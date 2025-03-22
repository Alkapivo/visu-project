///@package io.alkapivo.core.service.ui.item

///@param {String} name
///@param {Struct} [json]
///@return {UIItem}
function UISliderHorizontal(name, json = null) {
  var minValue = Struct.getIfType(json, "minValue", Number, 0.0)
  var maxValue = Struct.getIfType(json, "maxValue", Number, 1.0)
  if (minValue > maxValue) {
    var _value = minValue
    minValue = maxValue
    maxValue = _value
  }
  return new UIItem(name, Struct.append(json, {

    ///@param {Callable}
    type: UISliderHorizontal,

    ///@type {Number}
    value: Struct.getIfType(json, "value", Number, 0.0),

    ///@type {Number}
    minValue: minValue,

    ///@type {Number}
    maxValue: maxValue,

    ///@type {Number}
    snapValue: abs(Struct.getIfType(json, "snapValue", Number, 0.0)),

    ///@type {Sprite}
    pointer: Assert.isType(SpriteUtil.parse(Struct.getDefault(json, "pointer", {
      name: "texture_slider_pointer_default",
      scaleX: 0.6,
      scaleY: 0.6,
    })), Sprite),

    ///@type {TexturedLine}
    progress: new TexturedLine(Struct.getDefault(json, "progress", { 
      thickness: 0.75,
      blend: "#ff0000",
    })),

    ///@type {TexturedLine}
    background: new TexturedLine(Struct.getDefault(json, "background", {
      thickness: 0.75,
      blend: "#000000",
    })),

    ///@type {?Struct}
    enable: Struct.getIfType(json, "enable", Struct),

    ///@type {Callable}
    getClipboard: Struct.getIfType(json, "getClipboard", Callable, MouseUtil.getClipboard),

    ///@type {Callable}
    setClipboard: Struct.getIfType(json, "setClipboard", Callable, MouseUtil.setClipboard),

    ///@param {Number} mouseX
    ///@param {Number} mouseY
    updateValue: new BindIntent(Assert.isType(Struct.getDefault(json, "updateValue", function(mouseX, mouseY) {
      var position = clamp((this.context.area.getX() + mouseX - this.context.area.getX() - this.area.getX()) / this.area.getWidth(), 0.0, 1.0)
      if (this.snapValue > 0.0) {
        position = (floor(position / this.snapValue) * this.snapValue)
      }

      var length = abs(this.minValue - this.maxValue) * position
      var value = clamp(this.minValue + length, this.minValue, this.maxValue)
      if (value != this.value) {
        this.updatePosition(mouseX, mouseY)
      }

      if (Optional.is(this.store) && value != this.store.getValue()) {
        this.store.set(value)
      }
    }), Callable)),

    ///@param {Number} mouseX
    ///@param {Number} mouseY
    updatePosition: new BindIntent(Assert.isType(Struct.getDefault(json, "updatePosition", function(mouseX, mouseY) { }), Callable)),

    updateEnable: Struct.getIfType(json, "updateEnable", Callable, Callable.run(UIItemUtils.templates.get("updateEnable"))),

    ///@override
    ///@param {Boolean} [_updateArea]
    ///@return {UIItem}
    update: function(_updateArea = true) {
      if (_updateArea && Optional.is(this.updateArea)) {
        this.updateArea()
      }

      if (Optional.is(this.updateEnable)) {
        this.updateEnable()
      }

      if (Optional.is(this.updateCustom)) {
        this.updateCustom()
      }

      if (this.isHoverOver) {
        this.updateHover()
      }

      if (!storeSubscribed && Optional.is(this.store)) {
        this.store.subscribe()
        this.storeSubscribed = true
      }

      if (Core.isType(this.enable, Struct)) {
        var factor = Struct.get(this.enable, "value") == false ? 0.5 : 1.0
        if (Core.isType(this.pointer, Sprite)) {
          this.pointer.setAlpha(factor
            * Struct.inject(this.enable, "pointer-alpha", this.pointer.getAlpha()))
        }

        if (Core.isType(this.progress, TexturedLine)) {
          this.progress.alpha = factor
            * Struct.inject(this.enable, "progress-alpha", this.progress.alpha)
        }

        if (Core.isType(this.background, TexturedLine)) {
          this.background.alpha = factor
            * Struct.inject(this.enable, "background-alpha", this.background.alpha)
        }
      }

      return this
    },

    renderBackgroundColor: new BindIntent(Callable.run(UIItemUtils.templates.get("renderBackgroundColor"))),

    ///@return {UIItem}
    render: Struct.getDefault(json, "render", function() {
      var promise = this.getClipboard()
      if (Struct.get(Struct.get(promise, "state"), "context") == this) {
        var offsetX = Core.isType(Struct.get(this.context, "layout"), UILayout)
          ? this.context.layout.x() 
          : 0.0
        var offsetY = Core.isType(Struct.get(this.context, "layout"), UILayout)
          ? this.context.layout.y() 
          : 0.0
        this.updateValue(MouseUtil.getMouseX() - offsetX, MouseUtil.getMouseY() - offsetY)
      }
      
      if (Optional.is(this.preRender)) {
        this.preRender()
      }
      this.renderBackgroundColor()
      
      var fromX = this.context.area.getX() + this.area.getX()
      var fromY = this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2)
      var widthMax = this.area.getWidth()
      var width = ((this.value - this.minValue) / abs(this.minValue - this.maxValue)) * widthMax
      this.background.render(fromX, fromY, fromX + widthMax, fromY)
      this.progress.render(fromX, fromY, fromX + width, fromY)
      this.pointer.render(fromX + width, fromY)

      if (Optional.is(this.postRender)) {
        this.postRender()
      }
      
      return this
    }),

    ///@type {Callable}
    callback: new BindIntent(Assert.isType(Struct.getDefault(json, "callback", function() { }), Callable)),
    
    ///@param {Event} event
    onMouseReleasedLeft: Assert.isType(Struct.getDefault(json, "onMouseReleasedLeft", function(event) {
      if (Struct.get(this.enable, "value") == false) {
        return
      }

      var offsetX = Core.isType(Struct.get(this.context, "layout"), UILayout) 
        ? this.context.layout.x() 
        : 0.0
      var offsetY = Core.isType(Struct.get(this.context, "layout"), UILayout)
        ? this.context.layout.y() 
        : 0.0
      this.updateValue(MouseUtil.getMouseX() - offsetX, MouseUtil.getMouseY() - offsetY)
    }), Callable),

    ///@param {Event} event
    onMouseDragLeft: Assert.isType(Struct.getDefault(json, "onMouseDragLeft", function(event) {
      if (Struct.get(this.enable, "value") == false 
          || Optional.is(this.getClipboard())) {
        return
      }

      var context = this
      this.setClipboard(new Promise()
        .setState({
          context: context,
          callback: context.callback,
        })
        .whenSuccess(function() {
          Callable.run(Struct.get(this.state, "callback"))
        })
      )
    }), Callable),
  }, false))
}
