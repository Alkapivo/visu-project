///@package io.alkapivo.core.service.ui

///@param {Struct} json
function UIComponent(json) constructor {

  ///@type {String}
  name = Assert.isType(Struct.get(json, "name"), String)

  ///@type {Callable}
  template = Assert.isType(Struct.get(json, "template"), Callable)

  ///@type {Callable}
  layout = Assert.isType(Struct.get(json, "layout"), Callable)

  ///@type {any}
  config = Struct.get(json, "config")

  ///@param {?UILayout} [layout]
  ///@return {Array<UIItem>}
  toUIItems = function(layout) {
    return this.template(
      this.name, 
      new UILayout(
        this.layout(Struct.get(this.config, "layout"), Struct.get(this.config, "layout")), 
        layout
      ), 
      this.config
    )
  }
}
