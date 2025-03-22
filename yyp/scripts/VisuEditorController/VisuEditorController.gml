///@package io.alkapivo.visu.editor

#macro BeanVisuEditorController "VisuEditorController"
function VisuEditorController() constructor {

  ///@type {UIService}
  uiService = new UIService(this)
  
  ///@type {VETitleBar}
  titleBar = new VETitleBar(this)

  ///@type {VEAccordion}
  accordion = new VEAccordion(this)

  ///@type {VETrackControl}
  trackControl = new VETrackControl(this)

  ///@type {VisuTimeline}
  timeline = new VETimeline(this)

  ///@type {VEBrushToolbar}
  brushToolbar = new VEBrushToolbar(this)

  ///@type {VESceneConfigPrevie}
  sceneConfigPreview = new VESceneConfigPreview(this)

  ///@type {VEStatusBar}
  statusBar = new VEStatusBar(this)

  ///@type {VEPopupQueue}
  popupQueue = new VEPopupQueue(this)

  ///@type {VENewProjectModal}
  newProjectModal = new VENewProjectModal()

  ///@type {VEProjectModal}
  projectModal = new VEProjectModal()

  ///@type {VisuModal}
  exitModal = new VisuModal({
    message: { text: "Changes you made may not be saved." },
    accept: {
      text: "Leave",
      callback: function() {
        game_end()
      }
    },
    deny: {
      text: "Cancel",
      callback: function() {
        this.context.modal.send(new Event("close"))
      }
    }
  })

  ///@type {Store}
  store = new Store({
    "bpm": {
      type: Number,
      value: Assert.isType(Visu.settings.getValue("visu.editor.bpm", 120), Number),
      passthrough: function(value) {
        return clamp(value, 1, 999)
      }
    },
    "bpm-count": {
      type: Number,
      value: Assert.isType(Visu.settings.getValue("visu.editor.bpm-count", 0), Number),
      passthrough: function(value) {
        return round(clamp(value, 0, 64))
      }
    },
    "bpm-sub": {
      type: Number,
      value: Assert.isType(Visu.settings.getValue("visu.editor.bpm-sub", 2), Number),
      passthrough: function(value) {
        return round(clamp(value, 1, 16))
      }
    },
    "tool": {
      type: String,
      value: ToolType.SELECT,
      passthrough: function(value) {
        return Core.isEnum(value, ToolType) ? value : this.value
      }
    },
    "snap": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.snap", true), Boolean),
    },
    "render-event": {
      type: Boolean,
      value: false,
    },
    "_render-event": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-event", false), Boolean)
    },
    "render-timeline": {
      type: Boolean,
      value: false,
    },
    "_render-timeline": {
      type: Boolean,
      value:Assert.isType(Visu.settings.getValue("visu.editor.render-timeline", false), Boolean)
    },
    "render-brush": {
      type: Boolean,
      value: false,
    },
    "_render-brush": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-brush", false), Boolean)
    },
    "render-trackControl": {
      type: Boolean,
      value: false,
    },
    "_render-trackControl": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-track-control", false), Boolean)
    },
    "render-sceneConfigPreview": {
      type: Boolean,
      value: false,
    },
    "_render-sceneConfigPreview": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-scene-config-preview", false), Boolean)
    },
    "new-channel-name": {
      type: String,
      value: "channel name",
    },
    "channel-settings-target": {
      type: String,
      value: "",
    },
    "channel-settings-name": {
      type: String,
      value: "",
    },
    "channel-settings-config": {
      type: String,
      value: "{}",
      serialize: function() {
        return JSON.parse(this.get())
      },
      validate: function(value) {
        Assert.isType(JSON.parse(value), Struct)
      },
    },
    "selected-event": {
      type: Optional.of(Struct),
      value: null,
    },
    "selected-events": {
      type: Map,
      value: new Map(String, Struct),
    },
    "timeline-zoom": {
      type: Number,
      value: Assert.isType(Visu.settings.getValue("visu.editor.timeline-zoom", 10), Number),
      passthrough: function(value) {
        return clamp(value, 5, 30)
      },
    },
  })

  ///@type {Struct}
  autosave = {
    value: Visu.settings.getValue("visu.editor.autosave", false),
    timer: new Timer(Core.getProperty("visu.editor.autosave.interval", 1) * 60, { loop: Infinity }),
    update: function() {
      var controller = Beans.get(BeanVisuController)
      var stateName = controller.fsm.getStateName()
      if (!this.value || stateName != "paused") {
        return
      }
      
      if (this.timer.update().finished) {
        this.save()
      }
    },
    save: function() {
      try {
        var controller = Beans.get(BeanVisuController)
        var path = $"{controller.track.path}manifest.visu"
        if (!FileUtil.fileExists(path)) {
          return
        }
  
        controller.track.saveProject(path)
        controller.send(new Event("spawn-popup", { 
          message: $"Project '{controller.trackService.track.name}' auto saved successfully at: '{path}'"
        }))
      } catch (exception) {
        controller.send(new Event("spawn-popup", { 
          message: $"Cannot save the project: {exception.message}"
        }))
        Logger.error(BeanVisuEditorController, $"Cannot auto save the project: {exception.message}")
      }
    }
  }

  updateServices = Core.getProperty("visu.editor.update-services", true)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      //this.store.get("render-event").set(this.store.getValue("_render-event"))
      //this.store.get("render-timeline").set(this.store.getValue("_render-timeline"))
      //this.store.get("render-brush").set(this.store.getValue("_render-brush"))
      //this.store.get("render-trackControl").set(this.store.getValue("_render-trackControl"))

      this.requestOpenUI = true
    },
    "close": function(event) {
      this.store.get("_render-event").set(this.store.getValue("render-event"))
      this.store.get("render-event").set(false)
      this.store.get("_render-timeline").set(this.store.getValue("render-timeline"))
      this.store.get("render-timeline").set(false)
      this.store.get("_render-brush").set(this.store.getValue("render-brush"))
      this.store.get("render-brush").set(false)
      this.store.get("_render-trackControl").set(this.store.getValue("render-trackControl"))
      this.store.get("render-trackControl").set(false)
      this.store.get("_render-sceneConfigPreview").set(this.store.getValue("render-sceneConfigPreview"))
      this.store.get("render-sceneConfigPreview").set(false)
      this.store.get("selected-event").set(null)
      this.store.getValue("selected-events").clear()

      return {
        "accordion": this.accordion.send(new Event("close")),
        "trackControl": this.trackControl.send(new Event("close")),
        "brushToolbar": this.brushToolbar.send(new Event("close")),
        "timeline": this.timeline.send(new Event("close")),
        "sceneConfigPreview": this.sceneConfigPreview.send(new Event("close"))
      }
    },
    "spawn-popup": function(event) {
      this.popupQueue.send(new Event("push", event.data))
    },
  }), {
    enableLogger: true,
    catchException: false,
  })

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  ///@private
  ///@type {Array<Struct>}
  services = new Array(Struct, GMArray.map([
    "titleBar",
    "statusBar",
    "accordion",
    "trackControl",
    "brushToolbar",
    "timeline",
    "sceneConfigPreview",
    "popupQueue",
    "exitModal",
    "newProjectModal",
    "projectModal",
    "autosave"
  ], function(name, index, editor) {
    Logger.debug(BeanVisuEditorController, $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(editor, name), Struct),
    }
  }, this))

  ///@type {?UILayout}
  layout = null

  ///@type {Boolean}
  renderUI = Assert.isType(Core.getProperty("visu.editor.renderUI", false), Boolean)

  ///@private
  ///@type {Boolean}
  uiInitialized = false

  ///@private
  ///@type {Boolean}
  requestOpenUI = false

  ///@private
  ///@return {Task}
  factoryInitUITask = function() {
    return new Task("open-editor-ui")
      .setTimeout(20.0)
      .setState({
        cooldown: new Timer(0., { loop: Infinity }),
        primary: new Queue(Struct, [
          {
            handler: this.titleBar,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "title-bar")
            }),
            callback: function(editor) { },
          },
          {
            handler: this.statusBar,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "status-bar")
            }),
            callback: function(editor) { },
          },
          {
            handler: this.trackControl,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "track-control")
            }),
            callback: function(editor) {
              editor.store.get("render-trackControl").set(editor.store.getValue("_render-trackControl"))
            },
          }
        ]),
        events: new Queue(Struct, [
          {
            handler: this.accordion,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "accordion")
            }),
            cooldown: 0.25,
            callback: function(editor) {
              editor.store.get("render-event").set(editor.store.getValue("_render-event"))
            },
          },
          {
            handler: this.brushToolbar,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "brush-toolbar")
            }),
            cooldown: 0.15,
            callback: function(editor) {
              editor.store.get("render-brush").set(editor.store.getValue("_render-brush"))
            },
          },
          {
            handler: this.timeline,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "timeline")
            }),
            cooldown: 0.25,
            callback: function(editor) {
              editor.store.get("render-timeline").set(editor.store.getValue("_render-timeline"))
            },
          },
          {
            handler: this.sceneConfigPreview,
            event: new Event("open").setData({ 
              layout: Struct.get(this.layout.nodes, "preview-editor")
            }),
            cooldown: 0.064,
            callback: function(editor) {
              editor.store.get("render-sceneConfigPreview").set(editor.store.getValue("_render-sceneConfigPreview"))
            },
          }
        ]),
      })
      .whenUpdate(function() {
        if (this.state.primary.size() > 0) {
          this.state.primary.forEach(function(entry, index, editor) {
            entry.callback(editor)
            entry.handler.send(entry.event)
          }, Beans.get(BeanVisuEditorController))
        }

        if (!this.state.cooldown.update().finished) {
          return
        }

        var entry = this.state.events.pop()
        if (!Optional.is(entry)) {
          this.fullfill()
          return
        }
        this.state.cooldown.duration = entry.cooldown
        entry.callback(Beans.get(BeanVisuEditorController))
        entry.handler.send(entry.event)
      })
  }

  ///@private
  ///@return {Task}
  factoryOpenUITask = function() {
    return new Task("open-editor-ui")
      .setTimeout(10.0)
      .setState(new Queue(Struct, [
        {
          handler: this.accordion,
          event: new Event("open").setData({ 
            layout: Struct.get(this.layout.nodes, "accordion")
          }),
        },
        {
          handler: this.trackControl,
          event: new Event("open").setData({ 
            layout: Struct.get(this.layout.nodes, "track-control")
          }),
        },
        {
          handler: this.brushToolbar,
          event: new Event("open").setData({ 
            layout: Struct.get(this.layout.nodes, "brush-toolbar")
          }),
        },
        {
          handler: this.timeline,
          event: new Event("open").setData({ 
            layout: Struct.get(this.layout.nodes, "timeline")
          }),
        },
        {
          handler: this.sceneConfigPreview,
          event: new Event("open").setData({ 
            layout: Struct.get(this.layout.nodes, "preview-editor")
          }),
        }
      ]))
      .whenUpdate(function() {
        var entry = this.state.pop()
        if (!Optional.is(entry)) {
          this.fullfill()
          return
        }

        var editor = Beans.get(BeanVisuEditorController)
        editor.store.get("render-event").set(editor.store.getValue("_render-event"))
        editor.store.get("render-timeline").set(editor.store.getValue("_render-timeline"))
        editor.store.get("render-brush").set(editor.store.getValue("_render-brush"))
        editor.store.get("render-trackControl").set(editor.store.getValue("_render-trackControl"))
        editor.store.get("render-sceneConfigPreview").set(editor.store.getValue("_render-sceneConfigPreview"))
        entry.handler.send(entry.event)
      })
  }

  ///@private
  ///@return {VisuEditorController}
  init = function() {
    this.store.get("bpm").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.bpm"))
    this.store.get("bpm-count").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.bpm-count"))
    this.store.get("bpm-sub").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.bpm-sub"))
    this.store.get("snap").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.snap"))
    this.store.get("render-event").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.render-event"))
    this.store.get("render-timeline").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.render-timeline"))
    this.store.get("render-trackControl").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.render-track-control"))
    this.store.get("render-sceneConfigPreview").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.render-scene-config-preview"))
    this.store.get("render-brush").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.render-brush"))
    this.store.get("timeline-zoom").addSubscriber(Visu.generateSettingsSubscriber("visu.editor.timeline-zoom"))
    
    this.layout = this.factoryLayout()

    if (this.renderUI) {
      this.renderUI = Beans.get(BeanVisuController).menu.containers.size() == 0
    }
    
    return this
  }

  ///@private
  ///@return {UILayout}
  factoryLayout = function() {
    return new UILayout({
      name: "visu-editor",
      width: function() { return GuiWidth() },
      height: function() { return GuiHeight() },
      x: function() { return 0 },
      y: function() { return 0 },
      nodes: {
        "title-bar": {
          name: "visu-editor.title-bar",
          height: function() { return 24 },
        },
        "accordion": {
          name: "visu-editor.accordion",
          minWidth: 1,
          maxWidth: 1,
          percentageWidth: 0.2,
          width: function() { return round(clamp(max(this.percentageWidth * this.context.width(), 
            this.minWidth), this.minWidth, this.maxWidth)) },
          height: function() { return Struct.get(this.context.nodes, "timeline").top()
            - Struct.get(this.context.nodes, "title-bar").bottom() },
          y: function() { return Struct.get(this.context.nodes, "title-bar").bottom() },
        },
        "preview-editor": {
          name: "visu-editor.preview-editor",
          width: function() { return this.context.width()
            - Struct.get(this.context.nodes, "accordion").width()
            - Struct.get(this.context.nodes, "brush-toolbar").width() },
          height: function() { return this.context.height()
            - Struct.get(this.context.nodes, "title-bar").height()
            - Struct.get(this.context.nodes, "timeline").height()
            - Struct.get(this.context.nodes, "status-bar").height() },
          x: function() { return this.context.nodes.accordion.right() },
          y: function() { return Struct.get(this.context.nodes, "title-bar").bottom() },
        },
        "preview-full": {
          name: "visu-editor.preview-full",
          width: function() { return GuiWidth() },
          height: function() { return GuiHeight() },
          x: function() { return 0 },
          y: function() { return 0 }
        },
        "preview": { },
        "track-control": {
          name: "visu-editor.track-control",
          percentageHeight: 1.0,
          width: function() { return Struct.get(this.context.nodes, "preview").width() },
          height: function() { return round(90 * this.percentageHeight) },
          x: function() { return this.context.nodes.preview.x() },
          y: function() { return this.context.nodes.preview.bottom()
            - this.height() },
        },
        "brush-toolbar": {
          name: "visu-editor.brush-toolbar",
          minWidth: 1,
          maxWidth: 1,
          percentageWidth: 0.2,
          width: function() { 
            return round(clamp(this.percentageWidth * this.context.width(), this.minWidth, this.maxWidth))
          },
          height: function() { return this.context.height()
            - Struct.get(this.context.nodes, "title-bar").height()
            - Struct.get(this.context.nodes, "status-bar").height() },
          x: function() { return this.context.x() + this.context.width() - this.width() },
          y: function() { return Struct.get(this.context.nodes, "title-bar").bottom() },
        },
        "timeline": {
          name: "visu-editor.timeline",
          minHeight: 1,
          maxHeight: 1,
          percentageHeight: 0.25,
          width: function() { return this.context.width()
            - Struct.get(this.context.nodes, "brush-toolbar").width() },
          height: function() { 
            return floor(clamp(this.percentageHeight * this.context.height(), this.minHeight, this.maxHeight))
          },
          y: function() { return this.context.height() - this.height()
            - Struct.get(this.context.nodes, "status-bar").height() },
        },
        "status-bar": {
          name: "visu-editor.status-bar",
          height: function() { return 28 },
          y: function() { return this.context.height() - this.height() },
        },
      },
    })
  }

  ///@private
  ///@return {VisuEditorController}
  updateLayout = function() {
    static updateAccordion = function(container, key, acc) {
      if (key == "_ve-accordion_accordion-items"
          || key == "_ve-accordion_accordion-options") {
        container.enable = acc.enable
      } else if (!acc.enable) {
        container.enable = false
      }

      if (!acc.updateTimer) {
        return
      }

      container.finishUpdateTimer()
    }

    var lerpFactor = 0.2
    var renderBrush = this.store.getValue("render-brush")
    var brushNode = Struct.get(this.layout.nodes, "brush-toolbar")
    var brushNodePreviousMaxWidth = brushNode.maxWidth
    brushNode.minWidth = floor(renderBrush 
      ? lerp(brushNode.minWidth, 288, lerpFactor)
      : lerp(brushNode.minWidth, 0, lerpFactor))
    brushNode.maxWidth = floor(renderBrush
      ? lerp(brushNode.maxWidth, round(GuiWidth() * 0.37), lerpFactor)
      : lerp(brushNode.maxWidth, 0, lerpFactor))
    this.brushToolbar.containers.forEach(function(container, key, acc) {
      container.enable = acc.enable
      if (!acc.updateTimer) {
        return
      }

      container.finishUpdateTimer()
    }, {
      enable: brushNode.maxWidth > 24,
      updateTimer: brushNodePreviousMaxWidth != brushNode.maxWidth
          && choose(false, false, true),
    })

    var renderTimeline = this.store.getValue("render-timeline")
    var timelineNode = Struct.get(this.layout.nodes, "timeline")
    var timelineNodePreviousMaxHeight = timelineNode.maxHeight
    timelineNode.minHeight = floor(renderTimeline
      ? lerp(timelineNode.minHeight, 96, lerpFactor)
      : lerp(timelineNode.minHeight, 0, lerpFactor))
    timelineNode.maxHeight = floor(renderTimeline
      ? lerp(timelineNode.maxHeight, round(GuiHeight() * 0.58), lerpFactor)
      : lerp(timelineNode.maxHeight, 0, lerpFactor))
    var timelineAcc = {
      enable: timelineNode.maxHeight > 24,
      updateTimer: timelineNodePreviousMaxHeight != timelineNode.maxHeight
          || brushNodePreviousMaxWidth != brushNode.maxWidth
          && choose(false, false, true),
    }
    switch (this.timeline.channelsMode) {
      case "list":
        this.timeline.containers.forEach(function(container, key, acc) {
          container.enable = key == "ve-timeline-channel-settings" 
            ? false
            : acc.enable

          if (!acc.updateTimer) {
            return
          }
    
          container.finishUpdateTimer()
        }, timelineAcc)
        break
      case "settings":
        this.timeline.containers.forEach(function(container, key, acc) {
          container.enable = key == "ve-timeline-channels" || key == "ve-timeline-form"
            ? false
            : acc.enable

          if (!acc.updateTimer) {
            return
          }
    
          container.finishUpdateTimer()
        }, timelineAcc)
        break
    }

    var renderEvent = this.store.getValue("render-event")
    var accordionNode = Struct.get(this.layout.nodes, "accordion")
    var accordionNodePreviousMaxWidth = accordionNode.maxWidth
    accordionNode.minWidth = floor(renderEvent
      ? lerp(accordionNode.minWidth, 288, lerpFactor)
      : lerp(accordionNode.minWidth, 0, lerpFactor))
    accordionNode.maxWidth = floor(renderEvent
      ? lerp(accordionNode.maxWidth, round(GuiWidth() * 0.37), lerpFactor)
      : lerp(accordionNode.maxWidth, 0, lerpFactor))
    var accordionAcc = {
      enable: accordionNode.maxWidth > 24,
      updateTimer: timelineNodePreviousMaxHeight != timelineNode.maxHeight
          || accordionNodePreviousMaxWidth != accordionNode.maxWidth
          && choose(false, false, true),
    }

    this.accordion.containers.forEach(updateAccordion, accordionAcc)
    this.accordion.templateToolbar.containers.forEach(updateAccordion, accordionAcc)
    this.accordion.eventInspector.containers.forEach(updateAccordion, accordionAcc)

    var renderTrackControl = this.store.getValue("render-trackControl")
    var trackControlNode = Struct.get(this.layout.nodes, "track-control")
    trackControlNode.percentageHeight = renderTrackControl
      ? lerp(trackControlNode.percentageHeight, 1.0, lerpFactor * 2.0)
      : lerp(trackControlNode.percentageHeight, 0.0, lerpFactor * 2.0)
    this.trackControl.containers.forEach(function(container, key, enable) {
      container.enable = enable
    }, trackControlNode.percentageHeight > 0)

    var renderSceneConfigPreview = this.store.getValue("render-sceneConfigPreview")
    this.sceneConfigPreview.containers.forEach(function(container, key, enable) {
      container.enable = enable
    }, renderSceneConfigPreview)
    
    Struct.set(
      this.layout.nodes, 
      "preview", 
      this.renderUI 
        ? Struct.get(this.layout.nodes, "preview-editor") 
        : Struct.get(this.layout.nodes, "preview-full")
    )

    return this
  }

  ///@private
  ///@param {Struct} service
  ///@param {Number} iterator
  ///@param {VisuController} controller
  updateService = function(service, iterator, controller) {
    try {
      service.struct.update()
    } catch (exception) {
      var message = $"'update-service-{service.name}' fatal error: {exception.message}"
      Logger.error(BeanVisuEditorController, message)
      Core.printStackTrace()
      controller.send(new Event("spawn-popup", { message: message }))
    }
  }

  ///@private
  ///@return {VisuEditorController}
  updateDispatcher = function() {
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"dispatcher fatal error: {exception.message}"
      Logger.error(BeanVisuEditorController, message)
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }

  ///@private
  ///@return {VisuEditorController}
  updateExecutor = function() {
    try {
      this.executor.update()
    } catch (exception) {
      var message = $"executor fatal error: {exception.message}"
      Logger.error(BeanVisuEditorController, message)
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }

  ///@private
  ///@return {VisuEditorController}
  updateUIService = function() {
    if (this.renderUI) {
      this.renderUI = Beans.get(BeanVisuController).menu.containers.size() == 0
    }
    
    if (this.renderUI && this.requestOpenUI) {
      this.executor.add(this.uiInitialized 
        ? this.factoryOpenUITask()
        : this.factoryInitUITask())
      this.uiInitialized = true
      this.requestOpenUI = false
    } else if (!this.renderUI) {
      return this
    }

    try {
      ///@description reset UI timers after resize to avoid ghost effect
      if (Beans.get(BeanVisuController).displayService.state == "resized") {
        this.uiService.containers.forEach(this.resetUITimer)
      }
      this.uiService.update()
    } catch (exception) {
      var message = $"'updateUIService' set fatal error: {exception.message}"
      Logger.error(BeanVisuEditorController, message)
      Core.printStackTrace()
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }

  ///@private
  ///@param {UI}
  resetUITimer = function(ui) {
    ui.surfaceTick.skip()
    ui.finishUpdateTimer()
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VisuEditorController}
  update = function() {
    this.updateDispatcher()
    this.updateExecutor()
    this.updateUIService()
    this.services.forEach(this.updateService, this)
    this.updateLayout()
    return this
  }

  ///@return {VisuEditorController}
  free = function() {
    Struct.toMap(this)
      .filter(function(value) {
        if (!Core.isType(value, Struct)
          || !Struct.contains(value, "free")
          || !Core.isType(Struct.get(value, "free"), Callable)) {
          return false
        }
        return true
      })
      .forEach(function(struct, key, context) {
        try {
          Logger.debug(BeanVisuEditorController, $"Free '{key}'")
          Callable.run(Struct.get(struct, "free"))
        } catch (exception) {
          Logger.error(BeanVisuEditorController, $"Unable to free '{key}'. {exception.message}")
        }
      }, this)
    
    return this
  }
  
  this.init()
}