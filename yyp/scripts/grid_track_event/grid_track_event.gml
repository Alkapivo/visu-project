///@package io.alkapivo.visu.service.track

///@static
///@type {Struct}
global.__grid_track_event = {
  "brush_grid_channel": function(data) {
    var controller = Beans.get(BeanVisuController)
    if (Struct.get(data, "grid-channel_use-transform-amount") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-amount")
      controller.gridService.send(new Event("transform-property", {
        key: "channels",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.channels,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-transform-z") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-z")
      controller.gridService.send(new Event("transform-property", {
        key: "channelZ",
        container: controller.gridService.properties.depths,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.depths.channelZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-primary-color") == true) {
      controller.gridService.send(new Event("transform-property", {
        key: "channelsPrimaryColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.gridClearColor.toHex(true),
          target: Struct.get(data, "grid-channel_primary-color"),
          factor: Struct.getDefault(data, "grid-channel_primary-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-transform-primary-alpha") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-primary-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "channelsPrimaryAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.channelsPrimaryAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-transform-primary-size") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-primary-size")
      controller.gridService.send(new Event("transform-property", {
        key: "channelsPrimaryThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.channelsPrimaryThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "grid-channel_use-secondary-color") == true) {
      controller.gridService.send(new Event("transform-property", {
        key: "channelsSecondaryColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.gridClearColor.toHex(true),
          target: Struct.get(data, "grid-channel_secondary-color"),
          factor: Struct.getDefault(data, "grid-channel_secondary-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-transform-secondary-alpha") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-secondary-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "channelsSecondaryAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.channelsSecondaryAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-channel_use-transform-secondary-size") == true) {
      var transformer = Struct.get(data, "grid-channel_transform-secondary-size")
      controller.gridService.send(new Event("transform-property", {
        key: "channelsSecondaryThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.channelsSecondaryThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
  },
  "brush_grid_coin": function(data) {
    var controller = Beans.get(BeanVisuController)
    var view = controller.gridService.view
    var viewX = Struct.getDefault(data, "grid-coin_use-snap-h", false)
      ? floor(view.x / (view.width / 2.0)) * (view.width / 2.0)
      : view.x
    var viewY = Struct.getDefault(data, "grid-coin_use-snap-v", false)
      ? floor(view.y / (view.height / 2.0)) * (view.height / 2.0)
      : view.y
    
    var coin = {
      template: Struct.get(data, "grid-coin_template"),
      x: viewX + (Struct.get(data, "grid-coin_use-spawn-x")
        ? Struct.get(data, "grid-coin_spawn-x")
        : (-1.5 + random(4))),
      y: viewY + (Struct.get(data, "grid-coin_use-spawn-y")
        ? Struct.get(data, "grid-coin_spawn-y")
        : (-2.5 + random(4))),
    }
    
    controller.coinService.send(new Event("spawn-coin", coin))
  },
  "brush_grid_config": function(data) {
    var controller = Beans.get(BeanVisuController)
    if (Struct.get(data, "grid-config_use-render-grid")) {
      controller.gridService.properties.renderGrid = Struct
        .get(data, "grid-config_render-grid")
    }

    if (Struct.get(data, "grid-config_use-render-grid-elements")) {
      controller.gridService.properties.renderElements = Struct
        .get(data, "grid-config_render-grid-elements")
    }
    
    if (Struct.get(data, "grid-config_use-speed")) {
      var transformer = Struct.get(data, "grid-config_speed")
      controller.gridService.send(new Event("transform-property", {
        key: "speed",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.speed,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "grid-config_use-clear-frame")) {
      controller.gridService.properties.gridClearFrame = Struct
        .get(data, "grid-config_clear-frame")
    }

    if (Struct.get(data, "grid-config_use-clear-color") == true) {
      controller.gridService.send(new Event("transform-property", {
        key: "gridClearColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.gridClearColor.toHex(true),
          target: Struct.get(data, "grid-config_clear-color"),
          factor: 0.01,
        })
      }))
    }
    
    if (Struct.get(data, "grid-config_use-clear-frame-alpha") == true) {
      var transformer = Struct.get(data, "grid-config_clear-frame-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "gridClearFrameAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.gridClearFrameAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-gamemode") == true) {
      controller.send(new Event("change-gamemode")
        .setData(GameMode.get(Struct.get(data, "grid-config_gamemode"))))
    }

    if (Struct.get(data, "grid-config_use-border-bottom-color")) {
      controller.gridService.send(new Event("transform-property", {
        key: "borderVerticalColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.borderVerticalColor.toHex(true),
          target: Struct.get(data, "grid-config_border-bottom-color"),
          factor: Struct.getDefault(data, "grid-config_border-bottom-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-bottom-alpha")) {
      var transformer = Struct.get(data, "grid-config_border-bottom-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "borderVerticalAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderVerticalAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-bottom-size")) {
      var transformer = Struct.get(data, "grid-config_border-bottom-size")
      controller.gridService.send(new Event("transform-property", {
        key: "borderVerticalThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderVerticalThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-horizontal-color")) {
      controller.gridService.send(new Event("transform-property", {
        key: "borderHorizontalColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.borderHorizontalColor.toHex(true),
          target: Struct.get(data, "grid-config_border-horizontal-color"),
          factor: Struct.getDefault(data, "grid-config_border-horizontal-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-horizontal-alpha")) {
      var transformer = Struct.get(data, "grid-config_border-horizontal-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "borderHorizontalAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderHorizontalAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-horizontal-size")) {
      var transformer = Struct.get(data, "grid-config_border-horizontal-size")
      controller.gridService.send(new Event("transform-property", {
        key: "borderHorizontalThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderHorizontalThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-horizontal-width")) {
      var transformer = Struct.get(data, "grid-config_border-horizontal-width")
      controller.gridService.send(new Event("transform-property", {
        key: "borderHorizontalLength",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderHorizontalLength,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_use-border-horizontal-height")) {
      var transformer = Struct.get(data, "grid-config_border-horizontal-height")
      controller.gridService.send(new Event("transform-property", {
        key: "borderVerticalLength",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.borderVerticalLength,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-config_clear-player")) {
      controller.playerService.send(new Event("clear-player"))
    }

    if (Struct.get(data, "grid-config_clear-bullets")) {
      controller.bulletService.send(new Event("clear-bullets"))
    }

    if (Struct.get(data, "grid-config_clear-coins")) {
      controller.coinService.send(new Event("clear-coins"))
    }
  },
  "brush_grid_particle": function(data) {
    var particleService = Beans.get(BeanVisuController).particleService
    particleService.send(particleService
      .factoryEventSpawnParticleEmitter(
        {
          particleName: Struct.get(data, "grid-particle_template"),
          beginX: Struct.get(data, "grid-particle_beginX") * GRID_SERVICE_PIXEL_WIDTH,
          beginY: Struct.get(data, "grid-particle_beginY") * GRID_SERVICE_PIXEL_HEIGHT,
          endX: Struct.get(data, "grid-particle_endX") * GRID_SERVICE_PIXEL_WIDTH,
          endY: Struct.get(data, "grid-particle_endY") * GRID_SERVICE_PIXEL_HEIGHT,
          amount: Struct.get(data, "grid-particle_amount"),
          interval: Struct.get(data, "grid-particle_interval"),
          duration: Struct.get(data, "grid-particle_duration"),
          shape: ParticleEmitterShape
            .get(Struct.get(data, "grid-particle_shape")),
          distribution: ParticleEmitterDistribution
            .get(Struct.get(data, "grid-particle_distribution")),
        }, 
      ))
  },
  "brush_grid_player": function(data) {
    var controller = Beans.get(BeanVisuController)
    var json = {
      sprite: Struct.get(data, "grid-player_texture")
    }

    if (Struct.get(data, "grid-player_use-mask")) {
      Struct.set(json, "mask", Struct.get(data, "grid-player_mask"))
    }

    if (Struct.get(data, "grid-player_use-reset-position")) {
      Struct.set(json, "reset-position", Struct.get(data, "grid-player_reset-position") == true)
    }

    if (Struct.get(data, "grid-player_use-stats")) {
      Struct.set(json, "stats", Struct.get(data, "grid-player_stats"))
    }

    if (Struct.get(data, "grid-player_use-racing")) {
      Struct.set(json, "racing", Struct
        .get(data, "grid-player_racing"))
    }

    if (Struct.get(data, "grid-player_use-bullet-hell")) {
      Struct.set(json, "bulletHell", Struct
        .get(data, "grid-player_bullet-hell"))
    }

    if (Struct.get(data, "grid-player_use-platformer")) {
      Struct.set(json, "platformer", Struct
        .get(data, "grid-player_platformer"))
    }

    controller.playerService.send(new Event("spawn-player", json))

    if (Struct.get(data, "grid-player_use-transform-player-z")) {
      var gridService = controller.gridService
      var transformer = Struct.get(data, "grid-player_transform-player-z")
      gridService.send(new Event("transform-property", {
        key: "playerZ",
        container: gridService.properties.depths,
        executor: gridService.executor,
        transformer: new NumberTransformer({
          value: gridService.properties.depths.playerZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-player_use-margin")) {
      controller.gridService.targetLocked.margin.top = Struct
        .get(data, "grid-player_margin-top")
      controller.gridService.targetLocked.margin.right = Struct
        .get(data, "grid-player_margin-right")
      controller.gridService.targetLocked.margin.bottom = Struct
        .get(data, "grid-player_margin-bottom")
      controller.gridService.targetLocked.margin.left = Struct
        .get(data, "grid-player_margin-left")
    }
  },
  "brush_grid_separator": function(data) {
    var controller = Beans.get(BeanVisuController)
    if (Struct.get(data, "grid-separator_use-transform-amount") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-amount")
      controller.gridService.send(new Event("transform-property", {
        key: "separators",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.separators,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-transform-z") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-z")
      controller.gridService.send(new Event("transform-property", {
        key: "separatorZ",
        container: controller.gridService.properties.depths,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.depths.channelZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-primary-color") == true) {
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsPrimaryColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.separatorsPrimaryColor.toHex(true),
          target: Struct.get(data, "grid-separator_primary-color"),
          factor: Struct.getDefault(data, "grid-separator_primary-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-transform-primary-alpha") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-primary-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsPrimaryAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.separatorsPrimaryAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-transform-primary-size") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-primary-size")
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsPrimaryThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.separatorsPrimaryThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
    
    if (Struct.get(data, "grid-separator_use-secondary-color") == true) {
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsSecondaryColor",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new ColorTransformer({
          value: controller.gridService.properties.separatorsSecondaryColor.toHex(true),
          target: Struct.get(data, "grid-separator_secondary-color"),
          factor: Struct.getDefault(data, "grid-separator_secondary-color-speed", 0.01),
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-transform-secondary-alpha") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-secondary-alpha")
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsSecondaryAlpha",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.separatorsSecondaryAlpha,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "grid-separator_use-transform-secondary-size") == true) {
      var transformer = Struct.get(data, "grid-separator_transform-secondary-size")
      controller.gridService.send(new Event("transform-property", {
        key: "separatorsSecondaryThickness",
        container: controller.gridService.properties,
        executor: controller.gridService.executor,
        transformer: new NumberTransformer({
          value: controller.gridService.properties.separatorsSecondaryThickness,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
  },
}
#macro grid_track_event global.__grid_track_event
