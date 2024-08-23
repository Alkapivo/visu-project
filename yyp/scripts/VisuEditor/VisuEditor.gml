///@package io.alkapivo.visu.service.ui.track

#macro BeanVisuEditor "VisuEditor"
function VisuEditor() constructor {
  
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

  ///@type {VEStatusBar}
  statusBar = new VEStatusBar(this)

  ///@type {VEPopupQueue}
  popupQueue = new VEPopupQueue(this)

  ///@type {VEBrushService}
  brushService = new VEBrushService(this)

  ///@type {VisuNewProjectModal}
  newProjectModal = new VisuNewProjectModal()

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
    "bpm-sub": {
      type: Number,
      value: Assert.isType(Visu.settings.getValue("visu.editor.bpm-sub", 2), Number),
      passthrough: function(value) {
        return round(clamp(value, 1, 16))
      }
    },
    "tool": {
      type: String,
      value: ToolType.BRUSH,
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
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-event", false), Boolean)
    },
    "_render-event": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-event", false), Boolean)
    },
    "render-timeline": {
      type: Boolean,
      value:Assert.isType(Visu.settings.getValue("visu.editor.render-timeline", false), Boolean)
    },
    "_render-timeline": {
      type: Boolean,
      value:Assert.isType(Visu.settings.getValue("visu.editor.render-timeline", false), Boolean)
    },
    "render-brush": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-brush", false), Boolean)
    },
    "_render-brush": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-brush", false), Boolean)
    },
    "render-trackControl": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-track-control", false), Boolean)
    },
    "_render-trackControl": {
      type: Boolean,
      value: Assert.isType(Visu.settings.getValue("visu.editor.render-track-control", false), Boolean)
    },
    "new-channel-name": {
      type: String,
      value: "channel name",
    },
    "selected-event": {
      type: Optional.of(Struct),
      value: null,
    },
    "timeline-zoom": {
      type: Number,
      value: 10,
      passthrough: function(value) {
        return clamp(value, 5, 20)
      },
    },
  })

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.store.get("render-event").set(this.store.getValue("_render-event"))
      this.store.get("render-timeline").set(this.store.getValue("_render-timeline"))
      this.store.get("render-brush").set(this.store.getValue("_render-brush"))
      this.store.get("render-trackControl").set(this.store.getValue("_render-trackControl"))
      return {
        "titleBar": this.titleBar.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "title-bar") })),
        "accordion": this.accordion.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "accordion") })),
        "trackControl": this.trackControl.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "track-control") })),
        "brushToolbar": this.brushToolbar.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "brush-toolbar") })),
        "timeline": this.timeline.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "timeline") })),
        "statusBar": this.statusBar.send(new Event("open")
          .setData({ layout: Struct.get(this.layout.nodes, "status-bar") })),
      }
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
      this.store.get("selected-event").set(null)

      return {
        "accordion": this.accordion.send(new Event("close")),
        "trackControl": this.trackControl.send(new Event("close")),
        "brushToolbar": this.brushToolbar.send(new Event("close")),
        "timeline": this.timeline.send(new Event("close")),
      }
    },
  }), {
    enableLogger: true,
    catchException: false,
  })

  ///@private
  ///@type {Array<Struct>}
  services = new Array(Struct, GMArray.map([
    "titleBar",
    "accordion",
    "trackControl",
    "brushToolbar",
    "timeline",
    "statusBar",
    "popupQueue",
    "exitModal",
    "newProjectModal"
  ], function(name, index, editor) {
    Logger.debug(BeanVisuEditor, $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(editor, name), Struct),
    }
  }, this))

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
          height: function() { return 20 },
        },
        "accordion": {
          name: "visu-editor.accordion",
          minWidth: 1,
          maxWidth: 1,
          percentageWidth: 0.2,
          width: function() { 
            return clamp(this.percentageWidth * this.context.width(), this.minWidth, this.maxWidth)
          },
          width: function() { return clamp(max(this.percentageWidth * this.context.width(), 
            this.minWidth), this.minWidth, this.maxWidth) },
          height: function() { return Struct.get(this.context.nodes, "timeline").top()
            - Struct.get(this.context.nodes, "title-bar").bottom() },
          y: function() { return Struct.get(this.context.nodes, "title-bar").bottom() },
        },
        "preview": {
          name: "visu-editor.preview",
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
        "track-control": {
          name: "visu-editor.track-control",
          percentageHeight: 1.0,
          width: function() { return Struct.get(this.context.nodes, "preview").width() },
          height: function() { return 76.0 * this.percentageHeight },
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
            return clamp(this.percentageWidth * this.context.width(), this.minWidth, this.maxWidth)
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
            return clamp(this.percentageHeight * this.context.height(), this.minHeight, this.maxHeight)
          },
          y: function() { return this.context.height() - this.height()
            - Struct.get(this.context.nodes, "status-bar").height() },
        },
        "status-bar": {
          name: "visu-editor.status-bar",
          height: function() { return 24 },
          y: function() { return this.context.height() - this.height() },
        },
      },
    })
  }

  ///@type {UILayout}
  layout = this.factoryLayout()

  ///@private
  ///@return {VisuEditor}
  init = function() {
    var generateSettingsSubscriber = Visu.settings.generateSettingsSubscriber
    store.get("bpm").addSubscriber(generateSettingsSubscriber("visu.editor.bpm"))
    store.get("bpm-sub").addSubscriber(generateSettingsSubscriber("visu.editor.bpm-sub"))
    store.get("snap").addSubscriber(generateSettingsSubscriber("visu.editor.snap"))
    store.get("render-event").addSubscriber(generateSettingsSubscriber("visu.editor.render-event"))
    store.get("render-timeline").addSubscriber(generateSettingsSubscriber("visu.editor.render-timeline"))
    store.get("render-trackControl").addSubscriber(generateSettingsSubscriber("visu.editor.render-track-control"))
    store.get("render-brush").addSubscriber(generateSettingsSubscriber("visu.editor.render-brush"))
    store.get("timeline-zoom").addSubscriber(generateSettingsSubscriber("visu.editor.timeline-zoom"))

    return this
  }

  ///@private
  ///@return {VisuEditor}
  updateLayout = function() {
    var renderBrush = this.store.getValue("render-brush")
    var brushNode = Struct.get(this.layout.nodes, "brush-toolbar")
    brushNode.minWidth = renderBrush ? 270 : 0
    brushNode.maxWidth = renderBrush ? GuiWidth() * 0.37 : 0
    this.brushToolbar.containers.forEach(function(container, key, enable) {
      container.enable = enable
    }, renderBrush)

    var renderTimeline = this.store.getValue("render-timeline")
    var timelineNode = Struct.get(this.layout.nodes, "timeline")
    timelineNode.minHeight = renderTimeline ? 96 : 0
    timelineNode.maxHeight = renderTimeline ? GuiHeight() * 0.41 : 0
    this.timeline.containers.forEach(function(container, key, enable) {
      container.enable = enable
    }, renderTimeline)

    var renderEvent = this.store.getValue("render-event")
    var accordionNode = Struct.get(this.layout.nodes, "accordion")
    accordionNode.minWidth = renderEvent ? 270 : 0
    accordionNode.maxWidth = renderEvent ? GuiWidth() * 0.37 : 0
    this.accordion.containers.forEach(function(container, key, enable) {
      if (key == "_ve-accordion_accordion-items") {
        container.enable = enable
      } else {
        if (!enable) {
          container.enable = false
        }
      }
    }, renderEvent)

    var renderTrackControl = this.store.getValue("render-trackControl")
    var trackControlNode = Struct.get(this.layout.nodes, "track-control")
    trackControlNode.percentageHeight = renderTrackControl ? 1.0 : 0.0

    return this
  }

  ///@private
  ///@return {VisuEditor}
  render = function() {
    static renderLayout = function(layout, color) {
      var beginX = layout.x()
      var beginY = layout.y()
      var endX = beginX + layout.width()
      var endY = beginY + layout.height()
      GPU.render.rectangle(beginX, beginY, endX, endY, false, color, color, color, color, 0.5)
    }

    renderLayout(this.layout, c_red)
    renderLayout(Struct.get(this.layout.nodes, "title-bar"), c_blue)
    renderLayout(Struct.get(this.layout.nodes, "accordion"), c_yellow)
    renderLayout(Struct.get(this.layout.nodes, "preview"), c_fuchsia)
    renderLayout(Struct.get(this.layout.nodes, "track-control"), c_lime)
    renderLayout(Struct.get(this.layout.nodes, "brush-toolbar"), c_orange)
    renderLayout(Struct.get(this.layout.nodes, "timeline"), c_green)
    renderLayout(Struct.get(this.layout.nodes, "status-bar"), c_grey)

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
      Logger.error(BeanVisuEditor, message)
      Core.printStackTrace()
      controller.send(new Event("spawn-popup", { message: message }))
    }
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VisuEditor}
  update = function() {
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VisuEditor dispatcher fatal error: {exception.message}"
      Logger.error("UI", message)
      var controller = Beans.get(BeanVisuController)
      if (Core.isType(controller, VisuController)) {
        controller.send(new Event("spawn-popup", { message: message }))
      }
    }

    this.services.forEach(this.updateService, Beans.get(BeanVisuController))

    this.updateLayout()
    return this
  }
  
  this.init()
}
