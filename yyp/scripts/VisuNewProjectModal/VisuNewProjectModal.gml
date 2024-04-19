
///@package io.alkapivo.visu.editor.ui

///@param {Struct} [json]
function VisuNewProjectForm(json = null) constructor {

  ///@type {Store}
  store = new Store({
    "project-name": {
      type: String,
      value: Struct.getDefault(json, "name", "New project"),
    },
    "file-audio": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "file-audio", ""),
    },
    "use-file-video": {
      type: Boolean,
      value: Struct.getDefault(json, "use-file-video", false),
    },
    "file-video": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "file-video", ""),
    },
    "use-bullet": {
      type: Boolean,
      value: Struct.getDefault(json, "use-bullet", false),
    },
    "bullet": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "bullet", ""),
    },
    "use-particle": {
      type: Boolean,
      value: Struct.getDefault(json, "use-particle", false),
    },
    "particle": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "particle", ""),
    },
    "use-shroom": {
      type: Boolean,
      value: Struct.getDefault(json, "use-shroom", false),
    },
    "shroom": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "shroom", ""),
    },
    "include-brushes": {
      type: Boolean,
      value: Struct.getDefault(json, "include-brushes", false),
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
        label: { text: "Create new project" },
      },
    },
    {
      name: "project-name",
      template: VEComponents.get("text-field-checkbox"),
      layout: VELayouts.get("text-field-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Name" },
        field: { store: { key: "project-name" } },
      },
    },
    {
      name: "file-audio",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Audio" },
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
          colorHoverOver: VETheme.color.accent,
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
      name: "file-video",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-file-video" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Video",
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
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("file-video")
              .set(path)
          },
          colorHoverOver: VETheme.color.accent,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            if (!this.enable.value) {
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
      name: "bullet",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-bullet" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Bullets",
          enable: { key: "use-bullet" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("bullet")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-bullet"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-bullet"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("bullet")
              .set(path)
          },
          colorHoverOver: VETheme.color.accent,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            if (!this.enable.value) {
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
      name: "particle",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-particle" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Particles",
          enable: { key: "use-particle" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("particle")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-particle"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-particle"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("particle")
              .set(path)
          },
          colorHoverOver: VETheme.color.accent,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            if (!this.enable.value) {
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
      name: "shroom",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-shroom" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Shrooms",
          enable: { key: "use-shroom" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("shroom")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-shroom"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-shroom"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("shroom")
              .set(path)
          },
          colorHoverOver: VETheme.color.accent,
          colorHoverOut: VETheme.color.accentShadow,
          onMouseHoverOver: function(event) {
            if (!this.enable.value) {
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
      name: "include-brushes",
      template: VEComponents.get("boolean-field"),
      layout: VELayouts.get("text-field-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Include brushes" },
        field: { 
          store: { key: "include-brushes" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          scaleToFillStretched: false,
        },
      },
    },
    {
      name: "warning",
      template: VEComponents.get("property-bar"),
      layout: VELayouts.get("property-bar"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Remember to create project in an empty folder!",
          updateCustom: function() {
            if (!Optional.is(Struct.get(this, "flickeringTimer"))) {
              Struct.set(this, "flickeringTimer", new Timer(0.5, { loop: Infinity }))
            }
            
            if (this.flickeringTimer.update().finished) {
              var color = this.backgroundColor == ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor()
                ? ColorUtil.fromHex(VETheme.color.denyShadow).toGMColor()
                : ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor()
              this.backgroundColor = color
            }
          }
        },
      },
    },
    {
      name: "button_create",
      template: VEComponents.get("button"),
      layout: VELayouts.get("button"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        backgroundColor: VETheme.color.acceptShadow,
        backgroundMargin: { top: 5, bottom: 5, left: 5, right: 5 },
        label: { text: "Create project" },
        colorHoverOver: VETheme.color.accept,
        colorHoverOut: VETheme.color.acceptShadow,
        onMouseHoverOver: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
        },
        onMouseHoverOut: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
        },
        onMouseReleasedLeft: function(event) {
          if (Core.isType(global.GMTF_DATA.active, gmtf)) {
            if (Core.isType(global.GMTF_DATA.active.uiItem, UIItem)) {
              global.GMTF_DATA.active.uiItem.update()
            }
            global.GMTF_DATA.active.unfocus()
          }
          
          var path = FileUtil.getPathToSaveWithDialog({ 
            description: "VISU file",
            filename: "manifest", 
            extension: "visu" 
          })

          if (!Optional.is(path)) {
            return
          }

          try {
            this.context.state.get("form").save(path)
          } catch (exception) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: $"Cannot create project: {exception.message}" }))
          }
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
        backgroundMargin: { top: 5, bottom: 5, left: 5, right: 5 },
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

  ///@return {Struct}
  serialize = function() {
    var json = {
      name: Assert.isType(this.store.getValue("project-name"), String),
      audio: Assert.isType(this.store.getValue("file-audio"), String),
      includeBrushes: Assert.isType(this.store.getValue("include-brushes"), Boolean), 
    }

    if (this.store.getValue("use-file-video") 
      && Core.isType(this.store.getValue("file-video"), String)) {
      Struct.set(json, "video", this.store.getValue("file-video"))
    }

    if (this.store.getValue("use-bullet")
      && Core.isType(this.store.getValue("bullet"), String)) {
      Struct.set(json, "bullet", this.store.getValue("bullet"))
    }

    if (this.store.getValue("use-particle")
      && Core.isType(this.store.getValue("particle"), String)) {
      Struct.set(json, "particle", this.store.getValue("particle"))
    }

    if (this.store.getValue("use-shroom")
      && Core.isType(this.store.getValue("shroom"), String)) {
      Struct.set(json, "shroom", this.store.getValue("shroom"))
    }

    return json
  }

  ///@param {String} manifestPath
  ///@return {VisuNewProjectForm}
  save = function(manifestPath) {
    var json = this.serialize()
    var controller = Beans.get(BeanVisuController)
    var fileService = controller.fileService

    var filename = Assert.isType(FileUtil.getFilenameFromPath(manifestPath), String)
    var path = Assert.isType(FileUtil.getDirectoryFromPath(manifestPath), String)
    var manifest = {
      "model": "io.alkapivo.visu.controller.VisuTrack",
      "data": {  
        "bpm": controller.editor.store.getValue("bpm"),
        "bpm-sub": controller.editor.store.getValue("bpm-sub"),
        "bullet": "bullet.json",
        "editor": [],
        "lyrics": "lyrics.json",
        "particle": "particle.json",
        "shader": "shader.json",
        "shroom": "shroom.json",
        "sound": "sound.json",
        "texture": "texture.json",
        "track": "track.json"
      }
    }

    var templates = new Map(String, any, {
      "bullet": {
        "model": "Collection<io.alkapivo.visu.service.bullet.BulletTemplate>",
        "data": {},
      },
      "lyrics": {
        "model": "Collection<io.alkapivo.visu.service.lyrics.LyricsTemplate>",
        "data": {},
      },
      "particle": {
        "model": "Collection<io.alkapivo.core.service.particle.ParticleTemplate>",
        "data": {},
      },
      "shader": {
        "model": "Collection<io.alkapivo.core.service.shader.ShaderTemplate>",
        "data": {},
      },
      "shroom": {
        "model": "Collection<io.alkapivo.visu.service.shroom.ShroomTemplate>",
        "data": {},
      },
      "sound": {
        "model": "Collection<io.alkapivo.core.service.sound.SoundIntent>",
        "data": {
          "sound_external": {
            "file": FileUtil.getFilenameFromPath(json.audio)
          }
        }
      },
      "texture": {
        "model": "Collection<io.alkapivo.core.service.texture.TextureIntent>",
        "data": {},
      },
      "track": {
        "model":"io.alkapivo.core.service.track.Track",
        "data":{
          "name": json.name,
          "audio": "sound_external",
          "channels": [
            {
              "name": "main",
              "events": []
            },
          ]
        }
      }
    })

    if (Struct.contains(json, "bullet")) {
      templates.remove("bullet")
      FileUtil.copyFile(json.bullet, $"{path}{manifest.data.bullet}")
    }
    if (Struct.contains(json, "particle")) {
      templates.remove("particle")
      FileUtil.copyFile(json.particle, $"{path}{manifest.data.particle}")
    }
    if (Struct.contains(json, "shroom")) {
      templates.remove("shroom")
      FileUtil.copyFile(json.shroom, $"{path}{manifest.data.shroom}")
    }

    var visuTrack = global.__VisuTrack
    if (json.includeBrushes && Core.isType(visuTrack, VisuTrack)) {
      visuTrack.editor.forEach(function(brush, index, acc) {
        FileUtil.copyFile($"{acc.visuTrack.path}{brush}", $"{acc.path}{brush}")
      }, {
        visuTrack: visuTrack,
        path: path,
      })
    }

    var audioFilename = FileUtil.getFilenameFromPath(json.audio)
    FileUtil.copyFile(json.audio, $"{path}{audioFilename}")

    if (Core.isType(Struct.get(json, "video"), String)) {
      Struct.set(manifest.data, "video", FileUtil
        .getFilenameFromPath(json.video))
      var videoFilename = FileUtil.getFilenameFromPath(json.video)
      FileUtil.copyFile(json.video, $"{path}{videoFilename}")
    }

    templates.forEach(function(template, key, acc) {
      var filename = Assert.isType(Struct.get(acc.manifest.data, key), String)
      FileUtil.writeFileSync(new File({
        path: $"{acc.path}{filename}" ,
        data: String.replaceAll(JSON.stringify(template, { pretty: true }), "\\", ""),
      }))
    }, {
      fs: fileService,
      manifest: manifest,
      path: path,
    })

    FileUtil.writeFileSync(new File({
      path: $"{path}manifest.visu" ,
      data: String.replaceAll(JSON.stringify(manifest, { pretty: true }), "\\", ""),
    }))

    Beans.get(BeanVisuController).send(new Event("spawn-popup", 
      { message: $"Project '{json.name}' created successfully at: '{path}'" }))

    return this
  }
}

///@param {VisuController} _controller
///@param {?Struct} [_config]
function VisuNewProjectModal(_controller, _config = null) constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {UIService}
  uiService = Assert.isType(this.controller.uiService, UIService)

  ///@type {?Struct}
  config = Optional.is(_config) ? Assert.isType(_config, Struct) : null

  ///@type {Store}
  store = new Store({
    "form": {
      type: Optional.of(VisuNewProjectForm),
      value: null,
    },
  })

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "visu-new-project-modal",
        x: function() { return (this.context.width() - this.width()) / 2 },
        y: function() { return (this.context.height() - this.height()) / 2 },
        width: function() { return 500 },
        height: function() { return 412 },
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
      "visu-new-project-modal": new UI({
        name: "visu-new-project-modal",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
        }),
        modal: modal,
        layout: layout,
        propagate: false,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable")),
        onInit: function() {
          var container = this
          this.collection = new UICollection(this, { layout: container.layout })
          this.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
          this.collection.components.clear() ///@todo replace with remove lambda
          this.state.set("form", null)
          this.state.set("store", null)
          this.updateArea()

          var form = new VisuNewProjectForm()
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
      this.containers = this.factoryContainers(event.data.layout)
      containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, this.uiService)
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function (container, key, uiService) {
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, this.uiService).clear()
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