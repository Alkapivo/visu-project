///@package io.alkapivo.core.service.ui

///@param {?Struct} [json]
function Margin(json = null) constructor {
  
  ///@type {Number}
  top = Assert.isType(Struct.getDefault(json, "top", 0), Number)
  
  ///@type {Number}
  bottom = Assert.isType(Struct.getDefault(json, "bottom", 0), Number)
  
  ///@type {Number}
  left = Assert.isType(Struct.getDefault(json, "left", 0), Number)
  
  ///@type {Number}
  right = Assert.isType(Struct.getDefault(json, "right", 0), Number)
}


///@enum
function _UILayoutType(): Enum() constructor {
  NONE = "none"
  VERTICAL = "vertical"
  HORIZONTAL = "horizontal"
}
global.__UILayoutType = new _UILayoutType()
#macro UILayoutType global.__UILayoutType


///@param {?Struct} [config]
function UILayoutIterator(config = null) constructor {
  
  ///@type {Number}
  index = Assert.isType(Struct.getDefault(config, "index", 0), Number)
  
  ///@type {Number}
  size = Assert.isType(Struct.getDefault(config, "size", 1), Number)
  
  ///@return {Number}
  getIndex = function() { 
    return this.index
  }
  
  ///@return {Number}
  getSize = function() {
    return this.size
  }
  
  ///@param {Number} index
  ///@return {UILayoutIterator}
  setIndex = function(index) { 
    this.index = index
    return this
  }

  ///@param {Number} size
  ///@return {UILayoutIterator}
  setSize = function(size) { 
    this.size = size
    return this
  }
}

///@param {Struct} config
///@param {?UILayout} [_context]
function UILayout(config, _context = null) constructor {

  ///@private
  ///@return {Callable}
  static parseX = function() {
    if (this.context == null) {
      return function() { return this.margin.left }
    } 

    switch (this.type) {
      case UILayoutType.HORIZONTAL: return function() { return this.context.right() 
        + this.margin.left }
      default: return function() { return this.context.x() + this.margin.left }
    }
  }

  ///@private
  ///@return {Callable}
  static parseY = function() {
    if (this.context == null) {
      return function() { return this.margin.top }
    }

    switch (this.type) {
      case UILayoutType.VERTICAL: return function() { return this.context.bottom() 
        + this.margin.top }
      default: return function() { return this.context.y() + this.margin.top }
    }
  }

  ///@private
  ///@param {?UILayout} [context]
  ///@param {?Struct} [config]
  ///@return {Struct}
  static parseNodes = function(config = null, context = null) {
    static parseNode = function(node, name, context) {
      return new UILayout(node, context)
    }

    return Struct.contains(config, "nodes")
      ? Struct.map(Assert.isType(config.nodes, Struct), parseNode, context)
      : {} 
  }
  
  ///@final
  ///@param {?UILayout}
  context = _context != null ? Assert.isType(_context, UILayout) : null

  ///@final
  ///@type {UILayoutType}
  type = Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType)

  ///@type {?String}
  name = Struct.contains(config, "name") ? Assert.isType(config.name, String) : null

  ///@return {Margin}
  margin = Struct.contains(config, "margin") 
    ? Assert.isType(new Margin(config.margin), Margin)
    : new Margin()

  ///@return {Number}
  x = method(this, Assert.isType(Struct.contains(config, "x")
    ? config.x
    : this.parseX(), Callable))

  ///@return {Number}
  y = method(this, Assert.isType(Struct.contains(config, "y")
    ? config.y
    : this.parseY(), Callable))

  ///@return {Number}
  width = method(this, Assert.isType(Struct.getDefault(config, "width", this.context != null
    ? function() { return this.context.width() - this.margin.left - this.margin.right }
    : function() { return 0 }
  ), Callable))

  ///@return {Number}
  height = method(this, Assert.isType(Struct.getDefault(config, "height", this.context != null
    ? function() { return this.context.height() - this.margin.top - this.margin.bottom }
    : function() { return 0 }
  ), Callable))
  
  ///@return {Number}
  left = method(this, Assert.isType(Struct.getDefault(config, "left", function() { 
    return this.x() - this.margin.left
  }), Callable))

  ///@return {Number}
  top = method(this, Assert.isType(Struct.getDefault(config, "top", function() { 
    return this.y() - this.margin.top
  }), Callable))

  ///@return {Number}
  right = method(this, Assert.isType(Struct.getDefault(config, "right", function() { 
    return this.x() + this.width() + this.margin.right
  }), Callable))

  ///@return {Number}
  bottom = method(this, Assert.isType(Struct.getDefault(config, "bottom", function() { 
    return this.y() + this.height() + this.margin.bottom
  }), Callable))

  ///@type {?Struct}
  collection = Core.isType(Struct.get(context, "collection"), UILayoutIterator)
    ? context.collection
    : (Struct.contains(config, "collection") 
      ? new UILayoutIterator(config.collection)
      : null)
  
  ///@type {Struct}
  nodes = this.parseNodes(config, this)

  Struct.appendUnique(this, config, true)
}


///@static
function _UILayoutUtil() constructor {

  ///@return {Callable}
  sumNodesHeight = function() {
    return function() {
      static sumHeight = function(node, name, acc) {
        acc.height = acc.height + node.height()
      }

      var acc = { height: 0 }
      Struct.forEach(this.nodes, sumHeight, acc)
      return acc.height
    }
  }
}
global.__UILayoutUtil = new _UILayoutUtil()
#macro UILayoutUtil global.__UILayoutUtil
