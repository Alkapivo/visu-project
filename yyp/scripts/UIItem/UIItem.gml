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

  ///@type {?Struct}
  enable = Struct.getIfType(config, "enable", Struct)

  ///@type {Boolean}
  isHoverOver = false

  ///@type {any}
  state = Struct.get(config, "state")

  ///@type {?UIStore}
  store = Optional.is(Struct.get(config, "store"))
    ? new UIStore(config.store, this) 
    : null

  ///@type {Boolean}
  storeSubscribed = Core.isType(Struct.get(config, "storeSubscribed"), Boolean) 
    ? config.storeSubscribed 
    : false

  ///@type {?Struct}
  component = Struct.getIfType(config, "component", Struct)

  ///@type {?GMColor}
  backgroundColor = Optional.is(Struct.getIfType(config, "backgroundColor", String))
    ? Assert.isType(ColorUtil.parse(config.backgroundColor).toGMColor(), GMColor)
    : null

  ///@type {Number}
  backgroundAlpha = Struct.getIfType(config, "backgroundAlpha", Number, 1.0)

  ///@type {?Margin}
  backgroundMargin = Optional.is(Struct.get(config, "backgroundMargin"))
    ? new Margin(config.backgroundMargin)
    : null
  
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

  ///@type {?Callable}
  postRender = Struct.contains(config, "postRender")
    ? method(this, Assert.isType(config.postRender, Callable))
    : null
  
  ///@return {UIItem}
  render = method(this, Assert.isType(Struct.getDefault(config, "render", function() {
    if (Optional.is(this.preRender)) {
      this.preRender()
    }

    if (Optional.is(this.postRender)) {
      this.postRender()
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

  ///@type {Map<String, Callable>}
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
    "updateEnableKeys": function() {
      return function() {
        if (!Optional.is(Struct.get(this, "enable")) 
          || !Core.isType(Struct.get(this.context, "state"), Map)) {
          return
        }

        var keys = Struct.get(this.enable, "keys")
        if (!Core.isType(keys, GMArray)) {
          return
        }

        var store = this.context.state.get("store")
        if (!Core.isType(store, Store)) {
          return
        }

        Struct.set(this.enable, "value", false)
        for (var index = 0; index < GMArray.size(keys); index++) {
          var entry = keys[index]
          var item = store.get(entry.key)
          if (!Core.isType(item, StoreItem)) {
            return
          }

          var result = Struct.get(this.enable, "negate") 
            ? item.get() : !item.get()
          if (result) {
            return
          }
        }

        Struct.set(this.enable, "value", true)
      }
    },
  })

  ///@type {Struct}
  textField = {

    ///@return {Callable}
    getUpdateJSONTextArea: function() {
      return function() {
        var text = this.textField.getText()
        if (!Optional.is(text) 
            || String.isEmpty(text) 
            || Struct.get(this, "__previousText") == text) {
          return
        }

        Struct.set(this, "__previousText", text)
        if (!Struct.contains(this, "__colors")) {
          Struct.set(this, "__colors", {
            unfocusedValid: this.textField.style.c_bkg_unfocused.c,
            unfocusedInvalid: ColorUtil.fromHex(VETheme.color.denyShadow).toGMColor(),
            focusedValid: this.textField.style.c_bkg_focused.c,
            focusedInvalid: ColorUtil.fromHex(VETheme.color.deny).toGMColor(),
          })
        }

        var isValid = Optional.is(JSON.parse(text))
        var colors = Struct.get(this, "__colors")
        this.textField.style.c_bkg_unfocused.c = isValid 
          ? colors.unfocusedValid
          : colors.unfocusedInvalid
        this.textField.style.c_bkg_focused.c = isValid 
          ? colors.focusedValid
          : colors.focusedInvalid
      }
    },
  }
}
global.__UIItemUtils = new _UIItemUtils()
#macro UIItemUtils global.__UIItemUtils
