///@package io.alkapivo.visu.service.grid

///@type {Number}
global.__GRID_SERVICE_PIXEL_WIDTH = 2048
#macro GRID_SERVICE_PIXEL_WIDTH global.__GRID_SERVICE_PIXEL_WIDTH


///@type {Number}
global.__GRID_SERVICE_PIXEL_HEIGHT = 2048
#macro GRID_SERVICE_PIXEL_HEIGHT global.__GRID_SERVICE_PIXEL_HEIGHT


///@type {Number}
global.__GRID_ITEM_FRUSTUM_RANGE = 5
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
    .getDefault(this.config, "width", 100000.0), Number)

  ///@type {Number}
  height = Assert.isType(Struct
    .getDefault(this.config, "height", 100000.0), Number)

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
	this.view.y = this.height - (this.view.height * 2.0)

  ///@type {Struct}
  targetLocked = {
    x: this.view.x,
    y: this.view.y,
    isLockedX: false,
    isLockedY: false,
    setX: function(x) {
      this.x = x
      return this
    },
    setY: function(y) {
      this.y = y
      return this
    },
    margin: {
      top: 0.2,
      right: 0.5,
      bottom: 0.2, 
      left: 0.5,
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
        isLockedX: false,
        isLockedY: false,
        setX: function(x) {
          this.x = x
          return this
        },
        setY: function(y) {
          this.y = y
          return this
        },
        margin: {
          top: 0.2,
          right: 0.5,
          bottom: 0.2, 
          left: 0.5,
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
  ///@type {DebugOSTimer}
  moveGridItemsTimer = new DebugOSTimer("MoveGridItems")

  ///@private
  ///@type {DebugOSTimer}
  signalGridItemsCollisionTimer = new DebugOSTimer("GrdCollission")

  ///@private
  ///@type {DebugOSTimer}
  updatePlayerServiceTimer = new DebugOSTimer("PlayerService")

  ///@private
  ///@type {DebugOSTimer}
  updateShroomServiceTimer = new DebugOSTimer("ShroomService")

  ///@private
  ///@type {DebugOSTimer}
  updateBulletServiceTimer = new DebugOSTimer("BulletService")
  
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

    static moveShroom = function(shroom, key, acc) {
      shroom.move()
      acc.shroomGrid.update(shroom)
      
      var view = acc.view
      var length = Math.fetchLength(
        shroom.x, shroom.y,
        view.x + (view.width / 2.0), 
        view.y + (view.height / 2.0)
      )

      if (length > GRID_ITEM_FRUSTUM_RANGE) {
        shroom.signal("kill")
      }
    }

    var view = this.controller.gridService.view
    var shroomGrid = this.controller.shroomService.shroomGrid
    this.controller.bulletService.bullets.forEach(moveGridItem, view)
    this.controller.shroomService.shrooms.forEach(moveShroom, {
      view: view,
      shroomGrid: shroomGrid,
    })

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
          var shroomGrid = context.controller.shroomService.shroomGrid
          var column = floor(bullet.x / shroomGrid.size)
          var row = floor(bullet.y / shroomGrid.size)
          for (var rowIndex = row - 1; rowIndex <= row + 1; rowIndex++) {
            for (var columnIndex = column - 1; columnIndex <= column + 1; columnIndex++) {
              var key = shroomGrid.toKey(column, row)
              shroomGrid.get(key).forEach(playerBullet, bullet)
            } 
          }

          //context.controller.shroomService.shrooms.forEach(playerBullet, bullet)
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
    this.updatePlayerServiceTimer.start()
    this.controller.playerService.update(this)
    this.updatePlayerServiceTimer.finish()

    this.updateShroomServiceTimer.start()
    this.controller.shroomService.update(this)
    this.updateShroomServiceTimer.finish()

    this.updateBulletServiceTimer.start()
    this.controller.bulletService.update(this)
    this.updateBulletServiceTimer.finish()
    return this
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@type {Struct}
  movement = {
    enable: false,
    angle: new NumberTransformer({ value: 90.0, target: 1.0, factor: 0.01, increase: 0.0 }),
    speed: new NumberTransformer({ value: 0.0, target: 1.0, factor: 0.01, increase: 0.0 }),
  }

  ///@override
  ///@return {GridService}
  update = function() {

    this.properties.update(this)
    this.dispatcher.update()
    this.executor.update()

    var player = this.controller.playerService.player
    if (this.movement.enable) {
      this.movement.angle.update()
      this.movement.speed.update()
      this.targetLocked.setX(this.targetLocked.x + Math
        .fetchCircleX(this.movement.speed.get() / 500.0, this.movement.angle.get()))
      this.targetLocked.setY(this.targetLocked.y + Math
        .fetchCircleY(this.movement.speed.get() / 500.0, this.movement.angle.get()))
    } else {
      if (Core.isType(player, Player)) {
        this.targetLocked.setX(player.x)
        this.targetLocked.setY(player.y)
      }

      if (this.targetLocked.isLockedX) {
        this.targetLocked.setX((this.view.width * floor(this.view.x / this.view.width)) + (this.view.width / 2))
      }
  
      if (this.targetLocked.isLockedY) {
        this.targetLocked.setY((this.view.height * floor(this.view.y / this.view.height)) + (this.view.height / 2))
      }
    }

    if (Core.isType(player, Player)) {
      player.x = clamp(player.x, 0.0, this.width)
      player.y = clamp(player.y, 0.0, this.height)
    }

    this.view
      .setFollowTarget(this.targetLocked)
      .update()
    
    this.moveGridItemsTimer.start()
    this.moveGridItems()
    this.moveGridItemsTimer.finish()

    this.signalGridItemsCollisionTimer.start()
    this.signalGridItemsCollision()
    this.signalGridItemsCollisionTimer.finish()

    this.updateGridItems()
    return this
  }
}
