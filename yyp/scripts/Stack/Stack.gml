///@package io.alkapivo.core.collection

///@param {Type} [_type]
///@param {?GMArray} [items]
///@param {?Struct} [config]
function Stack(_type = any, items = null, config = { validate: false }) constructor {

  ///@type {Type}
  type = _type

  ///@private
  ///@type {Array}
  container = items != null ? new Array(this.type, items, config) : new Array(this.type)

  ///@param {any} item
  ///@throws {InvalidClassException}
  ///@return {Stack}
  static push = function(item) {
    gml_pragma("forceinline")
    this.container.add(item)
    return this
  }

  ///@return {any}
  static pop = function() {
    gml_pragma("forceinline")
    var size = this.container.size()
    if (size == 0) {
      return null
    }

    var item = this.container.get(size - 1)
    this.container.remove(size - 1)
    return item
  }

  ///@return {any}
  static peek = function() {
    gml_pragma("forceinline")
    return this.container.getLast()
  }

  ///@override
  ///@param {any} item
  ///@param {any} [key]
  ///@return {Queue}
  static add = function(item, key = null) {
    gml_pragma("forceinline")
    return this.push(item)
  }

  ///@override
  ///@return {Queue}
  static clear = function() {
    gml_pragma("forceinline")
    this.container.clear()
    return this
  }

  ///@override
  ///@param {any} searchItem
  ///@param {Callable} [comparator]
  ///@return {Boolean}
  static contains = function(searchItem, comparator = function(a, b) { return a == b }) {
    gml_pragma("forceinline")
    return this.container.contains(searchItem, comparator)
  }

  ///@override
  ///@param {any} key
  ///@param {any} [defaultValue]
  ///@return {any}
  static get = function(key, defaultValue = null) {
    gml_pragma("forceinline")
    var item = this.peek()
    return item == null ? defaultValue : item
  }

  ///@override
  ///@return {any}
  static getFirst = this.peek

  ///@override
  ///@return {any}
  static getLast = function() {
    gml_pragma("forceinline")
    return this.container.getFirst()
  }

  ///@override
  ///@param {any} key
  ///@return {Collection}
  static remove = function(key) {
    gml_pragma("forceinline")
    this.pop()
    return this
  }

  ///@override
  ///@param {any} key
  ///@param {any} item
  ///@return {Queue}
  static set = function(key, item) {
    gml_pragma("forceinline")
    return this.add(item)
  }

  ///@return {Number}
  static size = function() {
    gml_pragma("forceinline")
    return this.container.size()
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@throws {Exception}
  ///@return {Stack}
  static forEach = function(callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.container.size()
    for (index = size - 1; index >= 0; index--) {
      if (callback(this.pop(), index, acc) == BREAK_LOOP) {
        break
      }
    }
    return this
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@throws {Exception}
  ///@return {Stack}
  static filter = function(callback, acc = null) {
    gml_pragma("forceinline")
    var filtered = []
    var size = this.container.size()
    for (var index = size - 1; index >= 0; index--) {
      var item = this.pop()
      if (callback(item, index, acc)) {
        filtered = GMArray.add(filtered, item)
      }
    }
    return new Stack(this.type, filtered)
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@throws {Exception}
  ///@return {Stack}
  static map = function(callback, acc = null) {
    gml_pragma("forceinline")
    var mapped = []
    var size = this.container.size()
    for (var index = size - 1; index >= 0; index--) {
      var result = callback(this.pop(), index, acc)
      if (result == BREAK_LOOP) {
        break
      }
      GMArray.add(mapped, result)
    }
    return new Stack(this.type, mapped)
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@throws {Exception}
  ///@return {any}
  static find = function(callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size()
    for (var index = size - 1; index >= 0; index--) {
      var item = this.pop()
      if (callback(item, index, acc)) {
        return item
      }
    }
    return null
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@throws {Exception}
  ///@return {?Number}
  static findKey = function(callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size()
    for (var index = size - 1; index >= 0; index--) {
      var item = this.pop()
      if (callback(item, index, acc)) {
        return index
      }
    }
    return null
  }
}

