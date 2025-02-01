///@package io.alkapivo.visu.ui

///@type {Map<String, Callable>}
global.__VisuComponents = new Map(String, Callable, {

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "menu-title": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}_menu-title",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable
                .run(UIUtil.updateAreaTemplates
                .get("applyLayout")),
            }, 
            VisuStyles.get("menu-title").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "menu-button-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}_menu-button-entry",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable
                .run(UIUtil.updateAreaTemplates
                .get("applyCollectionLayout")),
            }, 
            VisuStyles.get("menu-button-entry").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "menu-button-input-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}_menu-button-input-entry",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable
                .run(UIUtil.updateAreaTemplates
                .get("applyCollectionLayout")),
            }, 
            VisuStyles.get("menu-button-input-entry").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UIButton(
        $"checkbox_{name}_menu-button-input-entry",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.input,
              updateArea: Callable
                .run(UIUtil.updateAreaTemplates
                .get("applyCollectionLayout")),
            }, 
            VisuStyles.get("menu-button-input-entry").input,
            false
          ),
          Struct.get(config, "input"),
          false
        )
      )
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "menu-spin-select-entry": function(name, layout, config = null) {
    static factoryButton = function(name, layout, config) {
      return UIButton(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable
              .run(UIUtil.updateAreaTemplates
              .get("applyCollectionLayout")),
          }, 
          config, 
          false
        )
      )
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryPreview = function(name, layout, config) {
      return UIImage(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
          }, 
          config, 
          false
        )
      )
    }

    return new Array(UIItem, [
      UIText(
        $"{name}_label", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            },
            Struct.get(VisuStyles.get("menu-spin-select-entry"), "label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      factoryButton(
        $"{name}_previous",
        layout.nodes.previous,
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              increment: -1,
              onMouseHoverOver: function(event) {
                this.sprite.setBlend(ColorUtil.fromHex(VETheme.color.accentLight).toGMColor())
              },
              onMouseHoverOut: function(event) {
                this.sprite.setBlend(c_white)
              },            
            },
            Struct.get(config, "previous"), 
            false
          ), 
          Struct.get(VisuStyles.get("menu-spin-select-entry"), "previous"),
          false
        )
      ),
      factoryPreview(
        $"{name}_preview",
        layout.nodes.preview,
        Struct.appendRecursive(
          Struct.get(config, "preview"),
          Struct.get(VisuStyles.get("menu-spin-select-entry"), "preview"),
          false
        )
      ),
      factoryButton(
        $"{name}_next",
        layout.nodes.next,
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              increment: 1,
              onMouseHoverOver: function(event) {
                this.sprite.setBlend(ColorUtil.fromHex(VETheme.color.accentLight).toGMColor())
              },
              onMouseHoverOut: function(event) {
                this.sprite.setBlend(c_white)
              },            
            },
            Struct.get(config, "next"),
            false
          ),
          Struct.get(VisuStyles.get("menu-spin-select-entry"), "next"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "menu-keyboard-key-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"{name}_label", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            },
            Struct.get(VisuStyles.get("menu-keyboard-key-entry"), "label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UIText(
        $"{name}_preview", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.preview,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            },
            Struct.get(VisuStyles.get("menu-keyboard-key-entry"), "preview"),
            false
          ),
          Struct.get(config, "preview"),
          false
        )
      ),
    ])
  },
})
#macro VisuComponents global.__VisuComponents