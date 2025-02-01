///@package io.alkapivo.visu.editor.ui.controller

global.__THEME_COLOR_ORDER = [
  "accentLight",
  "accent",
  "accentShadow",
  "accentDark",
  "primaryLight",
  "primary",
  "primaryShadow",
  "primaryDark",
  "sideLight",
  "side",
  "sideShadow",
  "sideDark",
  "button",
  "buttonHover",
  "text",
  "textShadow",
  "textFocus",
  "textSelected",
  "accept",
  "acceptShadow",
  "deny",
  "denyShadow",
  "ruler",
  "header",
  "stick",
  "stickHover",
  "stickBackground"
]
#macro THEME_COLOR_ORDER global.__THEME_COLOR_ORDER


///@param {Struct} [json]
function VisuProjectForm(json = null) constructor {
  var controller = Beans.get(BeanVisuController)
  var visuTrack = controller.track
  if (!Core.isType(visuTrack, VisuTrack)) {
    visuTrack = {
      video: null,
    }
  }

  var track = controller.trackService.track
  if (!Core.isType(track, Track)) {
    track = {
      name: "New project"
    }
  }

  var soundIntent = Beans.get(BeanSoundService).intents.get("sound_external")
  if (!Core.isType(soundIntent, SoundIntent)) {
    soundIntent = {
      file: null,
    }
  }

  ///@type {Store}
  store = new Store({
    "project-name": {
      type: String,
      value: Struct.getDefault(json, "name", track.name),
    },
    "file-audio": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "file-audio", Core.isType(soundIntent.file, String) 
        ? $"{visuTrack.path}{soundIntent.file}"
        : null),
    },
    "use-file-video": {
      type: Boolean,
      value: Struct.getDefault(json, "use-file-video", Core.isType(visuTrack.video, String)),
    },
    "file-video": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "file-video", Core.isType(visuTrack.video, String) 
        ? FileUtil.get($"{visuTrack.path}{visuTrack.video}")
        : null),
    },
  })

  ///@type {Array<Struct>}
  components = new Array(Struct, [
    {
      name: "titlebar",
      template: VEComponents.get("property-bar"),
      layout: VELayouts.get("property-bar"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Project settings" },
      },
    },
    {
      name: "project-name",
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { type: UILayoutType.VERTICAL, margin: { top: 4 } },
        label: { text: "Name" },
        field: { store: { key: "project-name" } },
      },
    },
    {
      name: "project-name_line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    },
    {
      name: "use-file-audio",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Import audio",
          //enable: { key: "use-file-video" },
          backgroundColor: VETheme.color.side,
        },
        checkbox: { 
          //store: { key: "use-file-video" },
          //spriteOn: { name: "visu_texture_checkbox_on" },
          //spriteOff: { name: "visu_texture_checkbox_off" },
          //scaleToFillStretched: false,
          backgroundColor: VETheme.color.side,
        },
        input: {
          backgroundColor: VETheme.color.side,
        },
      },
    },
    {
      name: "file-audio",  
      template: VEComponents.get("text-field-button"),
      layout: VELayouts.get("text-field-button"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "*.OGG" },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("file-audio")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
        },
        button: { 
          label: { text: "Open" },
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "OGG file",
              extension: "ogg",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("file-audio")
              .set(path)
          },
          colorHoverOver: VETheme.color.accentLight,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
          },
          onMouseHoverOut: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
          },
        },
      },
    },
    {
      name: "file-audio_line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    },
    {
      name: "use-file-video",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Import video",
          //enable: { key: "use-file-video" },
          backgroundColor: VETheme.color.side,
        },
        checkbox: { 
          store: { key: "use-file-video" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          //scaleToFillStretched: false,
          backgroundColor: VETheme.color.side,
        },
        input: {
          backgroundColor: VETheme.color.side,
        },
      },
    },
    {
      name: "file-video",  
      template: VEComponents.get("text-field-button"),
      layout: VELayouts.get("text-field-button"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "*.MP4",
          enable: { key: "use-file-video" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("file-video")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-file-video"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-file-video"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "MP4 file",
              extension: "mp4",
            })

            this.context.state.get("store")
              .get("file-video")
              .set(FileUtil.fileExists(path) ? path : null)
          },
          colorHoverOver: VETheme.color.accentLight,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            if (Struct.get(this.enable, "value") == false) {
              return 
            }
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
          },
          onMouseHoverOut: function(event) {
            this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
          },
        },
      },
    },
    {
      name: "file-video_line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    },
    {
      name: "button_apply",
      template: VEComponents.get("button"),
      layout: VELayouts.get("button"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        backgroundColor: VETheme.color.acceptShadow,
        backgroundMargin: { top: 1, bottom: 0, left: 5, right: 5 },
        label: { text: "Save visu project" },
        colorHoverOver: VETheme.color.accept,
        colorHoverOut: VETheme.color.acceptShadow,
        onMouseHoverOver: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
        },
        onMouseHoverOut: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
        },
        onMouseReleasedLeft: function(event) {
          if (Core.isType(GMTFContext.get(), GMTF)) {
            if (Core.isType(GMTFContext.get().uiItem, UIItem)) {
              GMTFContext.get().uiItem.update()
            }
            GMTFContext.get().unfocus()
          }

          if (String.isEmpty(this.context.state.get("form").store.getValue("project-name"))) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: "Name cannot be empty" }))
            return
          }
      
          if (!FileUtil.fileExists(this.context.state.get("form").store.getValue("file-audio"))) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: "Audio must be selected" }))
            return
          }

          var visuTrack = Beans.get(BeanVisuController).track
          if (!Core.isType(visuTrack, VisuTrack)) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: "VisuTrack must be loaded" }))
            return
          }

          var path = $"{visuTrack.path}manifest.visu"
          if (!FileUtil.fileExists(path)) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: "manifest.visu must exists" }))
            return
          }

          try {
            this.context.state.get("form").save()
          } catch (exception) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: $"Cannot update project: {exception.message}" }))
            this.context.modal.send(new Event("close"))
            return
          }
          return;//
          this.context.modal.send(new Event("close"))
          try {
            Assert.isTrue(FileUtil.fileExists(path))
            Beans.get(BeanVisuController).send(new Event("load", {
              manifest: path,
              autoplay: false
            }))
          } catch (exception) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: $"Cannot load the project: {exception.message}" }))
          }
        },
      },
    },
    {
      name: "button_cancel",
      template: VEComponents.get("button"),
      layout: VELayouts.get("button"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        backgroundColor: VETheme.color.denyShadow,
        backgroundMargin: { top: 1, bottom: 1, left: 5, right: 5 },
        label: { text: "Cancel" },
        colorHoverOver: VETheme.color.deny,
        colorHoverOut: VETheme.color.denyShadow,
        onMouseHoverOver: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
        },
        onMouseHoverOut: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
        },
        onMouseReleasedLeft: function(event) {
          this.context.modal.send(new Event("close"))
        },
      },
    },
  ])

  
  if (Core.getProperty("visu.editor.edit-theme")) {
    GMArray.forEach(THEME_COLOR_ORDER, function(colorName, index, acc) {
      var key = $"theme-color-{colorName}"
      if (!acc.store.contains(key)) {
        acc.store.add(new StoreItem(key, {
          type: Color,
          value: ColorUtil.parse(Struct.get(acc.theme, colorName)),
        }))
      }
  
      acc.components.add({
        name: key,
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          line: { disable: true },
          title: {
            label: { text: colorName },  
            input: { store: { key: key } }
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: key } },
            slider: { store: { key: key } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: key } },
            slider: { store: { key: key } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: key } },
            slider: { store: { key: key } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: key } },
          },
        },
      })
    }, {
      store: this.store,
      components: this.components,
      theme: Visu.settings.getValue("visu.editor.theme"),
    })
  }

  ///@return {VisuProjectForm}
  save = function() {

    if (Core.getProperty("visu.editor.edit-theme")) {
      GMArray.forEach(THEME_COLOR_ORDER, function(colorName, index, store) {
        var key = $"theme-color-{colorName}"
        if (!store.contains(key)) {
          Logger.error("VisuProjectForm", $"Color store item not found: {key}")
          return
        }

        Struct.set(VETheme.color, colorName, store.getValue(key).toHex())
      }, this.store)

      Visu.settings.setValue("visu.editor.theme", VETheme.color).save()
      VEStyles = generateVEStyles()

      var task = new Task("reset-editor")
        .setState({ stage: "kill" })
        .setTimeout(5.0)
        .whenUpdate(function(executor) {
          if (this.state.stage == "kill") {
            if (Optional.is(Beans.get(BeanVisuEditorIO))) {
              Beans.kill(BeanVisuEditorIO)
            }

            if (Optional.is(Beans.get(BeanVisuEditorController))) {
              Beans.kill(BeanVisuEditorController)
            }
            this.state.stage = "add"
          } else if (this.state.stage == "add") {
            if (!Optional.is(Beans.get(BeanVisuEditorIO))) {
              Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, 
                Beans.get(BeanVisuController).layerId, new VisuEditorIO()))
            }

            if (!Optional.is(Beans.get(BeanVisuEditorController))) {
              Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, 
                Beans.get(BeanVisuController).layerId, new VisuEditorController()))
            }
            this.state.stage = "open"
          } else if (this.state.stage == "open") {
            var editor = Beans.get(BeanVisuEditorController)
            if (Optional.is(editor)) {
              editor.renderUI = true
              editor.send(new Event("open"))
              this.fullfill()
            }
          }
        })
      Beans.get(BeanVisuController).executor.add(task)

      return this
    }

    var controller = Beans.get(BeanVisuController)
    var track = controller.trackService.track
    var visuTrack = controller.track
    if (!Core.isType(track, Track)
      || !Core.isType(visuTrack, VisuTrack)) {
      return this
    }

    var path = $"{controller.track.path}"
    if (!FileUtil.directoryExists(path)) {
      return this
    }

    track.name = this.store.getValue("project-name")

    var soundPath = this.store.getValue("file-audio")
    var soundFile = FileUtil.getFilenameFromPath(soundPath)
    var soundIntent = Beans.get(BeanSoundService).intents.get("sound_external")
    if (Core.isType(soundIntent, SoundIntent)) {
      FileUtil.copyFile(soundPath, FileUtil.get($"{path}{soundFile}"))
      soundIntent.file = soundFile
    }
    
    var useVideo = this.store.getValue("use-file-video")
    var videoPath = useVideo ? this.store.getValue("file-video") : null
    if (Core.isType(videoPath, String) &&
      FileUtil.fileExists(videoPath)) {
      var videoFile = FileUtil.getFilenameFromPath(videoPath)
      FileUtil.copyFile(videoPath, FileUtil.get($"{path}{videoFile}"))
      visuTrack.video = videoFile
    } else {
      visuTrack.video = null
    }
    
    Beans.get(BeanVisuEditorController).autosave.save()

    Beans.get(BeanVisuController).send(new Event("spawn-popup", 
      { message: $"Project '{track.name}' updated successfully at: '{path}'" }))

    return this
  }
}


///@param {?Struct} [_config]
function VEProjectModal(_config = null) constructor {

  ///@type {?Struct}
  config = Core.isType(_config, Struct) ? _config : null

  ///@type {Store}
  store = new Store({
    "form": {
      type: Optional.of(VisuProjectForm),
      value: null,
    },
  })

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    var editTheme = Core.getProperty("visu.editor.edit-theme")
    return new UILayout(
      {
        name: "visu-project-modal",
        x: editTheme
          ? function() { return 48 }
          : function() { return (GuiWidth() - this.width()) / 2.0 },
        y: function() { return this.context.y() + 24 },
        width: function() { return 640 },
        height: editTheme
          ? function() { return GuiHeight() - 48 }
          : function() { return 256 },
      },
      parent
    )
  }

  ///@private
  ///@param {?UIlayout} [parent]
  ///@return {Map<String, UI>}
  factoryContainers = function(parent = null) {
    var modal = this
    var layout = this.factoryLayout(parent)
    return new Map(String, UI, {
      "visu-project-modal": new UI({
        name: "visu-project-modal",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
        }),
        modal: modal,
        layout: layout,
        propagate: false,
        scrollbarY: { align: HAlign.RIGHT },
        onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
        onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable"))),
        render: Core.getProperty("visu.editor.edit-theme")
          ? function() {
            this.renderDefaultScrollable()
  
            GMArray.forEach(THEME_COLOR_ORDER, function(colorName, index, context) {
              var form = context.modal.store.getValue("form")
              if (!Optional.is(form)) {
                return
              }
  
              var color = form.store.getValue($"theme-color-{colorName}")
              if (!Optional.is(color)) {
                return
              }
  
              GPU.render.rectangle(
                48 + 640 + 24,
                20 + (index * 32),
                48 + 640 + 24 + 640,
                20 + 32 + (index * 32),
                false,
                color.toGMColor()
              )
  
              GPU.render.text(
                48 + 640 + 24 + 24,
                20 + (index * 32) + 16,
                $"{color.toHex()}: {colorName}",
                c_black,
                c_white,
                1.0,
                GPU_DEFAULT_FONT_BOLD,
                HAlign.LEFT,
                VAlign.CENTER,
                1.0,
              )
            }, this)

            return this
          }
          : function() {
            this.enableScrollbarY = false
            this.renderDefaultScrollable()

            return this
          },
        onInit: function() {
          var container = this
          this.collection = new UICollection(this, { layout: container.layout })
          this.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
          this.collection.components.clear() ///@todo replace with remove lambda
          this.state.set("form", null)
          this.state.set("store", null)
          this.updateArea()

          var form = new VisuProjectForm()
          this.state.set("form", form)
          this.state.set("store", form.store)
          this.addUIComponents(form.components
            .map(function(component) {
              return new UIComponent(component)
            }),
            new UILayout({
              area: container.area,
              width: function() { return this.area.getWidth() },
            })
          )
          this.modal.store.get("form").set(form)
        },
      }),
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.dispatcher.execute(new Event("close"))
      if (!Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
        return
      }

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
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETrackControl}
  update = function() { 
    this.dispatcher.update()
    return this
  }
}