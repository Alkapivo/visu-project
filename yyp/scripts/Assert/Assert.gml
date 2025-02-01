///@package io.alkapivo.core.lang
show_debug_message("init Assert.gml")

///@static
function _Assert() constructor {
  
  ///@param {any} a
  ///@param {any} b
  ///@param {?String} [message]
  ///@throws {InvalidAssertException}
  ///@return {Boolean}
  areEqual = function(a, b, message = null) {
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
  isTrue = function(object, message = null) {
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
  isFalse = function(object, message = null) {
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
  isType = function(object, type, message = null) {
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
  isEnum = function(object, enumerable, message = null) {
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
  isEnumKey = function(object, enumerable, message = null) {
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
  fileExists = function(path, message = null) {
    if (!Core.isType(path, String) && !file_exists(path)) {
      Logger.error("Assert.fileExists", message == null ? "Assert exception." : message)
      throw new InvalidAssertException(message)
    }
    return path
  }
}
global.__Assert = new _Assert()
#macro Assert global.__Assert
