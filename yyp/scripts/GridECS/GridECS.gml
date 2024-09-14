///@package io.alkapivo.visu.

///@param {VisuController} _controller
function GridECS(_controller) constructor {

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
    coins: new Map(String, GridEntity),
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
        case "coin": return this.coin
        default: throw new Exception($"Found not implemented entity type: {type}")
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
  ///@return {GridECS}
  static add = function(entity) {
    this.entities.add(entity)
    return this
  }

  ///@param {String} key
  ///@return {GridECS}
  static remove = function(key) {
    this.entities.remove(key)
    return this
  }

  ///@private
  ///@param {GridEntity} entity
  ///@param {any} iterator
  ///@param {GridView} view
  static renderEntity = function(entity, iterator, view) {
    //Core.print("renderEntity", iterator, "___", entity.position.x, entity.position.y)
    entity.renderSprite.sprite.render(
      (entity.position.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
      (entity.position.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT
    )
  }

  ///@private
  ///@param {String} key
  ///@param {any} iterator
  ///@param {GridECS} context
  static removeEntity = function(key, iterator, context) {
    context.remove(key)
  }

  ///@param {GridEntity} entity
  static freeEntity = function(entity) {
    entity.free()
  }

  ///@return {GridECS}
  static update = function() {

    this.systems.movement.update()
    this.systems.collision.update()

    if (this.entities.gc.size() > 0) {
      this.entities.gc.forEach(removeEntity, this)
    }

    if (keyboard_check_pressed(ord("V"))) {
      var gridService = Beans.get(BeanVisuController).gridService
      this.add(new GridEntity({
        type: GridEntityType.ENEMY,
        position: { x: gridService.view.x + 0.75, y: gridService.view.y + 0.0 },
        velocity: { speed: 3 / 1000, angle: 260 },
        renderSprite: { name: "texture_baron" },
      }))
    }

    return this
  }

  ///@type {Surface}
  gridSurface = new Surface({ width: GuiWidth(), height: GuiHeight() })

  ///@private
  ///@param {GridRenderer} renderer
  static renderGridSurface = function(acc) {
    var renderer = acc.renderer
    var system = acc.system
    var properties = renderer.controller.gridService.properties
    if (properties.gridClearFrame) {
      GPU.render.clear(properties.gridClearColor)
    }

    var depths = renderer.controller.gridService.properties.depths
      
    var cameraDistance = 1 ///@todo extract parameter
    var xto = renderer.camera.x
    var yto = renderer.camera.y
    var zto = renderer.camera.z + renderer.camera.zoom
    var xfrom = xto + cameraDistance * dcos(renderer.camera.angle) * dcos(renderer.camera.pitch)
    var yfrom = yto - cameraDistance * dsin(renderer.camera.angle) * dcos(renderer.camera.pitch)
    var zfrom = zto - cameraDistance * dsin(renderer.camera.pitch)
    var baseX = GRID_SERVICE_PIXEL_WIDTH + GRID_SERVICE_PIXEL_WIDTH * 0.5
    var baseY = GRID_SERVICE_PIXEL_HEIGHT + GRID_SERVICE_PIXEL_HEIGHT * 0.5
    renderer.camera.viewMatrix = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1)
    renderer.camera.projectionMatrix = matrix_build_projection_perspective_fov(-60, -1 * renderer.gridSurface.width / renderer.gridSurface.height, 1, 32000) ///@todo extract parameters
    camera_set_view_mat(renderer.camera.gmCamera, renderer.camera.viewMatrix)
    camera_set_proj_mat(renderer.camera.gmCamera, renderer.camera.projectionMatrix)
    camera_apply(renderer.camera.gmCamera)

    
    gpu_set_alphatestenable(true)
    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.shroomZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    system.entities.enemies.forEach(system.renderEntity, system.controller.gridService.view)
    gpu_set_alphatestenable(false)


    matrix_set(matrix_world, matrix_build_identity())
  }


  static render = function() {
    //var view = this.controller.gridService.view
    //this.entities.bullets.forEach(this.renderEntity, view)
    //this.entities.enemies.forEach(this.renderEntity, view)
    //this.entities.players.forEach(this.renderEntity, view)

    var width = GuiWidth()
    var height = GuiHeight()
    var system = this
    this.gridSurface
      .update(width, height)
      .renderOn(this.renderGridSurface, { renderer: system.controller.visuRenderer.gridRenderer, system: system })
  }

  static renderGUI = function() {
    var width = GuiWidth()
    var height = GuiHeight()
    this.gridSurface.render(0, 0)
  }

  ///@return {GridECS}
  static free = function() {
    this.entities.clear()
    this.entities.bullets.forEach(this.freeEntity).clear()
    this.entities.enemies.forEach(this.freeEntity).clear()
    this.entities.players.forEach(this.freeEntity).clear()
    return this
  }
}
