///@package io.alkapivo.visu.service.track

///@static
///@type {Map<String, Callable>}
global.__view_track_event = new Map(String, Callable, {
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

    if (Struct.get(data, "view-config_use-transform-x") == true) {
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
    
    if (Struct.get(data, "view-config_use-transform-y") == true) {
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
    
    if (Struct.get(data, "view-config_use-transform-z") == true) {
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
    
    if (Struct.get(data, "view-config_use-transform-zoom") == true) {
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
    
    if (Struct.get(data, "view-config_use-transform-angle") == true) {
      var transformer = Struct.get(data, "view-config_transform-angle")
      controller.gridService.send(new Event("transform-property", {
        key: "angle",
        container: controller.gridRenderer.camera,
        executor: controller.gridRenderer.camera.executor,
        transformer: new NumberTransformer({
          value: controller.gridRenderer.camera.angle,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    
    if (Struct.get(data, "view-config_use-transform-pitch") == true) {
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
        font: FontUtil.fetch(Struct.get(data, "view-lyrics_font")).asset,
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
          : null,
        speedTransformer: Struct.get(data, "view-lyrics_use-transform-speed")
          ? new NumberTransformer(Struct.get(data, "view-lyrics_transform-speed"))
          : null,
      }))
  },
  "brush_view_config": function(data) {
    var controller = Beans.get(BeanVisuController)
    var bktGlitchService = controller.gridRenderer.bktGlitchService
    if (Struct.get(data, "view-config_bkt-trigger") == true) {
      var event = new Event("spawn")
      if (Struct.get(data, "view-config_bkt-use-factor") == true) {
        event.setData({ factor: Struct.get(data, "view-config_bkt-factor")})
      }
      bktGlitchService.send(event)
    }

    if (Struct.get(data, "view-config_bkt-use-config") == true) {
      var config = bktGlitchService.configs.get(Struct.get(data, "view-config_bkt-config"))
      if (Optional.is(config)) {
        bktGlitchService.send(new Event("load-config").setData(config))
      }
    }
  },
})
#macro view_track_event global.__view_track_event
