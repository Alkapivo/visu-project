///@package io.alkapivo.visu

#macro BeanVisuController "visuController"
///@param {String} layerName
function VisuController(layerName) constructor {

  ////@type {Gamemode}
  gameMode = GameMode.BULLETHELL

  ///@type {?VisuTrack}
  track = null
  
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
            fsmState.state.set("autoplay", Struct.getDefault(data, "autoplay", false))
            fsm.context.loader.fsm.dispatcher.send(new Event("transition", {
              name: "parse-manifest",
              data: data.manifest,
            }))
            
            audio_stop_all()
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

            ///@hack
            var trackService = fsm.context.trackService
            if (trackService.isTrackLoaded()
              && !trackService.track.audio.isLoaded()) {
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

  ///@type {UIService}
  uiService = new UIService(this)

  ///@type {DisplayService}
  displayService = new DisplayService(this, { minWidth: 800, minHeight: 480 })

  ///@type {ParticleService}
  particleService = new ParticleService(this, { 
    layerName: layerName,
    getStaticTemplates: function() {
      return Visu.assets().particleTemplates
    },
  })

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

  ///@type {CoinService}
  coinService = new CoinService()

  ///@type {GridService}
  gridService = new GridService(this)

  ///@type {VideoService}
  videoService = new VideoService()

  ///@type {SFXService}
  sfxService = new SFXService()

  ///@type {LyricsService}
  lyricsService = new LyricsService(this)

  ///@type {VisuRenderer}
  visuRenderer = new VisuRenderer(this)

  ///@type {GridECS}
  //gridECS = new GridECS(this) ///@ecs

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
        var ostVolume = Visu.settings.getValue("visu.audio.ost.volume")
        if (ost.isPlaying() && ost.getVolume() != ostVolume) {
          ost.setVolume(ostVolume)
        }
      }

      var sfxVolume = Visu.settings.getValue("visu.audio.sfx.volume")
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
      }
    } catch (exception) {
      var message = $"Watchdog throwed an exception: {exception.message}"
      this.send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
    }

    return this
  }

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
      this.fsm.dispatcher.send(fsmEvent)
    },
    "quit": function(event) {
      this.fsm.dispatcher.send(new Event("transition", { name: "quit" }))
    },
    "spawn-popup": function(event) {
      var _editor = Beans.get(BeanVisuEditorController)
      if (Core.isType(_editor, VisuEditorController)) {
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
    //"gridECS", ///@ecs
    "lyricsService",
    "coinService",
    "videoService",
    "sfxService",
  ], function(name, index, controller) {
    Logger.debug("VisuController", $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(controller, name), Struct),
    }
  }, this))

  ///@private
  ///@return {VisuController}
  init = function() {
    Core.debugOverlay(Assert.isType(Core.getProperty("visu.debug", false), Boolean))
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
      .set("player-shoot", new SFX("sound_sfx_player_shoot", 2))
      .set("player-use-bomb", new SFX("sound_sfx_player_use_bomb"))
      .set("shroom-die", new SFX("sound_sfx_shroom_die", 2))
      .set("shroom-shoot", new SFX("sound_sfx_shroom_shoot", 2))

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
      var message = $"'update-service-{service.name}' fatal error: {exception.message}"
      Logger.error("VisuController", message)
      Core.printStackTrace()
      controller.send(new Event("spawn-popup", { message: message }))
      fsm.dispatcher.send(new Event("transition", { name: "idle" }))
    }
  }

  ///@private
  ///@return {VisuController}
  updateUIService = function() {
    try {
      if (this.displayService.state == "resized") {
        ///@description reset UI timers after resize to avoid ghost effect
        this.uiService.containers.forEach(this.resetUIContainerTimer)

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
      var message = $"'updateUIService' set fatal error: {exception.message}"
      Logger.error(BeanVisuController, message)
      Core.printStackTrace()
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }

  ///@private
  ///@param {UIContainer}
  resetUIContainerTimer = function(container) {
    if (!Optional.is(container.updateTimer)) {
      return
    }

    container.surfaceTick.skip()
    container.updateTimer.time = container.updateTimer.duration
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
    this.visuRenderer.update()
    this.watchdog()

    return this
  }

  ///@return {VisuController}
  render = function() {
    if (!this.renderEnabled) {
      return this
    }

    try {
      //gpu_set_alphatestenable(true) ///@todo investigate
      //this.gridECS.render() ///@ecs
      this.visuRenderer.render()
    } catch (exception) {
      var message = $"render throws exception: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
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
      //this.gridECS.renderGUI() ///@ecs
      this.visuRenderer.renderGUI()
    } catch (exception) {
      var message = $"renderGUI throws exception: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("VisuController", message)
      GPU.reset.shader()
      GPU.reset.surface()
      GPU.reset.blendMode()
    }
    
    return this
  }

  ///@return {VisuController}
  onSceneEnter = function() {
    Logger.info("VisuController", "onSceneEnter")
    VideoUtil.runGC()
    if (Core.getProperty("visu.manifest.load-on-start", false)) {
      var task = new Task("load-manifest")
        .setTimeout(3.0)
        .setState({
          cooldown: new Timer(1.0),
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
          Logger.debug(BeanVisuController, $"Free '{key}'")
          Callable.run(Struct.get(struct, "free"))
        } catch (exception) {
          Logger.error(BeanVisuController, $"Unable to free '{key}'. {exception.message}")
        }
      }, this)
    
    return this
  }

  this.init()
}
