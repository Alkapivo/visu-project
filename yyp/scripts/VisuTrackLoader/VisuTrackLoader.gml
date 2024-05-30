///@package io.alkapivo.visu

global.__VisuTrack = null
///@param {VisuController} _controller
function VisuTrackLoader(_controller): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)
  
  ///@todo extract to generic 
  ///@type {Struct}
  utils = {
    addTask: function(task, executor) {
      executor.add(task)
      return Assert.isType(task.promise, Promise)
    },
    filterPromise: function(promise, name) {
      if (!promise.isReady()) {
        return false
      }

      if (promise.status != PromiseStatus.FULLFILLED) { 
        throw new Exception($"Found rejected promise: {name}")
      }
      return true
    },
    mapPromiseToTask: function(promise) {
      return Assert.isType(promise.response, Task)
    }
  }

  ///@type {FSM}
  fsm = new FSM(this, {
    initialState: { name: "idle" },
    states: {
      "idle": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            fsm.context.controller.editor.send(new Event("open"))
            if (Core.isType(data, String)) {
              Logger.info("VisuTrackLoader", $"message: '{data}'")
            }
          },
        },
        transitions: GMArray.toStruct([ "idle", "parse-manifest" ]),
      },
      "parse-manifest": {
        actions: {
          onStart: function(fsm, fsmState, path) {
            window_set_caption($"{game_display_name}")
            audio_master_gain(0.0)

            var controller = fsm.context.controller
            controller.gridRenderer.clear()
            controller.editor.popupQueue.dispatcher.execute(new Event("clear"))
            controller.editor.dispatcher.execute(new Event("close"))
            controller.trackService.dispatcher.execute(new Event("close-track"))
            controller.videoService.dispatcher.execute(new Event("close-video"))
            controller.gridService.dispatcher.execute(new Event("clear-grid"))
            controller.playerService.dispatcher.execute(new Event("clear-player"))
            controller.shroomService.dispatcher.execute(new Event("clear-shrooms"))
            controller.bulletService.dispatcher.execute(new Event("clear-bullets"))
            controller.lyricsService.dispatcher.execute(new Event("clear-lyrics"))
            controller.particleService.dispatcher.execute(new Event("clear-particles"))
            Beans.get(BeanTextureService).dispatcher.execute(new Event("free"))

            fsmState.state.set("promise", fsm.context.controller.fileService.send(
              new Event("fetch-file")
                .setData({ path: path })
                .setPromise(new Promise()
                  .whenSuccess(function(result) {
                    var callback = this.setResponse
                    JSON.parserTask(result.data, { 
                      callback: function(prototype, json, key, acc) {
                        acc.callback(new prototype(acc.path, json))
                      }, 
                      acc: {
                        callback: callback,
                        path: result.path,
                      },
                    }).update()
                    
                    var item = Beans.get(BeanVisuController).editor.store.get("bpm")
                    item.set(this.response.bpm)

                    item = Beans.get(BeanVisuController).editor.store.get("bpm-sub")
                    item.set(this.response.bpmSub)

                    return {
                      path: Assert.isType(FileUtil.getDirectoryFromPath(result.path), String),
                      manifest: Assert.isType(this.response, VisuTrack),
                    }
                  })
                )
            ))
          },
        },
        update: function(fsm) {
          try {
            var promise = this.state.get("promise")
            if (!promise.isReady()) {
              return
            }
            
            fsm.dispatcher.send(new Event("transition", {
              name: "create-parser-tasks",
              data: {
                path: Assert.isType(promise.response.path, String),
                manifest: Assert.isType(promise.response.manifest, VisuTrack),
              },
            }))
          } catch (exception) {
            var message = $"'parse-manifest' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuTrackLoader", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "create-parser-tasks" ]),
      },
      "create-parser-tasks": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var controller = fsm.context.controller
            global.__VisuTrack = data.manifest
            var promises = new Map(String, Promise, {
              "texture": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.texture}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, iterator, acc) {
                        Logger.debug("VisuTrackLoader", $"Load texture '{json.name}'")
                        acc.promises.forEach(function(promise, key) {
                          if (promise.status == PromiseStatus.REJECTED) {
                            throw new Exception($"Found rejected load-texture promise for key '{key}'")
                          }
                        })

                        var textureIntent = Assert.isType(new prototype(json), TextureIntent)
                        textureIntent.file = FileUtil.get($"{acc.path}{textureIntent.file}")
                        var promise = new Promise()
                        acc.service.send(new Event("load-texture")
                          .setData(textureIntent)
                          .setPromise(promise))
                        acc.promises.add(promise, textureIntent.name)
                      },
                      acc: {
                        service: Beans.get(BeanTextureService),
                        promises: new Map(String, Promise),
                        path: global.__VisuTrack.path,
                      },
                      steps: 2,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "sound": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.sound}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load sound intent '{key}'")
                        var soundIntent = new prototype(json)
                        var soundService = acc.soundService
                        if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
                          soundService.sounds.add(sound_visu_wasm, key)
                          return
                        }

                        var path = FileUtil.get($"{acc.path}{soundIntent.file}")
                        Assert.fileExists(path)
                        Assert.isFalse(soundService.sounds.contains(key), "GMSound already loaded")
                        soundService.sounds.add(audio_create_stream(path), key)
                        soundService.intents.add(soundIntent, key)
                      },
                      acc: {
                        soundService: Beans.get(BeanSoundService),
                        path: global.__VisuTrack.path,
                      },
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "shader": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.shader}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load shader template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.shaderPipeline.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "track": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.track}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        var name = Struct.get(json, "name")
                        Logger.debug("VisuTrackLoader", $"Load track '{name}'")
                        acc.openTrack(new prototype(json, { handlers: acc.handlers }))
                      },
                      acc: controller.trackService
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "bullet": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.bullet}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load bullet template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.bulletService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "lyrics": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.lyrics}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load lyrics template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.lyricsService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "shroom": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.shroom}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load shroom template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.shroomService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "particle": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.particle}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"Load particle template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.particleService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
            })

            if (Optional.is(Struct.get(data.manifest, "video"))) {
              promises.set("video", new Promise().fullfill(
                new Task("send-load-video")
                  .setPromise(new Promise())
                  .setState(new Map(any, any, {
                    service: controller.videoService,
                    event: new Event("open-video", {
                      video: {
                        name: $"{data.manifest.video}",
                        path: $"{data.path}{data.manifest.video}",
                        timestamp: 0.0,
                        volume: 0,
                        loop: true,
                      }
                    })
                  }))
                  .whenUpdate(function() {
                    var event = Assert.isType(this.state.get("event"), Event)
                    var service = Assert.isType(this.state.get("service"), VideoService)
                    var name = Struct.get(Struct.get(event.data, "video"), "name")
                    service.send(event.setPromise(Assert.isType(this.promise, Promise)))
                    Logger.debug("VisuTrackLoader", $"load video '{name}'")
                    this.setPromise()
                    this.fullfill()
                  })
              ))
            }
            
            data.manifest.editor.forEach(function(file, index, acc) { 
              var promise = acc.controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{acc.data.path}{file}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, index, acc) {
                        Logger.debug("VisuTrackLoader", $"Load brush '{json.name}'")
                        acc.saveTemplate(new prototype(json))
                      },
                      acc: {
                        saveTemplate: acc.controller.editor.brushService.saveTemplate,
                        file: file,
                      },
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              )
              acc.promises.add(promise, file)
            }, { controller: controller, data: data, promises: promises })
            
            fsmState.state.set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            fsm.dispatcher.send(new Event("transition", {
              name: "parse-primary-assets",
              data: filtered.map(fsm.context.utils.mapPromiseToTask, null, String, Task),
            }))
          } catch (exception) {
            var message = $"'create-parser-tasks' fatal error: {exception.message}",
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuTrackLoader", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-primary-assets" ]),
      },
      "parse-primary-assets": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            var addTask = fsm.context.utils.addTask
            var executor = fsm.context.controller.executor
            fsmState.state.set("tasks", tasks).set("promises", new Map(String, Promise, {
              "texture": addTask(tasks.get("texture"), executor),
              "sound": addTask(tasks.get("sound"), executor),
              "shader": addTask(tasks.get("shader"), executor),
            }))

            if (tasks.contains("video")) {
              fsmState.state
                .get("promises")
                .set("video", addTask(tasks.get("video"), executor))
            }
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            var texturePromises = this.state.get("tasks").get("texture").state.get("acc").promises
            var filteredTextures = texturePromises.filter(fsm.context.utils.filterPromise)
            if (filteredTextures.size() != texturePromises.size()) {
              return
            }

            fsm.dispatcher.send(new Event("transition", {
              name: "parse-secondary-assets",
              data: Assert.isType(this.state.get("tasks"), Map)
            }))
          } catch (exception) {
            var message = $"'parse-primary-assets' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuTrackLoader", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-secondary-assets" ]),
      },
      "parse-secondary-assets": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            var addTask = fsm.context.utils.addTask
            var executor = fsm.context.executor
            var promises = new Map(String, Promise, {
              "bullet": addTask(tasks.get("bullet"), executor),
              "lyrics": addTask(tasks.get("lyrics"), executor),
              "particle": addTask(tasks.get("particle"), executor),
              "shroom": addTask(tasks.get("shroom"), executor),
              "track": addTask(tasks.get("track"), executor),
            })

            tasks.forEach(function(task, key, acc) { 
              if (String.contains(key, ".json")) {
                acc.promises.add(acc.addTask(task, acc.executor), key)
              }
            }, { addTask: addTask, executor: executor, promises: promises })
            
            fsmState.state.set("tasks", tasks).set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            var audio = Assert.isType(fsm.context.controller.trackService.track.audio, Sound)
            var attempts = this.state.inject("attempts", GAME_FPS * 5) - DeltaTime.apply(1)
            Assert.isTrue(attempts >= 0.0)
            this.state.set("attempts", attempts)
            audio.rewind(0.0)
            if (audio.getPosition() != 0.0) {
              return
            }

            audio.pause()
            fsm.dispatcher.send(new Event("transition", { name: "loaded" }))
          } catch (exception) {
            var message = $"'parse-secondary-assets' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuTrackLoader", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "loaded" ]),
      },
      "loaded": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            window_set_caption($"{game_display_name} | {fsm.context.controller.trackService.track.name} | {global.__VisuTrack.path}")
            audio_master_gain(1.0)

            var controller = fsm.context.controller
            controller.editor.send(new Event("open"))
            controller.send(new Event("spawn-popup", 
              { message: $"Project '{controller.trackService.track.name}' loaded successfully" }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-manifest" ]),
      }
    }
  })

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, { catchException: false })

  ///@return {FSM}
  update = function() {
    try {
      this.fsm.update()
    } catch (exception) {
      var message = $"VisuTrackLoader FSM fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
    }

    try {
      this.executor.update()
    } catch (exception) {
      this.executor.tasks.clear()
      var message = $"VisuTrackLoader executor fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
      this.fsm.dispatcher.send(new Event("transition", { name: "idle" }))
    }
    return this
  }
}
