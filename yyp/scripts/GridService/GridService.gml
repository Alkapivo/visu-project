///@package io.alkapivo.visu.service.grid

///@type {Number}
global.__GRID_SERVICE_PIXEL_WIDTH = 2048
#macro GRID_SERVICE_PIXEL_WIDTH global.__GRID_SERVICE_PIXEL_WIDTH

///@type {Number}
global.__GRID_SERVICE_PIXEL_HEIGHT = 2048
#macro GRID_SERVICE_PIXEL_HEIGHT global.__GRID_SERVICE_PIXEL_HEIGHT

///@type {Number}
global.__GRID_ITEM_FRUSTUM_RANGE = 3.5
#macro GRID_ITEM_FRUSTUM_RANGE global.__GRID_ITEM_FRUSTUM_RANGE


///@param {VisuController} _controller
///@param {Struct} [_config]
function GridService(_controller, _config = {}): Service(_config) constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Struct}
  config = JSON.clone(_config)

  ///@type {Number}
  width = Assert.isType(Struct
    .getDefault(this.config, "width", 1000000.0), Number)

  ///@type {Number}
  height = Assert.isType(Struct
    .getDefault(this.config, "height", 100.0), Number)

  ///@type {Number}
  pixelWidth = Assert.isType(Struct
    .getDefault(this.config, "pixelWidth", GRID_SERVICE_PIXEL_WIDTH), Number)

  ///@type {Number}
  pixelHeight = Assert.isType(Struct
    .getDefault(this.config, "pixelHeight", GRID_SERVICE_PIXEL_HEIGHT), Number)

  ///@type {GridView}
  view = new GridView({ 
    worldWidth: this.width, 
    worldHeight: this.height,
  })
  ///@description (set camera on middle bottom)
  this.view.x = (this.width - this.view.width) / 2.0
	this.view.y = this.height - this.view.height

  ///@type {Struct}
  targetLocked = {
    x: this.view.x,
    y: this.view.y,
    setX: function(x) {
      this.x = x
      return this
    },
    setY: function(y) {
      this.y = y
      return this
    },
  }

  ///@type {Struct}
  properties = Optional.is(Struct.get(this.config, "properties"))
    ? new GridProperties(this.config.properties)
    : new GridProperties()
  
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "transform-property": Callable.run(Struct.get(EVENT_DISPATCHERS, "transform-property")),
    "fade-sprite": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-sprite")),
    "fade-color": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-color")),
    "clear-grid": function(event) {

      this.view.x = (this.width - this.view.width) / 2.0
	    this.view.y = this.height - this.view.height
      
      this.targetLocked = {
        x: this.view.x,
        y: this.view.y,
        setX: function(x) {
          this.x = x
          return this
        },
        setY: function(y) {
          this.y = y
          return this
        },
      }

      properties = Optional.is(Struct.get(this.config, "properties"))
        ? new GridProperties(this.config.properties)
        : new GridProperties()
    },
  }))

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)
  
  ///@private
  ///@return {GridService}
  moveGridItems = function() {
    static moveGridItem = function(gridItem, key, view) {
      gridItem.move()
      var length = Math.fetchLength(
        gridItem.x, gridItem.y,
        view.x + (view.width / 2.0), 
        view.y + (view.height / 2.0)
      )

      if (length > GRID_ITEM_FRUSTUM_RANGE) {
        gridItem.signal("kill")
      }
    }

    this.controller.bulletService.bullets.forEach(moveGridItem, this.controller.gridService.view)
    this.controller.shroomService.shrooms.forEach(moveGridItem, this.controller.gridService.view)
    var player = this.controller.playerService.player
    if (Core.isType(player, Player)) {
      player.move()
    }
    return this
  }

  ///@private
  ///@return {GridService}
  signalGridItemsCollision = function() {
    static bulletCollision = function(bullet, index, context) {
      static playerBullet = function(shroom, index, bullet) {
        if (shroom.collide(bullet)) {
          shroom.signal("bulletCollision", bullet)
          bullet.signal("shroomCollision", shroom)
        }
      }
      static shroomBullet = function(player, bullet) {
        if (player.collide(bullet)) {
          player.signal("bulletCollision", bullet)
          bullet.signal("playerCollision", player)
        }
      }

      switch (bullet.producer) {
        case Player:
          context.controller.shroomService.shrooms.forEach(playerBullet, bullet)
          break
        case Shroom:
          shroomBullet(context.controller.playerService.player, bullet)
          break
        default:
          Logger.warn("GridService", "Found invalid bullet producer")
          break
      }
    }

    static shroomCollision = function(shroom, index, player) {
      if (shroom.collide(player)) {
        shroom.signal("playerCollision", player)
        player.signal("shroomCollision", shroom)
      }
    }
    
    var player = this.controller.playerService.player
    if (Core.isType(player, Player)) {
      this.controller.bulletService.bullets.forEach(bulletCollision, this) 
      this.controller.shroomService.shrooms.forEach(shroomCollision, player)
    }
    
    return this
  }

  ///@private
  ///@return {GridService}
  updateGridItems = function() {
    this.controller.playerService.update(this)
    this.controller.shroomService.update(this)
    this.controller.bulletService.update(this)
    return this
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {GridService}
  update = function() {

    this.properties.update(this)
    this.dispatcher.update()
    this.executor.update()

    var player = this.controller.playerService.player
    if (Core.isType(player, Player)) {
      this.targetLocked.setX(player.x)
      this.targetLocked.setY(player.y)
    }

    if (this.controller.editor.store.getValue("target-locked-x")) {
      this.targetLocked.setX((this.view.width * floor(this.view.x / this.view.width)) 
        + (this.view.width / 2))
    }

    if (this.controller.editor.store.getValue("target-locked-y")) {
      this.targetLocked.setY((this.view.height * floor(this.view.y / this.view.height)) 
        + (this.view.height / 2))
    }

    this.view
      .setFollowTarget(this.targetLocked)
      .update()
    
    this.moveGridItems()
      .signalGridItemsCollision()
      .updateGridItems()
    return this
  }
}
