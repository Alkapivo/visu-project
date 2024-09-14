///@package io.alkapivo.visu.editor.ui

///@param {VisuEditorController} _editor
///@param {?Struct} [config]
function VEAccordion(_editor, config = null) constructor {

  ///@type {VisuEditorController}
  editor = _editor

  ///@type {?UILayout}
  layout = null

  ///@type {VEEventInspector}
  eventInspector = new VEEventInspector(this.editor)

  ///@type {VETemplateToolbar}
  templateToolbar = new VETemplateToolbar(this.editor)

  ///@type {Map<String, UI>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "render-event-inspector": {
      type: Boolean,
      value: Assert.isType(Visu.settings
        .getValue("visu.editor.accordion.render-event-inspector", false), Boolean),
    },
    "render-template-toolbar": {
      type: Boolean,
      value: Assert.isType(Visu.settings
        .getValue("visu.editor.accordion.render-template-toolbar", false), Boolean),
    },
  })

  var generateSettingsSubscriber = Visu.settings.generateSettingsSubscriber
  store.get("render-event-inspector").addSubscriber(
    generateSettingsSubscriber("visu.editor.accordion.render-event-inspector"))
  store.get("render-template-toolbar").addSubscriber(
    generateSettingsSubscriber("visu.editor.accordion.render-template-toolbar"))

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "ve-accordion",
        store: {
          "render-event-inspector": false,
          "render-template-toolbar": false,
        },
        nodes: {
          "bar_event-inspector": {
            name: "bar_event-inspector",
            y: function() { return 0 },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { return 32 },
            nodes: {
              preview: {
                name: "bar_event-inspector.preview",
                width: function() { return 32 },
              },
              label: {
                name: "bar_event-inspector.label",
                x: function() { return this.context.nodes.preview.right() },
                width: function() { return this.context.width()
                  - this.context.nodes.preview.width()
                  - this.context.nodes.checkbox.width() },
              },
              checkbox: {
                name: "bar_event-inspector.checkbox",
                x: function() { return this.context.nodes.label.right() },
                width: function() { return 56 },
              },
            },
          },
          "view_event-inspector": {
            name: "view_event-inspector",
            margin: { top: 2, bottom: 2, right: 0, left: 1 },
            y: function() { return this.context.y() + this.margin.top
              + Struct.get(this.context.nodes, "bar_event-inspector").bottom() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { 
              if (!Struct.get(this.context.store, "render-event-inspector")) {
                return this.margin.top + this.margin.bottom
              }
              var height = this.context.height()
                - this.margin.top - this.margin.bottom
                - Struct.get(this.context.nodes, "bar_event-inspector").height()
                - Struct.get(this.context.nodes, "bar_template-toolbar").height()
              if (Struct.get(this.context.store, "render-template-toolbar")) {
                height = height * 0.3
              }
              return height
            },
            
          },
          "bar_template-toolbar": {
            name: "bar_template-toolbar",
            y: function() { return Struct.get(this.context.nodes, "view_event-inspector").bottom() 
              - this.context.y() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { return 32 },
            nodes: {
              label: {
                name: "bar_template-toolbar.label",
                width: function() { return this.context.width() - 56 },
              },
              checkbox: {
                name: "bar_template-toolbar.checkbox",
                x: function() { return this.context.nodes.label.right() },
                width: function() { return 56 },
              },
            },
          },
          "view_template-toolbar": {
            name: "view_template-toolbar",
            margin: { top: 2, bottom: 8, right: 0, left: 1 },
            y: function() { return this.context.y() + this.margin.top
              + Struct.get(this.context.nodes, "bar_template-toolbar").bottom() },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { 
              if (!Struct.get(this.context.store, "render-template-toolbar")) {
                return this.margin.top + this.margin.bottom
              }

              var height = this.context.height()
                - this.margin.top - this.margin.bottom
                - Struct.get(this.context.nodes, "bar_event-inspector").height()
                - Struct.get(this.context.nodes, "bar_template-toolbar").height()
              if (Struct.get(this.context.store, "render-event-inspector")) {
                height = height * 0.7
              }

              return height
            },
          },
          "resize": {
            name: "accordion.resize",
            x: function() { return this.context.x()
              + this.context.width()
              - this.width() },
            y: function() { return 0 },
            width: function() { return 7 },
            height: function() { return this.context.height() },
          }
        }
      },
      parent
    ) 
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Task}
  factoryOpenTask = function(parent) {
    var accordion = this
    var layout = this.factoryLayout(parent)
    this.layout = layout

    eventInspector.send(new Event("open").setData({ 
      layout: Struct.get(layout.nodes, "view_event-inspector")
    }))
    
    templateToolbar.send(new Event("open").setData({ 
      layout: Struct.get(layout.nodes, "view_template-toolbar")
    }))

    var containerIntents = new Map(String, Struct, {
      "_ve-accordion_accordion-items": {
        name: "_ve-accordion_accordion-items",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        accordion: accordion,
        layout: layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        updateCustom: function() {
          var store = this.state.get("store")
          if (!Core.isType(store, Store)
            || !Core.isType(this.layout, UILayout)) {
            return
          }
          
          Struct.set(this.layout.store, "render-event-inspector", store
            .getValue("render-event-inspector"))
          Struct.set(this.layout.store, "render-template-toolbar", store
            .getValue("render-template-toolbar"))
        },
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        onInit: function() {
          var context = this
          this.state.set("store", this.accordion.store)
          context
            .add(UIButton(
              "accordion-item_event-inspector_preview",
              {
                updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
                backgroundColor: VETheme.color.accentShadow,
                font: "font_inter_10_regular",
                color: VETheme.color.textFocus,
                sprite: { name: "texture_ve_event_inspector_button_preview" },
                layout: Struct.get(context.layout.nodes, "bar_event-inspector").nodes.preview,
                onMousePressedLeft: function(data) {
                  var eventInspector = this.context.accordion.eventInspector
                  var event = eventInspector.store.getValue("event")
                  if (!Core.isType(event, VEEvent)) {
                    return
                  }
                  
                  var handler = Beans.get(BeanVisuController).trackService.handlers
                    .get(event.type)
                  handler(event.toTemplate().event.data)
                },
              }
            ))
            .add(UIText(
              "accordion-item_event-inspector_label",
              {
                updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
                backgroundColor: VETheme.color.accentShadow,
                font: "font_inter_10_regular",
                color: VETheme.color.textFocus,
                align: { v: VAlign.CENTER, h: HAlign.LEFT },
                text: "Event inspector",
                offset: { x: 0 },
                layout: Struct.get(context.layout.nodes, "bar_event-inspector").nodes.label,
              }
            ))
            .add(UICheckbox(
              "accordion-item_event-inspector_checkbox",
              {
                spriteOn: { name: "visu_texture_checkbox_switch_on" },
                spriteOff: { name: "visu_texture_checkbox_switch_off" },
                updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
                backgroundColor: VETheme.color.accentShadow,
                layout: Struct.get(context.layout.nodes, "bar_event-inspector").nodes.checkbox,
                store: { key: "render-event-inspector" },
              }
            ))
            add(UIText(
              "accordion-item_template-toolbar_label",
              {
                updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
                backgroundColor: VETheme.color.accentShadow,
                font: "font_inter_10_regular",
                color: VETheme.color.textFocus,
                align: { v: VAlign.CENTER, h: HAlign.LEFT },
                text: "Templates",
                offset: { x: 32 },
                layout: Struct.get(context.layout.nodes, "bar_template-toolbar").nodes.label,
              }
            ))
            .add(UICheckbox(
              "accordion-item_template-toolbar_checkbox",
              {
                spriteOn: { name: "visu_texture_checkbox_switch_on" },
                spriteOff: { name: "visu_texture_checkbox_switch_off" },
                updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
                backgroundColor: VETheme.color.accentShadow,
                layout: Struct.get(context.layout.nodes, "bar_template-toolbar").nodes.checkbox,
                store: { key: "render-template-toolbar" },
              }
            ))
        },
        items: {
          "resize_accordion": {
            type: UIButton,
            layout: layout.nodes.resize,
            backgroundColor: VETheme.color.primary, //resize
            clipboard: {
              name: "resize_accordion",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_HORIZONTAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            updateCustom: function() {
              static updateAccordionTimer = function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }
                
                container.surfaceTick.skip()
                container.updateTimer.time = container.updateTimer.duration
              }

              if (MouseUtil.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseX())
                this.context.accordion.containers.forEach(updateAccordionTimer)
                this.context.accordion.eventInspector.containers.forEach(updateAccordionTimer)
                this.context.accordion.templateToolbar.containers.forEach(updateAccordionTimer)
  
                if (!mouse_check_button(mb_left)) {
                  MouseUtil.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(position) {
              var node = Struct.get(Beans.get(BeanVisuEditorController).layout.nodes, "accordion")
              node.percentageWidth = position / GuiWidth()
            }),
            onMousePressedLeft: function(event) {
              MouseUtil.setClipboard(this.clipboard)
            },
            onMouseHoverOver: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drag()
              }
            },
            onMouseHoverOut: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drop()
              }
            },
          }
        }
      }
    })

    return new Task("init-container")
      .setState({
        context: accordion,
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

      this.eventInspector.dispatcher.execute(new Event("close"))
      this.templateToolbar.dispatcher.execute(new Event("close"))
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = method(this, EventPumpUtil.send())

  ///@private
  ///@params {Struct} context
  ///@params {Boolean} enable
  updateContainerObject = function(context, enable) {
    if (!context.enable && enable) {
      context.containers.forEach(function(container) {
        if (Optional.is(container.updateArea)) {
          container.updateArea()
        }
        container.items.forEach(function(item) {
          if (Optional.is(item.updateArea)) {
            item.updateArea()
          }
        }) 
      })
    }

    context.enable = enable
    context.update()
  }

  ///@return {VEBrushToolbar}
  update = function() { 
    try {
      this.dispatcher.update()
      this.updateContainerObject(this.eventInspector, this.store.getValue("render-event-inspector"))
      this.updateContainerObject(this.templateToolbar, this.store.getValue("render-template-toolbar"))
    } catch (exception) {
      var message = $"VEAccordion dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}