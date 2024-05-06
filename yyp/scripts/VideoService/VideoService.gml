///@package com.alkapivo.core.component.video.VideoService

///@param {Controller} _controller
///@param {Struct} [config]
function VideoService(_controller, config = {}): Service() constructor {

  ///@deprecated
  ///@type {Struct}
  controller = Assert.isType(_controller, Struct)

  ///@private
  ///@type {?Video}
  video = null

  ///@private
  ///@param {Task} task
  rejectExistingTask = function(task) {
    task.reject()
  }

  ///@private
  ///@type {Number}
  cooldown = Assert.isType(Core.getProperty("core.video-service.cooldown", 0.25), Number)

  ///@private
  ///@type {Number}
  timeout = Assert.isType(Core.getProperty("core.video-service.timeout", 3), Number)

  ///@private
  ///@return {Callable}
  factoryTaskUpdate = function() {
    return function(executor) {
      var handler = Struct.get(this.state.get("stages"), this.state.get("stage"))
      handler(this, executor)

      var status = this.state.get("video").getStatus()
      if (status == VideoStatus.CLOSED) {
        VideoUtil.runGC()
        throw new VideoOpenException($"Invalid video status: {status}")
      }
    }
  }

  ///@private
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open-video": function(event) {
      if (this.executor.tasks.size() > 0) {
        event.promise.reject("There are unfinished tasks in videoService")
        return
      }

      var video = new Video(event.data.video)
      var service = this
      var task = new Task("open-video")
        .setPromise(event.promise // pass promise to TaskExecutor
          .whenSuccess(function(data) {
            data.context.setVideo(data.video.setVolume(data.video.volume))
            Logger.info("VideoService", $"Video loaded successfully: {data.video.path}")
            return data.video
          })
          .whenFailure(function(data) {
            Logger.error("VideoService", $"Failed to load video: {data}")
            VideoUtil.runGC()
            return null
          }))
        .setState(new Map(String, any, {
          video: video,
          service: service,
          stage: "open",
          stages: {
            open: function(task) {
              task.state.get("video").open()
              task.state.set("stage", "wait")
            },
            wait: function(task) {
              var video = task.state.get("video")
              var status = video.getStatus()
              if (status != VideoStatus.PLAYING && status != VideoStatus.PAUSED) {
                return
              }

              video.pause().setVolume(0)
              if (video.getStatus() != VideoStatus.PAUSED) {
                return
              }

              var service = task.state.get("service")
              if (Core.isType(video.timestamp, Number) && video.timestamp > 0.0) {
                service.send(new Event("rewind-video")
                  .setData({ timestamp: video.timestamp })
                  .setPromise(task.promise))
                task.promise.onSuccess({ context: service, video: video })
                task.setPromise() // disable promise, the promise will be resolved within TaskExecutor
              }
              task.fullfill({ context: service, video: video })
            }
          }
        }))
        .setTimeout(2.0)
        .whenUpdate(this.factoryTaskUpdate())
      
      this.executor.add(task)
      this.setVideo(null)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "rewind-video": function(event) {
      if (this.executor.tasks.size() > 0) {
        event.promise.reject("There are unfinished tasks in videoService")
        return
      }

      var video = Assert.isType(this.getVideo(), Video)
      var task = new Task("rewind-video")
        .setPromise(event.promise // pass promise to TaskExecutor
          .whenSuccess(function(data) {
            data.video.setVolume(data.video.volume)
            Logger.info("VideoService", $"Video rewind successfully: {data.video.path}")
            return data.video
          }))
        .setState(new Map(String, any, {
          stage: "prepare",
          video: video,
          before: 0,
          timer: new Timer(this.cooldown),
          stages: {
            prepare: function(task) {
              if (!task.state.get("timer").update().finished) {
                return 
              }

              var video = task.state.get("video")
              var status = video.getStatus()
              if (status != VideoStatus.PLAYING && status != VideoStatus.PAUSED) {
                return
              }

              video.pause().setVolume(0.0)
              if (video.getStatus() != VideoStatus.PAUSED) {
                return
              }

              task.state.set("before", video.getPosition()).set("stage", "seek")
              task.state.get("timer").reset()
            },
            seek: function(task) {
              if (task.state.get("timer").update().finished) {
                var video = task.state.get("video")
                video.seek(video.timestamp)
                task.state.set("stage", "wait")
              }
            },
            wait: function(task, executor) {
              var video = task.state.get("video")
              var before = task.state.get("before")
              var position = video.getPosition()
              var result = video.timestamp - before >= 0
                ? position >= video.timestamp
                : position <= video.timestamp
              if (result) {
                task.state.set("stage", "quit").get("timer").reset()
              }
            },
            quit: function(task, executor) {
              if (task.state.get("timer").update().finished) {
                var video = task.state.get("video")
                task.fullfill({ context: executor.context, video: video })
              }
            }
          }
        }))
        .setTimeout(2.0)
        .whenUpdate(this.factoryTaskUpdate())
      
      //this.executor.tasks.forEach(this.rejectExistingTask)
      this.executor.add(task)
      video.setTimestamp(event.data.timestamp)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "resume-video": function(event) {
      if (this.executor.tasks.size() > 0) {
        event.promise.reject("There are unfinished tasks in videoService")
        return
      }

      var task = new Task("resume-video")
        .setState(new Map(String, any, {
          timer: new Timer(this.cooldown),
        }))
        .setTimeout(this.timeout)
        .setPromise(event.promise) // pass promise to TaskExecutor
        .whenUpdate(function(executor) {
          var video = executor.context.getVideo()
          var timer = this.state.get("timer").update()
          var status = video.getStatus()
          switch (status) {
            case VideoStatus.CLOSED:
              this.reject($"'{this.name}' Invalid video status: {status}")
              break
            case VideoStatus.PLAYING:
            if (!timer.finished) {
                return
              }
              this.fullfill("success")
              break
            case VideoStatus.PAUSED:
              if (!timer.finished) {
                return
              }
              video.resume()
              timer.reset()
              break
          }
        })
      
      //this.executor.tasks.forEach(this.rejectExistingTask)
      this.executor.add(task)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "pause-video": function(event) {
      if (this.executor.tasks.size() > 0) {
        event.promise.reject("There are unfinished tasks in videoService")
        return
      }

      var task = new Task("pause-video")
        .setState(new Map(String, any, {
          timer: new Timer(0.05),
        }))
        .setTimeout(2.0)
        .setPromise(event.promise) // pass promise to TaskExecutor
        .whenUpdate(function(executor) {
          var video = executor.context.getVideo()
          var status = video.getStatus()
          var timer = this.state.get("timer").update()
          switch (status) {
            case VideoStatus.CLOSED:
              this.reject($"'{this.name}' Invalid video status: {status}")
              break
            case VideoStatus.PLAYING:
              if (!timer.finished) {
                return
              }
              video.pause()
              timer.reset()
              break
            case VideoStatus.PAUSED:
              if (!timer.finished) {
                return
              }
              this.fullfill("success")
              break
          }
        })
      
      //this.executor.tasks.forEach(this.rejectExistingTask)
      this.executor.add(task)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "close-video": function(event) {
      VideoUtil.runGC()
      this.setVideo(null)
    },
  }), { enableLogger: true })

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, { enableLogger: true })

  ///@return {?Video}
  getVideo = function() {
    return !Core.isType(this.video, Video) ? null : this.video
  }

  ///@param {?Video}
  ///@return {VideoService}
  setVideo = function(video = null) {
    this.video = video != null ? Assert.isType(video, Video) : video
    return this
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    if (!Core.isType(event.promise, Promise)) {
      event.promise = new Promise()
    }
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {VideoService}
  update = function() {
    this.dispatcher.update()
    this.executor.update()
    return this
  }

  ///@override
  free = function() {
    VideoUtil.runGC()
  }
}