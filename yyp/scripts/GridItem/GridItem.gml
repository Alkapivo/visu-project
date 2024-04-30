///@package com.alkapivo.visu.service.grid.GridItem

///@param {?Struct} [json]
function GridItemMovement(json = null) constructor {
  
  ///@type {Number}
  speed = Assert.isType(Struct.getDefault(json, "speed", 0.0) / 100.0, Number)
  
  ///@type {Number}
  speedMax = Assert.isType(Struct.getDefault(json, "speedMax", 2.1) / 100.0, Number)
  
  ///@type {Number}
  acceleration = Assert.isType(Struct.getDefault(json, "acceleration", 1.92) / 1000.0, Number)
  
  ///@type {Number}
  friction = Assert.isType(Struct.getDefault(json, "friction", 9.3) / 10000.0, Number)

  ///@return {Struct}
  serialize = function() {
    return {
      speed: this.speed * 100.0,
      speedMax: this.speedMax * 100.0,
      acceleration: this.acceleration * 1000.0,
      friction: this.friction * 10000.0,
    }
  }
}


function GridItemSignals() constructor {
  
  ///@type {Boolean}
  kill = false
  
  ///@type {?GridItem}
  bulletCollision = null
  
  ///@type {?GridItem}
  shroomCollision = null
  
  ///@type {?GridItem}
  playerCollision = null

  ///@type {Boolean}
  playerLanded = false

  ///@type {Boolean}
  playerLeave = false

  ///@param {String} key
  ///@param {any} value
  ///@return {GridItemSignals}
  set = function(key, value) {
    Struct.set(this, key, value)
    return this
  }

  ///@return {GridItemSignals}
  reset = function() {
    this.kill = false
    this.bulletCollision = null
    this.shroomCollision = null
    this.playerCollision = null
    this.playerLanded = false
    this.playerLeave = false
    return this
  }
}


///@interface
///@param {Struct} [config]
///@return {GridItem}
function GridItem(config = {}) constructor {

  ///@type {Number}
  x = Assert.isType(Struct.get(config, "x"), Number)

  ///@type {Number}
  y = Assert.isType(Struct.get(config, "y"), Number)

  ///@type {Number}
  z = Assert.isType(Struct.getDefault(config, "z", 0), Number)

  ///@type {Sprite}
  sprite = Assert.isType(SpriteUtil.parse(Struct
    .getDefault(config, "sprite", { name: "texture_test" })), Sprite)

  ///@type {Rectangle}
  mask = Core.isType(Struct.get(config, "mask"), Rectangle)
    ? config.mask
    : new Rectangle({ 
      x: 0, 
      y: 0, 
      width: this.sprite.getWidth(), 
      height: this.sprite.getHeight()
  })

  ///@type {Number}
  speed = Assert.isType(Struct.getDefault(config, "speed", 0), Number)

  ///@type {Number}
  angle = Assert.isType(Struct.getDefault(config, "angle", 0), Number)

  ///@type {Number}
  lifespawn = Assert.isType(Struct.getDefault(config, "lifespawn", 0), Number)

  ///@type {GridItemSignals}
  signals = new GridItemSignals()

  ///@type {Map<String, GridItemGameMode>}
  gameModes = new Map(String, GridItemGameMode)
  
  ///@type {?GridItemGameMode}
  gameMode = null

  ///@param {Number} angle
  ///@return {GridItem}
  setAngle = function(angle) {
    this.angle = Assert.isType(angle, Number)
    return this
  }

  ///@param {Number} speed
  ///@return {GridItem}
  setSpeed = function(speed) {
    this.speed = abs(Assert.isType(speed, Number))
    return this
  }

  ///@param {Sprite} sprite
  ///@return {GridItem}
  setSprite = function(sprite) {
    this.sprite = Assert.isType(sprite, Sprite)
    return this
  }

  ///@param {Rectangle} mask
  ///@return {GridItem}
  setMask = function(mask) {
    this.mask = Assert.isType(mask, Rectangle)
    return this
  }

  ///@param {GameMode} mode
  ///@return {GridItem}
  updateGameMode = Struct.contains(config, "updateGameMode")
  ? method(this, Assert.isType(config.updateGameMode, Callable))
  : function(mode) {
    this.gameMode = this.gameModes.get(mode)
    return this
  }

  ///@param {any} name
  ///@param {any} [value]
  ///@return {GridItem}
  signal = Struct.contains(config, "signal")
    ? method(this, Assert.isType(config.signal, Callable))
    : function(name, value = true) { 
      this.signals.set(name, value)
      return this
    }

  ///@param {GridItem} target
  ///@return {Bollean} collide?
  collide = Struct.contains(config, "collide")
    ? method(this, Assert.isType(config.collide, Callable))
    : function(target) { 
      var halfSourceWidth = (this.mask.getWidth() * this.sprite.scaleX) / 2.0
      var halfSourceHeight = (this.mask.getHeight() * this.sprite.scaleY) / 2.0
      var halfTargetWidth = (target.mask.getWidth() * target.sprite.scaleX) / 2.0
      var halfTargetHeight = (target.mask.getHeight() * target.sprite.scaleY) / 2.0
      var sourceX = this.x * GRID_SERVICE_PIXEL_WIDTH
      var sourceY = this.y * GRID_SERVICE_PIXEL_HEIGHT
      var targetX = target.x * GRID_SERVICE_PIXEL_WIDTH
      var targetY = target.y * GRID_SERVICE_PIXEL_HEIGHT
      return Math.rectangleOverlaps(
        sourceX - halfSourceWidth, sourceY - halfSourceHeight,
        sourceX + halfSourceWidth, sourceY + halfSourceHeight,
        targetX - halfTargetWidth, targetY - halfTargetHeight,
        targetX + halfTargetWidth, targetY + halfTargetHeight
      )
    }

  ///@param {VisuController} controller
  ///@return {GridItem}
  move = Struct.contains(config, "move")
    ? method(this, Assert.isType(config.move, Callable))
    : function() {
      this.signals.reset()
      this.x += Math.fetchCircleX(this.speed, this.angle)
      this.y += Math.fetchCircleY(this.speed, this.angle)
      return this
    }

  ///@param {VisuController} controller
  ///@return {GridItem}
  update = function(controller) { 
    if (Optional.is(this.gameMode)) {
      gameMode.update(this, controller)
    }

    return this
  }
}
