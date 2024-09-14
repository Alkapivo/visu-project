///@package com.alkapivo.visu.service.grid.GridItem

///@param {?Struct} [json]
///@param {Boolean} [useScale]
function GridItemMovement(json = null, _useScale = true) constructor {
  
  ///@type {Boolean}
  useScale = _useScale

  ///@type {Number}
  speed = Assert.isType(Struct
    .getDefault(json, "speed", 0.0) 
    / (this.useScale ? 100.0 : 1.0), Number)
  
  ///@type {Number}
  speedMax = Assert.isType(Struct
    .getDefault(json, "speedMax", 2.1) 
    / (this.useScale ? 100.0 : 1.0), Number)

  ///@type {Number}

  
  speedMaxFocus = (Core.isType(Struct.get(json, "speedMaxFocus"), Number) 
    ? json.speedMaxFocus 
    : 0.66) 
    / (this.useScale ? 100.0 : 1.0)
  
  ///@type {Number}
  acceleration = Assert.isType(Struct
    .getDefault(json, "acceleration", 1.92) 
    / (this.useScale ? 1000.0 : 1.0), Number)
  
  ///@type {Number}
  friction = Assert.isType(Struct
    .getDefault(json, "friction", 9.3) 
    / (this.useScale ? 10000.0 : 1.0), Number)

  ///@return {Struct}
  serialize = function() {
    return {
      speed: this.speed * (this.useScale ? 100.0 : 1.0),
      speedMax: this.speedMax * (this.useScale ? 100.0 : 1.0),
      acceleration: this.acceleration * (this.useScale ? 1000.0 : 1.0),
      friction: this.friction * (this.useScale ? 10000.0 : 1.0),
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
    //this.kill = false
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
  sprite = Assert.isType(SpriteUtil.parse(Struct.get(config, "sprite"), { name: "texture_missing" }), Sprite)

  ///@type {Rectangle}
  mask = Core.isType(Struct.get(config, "mask"), Struct)
    ? new Rectangle(config.mask)
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

  ///@type {Number}
  fadeIn = 0.0

  ///@type {Number}
  fadeInFactor = 0.03

  ///@param {Number} angle
  ///@return {GridItem}
  static setAngle = function(angle) {
    this.angle = angle
    return this
  }

  ///@param {Number} speed
  ///@return {GridItem}
  static setSpeed = function(speed) {
    if (speed > 0) {
      this.speed = speed
    }
    return this
  }

  ///@param {Sprite} sprite
  ///@return {GridItem}
  static setSprite = function(sprite) {
    this.sprite = sprite
    return this
  }

  ///@param {Rectangle} mask
  ///@return {GridItem}
  static setMask = function(mask) {
    this.mask = mask
    return this
  }

  ///@param {GameMode} mode
  ///@return {GridItem}
  static updateGameMode = function(mode) {
    this.gameMode = this.gameModes.get(mode)
    this.gameMode.onStart(this, Beans.get(BeanVisuController))
    return this
  }

  ///@param {any} name
  ///@param {any} [value]
  ///@return {GridItem}
  static signal = function(name, value = true) { 
    this.signals.set(name, value)
    return this
  }

  ///@param {GridItem} target
  ///@return {Bollean} collide?
  static collide = function(target) { 
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
  static move = function() {
    this.signals.reset()
    this.x += Math.fetchCircleX(this.speed, this.angle)
    this.y += Math.fetchCircleY(this.speed, this.angle)
    return this
  }

  ///@param {VisuController} controller
  ///@return {GridItem}
  static update = function(controller) { 
    if (Optional.is(this.gameMode)) {
      gameMode.update(this, controller)
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }
    return this
  }
}
