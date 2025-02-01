///@package io.alkapivo.core.service.ui.item

///@param {String} name
///@param {Struct} [json]
///@return {UIItem}
function UIButton(name, json = null) {
  return new UIItem(name, Struct.append(json, {

    ///@param {Callable}
    type: UIButton,
    
    ///@type {?Struct}
    enable: Struct.getIfType(json, "enable", Struct),

    ///@type {?Sprite}
    sprite: Optional.is(Struct.get(json, "sprite"))
      ? SpriteUtil.parse(json.sprite)
      : null,
    
    ///@type {?UILabel}
    label: Optional.is(Struct.get(json, "label"))
      ? new UILabel(json.label)
      : null,

    ///@type {?Margin}
    backgroundMargin: Optional.is(Struct.get(json, "backgroundMargin"))
      ? new Margin(json.backgroundMargin)
      : null,

    ///@override
    updateEnable: Assert.isType(Optional.is(Struct.get(json, "updateEnable"))
      ? json.updateEnable
      : Callable.run(UIItemUtils.templates.get("updateEnable")), Callable),
    
    ///@private
    renderBackgroundColor: new BindIntent(Optional.is(Struct.get(json, "renderBackgroundColor"))
      ? json.renderBackgroundColor
      : Callable.run(UIItemUtils.templates.get("renderBackgroundColor"))),

    ///@override
    ///@return {UIItem}
    render: Struct.getIfType(json, "render", Callable, function() {
      if (Optional.is(this.preRender)) {
        this.preRender()
      }

      var enableFactor = (Struct.get(this.enable, "value") == false ? 0.5 : 1.0)
      var _backgroundAlpha = this.backgroundAlpha
      this.backgroundAlpha *= enableFactor
      this.renderBackgroundColor()
      this.backgroundAlpha = _backgroundAlpha

      if (this.sprite != null) {
        var spriteAlpha = this.sprite.getAlpha()
        this.sprite
          .setAlpha(spriteAlpha * enableFactor)
          .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
          .render(
            this.context.area.getX() + this.area.getX(),
            this.context.area.getY() + this.area.getY())
          .setAlpha(spriteAlpha)
      }

      if (this.label != null) {
        var labelAlpha = this.label.alpha
        this.label.alpha *= enableFactor
        this.label.render(
          // todo VALIGN HALIGN
          this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
          this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2),
          this.area.getWidth(),
          this.area.getHeight()
        )
        this.label.alpha = labelAlpha
      }

      if (this.postRender != null) {
        this.postRender()
      }
      
      return this
    }),

    ///@type {?Callable}
    callback: Optional.is(Struct.getIfType(json, "callback", Callable))
      ? new BindIntent(json.callback)
      : null,
    
    ///@param {Event} event
    onMouseReleasedLeft: Struct.getIfType(json, "onMouseReleasedLeft", Callable, function(event) {
      if (Struct.get(this.enable, "value") == false) {
        return
      }

      if (Optional.is(this.callback)) {
        this.callback()
      }

      if (Optional.is(this.context)) {
        this.context.clampUpdateTimer(0.7500)
      }
    }),
  }, false))
}
