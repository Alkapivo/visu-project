///@package io.alkapivo.core.lang.type

#macro MAX_WRAP_TEXT_INDEX 1000000
///@static
function _String() constructor {

  ///@param {...String} value
  ///@return {String}
  static concat = string_concat

  ///@param {String} text
  ///@param {String} pattern
  ///@return {Boolean}
  static contains = function(text, pattern) {
    gml_pragma("forceinline")
    return string_pos(pattern, text) > 0
  }

  ///@param {String} text
  ///@param {Number} position
  ///@param {Number} count
  ///@return {String}
  static copy = function(text, position, count) {
    gml_pragma("forceinline")
    return string_copy(text, position, count)
  }

  ///@param {String} text
  ///@param {String} substr
  ///@return {Number}
  static count = function(text, substr) {
    gml_pragma("forceinline")
    return string_count(substr, text)
  }

  ///@param {String} text
  ///@param {Number} total
  ///@param {Number} decimal
  ///@return {String}
  static format = function(text, total, decimal) {
    gml_pragma("forceinline")
    return string_format(text, total, decimal)
  }

  ///@param {Number} time in seconds
  ///@return {String}
  static formatTimestamp = function(time) {
    gml_pragma("forceinline")
    var seconds = String.replace(String.format(time mod 60, 2, 0), " ", "0")
    var minutes = String.replace(String.format(time div 60, 2, 0), " ", "0")
    return $"{minutes}:{seconds}"
  }

  ///@param {Number} time in seconds
  ///@return {String}
  static formatTimestampMilisecond = function(time) {
    gml_pragma("forceinline")
    var miliSeconds = String.copy(String.format(time - floor(time), 0, 2), 3, 2)
    var seconds = String.replace(String.format(time mod 60, 2, 0), " ", "0")
    var minutes = String.replace(String.format(time div 60, 2, 0), " ", "0")
    return $"{minutes}:{seconds}.{miliSeconds}"
  }

  ///@param {String} text
  ///@param {Number} position
  ///@return {String}
  static getChar = function(text, position) {
    gml_pragma("forceinline")
    return position > 0 ? string_char_at(text, position) : ""
  }

  ///@param {String} text
  ///@return {String}
  static getFirstChar = function(text) {
    gml_pragma("forceinline")
    return String.getChar(String.size() > 0 ? 1 : 0)
  }

  ///@param {String} text
  ///@return {String}
  static getLastChar = function(text) {
    gml_pragma("forceinline")
    return String.getChar(String.size(text))
  }

  ///@param {String} text
  ///@return {Boolean}
  static isEmpty = function(text) {
    gml_pragma("forceinline")
    return String.size(text) == 0
  }

  ///@param {String} delimiter
  ///@param {...String} value
  ///@return {String}
  static join = string_join

  ///@param {String} text
  ///@param {Number} position
  ///@param {Number} count
  ///@return {String}
  static remove = function(text, position, count) {
    gml_pragma("forceinline")
    return string_delete(text, position, count)
  }

  ///@param {String} text
  ///@param {String} pattern
  ///@param {String} replacement
  ///@return {String}
  static replace = function(text, pattern, replacement) {
    gml_pragma("forceinline")
    return string_replace(text, pattern, replacement)
  }


  ///@param {String} text
  ///@param {String} pattern
  ///@param {String} replacement
  ///@return {String}
  static replaceAll = function(text, pattern, replacement) {
    gml_pragma("forceinline")
    return string_replace_all(text, pattern, replacement)
  }

  ///@param {String} text
  ///@return {Number}
  static size = function(text) {
    gml_pragma("forceinline")
    return string_length(text)
  }

  ///@param {String} text
  ///@param {String} pattern
  ///@return {Boolean}
  static startsWith = function(text, pattern) {
    gml_pragma("forceinline")
    return string_starts_with(text, pattern)
  }

  ///@param {String} text
  ///@param {String} delimiter
  ///@return {Array<String>}
  static split = function(text, delimiter) {
    gml_pragma("forceinline")
    var size = this.count(text, delimiter) + 1
    var delimiterSize = this.size(delimiter)
    var array = GMArray.create(String, size, "")
    var buffer = text
    for (var index = 0; index < size; index++) {
      var pointer = string_pos(delimiter, buffer) - 1;
      if (pointer == -1) {
        array.container[index] = buffer
      } else {
        array.container[index] = String.copy(buffer, 1, pointer)
        buffer = String.remove(buffer, 1, pointer + delimiterSize)
      }
    }

    return array
  }

  ///@param {String} template
  ///@param {...String} parameter
  ///@return {String}
  static template = function(template/*, ...parameter*/) {
    gml_pragma("forceinline")
    var text = template
    if (argument_count > 1) {
      for (var index = 1; index < argument_count; index++) {
        var subString = "{" + string(index - 1) + "}"
        var newString = string(argument[index])
        text = string_replace_all(text, subString, newString)
      }
    }
    return text
  }

  ///@param {String} text
  ///@return {Array<String>}
  static toArray = function(text) {
    gml_pragma("forceinline")
    var size = String.size(text)
    var array = GMArray.create(String, size, "")
    for (var index = 0; index < size; index++) {
      array.set(index, String.getChar(text, index + 1))
    }
    return array
  }

  ///@param {String} text
  ///@return {String}
  static toLowerCase = function(text) {
    gml_pragma("forceinline")
    return string_lower(text)
  }

  ///@param {String} text
  ///@return {String}
  static toUpperCase = function(text) {
    gml_pragma("forceinline")
    return string_upper(text)
  }

  ///@description Breake string into word wrap lines by delimiter
  ///@param {String} text
  ///@param {Integer} width
  ///@param {String} [delimiter]
  ///@param {Number} [wordsplitSize] size of the smallest undivided word
  ///@param {?GMFont} [font]
  ///@return {String}
  static wrapText = function(text, width, delimiter = "\n", wordsplitSize = 0, font = null) {
    gml_pragma("forceinline")
    var currentText = text
    var spacePosition = -1
    var currentPosition = 1
    var result = ""
    var _font = null
    if (Core.isType(font, GMFont)) {
      _font = GPU.get.font()
      if (font != _font) {
        GPU.set.font(font)
      }
    }

    var index = 0
    while (string_length(currentText) >= currentPosition) {
      if (index > MAX_WRAP_TEXT_INDEX) {
        Logger.warn("String", $"Limit of wrapText iteration (MAX_WRAP_TEXT_INDEX: {MAX_WRAP_TEXT_INDEX}) was reached at index: {index}")
        Logger.warn("String", $"result:\n{result}")
        break
      }

      if (string_width(string_copy(currentText, 1, currentPosition)) > width) {
        if (spacePosition != -1) {
          result += string_copy(currentText, 1, spacePosition) + delimiter;
          currentText = string_copy(currentText, spacePosition + 1, string_length(currentText) - (spacePosition));
          currentPosition = 1
          spacePosition = -1
        } else {
          result += string_copy(currentText, 1, currentPosition - 1) + delimiter;
          currentText = string_copy(currentText, currentPosition, string_length(currentText) - (currentPosition - 1));
          currentPosition = 1
          spacePosition = -1
        }
      }

      if (string_char_at(currentText, currentPosition) == " ") {
        spacePosition = currentPosition
      }

      currentPosition++
      index++
    }

    if (string_length(currentText) > 0) {
      result += currentText
    }

    if (Optional.is(_font) && _font != font) {
      GPU.set.font(_font)
    }
    return result
  }
}
global.__String = new _String()
#macro String global.__String

///@param {String} [_text]
function StringBuilder(_text = "") constructor {

  ///@private
  ///@param {String}
  text = Assert.isType(_text, String, "StringBuilder::text must be type of String")

  ///@return {String}
  static get = function() {
    return this.text
  }

  ///@param {String} text
  ///@return {StringBuilder}
  static set = function(text) {
    this.text = Assert.isType(text, String, "StringBuilder::text must be type of String")
    return this
  }

  ///@param {String} text
  ///@param {String} [delimiter]
  ///@return {StringBuilder}
  static append = function(text, delimiter = "") {
    return this.set(this.text != "" ? $"{this.text}{delimiter}{text}" : text)
  }

  ///@param {String} pattern
  ///@param {String} replacemenet
  ///@return {StringBuilder}
  static replace = function(pattern, replacement) {
    return this.set(String.replace(this.text, pattern, replacement))
  }

  ///@return {StringBuilder}
  static clear = function() {
    return this.set("")
  }
}
