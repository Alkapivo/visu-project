///@package io.alkapivo.visu.

///@param {VisuController} _controller
function GridSystem(_controller) constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Struct}
  systems = {
    movement: new MovementSystem(this),
    collision: new CollisionSystem(this),
  }

  ///@type {Struct}
  entities = {
    keys: new Map(String, String),
    bullets: new Map(String, GridEntity),
    enemies: new Map(String, GridEntity),
    players: new Map(String, GridEntity),
    gc: new Stack(String),

    ///@param {String} key
    ///@return {?GridEntity}
    get: function(key) {
      return this.keys.contains(key)
        ? this.getEntities(this.keys.get(key)).get(key)
        : null
    },

    ///@param {String} type
    ///@throws {Exception}
    ///@return {Map<String, GridEntity>}
    getEntities: function(type) {
      switch (type) {
        case "bullet": return this.bullets
        case "enemy": return this.enemies
        case "player": return this.players
        default: throw new Exception("Found not implemented entity type")
      }
    },

    ///@param {GridEntity}
    add: function(entity) {
      var entities = this.getEntities(entity.type)
      var key = this.keys.generateKey()
      this.keys.add(entity.type, key)
      entities.add(entity.setKey(key), key)
    },

    ///@param {String}
    remove: function(key) {
      if (this.keys.contains(key)) {
        this.getEntities(this.keys.get(key)).remove(key)
      }
    }
  }

  ///@param {GridEntity} entity
  ///@return {GridSystem}
  static add = function(entity) {
    this.entities.add(entity)
    return this
  }

  ///@param {String} key
  ///@return {GridSystem}
  static remove = function(key) {
    this.entities.remove(key)
    return this
  }

  ///@param {GridEntity} entity
  static renderEntity = function(entity, key, view) {
    entity.renderSprite.sprite.render(
      (entity.position.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
      (entity.position.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT
    )
  }


  ///@param {GridEntity} entity
  static freeEntity = function(entity) {
    entity.free()
  }

  ///@return {GridSystem}
  static update = function() {
    this.systems.movement.update()
    this.systems.collision.update()

    if (this.entities.gc.size() > 0) {
      this.entities.gc.forEach(function(key, index, context) {
        context.remove(key)
      }, this)
    }


    /*
    if (keyboard_check_pressed(vk_space)) {
      var gridService = Beans.get(BeanVisuController).gridService
      this.add(new GridEntity({
        type: GridEntityType.ENEMY,
        position: { x: gridService.view.x + 0.75, y: gridService.view.y + 0.0 },
        velocity: { speed: 3 / 1000, angle: 260 },
        renderSprite: { name: "texture_baron" },
      }))
    }
    */

    return this
  }

  static render = function() {
    this.entities.bullets.forEach(this.renderEntity, this.controller.gridService.view)
    this.entities.enemies.forEach(this.renderEntity, this.controller.gridService.view)
    this.entities.players.forEach(this.renderEntity, this.controller.gridService.view)
  }

  ///@return {GridSystem}
  static free = function() {
    this.entities.clear()
    this.entities.bullets.forEach(this.freeEntity).clear()
    this.entities.enemies.forEach(this.freeEntity).clear()
    this.entities.players.forEach(this.freeEntity).clear()
    return this
  }
}
