///@package io.alkapivo.visu.editor.ui.controller

///@param {Struct} config
///@return {Struct}
function factoryVEBrushToolbarTypeItem(config) {
  return {
    name: config.name,
    template: VEComponents.get("category-button"),
    layout: VELayouts.get("horizontal-item"),
    config: {
      backgroundColor: VETheme.color.primary,
      backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
      backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
      backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
      backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
      callback: function() {
        this.context.brushToolbar.store
          .get("type")
          .set(this.brushType)
        
        this.context.brushToolbar.store
          .get("template")
          .set(null)
        
        this.context.brushToolbar.store
          .get("brush")
          .set(null)

        var view = this.context.brushToolbar.containers.get("ve-brush-toolbar_inspector-view")
        view.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
        view.collection.components.clear() ///@todo replace with remove lambda
        view.state
          .set("template", null)
          .set("brush", null)
          .set("store", null)
      },
      updateCustom: function() {
        this.backgroundColor = this.brushType == this.context.brushToolbar.store.getValue("type")
          ? this.backgroundColorOn
          : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
      },
      onMouseHoverOver: function(event) { },
      onMouseHoverOut: function(event) { },
      label: { text: config.text },
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
        "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
      }),
      brushToolbar: brushToolbar,
      updateTimer: new Timer(FRAME_MS * 4, { loop: Infinity, shuffle: true }),
      layout: brushToolbar.layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "resize_brush_toolbar": {
          type: UIButton,
          layout: brushToolbar.layout.nodes.resize,
          backgroundColor: VETheme.color.primary, //resize
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
            if (MouseUtil.getClipboard() == this.clipboard) {
              this.updateLayout(MouseUtil.getMouseX())
              this.context.brushToolbar.containers.forEach(function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }

                container.surfaceTick.skip()
                container.updateTimer.time = container.updateTimer.duration
              })

              // reset timeline timer to avoid ghost effect,
              // because brushtoolbar height is affecting timeline height
              Beans.get(BeanVisuEditorController).timeline.containers.forEach(function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }

                container.surfaceTick.skip()
                container.updateTimer.time = container.updateTimer.duration
              })

              if (!mouse_check_button(mb_left)) {
                MouseUtil.clearClipboard()
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            }
          },
          updateLayout: new BindIntent(function(position) {
            var editor = Beans.get(BeanVisuEditorController)
            var node = Struct.get(editor.layout.nodes, "brush-toolbar")
            node.percentageWidth = abs(GuiWidth() - position) / GuiWidth()

            var events = editor.uiService.find("ve-timeline-events")
            if (Core.isType(events, UI) && Optional.is(events.updateTimer)) {
              events.updateTimer.finish()
            }
          }),
          onMousePressedLeft: function(event) {
            MouseUtil.setClipboard(this.clipboard)
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
        "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
        "components": new Array(Struct, [
          {
            name: "button_category-shader",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("vertical-item"),
            config: {
              backgroundColor: VETheme.color.primary,
              backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
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
              label: { text: String.toArray("SHADER").join("\n") },
              category: "shader",
            },
          },
          {
            name: "button_category-shroom",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("vertical-item"),
            config: {
              backgroundColor: VETheme.color.primary,
              backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
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
              label: { text: String.toArray("SHROOM").join("\n") },
              category: "shroom",
            },
          },
          {
            name: "button_category-grid",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("vertical-item"),
            config: {
              backgroundColor: VETheme.color.primary,
              backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
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
              label: { text: String.toArray("GRID").join("\n") },
              category: "grid",
            },
          },
          {
            name: "button_category-view",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("vertical-item"),
            config: {
              backgroundColor: VETheme.color.primary,
              backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
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
              label: { text: String.toArray("VIEW").join("\n") },
              category: "view",
            },
          },
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
  "type": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-alpha": 1.0,
        "background-color": ColorUtil.fromHex("#282828").toGMColor(),
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
        "grid": new Array(Struct, [
          {
            name: "button_category-grid_type-channel",
            text: "Channel",
            brushType: VEBrushType.GRID_CHANNEL,
          },
          {
            name: "button_category-grid_type-separator",
            text: "Separator",
            brushType: VEBrushType.GRID_SEPARATOR,
          },
          {
            name: "button_category-grid_type-particle",
            text: "Particle",
            brushType: VEBrushType.GRID_PARTICLE,
          },
          {
            name: "button_category-grid_type-player",
            text: "Player",
            brushType: VEBrushType.GRID_PLAYER,
          },
          {
            name: "button_category-grid_type-coin",
            text: "Coin",
            brushType: VEBrushType.GRID_COIN,
          },
          {
            name: "button_category-grid_type-config",
            text: "Config",
            brushType: VEBrushType.GRID_CONFIG,
          },
        ]).map(factoryVEBrushToolbarTypeItem),
        "view": new Array(Struct, [
          {
            name: "button_category-view_type-wallpaper",
            text: "Wallpaper",
            brushType: VEBrushType.VIEW_WALLPAPER,
          },
          {
            name: "button_category-view_type-camera",
            text: "Camera",
            brushType: VEBrushType.VIEW_CAMERA,
          },
          {
            name: "button_category-view_type-lyrics",
            text: "Lyrics",
            brushType: VEBrushType.VIEW_LYRICS,
          },
          {
            name: "button_category-view_type-glitch",
            text: "Glitch",
            brushType: VEBrushType.VIEW_GLITCH,
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
        "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
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
            update: Callable.run(UIUtil.updateAreaTemplates.get("applyMargin")),
          },
          VEStyles.get("bar-title"),
          false
        ),
        "button_brush-control-load": Struct.appendRecursiveUnique(
          {
            type: UIButton,
            group: { index: 1, size: 2, width: 48 },
            label: { text: "Import" },
            backgroundColor: VETheme.color.primary,
            colorHoverOver: VETheme.color.accentShadow,
            colorHoverOut: VETheme.color.primary,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("groupByXWidth")),
            callback: function(event) {
              var type = this.context.brushToolbar.store.getValue("type")
              var saveTemplate = Beans.get(BeanVisuEditorController).brushService.saveTemplate
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
            label: { text: "Export" },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("groupByXWidth")),
            backgroundColor: VETheme.color.primary,
            colorHoverOver: VETheme.color.accentShadow,
            colorHoverOut: VETheme.color.primary,
            callback: function(event) {
              var type = this.context.brushToolbar.store.getValue("type")
              var templates = Beans.get(BeanVisuEditorController).brushService.fetchTemplates(type)
              var data = JSON.stringify({
                "model": "Collection<io.alkapivo.visu.editor.api.VEBrushTemplate>",
                "data": Assert.isType(Beans.get(BeanVisuEditorController).brushService
                  .fetchTemplates(type)
                  .getContainer(), GMArray),
              }, { pretty: true })

              Beans.get(BeanFileService).send(new Event("save-file-sync")
                .setData(new File({
                  path: FileUtil.getPathToSaveWithDialog({ 
                    description: "JSON file",
                    filename: "brush", 
                    extension: "json",
                  }),
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
        "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
        "empty-label": new UILabel({
          text: "Click to\nadd template",
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        }),
        "dragItem": null,
      }),
      updateTimer: new Timer(FRAME_MS * 60, { loop: Infinity, shuffle: true }),
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
          MouseUtil.setClipboard(component)
        }
      },
      onMouseDropLeft: function(event) {
        var dragItem = this.state.get("dragItem")
        if (Optional.is(dragItem) && MouseUtil.getClipboard() == dragItem) {
          this.state.set("dragItem", null)
          MouseUtil.setClipboard(null)

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
            var templates = Beans.get(BeanVisuEditorController).brushService.fetchTemplates(type)
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

            this.updateTimer.time = this.updateTimer.duration
          }
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
          callback: function(type, data) {
            data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
            data.collection.components.clear() ///@todo replace with remove lambda
            data.state.set("type", type)

            var brushService = Beans.get(BeanVisuEditorController).brushService
            var task = new Task("load-brushes")
              .setState({
                collection: data.collection,
                templates: Assert.isType(brushService.templates.get(type), Array),
                pointer: 0,
                parse: data.brushToolbar.parseBrushTemplate,
              })
              .whenUpdate(function(executor) {
                if (this.state.templates.size() == 0) {
                  this.fullfill()
                }

                if (this.state.pointer >= this.state.templates.size()) {
                  return
                }

                var template = this.state.templates.get(this.state.pointer)
                if (Core.isType(template, Struct)) {
                  this.state.collection.add(this.state.parse(template))
                }

                this.state.pointer = this.state.pointer + 1
                if (this.state.pointer >= this.state.templates.size()) {
                  this.fullfill()
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
          Beans.get(BeanVisuEditorController).brushService.saveTemplate(template)
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
        "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
      }),
      updateTimer: new Timer(FRAME_MS * 6, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
      items: {
        "label_inspector-control-title": Struct.appendRecursiveUnique(
          {
            type: UIText,
            text: "Brush inspector",
            clipboard: {
              name: "resize_brush_inspector",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_VERTICAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            __update: new BindIntent(Callable.run(UIUtil.updateAreaTemplates.get("applyMargin"))),
            updateCustom: function() {
              this.__update()
              if (MouseUtil.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseY())
                this.context.brushToolbar.containers.forEach(function(container) {
                  if (!Optional.is(container.updateTimer)) {
                    return
                  }

                  container.surfaceTick.skip()
                  container.updateTimer.time = container.updateTimer.duration
                })

                if (!mouse_check_button(mb_left)) {
                  MouseUtil.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(_position) {
              var uiService = Beans.get(BeanVisuEditorController).uiService
              var titleBar = uiService.find("ve-title-bar")
              var statusBar = uiService.find("ve-status-bar")
              var brushNode = Struct.get(this.context.layout.context.nodes, "brush-view")
              var inspectorNode = Struct.get(this.context.layout.context.nodes, "inspector-view")
              var typeNode = Struct.get(this.context.layout.context.nodes, "type")
              var controlNode = Struct.get(this.context.layout.context.nodes, "control")
              var top = titleBar.layout.height() + typeNode.height() + typeNode.margin.top + typeNode.margin.bottom
              var bottom = GuiHeight() - statusBar.layout.height() - (controlNode.height() + controlNode.margin.top + controlNode.margin.bottom)
              var length = bottom - top
              var position = clamp(_position - top, 0, length)
              inspectorNode.percentageHeight = clamp((length - position) / length, 0.07, 0.93)
              brushNode.percentageHeight = 1.0 - inspectorNode.percentageHeight
            }),
            onMousePressedLeft: function(event) {
              MouseUtil.setClipboard(this.clipboard)
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
  "inspector-view": function(name, brushToolbar, layout) {
    return {
      name: name,
      state: new Map(String, any, {
        "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
        "inspectorType": VEBrushToolbar,
      }),
      updateTimer: new Timer(FRAME_MS * 60, { loop: Infinity, shuffle: true }),
      brushToolbar: brushToolbar,
      layout: layout,
      scrollbarY: { align: HAlign.RIGHT },
      updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
      renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
      render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable")),
      onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
      onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
      onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
      onInit: function() {
        var container = this
        this.collection = new UICollection(this, { layout: container.layout })
        this.brushToolbar.store.get("template").addSubscriber({ 
          name: this.name,
          callback: function(template, data) {
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

            data.updateArea()
            data.addUIComponents(brush.components
              .map(function(component) {
                return new UIComponent(component)
              }),
              new UILayout({
                area: data.area,
                width: function() { return this.area.getWidth() },
              })
            )
          },
          data: container
        })
      },
      onDestroy: function() {
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
        "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
        "components": new Array(Struct, [
          {
            name: "button_control-preview",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("horizontal-item"),
            config: {
              colorHoverOver: VETheme.color.accentShadow,
              colorHoverOut: VETheme.color.primaryShadow,
              backgroundColor: VETheme.color.primaryShadow,
              backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
              label: { text: "Preview" },
              callback: function() { 
                var brushToolbar = this.context.brushToolbar
                var brush = brushToolbar.store.getValue("brush")
                if (!Core.isType(brush, VEBrush)) {
                  return
                }
                
                var handler = Beans.get(BeanVisuController).trackService.handlers.get(brush.type)
                handler(brush.toTemplate().properties)
              },
              onMouseHoverOver: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
              },
              onMouseHoverOut: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
              },
            },
          },
          {
            name: "button_control-save",
            template: VEComponents.get("category-button"),
            layout: VELayouts.get("horizontal-item"),
            config: {
              colorHoverOver: VETheme.color.accentShadow,
              colorHoverOut: VETheme.color.primaryShadow,
              backgroundColor: VETheme.color.primaryShadow,
              backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
              label: { text: "Save" },
              callback: function() { 
                if (Core.isType(GMTFContext.get(), GMTF)) {
                  if (Core.isType(GMTFContext.get().uiItem, UIItem)) {
                    GMTFContext.get().uiItem.update()
                  }
                  GMTFContext.get().unfocus()
                }
                
                var brushToolbar = this.context.brushToolbar
                var inspector = brushToolbar.containers
                  .get("ve-brush-toolbar_inspector-view")

                if (Core.isType(inspector, UI) 
                  && Optional.is(inspector.updateTimer)) {
                  inspector.updateTimer.time = inspector.updateTimer.duration
                }

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
                var brushService = Beans.get(BeanVisuEditorController).brushService
                var sizeBefore = brushService.fetchTemplates(template.type).size()
                brushService.saveTemplate(template)
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
              },
              onMouseHoverOver: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
              },
              onMouseHoverOut: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
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

  ///@type {?UILayout}
  layout = null

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "category": {
      type: String,
      value: "shader",
    },
    "type": {
      type: String,
      value: VEBrushType.SHADER_SPAWN,
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

  ///@type {Map<String, Array>}
  categories = new Map(String, Array, {
    "shader": new Array(String, [ 
      VEBrushType.SHADER_SPAWN, 
      VEBrushType.SHADER_OVERLAY, 
      VEBrushType.SHADER_CLEAR, 
      VEBrushType.SHADER_CONFIG 
    ]),
    "shroom": new Array(String, [ 
      VEBrushType.SHROOM_SPAWN, 
      VEBrushType.SHROOM_CLEAR, 
      VEBrushType.SHROOM_CONFIG 
    ]),
    "grid": new Array(String, [ 
      VEBrushType.GRID_CHANNEL,
      VEBrushType.GRID_COIN,  
      VEBrushType.GRID_CONFIG, 
      VEBrushType.GRID_PARTICLE,
      VEBrushType.GRID_PLAYER,
      VEBrushType.GRID_SEPARATOR
    ]),
    "view": new Array(String, [ 
      VEBrushType.VIEW_WALLPAPER, 
      VEBrushType.VIEW_CAMERA,
      VEBrushType.VIEW_LYRICS,
      VEBrushType.VIEW_GLITCH,
      VEBrushType.VIEW_CONFIG 
    ]),
  })

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
          var control = Struct.get(this.nodes, "control")
          return type.height() + brushBar.height() + inspectorBar.height() + control.height()
        }),
        nodes: {
          "accordion": {
            name: "brush-toolbar.accordion",
          },
          "category": {
            name: "brush-toolbar.category",
            x: function() { return this.context.x() - this.width() },
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
              + Struct.get(this.context.nodes, "inspector-bar").bottom() },
            height: function() { return ceil((this.context.height() 
              - this.context.staticHeight()) * this.percentageHeight) 
              - this.margin.top - this.margin.bottom },
          },
          "control": {
            name: "brush-toolbar.category",
            y: function() { return Struct.get(this.context.nodes, "inspector-view").bottom() },
            x: function() { return this.context.x()
              + this.context.nodes.resize.width() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width() },
            height: function() { return 40 },
          },
          "resize": {
            name: "brush-toolbar.resize",
            x: function() { return 0 },
            y: function() { return 0 },
            width: function() { return 7 },
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
        },
        label: { 
          text: template.name,
          colorHoverOver: VETheme.color.accentShadow,
          colorHoverOut: VETheme.color.primaryShadow,
          onMouseReleasedLeft: function() {
            var template = this.context.brushToolbar.store.get("template")
            if (!Core.isType(template.get(), VEBrushTemplate)
              || template.get().name != this.brushTemplate.name) {

              var templates = Beans.get(BeanVisuEditorController).brushService.fetchTemplates(this.brushTemplate.type)
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

              var inspector = this.context.brushToolbar.containers
                .get("ve-brush-toolbar_inspector-view")

              if (Core.isType(inspector, UI) 
                && Optional.is(inspector.updateTimer)) {
                inspector.updateTimer.time = inspector.updateTimer.duration
              }
            }
          },
          brushTemplate: template,
        },
        button: { 
          sprite: {
            name: "texture_ve_icon_trash",
            blend: VETheme.color.textShadow,
          },
          callback: function() {
            Beans.get(BeanVisuEditorController).brushService.removeTemplate(this.brushTemplate)
            this.context.collection.remove(this.component.index)
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
      this.containers.forEach(function (container, key, uiService) {
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

      var button = control.items.get("button_control-save_category-button")
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
