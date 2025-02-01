///@package io.alkapivo.core.service.ui.item

///@param {String} name
///@param {Struct} [json]
///@return {UIItem}
function UICheckbox(name, json = null) {
  return new UIItem(name, Struct.append(json, {

    ///@param {Callable}
    type: UICheckbox,

    ///@type {Boolean}
    value: Assert.isType(Struct.getDefault(json, "value", false), Boolean),
    
    ///@type {?Sprite}
    spriteOn: Struct.contains(json, "spriteOn") 
      ? Assert.isType(SpriteUtil.parse(json.spriteOn), Sprite)
      : null,
    
    ///@type {?Sprite}
    spriteOff: Struct.contains(json, "spriteOff") 
      ? Assert.isType(SpriteUtil.parse(json.spriteOff), Sprite)
      : null,

    ///@type {?Struct}
    enable: Struct.getIfType(json, "enable", Struct),

    ///@type {Boolean}
    scaleToFillStretched: Struct.contains(json, "scaleToFillStretched")
      ? Assert.isType(json.scaleToFillStretched, Boolean)
      : true,
    
    ///@param {any} value
    updateValue: new BindIntent(Assert.isType(Struct.getDefault(json, "updateValue", function(value) {
      if (!Core.isType(value, Boolean)) {
        return
      }

      this.value = value
      if (Core.isType(this.callback, Callable)) {
        this.callback()
      }

      if (Core.isType(this.store, UIStore)) {
        this.store.set(this.value)
      }
    }), Callable)),

    updateEnable: Struct.getIfType(json, "updateEnable", Callable, Callable.run(UIItemUtils.templates.get("updateEnable"))),

    renderBackgroundColor: new BindIntent(Callable.run(UIItemUtils.templates.get("renderBackgroundColor"))),

    ///@override
    ///@return {UIItem}
    render: Struct.getDefault(json, "render", function() {
      if (Optional.is(this.preRender)) {
        this.preRender()
      }
      this.renderBackgroundColor()

      var sprite = this.value ? this.spriteOn : this.spriteOff
      if (sprite != null) {
        var alpha = sprite.getAlpha()
        if (this.scaleToFillStretched) {
          sprite.scaleToFillStretched(this.area.getWidth() - this.margin.left - this.margin.right, this.area.getHeight() - this.margin.top - this.margin.bottom)
        }
        sprite
          .setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
          .render(
            this.context.area.getX() + this.area.getX() + this.margin.left,
            this.context.area.getY() + this.area.getY() + this.margin.top
          )
          .setAlpha(alpha)
      }
      return this
    }),

    ///@type {?Callable}
    callback: Struct.contains(json, "callback")
      ? new BindIntent(Assert.isType(Struct.get(json, "callback"), Callable))
      : null,
    
    ///@param {Event} event
    onMouseReleasedLeft: Assert.isType(Struct.getDefault(json, "onMouseReleasedLeft", function(event) {
      if (Struct.get(this.enable, "value") == false) {
        return
      }

      if (Optional.is(this.updateValue)) {
        this.updateValue(this.value == true ? false : true)
      }

      if (Optional.is(this.context)) {
        this.context.clampUpdateTimer(0.7500)
      }
    }), Callable),
  }, false))
}
