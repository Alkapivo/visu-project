///@package io.alkapivo.core.lang

function Enum() constructor {

  ///@private
  ///@type {?Array}
  _keys = null
  
  ///@param {any} value
  ///@return {Boolean}
  contains = function(value) {
    var keys = this.keys()
    var size = keys.size()
    for (var index = 0; index < size; index++) {
      if (this.get(keys.get(index)) == value) {
        return true
      }
    }
    return false
  }

  ///@param {any} value
  ///@return {Boolean}
  containsKey = function(value) {
    var keys = this.keys()
    var size = keys.size()
    for (var index = 0; index < size; index++) {
      if (keys.get(index) == value) {
        return true
      }
    }
    return false
  }

  ///@param {String} key
  ///@return {any}
  get = function(key) {
    return Struct.get(this, key)
  }

  ///@param {any} value
  ///@return {any}
  findKey = function(value) {
    var keys = this.keys()
    var size = keys.size()
    for (var index = 0; index < size; index++) {
      var key = keys.get(index)
      if (this.get(key) == value) {
        return key
      }
    }
    return null
  }

  ///@return {Array<String>}
  keys = function() {
    static filterKeys = function(key) {
      return key != "_keys" 
        && key != "keys" 
        && key != "get" 
        && key != "findKey"
        && key != "contains"
        && key != "containsKey" 
    }

    if (!Core.isType(this._keys, Array)) {
      this._keys = GMArray.toArray(Struct.keys(this))
        .filter(filterKeys)
    }
    return this._keys
  }
}
