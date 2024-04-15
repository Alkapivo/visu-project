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

  ///@private
  ///@type {Boolean}
  renderSurfaceTick = false

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

  updateItems = Struct.contains(config, "updateItems")
    ? Assert.isType(method(this, config.updateItems), Callable)
    : function() {
      var updateItemArea = !this.renderSurfaceTick
      if (Optional.is(this.updateTimer)) {
        updateItemArea = this.updateTimer.finished
      }
      this.items.forEach(this.updateItem, updateItemArea)
    }

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
      this.items.add(item, item.name)
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
      this.renderSurfaceTick = !this.renderSurfaceTick
      if (!this.renderSurfaceTick) {
        return
      }

      var color = this.state.get("background-color")
      GPU.render.clear(Core.isType(color, GMColor) 
        ? ColorUtil.fromGMColor(color) 
        : ColorUtil.BLACK_TRANSPARENT)

      var deltaTime = DeltaTime.deltaTime

      ///@hack
      ///@description 2 *, because `renderSurfaceTick`
      DeltaTime.deltaTime = 2 * deltaTime 

      var areaX = this.area.x
      var areaY = this.area.y
      this.area.x = this.offset.x
      this.area.y = this.offset.y
      this.items.forEach(this.renderItem, this.area)
      this.area.x = areaX
      this.area.y = areaY
      DeltaTime.deltaTime = deltaTime
    }

  ///@param {UIItem} item
  renderItem = method(this, Assert.isType(
    Struct.contains(config, "renderItem")
      ? config.renderItem
      : Callable.run(UIUtil.renderTemplates.get("renderItemDefault")), 
    Callable))

  ///@return {UI}
  render = Struct.contains(config, "render")
    ? Assert.isType(method(this, config.render), Callable)
    : function() {
      this.items.forEach(this.renderItem, this.area)
      return this
    }

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
  
  ///@param {Array<UIComponents>} components
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {UI}
  addUIComponents = Struct.contains(config, "addUIComponents")
    ? Assert.isType(method(this, config.addUIComponents), Callable)
    : function(components, layout, config = null) {
    
    static factoryComponent = function(component, index, acc) {
      static add = function(item, index, acc) {
        if (item.type == UITextField) {
          var textField = item.textField
          if (Optional.is(acc.textField)) {
            acc.textField.setNext(textField)
            textField.setPrevious(acc.textField)
          }
          acc.textField = textField
        }

        acc.context.add(item, item.name)
        if (Optional.is(item.updateArea())) {
          item.updateArea()
        }
      }

      acc.layout = component
        .toUIItems(acc.layout)
        .forEach(add, acc)
        .getLast().layout.context
    }

    var context = this
    components.forEach(
      factoryComponent, 
      Struct.append(
        config,
        {
          layout: layout,
          context: context,
          textField: null
        },
        false
      )
    )
    return this
  }

  ///@type {?Timer}
  updateTimer = Core.isType(Struct.get(config, "updateTimer"), Timer)
    ? config.updateTimer 
    : null
  
  ///@type {Struct}
  scrollbarY = Struct.appendRecursive(
    {
      isDragEvent: false,
      align: HAlign.LEFT,
      width: 10,
      thickness: 3,
      color: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
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
        GPU.render.rectangle(x1, y1, x2, y2, false, this.color)
      }
    },
    Struct.getDefault(config, "scrollbarY", {})
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
  this.items.forEach(function(item) {
    if (Optional.is(item.updateArea)) {
      item.updateArea()
    }
  }) 
}


///@static
function _UIUtil() constructor {

  ///@type {Map<String, Callable>}
  templates = new Map(String, Callable, {
    "removeUIItemfromUICollection": function() {
      return function() {
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
        if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
          var previousElement = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
          if (Optional.is(previousElement)) {
            previousElement.items.forEach(function(item) {
              if (!Struct.contains(item, "colorHoverOut")) {
                return
              }
              item.backgroundColor = ColorUtil.fromHex(item.colorHoverOut).toGMColor()
            })
          }

          this.selectedIndex = (abs(this.offset.y) + (mouseY - areaY)) div size
          var currentElement = this.collection.findByIndex(this.selectedIndex)
          if (Optional.is(currentElement)) {
            currentElement.items.forEach(function(item) {
              if (!Struct.contains(item, "colorHoverOver")) {
                return
              }
              item.backgroundColor = ColorUtil.fromHex(item.colorHoverOver).toGMColor()
            })
          }
        } else {
          if (Optional.is(Struct.get(this, "selectedIndex"))) {
            var element = this.collection.findByIndex(this.selectedIndex)
            if (Optional.is(element)) {
              element.items.forEach(function(item) {
                if (!Struct.contains(item, "colorHoverOut")) {
                  return
                }
                item.backgroundColor = ColorUtil.fromHex(item.colorHoverOut).toGMColor()
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
        }

        if (this.textField.style.w != _w || this.textField.style.h != _h) {
          this.textField.update_style()
        }
      }
    },
    "applyCollectionLayout": function() {
      return function() {
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

        this.surface.update(round(this.area.getWidth()), round(this.area.getHeight()))
          .renderOn(this.renderSurface)
        GPU.set.blendEnable(false)
        this.surface.render(this.area.getX(), this.area.getY())
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

       this.surface.update(round(this.area.getWidth()), round(this.area.getHeight()))
         .renderOn(this.renderSurface)
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
        this.offset.y = clamp(this.offset.x + this.state.getDefault("offset-x", 34), 
          -1 * this.offsetMax.x, 0)
      }
    },
    "scrollableOnMouseWheelDownX": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.x - this.state.getDefault("offset-x", 34), 
          -1 * this.offsetMax.x, 0)
      }
    },
    "scrollableOnMouseWheelUpY": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.y + this.state.getDefault("offset-y", 34), 
          -1 * this.offsetMax.y, 0)
      }
    },
    "scrollableOnMouseWheelDownY": function() {
      return function(event) {
        this.offset.y = clamp(this.offset.y - this.state.getDefault("offset-y", 34), 
          -1 * this.offsetMax.y, 0)
      }
    },
    "onMouseScrollbarY": function() {
      return function(event) {
        var _x = event.data.x - this.area.getX()
        var _y = event.data.y - this.area.getY()
        var collide = this.scrollbarY.align == HAlign.LEFT
          ? (_x <= this.scrollbarY.width)
          : (_x >= this.area.getWidth() - this.scrollbarY.width)
        var scrollbarY = Struct.get(this, "scrollbarY")
        if (collide) || (Struct.get(scrollbarY, "isDragEvent") == true) {
          var ratio = _y / this.area.getHeight() 
          this.offset.y = clamp(-1 * (this.offsetMax.y * ratio), -1 * this.offsetMax.y, 0)
          Struct.set(scrollbarY, "isDragEvent", true)
        }
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
}
global.__UIUtil = new _UIUtil()
#macro UIUtil global.__UIUtil
