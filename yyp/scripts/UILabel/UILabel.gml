///@package io.alkapivo.core.service.ui

///@param {Struct} json
function UILabel(json) constructor {

  ///@type {String}
  text = Assert.isType(Struct.getDefault(json, "text", ""), String)

  ///@type {Font}
  font = Assert.isType(FontUtil.fetch(Struct.getDefault(json, "font", "font_basic")), Font)

  ///@type {GMColor}
  color = ColorUtil.fromHex(Struct.getDefault(json, "color", "#000000")).toGMColor()

  ///@type {Number}
  alpha = Assert.isType(Struct.getDefault(json, "alpha", 1.0), Number)

  ///@type {Struct}
  align = {
    v: Assert.isEnum(Struct.getDefault(Struct
      .get(json, "align"), "v", VAlign.TOP), VAlign),
    h: Assert.isEnum(Struct.getDefault(Struct
      .get(json, "align"), "h", HAlign.LEFT), HAlign),
  }

  ///@type {Vector2}
  offset = Vector.parse(Struct.get(json, "offset"), Vector2)

  ///@type {Boolean}
  outline = Assert.isType(Struct.getDefault(json, "outline", false), Boolean)

  ///@type {GMColor}
  outlineColor = ColorUtil.fromHex(Struct.getDefault(json, "outlineColor", "#ffffff")).toGMColor()

  ///@type {any}
  value = null

  ///@type {Boolean}
  enableColorWrite = Core.isType(Struct.get(json, "enableColorWrite"), Boolean) 
    ? json.enableColorWrite
    : Core.getProperty("core.ui-service.use-surface-optimalization", false)

  ///@type {Boolean}
  useScale = Struct.getIfType(json, "useScale", Boolean, true)

  ///@type {Boolean}
  useScaleWithOffset = Struct.getIfType(json, "useScaleWithOffset", Boolean, false)

  ///@param {Number} x
  ///@param {Number} y
  ///@param {Number} [maxWidth]
  ///@param {Number} [maxHeight]
  ///@param {Number} [forceScale]
  ///@return {UILabel}
  render = function(x, y, maxWidth = 0, maxHeight = 0, forceScale = 1.0) { 
    var enableBlend = GPU.get.blendEnable()
    if (!enableBlend) {
      GPU.set.blendEnable(true)
    }

    var colorWriteConfig = null
    if (this.enableColorWrite) {
      colorWriteConfig = GPU.get.colorWrite()
      GPU.set.colorWrite(true, true, true, false)
    }

    if (this.font.asset != GPU.get.font()) {
      GPU.set.font(this.font.asset)
    } 

    var _x = x + this.offset.x
    var _y = y + this.offset.y
    var _width = string_width(this.text)
    var _height = string_height(this.text)
    var _includeOffset = this.useScaleWithOffset ? 1 : 0
    var _maxWidth = maxWidth - (this.offset.x * _includeOffset)
    var _maxHeight = maxHeight - (this.offset.y * _includeOffset)
    var _outline = this.outline ? this.outlineColor : null
    var _scale = this.useScale 
      ? min(
        (_width > _maxWidth ? (_maxWidth / _width) : 1.0),
        (_height > _maxHeight ? (_maxHeight / _height) : 1.0)
      )
      : 1.0

    _scale = _scale < 1.0
      ? clamp(floor((_scale * 0.95) / 0.125) * 0.125, 0.0, 1.0)
      : _scale

    if (_scale <= 0.0) {
      return this
    }
    
    GPU.render.text(
      _x, 
      _y, 
      this.text,
      _scale,
      0.0,
      this.alpha,
      this.color,
      this.font,
      this.align.h,
      this.align.v,
      _outline,
      1.0
    )
    
    if (!enableBlend) {
      GPU.set.blendEnable(enableBlend)
    }

    if (Optional.is(colorWriteConfig)) {
      GPU.set.colorWrite(colorWriteConfig[0], colorWriteConfig[1], colorWriteConfig[2], colorWriteConfig[3])
    }

    return this
  }
}
