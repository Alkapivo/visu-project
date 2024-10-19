///@package io.alkapivo.core.util
show_debug_message("init Scene.gml")

///@static
function _Scene() constructor {

  ///@private
  ///@type {any}
  intent = null

  ///@return {any}
  getIntent = function() {
    return this.intent
  }

  ///@param {any} intent
  ///@return {Scene}
  setIntent = function(intent) {
    this.intent = intent
    return this
  }

  ///@param {String} name
  ///@param {any} [intent]
  ///@throws {AssertException}
  ///@return {Scene}
  open = function(name, intent = null) {
    var scene = Assert.isType(this.getScene(name), GMScene)
    this.setIntent(intent)
    room_goto(scene)
    return this
  }

  ///@param {String} name
  ///@return {?GMScene}
  getScene = function(name) {
    return Core.getIfType(asset_get_index(name), GMScene)
  }

  ///@param {String} name
  ///@return {?GMLayer}
  getLayer = function(name) {
    var layerId = layer_get_id(name)
    return Core.isType(layerId, GMLayer) ? layerId : null
  }

  ///@param {String} name
  ///@param {Number} [defaultDepth]
  ///@return {?GMLayer}
  factoryLayer = function(name, defaultDepth = 0.0) {
    var layerId = layer_create(Core.getIfType(defaultDepth, Number, 0.0), name)
    return Core.isType(layerId, GMLayer) ? layerId : null
  }

  ///@param {String} name
  ///@param {Number} [defaultDepth]
  ///@return {GMLayer}
  fetchLayer = function(name, defaultDepth = 0.0) {
    var layerId = this.getLayer(name)
    return layerId != null ? layerId : this.factoryLayer(name, defaultDepth)
  }
}
global.__Scene = new _Scene()
#macro Scene global.__Scene
