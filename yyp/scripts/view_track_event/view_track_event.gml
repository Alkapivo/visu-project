///@package io.alkapivo.visu.service.track

///@static
///@type {Struct}
global.__view_track_event = {
  "brush_view_camera": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "vw-cam_use-lock-x": Struct.parse.boolean(data, "vw-cam_use-lock-x"),
        "vw-cam_lock-x": Struct.parse.boolean(data, "vw-cam_lock-x"),
        "vw-cam_use-lock-y": Struct.parse.boolean(data, "vw-cam_use-lock-y"),
        "vw-cam_lock-y": Struct.parse.boolean(data, "vw-cam_lock-y"),
        "vw-cam_follow": Struct.parse.boolean(data, "vw-cam_follow"),
        "vw-cam_use-follow-x": Struct.parse.boolean(data, "vw-cam_use-follow-x"),
        "vw-cam_follow-x": Struct.parse.number(data, "vw-cam_follow-x", 0.35, -25.0, 25.0),
        "vw-cam_use-follow-y": Struct.parse.boolean(data, "vw-cam_use-follow-y"),
        "vw-cam_follow-y": Struct.parse.number(data, "vw-cam_follow-y", 0.40, -25.0, 25.0),
        "vw-cam_follow-smooth": Struct.parse.number(data, "vw-cam_follow-smooth", 32.0, 1.0, 256.0),
        "vw-cam_use-follow-smooth": Struct.parse.boolean(data, "vw-cam_use-follow-smooth"),
        "vw-cam_use-x": Struct.parse.boolean(data, "vw-cam_use-x"),
        "vw-cam_x": Struct.parse.numberTransformer(data, "vw-cam_x", {
          value: 4096.0,
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "vw-cam_change-x": Struct.parse.boolean(data, "vw-cam_change-x"),
        "vw-cam_use-y": Struct.parse.boolean(data, "vw-cam_use-y"),
        "vw-cam_y": Struct.parse.numberTransformer(data, "vw-cam_y", {
          value: 5356.0,
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "vw-cam_change-y": Struct.parse.boolean(data, "vw-cam_change-y"),
        "vw-cam_use-z": Struct.parse.boolean(data, "vw-cam_use-z"),
        "vw-cam_z": Struct.parse.numberTransformer(data, "vw-cam_z", {
          value: 5000.0,
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "vw-cam_change-z": Struct.parse.boolean(data, "vw-cam_change-z"),
        "vw-cam_use-dir": Struct.parse.boolean(data, "vw-cam_use-dir"),
        "vw-cam_dir": Struct.parse.numberTransformer(data, "vw-cam_dir", {
          clampValue: { from: -9999.9, to: 9999.9 },
          clampTarget: { from: -9999.9, to: 9999.9 },
        }),
        "vw-cam_change-dir": Struct.parse.boolean(data, "vw-cam_change-dir"),
        "vw-cam_use-pitch": Struct.parse.boolean(data, "vw-cam_use-pitch"),
        "vw-cam_pitch": Struct.parse.numberTransformer(data, "vw-cam_pitch", {
          value: -70.0,
          clampValue: { from: -9999.9, to: 9999.9 },
          clampTarget: { from: -9999.9, to: 9999.9 },
        }),
        "vw-cam_change-pitch": Struct.parse.boolean(data, "vw-cam_change-pitch"),
        "vw-cam_use-move-speed": Struct.parse.boolean(data, "vw-cam_use-move-speed"),
        "vw-cam_move-speed": Struct.parse.numberTransformer(data, "vw-cam_move-speed", {
          clampValue: { from: 0.0, to: 99.9 },
          clampTarget: { from: 0.0, to: 99.9 },
        }),
        "vw-cam_change-move-speed": Struct.parse.boolean(data, "vw-cam_change-move-speed"),
        "vw-cam_use-move-angle": Struct.parse.boolean(data, "vw-cam_use-move-angle"),
        "vw-cam_move-angle": Struct.parse.numberTransformer(data, "vw-cam_move-angle", {
          clampValue: { from: -9999.9, to: 9999.9 },
          clampTarget: { from: -9999.9, to: 9999.9 },
        }),
        "vw-cam_change-move-angle": Struct.parse.boolean(data, "vw-cam_change-move-angle"),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var pump = gridService.dispatcher
      var executor = gridService.executor
      var camera = controller.visuRenderer.gridRenderer.camera
      var lock = gridService.targetLocked
      var follow = gridService.view.follow
      ///@description feature TODO view.camera.lock.x
      Visu.resolveBooleanTrackEvent(data,
        "vw-cam_use-lock-x",
        "vw-cam_lock-x",
        "isLockedX",
        lock)
      gridService.targetLocked.lockX = null
      
      ///@description feature TODO view.camera.lock.y
      Visu.resolveBooleanTrackEvent(data,
        "vw-cam_use-lock-y",
        "vw-cam_lock-y",
        "isLockedY",
        lock)
      gridService.targetLocked.lockY = null

      ///@description feature TODO view.camera.follow.x
      Visu.resolvePropertyTrackEvent(data,
        "vw-cam_use-follow-x",
        "vw-cam_follow-x",
        "xMargin",
        follow)

      ///@description feature TODO view.camera.follow.y
      Visu.resolvePropertyTrackEvent(data,
        "vw-cam_use-follow-y",
        "vw-cam_follow-y",
        "yMargin",
        follow)

      ///@description feature TODO view.camera.follow.smooth
      Visu.resolvePropertyTrackEvent(data,
        "vw-cam_use-follow-smooth",
        "vw-cam_follow-smooth",
        "smooth",
        follow)

      ///@description feature TODO view.camera.x
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cam_use-x",
        "vw-cam_x",
        "vw-cam_change-x",
        "x",
        camera, pump, executor)

      ///@description feature TODO view.camera.y
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cam_use-y",
        "vw-cam_y",
        "vw-cam_change-y",
        "y",
        camera, pump, executor)
      
      ///@description feature TODO view.camera.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cam_use-z",
        "vw-cam_z",
        "vw-cam_change-z",
        "z",
        camera, pump, executor)

      ///@description feature TODO view.camera.dir
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cam_use-dir",
        "vw-cam_dir",
        "vw-cam_change-dir",
        "angle",
        camera, pump, executor)

      ///@description feature TODO view.camera.pitch
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cam_use-pitch",
        "vw-cam_pitch",
        "vw-cam_change-pitch",
        "pitch",
        camera, pump, executor)
      
      /*
      if (Struct.get(data, "view-config_use-movement")) {
        controller.gridService.movement.enable = Struct
          .get(data, "view-config_movement-enable")

        var movementAngle = Struct.get(data, "view-config_movement-angle")
        var angleDifference = Math.fetchPointsAngleDiff(movementAngle.target, controller.gridService.movement.angle.get())
        controller.gridService.movement.angle = new NumberTransformer({
          value: controller.gridService.movement.angle.get(),
          target: controller.gridService.movement.angle.get() + angleDifference,
          factor: movementAngle.factor,
          increase: movementAngle.increase,
        })

        var movementSpeed = Struct.get(data, "view-config_movement-speed")
        controller.gridService.movement.speed = new NumberTransformer({
          value: controller.gridService.movement.speed.get(),
          target: movementSpeed.target,
          factor: movementSpeed.factor,
          increase: movementSpeed.increase,
        })
      }
      */
    },
  },
  "brush_view_layer": {
    parse: function(data) {
      var useTextureBlend = Struct.parse.boolean(data, "vw-layer_use-texture-blend")
      var textureBlend = Struct.parse.color(data, "vw-layer_texture-blend")
      var texture = Struct.parse.sprite(data, "vw-layer_texture").setBlend(useTextureBlend
        ? textureBlend.toGMColor()
        : c_white)
      
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "vw-layer_type": Struct.parse.enumerableKey(data, "vw-layer_type", WallpaperType, WallpaperType.BACKGROUND),
        "vw-layer_fade-in": Struct.parse.number(data, "vw-layer_fade-in", 0.0, 0.0, 999.9),
        "vw-layer_fade-out": Struct.parse.number(data, "vw-layer_fade-out", 0.0, 0.0, 999.9),
        "vw-layer_use-texture": Struct.parse.boolean(data, "vw-layer_use-texture"),
        "vw-layer_texture": texture,
        "vw-layer_use-texture-blend": useTextureBlend,
        "vw-layer_texture-blend": textureBlend,
        "vw-layer_use-col": Struct.parse.boolean(data, "vw-layer_use-col"),
        "vw-layer_col": Struct.parse.color(data, "vw-layer_col"),
        "vw-layer_cls-texture": Struct.parse.boolean(data, "vw-layer_cls-texture"),
        "vw-layer_cls-col": Struct.parse.boolean(data, "vw-layer_cls-col"),
        "vw-layer_use-blend": Struct.parse.boolean(data, "vw-layer_use-blend"),
        "vw-layer_blend-src": Struct.parse.enumerableKey(data, "vw-layer_blend-src", BlendModeExt, BlendModeExt.SRC_ALPHA),
        "vw-layer_blend-dest": Struct.parse.enumerableKey(data, "vw-layer_blend-dest", BlendModeExt, BlendModeExt.INV_SRC_ALPHA),
        "vw-layer_blend-eq": Struct.parse.enumerableKey(data, "vw-layer_blend-eq", BlendEquation, BlendEquation.ADD),
        "vw-layer_blend-eq-alpha": Struct.parse.enumerableKey(data, "vw-layer_blend-eq-alpha", BlendEquation, BlendEquation.ADD),
        "vw-layer_use-spd": Struct.parse.boolean(data, "vw-layer_use-spd"),
        "vw-layer_spd": Struct.parse.numberTransformer(data, "vw-layer_spd", {
          clampValue: { from: 0.0, to: 99.9 },
          clampTarget: { from: 0.0, to: 99.9 },
        }),
        "vw-layer_change-spd": Struct.parse.boolean(data, "vw-layer_change-spd"),
        "vw-layer_use-dir": Struct.parse.boolean(data, "vw-layer_use-dir"),
        "vw-layer_dir": Struct.parse.numberTransformer(data, "vw-layer_dir", {
          clampValue: { from: -9999.9, to: 9999.9 },
          clampTarget: { from: -9999.9, to: 9999.9 },
        }),
        "vw-layer_change-dir": Struct.parse.boolean(data, "vw-layer_change-dir"),
        "vw-layer_use-scale-x": Struct.parse.boolean(data, "vw-layer_use-scale-x"),
        "vw-layer_scale-x": Struct.parse.numberTransformer(data, "vw-layer_scale-x", {
          value: 1.0,
          clampValue: { from: -99.9, to: 99.9 },
          clampTarget: { from: -99.9, to: 99.9 },
        }),
        "vw-layer_change-scale-x": Struct.parse.boolean(data, "vw-layer_change-scale-x"),
        "vw-layer_use-scale-y": Struct.parse.boolean(data, "vw-layer_use-scale-y"),
        "vw-layer_scale-y": Struct.parse.numberTransformer(data, "vw-layer_scale-y", {
          value: 1.0,
          clampValue: { from: -99.9, to: 99.9 },
          clampTarget: { from: -99.9, to: 99.9 },
        }),
        "vw-layer_change-scale-y": Struct.parse.boolean(data, "vw-layer_change-scale-y"),
        "vw-layer_use-texture-tiled": Struct.parse.boolean(data, "vw-layer_use-texture-tiled", true),
        "vw-layer_use-texture-replace": Struct.parse.boolean(data, "vw-layer_use-texture-replace", true),
        "vw-layer_texture-reset-pos": Struct.parse.boolean(data, "vw-layer_texture-reset-pos", true),
        "vw-layer_texture-use-lifespawn": Struct.parse.boolean(data, "vw-layer_texture-use-lifespawn"),
        "vw-layer_texture-lifespawn": Struct.parse.number(data, "vw-layer_texture-lifespawn", 0.0, 0.0, 9999.9),
      }
    },
    run: function(data) {
      static fadeOutColorTask = function(task, iterator, type) {
        if (task.name != "fade-color" || task.state.get("type") != type) {
          return
        }

        if (task.state.get("stage") == "fade-out") {
          task.fullfill()
          return
        }
        
        task.state.set("stage", "fade-out")
      }

      static fadeOutSpriteTask = function(task, iterator, type) {
        if (task.name != "fade-sprite" || task.state.get("type") != type) {
          return
        }

        if (task.state.get("stage") == "fade-out") {
          task.fullfill()
          return
        }
        
        task.state.set("stage", "fade-out")
      }
      

      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var pump = gridService.dispatcher
      var executor = gridService.executor
      var overlayRenderer = controller.visuRenderer.gridRenderer.overlayRenderer
      var type = Struct.get(data, "vw-layer_type")

      ///@description feature TODO view.layer.color.clear
      if (Struct.get(data, "vw-layer_cls-col")) {
        executor.tasks.forEach(fadeOutColorTask, type)
      }

      ///@description feature TODO view.layer.color
      Visu.resolveSendEventTrackEvent(data,
        "vw-layer_use-col",
        "fade-color",
        {
          executor: executor,
          type: type,
          collection: type == WallpaperType.BACKGROUND
            ? overlayRenderer.backgroundColors
            : overlayRenderer.foregroundColors,
          color: Struct.get(data, "vw-layer_col"),
          fadeInDuration: Struct.get(data, "vw-layer_fade-in"),
          fadeOutDuration: Struct.get(data, "vw-layer_fade-out"),
          blendModeSource: BlendModeExt.get(Struct.get(data, "vw-layer_blend-src")),
          blendModeTarget: BlendModeExt.get(Struct.get(data, "vw-layer_blend-dest")),
          blendEquation: BlendEquation.get(Struct.get(data, "vw-layer_blend-eq")),
          blendEquationAlpha: BlendEquation.get(Struct.get(data, "vw-layer_blend-eq-alpha")),
        },
        pump)
      

      ///@description feature TODO view.layer.texture.clear
      if (Struct.get(data, "vw-layer_cls-texture")) {
        executor.tasks.forEach(fadeOutSpriteTask, type)
      }

      var collection = type == WallpaperType.BACKGROUND
        ? overlayRenderer.backgrounds
        : overlayRenderer.foregrounds,
      var lastTask = collection.getLast()
      var lastSpeed = 0.0
      var lastAngle = 0.0
      var lastXScale = 1.0
      var lastYScale = 1.0
      var lastX = 0.0
      var lastY = 0.0
      if (Core.isType(lastTask, Task) && Core.isType(lastTask.state, Map)) {
        var _angleTransformer = lastTask.state.get("angleTransformer")
        lastAngle = Math.normalizeAngle(lastTask.state.get("angle") + (Optional.is(_angleTransformer) ? _angleTransformer.value : lastAngle))

        var _speedTransformer = lastTask.state.get("speedTransformer")
        lastSpeed = Optional.is(_speedTransformer) ? _speedTransformer.value : lastTask.state.get("speed")

        var _xScaleTransformer = lastTask.state.get("xScaleTransformer")
        lastXScale = Optional.is(_xScaleTransformer) ? _xScaleTransformer.value : lastTask.state.get("xScale")

        var _yScaleTransformer = lastTask.state.get("yScaleTransformer")
        lastYScale = Optional.is(_yScaleTransformer) ? _yScaleTransformer.value : lastTask.state.get("yScale")

        lastX = lastTask.state.get("x")
        lastY = lastTask.state.get("y")
      }

      var useAngleTransformer = Struct.get(data, "vw-layer_use-dir")
      var changeAngleTransformer = Struct.get(data, "vw-layer_change-dir")
      var angleTransformer = Struct.get(data, "vw-layer_dir")
      var angleTarget = Math.fetchPointsAngleDiff(
        Math.normalizeAngle(changeAngleTransformer 
          ? angleTransformer.target 
          : (useAngleTransformer 
            ? angleTransformer.value 
            : lastAngle)),
        Math.normalizeAngle(useAngleTransformer 
          ? angleTransformer.value 
          : lastAngle))

      angleTransformer = new NumberTransformer({
        value: 0.0,
        target: angleTarget,
        factor: (changeAngleTransformer ? angleTransformer.factor : angleTarget),
        increase: (changeAngleTransformer ? angleTransformer.increase : 0.0),
      })

      var useSpeedTransformer = Struct.get(data, "vw-layer_use-spd")
      var changeSpeedTransformer = Struct.get(data, "vw-layer_change-spd")
      var speedTransformer = Struct.get(data, "vw-layer_spd")
      speedTransformer = new NumberTransformer({
        value: useSpeedTransformer ? speedTransformer.value : lastSpeed,
        target: changeSpeedTransformer ? speedTransformer.target : (useSpeedTransformer ? speedTransformer.value : lastSpeed),
        factor: changeSpeedTransformer ? speedTransformer.factor : (useSpeedTransformer ? abs(speedTransformer.value) : 99.9),
        increase: changeSpeedTransformer ? speedTransformer.increase : 0.0,
      })

      var useXScaleTransformer = Struct.get(data, "vw-layer_use-scale-x")
      var changeXScaleTransformer = Struct.get(data, "vw-layer_change-scale-x")
      var xScaleTransformer = Struct.get(data, "vw-layer_scale-x")
      xScaleTransformer = new NumberTransformer({
        value: useXScaleTransformer ? xScaleTransformer.value : lastXScale,
        target: changeXScaleTransformer ? xScaleTransformer.target : (useXScaleTransformer ? xScaleTransformer.value : lastXScale),
        factor: changeXScaleTransformer ? xScaleTransformer.factor : (useXScaleTransformer ? abs(xScaleTransformer.value) : 99.9),
        increase: changeXScaleTransformer ? xScaleTransformer.increase : 0.0,
      })

      var useYScaleTransformer = Struct.get(data, "vw-layer_use-scale-y")
      var changeYScaleTransformer = Struct.get(data, "vw-layer_change-scale-y")
      var yScaleTransformer = Struct.get(data, "vw-layer_scale-y")
      yScaleTransformer = new NumberTransformer({
        value: useYScaleTransformer ? yScaleTransformer.value : lastYScale,
        target: changeYScaleTransformer ? yScaleTransformer.target : (useYScaleTransformer ? yScaleTransformer.value : lastYScale),
        factor: changeYScaleTransformer ? yScaleTransformer.factor : (useYScaleTransformer ? abs(yScaleTransformer.value) : 99.9),
        increase: changeYScaleTransformer ? yScaleTransformer.increase : 0.0,
      })
      
      ///@description feature TODO view.layer.texture
      Visu.resolveSendEventTrackEvent(data,
        "vw-layer_use-texture",
        "fade-sprite",
        {
          executor: executor,
          type: type,
          collection: collection,
          sprite: Struct.get(data, "vw-layer_texture"),
          fadeInDuration: Struct.get(data, "vw-layer_fade-in"),
          fadeOutDuration: Struct.get(data, "vw-layer_fade-out"),
          blendModeSource: BlendModeExt.get(Struct.get(data, "vw-layer_blend-src")),
          blendModeTarget: BlendModeExt.get(Struct.get(data, "vw-layer_blend-dest")),
          blendEquation: BlendEquation.get(Struct.get(data, "vw-layer_blend-eq")),
          blendEquationAlpha: BlendEquation.get(Struct.get(data, "vw-layer_blend-eq-alpha")),
          angle: Struct.get(data, "vw-layer_use-dir") 
            ? Struct.get(data, "vw-layer_dir").value 
            : lastAngle,
          angleTransformer: angleTransformer,
          speed: speedTransformer.value,
          speedTransformer: speedTransformer,
          xScale: xScaleTransformer.value,
          xScaleTransformer: xScaleTransformer,
          yScale: yScaleTransformer.value,
          yScaleTransformer: yScaleTransformer,
          x: Struct.get(data, "vw-layer_texture-reset-pos") ? null : lastX,
          y: Struct.get(data, "vw-layer_texture-reset-pos") ? null : lastY,
          tiled: Struct.get(data, "vw-layer_use-texture-tiled"),
          replace: Struct.get(data, "vw-layer_use-texture-replace"),
          lifespawn: Struct.get(data, "vw-layer_texture-use-lifespawn") ? Struct.get(data, "vw-layer_texture-lifespawn") : null,
        },
        pump)
    },
  },
  "brush_view_subtitle": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "vw-sub_template": Struct.parse.text(data, "vw-sub_template"),
        "vw-sub_font": Struct.parse.text(data, "vw-sub_font", VISU_FONT[0]),
        "vw-sub_fh": Struct.parse.number(data, "vw-sub_fh", 12, 0, 999),
        "vw-sub_use-timeout": Struct.parse.boolean(data, "vw-sub_use-timeout"),
        "vw-sub_timeout": Struct.parse.number(data, "vw-sub_timeout", 0.0, 0.0, 999.9),
        "vw-sub_col": Struct.parse.color(data, "vw-sub_col"),
        "vw-sub_use-outline": Struct.parse.boolean(data, "vw-sub_use-outline"),
        "vw-sub_outline": Struct.parse.color(data, "vw-sub_outline"),
        "vw-sub_align-v": Struct.parse.gmArrayValue(data, "vw-sub_align-v", [ "TOP", "BOTTOM" ], "TOP"),
        "vw-sub_align-h": Struct.parse.gmArrayValue(data, "vw-sub_align-h", [ "LEFT", "CENTER", "RIGHT" ], "LEFT"),
        "vw-sub_x": Struct.parse.normalizedNumber(data, "vw-sub_x", 0.0),
        "vw-sub_y": Struct.parse.normalizedNumber(data, "vw-sub_y", 0.0),
        "vw-sub_w": Struct.parse.number(data, "vw-sub_w", 1.0, 0.0, 10.0),
        "vw-sub_h": Struct.parse.number(data, "vw-sub_h", 1.0, 0.0, 10.0),
        "vw-sub_char-spd": Struct.parse.number(data, "vw-sub_char-spd", 1.0, 0.000001, 999.9),
        "vw-sub_use-nl-delay": Struct.parse.boolean(data, "vw-sub_use-nl-delay"),
        "vw-sub_nl-delay": Struct.parse.number(data, "vw-sub_nl-delay", 1.0, 0.0, 999.9),
        "vw-sub_use-end-delay": Struct.parse.boolean(data, "vw-sub_use-end-delay"),
        "vw-sub_end-delay": Struct.parse.number(data, "vw-sub_end-delay", 1.0, 0.0, 999.9),
        "vw-sub_use-dir": Struct.parse.boolean(data, "vw-sub_use-dir"),
        "vw-sub_dir": Struct.parse.numberTransformer(data, "vw-sub_dir", {
          clampValue: { from: -9999.9, to: 9999.9 },
          clampTarget: { from: -9999.9, to: 9999.9 },
        }),
        "vw-sub_change-dir": Struct.parse.boolean(data, "vw-sub_change-dir"),
        "vw-sub_use-spd": Struct.parse.boolean(data, "vw-sub_use-spd"),
        "vw-sub_spd": Struct.parse.numberTransformer(data, "vw-sub_spd", {
          clampValue: { from: 0.0, to: 999.9 },
          clampTarget: { from: 0.0, to: 999.9 },
        }),
        "vw-sub_change-spd": Struct.parse.boolean(data, "vw-sub_change-spd"),
        "vw-sub_fade-in": Struct.parse.number(data, "vw-sub_fade-in", 0.0, 999.9),
        "vw-sub_fade-out": Struct.parse.number(data, "vw-sub_fade-out", 0.0, 999.9),
        "vw-sub_use-area-preview": Struct.parse.boolean(data, "vw-sub_use-area-preview"),
      }
    },
    run: function(data) {
      var subtitleService = Beans.get(BeanVisuController).subtitleService

      ///@description feature TODO view.subtitle.add
      subtitleService.send(new Event("add", {
        template: Struct.get(data, "vw-sub_template"),
        font: FontUtil.fetch(Struct.get(data, "vw-sub_font")),
        fontHeight: Struct.get(data, "vw-sub_fh"),
        timeout: Struct.get(data, "vw-sub_use-timeout")
          ? Struct.get(data, "vw-sub_timeout")
          : null,
        color: Struct.get(data, "vw-sub_col").toGMColor(),
        outline: Struct.get(data, "vw-sub_use-outline")
          ? Struct.get(data, "vw-sub_outline").toGMColor()
          : null,
        align: {
          v: VAlign.get(Struct.get(data, "vw-sub_align-v")),
          h: HAlign.get(Struct.get(data, "vw-sub_align-h")),
        },
        area: new Rectangle({ 
          x: Struct.get(data, "vw-sub_x"),
          y: Struct.get(data, "vw-sub_y"),
          width: Struct.get(data, "vw-sub_w"),
          height: Struct.get(data, "vw-sub_h"),
        }),
        charSpeed: Struct.get(data, "vw-sub_char-spd"),
        lineDelay: Struct.get(data, "vw-sub_use-nl-delay")
          ? new Timer(Struct.get(data, "vw-sub_nl-delay"))
          : null,
        finishDelay: Struct.get(data, "vw-sub_use-end-delay")
          ? new Timer(Struct.get(data, "vw-sub_end-delay"))
          : null,
        angleTransformer: new NumberTransformer({
          value: (Struct.get(data, "vw-sub_use-dir")
            ? Struct.get(data, "vw-sub_dir").value
            : 0.0),
          target: (Struct.get(data, "vw-sub_change-dir")
            ? Struct.get(data, "vw-sub_dir").target
            : (Struct.get(data, "vw-sub_use-dir")
              ? Struct.get(data, "vw-sub_dir").value
              : 0.0)),
          factor: (Struct.get(data, "vw-sub_change-dir")
            ? Struct.get(data, "vw-sub_dir").factor
            : (Struct.get(data, "vw-sub_use-dir")
              ? Struct.get(data, "vw-sub_dir").value
              : 0.0)),
          increase: (Struct.get(data, "vw-sub_change-dir")
            ? Struct.get(data, "vw-sub_dir").increase
            : 0.0),
        }),
        speedTransformer: new NumberTransformer({
          value: (Struct.get(data, "vw-sub_use-spd")
            ? Struct.get(data, "vw-sub_spd").value
            : 0.0),
          target: (Struct.get(data, "vw-sub_change-spd")
            ? Struct.get(data, "vw-sub_spd").target
            : (Struct.get(data, "vw-sub_use-spd")
              ? Struct.get(data, "vw-sub_spd").value
              : 0.0)),
          factor: (Struct.get(data, "vw-sub_change-spd")
            ? Struct.get(data, "vw-sub_spd").factor
            : (Struct.get(data, "vw-sub_use-spd")
              ? Struct.get(data, "vw-sub_spd").value
              : 0.0)),
          increase: (Struct.get(data, "vw-sub_change-spd")
            ? Struct.get(data, "vw-sub_spd").increase
            : 0.0),
        }),
        fadeIn: Struct.get(data, "vw-sub_fade-in"),
        fadeOut: Struct.get(data, "vw-sub_fade-out"),
      }))
    },
  },
  "brush_view_config": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "vw-cfg_use-render-hud": Struct.parse.boolean(data, "vw-cfg_use-render-hud"),
        "vw-cfg_render-hud": Struct.parse.boolean(data, "vw-cfg_render-hud"),
        "vw-cfg_use-render-subtitle": Struct.parse.boolean(data, "vw-cfg_use-render-subtitle"),
        "vw-cfg_render-subtitle": Struct.parse.boolean(data, "vw-cfg_render-subtitle"),
        "vw-cfg_use-render-video": Struct.parse.boolean(data, "vw-cfg_use-render-video"),
        "vw-cfg_render-video": Struct.parse.boolean(data, "vw-cfg_render-video"),
        "vw-cfg_cls-subtitle": Struct.parse.boolean(data, "vw-cfg_cls-subtitle"),
        "vw-cfg_cls-bkg-texture": Struct.parse.boolean(data, "vw-cfg_cls-bkg-texture"),
        "vw-cfg_cls-bkg-col": Struct.parse.boolean(data, "vw-cfg_cls-bkg-col"),
        "vw-cfg_cls-frg-texture": Struct.parse.boolean(data, "vw-cfg_cls-frg-texture"),
        "vw-cfg_cls-frg-col": Struct.parse.boolean(data, "vw-cfg_cls-frg-col"),
        "vw-cfg_use-video-alpha": Struct.parse.boolean(data, "vw-cfg_use-video-alpha"),
        "vw-cfg_video-alpha": Struct.parse.normalizedNumberTransformer(data, "vw-cfg_video-alpha"),
        "vw-cfg_change-video-alpha": Struct.parse.boolean(data, "vw-cfg_change-video-alpha"),
        "vw-cfg_video-use-blend-col": Struct.parse.boolean(data, "vw-cfg_video-use-blend-col"),
        "vw-cfg_video-blend-col": Struct.parse.color(data, "vw-cfg_video-blend-col", "#ffffff"),
        "vw-cfg_video-blend-col-spd": Struct.parse.number(data, "vw-cfg_video-blend-col-spd", 1.0, 0.0, 999.9),
        "vw-cfg_video-use-blend": Struct.parse.boolean(data, "vw-cfg_video-use-blend"),
        "vw-cfg_video-blend-src": Struct.parse.enumerableKey(data, "vw-cfg_video-blend-src", BlendModeExt, BlendModeExt.SRC_ALPHA),
        "vw-cfg_video-blend-dest": Struct.parse.enumerableKey(data, "vw-cfg_video-blend-dest", BlendModeExt, BlendModeExt.INV_SRC_ALPHA),
        "vw-cfg_video-blend-eq": Struct.parse.enumerableKey(data, "vw-cfg_video-blend-eq", BlendEquation, BlendEquation.ADD),
        "vw-cfg_video-blend-eq-alpha": Struct.parse.enumerableKey(data, "vw-cfg_video-blend-eq-alpha", BlendEquation, BlendEquation.ADD),
        "vw-cfg_use-render-video-after": Struct.parse.boolean(data, "vw-cfg_use-render-video-after"),
        "vw-cfg_render-video-after": Struct.parse.boolean(data, "vw-cfg_render-video-after"),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor
      var overlayRenderer = controller.visuRenderer.gridRenderer.overlayRenderer

      ///@description feature TODO view.hud.render
      Visu.resolveBooleanTrackEvent(data,
        "vw-cfg_use-render-hud",
        "vw-cfg_render-hud",
        "enabled",
        controller.visuRenderer.hudRenderer)

      ///@description feature TODO view.subtitle.render
      Visu.resolveBooleanTrackEvent(data,
        "vw-cfg_use-render-subtitle",
        "vw-cfg_render-subtitle",
        "renderSubtitles",
        properties)

      ///@description feature TODO view.video.render
      Visu.resolveBooleanTrackEvent(data,
        "vw-cfg_use-render-video",
        "vw-cfg_render-video",
        "renderVideo",
        properties)

      ///@description feature TODO view.video.render-after
      Visu.resolveBooleanTrackEvent(data,
        "vw-cfg_use-render-video-after",
        "vw-cfg_render-video-after",
        "renderVideoAfter",
        properties)

      ///@description feature TODO view.subtitle.clear
      Visu.resolveSendEventTrackEvent(data,
        "vw-cfg_cls-subtitle",
        "clear-subtitle",
        null,
        controller.subtitleService.dispatcher)

      ///@description feature TODO view.bkg-texture.clear
      if (Struct.get(data, "vw-cfg_cls-bkg-texture")) {
        overlayRenderer.backgrounds.clear()
      }

      ///@description feature TODO view.bkg-col.clear
      if (Struct.get(data, "vw-cfg_cls-bkg-col")) {
        overlayRenderer.backgroundColors.clear()
      }

      ///@description feature TODO view.frg-texture.clear
      if (Struct.get(data, "vw-cfg_cls-frg-texture")) {
        overlayRenderer.foregrounds.clear()
      }

      ///@description feature TODO view.frg-col.clear
      if (Struct.get(data, "vw-cfg_cls-frg-col")) {
        overlayRenderer.foregroundColors.clear()
      }

      ///@description feature TODO view.video.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "vw-cfg_use-video-alpha",
        "vw-cfg_video-alpha",
        "vw-cfg_change-video-alpha",
        "videoAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.column.side.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "vw-cfg_video-use-blend-col",
        "vw-cfg_video-blend-col",
        "vw-cfg_video-blend-col-spd",
        "videoBlendColor",
        properties, pump, executor)

      ///@description feature TODO view.video.blend-config
      Visu.resolveBlendConfigTrackEvent(data,
        "vw-cfg_video-use-blend",
        "vw-cfg_video-blend-src",
        "vw-cfg_video-blend-dest",
        "vw-cfg_video-blend-eq",
        properties.videoBlendConfig,
        "vw-cfg_video-blend-eq-alpha")
    },
  },
}
#macro view_track_event global.__view_track_event
