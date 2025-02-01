
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
          "channels":[
            {
              "name":"shader 1",
              "events":[
              ]
            },
            {
              "name":"shader 2",
              "events":[
              ]
            },
            {
              "name":"shroom 1",
              "events":[
              ]
            },
            {
              "name":"shroom 2",
              "events":[
              ]
            },
            {
              "name":"shroom 3",
              "events":[
              ]
            },
            {
              "name":"shroom 4",
              "events":[
              ]
            },
            {
              "name":"glitch",
              "events":[
              ]
            },
            {
              "name":"grid columns",
              "events":[
                {
                  "callable":"brush_grid_old_channel",
                  "timestamp":0.0,
                  "data":{
                    "grid-channel_secondary-color":"#2C7C80",
                    "grid-channel_secondary-color-speed":1.0,
                    "grid-channel_transform-amount":{
                      "factor":999.0,
                      "target":1.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_transform-primary-alpha":{
                      "factor":999.0,
                      "target":0.59999999999999998,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_transform-primary-size":{
                      "factor":999.0,
                      "target":5.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_transform-secondary-alpha":{
                      "factor":999.0,
                      "target":0.59999999999999998,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_transform-secondary-size":{
                      "factor":999.0,
                      "target":5.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_transform-z":{
                      "factor":9999.0,
                      "target":2088.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-channel_use-primary-color":1.0,
                    "grid-channel_use-secondary-color":1.0,
                    "grid-channel_use-transform-amount":1.0,
                    "grid-channel_use-transform-primary-alpha":1.0,
                    "grid-channel_use-transform-primary-size":1.0,
                    "grid-channel_use-transform-secondary-alpha":1.0,
                    "grid-channel_use-transform-secondary-size":1.0,
                    "grid-channel_use-transform-z":1.0,
                    "icon":{
                      "blend":"#2C7C80",
                      "name":"texture_visu_editor_icon_event_grid_channel"
                    },
                    "grid-channel_primary-color":"#2C7C80",
                    "grid-channel_primary-color-speed":1.0
                  }
                }
              ]
            },
            {
              "name":"grid rows",
              "events":[
                {
                  "callable":"brush_grid_old_separator",
                  "timestamp":0.0,
                  "data":{
                    "grid-separator_primary-color":"#FFB2F4",
                    "grid-separator_primary-color-speed":1.0,
                    "grid-separator_secondary-color":"#FFB2F4",
                    "grid-separator_secondary-color-speed":1.0,
                    "grid-separator_transform-amount":{
                      "factor":999.0,
                      "target":2.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_transform-primary-alpha":{
                      "factor":999.0,
                      "target":0.59999999999999998,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_transform-primary-size":{
                      "factor":999.0,
                      "target":16.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_transform-secondary-alpha":{
                      "factor":999.0,
                      "target":0.59999999999999998,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_transform-secondary-size":{
                      "factor":999.0,
                      "target":16.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_transform-z":{
                      "factor":9999.0,
                      "target":2090.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-separator_use-primary-color":1.0,
                    "grid-separator_use-secondary-color":1.0,
                    "grid-separator_use-transform-amount":1.0,
                    "grid-separator_use-transform-primary-alpha":1.0,
                    "grid-separator_use-transform-primary-size":1.0,
                    "grid-separator_use-transform-secondary-alpha":1.0,
                    "grid-separator_use-transform-secondary-size":1.0,
                    "icon":{
                      "blend":"#FFB2F4",
                      "name":"texture_visu_editor_icon_event_grid_separator"
                    },
                    "grid-separator_use-transform-z":1.0
                  }
                }
              ]
            },
            {
              "name":"grid config",
              "events":[
                {
                  "callable":"brush_grid_old_config",
                  "timestamp":0.0,
                  "data":{
                    "grid-config_border-bottom-alpha":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_border-bottom-color":"#FFB2F4",
                    "grid-config_border-bottom-color-speed":1.0,
                    "grid-config_border-bottom-size":{
                      "factor":999.0,
                      "target":20.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_border-horizontal-alpha":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_border-horizontal-color":"#FFB2F4",
                    "grid-config_border-horizontal-color-speed":1.0,
                    "grid-config_border-horizontal-height":{
                      "factor":999.0,
                      "target":3.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_border-horizontal-size":{
                      "factor":999.0,
                      "target":20.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_border-horizontal-width":{
                      "factor":999.0,
                      "target":2.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_clear-bullets":true,
                    "grid-config_clear-coins":true,
                    "grid-config_clear-color":"#0000FF",
                    "grid-config_clear-frame":1.0,
                    "grid-config_clear-frame-alpha":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-config_clear-player":true,
                    "grid-config_gamemode":"BULLETHELL",
                    "grid-config_render-grid":1.0,
                    "grid-config_render-grid-elements":true,
                    "grid-config_speed":{
                      "factor":999.0,
                      "target":6.25,
                      "increase":0.0,
                      "value":4.166666666666667
                    },
                    "grid-config_use-border-bottom-alpha":true,
                    "grid-config_use-border-bottom-color":true,
                    "icon":{
                      "blend":"#FFB2F4",
                      "name":"texture_visu_editor_icon_event_grid_config"
                    },
                    "grid-config_use-border-bottom-size":true,
                    "grid-config_use-border-horizontal-alpha":true,
                    "grid-config_use-border-horizontal-color":true,
                    "grid-config_use-border-horizontal-height":true,
                    "grid-config_use-border-horizontal-size":true,
                    "grid-config_use-border-horizontal-width":true,
                    "grid-config_use-clear-color":true,
                    "grid-config_use-clear-frame":true,
                    "grid-config_use-clear-frame-alpha":true,
                    "grid-config_use-gamemode":true,
                    "grid-config_use-render-grid":1.0,
                    "grid-config_use-render-grid-elements":true,
                    "grid-config_use-speed":true
                  }
                }
              ]
            },
            {
              "name":"view background",
              "events":[
                {
                  "callable":"brush_view_old_wallpaper",
                  "timestamp":0.0,
                  "data":{
                    "view-wallpaper_angle":0.0,
                    "view-wallpaper_angle-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_blend-equation":"ADD",
                    "view-wallpaper_blend-mode-source":"SRC_ALPHA",
                    "view-wallpaper_blend-mode-target":"INV_SRC_ALPHA",
                    "view-wallpaper_clear-color":1.0,
                    "view-wallpaper_clear-texture":true,
                    "view-wallpaper_color":"#10101A",
                    "view-wallpaper_fade-in-duration":0.016,
                    "view-wallpaper_fade-out-duration":0.016,
                    "view-wallpaper_speed":0.0,
                    "view-wallpaper_speed-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_texture":{
                      "blend":"#FFFFFF",
                      "name":"texture_empty",
                      "randomFrame":false,
                      "angle":0.0,
                      "frame":0.0,
                      "speed":30.0,
                      "alpha":1.0,
                      "animate":false,
                      "scaleX":0.23225806451612904,
                      "scaleY":0.23225806451612904
                    },
                    "view-wallpaper_texture-blend":"#BC2EFC",
                    "view-wallpaper_type":"BACKGROUND",
                    "view-wallpaper_use-angle-transform":false,
                    "view-wallpaper_use-color":true,
                    "view-wallpaper_use-speed-transform":false,
                    "view-wallpaper_use-texture":0.0,
                    "view-wallpaper_use-texture-blend":0.0,
                    "icon":{
                      "blend":"#FF0000",
                      "name":"texture_visu_editor_icon_event_view_background"
                    },
                    "view-wallpaper_use-xScale-transform":false,
                    "view-wallpaper_use-yScale-transform":false,
                    "view-wallpaper_xScale":1.0,
                    "view-wallpaper_xScale-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_yScale":1.0,
                    "view-wallpaper_yScale-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    }
                  }
                }
              ]
            },
            {
              "name":"view foreground",
              "events":[
                {
                  "callable":"brush_view_old_wallpaper",
                  "timestamp":0.0,
                  "data":{
                    "view-wallpaper_angle":0.0,
                    "view-wallpaper_angle-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_blend-equation":"ADD",
                    "view-wallpaper_blend-mode-source":"SRC_ALPHA",
                    "view-wallpaper_blend-mode-target":"ONE",
                    "view-wallpaper_clear-color":1.0,
                    "view-wallpaper_clear-texture":true,
                    "view-wallpaper_color":"#00FFF7",
                    "view-wallpaper_fade-in-duration":0.016,
                    "view-wallpaper_fade-out-duration":0.016,
                    "view-wallpaper_speed":0.0,
                    "view-wallpaper_speed-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_texture":{
                      "blend":"#FFFFFF",
                      "name":"texture_empty",
                      "randomFrame":false,
                      "angle":0.0,
                      "frame":0.0,
                      "alpha":1.0,
                      "speed":30.0,
                      "animate":false,
                      "scaleX":0.23225806451612904,
                      "scaleY":0.23225806451612904
                    },
                    "view-wallpaper_texture-blend":"#BC2EFC",
                    "view-wallpaper_type":"FOREGROUND",
                    "view-wallpaper_use-angle-transform":false,
                    "view-wallpaper_use-color":0.0,
                    "view-wallpaper_use-speed-transform":false,
                    "view-wallpaper_use-texture":0.0,
                    "view-wallpaper_use-texture-blend":0.0,
                    "icon":{
                      "blend":"#FF0000",
                      "name":"texture_visu_editor_icon_event_view_foreground"
                    },
                    "view-wallpaper_use-xScale-transform":false,
                    "view-wallpaper_use-yScale-transform":false,
                    "view-wallpaper_xScale":1.0,
                    "view-wallpaper_xScale-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-wallpaper_yScale":1.0,
                    "view-wallpaper_yScale-transform":{
                      "factor":1.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    }
                  }
                }
              ]
            },
            {
              "name":"view camera",
              "events":[
                {
                  "callable":"brush_view_old_camera",
                  "timestamp":0.0,
                  "data":{
                    "view-config_follow-margin-x":0.5,
                    "view-config_follow-margin-y":0.5,
                    "view-config_follow-smooth":1.0,
                    "view-config_lock-target-x":false,
                    "view-config_lock-target-y":false,
                    "view-config_movement-angle":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":90.0
                    },
                    "view-config_movement-enable":false,
                    "view-config_movement-speed":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-angle":{
                      "factor":9999.0,
                      "target":270.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-pitch":{
                      "factor":9999.0,
                      "target":-45.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-x":{
                      "factor":9999.0,
                      "target":4096.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-y":{
                      "factor":9999.0,
                      "target":7296.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-z":{
                      "factor":9999.0,
                      "target":7000.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_transform-zoom":{
                      "factor":9999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_use-follow-properties":true,
                    "view-config_use-lock-target-x":true,
                    "view-config_use-lock-target-y":true,
                    "view-config_use-movement":true,
                    "view-config_use-transform-angle":1.0,
                    "view-config_use-transform-pitch":1.0,
                    "view-config_use-transform-x":1.0,
                    "view-config_use-transform-y":1.0,
                    "view-config_use-transform-z":1.0,
                    "view-config_use-transform-zoom":1.0,
                    "icon":{
                      "blend":"#00FF01",
                      "name":"texture_visu_editor_icon_event_view_camera"
                    }
                  }
                }
              ]
            },
            {
              "name":"view config",
              "events":[
                {
                  "callable":"brush_view_old_config",
                  "timestamp":0.0,
                  "data":{
                    "icon":{
                      "blend":"#00FF00",
                      "name":"texture_visu_editor_icon_event_view_config"
                    },
                    "view-config_use-render-HUD":true,
                    "view-config_use-render-particles":true,
                    "view-config_use-render-video":1.0,
                    "view-config_render-HUD":false,
                    "view-config_render-particles":true,
                    "view-config_use-transform-particles-z":true,
                    "view-config_render-video":true,
                    "view-config_transform-particles-z":{
                      "factor":9999.0,
                      "target":2094.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "view-config_clear-lyrics":true
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
                    "shader-config_clear-frame":true,
                    "shader-config_clear-shaders":true,
                    "shader-config_render-grid-shaders":1.0,
                    "shader-config_transform-clear-frame-alpha":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shader-config_use-background-grid-shaders":1.0,
                    "shader-config_use-clear-color":true,
                    "shader-config_use-clear-frame":1.0,
                    "shader-config_use-render-grid-shaders":1.0,
                    "shader-config_use-transform-clear-frame-alpha":true,
                    "icon":{
                      "blend":"#00FF00",
                      "name":"texture_visu_editor_icon_event_shader_config"
                    },
                    "shader-config_background-grid-shaders":1.0,
                    "shader-config_clear-bkg-shaders":true,
                    "shader-config_clear-color":"#000000"
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
                    "icon":{
                      "blend":"#FF0000",
                      "name":"texture_visu_editor_icon_event_shader_overlay"
                    },
                    "shader-overlay_render-support-grid":false,
                    "shader-overlay_transform-support-grid-alpha":{
                      "factor":999.0,
                      "target":0.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shader-overlay_transform-support-grid-treshold":{
                      "factor":999.0,
                      "target":1.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shader-overlay_use-render-support-grid":1.0,
                    "shader-overlay_use-transform-support-grid-alpha":true,
                    "shader-overlay_use-transform-support-grid-treshold":true
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
                    "shroom-config_render-coins":true,
                    "shroom-config_render-shrooms":1.0,
                    "shroom-config_transform-bullet-z":{
                      "factor":9999.0,
                      "target":2098.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shroom-config_transform-coin-z":{
                      "factor":9999.0,
                      "target":2094.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shroom-config_transform-shroom-z":{
                      "factor":9999.0,
                      "target":2096.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "shroom-config_use-render-bullets":true,
                    "shroom-config_use-render-coins":true,
                    "shroom-config_use-render-shrooms":1.0,
                    "shroom-config_use-transform-bullet-z":true,
                    "shroom-config_use-transform-coin-z":true,
                    "shroom-config_use-transform-shroom-z":true,
                    "icon":{
                      "blend":"#00FF00",
                      "name":"texture_visu_editor_icon_event_shroom_config"
                    },
                    "shroom-config_clear-shrooms":true,
                    "shroom-config_render-bullets":true
                  }
                }
              ]
            },
            {
              "name":"player",
              "events":[
                {
                  "callable":"brush_grid_old_player",
                  "timestamp":0.0,
                  "data":{
                    "grid-player_bullet-hell":{
                      "x":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      },
                      "y":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      },
                      "guns":[
                      ]
                    },
                    "grid-player_margin-bottom":0.35999999999999999,
                    "grid-player_margin-left":3.0,
                    "grid-player_margin-right":2.7360000000000002,
                    "grid-player_margin-top":2.0880000000000001,
                    "grid-player_mask":{
                      "x":20.0,
                      "height":106.0,
                      "width":126.0,
                      "y":20.0
                    },
                    "grid-player_platformer":{
                      "x":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      },
                      "y":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      },
                      "jump":{
                        "size":0.0
                      }
                    },
                    "grid-player_racing":{
                      "throttle":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":0.5
                      },
                      "nitro":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      },
                      "wheel":{
                        "speedMax":0.0,
                        "acceleration":0.0,
                        "friction":9.0
                      }
                    },
                    "grid-player_reset-position":true,
                    "grid-player_stats":{
                      "force":{
                        "maxValue":250.0,
                        "value":0.0,
                        "minValue":0.0
                      },
                      "bomb":{
                        "maxValue":10.0,
                        "value":5.0,
                        "minValue":0.0
                      },
                      "life":{
                        "maxValue":10.0,
                        "value":4.0,
                        "minValue":0.0
                      },
                      "point":{
                        "maxValue":9999999.0,
                        "value":0.0,
                        "minValue":0.0
                      }
                    },
                    "grid-player_texture":{
                      "blend":"#FFFFFF",
                      "name":"texture_empty",
                      "randomFrame":false,
                      "angle":0.0,
                      "frame":0.0,
                      "speed":10.0,
                      "alpha":1.0,
                      "animate":1.0,
                      "scaleX":2.0,
                      "scaleY":2.0
                    },
                    "grid-player_transform-player-z":{
                      "factor":9999.0,
                      "target":2100.0,
                      "increase":0.0,
                      "value":0.0
                    },
                    "grid-player_use-bullet-hell":1.0,
                    "grid-player_use-margin":true,
                    "grid-player_use-mask":true,
                    "grid-player_use-platformer":1.0,
                    "grid-player_use-racing":1.0,
                    "grid-player_use-reset-position":true,
                    "grid-player_use-stats":true,
                    "grid-player_use-transform-player-z":1.0,
                    "icon":{
                      "blend":"#FFFF00",
                      "name":"texture_visu_editor_icon_event_grid_player"
                    }
                  }
                }
              ]
            },
            {
              "name":"particle",
              "events":[
              ]
            },
            {
              "name":"subtitle",
              "events":[
              ]
            }
          ]
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