///@package io.alkapivo.visu

///@param {Struct} [config]
function TestKeypress(config = {}) constructor {

  ///@type {String}
  key = Assert.isType(Struct.get(config, "key"), String)

  ///@type {Boolean}
  enable = false

  ///@type {Array<Number>}
  durations = new Array(Number, Struct.get(config, "durations"))

  ///@type {Number}
  luck = clamp(Assert.isType(Struct.get(config, "luck"), Number), 0.0, 1.0)

  ///@type {Timer}
  timer = new Timer(this.durations.getRandom())

  ///@return {TestKeypress}
  update = function() {
    if (!this.timer.finished && this.timer.update().finished) {
      this.enable = this.luck >= random(1.0)
      this.timer.reset().setDuration(this.durations.getRandom())
    }

    return this
  }

  ///@param {Keyboard}
  ///@return {TestKeypress}
  updateKeyboard = function(keyboard) {
    var key = keyboard.getKey(this.key)
    if (!Optional.is(key)) {
      return this
    }

    if (this.enable) {
      if (key.pressed && key.on) {
        key.pressed = false
      }

      if (key.released) {
        key.released = false
      }

      if (!key.on) {
        key.on = true
        key.pressed = true
      }
    } else {
      if (key.pressed) {
        key.pressed = false
      } 

      if (key.released) {
        key.released = false
      }

      if (key.on) {
        key.on = false
        key.released = true
      }
    }

    return this
  }
}


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

          runner = Beans.get(BeanTestRunner)
          runner.exceptions.clear()
          Beans.get(BeanVisuController).send(new Event("load", {
            manifest: task.state.path,
            autoplay: false
          }))

          task.state.stage = "verify"
        },
        verify: function(task) {
          Assert.isTrue(Beans.get(BeanTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
          var controller = Beans.get(BeanVisuController)
          if (controller.loader.fsm.getStateName() == "loaded" 
            && controller.trackService.track.name == task.state.trackName) {
            task.state.stage = "pause" 
          }
        },
        pause: function(task) {
          var controller = Beans.get(BeanVisuController)
          if (controller.fsm.getStateName() == "paused") {
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
      Logger.test("VisuControllerTest", "TestEvent_VisuController_load started")
      Beans.get(BeanTestRunner).installHooks()
      Visu.settings.setValue("visu.god-mode", true)
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_load finished")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_load timeout")
      this.reject("failure")
      Beans.get(BeanTestRunner).uninstallHooks()
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
          Beans.get(BeanTestRunner).exceptions.clear()
          Beans.get(BeanVisuController).send(new Event("play"))
          task.state.stage = "playback"
        },
        playback: function(task) {
          Assert.isTrue(Beans.get(BeanTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
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

              var keypressMap = new Map(String, TestKeypress, {
                up: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.66,
                  key: "up"
                }),
                down: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.66,
                  key: "down"
                }),
                left: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.66,
                  key: "left"
                }),
                right: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.66,
                  key: "right"
                }),
                action: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.33,
                  key: "action"
                }),
                bomb: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.15,
                  key: "bomb"
                }),
                focus: new TestKeypress({
                  durations: [ 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.1, 1.25, 1.5, 1.7, 2.0 ],
                  luck: 0.50,
                  key: "focus"
                }),
              })
              Struct.set(player.keyboard, "keypressMap", keypressMap)
              player.keyboard.update = method(player.keyboard, function() {
                this.keypressMap.forEach(function(keypress, name, keyboard) {
                  keypress.update().updateKeyboard(keyboard)
                }, this)

                return this
              })
            }
          }
        },
        pause: function(task) {
          var controller = Beans.get(BeanVisuController)
          if (controller.fsm.getStateName() == "paused") {
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
      Logger.test("VisuControllerTest", "TestEvent_VisuController_playback started")
      Beans.get(BeanTestRunner).installHooks()
      Visu.settings.setValue("visu.god-mode", true)
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_playback finished")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_playback timeout")
      this.reject("failure")
      Beans.get(BeanTestRunner).uninstallHooks()
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

          var editor = Beans.get(BeanVisuEditorController)
          editor.renderUI = true
          editor.send(new Event("open"))
          if (!editor.store.getValue("_render-trackControl")) {
            editor.store.get("_render-trackControl").set(true)
          }
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
            task.state.target = random(trackService.duration * 0.7500)
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

            var editor = Beans.get(BeanVisuEditorController)
            editor.send(new Event("close"))
            if (editor.store.getValue("render-trackControl")) {
              editor.store.get("render-trackControl").set(false)
            }
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
      Beans.get(BeanTestRunner).installHooks()
      Visu.settings.setValue("visu.god-mode", true)
    })
    .whenFinish(function(data) {
      Logger.test("VisuControllerTest", $"TestEvent_VisuController_rewind finished")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("VisuControllerTest", "TestEvent_VisuController_rewind timeout")
      this.reject("failure")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
}