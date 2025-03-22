
///@type {Number}
#macro SHROOM_SPAWN_CHANNEL_AMOUNT 50

///@type {Number}
#macro SHROOM_SPAWN_CHANNEL_SIZE 8

///@type {Number}
#macro SHROOM_SPAWN_ROW_AMOUNT 50

///@type {Number}
#macro SHROOM_SPAWN_ROW_SIZE 8

///@type {Struct}
global.__entity_track_event = {
  "brush_entity_shroom": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-shr_preview": Struct.parse.boolean(data, "en-shr_preview"),
        "en-shr_template": Struct.parse.text(data, "en-shr_template", "shroom-default"),
        "en-shr_spd": Struct.parse.number(data, "en-shr_spd", 10.0, 0.0, 99.9),
        "en-shr_use-spd-rng": Struct.parse.boolean(data, "en-shr_use-spd-rng"),
        "en-shr_spd-rng": Struct.parse.number(data, "en-shr_spd-rng", 0.0, 0.0, 99.9),
        "en-shr_dir": Struct.parse.number(data, "en-shr_dir", 270.0, 0.0, 360.0),
        "en-shr_use-dir-rng": Struct.parse.boolean(data, "en-shr_use-dir-rng"),
        "en-shr_dir-rng": Struct.parse.number(data, "en-shr_dir-rng", 0.0, 0.0, 360.0),
        "en-shr_x": Struct.parse.number(data, "en-shr_x", 0.0, 
          -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0), 
          SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
        "en-shr_snap-x": Struct.parse.boolean(data, "en-shr_snap-x"),
        "en-shr_use-rng-x": Struct.parse.boolean(data, "en-shr_use-rng-x"),
        "en-shr_rng-x": Struct.parse.number(data, "en-shr_rng-x", 0.0, 
          0.0,
          SHROOM_SPAWN_CHANNEL_AMOUNT),
        "en-shr_y": Struct.parse.number(data, "en-shr_y", 0.0,
          -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2.0),
          SHROOM_SPAWN_ROW_AMOUNT / 2.0),
        "en-shr_snap-y": Struct.parse.boolean(data, "en-shr_snap-y"),
        "en-shr_use-rng-y": Struct.parse.boolean(data, "en-shr_use-rng-y"),
        "en-shr_rng-y": Struct.parse.number(data, "en-shr_rng-y", 0.0,
          0.0,
          SHROOM_SPAWN_ROW_AMOUNT),
        "en-shr_use-texture": Struct.parse.boolean(data, "en-shr_use-texture"),
        "en-shr_texture": Struct.parse.sprite(data, "en-shr_texture"),
        "en-shr_use-mask": Struct.parse.boolean(data, "en-shr_use-mask"),
        "en-shr_mask": Struct.parse.rectangle(data, "en-shr_mask"),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)

      ///@description feature TODO entity.shroom.spawn
      //controller.shroomService.send(new Event("spawn-shroom", {
      //  template: Struct.get(data, "en-shr_template"),
      //  speed: abs(Struct.get(data, "en-shr_spd")
      //    + (Struct.get(data, "en-shr_use-spd-rng")
      //      ? (random(Struct.get(data, "en-shr_spd-rng") / 2.0)
      //        * choose(1.0, -1.0))
      //      : 0.0)),
      //  angle: Math.normalizeAngle(Struct.get(data, "en-shr_dir")
      //    + (Struct.get(data, "en-shr_use-dir-rng")
      //      ? (random(Struct.get(data, "en-shr_dir-rng") / 2.0)
      //      * choose(1.0, -1.0))
      //    : 0.0)),
      //  spawnX: Struct.get(data, "en-shr_x")
      //    * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
      //    + 0.5
      //    + (Struct.get(data, "en-shr_use-rng-x")
      //      ? (random(Struct.get(data, "en-shr_rng-x") / 2.0)
      //        * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
      //        * choose(1.0, -1.0))
      //      : 0.0),
      //  snapH: Struct.getDefault(data, "en-shr_snap-x", false),
      //  spawnY: Struct.get(data, "en-shr_y")
      //    * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
      //    - 0.5
      //    + (Struct.get(data, "en-shr_use-rng-y")
      //      ? (random(Struct.get(data, "en-shr_rng-y") / 2.0)
      //        * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
      //        * choose(1.0, -1.0))
      //      : 0.0),
      //  snapV: Struct.getDefault(data, "en-shr_snap-y", false),
      //}))
      
      var spd = abs(Struct.get(data, "en-shr_spd")
        + (Struct.get(data, "en-shr_use-spd-rng")
          ? (random(Struct.get(data, "en-shr_spd-rng") / 2.0)
            * choose(1.0, -1.0))
          : 0.01))
      var angle = Math.normalizeAngle(Struct.get(data, "en-shr_dir")
        + (Struct.get(data, "en-shr_use-dir-rng")
          ? (random(Struct.get(data, "en-shr_dir-rng") / 2.0)
          * choose(1.0, -1.0))
        : 0.0)),
      var spawnX = Struct.get(data, "en-shr_x")
        * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
        + 0.5
        + (Struct.get(data, "en-shr_use-rng-x")
          ? (random(Struct.get(data, "en-shr_rng-x") / 2.0)
            * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapH = Struct.getDefault(data, "en-shr_snap-x", false)
      var spawnY = Struct.get(data, "en-shr_y")
        * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
        - 0.5
        + (Struct.get(data, "en-shr_use-rng-y")
          ? (random(Struct.get(data, "en-shr_rng-y") / 2.0)
            * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapV = Struct.getDefault(data, "en-shr_snap-y", false)
      controller.shroomService.spawnShroom(
        Struct.get(data, "en-shr_template"),
        spawnX,
        spawnY,
        angle,
        spd,
        snapH,
        snapV
      )

      ///@description ecs
      /*
      var controller = Beans.get(BeanVisuController)
      controller.gridECS.add(new GridEntity({
        type: GridEntityType.ENEMY,
        position: { 
          x: controller.gridService.view.x
            + (Struct.get(data, "en-shr_x") 
              * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) 
              + 0.5),
          y: controller.gridService.view.y
            + (Struct.get(data, "en-shr_y") 
              * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) 
              - 0.5),
        },
        velocity: { 
          speed: Struct.get(data, "en-shr_spd") / 1000, 
          angle: Struct.get(data, "en-shr_dir"),
        },
        renderSprite: { name: "texture_baron" },
      }))
      */
    },
  },
  "brush_entity_coin": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-coin_preview": Struct.parse.boolean(data, "en-coin_preview"),
        "en-coin_template": Struct.parse.text(data, "en-coin_template", "coin-default"),
        "en-coin_x": Struct.parse.number(data, "en-coin_x", 0.0,
          -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
          SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
        "en-coin_snap-x": Struct.parse.boolean(data, "en-coin_snap-x"),
        "en-coin_use-rng-x": Struct.parse.boolean(data, "en-coin_use-rng-x"),
        "en-coin_rng-x": Struct.parse.number(data, "en-coin_rng-x", 0.0,
          0.0,
          SHROOM_SPAWN_CHANNEL_AMOUNT),
        "en-coin_y": Struct.parse.number(data, "en-coin_y", 0.0,
          -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2.0),
          SHROOM_SPAWN_ROW_AMOUNT / 2.0),
        "en-coin_snap-y": Struct.parse.boolean(data, "en-coin_snap-y"),
        "en-coin_use-rng-y": Struct.parse.boolean(data, "en-coin_use-rng-y"),
        "en-coin_rng-y": Struct.parse.number(data, "en-coin_rng-y", 0.0,
          0.0, 
          SHROOM_SPAWN_ROW_AMOUNT),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var view = controller.gridService.view
      var viewX = Struct.get(data, "en-coin_snap-x")
        ? floor(view.x / (view.width / 2.0)) * (view.width / 2.0)
        : view.x
      var viewY = Struct.get(data, "en-coin_snap-y")
        ? floor(view.y / (view.height / 2.0)) * (view.height / 2.0)
        : view.y

      ///@description feature TODO entity.coin.spawn
      controller.coinService.send(new Event("spawn-coin", {
        template: Struct.get(data, "en-coin_template"),
        x: viewX + Struct.get(data, "en-coin_x")
          * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
          + 0.5
          + (Struct.get(data, "en-coin_use-rng-x")
            ? (random(Struct.get(data, "en-coin_rng-x") / 2.0)
              * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
        y: viewY + Struct.get(data, "en-coin_y")
          * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
          - 0.5
          + (Struct.get(data, "en-coin_use-rng-y")
            ? (random(Struct.get(data, "en-coin_rng-y") / 2.0)
              * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
      }))
    },
  },
  "brush_entity_player": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-pl_texture": Struct.parse.sprite(data, "en-pl_texture", { name: "texture_player" }),
        "en-pl_use-mask": Struct.parse.boolean(data, "en-pl_use-mask"),
        "en-pl_mask": Struct.parse.rectangle(data, "en-pl_mask"),
        "en-pl_reset-pos": Struct.parse.boolean(data, "en-pl_reset-pos"),
        "en-pl_use-stats": Struct.parse.boolean(data, "en-pl_use-stats"),
        "en-pl_stats": Struct.getIfType(data, "en-pl_stats", Struct, {
          force: { value: 0 },
          point: { value: 0 },
          bomb: { value: 5 },
          life: { value: 4 },
        }),
        "en-pl_use-bullethell": Struct.parse.boolean(data, "en-pl_use-bullethell"),
        "en-pl_bullethell": Struct.getIfType(data, "en-pl_bullethell", Struct, {
          x: {
            friction: 9.3,
            acceleration: 1.92,
            speedMax: 2.1,
          },
          y: {
            friction: 9.3,
            acceleration: 1.92,
            speedMax: 2.1,
          },
          guns: [
            {
              angle:  90,
              bullet: "bullet_default",
              cooldown: 8.0,
              offsetX:  0.0,
              offsetY:  0.0,
              speed:  10.0,
            }
          ]
        }),
        "en-pl_use-platformer": Struct.parse.boolean(data, "en-pl_use-platformer"),
        "en-pl_platformer": Struct.getIfType(data, "en-pl_platformer", Struct, {
          x: {
            friction: 9.3,
            acceleration: 1.92,
            speedMax: 2.1,
          },
          y: {
            friction: 0.0,
            acceleration: 1.92,
            speedMax: 25.0,
          },
          jump:  {
            size:  3.5,
          }
        }),
        "en-pl_use-racing": Struct.parse.boolean(data, "en-pl_use-racing"),
        "en-pl_racing": Struct.getIfType(data, "en-pl_racing", Struct, { }),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      
      ///@description feature TODO entity.player.spawn
      controller.playerService.send(new Event("spawn-player", {
        "sprite": Struct.get(data, "en-pl_texture").serialize(),
        "mask": Struct.get(data, "en-pl_mask").serialize(),
        "reset-position": Struct.get(data, "en-pl_reset-pos")
          ? Struct.get(data, "en-pl_reset-pos")
          : false,
        "stats": Struct.get(data, "en-pl_use-stats")
          ? Struct.get(data, "en-pl_stats")
          : null,
        "bulletHell": Struct.get(data, "en-pl_use-bullethell")
          ? Struct.get(data, "en-pl_bullethell")
          : null,
        "platformer": Struct.get(data, "en-pl_use-platformer")
          ? Struct.get(data, "en-pl_platformer")
          : null,
        "racing": Struct.get(data, "en-pl_use-racing")
          ? Struct.get(data, "en-pl_racing")
          : null,
      }))
    },
  },
  "brush_entity_config": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-cfg_use-render-shr": Struct.parse.boolean(data, "en-cfg_use-render-shr"),
        "en-cfg_render-shr": Struct.parse.boolean(data, "en-cfg_render-shr"),
        "en-cfg_use-render-player": Struct.parse.boolean(data, "en-cfg_use-render-player"),
        "en-cfg_render-player": Struct.parse.boolean(data, "en-cfg_render-player"),
        "en-cfg_use-render-coin": Struct.parse.boolean(data, "en-cfg_use-render-coin"),
        "en-cfg_render-coin": Struct.parse.boolean(data, "en-cfg_render-coin"),
        "en-cfg_use-render-bullet": Struct.parse.boolean(data, "en-cfg_use-render-bullet"),
        "en-cfg_render-bullet": Struct.parse.boolean(data, "en-cfg_render-bullet"),
        "en-cfg_cls-shr": Struct.parse.boolean(data, "en-cfg_cls-shr"),
        "en-cfg_cls-player": Struct.parse.boolean(data, "en-cfg_cls-player"),
        "en-cfg_cls-coin": Struct.parse.boolean(data, "en-cfg_cls-coin"),
        "en-cfg_cls-bullet": Struct.parse.boolean(data, "en-cfg_cls-bullet"),
        "en-cfg_use-z-shr": Struct.parse.boolean(data, "en-cfg_use-z-shr"),
        "en-cfg_z-shr": Struct.parse.numberTransformer(data, "en-cfg_z-shr", {
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "en-cfg_change-z-shr": Struct.parse.boolean(data, "en-cfg_change-z-shr"),
        "en-cfg_use-z-player": Struct.parse.boolean(data, "en-cfg_use-z-player"),
        "en-cfg_z-player": Struct.parse.numberTransformer(data, "en-cfg_z-player", {
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "en-cfg_change-z-player": Struct.parse.boolean(data, "en-cfg_change-z-player"),
        "en-cfg_use-z-coin": Struct.parse.boolean(data, "en-cfg_use-z-coin"),
        "en-cfg_z-coin": Struct.parse.numberTransformer(data, "en-cfg_z-coin", {
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "en-cfg_change-z-coin": Struct.parse.boolean(data, "en-cfg_change-z-coin"),
        "en-cfg_use-z-bullet": Struct.parse.boolean(data, "en-cfg_use-z-bullet"),
        "en-cfg_z-bullet":Struct.parse.numberTransformer(data, "en-cfg_z-bullet", {
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "en-cfg_change-z-bullet": Struct.parse.boolean(data, "en-cfg_use-render-shr"),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor
      var depths = properties.depths

      ///@description feature TODO grid.shroom.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-shr",
        "en-cfg_render-shr",
        "renderShrooms",
        properties)

      ///@description feature TODO grid.player.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-player",
        "en-cfg_render-player",
        "renderPlayer",
        properties)

      ///@description feature TODO grid.coin.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-coin",
        "en-cfg_render-coin",
        "renderCoins",
        properties)

      ///@description feature TODO grid.bullet.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-bullet",
        "en-cfg_render-bullet",
        "renderBullets",
        properties)

      ///@description feature TODO grid.shroom.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-shr",
        "clear-shrooms",
        null,
        controller.shroomService.dispatcher)

      ///@description feature TODO grid.player.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-player",
        "clear-player",
        null,
        controller.playerService.dispatcher)

      ///@description feature TODO grid.coin.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-coin",
        "clear-coins",
        null,
        controller.coinService.dispatcher)

      ///@description feature TODO grid.bullets.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-bullet",
        "clear-bullets",
        null,
        controller.bulletService.dispatcher)

      ///@description feature TODO grid.shroom.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-shr",
        "en-cfg_z-shr",
        "en-cfg_change-z-shr",
        "shroomZ",
        depths, pump, executor)

      ///@description feature TODO grid.player.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-player",
        "en-cfg_z-player",
        "en-cfg_change-z-player",
        "playerZ",
        depths, pump, executor)

      ///@description feature TODO grid.coin.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-coin",
        "en-cfg_z-coin",
        "en-cfg_change-z-coin",
        "coinZ",
        depths, pump, executor)

      ///@description feature TODO grid.bullet.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-bullet",
        "en-cfg_z-bullet",
        "en-cfg_change-z-bullet",
        "bulletZ",
        depths, pump, executor)
    },
  },
}
#macro entity_track_event global.__entity_track_event
