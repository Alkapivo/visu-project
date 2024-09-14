///@package io.alkapivo.visu.service.track

///@static
///@type {Struct}
global.__shroom_track_event = {
  "brush_shroom_spawn": function(data) {
    var controller = Beans.get(BeanVisuController)
    var shroom = {
      template: Struct.get(data, "shroom-spawn_template"),
      spawnX: Struct.get(data, "shroom-spawn_use-spawn-x")
        ? Struct.get(data, "shroom-spawn_spawn-x")
        : -1.5 + random(4),
      spawnY: Struct.get(data, "shroom-spawn_use-spawn-y")
        ? Struct.get(data, "shroom-spawn_spawn-y")
        : -2.5 + random(4),
      angle: Struct.get(data, "shroom-spawn_angle"),
      speed: Struct.get(data, "shroom-spawn_speed"),
      snapH: Struct.getDefault(data, "shroom-spawn_use-snap-h", false),
      snapV: Struct.getDefault(data, "shroom-spawn_use-snap-v", false),
    }
    controller.shroomService.send(new Event("spawn-shroom", shroom))
  
    ///@ecs
    /*
    var controller = Beans.get(BeanVisuController)
    controller.gridECS.add(new GridEntity({
      type: GridEntityType.ENEMY,
      position: { 
        x: controller.gridService.view.x + Struct.get(data, "shroom-spawn_spawn-x"), 
        y: controller.gridService.view.y + Struct.get(data, "shroom-spawn_spawn-y"),
      },
      velocity: { 
        speed: Struct.get(data, "shroom-spawn_speed") / 1000, 
        angle: Struct.get(data, "shroom-spawn_angle"),
      },
      renderSprite: { name: "texture_baron" },
    }))
    */
  },
  "brush_shroom_clear": function(data) {
    var shroomService = Beans.get(BeanVisuController).shroomService
    var shrooms = shroomService.shrooms
    if (Struct.get(data, "shroom-clear_use-clear-all-shrooms")) {
      shrooms.clear()
    }

    if (Struct.get(data, "shroom-clear_use-clear-amount")) {
      var amount = Struct.get(data, "shroom-clear_clear-amount")
      if (amount >= shrooms.size()) {
        shrooms.clear()
      } else {
        for (var index = 0; index < amount; index++) {
          var pointer = shrooms.size() - 1
          if (pointer > 0) {
            shroomService.shrooms.remove(pointer)
          }
        }
      }
    }
  },
  "brush_shroom_config": function(data) {
    var gridService = Beans.get(BeanVisuController).gridService
    if (Struct.get(data, "shroom-config_use-render-shrooms")) {
      gridService.properties.renderShrooms = Struct
        .get(data, "shroom-config_render-shrooms")
    }

    if (Struct.get(data, "shroom-config_use-transform-shroom-z")) {
      var transformer = Struct.get(data, "shroom-config_transform-shroom-z")
      gridService.send(new Event("transform-property", {
        key: "shroomZ",
        container: gridService.properties.depths,
        executor: gridService.executor,
        transformer: new NumberTransformer({
          value: gridService.properties.depths.shroomZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "shroom-config_use-render-bullets")) {
      gridService.properties.renderBullets = Struct
        .get(data, "shroom-config_render-bullets")
    }

    if (Struct.get(data, "shroom-config_use-transform-bullet-z")) {
      var transformer = Struct.get(data, "shroom-config_transform-bullet-z")
      gridService.send(new Event("transform-property", {
        key: "bulletZ",
        container: gridService.properties.depths,
        executor: gridService.executor,
        transformer: new NumberTransformer({
          value: gridService.properties.depths.bulletZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }

    if (Struct.get(data, "shroom-config_use-render-coins")) {
      gridService.properties.renderCoins = Struct
        .get(data, "shroom-config_render-coins")
    }

    if (Struct.get(data, "shroom-config_use-transform-coin-z")) {
      var transformer = Struct.get(data, "shroom-config_transform-coin-z")
      gridService.send(new Event("transform-property", {
        key: "coinZ",
        container: gridService.properties.depths,
        executor: gridService.executor,
        transformer: new NumberTransformer({
          value: gridService.properties.depths.coinZ,
          target: transformer.target,
          factor: transformer.factor,
          increase: transformer.increase,
        })
      }))
    }
  },
}
#macro shroom_track_event global.__shroom_track_event
