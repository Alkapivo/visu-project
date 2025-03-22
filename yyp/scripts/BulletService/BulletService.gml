///@package io.alkapivo.visu.service.bullet.BulletService

///@type {Number}
#macro BULLET_MAX_DISTANCE 3.0

global.BULLET_TEMPLATE = {
  name: "bullet_default",
  sprite: {
    name: "texture_test",
  },
  "gameModes": {
    "bulletHell": {
      "features": [
        {
          "feature": "AngleFeature",
          "value": {
            "value": 0.0,
            "target": 360.0,
            "factor": 1.0,
            "increase": 0.0
          }
        }
      ]
    }
  }
}


///@param {VisuController} _controller
///@param {Struct} [config]
function BulletService(_controller, config = {}): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Array<Bullet>}
  bullets = new Array(Bullet).enableGC()

  ///@type {Map<String, BulletTemplate>}
  templates = new Map(String, BulletTemplate)

  ///@type {?GameMode}
  gameMode = null

  ///@type {GridItemChunkService}
  chunkService = new GridItemChunkService(GRID_ITEM_CHUNK_SERVICE_SIZE)

  ///@param {String} name
  ///@return {?BulletTemplate}
  getTemplate = function(name) {
    var template = this.templates.get(name)
    return template == null
      ? Visu.assets().bulletTemplates.get(name)
      : template
  }

  ///@param {Boolean}
  optimalizationSortEntitiesByTxGroup = false

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-bullet": function(event, dispatcher) {
      var template = new BulletTemplate(event.data.template, this
        .getTemplate(event.data.template)
        .serialize())
        
      Struct.set(template, "x", event.data.x)
      Struct.set(template, "y", event.data.y)
      Struct.set(template, "angle", event.data.angle)
      Struct.set(template, "speed", event.data.speed / 1000)
      Struct.set(template, "producer", event.data.producer)
      Struct.set(template, "uid", this.controller.gridService.generateUID())

      if (event.data.producer == Shroom) {
        controller.sfxService.play("shroom-shoot")
      }
      
      var bullet = new Bullet(template)
      if (event.data.producer == Player) {
        this.chunkService.add(bullet)
      }
      //bullet.updateGameMode(this.controller.gameMode)

      this.bullets.add(bullet)

      if (this.optimalizationSortEntitiesByTxGroup) {
        this.controller.gridService.textureGroups.sortItems(this.bullets)
      }
    },
    "clear-bullets": function(event) {
      this.bullets.clear()
      this.chunkService.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear()
      this.dispatcher.container.clear()
    },
  }))

  static spawnBullet = function(name, x, y, angle, speed, producer) {
    var template = this.getTemplate(name).serializeSpawn(x, y, angle, speed / 1000.0, producer, this.controller.gridService.generateUID())
    if (producer == Shroom) {
      controller.sfxService.play("shroom-shoot")
    }
    
    var bullet = new Bullet(template)
    if (producer == Player) {
      this.chunkService.add(bullet)
    }
    //bullet.updateGameMode(this.controller.gameMode)

    this.bullets.add(bullet)

    if (this.optimalizationSortEntitiesByTxGroup) {
      this.controller.gridService.textureGroups.sortItems(this.bullets)
    }
  }

  ///@param {Event} event
  ///@return {?Promise}
  static send = function(event) {
    gml_pragma("forceinline")
    return this.dispatcher.send(event)
  }

  static updateGameMode = function(bullet, index, gameMode) {
    gml_pragma("forceinline")
    bullet.updateGameMode(gameMode)
  }

  static updateBullet = function(bullet, index, context) {
    gml_pragma("forceinline")
    bullet.update(context.controller)
    if (!bullet.signals.kill) {
      return
    }

    context.bullets.addToGC(index)
    if (bullet.producer == Player) {
      context.chunkService.remove(bullet)
    }

    if (!Optional.is(bullet.onDeath)) {
      return
    }
    
    for (var idx = 0; idx < bullet.onDeathAmount; idx++) {
      var rngDir = bullet.onDeathAngleRng ? choose(1, -1) : 1
      var rngSpd = random(bullet.onDeathRngSpeed)
      var dir = bullet.angle + (rngDir * bullet.onDeathAngle) 
        + (rngDir * idx * bullet.onDeathAngleStep) 
        + (rngDir * (random(2.0 * bullet.onDeathRngStep) - bullet.onDeathRngStep))
      var spd = clamp(abs(bullet.onDeathSpeedMerge 
        ? (rngSpd + (bullet.speed * 1000.0) + bullet.onDeathSpeed) 
        : (rngSpd + bullet.onDeathSpeed)), 0.1, 99.9)

      context.spawnBullet(
        bullet.onDeath, 
        bullet.x, 
        bullet.y,
        dir,
        spd,
        bullet.producer
      )        
      //context.send(new Event("spawn-bullet", {
      //  x: bullet.x,
      //  y: bullet.y,
      //  angle: dir,
      //  speed: spd,
      //  producer: bullet.producer,
      //  template: bullet.onDeath,
      //}))
    }
  }

  ///@return {BulletService}
  update = function() { 
    this.optimalizationSortEntitiesByTxGroup = Visu.settings.getValue("visu.optimalization.sort-entities-by-txgroup")
    if (controller.gameMode != this.gameMode) {
      this.gameMode = this.controller.gameMode
      this.bullets.forEach(this.updateGameMode, this.gameMode)
    }

    this.dispatcher.update()
    this.bullets.forEach(this.updateBullet, this).runGC()
    return this
  }
}
