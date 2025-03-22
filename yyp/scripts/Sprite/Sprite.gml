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
  speed = Struct.getIfType(config, "speed", Number, texture.speed)

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

  ///@type {Boolean}
  randomFrame = Struct.getDefault(config, "randomFrame", false)

  ///@return {String}
  static getName = function() {
    gml_pragma("forceinline")
    return this.texture.name
  }

  ///@return {Number}
  static getWidth = function() {
    gml_pragma("forceinline")
    return this.texture.width
  }

  ///@return {Number}
  static getHeight = function() {
    gml_pragma("forceinline")
    return this.texture.height
  }

  ///@return {Number}
  static getFrame = function() {
    gml_pragma("forceinline")
    return this.frame
  }

  ///@return {Number}
  static getSpeed = function() {
    gml_pragma("forceinline")
    return this.speed
  }

  ///@return {Number}
  static getScaleX = function() {
    gml_pragma("forceinline")
    return this.scaleX
  }

  ///@return {Number}
  static getScaleY = function() {
    gml_pragma("forceinline")
    return this.scaleY
  }

  ///@return {Number}
  static getAlpha = function() {
    gml_pragma("forceinline")
    return this.alpha
  }

  ///@return {Number}
  static getAngle = function() {
    gml_pragma("forceinline")
    return this.angle
  }

  ///@return {GMColor}
  static getBlend = function() {
    gml_pragma("forceinline")
    return this.blend
  }

  ///@return {Boolean}
  static getAnimate = function() {
    gml_pragma("forceinline")
    return this.animate
  }

  ///@return {Boolean}
  static getRandomFrame = function() {
    gml_pragma("forceinline")
    return this.randomFrame
  }

  ///@param {Number} frame
  ///@return {Sprite}
  static setFrame = function(frame) {
    gml_pragma("forceinline")
    //this.frame = clamp(frame, 0, this.texture.frames - (this.texture.frames > 0 ? 1 : 0))
    this.frame = clamp(frame, 0, this.texture.frames)
    return this
  }

  ///@param {Number} speed
  ///@return {Sprite}
  static setSpeed = function(speed) {
    gml_pragma("forceinline")
    this.speed = speed
    return this
  }

  ///@param {Number} scaleX
  ///@return {Sprite}
  static setScaleX = function(scaleX) {
    gml_pragma("forceinline")
    this.scaleX = scaleX
    return this
  }

  ///@param {Number} scaleY
  ///@return {Sprite}
  static setScaleY = function(scaleY) {
    gml_pragma("forceinline")
    this.scaleY = scaleY
    return this
  }

  ///@param {Number} alpha
  ///@return {Sprite}
  static setAlpha = function(alpha) {
    gml_pragma("forceinline")
    this.alpha = clamp(alpha, 0.0, 1.0)
    return this
  }

  ///@param {Number} angle
  ///@return {Sprite}
  static setAngle = function(angle) {
    gml_pragma("forceinline")
    this.angle = angle
    return this
  }

  ///@param {GMColor} blend
  ///@return {Sprite}
  static setBlend = function(blend) {
    gml_pragma("forceinline")
    this.blend = blend
    return this
  }

  ///@param {Boolean} animate
  ///@return {Sprite}
  static setAnimate = function(animate) {
    gml_pragma("forceinline")
    this.animate = animate
    return this
  }

  ///@param {Boolean} randomFrame
  ///@return {Sprite}
  static setRandomFrame = function(randomFrame) {
    gml_pragma("forceinline")
    this.randomFrame = randomFrame
    if (this.randomFrame) {
      //this.setFrame(irandom(this.texture.frames))
    }
    
    return this
  }
  
  ///@param {Number} x
  ///@param {Number} y
  ///@return {Sprite}
  static render = function(x, y) {
    gml_pragma("forceinline")
    if (this.scaleX == 0 || this.scaleY == 0) {
      return this
    }
    
    draw_sprite_ext(this.texture.asset, this.frame, x, y, this.scaleX, this.scaleY, this.angle, this.blend, this.alpha)
    
    if (!this.animate) {
      return this
    }

    this.frame += DeltaTime.apply(this.speed) / GAME_FPS
    if (this.frame > this.texture.frames) {
      this.frame = this.frame - (this.texture.frames * floor(this.frame / this.texture.frames))
    }
    return this
  }

  ///@param {Number} x
  ///@param {Number} y
  ///@return {Sprite}
  static renderTiled = function(x, y) {
    gml_pragma("forceinline")
    if (this.scaleX == 0 || this.scaleY == 0) {
      return this
    }

    draw_sprite_tiled_ext(this.texture.asset, this.frame, x, y, this.scaleX, this.scaleY, 
      this.blend, this.alpha)
    
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
  static scaleToFillStretched = function(width, height) {
    gml_pragma("forceinline")
    this.scaleX = width / this.texture.width
    this.scaleY = height / this.texture.height
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {Sprite}
  static scaleToFill = function(width, height) {
    gml_pragma("forceinline")
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
  static scaleToFit = function(width, height) {
    gml_pragma("forceinline")
    var scale = min(
      width / this.texture.width, 
      height / this.texture.height
    )
    
    this.scaleX = scale
    this.scaleY = scale
    return this
  }

  ///@return {Struct}
  static serialize = function() {
    gml_pragma("forceinline")
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
      randomFrame: this.getRandomFrame(),
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

      if (json.randomFrame == false) {
        Struct.remove(json, "randomFrame")
      }
    }
    
    return json
  }

  if (this.randomFrame) {
    this.setFrame(irandom(this.texture.frames))
  }
}

///@static
function _SpriteUtil() constructor {

  ///@param {Struct} _json
  ///@param {?Struct} [defaultJson]
  ///@return {?Sprite}
  static parse = function(_json, defaultJson = null) {
    gml_pragma("forceinline")
    var sprite = null
    try {
      if (!Optional.is(Struct.getIfType(_json, "name", String))
          && Core.isType(defaultJson, Struct)) {
        return SpriteUtil.parse(defaultJson)
      }

      var json = JSON.clone(_json)
      var texture = Assert.isType(TextureUtil.parse(json.name, json), Texture)
      Struct.set(json, "frame", clamp(
        (Struct.get(json, "randomFrame") == true
          ? random(texture.frames - 1.0) 
          : NumberUtil.parse(Struct.get(json, "frame"), 0.0)), 
        0.0, 
        texture.frames - 1.0
      ))

      if (Struct.contains(json, "blend")) {
        json.blend = ColorUtil
          .fromHex(json.blend, ColorUtil.WHITE)
          .toGMColor()
      }
      sprite = new Sprite(texture, json)
    } catch (exception) {
      Logger.error("SpriteUtil", $"'parse-sprite' fatal error: {exception.message}")
      sprite = null
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
