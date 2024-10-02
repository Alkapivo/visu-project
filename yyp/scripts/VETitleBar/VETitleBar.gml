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
          view: {
            name: "title-bar.view",
            x: function() { return this.context.nodes.edit.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          help: {
            name: "title-bar.help",
            x: function() { return this.context.nodes.view.right()
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
            width: function() { return 20 },
          },
          event: {
            name: "title-bar.event",
            x: function() { return this.context.nodes.timeline.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return 20 },
          },
          timeline: {
            name: "title-bar.timeline",
            x: function() { return this.context.nodes.brush.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return 20 },
          },
          brush: {
            name: "title-bar.brush",
            x: function() { return this.context.nodes.fullscreen.left() 
              - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return 20 },
          },
          fullscreen: {
            name: "title-bar.fullscreen",
            x: function() { return this.context.x() + this.context.width()
               - this.width() - this.margin.right },
            y: function() { return 0 },
            width: function() { return 20 },
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
      return Struct.appendRecursiveUnique(
        {
          type: UIButton,
          layout: json.layout,
          label: { text: json.text },
          options: json.options,
          callback: Struct.getDefault(json, "callback", function() { }),
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          onMouseHoverOver: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
          },
          onMouseHoverOut: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
          },
        },
        VEStyles.get("ve-title-bar").menu,
        false
      )
    }

    static factoryCheckboxButton = function(json) {
      var _json = {
        type: UICheckbox,
        layout: json.layout,
        spriteOn: json.spriteOn,
        spriteOff: json.spriteOff,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
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
          "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
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
              Beans.get(BeanVisuEditorController).newProjectModal
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
          "button_ve-title-bar_view": factoryTextButton({
            text: "Open",
            layout: layout.nodes.edit,
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
          "button_ve-title-bar_edit": factoryTextButton({
            text: "Save",
            layout: layout.nodes.view,
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
      this.containers.forEach(function (container, key, uiService) {
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