///@package io.alkapivo.visu.service.track

///@static
///@type {Struct}
global.__view_track_event = {
  "brush_view_wallpaper": function(data) {
    var controller = Beans.get(BeanVisuController)
    if (Struct.get(data, "view-wallpaper_use-color") == true) {
      controller.gridService.send(new Event("fade-color", {
        color: ColorUtil.fromHex(Struct.get(data, "view-wallpaper_color")),
        collection: Struct.get(data, "view-wallpaper_type") == "Background" 
          ? controller.gridRenderer.overlayRenderer.backgroundColors
          : controller.gridRenderer.overlayRenderer.foregroundColors,
        type: Struct.get(data, "view-wallpaper_type"),
        fadeInSpeed: Struct.get(data, "view-wallpaper_fade-in-speed"),
        fadeOutSpeed: Struct.get(data, "view-wallpaper_fade-out-speed"),
        executor: controller.gridService.executor,
      }))
    }

    if (Struct.get(data, "view-wallpaper_clear-color") == true) {
      controller.gridService.executor.tasks.forEach(function(task, iterator, type) {
        if (task.name == "fade-color" && task.state.get("type") == type) {
          task.state.set("stage", "fade-out")
        }
      }, Struct.get(data, "view-wallpaper_type"))
    }

    if (Struct.get(data, "view-wallpaper_use-texture") == true) {
      var sprite = Struct.get(data, "view-wallpaper_texture")
      var animate = Struct.get(data, "view-wallpaper_use-texture-speed")
      if (animate) {
        Struct.set(sprite, "animate", animate)
        Struct.set(sprite, "speed", Struct.get(data, "view-wallpaper_texture-speed"))
      }
      
      controller.gridService.send(new Event("fade-sprite", {
        sprite: SpriteUtil.parse(sprite),
        collection: Struct.get(data, "view-wallpaper_type") == "Background" 
          ? controller.gridRenderer.overlayRenderer.backgrounds
          : controller.gridRenderer.overlayRenderer.foregrounds,
        type: Struct.get(data, "view-wallpaper_type"),
        fadeInSpeed: Struct.get(data, "view-wallpaper_fade-in-speed"),
        fadeOutSpeed: Struct.get(data, "view-wallpaper_fade-out-speed"),
        executor: controller.gridService.executor,
      }))
    }

    if (Struct.get(data, "view-wallpaper_clear-texture") == true) {
      controller.gridService.executor.tasks.forEach(function(task, iterator, type) {
        if (task.name == "fade-sprite" && task.state.get("type") == type) {
          task.state.set("stage", "fade-out")
        }
      }, Struct.get(data, "view-wallpaper_type"))
    }
  },
  "brush_view_camera": function(data) {
    var controller = Beans.get(BeanVisuController)

    if (Struct.get(data, "view-config_use-movement")) {
      controller.gridService.movement.enable = Struct
        .get(data, "view-config_movement-enable")

      var movementAngle = Struct.get(data, "view-config_movement-angle")
      var angleDifference = angle_difference(movementAngle.target, controller.gridService.movement.angle.get())
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
    

    if (Struct.get(data, "view-config_use-lock-target-x")) {
      controller.editor.store
        .get("target-locked-x")
        .set(Struct.get(data, "view-config_lock-target-x"))
    }
    
    if (Struct.get(data, "view-config_use-lock-target-y")) {
      controller.editor.store
        .get("target-locked-y")
        .set(Struct.get(data, "view-config_lock-target-y"))
    }

    if (Struct.get(data, "view-config_use-follow-properties")) {
      var follow = controller.gridService.view.follow
      follow.xMargin = Struct.get(data, "view-config_follow-margin-x")
      follow.yMargin = Struct.get(data, "view-config_follow-margin-y")
      follow.smooth = Struct.get(data, "view-config_follow-smooth")
    }

    if (Struct.get(data, "view-config_use-transform-x")) {
      var transformer = Struct.get(data, "view-config_transform-x")
      controller.gridService.send(new Event("transform-property", {
        key: "x",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.x,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-transform-y")) {
      var transformer = Struct.get(data, "view-config_transform-y")
      controller.gridService.send(new Event("transform-property", {
        key: "y",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.y,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-transform-z")) {
      var transformer = Struct.get(data, "view-config_transform-z")
      controller.gridService.send(new Event("transform-property", {
        key: "z",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.z,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-transform-zoom")) {
      var transformer = Struct.get(data, "view-config_transform-zoom")
      controller.gridService.send(new Event("transform-property", {
        key: "zoom",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.zoom,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-transform-angle")) {
      var transformer = Struct.get(data, "view-config_transform-angle")
      var angleDifference = angle_difference(transformer.target, controller.gridRenderer.camera.angle)
      controller.gridService.send(new Event("transform-property", {
        key: "angle",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.angle,
          target: controller.gridRenderer.camera.angle + angleDifference,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-transform-pitch")) {
      var transformer = Struct.get(data, "view-config_transform-pitch")
      controller.gridService.send(new Event("transform-property", {
        key: "pitch",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.pitch,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
  },
  "brush_view_lyrics": function(data) {
    var controller = Beans.get(BeanVisuController)

    var align = { v: VAlign.TOP, h: HAlign.LEFT }
    var alignV = Struct.get(data, "view-lyrics_align-v")
    var alignH = Struct.get(data, "view-lyrics_align-h")
    if (alignV == "BOTTOM") {
      align.v = VAlign.BOTTOM
    }
    if (alignH == "CENTER") {
      align.h = HAlign.CENTER
    } else if (alignH == "RIGHT") {
      align.h = HAlign.RIGHT
    }

    controller.lyricsService.send(new Event("add")
      .setData({
        template: Struct.get(data, "view-lyrics_template"),
        font: FontUtil.fetch(Struct.get(data, "view-lyrics_font")),
        fontHeight: Struct.get(data, "view-lyrics_font-height"),
        charSpeed: Struct.get(data, "view-lyrics_char-speed"),
        color: ColorUtil.fromHex(Struct.get(data, "view-lyrics_color")).toGMColor(),
        outline: Struct.get(data, "view-lyrics_use-outline")
          ? ColorUtil.fromHex(Struct.get(data, "view-lyrics_outline")).toGMColor()
          : null,
        timeout: Struct.get(data, "view-lyrics_use-timeout")
          ? Struct.get(data, "view-lyrics_timeout")
          : null,
        align: align,
        area: new Rectangle({ 
          x: Struct.get(data, "view-lyrics_x"),
          y: Struct.get(data, "view-lyrics_y"),
          width: Struct.get(data, "view-lyrics_width"),
          height: Struct.get(data, "view-lyrics_height"),
        }),
        lineDelay: Struct.get(data, "view-lyrics_use-line-delay")
          ? new Timer(Struct.get(data, "view-lyrics_line-delay"))
          : null,
        finishDelay: Struct.get(data, "view-lyrics_use-finish-delay")
          ? new Timer(Struct.get(data, "view-lyrics_finish-delay"))
          : null,
        angleTransformer: Struct.get(data, "view-lyrics_use-transform-angle")
          ? new NumberTransformer(Struct.get(data, "view-lyrics_transform-angle"))
          : new NumberTransformer({ value: 0.0, target: 0.0, factor: 0.0, increase: 0.0 }),
        speedTransformer: Struct.get(data, "view-lyrics_use-transform-speed")
          ? new NumberTransformer(Struct.get(data, "view-lyrics_transform-speed"))
          : null,
        fadeIn: Struct.get(data, "view-lyrics_fade-in"),
        fadeOut: Struct.get(data, "view-lyrics_fade-out"),
      }))
  },
  "brush_view_glitch": function(data) {
    var bktGlitchService = Beans.get(BeanVisuController).gridRenderer.bktGlitchService

    var config = {
      lineSpeed: {
        defValue: Struct.getDefault(data, "view-glitch_line-speed", 0.0),
        minValue: 0.0,
        maxValue: 0.5,
      },
      lineShift: {
        defValue: Struct.getDefault(data, "view-glitch_line-shift", 0.0),
        minValue: 0.0,
        maxValue: 0.05,
      },
      lineResolution: {
        defValue: Struct.getDefault(data, "view-glitch_line-resolution", 0.0),
        minValue: 0.0,
        maxValue: 3.0,
      },
      lineVertShift: {
        defValue: Struct.getDefault(data, "view-glitch_line-vertical-shift", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      lineDrift: {
        defValue: Struct.getDefault(data, "view-glitch_line-drift", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleSpeed: {
        defValue: Struct.getDefault(data, "view-glitch_jumble-speed", 0.0),
        minValue: 0.0,
        maxValue: 25.0,
      },
      jumbleShift: {
        defValue: Struct.getDefault(data, "view-glitch_jumble-shift", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleResolution: {
        defValue: Struct.getDefault(data, "view-glitch_jumble-resolution", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleness: {
        defValue: Struct.getDefault(data, "view-glitch_jumble-jumbleness", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      dispersion: {
        defValue: Struct.getDefault(data, "view-glitch_shader-dispersion", 0.0),
        minValue: 0.0,
        maxValue: 0.5,
      },
      channelShift: {
        defValue: Struct.getDefault(data, "view-glitch_shader-channel-shift", 0.0),
        minValue: 0.0,
        maxValue: 0.05,
      },
      noiseLevel: {
        defValue: Struct.getDefault(data, "view-glitch_shader-noise-level", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      shakiness: {
        defValue: Struct.getDefault(data, "view-glitch_shader-shakiness", 0.0),
        minValue: 0.0,
        maxValue: 10.0,
      },
      rngSeed: {
        defValue: Struct.getDefault(data, "view-glitch_shader-rng-seed", 0.0),
        minValue: 0.0,
        maxValue: 1.0,
      },
      intensity: {
        defValue: Struct.getDefault(data, "view-glitch_shader-intensity", 0.0),
        minValue: 0.0,
        maxValue: 5.0,
      },
    }
    var useConfig = Struct.get(data, "view-glitch_use-config")
    if (useConfig) {
      bktGlitchService.dispatcher.execute(new Event("load-config", config))
    }

    bktGlitchService.dispatcher.execute(new Event("spawn", { 
      factor: (Struct.get(data, "view-glitch_use-factor") 
        ? Struct.get(data, "view-glitch_factor") / 100.0 
        : 0.0),
      rng: !useConfig,
    }))
  },
  "brush_view_config": function(data) {
    var gridService = Beans.get(BeanVisuController).gridService

    if (Struct.get(data, "view-config_use-render-particles")) {
      gridService.properties.renderParticles = Struct
        .get(data, "view-config_render-particles")
    }
    
    if (Struct.get(data, "view-config_use-transform-particles-z")) {
      var transformer = Struct.get(data, "view-config_transform-particles-z")
      gridService.send(new Event("transform-property", {
        key: "particleZ",
        container: gridService.properties.depths,
        executor: gridService.executor,
        transformer: new NumberTransformer({
          value: gridService.properties.depths.particleZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "view-config_use-render-video")) {
      gridService.properties.renderVideo = Struct
        .get(data, "view-config_render-video")
    }
  },
}
#macro view_track_event global.__view_track_event
