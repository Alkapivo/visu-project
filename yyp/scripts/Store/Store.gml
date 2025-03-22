///@package io.alkapivo.core.util.store

///@param {Struct} json
function Store(json) constructor {

  ///@type {Map<String, any>}
  container = Struct.toMap(
    json, 
    String, 
    StoreItem,
    function(item, key) { return new StoreItem(key, item) }
  )

  ///@private
  ///@param {StoreItem} item
  ///@param {Number} index
  ///@param {String} name
  ///@return {Boolean}
  static findStoreItemByName = function(item, index, name) {
    gml_pragma("forceinline")
    return item.name == name
  }

  ///@param {String} name
  ///@return {?StoreItem}
  static get = function(name) {
    gml_pragma("forceinline")
    return this.container.find(this.findStoreItemByName, name)
  }

  ///@type {String} name
  ///@param {any} [defaultValue]
  ///@return {?any}
  static getValue = function(name, defaultValue = null) {
    gml_pragma("forceinline")
    var item = this.get(name)
    return Core.isType(item, StoreItem) ? item.get() : defaultValue
  }

  ///@param {StoreItem} item
  ///@return {Store}
  static add = function(item) {
    gml_pragma("forceinline")
    this.container.add(item, item.name)
    return this
  }

  ///@param {String} name
  ///@return {Boolean}
  static contains = function(name) {
    gml_pragma("forceinline")
    return Core.isType(this.container.find(this.findStoreItemByName, name), StoreItem)
  }

  ///@param {String} name
  ///@return {Store}
  static remove = function(name) {
    gml_pragma("forceinline")
    var key = this.container.findKey(this.findStoreItemByName, name)
    if (Core.isType(key, String)) {
      this.container.remove(key)
    }
    return this
  }

  ///@return {Struct}
  static stringify = function() {
    gml_pragma("forceinline")
    return this.container.toStruct(function(item) { 
      return item.serialize()
    })
  }

  ///@param {Struct} json
  ///@return {Store}
  ///@throws {Exception}
  static parse = function(json) {
    gml_pragma("forceinline")
    Struct.forEach(json, function(value, key, store) {
      var item = store.get(key)
      if (!Core.isType(item, StoreItem)) {
        throw new Exception($"Unable to parse \{ '{key}': '{value}' \}")
      }
      item.set(value)
    }, this)
    return this
  }
}