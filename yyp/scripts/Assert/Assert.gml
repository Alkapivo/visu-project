///@package io.alkapivo.core.lang
show_debug_message("init Assert.gml")

///@static
function _Assert() constructor {
  
  ///@param {any} a
  ///@param {any} b
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Boolean}
  static areEqual = function(a, b, message = null) {
    gml_pragma("forceinline")
    if (a != b) {
      Logger.error("Assert.areEqual", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return true
  }

  ///@param {any} object
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Boolean}
  static isTrue = function(object, message = null) {
    gml_pragma("forceinline")
    if (object != true) {
      Logger.error("Assert.isTrue", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return true
  }

  ///@param {any} object
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Boolean}
  static isFalse = function(object, message = null) {
    gml_pragma("forceinline")
    if (object != false) {
      Logger.error("Assert.isFalse", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return true
  }

  ///@param {any} object
  ///@param {Type} type
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {any}
  static isType = function(object, type, message = null) {
    gml_pragma("forceinline")
    if (!Core.isType(object, type)) {
      Logger.error("Assert.isType", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return object
  }

  ///@param {any} object
  ///@param {Enum} enumerable
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Enum}
  static isEnum = function(object, enumerable, message = null) {
    gml_pragma("forceinline")
    if (!Core.isEnum(object, enumerable)) {
      Logger.error("Assert.isEnum", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return object
  }

  ///@param {any} object
  ///@param {Enum} enumerable
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Enum}
  static isEnumKey = function(object, enumerable, message = null) {
    gml_pragma("forceinline")
    if (!Core.isEnumKey(object, enumerable)) {
      Logger.error("Assert.isEnumKey", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return object
  }

  ///@param {String} path
  ///@throws {InvalidAssertException}
  ///@param {?String} [message]
  ///@return {String}
  static fileExists = function(path, message = null) {
    gml_pragma("forceinline")
    if (!Core.isType(path, String) && !file_exists(path)) {
      Logger.error("Assert.fileExists", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return path
  }
}
global.__Assert = new _Assert()
#macro Assert global.__Assert
