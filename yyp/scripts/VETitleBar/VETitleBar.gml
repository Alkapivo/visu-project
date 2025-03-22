///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
function VETitleBar(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "title-bar",
        nodes: {
          bottomLine: {
            name: "title-bar.bottomLine",
            x: function() { return 0 },
            y: function() { return this.context.height() - this.height() },
            width: function() { return this.context.width() },
            height: function() { return 1 },
          },
          file: {
            name: "title-bar.file",
            x: function() { return this.context.x() + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          edit: {
            name: "title-bar.edit",
            x: function() { return this.context.nodes.file.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          open: {
            name: "title-bar.open",
            x: function() { return this.context.nodes.edit.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          save: {
            name: "title-bar.save",
            x: function() { return this.context.nodes.open.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          help: {
            name: "title-bar.help",
            x: function() { return this.context.nodes.save.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          version: {
            name: "title-bar.version",
            x: function() { return (this.context.width() - this.width()) / 2.0 },
            y: function() { return 0 },
            width: function() { return 256 },
          },
          trackControl: {
            name: "title-bar.trackControl",
            x: function() { return this.context.nodes.event.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          },
          event: {
            name: "title-bar.event",
            x: function() { return this.context.nodes.timeline.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          },
          timeline: {
            name: "title-bar.timeline",
            x: function() { return this.context.nodes.brush.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          },
          brush: {
            name: "title-bar.brush",
            x: function() { return this.context.nodes.sceneConfigPreview.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          },
          sceneConfigPreview: {
            x: function() { return this.context.nodes.fullscreen.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          },
          fullscreen: {
            name: "title-bar.fullscreen",
            x: function() { return this.context.x() + this.context.width()
               - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return this.context.height() },
          }
        }
      }, 
      parent
    )
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Map<String, UI>}
  factoryContainers = function(parent) {
    static factoryTextButton = function(json) {
      var button = Struct.appendRecursiveUnique(
        {
          type: UIButton,
          layout: json.layout,
          backgroundMargin: { top: 2, bottom: 2, left: 2, right: 2 },
          label: { text: json.text },
          options: json.options,
          callback: Struct.getDefault(json, "callback", function() { }),
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          onMouseHoverOver: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
          },
          onMouseHoverOut: function(event) {
            var item = this
            var controller = Beans.get(BeanVisuController)
            controller.executor.tasks.forEach(function(task, iterator, item) {
              if (Struct.get(task.state, "item") == item) {
                task.fullfill()
              }
            }, item)
            
            var task = new Task($"onMouseHoverOut_{item.name}")
              .setTimeout(10.0)
              .setState({
                item: item,
                transformer: new ColorTransformer({
                  value: item.backgroundColorSelected,
                  target: item.backgroundColorOut,
                  factor: 0.026,
                })
              })
              .whenUpdate(function(executor) {
                if (this.state.transformer.update().finished) {
                  this.fullfill()
                }

                this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
              })

            controller.executor.add(task)
          },
        },
        VEStyles.get("ve-title-bar").menu,
        false
      )

      if (Optional.is(Struct.getIfType(json, "postRender", Callable))) {
        Struct.set(button, "postRender", json.postRender)
      }

      return button
    }

    static factoryCheckboxButton = function(json) {
      var _json = {
        type: UICheckbox,
        layout: json.layout,
        spriteOn: json.spriteOn,
        spriteOff: json.spriteOff,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        onMouseHoverOver: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
        },
        onMouseHoverOut: function(event) {
          var item = this
          var controller = Beans.get(BeanVisuController)
          controller.executor.tasks.forEach(function(task, iterator, item) {
            if (Struct.get(task.state, "item") == item) {
              task.fullfill()
            }
          }, item)
          
          var task = new Task($"onMouseHoverOut_{item.name}")
            .setTimeout(10.0)
            .setState({
              item: item,
              transformer: new ColorTransformer({
                value: item.backgroundColorSelected,
                target: item.backgroundColorOut,
                factor: 0.026,
              })
            })
            .whenUpdate(function(executor) {
              if (this.state.transformer.update().finished) {
                this.fullfill()
              }

              this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
            })

          controller.executor.add(task)
        },
      }

      if (Optional.is(Struct.get(json, "store"))) {
        Struct.set(_json, "store", json.store)
      }

      if (Optional.is(Struct.get(json, "callback"))) {
        Struct.set(_json, "callback", json.callback)
      }

      return Struct.appendRecursiveUnique(
        _json,
        VEStyles.get("ve-title-bar").checkbox,
        false
      )
    }

    var controller = this
    var layout = this.factoryLayout(parent)
    return new Map(String, UI, {
      "ve-title-bar": new UI({
        name: "ve-title-bar",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
        }),
        controller: controller,
        layout: layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        items: {
          "button_ve-title-bar_file": factoryTextButton({
            text: "New",
            layout: layout.nodes.file,
            options: new Array(),
            callback: function() {
              if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
                Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                  { message: $"Feature 'visu.title-bar.new' is not available on wasm-yyc target" }))
                return
              }

              var editor = Beans.get(BeanVisuEditorController)
              if (Core.isType(editor.uiService.find("visu-project-modal"), UI)) {
                editor.projectModal.send(new Event("close"))
              }
        
              if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
                editor.exitModal.send(new Event("close"))
              }

              editor.newProjectModal
                .send(new Event("open").setData({
                  layout: new UILayout({
                    name: "display",
                    x: function() { return 0 },
                    y: function() { return 0 },
                    width: function() { return GuiWidth() },
                    height: function() { return GuiHeight() },
                  }),
                }))
            },
          }),
          "button_ve-title-bar_edit": factoryTextButton({
            text: "Edit",
            layout: layout.nodes.edit,
            options: new Array(),
            callback: function() {
              if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
                Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                  { message: $"Feature 'visu.title-bar.edit' is not available on wasm-yyc target" }))
                return
              }

              var editor = Beans.get(BeanVisuEditorController)
              if (Core.isType(editor.uiService.find("visu-new-project-modal"), UI)) {
                editor.newProjectModal.send(new Event("close"))
              }
        
              if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
                editor.exitModal.send(new Event("close"))
              }

              editor.projectModal
                .send(new Event("open").setData({
                  layout: new UILayout({
                    name: "display",
                    x: function() { return 0 },
                    y: function() { return 0 },
                    width: function() { return GuiWidth() },
                    height: function() { return GuiHeight() },
                  }),
                }))
            }
          }),
          "button_ve-title-bar_open": factoryTextButton({
            text: "Open",
            layout: layout.nodes.open,
            options: new Array(),
            callback: function() {
              try {
                if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
                  Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                    { message: $"Feature 'visu.title-bar.open' is not available on wasm-yyc target" }))
                  return
                }

                var manifest = FileUtil.getPathToOpenWithDialog({ 
                  description: "Visu track file",
                  filename: "manifest", 
                  extension: "visu"
                })
  
                if (!FileUtil.fileExists(manifest)) {
                  return
                }

                Beans.get(BeanVisuController).send(new Event("load", {
                  manifest: manifest,
                  autoplay: false
                }))
              } catch (exception) {
                Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                  { message: $"Cannot load the project: {exception.message}" }))
              }
            }
          }),
          "button_ve-title-bar_save": factoryTextButton({
            text: "Save",
            layout: layout.nodes.save,
            options: new Array(),
            callback: function() {
              try {
                if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
                  Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                    { message: $"Feature 'visu.title-bar.save' is not available on wasm-yyc target" }))
                  return
                }

                var path = FileUtil.getPathToSaveWithDialog({ 
                  description: "Visu track file",
                  filename: "manifest", 
                  extension: "visu",
                })

                if (!Core.isType(path, String) || String.isEmpty(path)) {
                  return
                }

                if (!Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
                  return
                }

                var controller = Beans.get(BeanVisuController)
                controller.track.saveProject(path)
                controller.send(new Event("spawn-popup", 
                  { message: $"Project '{controller.trackService.track.name}' saved successfully at: '{path}'" }))
              } catch (exception) {
                var message = $"Cannot save the project: {exception.message}"
                Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
                Logger.error("VETitleBar", message)
              }
            }
          }),
          "button_ve-title-bar_help": factoryTextButton({
            text: "Help",
            layout: layout.nodes.help,
            options: new Array(),
            callback: function() {
              try {
                url_open("https://github.com/Alkapivo/visu-project/wiki/1.-UI-overview")
              } catch (exception) {
                var message = $"Cannot open URL: {exception.message}"
                Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
                Logger.error("VETitleBar", message)
              }
            }
          }),
          "text_ve-title-bar_version": Struct.appendRecursiveUnique(
            {
              type: UIText,
              layout: layout.nodes.version,
              text: $"v.{GM_build_date} {date_datetime_string(GM_build_date)}",
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("ve-title-bar").version,
            false
          ),
          "button_ve-title-bar_scene-config-preview": factoryCheckboxButton({
            layout: layout.nodes.sceneConfigPreview,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 5 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 5, alpha: 0.5 },
            store: { key: "render-sceneConfigPreview" },
          }),
          "button_ve-title-bar_track-control": factoryCheckboxButton({
            layout: layout.nodes.trackControl,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 4 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 4, alpha: 0.5 },
            store: { key: "render-trackControl" },
          }),
          "button_ve-title-bar_event": factoryCheckboxButton({
            layout: layout.nodes.event,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 0 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 0, alpha: 0.5 },
            store: { key: "render-event" },
          }),
          "button_ve-title-bar_timeline": factoryCheckboxButton({
            layout: layout.nodes.timeline,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 1 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 1, alpha: 0.5 },
            store: { key: "render-timeline" },
          }),
          "button_ve-title-bar_brush": factoryCheckboxButton({
            layout: layout.nodes.brush,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 2 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 2, alpha: 0.5 },
            store: { key: "render-brush" },
          }),
          "button_ve-title-fullscreen": factoryCheckboxButton({
            layout: layout.nodes.fullscreen,
            spriteOn: { name: "texture_ve_title_bar_icons", frame: 3 },
            spriteOff: { name: "texture_ve_title_bar_icons", frame: 3 },
            callback: function(event) {
              var displayService = Beans.get(BeanVisuController).displayService
              var fullscreen = displayService.getFullscreen()
              displayService.setFullscreen(!fullscreen)
            },
          }),
          "line_ve-title-bottomLine": {
            type: UIImage,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            layout: layout.nodes.bottomLine,
            backgroundColor: VETheme.color.accentShadow,
            backgroundAlpha: 0.85,
          },
        },
      }),
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.containers = this.factoryContainers(event.data.layout)
      containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService)
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function(container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETitleBar}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VETitleBar dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}