///@package io.alkapivo.core.renderer.Color

#macro GMColor "GMColor"
#macro COLOR_HEX_SYMBOLS "0123456789ABCDEF"
global.__ASCII_DIGIT_OFFSET = ord("0")
#macro ASCII_DIGIT_OFFSET global.__ASCII_DIGIT_OFFSET
global.__ASCII_CHAR_OFFSET = ord("A")
#macro ASCII_CHAR_OFFSET global.__ASCII_CHAR_OFFSET

///@param {Number} [_red]
///@param {Number} [_green]
///@param {Number} [_blue]
///@param {Number} [_alpha]
function Color(_red = 0.0, _green = 0.0, _blue = 0.0, _alpha = 1.0) constructor {

  ///@public {Number}
  red = _red

  ///@public {Number}
  green = _green

  ///@public {Number}
  blue = _blue

  ///@public {Number}
  alpha = _alpha

  ///@return {GMColor}
  toGMColor = function() {
    return ColorUtil.toGMColor(this)
  }

  ///@param {Boolean} [useAlpha]
  ///@return {String}
  toHex = function(useAlpha = false) {
    return ColorUtil.toHex(this, useAlpha)
  }

  ///@param {String} hex
  ///@return {Color}
  parse = function(hex) {
    var _red = this.red
    var _green = this.green
    var _blue = this.blue
    var _alpha = this.alpha
    try {
      var hexLength = String.size(hex)
      var hasAlpha = hexLength == 9
      var size = hasAlpha ? 8 : 6
      var color = GMArray.create(Number, size, ASCII_DIGIT_OFFSET)
        .map(function(value, index, hex) {
          var result = ord(String.toUpperCase(String.getChar(hex, index + 2)))
          return result >= ASCII_CHAR_OFFSET 
            ? result - ASCII_CHAR_OFFSET + 10 
            : result - ASCII_DIGIT_OFFSET
        }, hex)
    
      this.red = clamp(((color.get(0) * 16) + color.get(1)) / 255, 0.0, 1.0)
      this.green = clamp(((color.get(2) * 16) + color.get(3)) / 255, 0.0, 1.0)
      this.blue = clamp(((color.get(4) * 16) + color.get(5)) / 255, 0.0, 1.0)
      this.alpha = clamp(hasAlpha ? ((color.get(6) * 16) + color.get(7)) / 255 : 1.0, 0.0, 1.0)
    } catch (exception) {
      Logger.warn("Color", $"Cannot parse color from hash: {hex}\n{exception.message}")
      this.red = _red
      this.green = _green
      this.blue = _blue
      this.alpha = _alpha
    }

    return this
  }

  ///@param {Color} color
  ///@return {Color}
  set = function(color) {
    this.red = color.red
    this.green = color.green
    this.blue = color.blue
    this.alpha = color.alpha
    return this
  }

  ///@return {String}
  serialize = function() {
    return this.toHex(this.alpha != 1.0 ? true : false)
  }
}


///@static
function _ColorUtil() constructor {

  ///@type {Color}
  WHITE = new Color(1.0, 1.0, 1.0, 1.0)

  ///@type {Color}
  BLACK = new Color(0.0, 0.0, 0.0, 1.0)

  ///@type {Color}
  BLACK_TRANSPARENT = new Color(0.0, 0.0, 0.0, 0.0)

  ///@param {String} hex
  ///@param {String} defaultValue
  ///@return {Color}
  parse = function(hex, defaultValue = "#000000") {
    if (!Core.isType(hex, String)) {
      return Core.isType(defaultValue, String)
        ? ColorUtil.parse(defaultValue)
        : new Color(0.0, 0.0, 0.0, 1.0)
    }

    try {
      var hexLength = String.size(hex)
      var hasAlpha = hexLength == 9
      var size = hasAlpha ? 8 : 6
      var color = GMArray.create(Number, size, ASCII_DIGIT_OFFSET)
        .map(function(value, index, hex) {
          var result = ord(String.toUpperCase(String.getChar(hex, index + 2)))
          return result >= ASCII_CHAR_OFFSET 
            ? result - ASCII_CHAR_OFFSET + 10 
            : result - ASCII_DIGIT_OFFSET
        }, hex)
    
      var red = ((color.get(0) * 16) + color.get(1)) / 255
      var green = ((color.get(2) * 16) + color.get(3)) / 255
      var blue = ((color.get(4) * 16) + color.get(5)) / 255
      var alpha = hasAlpha ? ((color.get(6) * 16) + color.get(7)) / 255 : 1.0
      return new Color(red, green, blue, alpha)
    } catch (exception) {
      Logger.warn("ColorUtil", $"Cannot parse color from hash: {hex}\n{exception.message}\nTrying to parse using default value {defaultValue}")
      return Core.isType(defaultValue, String)
        ? ColorUtil.parse(defaultValue)
        : new Color(0.0, 0.0, 0.0, 1.0)
    }
  }


  ///@param {String} hex
  ///@param {?Color} defaultValue
  ///@return {Color}
  ///@throws {ParseException}
  fromHex = function(hex, defaultValue = null) {
    try {
      var hexLength = String.size(hex)
      var hasAlpha = hexLength == 9
      var size = hasAlpha ? 8 : 6
      var color = GMArray.create(Number, size, ASCII_DIGIT_OFFSET)
        .map(function(value, index, hex) {
          var result = ord(String.toUpperCase(String.getChar(hex, index + 2)))
          return result >= ASCII_CHAR_OFFSET 
            ? result - ASCII_CHAR_OFFSET + 10 
            : result - ASCII_DIGIT_OFFSET
        }, hex)
    
      var red = ((color.get(0) * 16) + color.get(1)) / 255
      var green = ((color.get(2) * 16) + color.get(3)) / 255
      var blue = ((color.get(4) * 16) + color.get(5)) / 255
      var alpha = hasAlpha ? ((color.get(6) * 16) + color.get(7)) / 255 : 1.0
      return new Color(red, green, blue, alpha)
      /*
      var color = array_create(size, ASCII_DIGIT_OFFSET)
      for (var index = 0; index < size; index++) {
        color[index] = ord(String.toUpperCase(String.getChar(hex, index + 2)))
        color[index] = color[index] >= ASCII_CHAR_OFFSET 
          ? color[index] - ASCII_CHAR_OFFSET + 10 
          : color[index] - ASCII_DIGIT_OFFSET
      }
    
      var red = ((color[0] * 16) + color[1]) / 255
      var green = ((color[2] * 16) + color[3]) / 255
      var blue = ((color[4] * 16) + color[5]) / 255
      var alpha = hasAlpha ? ((color[6] * 16) + color[7]) / 255 : 1.0
      return new Color(red, green, blue, alpha)
      */
    } catch (exception) {
      if (!Core.isType(defaultValue, Color)) {
        throw new ParseException($"Cannot parse color from hash: {hex}\n{exception.message}")
      }
      
      return ColorUtil.fromHex(defaultValue.toHex())
    }
  }

  ///@param {GMColor} color
  ///@param {Number} [alpha]
  ///@return {Color}
  fromGMColor = function(color, alpha = 1.0) {
    return new Color(
      colour_get_red(color) / 255,
      colour_get_green(color) / 255,
      colour_get_blue(color) / 255,
      alpha
    )
  }

  ///@param {Color} color
  ///@return {String}
  toHex = function(color, useAlpha = false) {
    var red = round(color.red * 255)
    var green = round(color.green * 255)
    var blue = round(color.blue * 255)
    var alpha = round(color.alpha * 255)
    var hex = "\#"
      + String.getChar(COLOR_HEX_SYMBOLS, ((red - red mod 16) / 16) + 1)
      + String.getChar(COLOR_HEX_SYMBOLS, (red mod 16 + 1))
      + String.getChar(COLOR_HEX_SYMBOLS, ((green - green mod 16) / 16) + 1)
      + String.getChar(COLOR_HEX_SYMBOLS, (green mod 16 + 1))
      + String.getChar(COLOR_HEX_SYMBOLS, ((blue - blue mod 16) / 16) + 1)
      + String.getChar(COLOR_HEX_SYMBOLS, (blue mod 16 + 1))
    if (useAlpha) {
      hex = hex 
        + String.getChar(COLOR_HEX_SYMBOLS, ((alpha - alpha mod 16) / 16) + 1)
        + String.getChar(COLOR_HEX_SYMBOLS, (alpha mod 16 + 1))
    }
    return hex
  }

  ///@param {Color} color
  ///@return {GMColor}
  toGMColor = function(color) {
    return make_color_rgb(
      color.red * 255, 
      color.green * 255, 
      color.blue * 255
    )
  }

  ///@param {Color} source
  ///@param {Color} target
  ///@return {Boolean}
  areEqual = function(source, target) {
    return source.red == target.red
      && source.green == target.green
      && source.blue == target.blue
      && source.alpha == target.alpha
  }

  ///@param {String} key
  ///@return {Boolean}
  isColorProperty = function(key) {
    return key == "red" || key == "green" || key == "blue" || key == "alpha"
  }
}
global.__ColorUtil = new _ColorUtil()
#macro ColorUtil global.__ColorUtil
