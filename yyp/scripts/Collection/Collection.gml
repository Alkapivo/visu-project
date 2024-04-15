///@package io.alkapivo.core.collection

///@interface
///@param {?Struct} [config]
function Collection(config = null) constructor {

  ///@param {any} item
  ///@param {any} [key]
  ///@return {Collection}
  add = Struct.contains(config, "add")
    ? method(this, Assert.isType(config.add, Callable))
    : function(item, key = null) { return this }

  ///@return {Collection}
  clear = Struct.contains(config, "clear")
    ? method(this, Assert.isType(config.clear, Callable))
    : function() { return this }

  ///@param {any} key
  ///@return {Collection}
  remove = Struct.contains(config, "remove")
    ? method(this, Assert.isType(config.remove, Callable))
    : function(key) { return this }

  ///@param {any} key
  ///@return {Boolean}
  contains = Struct.contains(config, "contains")
    ? method(this, Assert.isType(config.contains, Callable))
    : function(key) { return false }

  ///@param {any} key
  ///@param {any} [defaultValue]
  ///@return {any}
  get = Struct.contains(config, "get")
    ? method(this, Assert.isType(config.get, Callable))
    : function(key, defaultValue = null) { return defaultValue }

  ///@param {any} [defaultValue]
  ///@return {any}
  getFirst = Struct.contains(config, "getFirst")
    ? method(this, Assert.isType(config.getFirst, Callable))
    : function(defaultValue) { return defaultValue }

  ///@param {any} [defaultValue]
  ///@return {any}
  getLast = Struct.contains(config, "getLast")
    ? method(this, Assert.isType(config.getLast, Callable))
    : function(defaultValue) { return defaultValue }

  ///@param {any} key
  ///@return {Collection}
  getLast = Struct.contains(config, "getLast")
    ? method(this, Assert.isType(config.getLast, Callable))
    : function(defaultValue) { return defaultValue }

  ///@param {any} key
  ///@param {any} value
  ///@return {Collection}
  set = Struct.contains(config, "set")
    ? method(this, Assert.isType(config.set, Callable))
    : function(key, value) { return this }

  ///@return {Number}
  size = Struct.contains(config, "size")
    ? method(this, Assert.isType(config.size, Callable))
    : function() { return 0 }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Collection}
  filter = Struct.contains(config, "filter")
    ? method(this, Assert.isType(config.filter, Callable))
    : function(callback, acc = null) { return new Collection() }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Collection}
  forEach = Struct.contains(config, "forEach")
    ? method(this, Assert.isType(config.forEach, Callable))
    : function(callback, acc = null) { return new Collection() }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Collection}
  map = Struct.contains(config, "map")
    ? method(this, Assert.isType(config.map, Callable))
    : function(callback, acc = null) { return new Collection() }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  find = Struct.contains(config, "find")
    ? method(this, Assert.isType(config.find, Callable))
    : function(callback, acc = null) { return null }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  findKey = Struct.contains(config, "findKey")
    ? method(this, Assert.isType(config.findKey, Callable))
    : function(callback, acc = null) { return null }

  ///@param {any} [seed]
  ///@return {any}
  generateKey = Struct.contains(config, "generateKey")
    ? method(this, Assert.isType(config.generateKey, Callable))
    : function(seed = null) { return null }

  Struct.appendUnique(this, config, false)
}
