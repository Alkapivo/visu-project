///@package io.alkapivo.core.service.ui

///@param {Struct} [config]
function UI(config = {}) constructor {

  ///@type {String}
  name = Assert.isType(Struct.get(config, "name"), String)

  ///@type {Rectangle}
  area = new Rectangle(Struct.get(config, "area"))

  ///@type {any}
  state = Struct.get(config, "state")

  ///@type {Boolean}
  enable = Assert.isTrue(Struct.getDefault(config, "enable", true), Boolean)

  ///type {Boolean}
  propagate = Assert.isType(Struct.getDefault(config, "propagate", true), Boolean)

  ///@type {Vector2}
  offset = Assert.isType(Struct.getDefault(config, "offset", new Vector2()), Vector2)

  ///@type {Vector2}
  offsetMax = Assert.isType(Struct.getDefault(config, "offsetMax", new Vector2()), Vector2)

  ///@type {?UILayout}
  layout = Struct.contains(config, "layout")
    ? Assert.isType(config.layout, UILayout)
    : null

  ///@type {?UICollection}
  collection = Struct.contains(config, "collection")
    ? Assert.isType(config.collection, UICollection)
    : null

  ///@private
  ///@type {Collection}
  items = new Map(String, UIItem)

  ///@type {Margin}
  margin = new Margin(Struct.get(config, "margin"))
  
  ///@return {Number}
  fetchViewWidth = Struct.contains(config, "fetchViewWidth")
    ? Assert.isType(method(this, config.fetchViewWidth), Callable)
    : function() {
      static updateWidthPeak = function(item, name, acc) {
        acc.peak = max(acc.peak, item.area.getX() 
          + item.area.getWidth() + item.margin.right)
      }
      
      var acc = { peak: 0 }
      this.items.forEach(updateWidthPeak, acc)
      return acc.peak
    }

  ///@return {Number}
  fetchViewHeight = Struct.contains(config, "fetchViewHeight")
    ? Assert.isType(method(this, config.fetchViewHeight), Callable)
    : function() {
      static updateHeightPeak = function(item, name, acc) {
        acc.peak = max(acc.peak, item.area.getY() 
          + item.area.getHeight() + item.margin.bottom)
      }
      
      var acc = { peak: 0 }
      this.items.forEach(updateHeightPeak, acc)
      return acc.peak
    } 

  ///@private
  ///@type {?Surface}
  surface = Struct.contains(config, "surface")
    ? Assert.isType(config.surface, Surface)
    : null

  var _surfaceTick = Core.getProperty("core.ui-service.surface-optimalization", 3)
  ///@private
  ///@type {Struct}
  surfaceTick = {
    value: irandom(_surfaceTick),
    maxValue: _surfaceTick,
    delta: 0,
    previous: false,
    get: function() {
      this.value += 1
      this.delta += DeltaTime.deltaTime
      if (this.value > this.maxValue) {
        this.value = 0
        this.delta = 0
      }
      return this.value == this.maxValue
    },
    skip: function() {
      this.value = this.maxValue - 1
      if (this.value < 0) {
        this.value = 0
      }
      return this
    },
  }

  updateArea = Struct.contains(config, "updateArea")
    ? Assert.isType(method(this, config.updateArea), Callable)
    : null

  updateCustom = Struct.contains(config, "updateCustom")
    ? Assert.isType(method(this, config.updateCustom), Callable)
    : null

  ///@param {UIItem} item
  updateItem = Struct.contains(config, "updateItem")
    ? Assert.isType(method(this, config.updateItem), Callable)
    : function(item, iterator, acc) {
      item.update(acc)
    }

  ///@private
  ///@type {Rectangle}
  areaWatchdog = {
    name: this.name,
    value: false,
    force: false,
    area: new Rectangle({ width: -1, height: -1 }),
    signal: function() {
      this.force = true
      return this
    },
    get: function() {
      return this.value || this.force
    },
    update: function(area) {
      var force = this.force
      this.force = false
      if (this.area.getX() == area.getX()
          && this.area.getY() == area.getY()
          && this.area.getWidth() == area.getWidth()
          && this.area.getHeight() == area.getHeight()) {
        this.value = force
      } else {
        this.value = true
        this.area
          .setX(area.getX())
          .setY(area.getY())
          .setWidth(area.getWidth())
          .setHeight(area.getHeight())
      }

      return this
    },
  }


  updateItems = Struct.contains(config, "updateItems")
    ? Assert.isType(method(this, config.updateItems), Callable)
    : function() {
      //var updateItemArea = this.surfaceTick.skip()
      //if (Optional.is(this.updateTimer)) {
      //  updateItemArea = this.updateTimer.finished
      //}
      var updateItemArea = this.areaWatchdog.update(this.area).get()
      this.items.forEach(this.updateItem, updateItemArea)
    }

  hoverItem = null

  ///@param {Event} event
  ///@return {Boolean}
  dispatch = Struct.contains(config, "dispatch")
    ? Assert.isType(method(this, config.dispatch), Callable)
    : function(event) {
      static isValidItem = function(item, name, event) {
        return item.support(event) && item.collide(event)
      }

      var _x = Struct.get(event.data, "x")
      var _y = Struct.get(event.data, "y")
      
      if (this.enableScrollbarY) {
        var halign = this.scrollbarY.align
        this.area.setWidth(this.area.getWidth() + this.scrollbarY.width)
        if (halign == HAlign.LEFT) {
          this.area.setX(this.area.getX() - this.scrollbarY.width)
        }
      }

      if (!Core.isType(_x, Number) || !Core.isType(_y, Number) || !this.area.collide(_x, _y)) {
        if (this.enableScrollbarY) {
          var halign = this.scrollbarY.align
          this.area.setWidth(this.area.getWidth() - this.scrollbarY.width)
          if (halign == HAlign.LEFT) {
            this.area.setX(this.area.getX() + this.scrollbarY.width)
          }
        }
        return false
      }

      if (this.enableScrollbarY) {
        var halign = this.scrollbarY.align
        this.area.setWidth(this.area.getWidth() - this.scrollbarY.width)
        if (halign == HAlign.LEFT) {
          this.area.setX(this.area.getX() + this.scrollbarY.width)
        }
      }

      var item = this.items.find(isValidItem, event)
      if (!Core.isType(item, UIItem)) {
        var containerHandler = Struct.get(this, $"on{event.name}")
        if (!Core.isType(containerHandler, Callable)) {
          return !this.propagate
        }
        Callable.run(containerHandler, event)
        return true
      }

      var dispatcher = item.fetchEventPump(event)
      if (event.name == "MouseHoverOver" && Optional.is(dispatcher)) {
        if (item.isHoverOver) {
          return true
        }

        if (this.hoverItem != item) {
          this.hoverItem = item
          this.clampUpdateTimer(0.9500)
        }
        item.isHoverOver = true
      }
      Callable.run(dispatcher, event)
      return true
    }

  ///@param {UIItem} item
  ///@return {UI} 
  add = Struct.contains(config, "add")
    ? Assert.isType(method(this, config.add), Callable)
    : function(item) {
      item.context = this //@todo item context constructor
      //this.areaWatchdog.signal()
      this.items.add(item, item.name)
      if (Optional.is(item.updateArea)) {
        item.updateArea()
      }
      return this
    }

  ///@param {String} name
  ///@return {UI}
  remove = Struct.contains(config, "remove")
    ? Assert.isType(method(this, config.remove), Callable)
    : function(name) {
      var item = this.items.get(name)
      if (Optional.is(item)) {
        item.free()
      }
      this.areaWatchdog.signal()
      this.items.remove(name)
      return this
    }

  ///@return {UI}
  update = Struct.contains(config, "update")
    ? Assert.isType(method(this, config.update), Callable)
    : function() {

      if (this.enableScrollbarY && Struct.get(this.scrollbarY, "isDragEvent")) {
        if (mouse_check_button(mb_left) ///@todo button should be a parameter
          && Optional.is(Struct.get(this, "onMousePressedLeft"))) {
          this.onMousePressedLeft(new Event("MouseOnLeft", { 
            x: MouseUtil.getMouseX(), 
            y: MouseUtil.getMouseY(),
          }))
        } else {
          Struct.set(scrollbarY, "isDragEvent", false)
        }
      }
      
      if (Optional.is(this.updateArea)) {
        if (Optional.is(this.updateTimer)) {
          if (this.updateTimer.update().finished) {
            this.updateArea()

            if (Optional.is(this.updateCustom)) {
              this.updateCustom()
            }

            if (Optional.is(this.updateItems)) {
              this.updateItems()
            }
          }
        } else {
          this.updateArea()

          if (Optional.is(this.updateCustom)) {
            this.updateCustom()
          }
          
          if (Optional.is(this.updateItems)) {
            this.updateItems()
          }
        }
      }
      
      return this
    }

  ///@return {UI}
  renderSurface = Struct.contains(config, "renderSurface")
    ? Assert.isType(method(this, config.renderSurface), Callable)
    : function() {

      var color = this.state.getDefault("background-color", c_black)
      var alpha = this.state.getDefault("background-alpha", 0.0)
      GPU.render.clear(color, alpha)

      var areaX = this.area.x
      var areaY = this.area.y
      var delta = DeltaTime.deltaTime
      DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
      this.area.x = this.offset.x
      this.area.y = this.offset.y
      this.items.forEach(this.renderItem, this.area)
      this.area.x = areaX
      this.area.y = areaY
      DeltaTime.deltaTime = delta
    }

  ///@param {UIItem} item
  renderItem = method(this, Assert.isType(
    Struct.contains(config, "renderItem")
      ? config.renderItem
      : Callable.run(UIUtil.renderTemplates.get("renderItemDefault")), 
    Callable))

  ///@return {UI}
  render = method(this, Core.isType(Struct.get(config, "render"), Callable)
    ? config.render
    : Callable.run(UIUtil.renderTemplates.get("renderDefault")))

  ///@type {Map<String, Callable>}
  freeOperations = Struct.contains(config, "freeOperations")
    ? Assert.isType(config.operations, Map)
    : new Map(String, Callable, {
        "unsubscribe-items": function(context) {
          context.items.forEach(function(item) {
            item.free()
          })
        },
        "free-surface": function(context) {
          if (Core.isType(context.surface, Surface)) {
            context.surface.free()
          }
        },
        "clean-up": function(context) {
          if (Core.isType(context.onDestroy, Callable)) {
            context.onDestroy()
          }
        }
      })
  
  free = Struct.contains(config, "free")
    ? Assert.isType(method(this, config.free), Callable)
    : function() {
    this.freeOperations.forEach(function(operation, key, context) {
      try {
        operation(context)
      } catch (exception) {
        Logger.error("UI", $"Unable to execute free operation '{key}'. {exception.message}")
      }
    }, this)

    return this
  }

  ///@param {UIItem} item
  ///@param {String|Number} iterator
  ///@param {?Struct} [data]
  addUIItem = function(item, iterator, data = null) {
    if (item.type == UITextField) {
      if (Optional.is(Struct.get(data, "textField"))) {
        data.textField.setNext(item.textField)
        item.textField.setPrevious(data.textField)
      }
      Struct.set(data, "textField", item.textField)
    }

    this.add(item, item.name)
    //if (Optional.is(item.updateArea)) {
    //  item.updateArea()
    //}

    if (!item.storeSubscribed && Optional.is(item.store)) {
      item.store.subscribe()
      item.storeSubscribed = true
    }
  }
  
  ///@param {UIComponent} component
  ///@param {String|Number} iterator
  ///@param {?Struct} [data]
  addUIComponent = function(component, iterator, data) {
    data.layout = component
      .toUIItems(data.layout)
      .forEach(this.addUIItem, data)
      .getLast().layout.context
  }

  ///@param {Array<UIComponents>} components
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {UI}
  addUIComponents = Struct.contains(config, "addUIComponents")
    ? Assert.isType(method(this, config.addUIComponents), Callable)
    : function(components, layout, config = null) {
        var context = this
        components.forEach(this.addUIComponent, Struct.append(config, {
          layout: layout,
          context: context,
          textField: null
        }, false))

        return this
      }

  ///@type {?Timer}
  updateTimer = Core.isType(Struct.get(config, "updateTimer"), Timer)
    ? config.updateTimer 
    : null

  ///@return {UI}
  finishUpdateTimer = method(this, Struct.getIfType(config, "finishRngTimer", Callable, function() {
    if (!Optional.is(this.updateTimer)) {
      return this
    }

    this.updateTimer.time = this.updateTimer.duration + random(this.updateTimer.duration / 2.0)
    return this
  }))

  ///@param {Number} [factor]
  ///@return {UI}
  clampUpdateTimer = method(this, Struct.getIfType(config, "clampUpdateTimer", Callable, function(factor = 1.0) {
    if (!Optional.is(this.updateTimer)) {
      return this
    }

    this.updateTimer.time = clamp(this.updateTimer.time, this.updateTimer.duration * factor, this.updateTimer.duration)
    return this
  }))
  
  ///@type {Struct}
  scrollbarY = Struct.appendRecursive(
    {
      isDragEvent: false,
      align: HAlign.LEFT,
      width: 10,
      thickness: 3,
      color: ColorUtil.fromHex(VETheme.color.primaryShadow).toGMColor(),
      alpha: 1.0,
      render: function(context) {
        var x1 = 0, y1 = 0, x2 = 0, y2 = 0
        switch (this.align) {
          case HAlign.LEFT:
            x1 = context.area.getX() - this.width + (this.width - this.thickness) / 2.0
            y1 = context.area.getY() + this.thickness
            x2 = x1 + this.thickness
            y2 = y1 + context.area.getHeight() - (this.thickness * 2)
            break
          case HAlign.RIGHT:
            x1 = context.area.getX() + context.area.getWidth() + (this.width - this.thickness) / 2.0
            y1 = context.area.getY()  + this.thickness
            x2 = x1 + this.thickness
            y2 = y1 + context.area.getHeight() - (this.thickness * 2)
            break
        }

        var height = context.area.getHeight() - (this.thickness * 2)
        var length = height + context.offsetMax.y 
        var beginRatio = clamp(clamp(abs(context.offset.y), 0, context.offsetMax.y) / length, 0, 1)

        y1 = y1 + (beginRatio * height)
        y2 = y1 + ((height / length) * height)
        GPU.render.rectangle(x1, y1, x2, y2, false, this.color, this.color, this.color, this.color, this.alpha)
      }
    },
    Struct.get(config, "scrollbarY")
  )

  ///@type {Boolean}
  enableScrollbarY = Struct.contains(config, "scrollbarY")

  ///@type {?Callable}
  onInit = null

  ///@type {?Callable}
  onDestroy = null

  ///@description apply functions like onMouseWheelUp as struct fields
  Struct.forEach(config, function(value, key, container) {
    if (!String.startsWith(key, "on")) {
      return
    }
    Struct.set(container, key, method(container, Assert.isType(value, Callable)))
  }, this)

  if (Struct.contains(config, "items")) {
    Struct.forEach(Struct.get(config, "items"), function(json, name, container) {
      container.add(json.type(name, json), name)
    }, this)
  }
  
  Struct.appendUnique(this, config)
  
  if (Core.isType(this.onInit, Callable)) {
    this.onInit()
  }

  ///@todo move to method
  if (Optional.is(this.updateArea)) {
    this.updateArea()
  }
  this.areaWatchdog.signal()
  //this.items.forEach(function(item) {
  //  if (Optional.is(item.updateArea)) {
  //    item.updateArea()
  //  }
  //}) 
}


///@static
function _UIUtil() constructor {

  ///@type {Map<String, Callable>}
  templates = new Map(String, Callable, {
    "removeUIItemfromUICollection": function() {
      return function() {
        if (this.component == null) {
          throw new Exception($"removeUIItemfromUICollection require 'component' to be initialized")
        }

        this.context.collection.remove(this.component.index)
      }
    },
    "updateVerticalSelectedIndex": function() {
      return function(size) {
        var mouseX = device_mouse_x_to_gui(0)
        var mouseY = device_mouse_y_to_gui(0)
        var areaX = this.area.getX()
        var areaY = this.area.getY()
        var areaWidth = this.area.getWidth()
        var areaHeight = this.area.getHeight()
        var isKeyboardEvent = this.state.getDefault("isKeyboardEvent", false)
        if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
          if (isKeyboardEvent && !MouseUtil.hasMoved()) {
            return
          }
          this.state.set("isKeyboardEvent", false)
          
          var previousElement = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
          if (Optional.is(previousElement)) {
            previousElement.items.forEach(function(item) {
              item.backgroundColor = Struct.contains(item, "colorHoverOut")
                ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                : item.backgroundColor
            })
          }

          this.selectedIndex = (abs(this.offset.y) + (mouseY - areaY)) div size
          var currentElement = this.collection.findByIndex(this.selectedIndex)
          if (Optional.is(currentElement)) {
            currentElement.items.forEach(function(item) {
              item.backgroundColor = Struct.contains(item, "colorHoverOver")
                ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                : item.backgroundColor
            })
          }
        } else {
          if (Optional.is(Struct.get(this, "selectedIndex")) && !isKeyboardEvent) {
            var element = this.collection.findByIndex(this.selectedIndex)
            if (Optional.is(element)) {
              element.items.forEach(function(item) {
                item.backgroundColor = Struct.contains(item, "colorHoverOut")
                  ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                  : item.backgroundColor
              })
            }
            this.selectedIndex = null
          }
        }
      }
    },
  })
  
  ///@type {Map<String, Callable>}
  updateAreaTemplates = new Map(String, Callable, {
    "applyLayout": function() {
      return function() {
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(this.layout.width())
        this.area.setHeight(this.layout.height())
      }
    },
    "applyLayoutTextField": function() {
      return function() {
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(max(this.layout.width(), this.textField.style.w_min))
        this.area.setHeight(this.layout.height())

        var _w = this.textField.style.w
        var _h = this.textField.style.h
        this.textField.style.w = this.area.getWidth()
        if (!this.textField.style.v_grow) {
          this.textField.style.h = this.area.getHeight()
          this.textField.updateStyle()
        }

        if (this.textField.style.w != _w || this.textField.style.h != _h) {
          this.textField.updateStyle()
        }
      }
    },
    "applyCollectionLayout": function() {
      return function() {
        if (this.component == null) {
          throw new Exception($"applyCollectionLayout require 'component' to be initialized")
        }

        this.layout.collection.setIndex(this.component.index)
        this.layout.collection.setSize(this.context.collection.size())
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(this.layout.width())
        this.area.setHeight(this.layout.height())
      }
    },
    "applyMargin": function() {
      return function() {
        this.area.setX(this.margin.left)
        this.area.setY(this.margin.top)
        this.area.setWidth(this.context.area.getWidth() 
          - this.margin.left - this.margin.right)
        this.area.setHeight(this.context.area.getHeight() 
          - this.margin.top - this.margin.bottom)
      }
    },
    "groupByX": function() {
      return function() {
        if (!Optional.is(Struct.get(this, "group"))) {
          throw new Exception($"groupByX require 'group' to be initialized")
        }

        ///@todo group.align support
        ///@todo group.amount support
        ///@todo group.width() support
        ///@todo group.height() support
        this.area.setWidth(this.context.area.getHeight()
          - this.margin.left - this.margin.right)
        this.area.setHeight(this.context.area.getHeight()
          - this.margin.top - this.margin.bottom)
        this.area.setX(this.context.area.getWidth() 
          - (this.area.getWidth() * (this.group.index + 1)))
        this.area.setY(this.margin.top)
      }
    },
    "groupByXWidth": function() {
      return function() {
        if (!Optional.is(Struct.get(this, "group"))) {
          throw new Exception($"groupByXWidth require 'group' to be initialized")
        }

        ///@todo group.align support
        ///@todo group.amount support
        ///@todo group.width() support
        ///@todo group.height() support
        this.area.setWidth(this.group.width)
        this.area.setHeight(this.context.area.getHeight()
          - this.margin.top - this.margin.bottom)
        this.area.setX(this.context.area.getWidth() 
          - (this.area.getWidth() * (this.group.index + 1)))
        this.area.setY(this.margin.top)
      }
    },

    ///@deprecated
    "layout": function() {
      return function() {
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(this.layout.width())
        this.area.setHeight(this.layout.height())
      }
    },
    "scrollable": function() {
      return function() {
        var viewWidth = this.fetchViewWidth()
        this.offsetMax.x = viewWidth >= this.area.getWidth()
            ? abs(this.area.getWidth() - viewWidth) + this.margin.right
            : 0.0
        this.offset.x = clamp(this.offset.x, -1 * this.offsetMax.x, 0.0)

        var viewHeight = this.fetchViewHeight()
        this.offsetMax.y = viewHeight >= this.area.getHeight()
            ? abs(this.area.getHeight() - viewHeight) + this.margin.bottom
            : 0.0
        this.offset.y = clamp(this.offset.y, -1 * this.offsetMax.y, 0.0)
      }
    },
    "scrollableX": function() {
      return function() {
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(this.layout.width())
        this.area.setHeight(this.layout.height())

        var viewWidth = this.fetchViewWidth()
        this.offsetMax.x = viewWidth >= this.area.getWidth()
            ? abs(this.area.getWidth() - viewWidth) + this.margin.right
            : 0.0
        this.offset.x = clamp(this.offset.x, -1 * this.offsetMax.x, 0.0)
      }
    },
    "scrollableY": function() {
      return function() {
        this.area.setX(this.layout.x())
        this.area.setY(this.layout.y())
        this.area.setWidth(this.layout.width())
        this.area.setHeight(this.layout.height())

        var viewHeight = this.fetchViewHeight()
        this.offsetMax.y = viewHeight >= this.area.getHeight()
            ? abs(this.area.getHeight() - viewHeight) + this.margin.bottom
            : 0.0
        this.offset.y = clamp(this.offset.y, -1 * this.offsetMax.y, 0.0)

        var scrollbarY = Struct.get(this, "scrollbarY")
        ///@todo unreachable code
        if (Struct.get(scrollbarY, "isDragEvent")) {
          if (mouse_check_button(mb_left)) { ///@todo button should be a parameter
            this.onMousePressedLeft(new Event("MouseOnLeft", { 
              x: MouseUtil.getMouseX(), 
              y: MouseUtil.getMouseY(),
            }))
          } else {
            Struct.set(scrollbarY, "isDragEvent", false)
          }
        }
      }
    },
    ///@description cached scrollableY
    "__scrollableY": function() { 
      return function() {
        var resetLayoutCache = false
        var scrollbarY = Struct.get(this, "scrollbarY")
        if (Struct.get(scrollbarY, "isDragEvent")) {
          resetLayoutCache = true
          if (mouse_check_button(mb_left)) { ///@todo button should be a parameter
            this.onMousePressedLeft(new Event("MouseOnLeft", { 
              x: MouseUtil.getMouseX(), 
              y: MouseUtil.getMouseY(),
            }))
          } else {
            Struct.set(scrollbarY, "isDragEvent", false)
          }
        }

        var viewHeight = this.fetchViewHeight()
        this.offsetMax.y = viewHeight >= this.area.getHeight()
          ? abs(this.area.getHeight() - viewHeight) + this.margin.bottom
          : 0.0
        this.offset.y = clamp(this.offset.y, -1 * this.offsetMax.y, 0.0)
        
        var layoutCache = Struct.get(this, "layoutCache")
        if (!Core.isType(layoutCache, Struct)) {
          layoutCache = {
            x: -1,
            y: -1,
            width: -1,
            height: -1,
            viewHeight: -1,
            displayWidth: GuiWidth(), ///@todo replace GuiWidth with DisplayService call
            displayHeight: GuiHeight(), ///@todo replace GuiHeight with DisplayService call
            finalized: false,
            resetItemsCache: false,
          }
          Struct.set(this, "layoutCache", layoutCache)
        }
        layoutCache.resetItemsCache = false

        if (layoutCache.displayWidth != GuiWidth() ///@todo replace GuiWidth with DisplayService call
          || layoutCache.displayHeight != GuiHeight()) { ///@todo replace GuiHeight with DisplayService call
          resetLayoutCache = true
        }

        if (resetLayoutCache) {
          layoutCache.finalized = false
        }

        if (layoutCache.finalized) {
          return
        }

        var _x = this.layout.x()
        var _y = this.layout.y()
        var _width = this.layout.width()
        var _height = this.layout.height()
        this.area.setX(_x)
        this.area.setY(_y)
        this.area.setWidth(_width)
        this.area.setHeight(_height)

        if (layoutCache.x == _x
          && layoutCache.y == _y
          && layoutCache.width == _width
          && layoutCache.height == _height) {

          layoutCache.finalized = true
        }

        layoutCache.x = _x
        layoutCache.y = _y
        layoutCache.width = _width
        layoutCache.height = _height
        layoutCache.viewHeight = viewHeight
        layoutCache.displayWidth = GuiWidth() ///@todo replace GuiWidth with DisplayService call
        layoutCache.displayHeight = GuiHeight() ///@todo replace GuiHeight with DisplayService call
        layoutCache.resetItemsCache = resetLayoutCache
      }
    },
  })

  ///@type {Map<String, Callable>}
  renderTemplates = new Map(String, Callable, {
    "renderDefault": function() {
      return Core.getProperty("core.ui-service.use-surface-optimalization", false)
        ? function() {
          if (this.surface == null) {
            this.surface = new Surface(this.area.getWidth(), this.area.getHeight())
          }

          this.surface.update(this.area.getWidth(), this.area.getHeight())
          if (!this.surfaceTick.get() && !this.surface.updated) {
            this.surface.render(this.area.getX(), this.area.getY())
            return
          }
          
          GPU.set.surface(this.surface)
          var color = this.state.get("background-color")
          if (Optional.is(color)) {
            GPU.render.clear(color, this.state.getDefault("background-alpha", 1.0))
          }
          
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          DeltaTime.deltaTime = delta
  
          GPU.reset.surface()
          this.surface.render(this.area.getX(), this.area.getY())
        }
        : function() {
          var color = this.state.get("background-color")
          if (Core.isType(color, GMColor)) {
            GPU.render.rectangle(
              this.area.x, this.area.y, 
              this.area.x + this.area.getWidth(), this.area.y + this.area.getHeight(), 
              false,
              color, color, color, color, 
              this.state.getIfType("background-alpha", Number, 1.0)
            )
          }
          
          this.items.forEach(this.renderItem, this.area)
        }
    },
    "renderDefaultNoSurface": function() {
      return function() {
        var color = this.state.get("background-color")
        if (Core.isType(color, GMColor)) {
          GPU.render.rectangle(
            this.area.x, this.area.y, 
            this.area.x + this.area.getWidth(), this.area.y + this.area.getHeight(), 
            false,
            color, color, color, color, 
            this.state.get("background-alpha")
          )
        }
        
        this.items.forEach(this.renderItem, this.area)
      }
    },
    "renderDefaultScrollable": function() {
       return function() {
        if (!Optional.is(this.surface)) {
          this.surface = new Surface()
        }

        this.surface.update(this.area.getWidth(), this.area.getHeight())
        if (!this.surfaceTick.get() && !this.surface.updated) {
          GPU.set.blendEnable(false)
          this.surface.render(this.area.getX(), this.area.getY())
          GPU.set.blendEnable(true)
          if (this.enableScrollbarY) {
            this.scrollbarY.render(this)
          }
          return
        }

        this.surface.renderOn(this.renderSurface)
        GPU.set.blendEnable(false)
        this.surface.render(this.area.getX(), this.area.getY())
        GPU.set.blendEnable(true)

        if (this.enableScrollbarY) {
          this.scrollbarY.render(this)
        }
      }
    },
    "renderDefaultScrollableAlpha": function() {
       return function() {
        if (!Optional.is(this.surface)) {
          this.surface = new Surface()
        }

        var alpha = this.state.getIfType("surface-alpha", Number, 1.0)
        this.surface.update(this.area.getWidth(), this.area.getHeight())
        if (!this.surfaceTick.get() && !this.surface.updated) {
          GPU.set.blendEnable(alpha < 1.0)
          this.surface.render(this.area.getX(), this.area.getY(), alpha)
          GPU.set.blendEnable(true)
          if (this.enableScrollbarY) {
            this.scrollbarY.render(this)
          }
          return
        }

        this.surface.renderOn(this.renderSurface)
        GPU.set.blendEnable(alpha < 1.0)
        this.surface.render(this.area.getX(), this.area.getY(), alpha)
        GPU.set.blendEnable(true)

        if (this.enableScrollbarY) {
          this.scrollbarY.render(this)
        }
      }
    },
    "renderDefaultScrollableBlend": function() {
      return function() {
        if (!Optional.is(this.surface)) {
          this.surface = new Surface()
        }

        this.surface.update(this.area.getWidth(), this.area.getHeight())
        if (!this.surfaceTick.get() && !this.surface.updated) {
          this.surface.render(this.area.getX(), this.area.getY())
          if (this.enableScrollbarY) {
            this.scrollbarY.render(this)
          }
          return
        }

        this.surface.renderOn(this.renderSurface)
        this.surface.render(this.area.getX(), this.area.getY())

        if (this.enableScrollbarY) {
          this.scrollbarY.render(this)
        }
     }
   },
    "renderItemDefault": function() {
      return function(item, iterator, area) {
        item.render()
      }
    },
    "renderItemDefaultScrollable": function() {
      return function(item, iterator, area) {
        var itemX = item.area.x
        var itemY = item.area.y
        var areaX = abs(area.x)
        var areaY = abs(area.y)
        if (Math.rectangleOverlaps(
          itemX, itemY,
          itemX + item.area.z, itemY + item.area.a,
          areaX, areaY,
          areaX + area.z, areaY + area.a)) {
          item.render()
        }
      }
    },
  })

  ///@type {Map<String, Callable>}
  mouseEventTemplates = new Map(String, Callable, {
    "scrollableOnMouseWheelUpX": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.x + this.state.getDefault("offset-x", 54), 
          -1 * this.offsetMax.x, 0)
      }
    },
    "scrollableOnMouseWheelDownX": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.x - this.state.getDefault("offset-x", 54), 
          -1 * this.offsetMax.x, 0)
      }
    },
    "scrollableOnMouseWheelUpY": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.y + this.state.getDefault("offset-y", 54), 
          -1 * this.offsetMax.y, 0)
      }
    },
    "scrollableOnMouseWheelDownY": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.y - this.state.getDefault("offset-y", 54), 
          -1 * this.offsetMax.y, 0)
      }
    },
    "onMouseScrollbarY": function() {
      return function(event) {
        var _x = event.data.x - this.area.getX()
        var _y = event.data.y - this.area.getY()
        var collide = this.scrollbarY.align == HAlign.LEFT
          ? (_x <= 0)
          : (_x >= this.area.getWidth())
        var scrollbarY = Struct.get(this, "scrollbarY")
        if (collide) || (Struct.get(scrollbarY, "isDragEvent") == true) {
          var ratio = _y / this.area.getHeight() 
          this.offset.y = clamp(-1 * (this.offsetMax.y * ratio), -1 * this.offsetMax.y, 0)
          Struct.set(scrollbarY, "isDragEvent", true)
        }
      }
    },
    "onMouseHoverOverBackground": function() {
      return function(event) {
        this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
      }
    },
    "onMouseHoverOutBackground": function() {
      return function(event) {
        this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
      }
    },
  })

  ///@type {Map<String, Callable>}
  itemUpdateTemplates = new Map(String, Callable, {
    ///@description cached
    "applyLayoutCached": function() {
      return function() {

        var layoutCache = Struct.get(this, "layoutCache")
        if (!Core.isType(layoutCache, Struct)) {
          layoutCache = {
            x: -1,
            y: -1,
            width: -1,
            height: -1,
            finalized: false,
          }
          Struct.set(this, "layoutCache", layoutCache)
        }

        if (layoutCache.finalized) {
          return
        }

        var _x = this.layout.x()
        var _y = this.layout.y()
        var _width = this.layout.width()
        var _height = this.layout.height()
        this.area.setX(_x)
        this.area.setY(_y)
        this.area.setWidth(_width)
        this.area.setHeight(_height)

        if (layoutCache.x == _x
          && layoutCache.y == _y
          && layoutCache.width == _width
          && layoutCache.height == _height) {

          layoutCache.finalized = true
        }

        layoutCache.x = _x
        layoutCache.y = _y
        layoutCache.width = _width
        layoutCache.height = _height
      }
    },
    "updateScrollableXItem": function() {
      if (!this.state.contains("index")) {
        throw new Exception($"updateScrollableXItem require 'state.index' to be initialized")
      }

      var width = this.context.area.getWidth() / this.context.items.size()
      this.area.setX(this.state.get("index") * width)
      this.area.setY(0)
      this.area.setWidth(width)
      this.area.setHeight(this.context.area.getHeight())
    },
    "updateScrollableYItem": function() {
      if (!this.state.contains("index")) {
        throw new Exception($"updateScrollableYItem require 'state.index' to be initialized")
      }

      var height = this.context.area.getHeight() / this.context.items.size()
      this.area.setX(0)
      this.area.setY(this.state.get("index") * height)
      this.area.setWidth(this.context.area.getWidth())
      this.area.setHeight(height)
    },
  })

  ///@param {UIItem} uiItem
  ///@param {Type} type
  ///@param {any} [defaultValue]
  ///@return {any}
  getIncreaseUIStoreItem = function(uiItem, type, defaultValue = null) {
    var factor = Struct.get(uiItem, "factor")
    if (!Core.isType(factor, Number) || !Core.isType(uiItem.store, UIStore)) {
      return defaultValue
    }

    var item = uiItem.store.get()
    if (!Core.isType(item, StoreItem)) {
      return defaultValue
    }

    var value = item.get()
    return Core.isType(value, type) ? item : defaultValue
  }

  ///@param {Struct}
  passthrough = {

    ///@return {Callable}
    getClampedStringInteger: function() {
      return function(value) {
        if (!Core.isType(this.data, Vector2)) {
          this.data = new Vector2(0.0, 1.0)
        }

        return round(clamp(NumberUtil.parse(value, this.value), this.data.x, this.data.y))
      }
    },

    ///@return {Callable}
    getClampedStringNumber: function() {
      return function(value) {
        if (!Core.isType(this.data, Vector2)) {
          this.data = new Vector2(0.0, 1.0)
        }

        return clamp(NumberUtil.parse(value, this.value), this.data.x, this.data.y)
      }
    },

    ///@return {Callable}
    getNormalizedStringNumber: function() {
      return function(value) {
        return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
      }
    },

    ///@return {Callable}
    getClampedNumberTransformer: function() {
      return function(value) {
        if (!Core.isType(value, NumberTransformer)) {
          return this.value
        }

        if (!Core.isType(this.data, Vector2)) {
          this.data = new Vector2(0.0, 1.0)
        }

        value.value = clamp(value.value, this.data.x, this.data.y)
        value.target = clamp(value.target, this.data.x, this.data.y)
        return value
      }
    },

    ///@return {Callable}
    getNormalizedNumberTransformer: function() {
      return function(value) {
        if (!Core.isType(value, NumberTransformer)) {
          return this.value
        }

        value.value = clamp(value.value, 0.0, 1.0)
        value.target = clamp(value.target, 0.0, 1.0)
        return value
      }
    },

    ///@return {Callable}
    getArrayValue: function() {
      return function(value) {
        return this.data.contains(value) 
          ? value 
          : (this.data.contains(this.value) ? this.value : this.data.getFirst())
      }
    },

    ///@return {Callable}
    getGMArrayValue: function() {
      return function(value) {
        return GMArray.contains(this.data, value)
          ? value 
          : (GMArray.contains(this.data, this.value) ? this.value : GMArray.getFirst(this.data))
      }
    },

    ///@return {Callable}
    getCallbackValue: function() {
      return function(value) {
        var contains = this.data.callback
        return contains(value) 
          ? value 
          : (contains(this.value) ? this.value : Struct.get(this.data, "defaultValue"))
      }
    },
  }

  ///@param {UI} container
  ///@param {any} iterator
  ///@param {Number} cooldown
  ///@return {UI}
  clampUpdateTimerToCooldown = function(container, iterator, cooldown) {
    if (!Optional.is(container.updateTimer)) {
      return container
    }

    var timer = container.updateTimer
    var duration = timer.duration
    timer.time = clamp(timer.time, max(duration - (cooldown * FRAME_MS), 0.0), duration * 2.0)
    return container
  }

  ///@param {Struct}
  serialize = {
    getStringStruct: function() {
      return function() {
        return JSON.parse(this.get())
      }
    },
  }
  
  ///@param {Struct}
  validate = {
    getStringStruct: function() {
      return function(value) {
        Assert.isType(JSON.parse(value), Struct)
      }
    },
  }
}
global.__UIUtil = new _UIUtil()
#macro UIUtil global.__UIUtil
