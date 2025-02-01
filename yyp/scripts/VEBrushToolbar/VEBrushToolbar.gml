///@package io.alkapivo.visu.editor.ui.controller

#macro BRUSH_ENTRY_STEP 1
#macro BRUSH_TOOLBAR_ENTRY_STEP 1


///@param {Struct} config
///@return {Struct}
function factoryVEBrushToolbarTypeItem(config, index) {
  return {
    name: config.name,
    template: VEComponents.get("type-button"),
    layout: VELayouts.get("horizontal-item"),
    config: {
      backgroundMargin: { top: 1, bottom: 2, left: (index == 0 ? 0 : 1), right: 1 },
      callback: function() {
        var brushToolbar = this.context.brushToolbar
        var templatesCache = brushToolbar.templatesCache
        var store = brushToolbar.store
        var template = store.getValue("template")
        if (Optional.is(template)) {
          templatesCache.set(template.type, template.toStruct())
        }

        if (store.getValue("type") != this.brushType) {
          store.get("type").set(this.brushType)
          var templateCached = templatesCache.get(this.brushType)
          if (Optional.is(templateCached)) {
            template = new VEBrushTemplate(templateCached)
            store.get("template").set(template)
          }
        }
      },
      updateCustom: function() {
        this.backgroundColor = this.brushType == this.context.brushToolbar.store.getValue("type")
          ? this.backgroundColorOn
          : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
      },
      onMouseHoverOver: function(event) { },
      onMouseHoverOut: function(event) { },
      label: {text: config.text },
      brushType: config.brushType,
    },
  }
}


///@todo move to VEBrushToolbar
///@static
///@type {Map<String, Callable>}
global.__VisuBrushContainers = new Map(String, Callable, {
  "accordion": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-alpha": 1.0,
        "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
      }),
      brushToolbar: brushToolbar,
      updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.brush-toolbar.accordion.updateTimer", 10.0), { loop: Infinity, shuffle: true }),
      updateTimerCooldown: Core.getProperty("visu.editor.ui.brush-toolbar.accordion.updateTimer.cooldown", 4.0),
      layout: brushToolbar.layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "resize_brush_toolbar": {
          type: UIButton,
          layout: brushToolbar.layout.nodes.resize,
          backgroundColor: VETheme.color.primaryShadow, //resize
          clipboard: {
            name: "resize_brush_toolbar",
            drag: function() {
              Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_HORIZONTAL)
            },
            drop: function() {
              Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
            }
          },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: function() {
            var editorIO = Beans.get(BeanVisuEditorIO)
            var mouse = editorIO.mouse
            if (mouse.hasMoved() && mouse.getClipboard() == this.clipboard) {
              this.updateLayout(MouseUtil.getMouseX())
              this.context.brushToolbar.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

              // reset timeline timer to avoid ghost effect,
              // because brushtoolbar height is affecting timeline height
              Beans.get(BeanVisuEditorController).timeline.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

              if (!mouse_check_button(mb_left)) {
                Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            }
          },
          updateLayout: new BindIntent(function(position) {
            var editor = Beans.get(BeanVisuEditorController)
            var node = Struct.get(editor.layout.nodes, "brush-toolbar")
            node.percentageWidth = abs(GuiWidth() - position) / GuiWidth()

            var events = editor.uiService.find("ve-timeline-events")
            if (Optional.is(events)) {
              UIUtil.clampUpdateTimerToCooldown(events, "ve-timeline-events", this.context.updateTimerCooldown)
            }
          }),
          onMousePressedLeft: function(event) {
            Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
          },
          onMouseHoverOver: function(event) {
            if (!mouse_check_button(mb_left)) { ///@todo replace mouse_check_button
              this.clipboard.drag()
            }
          },
          onMouseHoverOut: function(event) {
            if (!mouse_check_button(mb_left)) { ///@todo replace mouse_check_button
              this.clipboard.drop()
            }
          },
        }
      }
    }
  },
  "category": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-alpha": 1.0,
        "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
        "components": new Array(Struct, Core.getProperty("visu.editor.migrate", false) 
          ?
            [
              #region Old API
              {
                name: "button_category-shader",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundColor: VETheme.color.primary,
                  backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentLight).toGMColor(),
                  backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                  backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                  backgroundMargin: { top: 0, bottom: 1, left: 1, right: 0 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: { 
                    font: "font_inter_8_bold",
                    text: String.toArray("@SH").join("\n"),
                  },
                  category: "shader",
                },
              },
              {
                name: "button_category-shroom",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundColor: VETheme.color.primary,
                  backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentLight).toGMColor(),
                  backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                  backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 0 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("@SR").join("\n"),
                  },
                  category: "shroom",
                },
              },
              {
                name: "button_category-grid_old",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundColor: VETheme.color.primary,
                  backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentLight).toGMColor(),
                  backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                  backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 0 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("@GR").join("\n"),
                  },
                  category: "grid_old",
                },
              },
              {
                name: "button_category-view_old",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundColor: VETheme.color.primary,
                  backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentLight).toGMColor(),
                  backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                  backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                  backgroundMargin: { top: 1, bottom: 0, left: 1, right: 0 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("@VW").join("\n"),
                  },
                  category: "view_old",
                },
              },
              #endregion
              {
                name: "button_category-effect",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: { 
                    font: "font_inter_8_bold",
                    //text: String.toArray("EFFECT").join("\n"),
                    text: String.toArray("EFF").join("\n"),
                  },
                  category: "effect",
                },
              },
              {
                name: "button_category-entity",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    //text: String.toArray("ENTITY").join("\n"),
                    text: String.toArray("ENT").join("\n"),
                  },
                  category: "entity",
                },
              },
              {
                name: "button_category-grid",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    //text: String.toArray("GRID").join("\n"),
                    text: String.toArray("GRD").join("\n"),
                  },
                  category: "grid",
                },
              },
              {
                name: "button_category-view",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 0, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    //text: String.toArray("VIEW").join("\n"),
                    text: String.toArray("VW").join("\n"),
                  },
                  category: "view",
                },
              }
            ] 
          :
            [
              {
                name: "button_category-effect",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: { 
                    font: "font_inter_8_bold",
                    text: String.toArray("EFFECT").join("\n"),
                  },
                  category: "effect",
                },
              },
              {
                name: "button_category-entity",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("ENTITY").join("\n"),
                  },
                  category: "entity",
                },
              },
              {
                name: "button_category-grid",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("GRID").join("\n"),
                  },
                  category: "grid",
                },
              },
              {
                name: "button_category-view",
                template: VEComponents.get("category-button"),
                layout: VELayouts.get("vertical-item"),
                config: {
                  backgroundMargin: { top: 1, bottom: 0, left: 1, right: 1 },
                  callback: function() { 
                    var category = this.context.brushToolbar.store.get("category")
                    if (category.get() != this.category) {
                      category.set(this.category)
                    }
                  },
                  updateCustom: function() {
                    this.backgroundColor = this.category == this.context.brushToolbar.store.getValue("category")
                      ? this.backgroundColorOn
                      : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                  },
                  onMouseHoverOver: function(event) { },
                  onMouseHoverOut: function(event) { },
                  label: {
                    font: "font_inter_8_bold",
                    text: String.toArray("VIEW").join("\n"),
                  },
                  category: "view",
                },
              }
            ]
          ),
      }),
      updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefaultNoSurface")),
      onInit: function() {
        this.collection = new UICollection(this, { layout: this.layout })
        this.state.get("components")
          .forEach(function(component, index, collection) {
            collection.add(new UIComponent(component))
          }, this.collection)
      },
    }
  },
  "type": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-alpha": 1.0,
        "background-color": ColorUtil.fromHex(VETheme.color.sideShadow).toGMColor(),
        "category": null,
        "type": null,
        "shader": new Array(Struct, [
          {
            name: "button_category-shader_type-spawn",
            text: "Spawn",
            brushType: VEBrushType.SHADER_SPAWN,
          },
          {
            name: "button_category-shader_type-overlay",
            text: "Overlay",
            brushType: VEBrushType.SHADER_OVERLAY,
          },
          {
            name: "button_category-shader_type-clear",
            text: "Clear",
            brushType: VEBrushType.SHADER_CLEAR,
          },
          {
            name: "button_category-shader_type-config",
            text: "Config",
            brushType: VEBrushType.SHADER_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "shroom": new Array(Struct, [
          {
            name: "button_category-shroom_type-spawn",
            text: "Spawn",
            brushType: VEBrushType.SHROOM_SPAWN,
          },
          {
            name: "button_category-shader_type-clear",
            text: "Clear",
            brushType: VEBrushType.SHROOM_CLEAR,
          },
          {
            name: "button_category-shader_type-config",
            text: "Config",
            brushType: VEBrushType.SHROOM_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "grid_old": new Array(Struct, [
          {
            name: "button_category-grid_old_type-channel",
            text: "Cols",
            brushType: VEBrushType.GRID_OLD_CHANNEL,
          },
          {
            name: "button_category-grid_old_type-separator",
            text: "Rows",
            brushType: VEBrushType.GRID_OLD_SEPARATOR,
          },
          {
            name: "button_category-grid_old_type-particle",
            text: "Particle",
            brushType: VEBrushType.GRID_OLD_PARTICLE,
          },
          {
            name: "button_category-grid_old_type-player",
            text: "Player",
            brushType: VEBrushType.GRID_OLD_PLAYER,
          },
          {
            name: "button_category-grid_old_type-coin",
            text: "Coin",
            brushType: VEBrushType.GRID_OLD_COIN,
          },
          {
            name: "button_category-grid_old_type-config",
            text: "Config",
            brushType: VEBrushType.GRID_OLD_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "view_old": new Array(Struct, [
          {
            name: "button_category-view_old_type-wallpaper",
            text: "Layer",
            brushType: VEBrushType.VIEW_OLD_WALLPAPER,
          },
          {
            name: "button_category-view_old_type-camera",
            text: "Camera",
            brushType: VEBrushType.VIEW_OLD_CAMERA,
          },
          {
            name: "button_category-view_old_type-lyrics",
            text: "Subtitle",
            brushType: VEBrushType.VIEW_OLD_LYRICS,
          },
          {
            name: "button_category-view_old_type-glitch",
            text: "Glitch",
            brushType: VEBrushType.VIEW_OLD_GLITCH,
          },
          {
            name: "button_category-view_old_type-config",
            text: "Config",
            brushType: VEBrushType.VIEW_OLD_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "effect": new Array(Struct, [
          {
            name: "button_category-effect_type-shader",
            text: "Shader",
            brushType: VEBrushType.EFFECT_SHADER,
          },
          {
            name: "button_category-effect_type-glitch",
            text: "Glitch",
            brushType: VEBrushType.EFFECT_GLITCH,
          },
          {
            name: "button_category-effect_type-particle",
            text: "Particle",
            brushType: VEBrushType.EFFECT_PARTICLE,
          },
          {
            name: "button_category-effect_type-config",
            text: "Config",
            brushType: VEBrushType.EFFECT_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "entity": new Array(Struct, [
          {
            name: "button_category-entity_type-shroom",
            text: "Shroom",
            brushType: VEBrushType.ENTITY_SHROOM,
          },
          {
            name: "button_category-entity_type-coin",
            text: "Coin",
            brushType: VEBrushType.ENTITY_COIN,
          },
          {
            name: "button_category-entity_type-player",
            text: "Player",
            brushType: VEBrushType.ENTITY_PLAYER,
          },
          {
            name: "button_category-entity_type-config",
            text: "Config",
            brushType: VEBrushType.ENTITY_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "grid": new Array(Struct, [
          {
            name: "button_category-grid_type-area",
            text: "Area",
            brushType: VEBrushType.GRID_AREA,
          },
          {
            name: "button_category-grid_type-column",
            text: "Column",
            brushType: VEBrushType.GRID_COLUMN,
          },
          {
            name: "button_category-grid_type-row",
            text: "Row",
            brushType: VEBrushType.GRID_ROW,
          },
          {
            name: "button_category-grid_type-config",
            text: "Config",
            brushType: VEBrushType.GRID_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "view": new Array(Struct, [
          {
            name: "button_category-view_type-camera",
            text: "Camera",
            brushType: VEBrushType.VIEW_CAMERA,
          },
          {
            name: "button_category-view_type-wallpaper",
            text: "Layer",
            brushType: VEBrushType.VIEW_WALLPAPER,
          },
          {
            name: "button_category-view_type-subtitle",
            text: "Subtitle",
            brushType: VEBrushType.VIEW_SUBTITLE,
          },
          {
            name: "button_category-view_type-config",
            text: "Config",
            brushType: VEBrushType.VIEW_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
      }),
      updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      onInit: function() {
        this.collection = new UICollection(this, { layout: this.layout })
        var container = this
        var store = this.brushToolbar.store
        
        store.get("category").addSubscriber({ 
          name: this.name,
          overrideSubscriber: true,
          callback: function(category, context) { 
            if (category == context.state.get("category")) {
              return
            }

            context.state.set("category", category)
            context.brushToolbar.store
              .get("type")
              .set(context.brushToolbar.categories
                .get(category)
                .getFirst())
          },
          data: container,
        })

        store.get("type").addSubscriber({ 
          name: this.name,
          overrideSubscriber: true,
          callback: function(type, context) {
            //if (type == context.state.get("type")) {
            //  return
            //}

            data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
            data.collection.components.clear() ///@todo replace with remove lambda
            context.state
              .set("type", type)
              .get(context.brushToolbar.store.getValue("category"))
              .forEach(function(component, index, collection) {
                collection.add(new UIComponent(component))
              }, context.collection)
          },
          data: container
        })
      },
      onDestroy: function() {
        var store = this.brushToolbar.store
        store.get("category").removeSubscriber(this.name)
        store.get("type").removeSubscriber(this.name)
      },
    }
  },
  "brush-bar": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
        "background-alpha": 1.0,
      }),
      updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "label_brush-control-title": Struct.appendRecursiveUnique(
          {
            type: UIText,
            text: "Brushes",
            font: "font_inter_8_bold",
            offset: { x: 4 },
            margin: { right: 96, top: 1 },
            update: Callable.run(UIUtil.updateAreaTemplates.get("applyMargin")),
          },
          VEStyles.get("bar-title"),
          false
        ),
        "button_brush-control-load": Struct.appendRecursiveUnique(
          {
            type: UIButton,
            group: { index: 1, size: 2, width: 48 },
            label: { 
              font: "font_inter_8_regular",
              text: "Import",
            },
            margin: { top: 1 },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("groupByXWidth")),
            callback: function(event) {
              var type = this.context.brushToolbar.store.getValue("type")
              var saveTemplate = Beans.get(BeanVisuController).brushService.saveTemplate
              var promise = Beans.get(BeanFileService).send(
                new Event("fetch-file-dialog")
                  .setData({
                    description: "JSON file",
                    filename: "brush", 
                    extension: "json",
                  })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, index, acc) {
                        var template = new prototype(json)
                        acc.saveTemplate(template)
                        var type = Beans.get(BeanVisuEditorController).brushToolbar.store.get("type")
                        type.set(type.get())
                      },
                      acc: {
                        saveTemplate: saveTemplate,
                      },
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      ///@todo refactor
                      if (result == null) {
                        return new Task("dummy-task").whenUpdate(function(executor) {
                          this.fullfill()
                        })
                      }

                      var task = JSON.parserTask(result.data, this.state)
                      Beans.get(BeanVisuController).executor.add(task)
                      return task
                    }))
              )
            },
            onMouseHoverOver: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
            },
          },
          VEStyles.get("bar-button"),
          false
        ),
        "button_brush-control-save": Struct.appendRecursiveUnique(
          {
            type: UIButton,
            group: { index: 0, size: 2, width: 48 },
            label: { 
              font: "font_inter_8_regular",
              text: "Export",
            },
            margin: { top: 1 },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("groupByXWidth")),
            callback: function(event) {
              var path = FileUtil.getPathToSaveWithDialog({ 
                description: "JSON file",
                filename: "brush", 
                extension: "json",
              })

              if (!Core.isType(path, String)) {
                return
              }

              var type = this.context.brushToolbar.store.getValue("type")
              var templates = Beans.get(BeanVisuController).brushService.fetchTemplates(type)
              var data = JSON.stringify({
                "model": "Collection<io.alkapivo.visu.editor.api.VEBrushTemplate>",
                "data": Assert.isType(Beans.get(BeanVisuController).brushService
                  .fetchTemplates(type)
                  .getContainer(), GMArray),
              }, { pretty: true })

              Beans.get(BeanFileService).send(new Event("save-file-sync")
                .setData(new File({
                  path: path,
                  data: data
                })))
            },
            onMouseHoverOver: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
            },
          },
          VEStyles.get("bar-button"),
          false
        ),
      }
    }
  },
  "brush-view": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-alpha": 1.0,
        "type": null,
        "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
        "empty-label": new UILabel({
          text: "Click to\nadd template",
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        }),
        "dragItem": null,
      }),
      updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.brush-toolbar.brush-view.updateTimer", 60), { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      scrollbarY: { align: HAlign.RIGHT },
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
      renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
      renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable"))),
      updateVerticalSelectedIndex: new BindIntent(Callable.run(UIUtil.templates.get("updateVerticalSelectedIndex"))),
      executor: null,
      render: function() {
        if (this.executor != null) {
          this.executor.update()
        }

        this.updateVerticalSelectedIndex(32)

        this.renderDefaultScrollable()
        if (!Core.isType(this.collection, UICollection) 
          || this.collection.size() == 0) {
          this.state.get("empty-label").render(
            this.area.getX() + (this.area.getWidth() / 2),
            this.area.getY() + (this.area.getHeight() / 2)
          )
        }

        ///@todo replace with Promise in clipboard
        var dragItem = this.state.get("dragItem")
        if (Optional.is(dragItem) 
          && !mouse_check_button(mb_left) 
          && !mouse_check_button_released(mb_left)) {
          this.state.set("dragItem", null)
          dragItem = null
        }

        if (Optional.is(dragItem)) {
          var mouseX = device_mouse_x_to_gui(0)
          var mouseY = device_mouse_y_to_gui(0)
          var areaX = this.area.getX()
          var areaY = this.area.getY()
          var areaWidth = this.area.getWidth()
          var areaHeight = this.area.getHeight()
          if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
            draw_sprite_ext(texture_baron_cursor, 0, mouseX, mouseY, 1.0, 1.0, 0.0, c_white, 0.5)
          }
        }
      },
      onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
      onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
      onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
      onMouseDragLeft: function(event) {
        var mouse = Beans.get(BeanVisuEditorIO).mouse
        var name = Struct.get(mouse.getClipboard(), "name")
        if (name == "resize_accordion"
            || name == "resize_brush_toolbar"
            || name == "resize_brush_inspector"
            || name == "resize_template_inspector"
            || name == "resize_timeline"
            || name == "resize_horizontal"
            || name == "resize_event_title") {
          return
        }
        
        var component = this.collection.components.find(function(component) {
          var text = component.items.find(function(item) {
            return item.type == UIText
          })

          return Optional.is(text)
            ? text.backgroundColor == ColorUtil.fromHex(text.colorHoverOver).toGMColor()
            : false
        })

        if (Optional.is(component)) {
          this.state.set("dragItem", component)
          mouse.setClipboard(component)
        }
      },
      onMouseDropLeft: function(event) {
        var dragItem = this.state.get("dragItem")
        if (Optional.is(dragItem) && Beans.get(BeanVisuEditorIO).mouse.getClipboard() == dragItem) {
          this.state.set("dragItem", null)
          Beans.get(BeanVisuEditorIO).mouse.setClipboard(null)

          var component = this.collection.components.find(function(component) {
            var text = component.items.find(function(item) {
              return item.type == UIText
            })
  
            return Optional.is(text)
              ? text.backgroundColor == ColorUtil.fromHex(text.colorHoverOver).toGMColor()
              : false
          })
  
          if (Optional.is(component)) {
            var type = this.brushToolbar.store.getValue("type")
            var newIndex = component.index
            var templates = Beans.get(BeanVisuController).brushService.fetchTemplates(type)
            var template = templates.get(dragItem.index)
            templates.remove(dragItem.index)
            templates.add(template, newIndex)

            this.collection.components.forEach(function(component, key, acc) {
              if (component.index == acc.oldIndex) {
                component.index = acc.newIndex
                component.items.forEach(function(item, key, index) {
                  item.layout.collection.setIndex(index)
                }, component.index)
                return
              }

              if (acc.oldIndex < acc.newIndex && component.index >= acc.oldIndex && component.index <= acc.newIndex) {
                component.index--
                component.items.forEach(function(item, key, index) {
                  item.layout.collection.setIndex(index)
                }, component.index)
                return
              }
              
              if (acc.oldIndex > acc.newIndex && component.index >= acc.newIndex && component.index <= acc.oldIndex) {
                component.index++
                component.items.forEach(function(item, key, index) {
                  item.layout.collection.setIndex(index)
                }, component.index)
                return
              }
            }, { 
              newIndex: newIndex, oldIndex: dragItem.index })

            component.items.forEach(function(item) {
              if (!Struct.contains(item, "colorHoverOut")) {
                return
              }
              item.backgroundColor = ColorUtil.fromHex(item.colorHoverOut).toGMColor()
            })

            this.finishUpdateTimer()
            this.areaWatchdog.signal()
          }
        } else {
          var mouse = Beans.get(BeanVisuEditorIO).mouse
          var dropEvent = mouse.getClipboard()
          if (Core.isType(dropEvent, Promise)) {
            dropEvent.fullfill()
          }

          if (Core.isType(Struct.get(dropEvent, "drop"), Callable)) {
            dropEvent.drop()
          }
          mouse.clearClipboard()
        }
      },
      onInit: function() {
        this.executor = new TaskExecutor(this, {
          enableLogger: true,
          catchException: false,
        })

        var container = this
        this.collection = new UICollection(this, { layout: this.layout })
        this.brushToolbar.store.get("type").addSubscriber({ 
          name: container.name,
          overrideSubscriber: true,
          callback: function(type, data) {
            data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
            data.collection.components.clear() ///@todo replace with remove lambda
            data.state.set("type", type)

            var brushService = Beans.get(BeanVisuController).brushService
            var task = new Task("load-brushes")
              .setState({
                collection: data.collection,
                templates: Assert.isType(brushService.templates.get(type), Array),
                pointer: 0,
                parse: data.brushToolbar.parseBrushTemplate,
              })
              .whenUpdate(function(executor) {
                repeat (BRUSH_ENTRY_STEP) {
                  if (this.state.templates.size() == 0) {
                    this.fullfill()
                    break
                  }
  
                  if (this.state.pointer >= this.state.templates.size()) {
                    break
                  }
  
                  var template = this.state.templates.get(this.state.pointer)
                  if (Core.isType(template, Struct)) {
                    this.state.collection.add(this.state.parse(template))
                  }
  
                  this.state.pointer = this.state.pointer + 1
                  if (this.state.pointer >= this.state.templates.size()) {
                    this.fullfill()
                    break
                  }
                }
              })

            data.executor.tasks.clear()
            data.executor.add(task)
          },
          data: container
        })
      },
      onDestroy: function() {
        this.brushToolbar.store
          .get("type")
          .removeSubscriber(this.name)
      },
      onMouseReleasedLeft: function() {
        if (!Core.isType(this.collection, UICollection) || this.collection.size() == 0) {
          var type = this.brushToolbar.store.getValue("type")
          var template = new VEBrushTemplate({
            "name": "new brush template",
            "type": type,
            "color":"#FFFFFF",
            "texture":"texture_baron",
          })
          Beans.get(BeanVisuController).brushService.saveTemplate(template)
          this.brushToolbar.store.get("type").set(type)
          this.brushToolbar.store.get("template").set(template)
        }
      }
    }
  },
  "inspector-bar": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
        "background-alpha": 1.0,
      }),
      updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.brush-toolbar.inspector-bar.updateTimer", 10.0), { loop: Infinity, shuffle: true }),
      updateTimerCooldown: Core.getProperty("visu.editor.ui.brush-toolbar.inspector-bar.updateTimer.cooldown", 4.0),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "label_inspector-control-title": Struct.appendRecursiveUnique(
          {
            type: UIText,
            text: "Tools",
            font: "font_inter_8_bold",
            offset: { x: 4 },
            margin: { top: 1 },
            clipboard: {
              name: "resize_brush_inspector",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_VERTICAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            __height: null,
            __update: new BindIntent(Callable.run(UIUtil.updateAreaTemplates.get("applyMargin"))),
            updateCustom: function() {
              this.__update()
              var editorIO = Beans.get(BeanVisuEditorIO)
              var mouse = editorIO.mouse
              if (mouse.hasMoved() && mouse.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseY())
                this.context.brushToolbar.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)
                 
                if (!mouse_check_button(mb_left)) {
                  mouse.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              } else {
                var editor = Beans.get(BeanVisuEditorController)
                var height = editor.brushToolbar.layout.height()
                if (this.__height != height) {
                  this.__height = height
                  var uiService = Beans.get(BeanVisuEditorController).uiService
                  var titleBar = uiService.find("ve-title-bar")
                  var statusBar = uiService.find("ve-status-bar")
                  var brushNode = Struct.get(this.context.layout.context.nodes, "brush-view")
                  var toolNode = Struct.get(this.context.layout.context.nodes, "inspector-tool")
                  var inspectorNode = Struct.get(this.context.layout.context.nodes, "inspector-view")
                  var typeNode = Struct.get(this.context.layout.context.nodes, "type")
                  var controlNode = Struct.get(this.context.layout.context.nodes, "control")
                  var top = titleBar.layout.height() + typeNode.height() + typeNode.margin.top + typeNode.margin.bottom
                  var bottom = GuiHeight() - statusBar.layout.height() - (controlNode.height() + controlNode.margin.top + controlNode.margin.bottom) - (toolNode.height() + toolNode.margin.top + toolNode.margin.bottom)
                  var length = bottom - top
                  var before = inspectorNode.percentageHeight
                  inspectorNode.percentageHeight = clamp(inspectorNode.percentageHeight, 4.0 / length, 1.0 - (48.0 / length))
                  brushNode.percentageHeight = 1.0 - inspectorNode.percentageHeight
                  if (before != inspectorNode.percentageHeight) {
                    editor.brushToolbar.containers.forEach(editor.accordion.resetUpdateTimer)
                  }
                }
              }
            },
            updateLayout: new BindIntent(function(_position) {
              var editor = Beans.get(BeanVisuEditorController)
              var uiService = Beans.get(BeanVisuEditorController).uiService
              var titleBar = uiService.find("ve-title-bar")
              var statusBar = uiService.find("ve-status-bar")
              var brushNode = Struct.get(this.context.layout.context.nodes, "brush-view")
              var inspectorNode = Struct.get(this.context.layout.context.nodes, "inspector-view")
              var toolNode = Struct.get(this.context.layout.context.nodes, "inspector-tool")
              var typeNode = Struct.get(this.context.layout.context.nodes, "type")
              var controlNode = Struct.get(this.context.layout.context.nodes, "control")
              var top = titleBar.layout.height() + typeNode.height() + typeNode.margin.top + typeNode.margin.bottom
              var bottom = GuiHeight() - statusBar.layout.height() - (controlNode.height() + controlNode.margin.top + controlNode.margin.bottom) - (toolNode.height() + toolNode.margin.top + toolNode.margin.bottom)
              var length = bottom - top
              var position = clamp(_position - top, 4.0, length - 4.0)
              var before = inspectorNode.percentageHeight
              inspectorNode.percentageHeight = clamp((length - position) / length, 8.0 / length, 1.0 - (48.0 / length))
              brushNode.percentageHeight = 1.0 - inspectorNode.percentageHeight
              if (before != inspectorNode.percentageHeight) {
                editor.brushToolbar.containers.forEach(editor.accordion.resetUpdateTimer)
              }
            }),
            onMousePressedLeft: function(event) {
              Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
            },
            onMouseHoverOver: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drag()
              }
            },
            onMouseHoverOut: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drop()
              }
            },
          },
          VEStyles.get("bar-title"),
          false
        ),
      }
    }
  },
  "inspector-tool": function(name, brushToolbar, layout) {
    static factoryToolItem = function(json) {
      return {
        name: json.name,
        template: VEComponents.get("category-button"),
        layout: function(config = null) {
          return {
            name: "horizontal-item",
            type: UILayoutType.HORIZONTAL,
            collection: true,
            margin: { right: 2, left: 2 },
            width: function() { return this.context.height() },
            x: function() { return this.context.x()
              + (this.collection.getIndex() * this.width())
              + (this.collection.getIndex() * this.margin.right)
              + ((this.collection.getIndex() + 1) * this.margin.left) },
          }
        },
        config: {
          backgroundColorSelected: VETheme.color.primary,
          backgroundColor: VETheme.color.sideDark,
          backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
          backgroundColorOn: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          backgroundColorOff: ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          //backgroundMargin: { top: 1, bottom: 1, right: 1, left: 1 },
          callback: function() { 
            this.context.state.get("store")
              .get("tool")
              .set(this.tool)
          },
          updateCustom: function() {
            this.backgroundColor = this.tool == this.context.state.get("store").getValue("tool")
              ? this.backgroundColorOn
              : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
          },
          onMouseHoverOver: function(event) { },
          onMouseHoverOut: function(event) { },
          label: {
            text: json.text,
            color: VETheme.color.textFocus,
            align: { v: VAlign.CENTER, h: HAlign.CENTER },
            useScale: false,
            outline: true,
            outlineColor: VETheme.color.sideDark,
            font: "font_inter_8_bold",
          },
          sprite: json.sprite,
          tool: json.tool,
          description: json.description,
          render: function() {
            if (Optional.is(this.preRender)) {
              this.preRender()
            }
            this.renderBackgroundColor()
      
            if (this.sprite != null) {
              var alpha = this.sprite.getAlpha()
              this.sprite
                .setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
                .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
                .render(
                  this.context.area.getX() + this.area.getX(),
                  this.context.area.getY() + this.area.getY())
                .setAlpha(alpha)
            }
      
            if (this.label != null) {
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2)
              )
            }

            if (this.isHoverOver) {
              var text = this.label.text
              this.label.text = this.description
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2)
              )
              this.label.text = text
            }
            return this
          },
        },
      }
    }

    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.primaryDark).toGMColor(),
        "store": Beans.get(BeanVisuEditorController).store,
        "tools": new Array(Struct, [
          factoryToolItem({ 
            name: "ve-track-control_tool_select", 
            text: "", 
            description: "Select\n\n[V]", 
            tool: "tool_select",
            sprite: { name: "texture_ve_brush_toolbar_icon_tool_select"},
          }),
          factoryToolItem({ 
            name: "ve-track-control_tool_brush", 
            text: "", 
            description: "Brush\n\n[B]", 
            tool: "tool_brush",
            sprite: { name: "texture_ve_brush_toolbar_icon_tool_brush"},
          }),
          factoryToolItem({ 
            name: "ve-track-control_tool_clone", 
            text: "", 
            description: "Clone\n\n[C]", 
            tool: "tool_clone",
            sprite: { name: "texture_ve_brush_toolbar_icon_tool_clone"},
          }),
          factoryToolItem({ 
            name: "ve-track-control_tool_erase", 
            text: "", 
            description: "Erase\n\n[E]", 
            tool: "tool_erase",
            sprite: { name: "texture_ve_brush_toolbar_icon_tool_erase"},
          }),
        ])
      }),
      updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "brush_ve-brush-toolbar_brush-icon-preview": {
          type: UIImage,
          layout: layout.nodes.brushIconPreview,
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          backgroundColor: VETheme.color.sideShadow,
          backgroundAlpha: 1.0,
          state: new Map(String, any),
          updateCustom: function() {
            try {
              var editor = Beans.get(BeanVisuEditorController)
              if (!Optional.is(editor)) {
                return
              }
            
              var events = editor.timeline.containers.get("ve-timeline-events")
              if (!Optional.is(events)) {
                return
              }

              var initialized = events.state.get("initialized")
              if (!initialized) {
                return
              }
              
              var tool = editor.store.getValue("tool")
              if (tool != this.state.get("tool")) {
                this.state.set("brush-color", null)
                this.state.set("brush-sprite-name", null)
                this.state.set("brush-sprite", null)
                this.state.set("tool", tool)
              }

              switch (tool) {
                case ToolType.SELECT:
                  this.state.set("brush-color", null)
                  this.state.set("brush-sprite-name", null)
                  this.state.set("brush-sprite", null)
                  break
                case ToolType.ERASE:
                  this.state.set("brush-color", null)
                  this.state.set("brush-sprite-name", null)
                  this.state.set("brush-sprite", null)
                  break
                case ToolType.BRUSH:
                  var brush = editor.brushToolbar.store.getValue("brush")
                  if (!Optional.is(brush)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }
            
                  var colorItem = brush.store.get("brush-color")
                  if (!Optional.is(colorItem)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }
            
                  var textureItem = brush.store.get("brush-texture")
                  if (!Optional.is(textureItem)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }
            
                  if (this.state.get("brush-color") == colorItem.get().toHex()
                      && this.state.get("brush-sprite-name") == textureItem.get()) {
                    break
                  }

                  this.state.set("brush-color", null)
                  this.state.set("brush-sprite-name", null)
                  this.state.set("brush-sprite", null)
            
                  var sprite = SpriteUtil.parse({ name: textureItem.get() })
                  sprite.setBlend(colorItem.get().toGMColor())
            
                  this.state.set("brush-color", colorItem.get().toHex())
                  this.state.set("brush-sprite-name", textureItem.get())
                  this.state.set("brush-sprite", sprite)
            
                  break
                case ToolType.CLONE:
                  var selectedEvent = editor.store.getValue("selected-event")
                  if (!Optional.is(selectedEvent)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }
            
                  var trackEvent = selectedEvent.data
                  if (!Core.isType(trackEvent, TrackEvent)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }
            
                  var icon = Struct.get(trackEvent.data, "icon")
                  if (!Optional.is(icon)) {
                    this.state.set("brush-color", null)
                    this.state.set("brush-sprite-name", null)
                    this.state.set("brush-sprite", null)
                    break
                  }

                  if (this.state.get("brush-color") == Struct.get(icon, "blend")
                      && this.state.get("brush-sprite-name") == Struct.get(icon, "name")) {
                    break
                  }
                  
                  this.state.set("brush-color", null)
                  this.state.set("brush-sprite-name", null)
                  this.state.set("brush-sprite", null)
                  
                  var sprite = SpriteUtil.parse(icon)

                  this.state.set("brush-color", ColorUtil.fromGMColor(sprite.getBlend()).toHex())
                  this.state.set("brush-sprite-name", sprite.getName())
                  this.state.set("brush-sprite", sprite)
                  
                  break
              }
            } catch (exception) {
              var message = $"exception!!!: {exception.message}"
              Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
              Logger.error("VETrackControl", message)
            }
          },
          render: function() {
            if (Optional.is(this.preRender)) {
              this.preRender()
            }
            this.renderBackgroundColor()

            var sprite = this.state.get("brush-sprite")
            if (Optional.is(sprite)) {
              sprite
                .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
                .render(
                  this.context.area.getX() + this.area.getX(),
                  this.context.area.getY() + this.area.getY()
                )
            }

            return this
          },
        },
        "checkbox_ve-brush-toolbar_snap": {
          type: UICheckbox,
          layout: layout.nodes.snapCheckbox,
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          store: { key: "snap" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
        },
        "text_ve-brush-toolbar_snap": {
          type: UIText,
          layout: layout.nodes.snapLabel,
          text: "Snap",
          font: "font_inter_8_bold",
          color: VETheme.color.textFocus,
          align: { v: VAlign.CENTER, h: HAlign.LEFT },
          outline: true,
          outlineColor: VETheme.color.sideDark,
          store: { key: "snap" },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          preRender: function() {
            var value = this.store.getValue()
            if (!Optional.is(value)) {
              return
            }

            var alpha = this.label.alpha
            this.label.alpha = value ? alpha : alpha * 0.5
            Struct.set(this, "_alpha", alpha)
          },
          postRender: function() {
            this.label.alpha = this._alpha
          },
          onMouseReleasedLeft: function(event) {
            var item = this.store.get()
            if (!Optional.is(item)) {
              return
            }
            
            item.set(!item.get())
          }
        },
      },
      onInit: function() {
        var container = this
        this.collection = new UICollection(this, { layout: container.layout.nodes.toolbar })
        this.state.get("tools")
          .forEach(function(component, index, collection) {
            collection.add(new UIComponent(component))
          }, this.collection)
      },
    }
  },
  "inspector-view": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
        "background-alpha": 1.0,
        "inspectorType": VEBrushToolbar,
        "surface-alpha": 1.0,
      }),
      updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.brush-toolbar.inspector-view.updateTimer", 60), { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      executor: null,
      scrollbarY: { align: HAlign.RIGHT },
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
      renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
      renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableAlpha"))),
      render: function() {
        if (this.executor != null) {
          this.executor.update()
        }

        var surfaceAlpha = this.state.getIfType("surface-alpha", Number, 1.0)
        if (surfaceAlpha < 1.0) {
          this.state.set("surface-alpha", clamp(surfaceAlpha + DeltaTime.apply(0.066), 0.0, 1.0))
        }

        this.renderDefaultScrollable()
        return this
      },
      onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
      onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
      onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
      onInit: function() {
        var container = this
        this.executor = new TaskExecutor(this, {
          enableLogger: true,
          catchException: false,
        })
        this.collection = new UICollection(this, { layout: container.layout })
        this.brushToolbar.store.get("template").addSubscriber({ 
          name: this.name,
          overrideSubscriber: true,
          callback: function(template, data) {
            data.executor.tasks.forEach(function(task, iterator, name) {
              if (task.name == name) {
                task.fullfill()
              }
            }, "init-ui-components")
            
            if (!Optional.is(template)) {
              data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
              data.collection.components.clear() ///@todo replace with remove lambda
              data.state
                .set("template", null)
                .set("brush", null)
                .set("store", null)
              return
            }

            var brush = new VEBrush(template)
            data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
            data.collection.components.clear() ///@todo replace with remove lambda
            data.brushToolbar.store.get("brush").set(brush)
            data.state
              .set("template", template)
              .set("brush", brush)
              .set("store", brush.store)

            var task = new Task("init-ui-components")
              .setTimeout(60)
              .setState({
                context: data,
                template: template,
                stage: "load-components",
                components: brush.components,
                componentsQueue: new Queue(String, GMArray
                  .map(brush.components.container, function(component, index) { 
                    return index 
                  })),
                componentsConfig: {
                  context: data,
                  layout: new UILayout({
                    area: data.area,
                    width: function() { return this.area.getWidth() },
                  }),
                  textField: null,
                },
                "load-components": function(task) {
                  repeat (BRUSH_TOOLBAR_ENTRY_STEP) {
                    var index = task.state.componentsQueue.pop()
                    if (!Optional.is(index)) {
                      task.fullfill()
                      task.state.context.finishUpdateTimer()
                      break
                    }
  
                    var component = new UIComponent(task.state.components.get(index))
                    task.state.context.addUIComponent(component, index, task.state.componentsConfig)
                  }
                },
              })
              .whenUpdate(function() {
                var stage = Struct.get(this.state, this.state.stage)
                stage(this)
                return this
              })
            
            data.executor.add(task)
          },
          data: container
        })
      },
      onDestroy: function() {
        if (Optional.is(this.executor)) {
          this.executor.tasks.forEach(function(task) { 
            task.fullfill() 
          }).clear()
        }

        var store = this.brushToolbar.store
        store.get("template").removeSubscriber(this.name)
        store.get("type").removeSubscriber(this.name)
      },
    }
  },
  "control": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
        "components": new Array(Struct, [
          {
            name: "button_control-preview",
            template: VEComponents.get("collection-button"),
            layout: VELayouts.get("horizontal-item"),
            config: {
              label: { text: "Preview" },
              callback: function() { 
                var brushToolbar = this.context.brushToolbar
                var brush = brushToolbar.store.getValue("brush")
                if (!Core.isType(brush, VEBrush)) {
                  return
                }
                
                var controller = Beans.get(BeanVisuController)
                var handler = controller.trackService.handlers.get(brush.type)
                handler.run(handler.parse(brush.toTemplate().properties))

                var item = this
                controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)
                
                var task = new Task($"onMouseReleasedLeft_{item.name}")
                  .setTimeout(10.0)
                  .setState({
                    item: item,
                    transformer: new ColorTransformer({
                      value: VETheme.color.accentLight,
                      target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                      factor: 0.016,
                    })
                  })
                  .whenUpdate(function(executor) {
                    if (this.state.transformer.update().finished) {
                      this.fullfill()
                    }
    
                    this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                  })
    
                item.backgroundColor = ColorUtil.parse(VETheme.color.accentLight).toGMColor()
                controller.executor.add(task)
              },
              onMouseHoverOut: function(event) {
                var item = this
                var controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)

                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
              },
              onMouseHoverOver: function(event) {
                var item = this
                var controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)

                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
              },
              postRender: function() {
                var keyLabel = Struct.get(this, "keyLabel")
                if (!Optional.is(keyLabel)) {
                  keyLabel = Struct.set(this, "keyLabel", new UILabel({
                    font: "font_inter_8_regular",
                    text: "[CTRL + D]",
                    alpha: 1.0,
                    useScale: false,
                    color: VETheme.color.textShadow,
                    align: {
                      v: VAlign.BOTTOM,
                      h: HAlign.CENTER,
                    },
                  }))
                }

                keyLabel.render(
                  this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
                  this.context.area.getY() + this.area.getY() + this.area.getHeight(),
                  this.area.getWidth(),
                  this.area.getHeight(),
                  0.9
                )
              },
            },
          },
          {
            name: "button_control-save",
            template: VEComponents.get("collection-button"),
            layout: VELayouts.get("horizontal-item"),
            config: {
              label: { text: "Save" },
              callback: function() { 
                if (Core.isType(GMTFContext.get(), GMTF)) {
                  if (Core.isType(GMTFContext.get().uiItem, UIItem)) {
                    GMTFContext.get().uiItem.update()
                  }
                  GMTFContext.get().unfocus()
                }
                
                var brushToolbar = this.context.brushToolbar
                var inspector = brushToolbar.containers.get("ve-brush-toolbar_inspector-view")
                if (!Optional.is(inspector)) {
                  return 
                }

                inspector.finishUpdateTimer()

                if (Optional.is(inspector.updateArea)) {
                  inspector.updateArea()
                }

                if (Optional.is(inspector.updateItems)) {
                  inspector.updateItems()
                }
    
                if (Optional.is(inspector.updateCustom)) {
                  inspector.updateCustom()
                }

                var brush = brushToolbar.containers
                  .get("ve-brush-toolbar_inspector-view").state
                  .get("brush")

                if (brush == null) {
                  return
                }

                var template = brush.toTemplate()
                var controller = Beans.get(BeanVisuController)
                var brushService = controller.brushService
                var sizeBefore = brushService.fetchTemplates(template.type).size()
                brushService.saveTemplate(template, 0)
                var sizeAfter = brushService.fetchTemplates(template.type).size()

                if (sizeBefore != sizeAfter) {
                  this.context.brushToolbar.containers
                    .get("ve-brush-toolbar_brush-view").collection
                    .add(this.context.brushToolbar.parseBrushTemplate(template), 0)
                } else {
                  var component = this.context.brushToolbar.containers
                    .get("ve-brush-toolbar_brush-view").collection.components
                    .find(function(component, key, name) {
                      return component.name == name
                    }, template.name)
                  var item = component.items.find(function(item) {
                    return item.type == UIImage
                  })

                  item.image.texture = TextureUtil.parse(template.texture)
                  item.image.setBlend(ColorUtil.fromHex(template.color).toGMColor())
                }

                var item = this
                controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)
                
                var task = new Task($"onMouseReleasedLeft_{item.name}")
                  .setTimeout(10.0)
                  .setState({
                    item: item,
                    transformer: new ColorTransformer({
                      value: VETheme.color.accept,
                      target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                      factor: 0.016,
                    })
                  })
                  .whenUpdate(function(executor) {
                    if (this.state.transformer.update().finished) {
                      this.fullfill()
                    }
    
                    this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                  })
    
                item.backgroundColor = ColorUtil.parse(VETheme.color.accept).toGMColor()
                controller.executor.add(task)

                if (Optional.is(inspector)) {
                  inspector.state.set("surface-alpha", 0.5)
                }
              },
              onMouseHoverOut: function(event) {
                var item = this
                var controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)

                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
              },
              onMouseHoverOver: function(event) {
                var item = this
                var controller = Beans.get(BeanVisuEditorController)
                controller.executor.tasks.forEach(function(task, iterator, item) {
                  if (Struct.get(task.state, "item") == item) {
                    task.fullfill()
                  }
                }, item)
                
                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
              },
              postRender: function() {
                var keyLabel = Struct.get(this, "keyLabel")
                if (!Optional.is(keyLabel)) {
                  keyLabel = Struct.set(this, "keyLabel", new UILabel({
                    font: "font_inter_8_regular",
                    text: "[CTRL + SHIFT + D]",
                    alpha: 1.0,
                    useScale: false,
                    color: VETheme.color.textShadow,
                    align: {
                      v: VAlign.BOTTOM,
                      h: HAlign.CENTER,
                    },
                  }))
                }

                keyLabel.render(
                  this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
                  this.context.area.getY() + this.area.getY() + this.area.getHeight(),
                  this.area.getWidth(),
                  this.area.getHeight(),
                  0.9
                )
              },
            },
          }
        ]),
      }),
      updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      onInit: function() {
        this.collection = new UICollection(this, { layout: this.layout })
        this.state.get("components")
          .forEach(function(component, index, collection) {
            collection.add(new UIComponent(component))
          }, this.collection)
      },
    }
  },
})
#macro VisuBrushContainers global.__VisuBrushContainers


///@param {VisuEditorController}
function VEBrushToolbar(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Boolean}
  enable = true

  ///@type {?UILayout}
  layout = null

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "category": {
      type: String,
      value: "effect",
    },
    "type": {
      type: String,
      value: VEBrushType.EFFECT_SHADER,
    },
    "template": {
      type: Optional.of(VEBrushTemplate),
      value: null,
    },
    "brush": {
      type: Optional.of(VEBrush),
      value: null,
    }
  })

  ///@type {Map<String, Struct>}
  templatesCache = new Map(String, Struct)

  ///@type {Map<String, Array>}
  categories = new Map(String, Array, {
    "effect": new Array(String, [
      VEBrushType.EFFECT_SHADER,
      VEBrushType.EFFECT_GLITCH,
      VEBrushType.EFFECT_PARTICLE,
      VEBrushType.EFFECT_CONFIG
    ]),
    "entity": new Array(String, [
      VEBrushType.ENTITY_SHROOM,
      VEBrushType.ENTITY_COIN, 
      VEBrushType.ENTITY_PLAYER,
      VEBrushType.ENTITY_CONFIG 
    ]),
    "grid": new Array(String, [
      VEBrushType.GRID_AREA,
      VEBrushType.GRID_COLUMN,
      VEBrushType.GRID_ROW,
      VEBrushType.GRID_CONFIG
    ]),
    "view": new Array(String, [
      VEBrushType.VIEW_CAMERA,
      VEBrushType.VIEW_WALLPAPER,
      VEBrushType.VIEW_SUBTITLE,
      VEBrushType.VIEW_CONFIG
    ]),
  })

  #region Old API
  if (Core.getProperty("visu.editor.migrate")) {
    this.categories.set("shader", new Array(String, [
      VEBrushType.SHADER_SPAWN,
      VEBrushType.SHADER_OVERLAY,
      VEBrushType.SHADER_CLEAR,
      VEBrushType.SHADER_CONFIG
    ]))
    
    this.categories.set("shroom", new Array(String, [
      VEBrushType.SHROOM_SPAWN,
      VEBrushType.SHROOM_CLEAR,
      VEBrushType.SHROOM_CONFIG
    ]))

    this.categories.set("grid_old", new Array(String, [
      VEBrushType.GRID_OLD_CHANNEL,
      VEBrushType.GRID_OLD_COIN,
      VEBrushType.GRID_OLD_CONFIG,
      VEBrushType.GRID_OLD_PARTICLE,
      VEBrushType.GRID_OLD_PLAYER,
      VEBrushType.GRID_OLD_SEPARATOR
    ]))

    this.categories.set("view_old", new Array(String, [
      VEBrushType.VIEW_OLD_WALLPAPER,
      VEBrushType.VIEW_OLD_CAMERA,
      VEBrushType.VIEW_OLD_LYRICS,
      VEBrushType.VIEW_OLD_GLITCH,
      VEBrushType.VIEW_OLD_CONFIG
    ]))
    #endregion
  }

  ///@param {VEBrushType}
  ///@return {?String}
  getCategoryFromType = function(type) {
    static find = function(types, category, type) {
      return Optional.is(types.find(Lambda.equal, type))
    }

    return this.categories.findKey(find, type)
  }
  
  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "brush-toolbar",
        staticHeight: new BindIntent(function() {
          var type = Struct.get(this.nodes, "type")
          var brushBar = Struct.get(this.nodes, "brush-bar")
          var inspectorBar = Struct.get(this.nodes, "inspector-bar")
          var inspectorTool = Struct.get(this.nodes, "inspector-tool")
          var control = Struct.get(this.nodes, "control")
          return type.height() + brushBar.height() + inspectorBar.height() + control.height() + inspectorTool.height()
        }),
        nodes: {
          "accordion": {
            name: "brush-toolbar.accordion",
          },
          "category": {
            name: "brush-toolbar.category",
            x: function() { return this.context.x() - this.width() - 1 },
            width: function() { return 24 },
            height: function() { return 420 },
          },
          "type": {
            name: "brush-toolbar.type",
            height: function() { return 40 },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
          },
          "brush-bar": {
            name: "brush-toolbar.brushBar",
            y: function() { return this.context.nodes.type.bottom() },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
            height: function() { return 16 },
          },
          "brush-view": {
            name: "brush-toolbar.brushView",
            percentageHeight: 0.23,
            margin: { top: 1, bottom: 1, left: 0, right: 10 },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width()
              + this.margin.left },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left 
              - this.margin.right },
            y: function() { return this.margin.top
               + Struct.get(this.context.nodes, "brush-bar").bottom() },
            height: function() { return ceil((this.context.height() 
               - this.context.staticHeight()) * this.percentageHeight) 
               - this.margin.top - this.margin.bottom },
          },
          "inspector-bar": {
            name: "brush-toolbar.inspector-bar",
            y: function() { return Struct.get(this.context.nodes, "brush-view").bottom() },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
            height: function() { return 16 },
          },
          "inspector-tool": {
            name: "brush-toolbar.inspector-tool",
            y: function() { return Struct.get(this.context.nodes, "inspector-bar").bottom() },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() - 1 },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
            height: function() { return 40 },
            nodes: {
              brushIconPreview: {
                name: "brush-toolbar.iinspector-tool.brushIconPreview",
                x: function() { return 4 },
                y: function() { return 4 },
                width: function() { return 32 },
                height: function() { return 32 },
              },
              toolbar: {
                name: "brush-toolbar.inspector-tool.toolbar",
                width: function() { return 32.0 * 4.0 + 16.0 },
                height: function() { return 32.0 },
                x: function() { return this.context.nodes.brushIconPreview.right() + 4.0 },
                y: function() { return round((this.context.height() - this.height()) / 2.0) },
              },
              snapCheckbox: {
                name: "brush-toolbar.inspector-tool.snapCheckbox",
                width: function() { return 28 },
                height: function() { return 28 },
                x: function() { return this.context.nodes.toolbar.right() + 2.0 },
                y: function() { return round((this.context.height() - this.height()) / 2.0) },
              },
              snapLabel: {
                name: "brush-toolbar.inspector-tool.snapLabel",
                width: function() { return 40 },
                height: function() { return 28 },
                x: function() { return this.context.nodes.snapCheckbox.right() + 0.0 },
                y: function() { return round((this.context.height() - this.height()) / 2.0) },
              }
            }
          },
          "inspector-view": {
            name: "brush-toolbar.inspector-view",
            percentageHeight: 0.77,
            margin: { top: 1, bottom: 1, left: 0, right: 10 },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width()
              + this.margin.left },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left 
              - this.margin.right },
            y: function() { return this.margin.top
              + Struct.get(this.context.nodes, "inspector-tool").bottom() },
            height: function() { return ceil((this.context.height() 
              - this.context.staticHeight()) * this.percentageHeight) 
              - this.margin.top - this.margin.bottom - 1},
          },
          "control": {
            name: "brush-toolbar.category",
            y: function() { return Struct.get(this.context.nodes, "inspector-view").bottom() - 1 },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() - 1 },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
            height: function() { return 40 },
          },
          "resize": {
            name: "brush-toolbar.resize",
            x: function() { return -2 },
            y: function() { return 0 },
            width: function() { return 8 },
            height: function() { return this.context.height() },
          }
        }
      },
      parent
    )
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Task}
  factoryOpenTask = function(parent) {
    this.layout = this.factoryLayout(parent)
    var brushToolbar = this
    var containerIntents = new Map(String, Struct)
    VisuBrushContainers.forEach(function(template, name, acc) {
      var layout = Assert.isType(Struct.get(acc.brushToolbar.layout.nodes, name), UILayout)
      var ui = template($"ve-brush-toolbar_{name}", acc.brushToolbar, layout)
      acc.containers.set($"ve-brush-toolbar_{name}", ui)
    }, { containers: containerIntents, brushToolbar: brushToolbar })
    
    return new Task("init-container")
      .setState({
        context: brushToolbar,
        containers: containerIntents,
        queue: new Queue(String, GMArray.sort(containerIntents.keys().getContainer())),
      })
      .whenUpdate(function() {
        var key = this.state.queue.pop()
        if (key == null) {
          this.fullfill()
          return
        }
        this.state.context.containers.set(key, new UI(this.state.containers.get(key)))
      })
      .whenFinish(function() {
        var containers = this.state.context.containers
        IntStream.forEach(0, containers.size(), function(iterator, index, acc) {
          Beans.get(BeanVisuEditorController).uiService.send(new Event("add", {
            container: acc.containers.get(acc.keys[iterator]),
            replace: true,
          }))
        }, {
          keys: GMArray.sort(containers.keys().getContainer()),
          containers: containers,
        })
      })
  }

  ///@param {VEBrushTemplate}
  ///@return {UIComponent}
  parseBrushTemplate = function(template) {
    return new UIComponent({
      name: template.name,
      template: VEComponents.get("brush-entry"),
      layout: VELayouts.get("brush-entry"),
      config: {
        image: {
          image: {
            name: template.texture,
            blend: template.color,
          },
          backgroundMargin: { bottom: 2, right: 0, left: 0, top: 0 },
        },
        label: { 
          text: template.name,
          onMouseReleasedLeft: function() {
            var template = this.context.brushToolbar.store.get("template")
            if (!Core.isType(template.get(), VEBrushTemplate)
                || template.get().name != this.brushTemplate.name
                || template.get().type != this.brushTemplate.type) {

              var templates = Beans.get(BeanVisuController).brushService
                .fetchTemplates(this.brushTemplate.type)
              if (!Core.isType(templates, Array)) {
                return
              }

              var foundTemplate = templates.find(function(template, index, name) {
                return template.name = name
              }, this.brushTemplate.name)
              if (!Core.isType(foundTemplate, VEBrushTemplate)) {
                return
              }

              template.set(foundTemplate)

              var inspector = this.context.brushToolbar.containers.get("ve-brush-toolbar_inspector-view")
              if (Optional.is(inspector)) {
                inspector.finishUpdateTimer()
              }
            }
          },
          brushTemplate: template,
        },
        remove: { 
          sprite: {
            name: "texture_ve_icon_trash",
          },
          callback: function() {
            Beans.get(BeanVisuController).brushService.removeTemplate(this.brushTemplate)
            this.context.collection.remove(this.component.index)
          },
          brushTemplate: template,
        },
        settings: { 
          sprite: {
            name: "texture_ve_icon_settings",
          },
          callback: function() {
            var template = this.context.brushToolbar.store.get("template")
            if (!Core.isType(template.get(), VEBrushTemplate)
                || template.get().name != this.brushTemplate.name
                || template.get().type != this.brushTemplate.type) {

              var templates = Beans.get(BeanVisuController).brushService
                .fetchTemplates(this.brushTemplate.type)
              if (!Core.isType(templates, Array)) {
                return
              }

              var foundTemplate = templates.find(function(template, index, name) {
                return template.name = name
              }, this.brushTemplate.name)
              if (!Core.isType(foundTemplate, VEBrushTemplate)) {
                return
              }

              template.set(foundTemplate)

              var inspector = this.context.brushToolbar.containers.get("ve-brush-toolbar_inspector-view")
              if (Optional.is(inspector)) {
                inspector.finishUpdateTimer()
              }
            }
          },
          brushTemplate: template,
        },
      },
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.dispatcher.execute(new Event("close"))
      Beans.get(BeanVisuEditorController).executor
        .add(this.factoryOpenTask(event.data.layout))
    },
    "close": function(event) {
      var context = this
      this.templatesCache.clear()
      this.containers.forEach(function(container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()

      this.store.get("template").set(null)
      this.store.get("brush").set(null)
    },
    "save-brush": function(event) {
      var control = this.containers.get("ve-brush-toolbar_control")
      if (control == null) {
        return
      }

      var button = control.items.get("button_control-save_type-button")
      if (button == null) {
        return
      }

      button.callback()
    }
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = method(this, EventPumpUtil.send())

  ///@return {VEBrushToolbar}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VEBrushToolbar dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}
