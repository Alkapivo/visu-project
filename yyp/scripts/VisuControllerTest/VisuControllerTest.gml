///@package io.alkapivo.visu

///@param {Struct} [json]
///@return {Task}
function TestEvent_VisuController_load(json = {}) {
  return new Task("TestEvent_VisuController_load")
    .setTimeout(Struct.getDefault(json, "timeout", 10.0))
    .setPromise(new Promise())
    .setState({
      path: Struct.getDefault(json, "path", "C:/Users/Alkapivo/projects/io.alkapivo/gm_modules/visu-track/resource/datafiles/track/Perturbator/Sentient/manifest.visu"),
      trackName: Struct.getDefault(json, "trackName", "Perturbator - Sentient"),
      cooldown: new Timer(Struct.getDefault(json, "cooldown", 2.0)),
      stage: "cooldownBefore",
      stages: {
        cooldownBefore: function(task) {
          if (task.state.cooldown.update().finished) {
            task.state.stage = "setup"
            task.state.cooldown.reset()
          }
        },
        setup: function(task) {
          if (Beans.get(BeanVisuController).fsm.getStateName() == "load") {
            return
          }

          runner = Beans.get(BeanVisuTestRunner)
          runner.exceptions.clear()
          Beans.get(BeanVisuController).send(new Event("load", {
            manifest: task.state.path,
            autoplay: false
          }))

          task.state.stage = "verify"
        },
        verify: function(task) {
          Assert.isTrue(Beans.get(BeanVisuTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
          var controller = Beans.get(BeanVisuController)
          if (controller.loader.fsm.getStateName() == "loaded" && controller.trackService.track.name == task.state.trackName) {
            task.state.stage = "pause" 
          }
        },
        pause: function(task) {
          var controller = Beans.get(BeanVisuController)
          if (controller.fsm.getStateName() == "pause") {
            task.state.stage = "cooldownAfter"
          }
        },
        cooldownAfter: function(task) {
          if (task.state.cooldown.update().finished) {
            task.fullfill("success")
          }
        }
      },
    })
    .whenUpdate(function(executor) {
      var stage = Struct.get(this.state.stages, this.state.stage)
      stage(this)
    })
    .whenStart(function(executor) {
      Logger.test("VisuControllerTest", "Start TestEvent_VisuController_load")
      Beans.get(BeanVisuTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_load: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_load: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
}


///@param {Struct} [json]
///@return {Task}
function TestEvent_VisuController_playback(json = {}) {
  return new Task("TestEvent_VisuController_playback")
    .setTimeout(Struct.getDefault(json, "timeout", 20.0))
    .setPromise(new Promise())
    .setState({
      duration: Struct.getDefault(json, "duration", 10.0),
      cooldown: new Timer(Struct.getDefault(json, "cooldown", 2.0)),
      stage: "cooldownBefore",
      videoLimit: new Timer(Struct.getDefault(json, "videoLimit", 2.0)),
      stages: {
        cooldownBefore: function(task) {
          if (task.state.cooldown.update().finished) {
            task.state.stage = "setup"
            task.state.cooldown.reset()
          }
        },
        setup: function(task) {
          Beans.get(BeanVisuTestRunner).exceptions.clear()
          Beans.get(BeanVisuController).send(new Event("play"))
          task.state.stage = "playback"
        },
        playback: function(task) {
          Assert.isTrue(Beans.get(BeanVisuTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
          var controller = Beans.get(BeanVisuController)
          if (controller.trackService.time > task.state.duration) {
            controller.send(new Event("pause"))
            task.state.stage = "pause" 
          }

          var track = controller.trackService.track
          var video = controller.videoService.video
          if (Optional.is(video) && track.getStatus() == TrackStatus.PLAYING) {
            if (video.getStatus() != VideoStatus.PLAYING) {
              task.state.videoLimit.update()
            }
            Assert.isFalse(task.state.videoLimit.finished, "Video must be played")
          }

          var player = controller.playerService.player
          if (Core.isType(player, Player)) {
            if (!Struct.getDefault(player, "keyboardHook", false)) {
              Struct.set(player, "keyboardHook", true)
              player.keyboard.update = method(player.keyboard, function() {
                Struct.forEach(this.keys, function(key) {
                  key.on = choose(true, false)
                  key.pressed = choose(true, false)
                  key.released = choose(true, false)
                })
                return this
              })
            }
          }
        },
        pause: function(task) {
          var controller = Beans.get(BeanVisuController)
          if (controller.fsm.getStateName() == "pause") {
            task.state.stage = "cooldownAfter"
          }
        },
        cooldownAfter: function(task) {
          if (task.state.cooldown.update().finished) {
            task.fullfill("success")
          }
        }
      },
    })
    .whenUpdate(function(executor) {
      var stage = Struct.get(this.state.stages, this.state.stage)
      stage(this)
    })
    .whenStart(function(executor) {
      Logger.test("VisuControllerTest", "Start TestEvent_VisuController_playback")
      Beans.get(BeanVisuTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_playback: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_playback: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
}


///@param {Struct} [json]
///@return {Task}
function TestEvent_VisuController_rewind(json = {}) {
  return new Task("TestEvent_VisuController_rewind")
    .setTimeout(Struct.getDefault(json, "timeout", 20.0))
    .setPromise(new Promise())
    .setState({
      amount: Struct.getDefault(json, "amount", 5),
      minDuration: Struct.getDefault(json, "maxDuration", 0.2),
      maxDuration: Struct.getDefault(json, "maxDuration", 3.0),
      target: 0,
      timer: new Timer(random_range(1, 2)),
      cooldown: new Timer(Struct.getDefault(json, "cooldown", 2.0)),
      stage: "cooldownBefore",
      count: 0,
      countTarget: Struct.getDefault(json, "amount", 5),
      stages: {
        cooldownBefore: function(task) {
          if (task.state.cooldown.update().finished) {
            task.state.stage = "rewind"
            task.state.cooldown.reset()
          }
        },
        setup: function(task) {
          controller.send(new Event("pause"))
          task.state.stage = "rewind"
        },
        rewind: function(task) {
          var controller = Beans.get(BeanVisuController)
          var trackService = controller.trackService
          if (task.state.timer.update().finished && task.state.amount > 0) {
            var delta = abs(trackService.time - task.state.target)
            if (delta < 2) {
              task.state.count++
            }
            Logger.test("TestEvent_VisuController_rewind", $"Current delta: {delta}, counter: {task.state.count}")
            task.state.timer.reset()
            task.state.timer.duration = random_range(task.state.minDuration, task.state.maxDuration)
            task.state.target = random(trackService.duration * 0.9)
            controller.send(new Event("rewind", { 
              timestamp: task.state.target,
            }))
            task.state.amount--
          }

          if (task.state.timer.finished && task.state.amount <= 0) {
            Logger.test("TestEvent_VisuController_rewind", $"{task.state.count} successfull rewind attempts, target is {task.state.countTarget * 0.75}")
            if (task.state.count >= task.state.countTarget * 0.75) {
              var video = controller.videoService.getVideo()
              if (Core.isType(video, Video)) {
                if (video.getStatus() != VideoStatus.CLOSED) {
                  task.state.stage = "cooldownAfter"
                } else {
                  task.reject()
                }
              } else {
                task.state.stage = "cooldownAfter"
              }
            } else {
              task.reject()
            }
          }
        },
        cooldownAfter: function(task) {
          if (task.state.cooldown.update().finished) {
            task.fullfill("success")
          }
        }
      },
    })
    .whenUpdate(function(executor) {
      var stage = Struct.get(this.state.stages, this.state.stage)
      stage(this)
    })
    .whenStart(function(executor) {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_rewind started")
      Beans.get(BeanVisuTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_rewind: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_rewind: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
}