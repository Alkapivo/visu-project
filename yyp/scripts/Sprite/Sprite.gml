///@package io.alkapivo.core.asset


///@static
///@type {Boolean}
global.__OPTIMALIZATION_SPRITE_STRINGIFY = false
#macro OPTIMALIZATION_SPRITE_STRINGIFY global.__OPTIMALIZATION_SPRITE_STRINGIFY


///@param {Texture} _texture
///@param {Struct} [config]
function Sprite(_texture, config = {}) constructor {

  ///@final
  ///@type {Texture}
  texture = _texture

  ///@type {Number}
  frame = Struct.getDefault(config, "frame", 0)

  ///@type {Number}
  speed = Struct.getDefault(config, "speed", texture.speed)

  ///@type {Number}
  scaleX = Struct.getDefault(config, "scaleX", 1.0)

  ///@type {Number}
  scaleY = Struct.getDefault(config, "scaleY", 1.0)

  ///@type {Number}
  alpha = Struct.getDefault(config, "alpha", 1.0)

  ///@type {Number}
  angle = Struct.getDefault(config, "angle", 0.0)

  ///@type {GMColor}
  blend = Struct.getDefault(config, "blend", c_white)

  ///@type {Boolean}
  animate = Struct.getDefault(config, "animate", this.texture.frames > 1)

  ///@return {String}
  getName = function() {
    return this.texture.name
  }

  ///@return {Number}
  getWidth = function() {
    return this.texture.width
  }

  ///@return {Number}
  getHeight = function() {
    return this.texture.height
  }

  ///@return {Number}
  getFrame = function() {
    return this.frame
  }

  ///@return {Number}
  getSpeed = function() {
    return this.speed
  }

  ///@return {Number}
  getScaleX = function() {
    return this.scaleX
  }

  ///@return {Number}
  getScaleY = function() {
    return this.scaleY
  }

  ///@return {Number}
  getAlpha = function() {
    return this.alpha
  }

  ///@return {Number}
  getAngle = function() {
    return this.angle
  }

  ///@return {GMColor}
  getBlend = function() {
    return this.blend
  }

  ///@return {Boolean}
  getAnimate = function() {
    return this.animate
  }

  ///@param {Number} frame
  ///@return {Sprite}
  setFrame = function(frame) {
    this.frame = clamp(frame, 0, this.texture.frames - (this.texture.frames > 0 ? 1 : 0))
    return this
  }

  ///@param {Number} speed
  ///@return {Sprite}
  setSpeed = function(speed) {
    this.speed = speed
    return this
  }

  ///@param {Number} scaleX
  ///@return {Sprite}
  setScaleX = function(scaleX) {
    this.scaleX = scaleX
    return this
  }

  ///@param {Number} scaleY
  ///@return {Sprite}
  setScaleY = function(scaleY) {
    this.scaleY = scaleY
    return this
  }

  ///@param {Number} alpha
  ///@return {Sprite}
  setAlpha = function(alpha) {
    this.alpha = clamp(alpha, 0.0, 1.0)
    return this
  }

  ///@param {Number} angle
  ///@return {Sprite}
  setAngle = function(angle) {
    this.angle = angle
    return this
  }

  ///@param {GMColor} blend
  ///@return {Sprite}
  setBlend = function(blend) {
    this.blend = blend
    return this
  }

  ///@param {Boolean} animate
  ///@return {Sprite}
  setAnimate = function(animate) {
    this.animate = animate
    return this
  }
  
  ///@param {Number} x
  ///@param {Number} y
  ///@return {Sprite}
  render = function(x, y) {
    draw_sprite_ext(this.texture.asset, this.frame, x, y, this.scaleX, this.scaleY, 
      this.angle, this.blend, this.alpha)
    
    if (!this.animate) {
      return this
    }

    this.frame += DeltaTime.apply(this.speed / GAME_FPS)
    if (this.frame > this.texture.frames) {
      this.frame = this.frame - (this.texture.frames 
        * floor(this.frame / this.texture.frames))
    }
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {Sprite}
  scaleToFillStretched = function(width, height) {
    this.scaleX = width / this.texture.width
    this.scaleY = height / this.texture.height
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {Sprite}
  scaleToFill = function(width, height) {
    var scale = max(
      width / this.texture.width, 
      height / this.texture.height
    )
    
    this.scaleX = scale
    this.scaleY = scale
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {Sprite}
  scaleToFit = function(width, height) {
    var scale = min(
      width / this.texture.width, 
      height / this.texture.height
    )
    
    this.scaleX = scale
    this.scaleY = scale
    return this
  }

  ///@return {Struct}
  serialize = function() {
    var json = {
      name: this.getName(),
      frame: this.getFrame(),
      speed: this.getSpeed(),
      scaleX: this.getScaleX(),
      scaleY: this.getScaleY(),
      alpha: this.getAlpha(),
      angle: this.getAngle(),
      blend: ColorUtil.fromGMColor(this.getBlend()).toHex(),
      animate: this.getAnimate(),
    }

    ///@description Shrink json size
    if (OPTIMALIZATION_SPRITE_STRINGIFY) {
      if (json.frame == 0) {
        Struct.remove(json, "frame")
      }

      if (json.scaleX == 1.0) {
        Struct.remove(json, "scaleX")
      }

      if (json.scaleY == 1.0) {
        Struct.remove(json, "scaleY")
      }

      if (json.alpha == 1.0) {
        Struct.remove(json, "alpha")
      }

      if (json.angle == 0) {
        Struct.remove(json, "angle")
      }

      if (json.blend == "#ffffff") {
        Struct.remove(json, "blend")
      }

      if (json.speed == 0.0) {
        Struct.remove(json, "animate")
      }

      if (json.animate == true) {
        Struct.remove(json, "animate")
      }
    }
    
    return json
  }
}

///@static
function _SpriteUtil() constructor {

  ///@param {Struct} _json
  ///@param {?Struct} [defaultJson]
  ///@return {?Sprite}
  parse = function(_json, defaultJson = null) {
    var sprite = null
    try {
      var json = JSON.clone(_json)
      var texture = Assert.isType(TextureUtil.parse(json.name), Texture)
      if (Struct.contains(json, "frame")) {
        json.frame = clamp(
          json.frame == "random" 
            ? random(texture.frames - 1.0) 
            : NumberUtil.parse(json.frame, 0.0), 
          0.0, 
          texture.frames - 1.0
        )
      }

      if (Struct.contains(json, "blend")) {
        json.blend = ColorUtil
          .fromHex(json.blend, ColorUtil.WHITE)
          .toGMColor()
      }
      sprite = new Sprite(texture, json)
    } catch (exception) {
      Logger.error("SpriteUtil", $"'parse-sprite' fatal error: {exception.message}")
      if (Core.isType(defaultJson, Struct)) {
        Logger.error("SpriteUtil", $"'parse-sprite' use defaultJson: {JSON.stringify(defaultJson)}")
        sprite = SpriteUtil.parse(defaultJson)
      }
    }
    return sprite
  }
}
global.__SpriteUtil = new _SpriteUtil()
#macro SpriteUtil global.__SpriteUtil
