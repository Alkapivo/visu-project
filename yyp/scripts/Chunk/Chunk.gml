///@package io.alkapivo.service.chunk

///@interface
///@param {ChunkService} _context
///@param {Struct} config
function Chunk(_context, config) constructor {

  ///@type {ChunkService}
  context = Assert.isType(_context, ChunkService)

  ///@type {String}
  key = Assert.isType(Struct.get(config, "key"), String)

  ///@type {any}
  type = Struct.get(config, "type")

  ///@type {any}
  data = Struct.get(config, "data")

  ///@param {any} item
  ///@return {Chunk}
  add = Struct.contains(config, "add")
    ? method(this, Assert.isType(config.add, Callable))
    : function(item) { return this }

  ///@param {String} name
  ///@return {any}
  get = Struct.contains(config, "get")
    ? method(this, Assert.isType(config.get, Callable))
    : function(name) { return null }

  ///@return {Number}
  size = Struct.contains(config, "size")
    ? method(this, Assert.isType(config.size, Callable))
    : function() { return 0 }

  ///@param {String} name
  ///@return {Boolean}
  contains = Struct.contains(config, "contains")
    ? method(this, Assert.isType(config.contains, Callable))
    : function(name) { return false }

  ///@param {String} name
  ///@return {Chunk}
  remove = Struct.contains(config, "remove")
    ? method(this, Assert.isType(config.remove, Callable))
    : function(name) { return this }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Chunk}
  forEach = Struct.contains(config, "forEach")
    ? method(this, Assert.isType(config.forEach, Callable))
    : function(callback, acc = null) {  return this }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  filter = Struct.contains(config, "filter")
    ? method(this, Assert.isType(config.filter, Callable))
    : function(callback, acc = null) {  return null }

  
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  find = Struct.contains(config, "find")
    ? method(this, Assert.isType(config.find, Callable))
    : function(callback, acc = null) {  return null }
}
