
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
    "use-shader": {
      type: Boolean,
      value: Struct.getDefault(json, "use-shader", false),
    },
    "shader": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "shader", ""),
    },
    "use-shroom": {
      type: Boolean,
      value: Struct.getDefault(json, "use-shroom", false),
    },
    "shroom": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "shroom", ""),
    },
    "use-bullet": {
      type: Boolean,
      value: Struct.getDefault(json, "use-bullet", false),
    },
    "bullet": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "bullet", ""),
    },
    "use-lyrics": {
      type: Boolean,
      value: Struct.getDefault(json, "use-lyrics", false),
    },
    "lyrics": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "lyrics", ""),
    },
    "use-particle": {
      type: Boolean,
      value: Struct.getDefault(json, "use-particle", false),
    },
    "particle": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "particle", ""),
    },
    "use-texture": {
      type: Boolean,
      value: Struct.getDefault(json, "use-texture", false),
    },
    "texture": {
      type: Optional.of(String),
      value: Struct.getDefault(json, "texture", ""),
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
      name: "shader",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-shader" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Shaders",
          enable: { key: "use-shader" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("shader")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-shader"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-shader"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("shader")
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
      name: "lyrics",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-lyrics" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Lyrics",
          enable: { key: "use-lyrics" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("lyrics")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-lyrics"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-lyrics"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("lyrics")
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
      name: "texture",  
      template: VEComponents.get("text-field-button-checkbox"),
      layout: VELayouts.get("text-field-button-checkbox"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        checkbox: { 
          store: { key: "use-texture" },
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          
        },
        label: { 
          text: "Textures",
          enable: { key: "use-texture" },
        },
        field: { 
          read_only: true,
          updateCustom: function() {
            var text = this.context.state.get("store").getValue("texture")
            if (Core.isType(text, String)) {
              this.textField.setText(FileUtil.getFilenameFromPath(text))
            } else {
              this.textField.setText("")
            }
          },
          enable: { key: "use-texture"},
        },
        button: { 
          label: { text: "Open" },
          enable: { key: "use-texture"},
          callback: function() {
            var path = FileUtil.getPathToOpenWithDialog({
              description: "JSON file",
              extension: "json",
            })
            if (!FileUtil.fileExists(path)) {
              return
            }

            this.context.state.get("store")
              .get("texture")
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

    if (this.store.getValue("use-shader")
      && Core.isType(this.store.getValue("shader"), String)) {
      Struct.set(json, "shader", this.store.getValue("shader"))
    }

    if (this.store.getValue("use-shroom")
      && Core.isType(this.store.getValue("shroom"), String)) {
      Struct.set(json, "shroom", this.store.getValue("shroom"))
    }

    if (this.store.getValue("use-bullet")
      && Core.isType(this.store.getValue("bullet"), String)) {
      Struct.set(json, "bullet", this.store.getValue("bullet"))
    }

    if (this.store.getValue("use-lyrics")
      && Core.isType(this.store.getValue("lyrics"), String)) {
      Struct.set(json, "lyrics", this.store.getValue("lyrics"))
    }

    if (this.store.getValue("use-particle")
      && Core.isType(this.store.getValue("particle"), String)) {
      Struct.set(json, "particle", this.store.getValue("particle"))
    }

    if (this.store.getValue("use-texture")
      && Core.isType(this.store.getValue("texture"), String)) {
      Struct.set(json, "texture", this.store.getValue("texture"))
    }

    return json
  }

  ///@param {String} manifestPath
  ///@return {VisuNewProjectForm}
  save = function(manifestPath) {
    var json = this.serialize()
    var controller = Beans.get(BeanVisuController)

    var path = Assert.isType(FileUtil.getDirectoryFromPath(manifestPath), String)
    var manifest = {
      "model": "io.alkapivo.visu.controller.VisuTrack",
      "version": "1",
      "data": {  
        "bpm": Beans.get(BeanVisuEditor).store.getValue("bpm"),
        "bpm-sub": Beans.get(BeanVisuEditor).store.getValue("bpm-sub"),
        "bullet": "template/bullet.json",
        "editor": [],
        "lyrics": "template/lyrics.json",
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
      "lyrics": {
        "model": "Collection<io.alkapivo.visu.service.lyrics.LyricsTemplate>",
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
          "channels":[
            {
              "name":"shader",
              "events":[
                {
                  "callable":"brush_shader_clear",
                  "timestamp":0.0,
                  "data":{
                    "shader-clear_pipeline":"All",
                    "shader-clear_use-clear-all-shaders":1.0,
                    "shader-clear_use-clear-amount":0.0,
                    "shader-clear_clear-amount":1.0,
                    "shader-clear_use-fade-out":false,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_shader_clear",
                      "blend":"#FF0000"
                    },
                    "shader-clear_fade-out":0.0
                  }
                }
              ]
            },
            {
              "name":"shroom",
              "events":[
                {
                  "callable":"brush_shroom_clear",
                  "timestamp":0.0,
                  "data":{
                    "shroom-clear_use-clear-all-shrooms":1.0,
                    "shroom-clear_use-clear-amount":0.0,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_shroom_clear",
                      "blend":"#FF0000"
                    },
                    "shroom-clear_clear-amount":1.0
                  }
                }
              ]
            },
            {
              "name":"shader config",
              "events":[
                {
                  "callable":"brush_shader_config",
                  "timestamp":0.0,
                  "data":{
                    "shader-config_use-render-grid-shaders":1.0,
                    "shader-config_render-grid-shaders":1.0,
                    "shader-config_use-background-grid-shaders":1.0,
                    "shader-config_background-grid-shaders":1.0,
                    "shader-config_use-clear-frame":1.0,
                    "shader-config_clear-frame":true,
                    "shader-config_use-clear-color":true,
                    "shader-config_clear-color":"#FFFFFF",
                    "shader-config_use-transform-clear-frame-alpha":true,
                    "shader-config_transform-clear-frame-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":0.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "icon":{
                      "name":"texture_visu_editor_icon_event_shader_config",
                      "blend":"#FFFF00"
                    }
                  }
                }
              ]
            },
            {
              "name":"shroom config",
              "events":[
                {
                  "callable":"brush_shroom_config",
                  "timestamp":0.0,
                  "data":{
                    "shroom-config_use-render-bullets":true,
                    "shroom-config_render-bullets":true,
                    "shroom-config_use-transform-bullet-z":true,
                    "shroom-config_transform-bullet-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":2048.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "shroom-config_use-render-shrooms":1.0,
                    "shroom-config_render-shrooms":1.0,
                    "shroom-config_use-transform-shroom-z":true,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_shroom_config",
                      "blend":"#FFFF00"
                    },
                    "shroom-config_transform-shroom-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":2049.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    }
                  }
                }
              ]
            },
            {
              "name":"grid channel",
              "events":[
                {
                  "callable":"brush_grid_channel",
                  "timestamp":0.0,
                  "data":{
                    "grid-channel_transform-amount":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-channel_use-transform-secondary-size":1.0,
                    "grid-channel_use-transform-z":1.0,
                    "grid-channel_transform-secondary-size":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":8.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-channel_transform-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-channel_use-primary-color":1.0,
                    "grid-channel_primary-color":"#0045B1",
                    "grid-channel_primary-color-speed":0.01,
                    "grid-channel_use-transform-primary-alpha":1.0,
                    "grid-channel_transform-primary-alpha":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-channel_use-transform-primary-size":1.0,
                    "grid-channel_transform-primary-size":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":8.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-channel_use-secondary-color":1.0,
                    "grid-channel_secondary-color":"#C93B9C",
                    "grid-channel_secondary-color-speed":0.01,
                    "grid-channel_use-transform-secondary-alpha":1.0,
                    "grid-channel_use-transform-amount":1.0,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_grid_channel",
                      "blend":"#FFFF00"
                    },
                    "grid-channel_transform-secondary-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":0.80000000000000004,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    }
                  }
                }
              ]
            },
            {
              "name":"grid separator",
              "events":[
                {
                  "callable":"brush_grid_separator",
                  "timestamp":0.0,
                  "data":{
                    "grid-separator_secondary-color":"#C93B9C",
                    "grid-separator_secondary-color-speed":0.01,
                    "grid-separator_use-transform-secondary-alpha":1.0,
                    "grid-separator_transform-secondary-alpha":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":0.80000000000000004,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-separator_use-transform-secondary-size":1.0,
                    "grid-separator_use-transform-amount":1.0,
                    "grid-separator_transform-secondary-size":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":8.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-separator_transform-amount":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":2.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-separator_use-transform-z":1.0,
                    "grid-separator_transform-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-separator_use-primary-color":1.0,
                    "grid-separator_primary-color":"#0045B1",
                    "grid-separator_primary-color-speed":0.01,
                    "grid-separator_use-transform-primary-alpha":1.0,
                    "grid-separator_transform-primary-alpha":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-separator_use-transform-primary-size":1.0,
                    "grid-separator_transform-primary-size":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":8.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "icon":{
                      "name":"texture_visu_editor_icon_event_grid_separator",
                      "blend":"#FFFF00"
                    },
                    "grid-separator_use-secondary-color":1.0
                  }
                }
              ]
            },
            {
              "name":"grid config",
              "events":[
                {
                  "callable":"brush_grid_config",
                  "timestamp":0.0,
                  "data":{
                    "grid-config_speed":{
                      "value":4.166666666666667,
                      "factor":0.5,
                      "overrideValue":false,
                      "target":10.0,
                      "increase":0.0,
                      "startValue":4.166666666666667,
                      "finished":false
                    },
                    "grid-config_use-clear-frame":true,
                    "grid-config_clear-frame":1.0,
                    "grid-config_use-clear-color":true,
                    "grid-config_clear-color":"#FFFFFF",
                    "grid-config_use-clear-frame-alpha":true,
                    "grid-config_clear-frame-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":0.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-config_use-gamemode":true,
                    "grid-config_gamemode":"BULLETHELL",
                    "grid-config_use-border-bottom-color":true,
                    "grid-config_border-bottom-color":"#FF0000ED",
                    "grid-config_border-bottom-color-speed":1.0,
                    "grid-config_use-border-bottom-alpha":true,
                    "grid-config_border-bottom-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "icon":{
                      "name":"texture_visu_editor_icon_event_grid_config",
                      "blend":"#FFFF00"
                    },
                    "grid-config_use-border-bottom-size":true,
                    "grid-config_border-bottom-size":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":32.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-config_use-border-horizontal-color":true,
                    "grid-config_border-horizontal-color":"#FF0000ED",
                    "grid-config_border-horizontal-color-speed":1.0,
                    "grid-config_use-border-horizontal-alpha":true,
                    "grid-config_border-horizontal-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":1.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-config_use-border-horizontal-size":true,
                    "grid-config_border-horizontal-size":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":32.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "grid-config_use-render-grid":1.0,
                    "grid-config_render-grid":1.0,
                    "grid-config_use-render-grid-elements":true,
                    "grid-config_render-grid-elements":true,
                    "grid-config_use-speed":true
                  }
                }
              ]
            },
            {
              "name":"shader overlay",
              "events":[
                {
                  "callable":"brush_shader_overlay",
                  "timestamp":0.0,
                  "data":{
                    "shader-overlay_use-transform-support-grid-alpha":true,
                    "shader-overlay_transform-support-grid-alpha":{
                      "value":0.0,
                      "factor":999.0,
                      "overrideValue":false,
                      "target":0.5,
                      "increase":1.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "shader-overlay_use-render-support-grid":1.0,
                    "shader-overlay_render-support-grid":1.0,
                    "shader-overlay_use-transform-support-grid-treshold":true,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_shader_overlay",
                      "blend":"#FFFF00"
                    },
                    "shader-overlay_transform-support-grid-treshold":{
                      "value":0.0,
                      "factor":0.01,
                      "overrideValue":false,
                      "target":3.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    }
                  }
                }
              ]
            },
            {
              "name":"view background",
              "events":[
                {
                  "callable":"brush_view_wallpaper",
                  "timestamp":0.0,
                  "data":{
                    "view-wallpaper_texture":{
                      "alpha":1.0,
                      "angle":0.0,
                      "scaleX":0.23225806451612904,
                      "animate":false,
                      "name":"texture_empty",
                      "scaleY":0.23225806451612904,
                      "speed":30.0,
                      "frame":0.0,
                      "blend":"#FFFFFF"
                    },
                    "view-wallpaper_use-texture-speed":0.0,
                    "view-wallpaper_texture-speed":1.0,
                    "view-wallpaper_use-texture-blend":0.0,
                    "view-wallpaper_texture-blend":"#BC2EFC",
                    "view-wallpaper_clear-texture":true,
                    "view-wallpaper_type":"Background",
                    "view-wallpaper_fade-in-duration":0.0,
                    "view-wallpaper_fade-out-duration":0.0,
                    "view-wallpaper_use-color":0.0,
                    "view-wallpaper_color":"#00FFF7",
                    "view-wallpaper_clear-color":1.0,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_view_background",
                      "blend":"#FFFF00"
                    },
                    "view-wallpaper_use-texture":0.0
                  }
                }
              ]
            },
            {
              "name":"view foreground",
              "events":[
                {
                  "callable":"brush_view_wallpaper",
                  "timestamp":0.0,
                  "data":{
                    "view-wallpaper_texture":{
                      "alpha":1.0,
                      "angle":0.0,
                      "scaleX":0.23225806451612904,
                      "animate":false,
                      "name":"texture_empty",
                      "scaleY":0.23225806451612904,
                      "speed":30.0,
                      "frame":0.0,
                      "blend":"#FFFFFF"
                    },
                    "view-wallpaper_use-texture-speed":0.0,
                    "view-wallpaper_texture-speed":1.0,
                    "view-wallpaper_use-texture-blend":0.0,
                    "view-wallpaper_texture-blend":"#BC2EFC",
                    "view-wallpaper_clear-texture":true,
                    "view-wallpaper_type":"Foreground",
                    "view-wallpaper_fade-in-duration":0.0,
                    "view-wallpaper_fade-out-duration":0.0,
                    "view-wallpaper_use-color":0.0,
                    "view-wallpaper_color":"#00FFF7",
                    "view-wallpaper_clear-color":1.0,
                    "icon":{
                      "name":"texture_visu_editor_icon_event_view_background",
                      "blend":"#FFFF00"
                    },
                    "view-wallpaper_use-texture":0.0
                  }
                }
              ]
            },
            {
              "name":"view camera",
              "events":[
                {
                  "callable":"brush_view_camera",
                  "timestamp":0.0,
                  "data":{
                    "view-config_lock-target-x":false,
                    "view-config_use-lock-target-y":true,
                    "view-config_lock-target-y":false,
                    "view-config_use-transform-x":1.0,
                    "view-config_transform-x":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":4096.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-transform-y":1.0,
                    "view-config_transform-y":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":5356.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-transform-z":1.0,
                    "view-config_transform-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":5000.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-transform-zoom":1.0,
                    "view-config_transform-zoom":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":0.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-transform-angle":1.0,
                    "view-config_transform-angle":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":270.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-transform-pitch":1.0,
                    "view-config_transform-pitch":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":-70.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "icon":{
                      "name":"texture_visu_editor_icon_event_view_camera",
                      "blend":"#FFFF01"
                    },
                    "view-config_use-lock-target-x":true
                  }
                }
              ]
            },
            {
              "name":"view config",
              "events":[
                {
                  "callable":"brush_view_config",
                  "timestamp":0.0,
                  "data":{
                    "view-config_bkt-factor":0.00050000000000000001,
                    "view-config_use-render-particles":true,
                    "view-config_render-particles":true,
                    "view-config_use-transform-particles-z":true,
                    "view-config_transform-particles-z":{
                      "value":0.0,
                      "factor":9999.0,
                      "overrideValue":false,
                      "target":1024.0,
                      "increase":0.0,
                      "startValue":0.0,
                      "finished":false
                    },
                    "view-config_use-render-video":1.0,
                    "view-config_render-video":1.0,
                    "view-config_bkt-trigger":false,
                    "view-config_bkt-use-config":true,
                    "view-config_bkt-config":"easy",
                    "icon":{
                      "name":"texture_visu_editor_icon_event_view_config",
                      "blend":"#FFFF00"
                    },
                    "view-config_bkt-use-factor":true
                  }
                }
              ]
            }
          ]
        }
      }
    })

    FileUtil.createDirectory($"{path}brush")
    FileUtil.createDirectory($"{path}template")
    FileUtil.createDirectory($"{path}texture")

    if (Struct.contains(json, "shader")) {
      templates.remove("shader")
      FileUtil.copyFile(json.shader, $"{path}{manifest.data.shader}")
    }
    if (Struct.contains(json, "shroom")) {
      templates.remove("shroom")
      FileUtil.copyFile(json.shroom, $"{path}{manifest.data.shroom}")
    }
    if (Struct.contains(json, "bullet")) {
      templates.remove("bullet")
      FileUtil.copyFile(json.bullet, $"{path}{manifest.data.bullet}")
    }
    if (Struct.contains(json, "lyrics")) {
      templates.remove("lyrics")
      FileUtil.copyFile(json.lyrics, $"{path}{manifest.data.lyrics}")
    }
    if (Struct.contains(json, "particle")) {
      templates.remove("particle")
      FileUtil.copyFile(json.particle, $"{path}{manifest.data.particle}")
    }
    if (Struct.contains(json, "texture")) {
      templates.remove("texture")
      var textures = JSON.parse(FileUtil.readFileSync(json.texture).getData()).data
      Struct.forEach(textures, function(config, name, acc) {
        var filename = String.replaceAll(config.file, "texture/", "")
        FileUtil.copyFile($"{acc.sourceDirectory}{filename}", $"{acc.targetDirectory}{filename}")
      }, {
        sourceDirectory: Assert.isType(FileUtil.getDirectoryFromPath(json.texture), String),
        targetDirectory: $"{path}texture/",
      })
      FileUtil.copyFile(json.texture, $"{path}{manifest.data.texture}")
    }

    var visuTrack = global.__VisuTrack
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


///@param {?Struct} [_config]
function VisuNewProjectModal(_config = null) constructor {

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
        height: function() { return 532 },
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
      }, Beans.get(BeanVisuController).uiService)
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function (container, key, uiService) {
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuController).uiService).clear()
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