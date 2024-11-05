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

  ///@param {Number} x
  ///@param {Number} y
  ///@return {UILabel}
  render = function(x, y) {  
    var _x = x + this.offset.x
    var _y = y + this.offset.y
    var config = gpu_get_colorwriteenable()
    var enableBlend = gpu_get_blendenable()
    gpu_set_blendenable(true)
    if (this.enableColorWrite) {
      GPU.set.colorWrite(true, true, true, false)
    }

    if (this.font.asset != draw_get_font()) {
      draw_set_font(this.font.asset)
    }

    if (this.align.v != draw_get_valign()) {
      draw_set_valign(this.align.v)
    }

    if (this.align.h != draw_get_halign()) {
      draw_set_halign(this.align.h)
    }

    if (this.outline) {
      draw_text_color(_x + 1, _y + 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x - 1, _y - 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x    , _y + 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x + 1, _y    , this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x    , _y - 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x - 1, _y    , this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x - 1, _y + 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
      draw_text_color(_x + 1, _y - 1, this.text, this.outlineColor, this.outlineColor, this.outlineColor, this.outlineColor, this.alpha)
    }

    draw_text_color(_x, _y, this.text, this.color, this.color, this.color, this.color, this.alpha)
    
    GPU.set.colorWrite(config[0], config[1], config[2], config[3]).set.blendEnable(enableBlend)
    return this
  }
}
