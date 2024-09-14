///@package io.alkapivo.visu.editor.ui

///@param {VisuEditorController} _editor
function VEEventInspector(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "event": {
      type: Optional.of(VEEvent),
      value: null,
    },
  })

  ///@type {Boolean}
  enable = true

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout({ 
      name: "event-inspector",
      margin: { left: 10 },
      x: function() { return this.context.x() + this.margin.left },
    }, parent)
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Task}
  factoryOpenTask = function(parent) {
    var eventInspector = this
    this.layout = this.factoryLayout(parent)
    var containerIntents = new Map(String, Struct, {
      "ve-event-inspector-properties": {
        name: "ve-event-inspector-properties",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
          "empty-label": new UILabel({
            text: "Click on\ntimeline\nevent",
            font: "font_inter_10_regular",
            color: VETheme.color.textShadow,
            align: { v: VAlign.CENTER, h: HAlign.CENTER },
          }),
          "inspectorType": VEEventInspector,
          "updateTrackEvent": false,
        }),
        updateTimer: new Timer(FRAME_MS * 30, { loop: Infinity, shuffle: true }),
        eventInspector: eventInspector,
        layout: layout,
        _updateTrackEvent: new BindIntent(function() {
          if (!this.state.get("updateTrackEvent")) {
            return
          }

          this.state.set("updateTrackEvent", false)
          var selectedEvent = Beans.get(BeanVisuEditorController).store
            .getValue("selected-event")
          if (!Core.isType(selectedEvent, Struct)) {
            return
          }

          var event = this.state.get("event")
          if (!Core.isType(event, VEEvent)) {
            return
          }

          var template = event.toTemplate()
          selectedEvent.data.timestamp = template.event.timestamp
          selectedEvent.data.data = template.event.data
          selectedEvent.channel = template.channel

          var container = Beans.get(BeanVisuEditorController).uiService
            .find("ve-timeline-events")
          if (!Core.isType(container, UI)) {
            return
          }

          selectedEvent.name = container.updateEvent(
            selectedEvent.channel, 
            selectedEvent.data, 
            selectedEvent.name
          ).name
        }),
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable"))),
        render: function() {
          this._updateTrackEvent()
          this.renderDefaultScrollable()
          if (!Optional.is(this.state.get("selectedEvent"))) {
            this.state.get("empty-label").render(
              this.area.getX() + (this.area.getWidth() / 2),
              this.area.getY() + (this.area.getHeight() / 2)
            )
          }
        },
        scrollbarY: { align: HAlign.LEFT },
        onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
        onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          var container = this
          this.collection = new UICollection(this, { layout: container.layout })
          Beans.get(BeanVisuEditorController).store
            .get("selected-event")
            .addSubscriber({ 
              name: container.name,
              overrideSubscriber: true, ///@todo investigate
              callback: function(selectedEvent, data) { 
                if (!Optional.is(selectedEvent)) {
                  data.collection.components.clear() ///@todo replace with remove lambda
                  data.items.clear() ///@todo replace with remove lambda
                  data.state
                    .set("selectedEvent", null)
                    .set("event", null)
                    .set("store", null)
                  return
                }

                var trackEvent = selectedEvent.data
                var event = new VEEvent(null, {
                  "event-color": Struct.getDefault(trackEvent.data.icon, "blend", "#FFFFFF"),
                  "event-texture": trackEvent.data.icon.name,
                  "event-timestamp": trackEvent.timestamp,
                  "event-channel": selectedEvent.channel,
                  "type": trackEvent.callableName,
                  "properties": Struct.remove(JSON.clone(trackEvent.data), "icon")
                })
                data.collection.components.clear() ///@todo replace with remove lambda
                data.items.clear() ///@todo replace with remove lambda
                data.eventInspector.store.get("event").set(event)
                data.state
                  .set("selectedEvent", selectedEvent)
                  .set("event", event)
                  .set("store", event.store)

                data.addUIComponents(event.components
                  .map(function(component) {
                    return new UIComponent(component)
                  }),
                  new UILayout({
                    area: data.area,
                    width: function() { return this.area.getWidth() },
                  })
                )

                event.store.container.forEach(function(item, name, acc) {
                  item.addSubscriber(acc)
                }, {
                  name: data.name,
                  callback: function(value, data) { 
                    data.state.set("updateTrackEvent", true)
                  },
                  data: data,
                })
              },
              data: container,
            })
        },
        onDestroy: function() {
          if (Core.isType(this.eventInspector.editor, VisuEditorController)) {
            this.eventInspector.editor.store
              .get("selected-event")
              .removeSubscriber(this.name)
          }
        },
      },
    })

    return new Task("init-container")
      .setState({
        context: eventInspector,
        containers: containerIntents,
        queue: new Queue(String, GMArray.sort(containerIntents.keys().getContainer())),
      })
      .whenUpdate(function() {
        var key = this.state.queue.pop()
        if (key == null) {
          this.fullfill()
          return
        }
        this.state.context.containers.set(key, new UI(this.state.containers.get(key)))
      })
      .whenFinish(function() {
        var containers = this.state.context.containers
        IntStream.forEach(0, containers.size(), function(iterator, index, acc) {
          Beans.get(BeanVisuEditorController).uiService.send(new Event("add", {
            container: acc.containers.get(acc.keys[iterator]),
            replace: true,
          }))
        }, {
          keys: GMArray.sort(containers.keys().getContainer()),
          containers: containers,
        })
      })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.dispatcher.execute(new Event("close"))
      Beans.get(BeanVisuEditorController).executor
        .add(this.factoryOpenTask(event.data.layout))
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function (container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()

      this.store.get("event").set(null)
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = method(this, EventPumpUtil.send())

  ///@return {VEBrushToolbar}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VEBrushToolbar dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }

    this.containers.forEach(function (container, key, enable) {
      container.enable = enable
    }, this.enable)
    return this
  }
}