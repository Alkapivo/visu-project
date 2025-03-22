///@package io.alkapivo.visu

///@param {Struct} json
function VisuSave(json) constructor {
  
  ///@type {String}
  name = Assert.isType(Struct.get(json, "name"), String)
}


#macro BeanVisuController "VisuController"
///@param {String} layerName
function VisuController(layerName) constructor {

  ///@type {GMLayer}
  layerId = Assert.isType(Scene.getLayer(layerName), GMLayer)

  ///@type {Gamemode}
  gameMode = GameMode.BULLETHELL

  ///@type {?VisuTrack}
  track = null
  
  ///@type {?Sound}
  ostSound = null

  ///@type {FSM}
  fsm = new FSM(this, {
    displayName: BeanVisuController,
    initialState: { name: "idle" },
    states: {
      "idle": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var controller = Beans.get(BeanVisuController)
            controller.visuRenderer.gridRenderer.camera.breathTimer1.reset()
            controller.visuRenderer.gridRenderer.camera.breathTimer2.reset()

            if (Optional.is(controller.ostSound)) {
              controller.ostSound.stop()
              controller.ostSound = null
            }

            if (Core.isType(data, Event)) {
              fsm.context.send(data)
            }

            fsmState.state.set("bkgTimer", new Timer(4.0 + random(12.0), { loop: Infinity }))
            fsmState.state.set("bkgColorTimer", new Timer(4.0 + random(12.0), { loop: Infinity }))
            fsmState.state.set("glitchTimer", new Timer(4.0 + random(12.0), { loop: Infinity }))
          },
          onFinish: function(fsm, fsmState, data) {
            var controller = Beans.get(BeanVisuController)
            controller.visuRenderer.gridRenderer.camera.breathTimer1.reset()
            controller.visuRenderer.gridRenderer.camera.breathTimer2.reset()

            if (Optional.is(controller.ostSound)) {
              controller.ostSound.stop()
              controller.ostSound = null
            }
          },
        },
        update: function(fsm) {
          var controller = Beans.get(BeanVisuController)
          var gridService = controller.gridService
          if (!Optional.is(controller.ostSound)) {
            var sound = SoundUtil.fetch("sound_nfract_amphetamine", { loop: true })
            controller.ostSound = Core.isType(sound, Sound)
              ? sound 
              : controller.ostSound
          } else {
            var ostVolume = Visu.settings.getValue("visu.audio.ost-volume")
            if (!controller.ostSound.isLoaded()) {
              controller.ostSound.play(0.0).rewind(random(60.0)).setVolume(ostVolume, 2.0)
            } else if (controller.ostSound.isPaused()) {
              controller.ostSound.resume().setVolume(ostVolume, 2.0)
            } else if (controller.ostSound.isPlaying()
                && ostVolume != controller.ostSound.getVolume()) {
              controller.ostSound.setVolume(ostVolume, 2.0)
            }
          }
  
          var bkgTimer = this.state.get("bkgTimer")
          if (bkgTimer.update().finished) {
            bkgTimer.setDuration(4.0 + random(12.0))
            gridService.init()
          }

          var bkgColorTimer = this.state.get("bkgColorTimer")
          if (bkgColorTimer.update().finished) {
            bkgColorTimer.setDuration(4.0 + random(12.0))
            var properties = gridService.properties
            var pump = controller.dispatcher
            var executor = controller.executor
            var color = ColorUtil.parse(GMArray.getRandom([
              "#000000",
              "#160e24",
              "#6e0d27",
              "#c21772",
              "#5d2985", 
              "#c4146c",
              "#1d6296",
              "#4550e6",
              "#d62ce6",
              "#1082c9",
              "#1c070a",
              "#160b24"
            ]))
            Visu.resolveColorTransformerTrackEvent(
              {
                use: true,
                col: color,
                spd: bkgColorTimer.duration * 0.9,
              }, 
              "use",
              "col",
              "spd",
              "gridClearColor",
              properties,
              pump,
              executor
            )
          }

          var glitchTimer = this.state.get("glitchTimer")
          if (glitchTimer.update().finished) {
            glitchTimer.setDuration(4.0 + random(12.0))
            controller.visuRenderer.hudRenderer.sendGlitchEvent()
            effect_track_event.brush_effect_glitch.run({
              "ef-glt_use-config": false,
              "ef-glt_use-fade-out": true,
              "ef-glt_fade-out": 0.02 + random(1.0) * 0.08,
            })
          }

          controller.visuRenderer.gridRenderer.camera.breathTimer1.update()
          controller.visuRenderer.gridRenderer.camera.breathTimer2.update()
        },
        transitions: { 
          "idle": null, 
          "game-over": null,
          "load": null, 
          "play": null, 
          "pause": null, 
          "paused": null,
          "quit": null,
        },
      },
      "game-over": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            fsm.context.menu.send(fsm.context.menu
              .factoryOpenMainMenuEvent({ 
                titleLabel: "Game over"
              }))
          },
        },
        update: function(fsm) {
          if (fsm.context.menu.containers.size() == 0) {
            fsm.context.menu.send(fsm.context.menu
              .factoryOpenMainMenuEvent({ 
                titleLabel: "Game over"
              }))
          }
        },
        transitions: { 
          "idle": null, 
          "game-over": null,
          "load": null, 
          "play": null, 
          "pause": null, 
          "paused": null,
          "quit": null,
        },
      },
      "load": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var controller = Beans.get(BeanVisuController)
            controller.menu.send(new Event("close"))
            controller.loader.fsm.dispatcher.send(new Event("transition", {
              name: "parse-manifest",
              data: data.manifest,
            }))
            fsmState.state.set("autoplay", Struct.getDefault(data, "autoplay", false))
            
            if (Optional.is(controller.ostSound)) {
              controller.ostSound.stop()
              controller.ostSound = null
            }

            audio_stop_all()
            controller.visuRenderer.gridRenderer.clear()
            Beans.get(BeanSoundService).free()
            Beans.get(BeanTextureService).free()
            
            controller.trackService.dispatcher.execute(new Event("close-track"))
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
            var message = $"'fsm::update' (state: 'load') fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error(BeanVisuController, message)
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
            var controller = Beans.get(BeanVisuController)
            controller.visuRenderer.gridRenderer.camera.breathTimer1.reset()
            controller.visuRenderer.gridRenderer.camera.breathTimer2.reset()
            controller.menu.send(new Event("close", { fade: true }))

            var promises = new Map(String, Promise, {})
            fsmState.state.set("promises", promises)

            var videoService = controller.videoService
            if (Optional.is(videoService.video)) {
              promises.set("video", videoService.send(new Event("resume-video")))
            }

            ///@hack
            var trackService = controller.trackService
            if (trackService.isTrackLoaded() && !trackService.track.audio.isLoaded()) {
              trackService.time = 0.0
            }
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
            var message = $"'fsm::update' (state: 'play') fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error(BeanVisuController, message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: { 
          "idle": null, 
          "game-over": null,
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
            fsmState.state.set("menuEvent", data)
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

            fsm.dispatcher.send(new Event("transition", { 
              name: "paused", 
              data: this.state.get("menuEvent"),
            }))
            //Assert.areEqual(fsm.context.videoService.video.getStatus(), VideoStatus.PAUSED)
            //Assert.areEqual(fsm.context.trackService.track.getStatus(), TrackStatus.PAUSED)
          } catch (exception) {
            var message = $"'fsm::update' (state: 'pause') fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error(BeanVisuController, message)
            fsm.dispatcher.send(new Event("transition", { name: "idle" }))
          }
        },
        transitions: { 
          "idle": null, 
          "load": null, 
          "play": null, 
          "paused": null,
          "rewind": null, 
          "quit": null,
        },
      },
      "paused": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            if (Core.isType(data, Event)) {
              Beans.get(BeanVisuController).menu.send(data)
            }
          },
          onFinish: function(fsm, fsmState, data) {
            Beans.get(BeanVisuController).menu.send(new Event("close", { fade: true }))
          },
        },
        update: function(fsm) { },
        transitions: {
          "idle": null, 
          "load": null,
          "play": null, 
          "pause": null, 
          "rewind": null, 
          "quit": null,
        }
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
            var message = $"'fsm::update' (state: 'rewind') fatal error: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error(BeanVisuController, message)
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

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, {
    enableLogger: true,
    catchException: false,
  })

  ///@type {ShaderPipeline}
  shaderPipeline = new ShaderPipeline({
    getLimit: function() {
      return Visu.settings.getValue("visu.graphics.shaders-limit")
    },
    getTemplate: function(name) {
      var template = this.templates.get(name)
      return template == null
        ? Visu.assets().shaderTemplates.get(name)
        : template
    },
  })

  ///@param {String} name
  ///@return {Boolean}
  shaderTemplateExists = function(name) {
    return this.shaderPipeline.templates.contains(name)
        || Visu.assets().shaderTemplates.contains(name)  
  }

  ///@param {String} name
  ///@return {Boolean}
  particleTemplateExists = function(name) {
    return this.particleService.templates.contains(name) 
        || Visu.assets().particleTemplates.contains(name)  
  }

  ///@param {String} name
  ///@return {Boolean}
  shroomTemplateExists = function(name) {
    return this.shroomService.templates.contains(name) 
        || Visu.assets().shroomTemplates.contains(name)
  }

  ///@param {String} name
  ///@return {Boolean}
  coinTemplateExists = function(name) {
    return this.coinService.templates.contains(name) 
        || Visu.assets().coinTemplates.contains(name)
  }   

  ///@param {String} name
  ///@return {Boolean}
  subtitleTemplateExists = function(name) {
    return this.subtitleService.templates.contains(name) 
        || Visu.assets().subtitleTemplates.contains(name)
  }   

  ///@type {ShaderPipeline}
  shaderBackgroundPipeline = new ShaderPipeline({
    templates: this.shaderPipeline.templates,
    getLimit: function() {
      return Beans.get(BeanVisuController).shaderPipeline.getLimit()
    },
    getTemplate: function(name) {
      return Beans.get(BeanVisuController).shaderPipeline.getTemplate(name)
    },
  })

  ///@type {ShaderPipeline}
  shaderCombinedPipeline = new ShaderPipeline({
    templates: this.shaderPipeline.templates,
    getLimit: function() {
      return Beans.get(BeanVisuController).shaderPipeline.getLimit()
    },
    getTemplate: function(name) {
      return Beans.get(BeanVisuController).shaderPipeline.getTemplate(name)
    },
  })

  ///@type {UIService}
  uiService = new UIService(this)

  ///@type {DisplayService}
  displayService = new DisplayService(this, { 
    minWidth: 800, 
    minHeight: 480,
    scale: Visu.settings.getValue("visu.interface.scale"),
  })

  ///@type {ParticleService}
  particleService = new ParticleService({ 
    layerName: layerName,
    getStaticTemplates: function() {
      return Visu.assets().particleTemplates
    },
  })

  ///@type {TrackService}
  trackService = new TrackService(this, {
    handlers: new Map(String, Struct)
      .merge(
        DEFAULT_TRACK_EVENT_HANDLERS,
        new Map(String, Struct, effect_track_event),
        new Map(String, Struct, entity_track_event),
        new Map(String, Struct, grid_track_event),
        new Map(String, Struct, view_track_event)
      )
      .forEach(function(handler) {
        Struct.set(handler, "parse", Struct.getIfType(handler, "parse", Callable, Lambda.passthrough))
        Struct.set(handler, "serialize", Struct.getIfType(handler, "serialize", Callable, Struct.serialize))
        Struct.set(handler, "run", Struct.getIfType(handler, "run", Callable, Lambda.dummy))
      }),
    isTrackLoaded: function() {
      var stateName = this.context.fsm.getStateName()
      return Core.isType(this.track, Track) 
          && (stateName == "play" 
          || stateName == "pause" 
          || stateName == "paused") 
    },
  })

  ///@type {PlayerService}
  playerService = new PlayerService(this)

	///@type {ShroomService}
  shroomService = new ShroomService(this)

	///@type {BulletService}
  bulletService = new BulletService(this)

  ///@type {CoinService}
  coinService = new CoinService()

  ///@type {GridService}
  gridService = new GridService(this)

  ///@type {VideoService}
  videoService = new VideoService()

  ///@type {SFXService}
  sfxService = new SFXService()

  ///@type {SubtitleService}
  subtitleService = new SubtitleService(this)

  ///@type {VEBrushService}
  brushService = new VEBrushService()

  ///@type {VisuRenderer}
  visuRenderer = new VisuRenderer(this)

  ///@type {GridECS}
  //gridECS = new GridECS(this) ///@description ecs
  
  ///@type {Server}
  server = new Server({
    type: SocketType.WS,
    port: int64(Core.getProperty("visu.server.port", "8082")),
    maxClients: Core.getProperty("visu.server.maxClients", 2),
  })

  ///@type {VisuMenu}
  menu = new VisuMenu()

  ///@private
  ///@type {Boolean}
  renderEnabled = true

  ///@private
  ///@type {Boolean}
  renderGUIEnabled = true

  ///@private
  ///@type {?Promise}
  watchdogPromise = null

  ///@private
  ///@return {VisuController}
  watchdog = function() {
    try {
      if (this.trackService.isTrackLoaded()) {
        var ost = this.trackService.track.audio
        var ostVolume = Visu.settings.getValue("visu.audio.ost-volume")
        if (ost.isPlaying() && ost.getVolume() != ostVolume) {
          ost.setVolume(ostVolume)
        }
      }

      var sfxVolume = Visu.settings.getValue("visu.audio.sfx-volume")
      if (this.sfxService.getVolume() != sfxVolume) {
        this.sfxService.setVolume(sfxVolume)
      }

      if (Optional.is(this.watchdogPromise)) {
        this.watchdogPromise = this.watchdogPromise.status == PromiseStatus.PENDING
          ? this.watchdogPromise
          : null
        return this
      }

      if (!Optional.is(this.watchdogPromise)
        && this.trackService.isTrackLoaded()
        && !this.trackService.track.audio.isLoaded() 
        && 1 > abs(this.trackService.time - this.trackService.duration)
        && this.fsm.getStateName() == "play") {
        
        Logger.info("VisuController", $"Track finished at {this.trackService.time}")
        this.watchdogPromise = this.send(new Event("pause").setPromise(new Promise()))
        this.menu.send(this.menu.factoryOpenMainMenuEvent({ disableResume: true }))
      }

      if (this.fsm.getStateName() != "idle" && Optional.is(this.ostSound)) {
        this.ostSound.stop()
        this.ostSound = null
      }
    } catch (exception) {
      var message = $"'watchdog' fatal error: {exception.message}"
      this.send(new Event("spawn-popup", { message: message }))
      Logger.error(BeanVisuController, message)
    }

    return this
  }

  ///@param {Boolean} value
  ///@return {VisuController}
  setRenderEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@param {Boolean} value
  ///@return {VisuController}
  setRenderGUIEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "change-gamemode": function(event) {
      this.gameMode = Assert.isEnum(event.data, GameMode)
    },
    "game-over": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "game-over" }))
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
      this.fsm.dispatcher.send(new Event("transition", Struct
        .appendUnique({ name: "pause" }, event.data)))
    },
    "rewind": function(event) {
      var fsmEvent = new Event("transition", { 
        name: "rewind", 
        data: {
          resume: Core.isType(Struct.get(event.data, "resume"), Boolean) 
            ? event.data.resume : this.fsm.getStateName() == "play",
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
      this.fsm.dispatcher.execute(fsmEvent)
    },
    "quit": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "quit" }))
    },
    "spawn-popup": function(event) {
      var _editor = Beans.get(BeanVisuEditorController)
      if (Core.isType(_editor, VisuEditorController)) {
        _editor.popupQueue.send(new Event("push", event.data))
      }
    },
    "spawn-track-event": function(event) {
      var callable = Assert.isType(this.trackService.handlers
        .get(event.data.callable), Callable)
      callable(event.data.data)
    },
    "transform-property": Callable.run(Struct.get(EVENT_DISPATCHERS, "transform-property")),
    "fade-sprite": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-sprite")),
    "fade-color": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-color")),
  }), {
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
    "videoService",
    "sfxService",
    "menu"
  ], function(name, index, controller) {
    Logger.debug(BeanVisuController, $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(controller, name), Struct),
    }
  }, this))

  ///@private
  ///@type {Array<Struct>}
  gameplayServices = new Array(Struct, GMArray.map([
    "shaderPipeline",
    "shaderBackgroundPipeline",
    "shaderCombinedPipeline",
    "particleService",
    "trackService",
    "gridService",
    //"gridECS", ///@description ecs
    "subtitleService",
    "coinService",
  ], function(name, index, controller) {
    Logger.debug(BeanVisuController, $"Load gameplay service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(controller, name), Struct),
    }
  }, this))

  ///@private
  ///@return {VisuController}
  init = function() {
    /*
    FileUtil.listDirectory($"{game_save_id}save", "*.visu-save.json").forEach(function(path, index) {
      Core.print(index, "|", path)
    })

    if (!FileUtil.directoryExists($"{game_save_id}save")) {
      Core.print("create directory:", $"{game_save_id}save")
      FileUtil.createDirectory($"{game_save_id}save")

      FileUtil.writeFileSync(new File({ 
        path: $"{game_save_id}save/1.visu-save.json",
        data: JSON.stringify({
          version:"1",
          model:"io.alkapivo.visu.VisuSave",
          data: {
            name: "player 1",
          },
        }, { pretty: true })
      }))
      
      FileUtil.writeFileSync(new File({ 
        path: $"{game_save_id}save/2.visu-save.json",
        data: JSON.stringify({
          version:"1",
          model:"io.alkapivo.visu.VisuSave",
          data: {
            name: "player 2",
          },
        }, { pretty: true })
      }))
    }
    FileUtil.listDirectory($"{game_save_id}save", "*.visu-save.json").forEach(function(path, index) {
      Core.print(index, ":", path)
    })
    */

    this.displayService.setCaption(game_display_name)
    Core.debugOverlay(Assert.isType(Visu.settings.getValue("visu.debug", false), Boolean))
    var fullscreen = Assert.isType(Visu.settings.getValue("visu.fullscreen", false), Boolean)
    this.displayService
      .resize(
        Assert.isType(Visu.settings.getValue("visu.window.width", 1280), Number),
        Assert.isType(Visu.settings.getValue("visu.window.height", 720), Number)
      )
      .setFullscreen(fullscreen)
      .setCursor(Cursor.DEFAULT)
      .center()
    
    this.sfxService
      .set("player-collect-bomb", new SFX("sound_sfx_player_collect_bomb"))
      .set("player-collect-life", new SFX("sound_sfx_player_collect_life"))
      .set("player-collect-point-or-force", new SFX("sound_sfx_player_collect_point_or_force"))
      .set("player-die", new SFX("sound_sfx_player_die"))
      .set("player-force-level-up", new SFX("sound_sfx_player_force_level_up"))
      .set("player-shoot", new SFX("sound_sfx_player_shoot", 3))
      .set("player-use-bomb", new SFX("sound_sfx_player_use_bomb"))
      .set("shroom-die", new SFX("sound_sfx_shroom_die", 3))
      .set("shroom-damage", new SFX("sound_sfx_shroom_damage", 3))
      .set("shroom-shoot", new SFX("sound_sfx_shroom_shoot", 3))
      .set("menu-move-cursor", new SFX("sound_sfx_player_collect_point_or_force"), 1)
      .set("menu-select-entry", new SFX("sound_sfx_player_shoot"), 1)
      .set("menu-use-entry", new SFX("sound_sfx_shroom_damage"), 1)
    

    if (Visu.settings.getValue("visu.server.enable", false)) {
      this.server.run()
    }

    
    var httpService = Beans.get(BeanHTTPService)
    if (Core.getProperty("visu.version.check", false)
      && Core.getRuntimeType() != RuntimeType.GXGAMES
      && Optional.is(httpService)) {
      httpService.send(httpService.factoryGetEvent({
        url: Core.getProperty("visu.version.url"),
        onSuccess: function(result) {
          try {
            ///@todo Use JSON.parserTask
            var versionConfig = JSON.parse(result)
            var current = Struct.get(versionConfig.data.current, Core.getRuntimeType())
            Visu._serverVersion = current.version
          } catch (exception) {
            Visu._serverVersion = null
            Logger.error("VisuController", $"serverVersion fatal error: {exception.message}")
            Core.printStackTrace()
          }
        },
      }))
    }
  
    return this
  }

  ///@private
  ///@param {Struct} service
  ///@param {Number} iterator
  ///@param {VisuController} controller
  updateService = function(service, iterator, controller) {
    try {
      service.struct.update()
    } catch (exception) {
      var message = $"'{service.name}::update' fatal error: {exception.message}"
      Logger.error(BeanVisuController, message)
      Core.printStackTrace()
      controller.send(new Event("spawn-popup", { message: message }))
      controller.fsm.dispatcher.send(new Event("transition", { name: trackService.isTrackLoaded() ? "pause" : "idle" }))

      if (!Beans.exists(BeanVisuEditorIO)) {
        Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, layerId,
          new VisuEditorIO()))
      }
      
      if (!Beans.exists(BeanVisuEditorController)) {
        Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, layerId,
          new VisuEditorController()))
      }
      var editor = Beans.get(BeanVisuEditorController)
      editor.renderUI = true
      editor.send(new Event("open"))
    }
  }

  ///@private
  ///@return {VisuController}
  updateUIService = function() {
    try {
      if (this.displayService.state == "resized") { 
        ///@description reset UI timers after resize to avoid ghost effect
        this.uiService.containers.forEach(this.resetUITimer)

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
      var message = $"'uiService::update' fatal error: {exception.message}"
      Logger.error(BeanVisuController, message)
      Core.printStackTrace()
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }

  ///@return {VisuController}
  updateCursor = function() {
    var cursor = this.displayService.getCursor()
    var size = this.menu.containers.size()
    var editor = Beans.get(BeanVisuEditorController)
    if (Optional.is(editor)) {
      if (editor.renderUI && cursor == Cursor.NONE && cursor_sprite == -1) {
        displayService.setCursor(Cursor.DEFAULT)
      } else if (!editor.renderUI && size == 0 && cursor != Cursor.NONE) {
        displayService.setCursor(Cursor.NONE)
      } else if (!editor.renderUI && size > 0 && cursor == Cursor.NONE) {
        displayService.setCursor(Cursor.DEFAULT)
      }

      if (!editor.renderUI && cursor_sprite != -1) {
        cursor_sprite = -1
      }
    } else {
      if (cursor_sprite != -1) {
        cursor_sprite = -1
      }
      
      if (size == 0 && cursor != Cursor.NONE) {
        displayService.setCursor(Cursor.NONE)
      } else if (size > 0 && cursor == Cursor.NONE) {
        displayService.setCursor(Cursor.DEFAULT)
      }
    }

    if (cursor_sprite != -1 && this.displayService.getCursor() != Cursor.NONE) {
      cursor_sprite = -1
    }

    return this
  }

  ///@private
  ///@param {UI}
  resetUITimer = function(ui) {
    ui.surfaceTick.skip()
    ui.finishUpdateTimer()
  }

  ///@param {Event}
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VisuController}
  update = function() {
    this.updateUIService()
    this.services.forEach(this.updateService, this)
    this.updateCursor()
    var editor = Beans.get(BeanVisuEditorController)
    var state = this.fsm.getStateName()
    if ((this.menu.containers.size() == 0) 
      && (state != "game-over")
      && (state != "paused" 
      || (Optional.is(editor) && editor.updateServices))) {
      this.gameplayServices.forEach(this.updateService, this)
    }
    this.visuRenderer.update()
    this.watchdog()
    return this
  }

  ///@return {VisuController}
  render = function() {
    GPU.set.colorWrite(true, true, true, true)
    if (!this.renderEnabled) {
      return this
    }

    try {
      //gpu_set_alphatestenable(true) ///@todo investigate
      //this.gridECS.render() ///@description ecs
      this.visuRenderer.render()
    } catch (exception) {
      var message = $"'render' fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error(BeanVisuController, message)
      GPU.reset.shader()
      GPU.reset.surface()
      GPU.reset.blendMode()
    }
    
    return this
  }

  ///@return {VisuController}
  renderGUI = function() {
    if (!this.renderGUIEnabled) {
      return this
    }

    try {
      //this.gridECS.renderGUI() ///@description ecs
      this.visuRenderer.renderGUI()
    } catch (exception) {
      var message = $"'renderGUI' fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error(BeanVisuController, message)
      GPU.reset.shader()
      GPU.reset.surface()
      GPU.reset.blendMode()
    }

    return this
  }

  ///@return {VisuController}
  onSceneEnter = function() {
    Logger.info("VisuController", "onSceneEnter")
    audio_stop_all()
    VideoUtil.runGC()
    if (Core.getProperty("visu.manifest.load-on-start", false)) {
      var task = new Task("load-manifest")
        .setTimeout(3.0)
        .setState({
          cooldown: new Timer(1.8),
          event: new Event("load", {
            manifest: FileUtil.get(Core.getProperty("visu.manifest.path")),
            autoplay: Assert.isType(Core.getProperty("visu.manifest.play-on-start", false), Boolean),
          }),
        })
        .whenUpdate(function() {
          if (this.state.cooldown.update().finished) {
            Beans.get(BeanVisuController).send(this.state.event)
            this.fullfill()
          }
        })
      
      this.executor.add(task)
    } else {
      var event = this.menu.factoryOpenMainMenuEvent()
      var task = new Task("load-manifest")
        .setTimeout(3.0)
        .setState({
          cooldown: new Timer(1.5),
          event: event,
        })
        .whenUpdate(function() {
          if (this.state.cooldown.update().finished) {
            Beans.get(BeanVisuController).menu.send(this.state.event)
            this.fullfill()
          }
        })
      
      this.executor.add(task)
    }
    
    return this
  }

  ///@return {VisuController}
  onSceneLeave = function() {
    Logger.info("VisuController", "onSceneLeave")
    audio_stop_all()
    VideoUtil.runGC()
    return this
  }

  ///@return {VisuController}
  onNetworkEvent = function() {
    try {
      var event = JSON.parse(json_encode(async_load))
      Logger.debug(BeanVisuController, $"'onNetworkEvent' incoming event: {event}")
      if (!Optional.is(Struct.getIfType(event, "buffer", GMBuffer))) {
        return this
      }

      var json = JSON.parse(buffer_read(event.buffer, buffer_string))
      Logger.debug(BeanVisuController, $"'onNetworkEvent' parse json: {json}")

      this.send(new Event(json.event, json.data.data))
    } catch (exception) {
      var message = $"'onNetworkEvent' fatal error: {exception.message}"
      this.send(new Event("spawn-popup", { message: message }))
      Logger.error(BeanVisuController, message)	
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
          Logger.debug(BeanVisuController, $"'free' (key: '{key}') resolved")
          Callable.run(Struct.get(struct, "free"))
        } catch (exception) {
          Logger.error(BeanVisuController, $"'free' (key: '{key}') fatal error: {exception.message}")
        }
      }, this)
    
    return this
  }

  this.init()
}

/*
Simulate FPS drops with:
```
if (keyboard_check(ord("B"))) {
  if (irandom(100) > 40) {
    var spd = 15 + irandom(keyboard_check(ord("N")) ? 15 : 45)
    game_set_speed(spd, gamespeed_fps)
    Core.print("set spd", spd, "DT", DeltaTime.get())
  }
} else {
  var spd = game_get_speed(gamespeed_fps)
  if (game_get_speed(gamespeed_fps) < 60) {
    spd = clamp(spd + choose(1, 0, 1, 0, 0, 2, 0, 1, 0, 0, 0, 0, -1, 0, 1, 1, 0, -1, 1), 15, 60)
    game_set_speed(spd, gamespeed_fps)
    Core.print("restore spd60:", spd, "DT", DeltaTime.get())
  }
}
```
*/