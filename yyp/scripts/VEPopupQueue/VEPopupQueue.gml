///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
function VEPopupQueue(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Array<UI>}
  containers = new Array(UI)

  ///@type {Number}
  SIZE_LIMIT = 3

  ///@type {Number}
  WIDTH_MAX = 960

  ///@param {?Struct} [config]
  ///@return {UILayout}
  factoryLayout = function(config = null) {
    return new UILayout({
      name: "ve-popup-queue_item",
      index: Assert.isType(Struct.getDefault(config, "index", 0), Number),
      _x: 0,
      _y: 28,
      _width: 300,
      _height: 48,
      _margin: 8,
      x: function() { return this._x + this.margin.left },
      y: function() { return this._y + (index * this.height()) + (index * _margin) },
      width: function() { return this._width - this.margin.left - this.margin.right },
      height: function() { return this._height },
      margin: { right: 48, left: 48 },
      nodes: {
        icon: {
          name: "ve-popup-queue_item.icon",
          _offsetY: 0,
          _width: 0,
          _height: 0,
          x: function() { return this.margin.left },
          y: function() { return this._offsetY + this.margin.top },
          width: function() { return _width - this.margin.left - this.margin.right },
          height: function() { return _height - this.margin.top - this.margin.bottom },
          //margin: { top: 4, right: 4, bottom: 4, left: 4 },
        },
        message: {
          name: "ve-popup-queue_item.message",
          _height: 48,
          x: function() { return this.context.nodes.icon.right() + this.margin.left },
          y: function() { return this.margin.top },
          width: function() { return this.context.width()
            - this.context.nodes.icon.width()
            - this.context.nodes.icon.margin.left
            - this.context.nodes.icon.margin.right
            - this.context.nodes.close.width()
            - this.context.nodes.close.margin.left
            - this.context.nodes.close.margin.right
            - this.margin.left 
            - this.margin.right
          },
          height: function() { return this._height
            - this.margin.top 
            - this.margin.bottom },
          margin: { top: 4, right: 4, bottom: 4, left: 4 },
        },
        close: {
          name: "ve-popup-queue_item.close",
          _offsetY: 0,
          _width: 32,
          _height: 32,
          x: function() { return this.context.nodes.message.right() + this.margin.left },
          y: function() { return this._offsetY + this.margin.top },
          width: function() { return this._width - this.margin.left - this.margin.right },
          height: function() { return this._height - this.margin.top - this.margin.bottom },
          margin: { top: 12, right: 4, bottom: -4, left: 4 },
        },
      }
    })
  }

  ///@private
  ///@param {?Struct} [config]
  ///@return {UI}
  factoryContainer = function(config = null) {
    var controller = this
    var layout = this.factoryLayout(Struct.get(config, "layout"))
    var key = md5_string_utf8(string(1000000 + random(9000000) + random(9000000)))
    var ui = new UI({
      name: $"ve-popup-item_{key}",
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
        "background-alpha": 0.66,
      }),
      controller: controller,
      layout: layout,
      scrollbarY: { align: HAlign.LEFT },
      timeout: new Timer(Assert.isType(Struct.getDefault(config, "timeout", 3.0), Number)),
      timeoutLine: new TexturedLine({ 
        thickness: 10,
        blend: VETheme.color.accent,
        cornerTo: { name: "texture_empty" },
        cornerFrom: { name: "texture_empty" },
      }),
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
      updateCustom: function() {
        var index = this.controller.containers
          .findIndex(Lambda.equal, this.name)
        
        if (Core.isType(index, Number)) {
          this.layout.index = index
        }

        if (Core.isType(this.timeout, Timer) && this.timeout.update().finished) {
          this.controller.dispatcher.send(new Event("remove", this.name))
        }
      },
      renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
      renderSurface: function() {
        var color = ColorUtil.fromGMColor(this.state.get("background-color"))
        color.alpha = this.state.get("background-alpha")
        GPU.render.clear(color)

        if (Core.isType(this.timeout, Timer)) {
          var lineY = this.area.getHeight() / 2.0
          this.timeoutLine.render(0, lineY, (1.0 - this.timeout.getProgress()) * this.area.getWidth(), lineY)
        }

        var areaX = this.area.x
        var areaY = this.area.y
        var delta = DeltaTime.deltaTime
        DeltaTime.deltaTime += this.surfaceTick.delta
        this.area.x = this.offset.x
        this.area.y = this.offset.y
        this.items.forEach(this.renderItem, this.area)
        this.area.x = areaX
        this.area.y = areaY
        DeltaTime.deltaTime = delta
      },
      render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableBlend")),
      onMouseHoverOver: function() {
        this.timeout = null
      },
      onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
      onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
      onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
      items: {
        "icon": {
          type: UIText,
          layout: layout.nodes.icon,
          text: "",
          font: "font_inter_10_regular",
          color: VETheme.color.textFocus,
          outline: true,
          outlineColor: VETheme.color.darkShadow,
          backgroundColor: VETheme.color.deny,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: function() {
            this.layout._offsetY = abs(this.context.offset.y)
            this.updateArea()
          },
        },
        "message": {
          type: UIText,
          layout: layout.nodes.message,
          text: "",
          _text: Assert.isType(Struct.getDefault(config, "message", ""), String),
          font: "font_consolas_12_bold",
          color: VETheme.color.textFocus,
          outline: true,
          outlineColor: VETheme.color.darkShadow,
          align: { v: VAlign.CENTER, h: HAlign.LEFT },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: function() {
            GPU.set.font(this.label.font.asset)
            var text = String.wrapText(this._text, this.area.getWidth(), "\n", 0)
            var lines = 1 + String.count(text, "\n")
            this.layout._height = lines == 1 ? this.context.area.getHeight() : lines * string_height("|")
            this.label.text = text
          },
          onMousePressedLeft: function(event) {
            this.context.controller.dispatcher.send(new Event("remove", this.context.name))
          },
        },
        "close": {
          type: UIText,
          layout: layout.nodes.close,
          text: "x",
          font: "font_inter_10_regular",
          color: VETheme.color.textFocus,
          outline: true,
          outlineColor: VETheme.color.darkShadow,
          backgroundColor: VETheme.color.denyShadow,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: function() {
            this.layout._offsetY = abs(this.context.offset.y)
            this.updateArea()
          },
          colorHoverOver: VETheme.color.deny,
          colorHoverOut: VETheme.color.denyShadow,
          onMouseHoverOver: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
          },
          onMouseHoverOut: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
          },
          onMousePressedLeft: function(event) {
            this.context.dispatcher.send(new Event("remove", this.context.name))
          },
        },
      }
    })

    return ui
  }
  
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "push": function(event) {
      if (this.containers.size() >= this.SIZE_LIMIT) {
        this.dispatcher.execute(new Event("remove", this.containers.get(0).name))
      }

      var size = this.containers.size()
      var container = this.factoryContainer(Struct.appendRecursiveUnique(
        event.data,
        { layout: { index: size } },
        false
      ))

      Beans.get(BeanVisuEditorController).uiService.send(new Event("add", {
        container: container,
        replace: true,
      }))

      this.containers.add(container)
    },
    "clear": function(event) {
      this.containers
        .forEach(function(container, index, uiService) {
          uiService.send(new Event("remove", { 
            name: container.name, 
            quiet: true,
          }))
        }, Beans.get(BeanVisuEditorController).uiService)
        .clear()
    },
    "remove": function(event) {
      var index = this.containers.findIndex(function(container, index, target) {
        return container.name == target
      }, event.data)

      if (!Core.isType(index, Number)) {
        return
      }
      
      Beans.get(BeanVisuEditorController).uiService.send(new Event("remove", { 
        name: event.data, 
        quiet: true,
      }))

      this.containers
        .remove(index)
        .forEach(function(container, index) {
          container.layout.index = index
        })
    }
  }), { 
    enableLogger: false, 
    catchException: true,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VEBrushToolbar}
  update = function() { 
    this.dispatcher.update()

    this.containers.forEach(function(container, index, context) {
      var layout = container.layout
      var preview = context.editor.layout.nodes.preview
      layout._width = min(preview.width(), context.WIDTH_MAX)
      layout._x = preview.x() + ((preview.width() - layout._width) / 2.0)
    }, this)
    return this
  }
}