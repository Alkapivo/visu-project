///@package io.alkapivo.visu

///@enum
function _GameMode(): Enum() constructor {
  RACING = "racing"
  BULLETHELL = "bulletHell"
  PLATFORMER = "platformer"
}
global.__GameMode = new _GameMode()
#macro GameMode global.__GameMode


#macro BeanVisuController "visuController"
///@param {String} layerName
function VisuController(layerName) constructor {
  
  ///@todo MOVE
  ///@param {String} name
  factoryTimer = function(name) {
    return {
      a: 0.0,
      b: 0.0,
      name: name,
      value: 0.0,
      size: 0,
      start: function() {
        this.a = get_timer()
        if (this.size > 60) {
          this.size = 0
          this.value = 0
        }
        return this
      },
      finish: function() {
        this.b = get_timer()
        this.size = this.size + 1
        this.value = this.value + ((this.b - this.a) / 1000)
        return this
      },
      ///@return {Number} time in ms (there are 1000 miliseconds per second)
      getValue: function() {
        return this.value / this.size
      },
      getMessage: function() {
        return $"{this.name} avg: {string_format(this.getValue(), 1, 4)} ms"
      },
    }
  }

  ////@type {Gamemode}
  gameMode = GameMode.BULLETHELL

  ///@type {Boolean}
  renderUI = true

  ///@type {UIService}
  uiService = new UIService(this)

  ///@type {DisplayService}
  displayService = new DisplayService(this, { minWidth: 800, minHeight: 480 })

  ///@type {FSM}
  fsm = new FSM(this, {
    initialState: { name: "idle" },
    states: {
      "idle": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            if (Core.isType(data, Event)) {
              fsm.context.send(data)
            }
          },
        },
        transitions: { 
          "idle": null, 
          "load": null, 
          "play": null, 
          "pause": null, 
          "quit": null,
        },
      },
      "load": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            fsmState.state.set("autoplay", data.autoplay)
            fsm.context.loader.fsm.dispatcher.send(new Event("transition", {
              name: "parse-manifest",
              data: data.manifest,
            }))
            
            audio_stop_all()
            VideoUtil.runGC()
            Beans.get(BeanSoundService).free()
            Beans.get(BeanTextureService).free()
          },
        },
        update: function(fsm) {
          try {
            var loaderState = fsm.context.loader.fsm.getStateName()
            Assert.areEqual(loaderState != null && loaderState != "idle", true, $"Invalid loader state: {loaderState}")
            if (loaderState == "loaded") {
              fsm.dispatcher.send(new Event("transition", {
                name: this.state.get("autoplay") ? "play" : "pause",
              }))
            }
          } catch (exception) {
            var message = $"'load' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuController::FSM", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
            fsm.context.loader.fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: { 
          "idle": null, 
          "play": null, 
          "pause": null,
        },
      },
      "play": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var promises = new Map(String, Promise, {})

            if (Optional.is(fsm.context.videoService.video)) {
              promises.set("video", fsm.context.videoService
                .send(new Event("resume-video")))
            }

            fsmState.state.set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            if (this.state.get("promises-resolved") != "success") {
              var promises = this.state.get("promises")
              var filtered = promises.filter(fsm.context.loader.utils.filterPromise)
              if (filtered.size() != promises.size()) {
                return
              }

              if (!promises.contains("track")) {
                promises.set("track", fsm.context.trackService.send(new Event("resume-track")))
                return
              }

              this.state.set("promises-resolved", "success")
              return
            }

            //Assert.isType(fsm.context.playerService.player, Player)
            //Assert.areEqual(fsm.context.videoService.getVideo().getStatus(), VideoStatus.PLAYING)
            //Assert.areEqual(fsm.context.trackService.track.getStatus(), TrackStatus.PLAYING)
          } catch (exception) {
            var message = $"'play': {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuController::FSM", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: { 
          "idle": null, 
          "load": null, 
          "pause": null, 
          "rewind": null, 
          "quit": null,
        },
      },
      "pause": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var promises = new Map(String, Promise, {
              "track": fsm.context.trackService
                .send(new Event("pause-track")),
            })

            if (Optional.is(fsm.context.videoService.video)) {
              promises.set("video", fsm.context.videoService
                .send(new Event("pause-video")))
            }

            fsmState.state.set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            if (this.state.get("promises-resolved") != "success") {
              var promises = this.state.get("promises")
              var filtered = promises.filter(fsm.context.loader.utils.filterPromise)
              if (filtered.size() != promises.size()) {
                return
              }
              this.state.set("promises-resolved", "success")
            }

            //Assert.areEqual(fsm.context.videoService.video.getStatus(), VideoStatus.PAUSED)
            //Assert.areEqual(fsm.context.trackService.track.getStatus(), TrackStatus.PAUSED)
          } catch (exception) {
            var message = $"'pause' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuController", message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: { 
          "idle": null, 
          "load": null, 
          "play": null, 
          "rewind": null, 
          "quit": null,
        },
      },
      "rewind": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var promises = new Map(String, Promise, {
              "pause-track": fsm.context.trackService
                .send(new Event("pause-track")),
            })

            var trackDuration = fsm.context.trackService.duration
            var video = fsm.context.videoService.video
            if (Optional.is(video) && trackDuration > 0.0) {
              var videoData = JSON.clone(data)
              var videoDuration = video.getDuration()
              if (videoData.timestamp > videoDuration) {
                videoData.timestamp = videoData.timestamp mod videoDuration
              }
              
              promises.set("rewind-video", fsm.context.videoService
                .send(new Event("rewind-video", videoData)))
            }

            fsmState.state
              .set("resume", data.resume)
              .set("data", data)
              .set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            if (this.state.get("promises-resolved") != "success") {
              var promises = this.state.get("promises")
              ///@description gml bug answered by videoServiceAttempts "feature"
              try {
                var filtered = promises.filter(fsm.context.loader.utils.filterPromise)
                if (filtered.size() != promises.size()) {
                  return
                }
              } catch (exception) {
                var message = $"Rewind exception: {exception.message}"
                //Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
                Logger.warn("VisuController", message)
                if (!promises.contains("rewind-video")) {
                  return
                }

                promises.forEach(function(promise, name) {
                  if (name != "rewind-video" && promise.status == PromiseStatus.REJECTED) {
                    throw new Exception($"non-video promise failed: '{name}'")
                  }
                })

                var data = this.state.get("data")
                var videoServiceAttempts = Struct.get(data, "videoServiceAttempts")
                if (!Core.isType(videoServiceAttempts, Number) 
                  || videoServiceAttempts == 0) {
                  throw new Exception($"video promise failed. 'videoServiceAttempts' value: {videoServiceAttempts}")
                }
                data.videoServiceAttempts = videoServiceAttempts - 1
                Logger.debug("VisuController", $"videoServiceAttempts value: {data.videoServiceAttempts}")
                promises.set("rewind-video", fsm.context.videoService.send(new Event("rewind-video", data)))
                return
              }

              if (!promises.contains("rewind-track")) {
                promises.set("rewind-track", fsm.context.trackService.send(new Event(
                  "rewind-track", this.state.get("data"))))
                return
              }

              this.state.set("promises-resolved", "success")
              fsm.context.send(new Event(this.state.get("resume") ? "play" : "pause"))
              return
            }
          } catch (exception) {
            var message = $"'rewind' fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VisuController", message)
            fsm.dispatcher.send(new Event("transition", {
              name: this.state.get("resume") ? "play" : "pause",
            }))
          }
        },
        transitions: {
          "idle": null, 
          "play": null, 
          "pause": null, 
          "quit": null,
        },
      },
      "quit": {
        actions: {
          onStart: function(fsm, fsmState, data) { 
            fsm.context.free()
            game_end()
          }
        },
      },
    },
  })

  ///@type {VisuTrackLoader}
  loader = new VisuTrackLoader(this)

  ///@type {ShaderPipeline}
  shaderPipeline = new ShaderPipeline()

  ///@type {ShaderPipeline}
  shaderBackgroundPipeline = new ShaderPipeline(this.shaderPipeline)

  ///@type {ParticleService}
  particleService = new ParticleService(this, { layerName: layerName })

  ///@type {TrackService}
  trackService = new TrackService(this, {
    handlers: new Map(String, Callable)
      .merge(
        DEFAULT_TRACK_EVENT_HANDLERS,
        new Map(String, Callable, grid_track_event),
        new Map(String, Callable, shader_track_event),
        new Map(String, Callable, shroom_track_event),
        new Map(String, Callable, view_track_event)
      ),
    isTrackLoaded: function() {
      var stateName = this.context.fsm.getStateName()
      return (stateName == "play" || stateName == "pause") 
        && Core.isType(this.track, Track)
    },
  })

  ///@type {PlayerService}
  playerService = new PlayerService(this)

	///@type {ShroomService}
  shroomService = new ShroomService(this)

	///@type {BulletService}
  bulletService = new BulletService(this)

  ///@type {GridService}
  gridService = new GridService(this)

  ///@type {GridRenderer}
  gridRenderer = new GridRenderer(this)

  ///@type {VideoService}
  videoService = new VideoService()

  ///@type {LyricsService}
  lyricsService = new LyricsService(this)

  ///@type {LyricsRenderer}
  lyricsRenderer = new LyricsRenderer(this)

  ///@type {GridSystem}
  //gridSystem = new GridSystem(this) ///@ecs

  ///@type {Boolean}
  renderEnabled = true

  ///@type {Boolean}
  renderGUIEnabled = true

  ///@type {Struct}
  renderTimer = this.factoryTimer("Render")
  
  ///@type {Struct}
  renderGUITimer = this.factoryTimer("RenderGUI")

  ///@param {Boolean} value
  ///@return {TopDownController}
  setRenderEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@param {Boolean} value
  ///@return {TopDownController}
  setRenderGUIEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "change-gamemode": function(event) {
      this.gameMode = Assert.isEnum(event.data, GameMode)
    },
    "load": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { 
        name: "load", 
        data: event.data
      }))
    },
    "play": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "play" }))
    },
    "pause": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "pause" }))
    },
    "rewind": function(event) {
      var fsmEvent = new Event("transition", { 
        name: "rewind", 
        data: {
          resume: this.fsm.getStateName() == "play",
          timestamp: Assert.isType(event.data.timestamp, Number),
          videoServiceAttempts: Struct.getDefault(
            event.data, 
            "videoServiceAttempts", 
            Core.getProperty("core.video-service.attempts", 3)
          ),
        }
      })
      
      if (Core.isType(event.promise, Promise)) {
        fsmEvent.setPromise(event.promise)
        event.setPromise(null)
      }
      this.fsm.dispatcher.send(fsmEvent)
    },
    "quit": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "quit" }))
    },
    "spawn-popup": function(event) {
      var _editor = Beans.get(BeanVisuEditor)
      if (Core.isType(_editor, VisuEditor)) {
        _editor.popupQueue.send(new Event("push", event.data))
      }
    }
  }, {
    enableLogger: true,
    catchException: false,
  }))

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, {
    enableLogger: true,
    catchException: false,
  })

  ///@private
  ///@type {Array<Struct>}
  services = new Array(Struct, GMArray.map([
    "fsm",
    "loader",
    "displayService",
    "dispatcher",
    "executor",
    "particleService",
    "shaderPipeline",
    "shaderBackgroundPipeline",
    "trackService",
    "gridService",
    //"gridSystem", ///@ecs
    "lyricsService",
    "gridRenderer",
    "videoService",
  ], function(name, index, controller) {
    Logger.debug("VisuController", $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(controller, name), Struct),
    }
  }, this))

  ///@param {Event}
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@private
  ///@return {VisuController}
  init = function() {
    Core.debugOverlay(Assert.isType(Core.getProperty("visu.debug-overlay", false), Boolean))
    var fullscreen = Assert.isType(Visu.settings.getValue("visu.fullscreen", false), Boolean)
    this.displayService
      .resize(
        Assert.isType(Visu.settings.getValue("visu.window.width", 1280), Number),
        Assert.isType(Visu.settings.getValue("visu.window.height", 720), Number)
      )
      .setFullscreen(fullscreen)
      .setCursor(Cursor.DEFAULT)
    
    ///@todo DEMO
    var tree = new Tree({
      name: "root-node",
      value: 0,
      type: "Number",
      childrens: [
        {
          name: "children-1",
          value: 1,
          type: "Number"
        },
        {
          name: "children-2",
          value: 2,
          type: "Number",
          childrens: [
            {
              name: "children-2.1",
              value: 2.1,
              type: "Number"
            }
          ]
        }
      ]
    })
    tree.print()

    ///@todo DEMO
    var _player = {
      "map": {
        "name": "neon-pub",
        "x": 0,
        "y": 0
      },
      "level": 1,
      "exp": 0,
      "sp": 0,
      "credits": 100,
      "visu": {
        "life": {
          "value": 1,
          "max": 3
        },
        "bomb": {
          "value": 2,
          "max": 3
        },
        "slotA": "chip-bomb-01",
        "slotB": null,
        "slotC": null
      },
      "schematics": [ "chip-bomb-01" ],
      "items": [
        {
          "amount": 3,
          "item": "empty-chip"
        }
      ],
      "quests": [
        {
          "name": "first-quest",
          "status": "finished",
          "steps": [
            "find-item",
            "return-item",
            "finished"
          ],
          "step": "finished"
        }
      ],
      "vars": {
        "quest_first-quest_npc-talked": true,
        "map_neon-pub_secret-lever": true,
        "map_neon-pub_secret-item": true
      }
    }

    return this
  }

  ///@private
  ///@type {Timer}
  autosaveTimer = new Timer(Core.getProperty("visu.autosave.interval", 1)  * 60, { loop: Infinity })

  ///@private
  ///@type {Boolean}
  autosaveEnabled = Visu.settings.getValue("visu.autosave", false)

  ///@private
  ///@return {VisuController}
  autosaveHandler = function() {
    if (!this.autosaveEnabled || this.fsm.getStateName() != "pause") {
      return this
    }

    return this.autosaveTimer.update().finished ? this.autosave() : this
  }

  ///@private
  ///@return {VisuController}
  autosave = function() {
    try {
      var path = $"{global.__VisuTrack.path}manifest.visu"
      if (!FileUtil.fileExists(path)) {
        return
      }

      global.__VisuTrack.saveProject(path)

      this.send(new Event("spawn-popup", 
        { message: $"Project '{this.trackService.track.name}' auto saved successfully at: '{path}'" }))
    } catch (exception) {
      this.send(new Event("spawn-popup", { message: $"Cannot save the project: {exception.message}" }))
      Logger.error("VETitleBar", $"Cannot auto save the project: {exception.message}")
    }

    return this
  }

  ///@private
  ///@type {Sprite}
  spinner = Assert.isType(SpriteUtil
    .parse({ 
      name: "texture_spinner", 
      scaleX: 0.25, 
      scaleY: 0.25,
    }), Sprite)


  ///@private
  ///@type {Number}
  spinnerFactor = 0

  ///@private
  ///@param {Struct} service
  ///@param {Number} iterator
  ///@param {VisuController} controller
  updateService = function(service, iterator, controller) {
    try {
      service.struct.update()
    } catch (exception) {
      var message = $"'update-service-{service.name}' fatal error: {exception.message}"
      Logger.error("VisuController", message)
      Core.printStackTrace()
      controller.send(new Event("spawn-popup", { message: message }))
      fsm.dispatcher.send(new Event("transition", { name: "idle" }))
    }
  }
  
  ///@return {VisuController}
  update = function() {
    if (this.renderUI) {
      try {
        // reset UI timers after resize to avoid ghost effect
        if (this.displayService.state == "resized") {
          this.uiService.containers.forEach(function(container) {
            if (!Optional.is(container.updateTimer)) {
              return
            }

            container.surfaceTick.skip()
            container.updateTimer.time = container.updateTimer.duration
          })

          Visu.settings.setValue("visu.fullscreen", this.displayService.getFullscreen()).save()
          if (!this.displayService.getFullscreen()) {
            Visu.settings
              .setValue("visu.window.width", this.displayService.getWidth())
              .setValue("visu.window.height", this.displayService.getHeight())
              .save()
          }
        }
        this.uiService.update()
      } catch (exception) {
        var message = $"'update' set fatal error: {exception.message}"
        Logger.error("UIService", message)
        Core.printStackTrace()
        this.send(new Event("spawn-popup", { message: message }))
      }
    }

    this.services.forEach(this.updateService, this)
    this.autosaveHandler()

    return this
  }
 
  preview = {
    x: function() { return 0 },
    y: function() { return 0 },
    width: GuiWidth,
    height: GuiHeight,
  }

  ///@return {VisuController}
  render = function() {
    if (!this.renderEnabled) {
      return this
    }

    this.renderTimer.start()
    try {
      gpu_set_alphatestenable(true) ///@todo investigate
      var enable = this.renderUI
      var _editor = Beans.get(BeanVisuEditor)
      var preview = _editor == null ? this.preview : _editor.layout.nodes.preview
      this.gridRenderer.render({ 
        width: enable ? ceil(preview.width()) : GuiWidth(), 
        height: enable ? ceil(preview.height()) : GuiHeight(),
      })
      //this.gridSystem.render()
    } catch (exception) {
      var message = $"render throws exception: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
      GPU.reset.shader()
      GPU.reset.surface()
      GPU.reset.blendMode()
    }
    this.renderTimer.finish()
    
    return this
  }

  ///@return {VisuController}
  renderGUI = function() {
    if (!this.renderGUIEnabled) {
      return this
    }

    this.renderGUITimer.start()
    try {
      var enable = this.renderUI
      var _editor = Beans.get(BeanVisuEditor)
      var preview = _editor == null ? this.preview : _editor.layout.nodes.preview
      this.gridRenderer.renderGUI({ 
        width: enable ? ceil(preview.width()) : GuiWidth(), 
        height: enable ? ceil(preview.height()) : GuiHeight(), 
        x: enable ? ceil(preview.x()) : 0, 
        y: enable ? ceil(preview.y()) : 0,
      })
      this.lyricsRenderer.renderGUI()
      if (this.renderUI) {
        this.uiService.render()
        var loaderState = this.loader.fsm.getStateName()
        if (loaderState != "idle" && loaderState != "loaded") {
          var color = c_black
          this.spinnerFactor = lerp(this.spinnerFactor, 100.0, 0.1)
  
          GPU.render.rectangle(
            0, 0, 
            GuiWidth(), GuiHeight(), 
            false, 
            color, color, color, color, 
            (this.spinnerFactor / 100) * 0.5
          )
  
          this.spinner
            .setAlpha(this.spinnerFactor / 100.0)
            .render(
              (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
              (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
                - (this.spinnerFactor / 2)
          )
        } else if (this.spinnerFactor > 0) {
          var color = c_black
          this.spinnerFactor = lerp(this.spinnerFactor, 0.0, 0.1)
  
          GPU.render.rectangle(
            0, 0, 
            GuiWidth(), GuiHeight(), 
            false, 
            color, color, color, color, 
            (this.spinnerFactor / 100) * 0.5
          )
  
          this.spinner
            .setAlpha(this.spinnerFactor / 100.0)
            .render(
            (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
            (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
              - (this.spinnerFactor / 2)
          )
        }
      }
      
      //MouseUtil.renderSprite()
      //Beans.get(BeanVisuEditor).render()
    } catch (exception) {
      var message = $"renderGUI throws exception: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
      GPU.reset.shader()
      GPU.reset.surface()
      GPU.reset.blendMode()
    }
    this.renderGUITimer.finish()

    if (is_debug_overlay_open()) {
      var controller = this
      var gridService = controller.gridService
      var shrooms = controller.shroomService.shrooms.size()
      var bullets = controller.bulletService.bullets.size()
  
      var timeSum = gridService.moveGridItemsTimer.getValue()
        + gridService.signalGridItemsCollisionTimer.getValue()
        + gridService.updatePlayerServiceTimer.getValue()
        + gridService.updateShroomServiceTimer.getValue()
        + gridService.updateBulletServiceTimer.getValue()
        + controller.renderTimer.getValue()
        + controller.renderGUITimer.getValue()
  
      var text = $"shrooms: {shrooms}" + "\n"
        + $"bullets: {bullets}" + "\n"
        + $"fps: {fps}, fps-real: {fps_real}" + "\n\n"
        + gridService.moveGridItemsTimer.getMessage() + "\n"
        + gridService.signalGridItemsCollisionTimer.getMessage() + "\n"
        + gridService.updatePlayerServiceTimer.getMessage() + "\n"
        + gridService.updateShroomServiceTimer.getMessage() + "\n"
        + gridService.updateBulletServiceTimer.getMessage() + "\n"
        + controller.renderTimer.getMessage() + "\n"
        + controller.renderGUITimer.getMessage() + "\n"
        + $"Sum: {timeSum}" + "\n"
      GPU.render.text(32, 32, text, c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD)  
    }

    var gridCamera = this.gridRenderer.camera
    var gridCameraMessage = ""
    if (gridCamera.enableMouseLook) {
      gridCameraMessage = gridCameraMessage 
        + $"pitch: {gridCamera.pitch}\n"
        + $"angle: {gridCamera.angle}\n"
        + $"zoom: {gridCamera.zoom}\n"
    }

    if (gridCamera.enableKeyboardLook) {
      gridCameraMessage = gridCameraMessage 
        + $"x: {gridCamera.x}\n"
        + $"y: {gridCamera.y}\n"
        + $"z: {gridCamera.z}\n"
    }
    
    if (gridCameraMessage != "") {
      GPU.render.text(32, GuiHeight() - 32, gridCameraMessage, c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD, HAlign.LEFT, VAlign.BOTTOM)  
    }
    return this
  }

  ///@return {VisuController}
  onSceneEnter = function() {
    Logger.info("VisuController", "onSceneEnter")
    VideoUtil.runGC()
    if (Core.getProperty("visu.manifest.load-on-start", false)) {
      this.send(new Event("load", {
        manifest: FileUtil.get(Core.getProperty("visu.manifest.path")),
        autoplay: Assert.isType(Core.getProperty("visu.manifest.play-on-start", false), Boolean),
      }))
    }
    
    return this
  }

  ///@return {VisuController}
  onSceneLeave = function() {
    Logger.info("VisuController", "onSceneLeave")
    VideoUtil.runGC()
    return this
  }

  ///@return {VisuController}
  onNetworkEvent = function() {
    try {
      var json = json_encode(async_load)
      var event = JSON.parse(json)
      var message = buffer_read(event.buffer, buffer_string)
      Core.print("[onNetworkEvent] event:", event)
      Core.print("[onNetworkEvent] message:", message)
    } catch (exception) {
      var message = $"'onNetworkEvent' fatal error: {exception.message}"
      this.send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)	
    }

    return this
  }

  ///@return {VisuController}
  free = function() {
    Struct.toMap(this)
      .filter(function(value) {
        if (!Core.isType(value, Struct)
          || !Struct.contains(value, "free")
          || !Core.isType(Struct.get(value, "free"), Callable)) {
          return false
        }
        return true
      })
      .forEach(function(struct, key, context) {
        try {
          Logger.debug("VisuController", $"Free '{key}'")
          Callable.run(Struct.get(struct, "free"))
        } catch (exception) {
          Logger.error("VisuController", $"Unable to free '{key}'. {exception.message}")
        }
      }, this)
    
    return this
  }

  this.init()
}
