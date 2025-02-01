///@package io.alkapivo.visu.service.track._old

///@static
///@type {Struct}
global.__shroom_track_event = {
  "brush_shroom_spawn": {
    parse: function(data) {
      return Struct.appendUnique({ "icon": Struct.parse.sprite(data, "icon") }, data, false)
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var shroom = {
        template: Struct.get(data, "shroom-spawn_template"),
        speed: abs(Struct.get(data, "shroom-spawn_speed")
          + (Struct.get(data, "shroom-spawn_use-speed-rng")
            ? (random(Struct.get(data, "shroom-spawn_speed-rng") / 2.0)
              * choose(1.0, -1.0))
            : 0.0)),
        angle: Math.normalizeAngle(Struct.get(data, "shroom-spawn_angle")
          + (Struct.get(data, "shroom-spawn_use-angle-rng")
            ? (random(Struct.get(data, "shroom-spawn_angle-rng") / 2.0)
            * choose(1.0, -1.0))
          : 0.0)),
        spawnX: Struct.get(data, "shroom-spawn_channel")
          * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
          + 0.5
          + (Struct.get(data, "shroom-spawn_use-channel-rng")
            ? (random(Struct.get(data, "shroom-spawn_channel-rng") / 2.0)
              * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
        snapH: Struct.getDefault(data, "shroom-spawn_channel-snap", false),
        spawnY: Struct.get(data, "shroom-spawn_row")
          * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
          - 0.5
          + (Struct.get(data, "shroom-spawn_use-row-rng")
            ? (random(Struct.get(data, "shroom-spawn_row-rng") / 2.0)
              * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
        snapV: Struct.getDefault(data, "shroom-spawn_row-snap", false),
      }

      controller.shroomService.send(new Event("spawn-shroom", shroom))
      
      ///@description ecs
      /*
      var controller = Beans.get(BeanVisuController)
      controller.gridECS.add(new GridEntity({
        type: GridEntityType.ENEMY,
        position: { 
          x: controller.gridService.view.x
            + (Struct.get(data, "shroom-spawn_channel") 
              * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) 
              + 0.5),
          y: controller.gridService.view.y
            + (Struct.get(data, "shroom-spawn_row") 
              * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) 
              - 0.5),
        },
        velocity: { 
          speed: Struct.get(data, "shroom-spawn_speed") / 1000, 
          angle: Struct.get(data, "shroom-spawn_angle"),
        },
        renderSprite: { name: "texture_baron" },
      }))
      */
    },
  },
  "brush_shroom_clear": {
    parse: function(data) {
      return Struct.appendUnique({ "icon": Struct.parse.sprite(data, "icon") }, data, false)
    },
    run: function(data) {
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
  },
  "brush_shroom_config": {
    parse: function(data) {
      return Struct.appendUnique({ "icon": Struct.parse.sprite(data, "icon") }, data, false)
    },
    run: function(data) {
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

      if (Struct.get(data, "shroom-config_clear-shrooms")) {
        Beans.get(BeanVisuController).shroomService.send(new Event("clear-shrooms"))
      }
    },
  },
}
#macro shroom_track_event global.__shroom_track_event