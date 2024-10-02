///@package io.alkapivo.core.service.ui

///@interface
///@param {UI} _context
///@param {?Struct} [config]
function UIItem(_name, config = {}) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {?UI}
  context = null

  ///@type {any}
  type = Struct.get(config, "type")

  ///@type {Rectangle}
  area = new Rectangle(Struct.get(config, "area"))

  ///@type {Margin}
  margin = new Margin(Struct.get(config, "margin"))

  ///@type {any}
  state = Struct.get(config, "state")

  ///@type {?UIStore}
  store = Struct.contains(config, "store") ? new UIStore(config.store, this) : null

  ///@type {Boolean}
  storeSubscribed = Core.isType(Struct.get(config, "storeSubscribed"), Boolean) 
    ? config.storeSubscribed 
    : false

  ///@type {?Struct}
  component = Optional.is(Struct.get(config, "component"))
    ? Assert.isType(config.component, Struct)
    : null

  ///@params {Boolean}
  isHoverOver = false

  ///@type {?GMColor}
  backgroundColor = Core.isType(Struct.get(config, "backgroundColor"), String)
    ? Assert.isType(ColorUtil.fromHex(config.backgroundColor).toGMColor(), GMColor)
    : null

  ///@type {Number}
  backgroundAlpha = Core.isType(Struct.get(config, "backgroundAlpha"), Number)
    ? config.backgroundAlpha
    : 1.0
  
  ///@type {Event}
  hoverEvent = new Event("MouseHoverOut", { x: 0, y: 0 })

  ///@param {Event} event
  ///@return {Boolean}
  support = method(this, Assert.isType(Struct.getDefault(config, "support", function(event, key, name) {
    return Core.isType(Struct.get(this, $"on{event.name}"), Callable)
  }, this.name), Callable))

  ///@param {Event} event
  ///@return {?Callable}
  fetchEventPump = method(this, Assert.isType(Struct.getDefault(config, "fetchEventPump", function(event) {
    return this.support(event) ? Struct.get(this, $"on{event.name}") : null
  }), Callable))

  ///@param {any} event
  ///@return {Boolean}
  collide = method(this, Assert.isType(Struct.getDefault(config, "collide", function(event) {
    return this.area.collide(
      Struct.get(event.data, "x") - this.context.area.getX() - this.context.offset.x, 
      Struct.get(event.data, "y") - this.context.area.getY() - this.context.offset.y
    )
  }), Callable))

  updateArea = Struct.contains(config, "updateArea")
    ? method(this, Assert.isType(Struct.get(config, "updateArea"), Callable))
    : null

  updateEnable = Struct.contains(config, "updateEnable")
    ? method(this, Assert.isType(Struct.get(config, "updateEnable"), Callable))
    : null

  updateCustom = Struct.contains(config, "updateCustom")
    ? method(this, Assert.isType(Struct.get(config, "updateCustom"), Callable))
    : null

  updateHover = Struct.contains(config, "updateHover")
    ? method(this, Assert.isType(config.updateHover, Callable))
    : function() {
      this.hoverEvent.data.x = MouseUtil.getMouseX()
      this.hoverEvent.data.y = MouseUtil.getMouseY()
      this.isHoverOver = this.collide(this.hoverEvent)
      if (!this.isHoverOver && Struct.contains(this, "onMouseHoverOut")) {
        Callable.run(this.onMouseHoverOut, this.hoverEvent)
      }
    }

  ///@param {Boolean} [_updateArea]
  ///@return {UIItem}
  update = Struct.contains(config, "update")
    ? Assert.isType(method(this, config.update), Callable)
    : function(_updateArea = true) {
      if (_updateArea && Optional.is(this.updateArea)) {
        this.updateArea()
      }

      if (Optional.is(this.updateEnable)) {
        this.updateEnable()
      }

      if (Optional.is(this.updateCustom)) {
        this.updateCustom()
      }

      if (!storeSubscribed && Optional.is(this.store)) {
        this.store.subscribe()
        this.storeSubscribed = true
      }

      if (this.isHoverOver) {
        this.updateHover()
      }

      return this
    }

  free = method(this, Assert.isType(Struct.getDefault(config, "free", function() {
    if (Optional.is(this.store)) {
      this.store.unsubscribe()
      this.storeSubscribed = false
    }
  }), Callable))

  ///@type {?Callable}
  preRender = Struct.contains(config, "preRender")
    ? method(this, Assert.isType(config.preRender, Callable))
    : null
  
  ///@return {UIItem}
  render = method(this, Assert.isType(Struct.getDefault(config, "render", function() {
    if (Optional.is(this.preRender)) {
      this.preRender()
    }
    return this
  }), Callable))

  ///@description append mouse events
  Struct.forEach(config, function(value, key, button) {
    if (!String.startsWith(key, "on")) {
      return
    }
    Struct.set(button, key, method(button, Assert.isType(value, Callable)))
  }, this)
  Struct.appendUnique(this, config)
}


///@static
function _UIItemUtils() constructor {

  templates = new Map(String, Callable, {
    "renderBackgroundColor": function() {
      return function() {
        if (this.backgroundColor == null) {
          return
        }

        var beginX = this.context.area.getX() + this.area.getX()
        var beginY = this.context.area.getY() + this.area.getY()
        var endX = beginX + this.area.getWidth()
        var endY = beginY + this.area.getHeight()
        var margin = Struct.get(this, "backgroundMargin")
        if (Core.isType(margin, Margin)) {
          GPU.render.rectangle(
            beginX + margin.left,
            beginY + margin.top,
            endX - margin.right,
            endY - margin.bottom,
            false,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundAlpha
          )
        } else {
          GPU.render.rectangle(
            beginX,
            beginY,
            endX,
            endY,
            false,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundColor,
            this.backgroundAlpha
          )
        }
      }
    },
    "updateEnable": function() {
      return function() {
        if (!Optional.is(Struct.get(this, "enable")) 
          || !Core.isType(Struct.get(this.context, "state"), Map)) {
          return
        }

        var key = Struct.get(this.enable, "key")
        if (!Optional.is(key)) {
          return
        }

        var store = this.context.state.get("store")
        if (!Core.isType(store, Store)) {
          return
        }

        var item = store.get(key)
        if (!Core.isType(item, StoreItem)) {
          return
        }

        Struct.set(this.enable, "value", Struct.get(this.enable, "negate") 
          ? !item.get() : item.get())
      }
    },
  })
}
global.__UIItemUtils = new _UIItemUtils()
#macro UIItemUtils global.__UIItemUtils
