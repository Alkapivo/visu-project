///@package io.alkapivo.visu.service.coin

function _CoinCategory(): Enum() constructor {
  FORCE = "force"
  POINT = "point"
  BOMB = "bomb"
  LIFE = "life"
}
global.__CoinCategory = new _CoinCategory()
#macro CoinCategory global.__CoinCategory

///@param {String} _name
///@param {Struct} json
function CoinTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {CoinCategory}
  category = Assert.isEnum(json.category, CoinCategory)

  ///@type {Struct}
  sprite = Assert.isType(json.sprite, Struct)

  ///@type {Optional<Struct>}
  mask = Core.isType(Struct.get(json, "mask"), Struct) ? json.mask : null

  ///@type {Optional<Number>}
  amount = Core.isType(Struct.get(json, "amount"), Number) ? json.amount : null

  ///@type {Optional<Struct>}
  speed = Core.isType(Struct.get(json, "speed"), Struct) ? json.speed : null

  //@return {Struct}
  serialize = function() {
    var json = {
      name: this.name,
      category: this.category,
      sprite: this.sprite,
    }

    if (Optional.is(this.mask)) {
      Struct.set(json, "mask", this.mask)
    }

    if (Optional.is(this.amount)) {
      Struct.set(json, "amount", this.amount)
    }

    if (Optional.is(this.speed)) {
      Struct.set(json, "speed", this.speed)
    }

    return JSON.clone(json)
  }
}

///@param {Struct} config
function Coin(config) constructor {

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

  ///@type {CoinCategory}
  category = Assert.isEnum(Struct.get(config, "category"), CoinCategory)

  ///@type {Number}
  amount = Core.isType(Struct.get(config, "amount"), Number) ? config.amount : 1

  ///@type {NumberTransformer}
  speed = new NumberTransformer(Core.isType(Struct.get(config, "speed"), Struct) 
    ? config.speed 
    : { value: -3.0, target: 1.0, factor: 0.1, increase: 0.0 })

  ///@type {Number}
  angle = Core.isType(Struct.get(config, "angle"), Number) ? config.angle : 90.0

  ///@private
  ///@type {Boolean}
  simpleAngle = this.angle == 90.0

  ///@param {Player} target
  ///@return {Boolean}
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

  ///@private
  ///@type {Boolean}
  magnet = false

  ///@private
  ///@type {Number}
  magnetSpeed = 0.0

  ///@param {?Player} player
  ///@return {Coin}
  static move = function(player = null) {
    var value = (this.speed.update().value / 100.0) 
    if (player != null && Math.fetchLength(this.x, this.y, player.x, player.y) < 0.4) {
      var to = Math.fetchAngle(this.x, this.y, player.x, player.y)
      this.magnet = true
      this.magnetSpeed = clamp(this.magnetSpeed + DeltaTime.apply(0.000004), 0.0, 0.005)
      this.speed.value = (abs(value) * 100.0)
      this.angle = Math.lerpAngle(this.angle, to, 0.1)
    } else {
      var dir = value < 0.0 ? 90.0 : 270.0
      this.magnetSpeed = clamp(this.magnetSpeed - DeltaTime.apply(0.0005), 0.0, 0.005)
      this.angle = this.simpleAngle && !this.magnet ? dir : Math.lerpAngle(this.angle, dir, 0.05)
    }

    value = abs(value) + this.magnetSpeed
    this.x += Math.fetchCircleX(value, this.angle)
    this.y += Math.fetchCircleY(value, this.angle)
    return this
  }
}