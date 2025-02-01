///@package io.alkapivo.core.service.ui.item

///@param {String} name
///@param {Struct} [json]
///@return {UIItem}
function UIText(name, json = null) {
  return new UIItem(name, Struct.append(json, {

    ///@param {Callable}
    type: UIText,

    ///@type {UILabel}
    label: new UILabel(json),

    ///@type {Boolean}
    value: Struct.contains(json, "value") ? Assert.isType(json.value, Boolean) : true,

    ///@type {?Struct}
    enable: Struct.getIfType(json, "enable", Struct),
    
    updateEnable: Optional.is(Struct.getIfType(json, "updateEnable", Callable))
      ? json.updateEnable
      : Callable.run(UIItemUtils.templates.get("updateEnable")),

    renderBackgroundColor: new BindIntent(Callable.run(UIItemUtils.templates.get("renderBackgroundColor"))),

    ///@override
    ///@return {UIItem}
    render: Struct.getDefault(json, "render", function() {
      if (Optional.is(this.preRender)) {
        this.preRender()
      }
      this.renderBackgroundColor()

      if (Core.isType(this.enable, Struct)) {
        this.label.alpha = (Struct.get(this.enable, "value") == false ? 0.5 : 1.0)
          * Struct.inject(this.enable, "alpha", this.label.alpha)
      }

      var offsetX = 0
      if (this.label.align.h == HAlign.CENTER) {
        offsetX = this.area.getWidth() / 2
      }
      if (this.label.align.h == HAlign.RIGHT) {
        offsetX = this.area.getWidth()
      }

      var offsetY = 0
      if (this.label.align.v == VAlign.CENTER) {
        offsetY = this.area.getHeight() / 2
      }
      if (this.label.align.v == VAlign.BOTTOM) {
        offsetY = this.area.getHeight()
      }

      this.label.render(
        this.context.area.getX() + this.area.getX() + offsetX,
        this.context.area.getY() + this.area.getY() + offsetY,
        this.area.getWidth(),
        this.area.getHeight()
      )

      if (this.postRender != null) {
        this.postRender()
      }
      
      return this
    }),
  }, false))
}