///@package io.alkapivo.core.util.store

///@param {Struct} json
function Store(json) constructor {

  ///@type {Map<String, any>}
  container = Struct.toMap(json, String, StoreItem,
    function(item, key) { return new StoreItem(key, item) }, null, 
    function(item, key) { return key })

  ///@private
  ///@param {StoreItem} item
  ///@param {Number} index
  ///@param {String} name
  ///@return {Boolean}
  static findStoreItemByName = function(item, index, name) {
    return item.name == name
  }

  ///@param {String} name
  ///@return {?StoreItem}
  get = function(name) {
    return this.container.find(this.findStoreItemByName, name)
  }

  ///@type {String} name
  ///@param {any} [defaultValue]
  ///@return {?any}
  getValue = function(name, defaultValue = null) {
    var item = this.get(name)
    return Core.isType(item, StoreItem) ? item.get() : defaultValue
  }

  ///@param {StoreItem} item
  ///@return {Store}
  add = function(item) {
    this.container.add(item, item.name)
    return this
  }

  ///@param {String} name
  ///@return {Boolean}
  contains = function(name) {
    return Core.isType(this.container.find(this.findStoreItemByName, name), StoreItem)
  }

  ///@param {String} name
  ///@return {Store}
  remove = function(name) {
    var key = this.container.findKey(this.findStoreItemByName, name)
    if (Core.isType(key, String)) {
      this.container.remove(key)
    }
    return this
  }

  ///@return {Struct}
  stringify = function() {
    return this.container.toStruct(function(item) { 
      return item.serialize()
    })
  }

  ///@param {Struct} json
  ///@return {Store}
  ///@throws {Exception}
  parse = function(json) {
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