
///@package io.alkapivo.visu.editor.ui.controller

///@param {Struct} [json]
function VisuNewProjectForm(json = null) constructor {
  var track = Beans.get(BeanVisuController).track

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
    "use-include-templates": {
      type: Boolean,
      value: Core.isType(track, VisuTrack),
    },
    "include-templates": {
      type: Boolean,
      value: Struct.getDefault(json, "include-templates", false),
    },
    "use-include-brushes": {
      type: Boolean,
      value: Core.isType(track, VisuTrack),
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
        label: { text: "Create new visu project" },
      },
    },
    {
      name: "project-name",
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
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
          backgroundColor: VETheme.color.side,
        },
        checkbox: { 
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
      name: "include-templates",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Include current templates",
          enable: { key: "use-include-templates"},
        },
        checkbox: { 
          store: { key: "include-templates" },
          enable: { key: "use-include-templates"},
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          //scaleToFillStretched: false,
        },
      },
    },
    {
      name: "include-brushes",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Include current brushes",
          enable: { key: "use-include-brushes"},
        },
        checkbox: {
          store: { key: "include-brushes" },
          enable: { key: "use-include-brushes"},
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          //scaleToFillStretched: false,
        },
      },
    },
    {
      name: "include-brushes_line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    },
    {
      name: "warning",
      template: VEComponents.get("property-bar"),
      layout: VELayouts.get("property-bar"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          height: function() { return 28 * 2 },
          margin: { top: 0, bottom: 0 },
        },
        label: { 
          text: "Visu project must be saved\nin an empty folder!!!",
          backgroundColor: VETheme.color.side,
          updateCustom: function() {
            if (!Optional.is(Struct.get(this, "flickeringTimer"))) {
              Struct.set(this, "flickeringTimer", new Timer(0.5, { loop: Infinity }))
            }
            
            if (this.flickeringTimer.update().finished) {
              var color = this.backgroundColor == ColorUtil.fromHex(VETheme.color.deny).toGMColor()
                ? ColorUtil.fromHex(VETheme.color.side).toGMColor()
                : ColorUtil.fromHex(VETheme.color.deny).toGMColor()
              this.backgroundColor = color
            }
          }
        },
        input: {
          backgroundColor: VETheme.color.side,
        },
        checkbox: {
          backgroundColor: VETheme.color.side,
        }
      },
    },
    {
      name: "warning_line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    },
    {
      name: "button_create",
      template: VEComponents.get("button"),
      layout: VELayouts.get("button"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        backgroundColor: VETheme.color.acceptShadow,
        backgroundMargin: { top: 1, bottom: 1, left: 5, right: 5 },
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
          
          var path = FileUtil.getPathToSaveWithDialog({ 
            description: "VISU file",
            filename: "manifest", 
            extension: "visu" 
          })

          if (!Core.isType(path, String) || String.isEmpty(path)) {
            return
          }

          try {
            this.context.state.get("form").save(path)
          } catch (exception) {
            Beans.get(BeanVisuController).send(new Event("spawn-popup", 
              { message: $"Cannot create project: {exception.message}" }))
            this.context.modal.send(new Event("close"))
            return
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
        backgroundMargin: { top: 1, bottom: 5, left: 5, right: 5 },
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
      includeTemplates: Assert.isType(this.store.getValue("use-include-templates"), Boolean) 
        && Assert.isType(this.store.getValue("include-templates"), Boolean), 
      includeBrushes: Assert.isType(this.store.getValue("use-include-brushes"), Boolean) 
        && Assert.isType(this.store.getValue("include-brushes"), Boolean),
    }

    if (this.store.getValue("use-file-video") 
      && Core.isType(this.store.getValue("file-video"), String)) {
      Struct.set(json, "video", this.store.getValue("file-video"))
    }

    return json
  }

  ///@param {String} manifestPath
  ///@return {VisuNewProjectForm}
  save = function(manifestPath) {
    Assert.isTrue(!FileUtil.fileExists(manifestPath), $"Visu project cannot be saved at location '{manifestPath}', because it already contains visu project.\nasd\ndef\  ghi\n---")

    var json = this.serialize()
    var controller = Beans.get(BeanVisuController)
    var path = Assert.isType(FileUtil.getDirectoryFromPath(manifestPath), String)
    var manifest = {
      "model": "io.alkapivo.visu.controller.VisuTrack",
      "version": "1",
      "data": {  
        "bpm": Beans.get(BeanVisuEditorController).store.getValue("bpm"),
        "bpm-count": Beans.get(BeanVisuEditorController).store.getValue("bpm-count"),
        "bpm-sub": Beans.get(BeanVisuEditorController).store.getValue("bpm-sub"),
        "bullet": "template/bullet.json",
        "coin": "template/coin.json",
        "editor": [],
        "subtitle": "template/subtitle.json",
        "particle": "template/particle.json",
        "shader": "template/shader.json",
        "shroom": "template/shroom.json",
        "sound": "sound.json",
        "texture": "texture/texture.json",
        "track": "track.json"
      }
    }

    var templates = new Map(String, any, {
      "bullet": {
        "model": "Collection<io.alkapivo.visu.service.bullet.BulletTemplate>",
        "version": "1",
        "data": {},
      },
      "coin": {
        "model": "Collection<io.alkapivo.visu.service.coin.CoinTemplate>",
        "version": "1",
        "data": {},
      },
      "subtitle": {
        "model": "Collection<io.alkapivo.visu.service.subtitle.SubtitleTemplate>",
        "version": "1",
        "data": {},
      },
      "particle": {
        "model": "Collection<io.alkapivo.core.service.particle.ParticleTemplate>",
        "version": "1",
        "data": {},
      },
      "shader": {
        "model": "Collection<io.alkapivo.core.service.shader.ShaderTemplate>",
        "version": "1",
        "data": {},
      },
      "shroom": {
        "model": "Collection<io.alkapivo.visu.service.shroom.ShroomTemplate>",
        "version": "1",
        "data": {},
      },
      "sound": {
        "model": "Collection<io.alkapivo.core.service.sound.SoundIntent>",
        "version": "1",
        "data": {
          "sound_external": {
            "file": FileUtil.getFilenameFromPath(json.audio)
          }
        }
      },
      "texture": {
        "model": "Collection<io.alkapivo.core.service.texture.TextureIntent>",
        "version": "1",
        "data": {},
      },
      "track": {
        "model":"io.alkapivo.core.service.track.Track",
        "version": "1",
        "data":{
          "name": json.name,
          "audio": "sound_external",
          "channels":[]
        }
      }
    })

    FileUtil.createDirectory($"{path}brush")
    FileUtil.createDirectory($"{path}template")
    FileUtil.createDirectory($"{path}texture")

    var visuTrack = controller.track
    if (Struct.get(json, "includeTemplates") && Core.isType(visuTrack, VisuTrack)) {
      templates.remove("shader")
      templates.remove("shroom")
      templates.remove("bullet")
      templates.remove("coin")
      templates.remove("subtitle")
      templates.remove("particle")
      templates.remove("texture")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.shader}"), $"{path}{manifest.data.shader}")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.shroom}"), $"{path}{manifest.data.shroom}")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.bullet}"), $"{path}{manifest.data.bullet}")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.coin}"), $"{path}{manifest.data.coin}")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.subtitle}"), $"{path}{manifest.data.subtitle}")
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.particle}"), $"{path}{manifest.data.particle}")
      var textures = JSON.parse(FileUtil.readFileSync(FileUtil.get($"{visuTrack.path}{visuTrack.texture}")).getData()).data
      Struct.forEach(textures, function(config, name, acc) {
        var filename = String.replaceAll(config.file, "texture/", "")
        FileUtil.copyFile($"{acc.sourceDirectory}{filename}", $"{acc.targetDirectory}{filename}")
      }, {
        sourceDirectory: Assert.isType(FileUtil.getDirectoryFromPath(FileUtil.get($"{visuTrack.path}{visuTrack.texture}")), String),
        targetDirectory: $"{path}texture/",
      })
      FileUtil.copyFile(FileUtil.get($"{visuTrack.path}{visuTrack.texture}"), $"{path}{manifest.data.texture}")
    }
    
    if (json.includeBrushes && Core.isType(visuTrack, VisuTrack)) {
      visuTrack.editor.forEach(function(brush, index, acc) {
        acc.manifest.data.editor = GMArray.add(acc.manifest.data.editor, brush)
        FileUtil.copyFile($"{acc.visuTrack.path}{brush}", $"{acc.path}{brush}")
      }, {
        visuTrack: visuTrack,
        manifest: manifest,
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


///@param {?Struct} [_config]
function VENewProjectModal(_config = null) constructor {

  ///@type {?Struct}
  config = Optional.is(_config) ? Assert.isType(_config, Struct) : null

  ///@type {Store}
  store = new Store({
    "form": {
      type: Optional.of(VisuNewProjectForm),
      value: null,
    },
  })

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "visu-new-project-modal",
        x: function() { return (GuiWidth() - this.width()) / 2 },
        y: function() { return this.context.y() + 24},
        width: function() { return 480 },
        height: function() { return 374 },
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
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
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
      this.dispatcher.execute(new Event("close"))

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