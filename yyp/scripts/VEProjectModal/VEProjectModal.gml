///@package io.alkapivo.visu.editor.ui.controller

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

            this.context.state.get("store")
              .get("file-video")
              .set(FileUtil.fileExists(path) ? path : null)
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
      name: "button_apply",
      template: VEComponents.get("button"),
      layout: VELayouts.get("button"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        backgroundColor: VETheme.color.acceptShadow,
        backgroundMargin: { top: 5, bottom: 5, left: 5, right: 5 },
        label: { text: "Apply" },
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

  ///@return {VisuProjectForm}
  save = function() {
    var controller = Beans.get(BeanVisuController)
    var track = controller.trackService.track
    var visuTrack = controller.track
    if (!Core.isType(track, Track)
      || !Core.isType(visuTrack, VisuTrack)) {
      return
    }

    var path = $"{controller.track.path}"
    if (!FileUtil.directoryExists(path)) {
      return
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
    return new UILayout(
      {
        name: "visu-project-modal",
        x: function() { return (this.context.width() - this.width()) / 2 },
        y: function() { return (this.context.height() - this.height()) / 2 },
        width: function() { return 500 },
        height: function() { return 218 },
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
      this.containers.forEach(function (container, key, uiService) {
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