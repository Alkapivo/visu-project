///@package io.alkapivo.visu.service.subtitle

///@param {String} _name
///@param {Struct} json
function SubtitleTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Array<String>}
  lines = Optional.is(Struct.get(json, "lines"))
    ? new Array(String, GMArray
      .map(json.lines, function(line) {
        return Assert.isType(line, String)
      }))
    : new Array(String)

  ///@return {Struct}
  serialize = function() {
    return {
      lines: this.lines.getContainer(),
    }
  }
}


///@param {Struct} json
function Subtitle(json) constructor {

  ///@type {String}
  template = Assert.isType(json.template, String)

  ///@type {Array<String>}
  lines = Assert.isType(json.lines, Array)

  ///@type {Font}
  font = Core.isType(Struct.get(json, "font"), Font)
    ? json.font
    : Assert.isType(FontUtil.parse({ name: "font_basic" }), Font)

  ///@type {String}
  fontHeight = Optional.is(Struct.get(json, "fontHeight"))
    ? Assert.isType(json.fontHeight, Number)
    : 12

  ///@type {Number}
  charSpeed = Optional.is(Struct.get(json, "charSpeed"))
    ? Assert.isType(json.charSpeed, Number)
    : 1

  ///@type {GMColor}
  color = Optional.is(Struct.get(json, "color"))
    ? Assert.isType(json.color, GMColor)
    : c_white

  ///@type {?GMColor}
  outline = Optional.is(Struct.get(json, "outline"))
    ? Assert.isType(json.outline, GMColor)
    : null

  ///@type {Struct}
  align = Optional.is(Struct.get(json, "align"))
    ? Assert.isType(json.align, Struct)
    : { v: VAlign.TOP, h: HAlign.LEFT }

  ///@type {Rectangle}
  area = Assert.isType(json.area, Rectangle)

  ///@type {?Timer}
  lineDelay = Optional.is(Struct.get(json, "lineDelay"))
    ? Assert.isType(json.lineDelay, Timer)
    : null

  ///@type {?Timer}
  finishDelay = Optional.is(Struct.get(json, "finishDelay"))
    ? Assert.isType(json.finishDelay, Timer)
    : null

  ///@type {NumberTransformer}
  angleTransformer = Optional.is(Struct.get(json, "angleTransformer"))
    ? Assert.isType(json.angleTransformer, NumberTransformer)
    : null

  ///@type {NumberTransformer}
  speedTransformer = Optional.is(Struct.get(json, "speedTransformer"))
    ? Assert.isType(json.speedTransformer, NumberTransformer)
    : null

  ///@type {Number}
  fadeIn = Optional.is(Struct.get(json, "fadeIn"))
    ? Assert.isType(json.fadeIn, Number)
    : 0.0

  ///@type {Number}
  fadeOut = Optional.is(Struct.get(json, "fadeOut"))
    ? Assert.isType(json.fadeOut, Number)
    : 0.0
}
