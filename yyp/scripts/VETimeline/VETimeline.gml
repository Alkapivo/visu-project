///@package io.alkapivo.visu.editor.ui.controller

///@enum
function _ToolType(): Enum() constructor {
  SELECT = "tool_select"
  BRUSH = "tool_brush"
  ERASE = "tool_erase"
  CLONE = "tool_clone"
}
global.__ToolType = new _ToolType()
#macro ToolType global.__ToolType


///@param {VisuEditorController} _editor
function VETimeline(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)
  
  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {String}
  channelsMode = "list"

  ///@type {TransactionService}
  transactionService = new TransactionService()

  ///@private
  ///@param {Struct} context
  ///@return {ChunkService}
  factoryChunkService = function() {
    return new ChunkService(this, {
      step: 30,
      fetchKey: function(timestamp) {
        var from = timestamp div this.step * this.step
        var to = from + this.step
        var key = $"{from}-{to}"
        return key
      },
      factoryChunk: function(key) {
        return new Chunk(this, {
          key: key,
          type: UIItem,
          data:  new Map(String, UIItem),
          add: function(item) {
            this.data.add(item, item.name)
            return this
          },
          get: function(name) {
            return this.data.get(name)
          },
          size: function() {
            return this.data.size()
          },
          contains: function(name) {
            return this.data.contains(name)
          },
          remove: function(name) {
            this.data.remove(name)
            return this
          },
          forEach: function(callback, acc = null) {
            this.data.forEach(callback, acc)
            return this
          },
          filter: function(callback, acc = null) {
            return this.data.filter(callback, acc)
          },
          find: function(callback, acc = null) {
            return this.data.find(callback, acc)
          },
        })
      },
      activeChunks: new Collection({
        chunks: new Map(String, Chunk),
        size: function() {
          var acc = {
            size: 0,
          }

          this.chunks.forEach(function(chunk, key, acc) {
            acc.size += chunk.size()
          }, acc)

          return acc.size
        },
        find: function(callback, acc) {
          var keys = this.chunks.keys()
          var size = this.chunks.size()
          for (var index = 0; index < size; index++) {
            var item = this.chunks.get(keys.get(index)).find(callback, acc)
            if (Core.isType(item, UIItem)) {
              return item
            }
          }
        }, 
        generateKey: function(timestamp) {
          var key = this.service.fetchKey(timestamp)
          return this.service.fetch(key).data.generateKey()
        },
        get: function(name) {
          var chunks = this.service.chunks
          var keys = chunks.keys()
          var size = chunks.size()
          for (var index = 0; index < size; index++) {
            var chunk = chunks.get(keys.get(index))
            if (!chunk.contains(name)) {
              continue
            }
            return chunk.get(name)
          }
        },
        add: function(item, name) {
          var timestamp = item.state.get("timestamp")
          var key = this.service.fetchKey(timestamp)
          this.service.fetch(key).add(item, name)
        },
        remove: function(name) {
          var chunks = this.service.chunks
          var chunk = null
          var keys = chunks.keys()
          var size = chunks.size()
          for (var index = 0; index < size; index++) {
            var _chunk = chunks.get(keys.get(index))
            if (!_chunk.contains(name)) {
              continue
            }
            chunk = _chunk
            break
          }

          if (!Core.isType(chunk, Chunk)) {
            return
          }
          chunk.remove(name)
        },
        forEach: function(callback, acc) {
          var keys = this.chunks.keys()
          var size = this.chunks.size()
          for (var index = 0; index < size; index++) {
            this.chunks.get(keys.get(index)).forEach(callback, acc)
          }
        },
      }),
      update: function(timestamp) {
        var step = this.step
        var keyPast = this.fetchKey(clamp(timestamp - step, 0, timestamp))
        var keyPresent = this.fetchKey(timestamp)
        var keyFuture = this.fetchKey(timestamp + step)
        if (!this.activeChunks.chunks.contains(keyPast)
          || !this.activeChunks.chunks.contains(keyPresent)
          || !this.activeChunks.chunks.contains(keyFuture)) {
          
          Logger.debug("ChunkService", $"Update keys, past: {keyPast}, present: {keyPresent}, future: {keyFuture}")
          this.activeChunks.chunks.clear()
            .set(keyPast, this.fetch(keyPast))
            .set(keyPresent, this.fetch(keyPresent))
            .set(keyFuture, this.fetch(keyFuture))
        }
        return this
      },
    })
  }
  
  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "timeline",
        nodes: {
          background: {},
          resize: {
            name: "timeline.resize",
            x: function() { return 0 },
            y: function() { return 0 },
            width: function() { return this.context.width() },
            height: function() { return 7 },
          },
          resizeHorizontal: {
            name: "timeline.resizeHorizontal",
            x: function() { return this.context.nodes.form.right() },
            y: function() { return 0 },
            width: function() { return 6 },
            height: function() { return this.context.height() },
          },
          form: {
            name: "timeline.form",
            minWidth: 200,
            maxWidth: 1,
            percentageWidth: 0.2,
            margin: { top: 2, bottom: 1, left: 3, right: 1 },
            width: function() { 
              this.maxWidth = round(GuiWidth() * 0.37) 
              return ceil(clamp(
                max(this.percentageWidth * this.context.context.context.width(), this.minWidth), 
                this.minWidth, 
                this.maxWidth)) - this.margin.left - this.margin.right - 4
            },
            height: function() { return 29 - this.margin.bottom },
            x: function() { return 0 },
            y: function() { return this.context.y() + this.context.nodes.resize.height() + this.margin.top },
          },
          settings: {
            name: "timeline.settings",
            margin: { top: 3, bottom: 4, left: 10, right: 0 },
            width: function() { return this.context.nodes.form.width() - this.margin.left },
            height: function() { return this.context.height()
              - this.context.nodes.resize.height() - this.margin.top },
            x: function() { return this.context.x() + this.margin.left },
            y: function() { return this.context.y() + this.context.nodes.resize.height() + this.margin.top },
          },
          ruler: {
            name: "timeline.ruler",
            width: function() { return this.context.x() + this.context.width() 
              - this.context.nodes.resizeHorizontal.right()
              - this.margin.left
              - this.margin.right },
            height: function() { return this.context.nodes.form.height() 
              - this.margin.top
              - this.margin.bottom },
            margin: { top: 8, bottom: 0, left: 2, right: 1 },
            x: function() { return this.context.nodes.resizeHorizontal.right() + this.margin.left },
            y: function() { return this.context.y() + this.margin.top + this.context.nodes.resize.height() },
          },
          channels: {
            name: "timeline.channels",
            margin: { left: 10, right: 0 },
            width: function() { return this.context.nodes.form.width() 
              - this.margin.left - this.margin.right },
            height: function() { return this.context.height() 
              - this.context.nodes.form.height()
              - this.context.nodes.form.margin.top
              - this.context.nodes.form.margin.bottom
              - this.context.nodes.resize.height()
              - this.context.nodes.resize.margin.top
              - this.context.nodes.resize.margin.bottom },
            x: function() { return this.context.x() + this.margin.left },
            y: function() { return this.context.nodes.form.bottom() },
          },
          events: {
            name: "timeline.events",
            width: function() { return this.context.nodes.ruler.width() },
            height: function() { return this.context.height() 
              - this.context.nodes.ruler.height()
              - this.context.nodes.resize.height() - 12 },
            margin: { top: 0, bottom: 0, left: 2, right: 1 },
            x: function() { return this.context.nodes.resizeHorizontal.right() 
              + this.margin.left},
            y: function() { return this.context.nodes.form.bottom() + this.margin.bottom },
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
    var controller = this
    var layout = this.factoryLayout(parent)
    var containerIntents = new Map(String, Struct, {
      "_ve-timeline-background": {
        name: "_ve-timeline-background",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),

        }),
        controller: controller,
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.timeline.background.updateTimer", 2.0), { loop: Infinity, shuffle: true }),
        updateTimerCooldown: Core.getProperty("visu.editor.ui.timeline.background.updateTimer.cooldown", 4.0),
        layout: layout.nodes.background,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        items: {
          "resize_timeline": {
            type: UIButton,
            layout: layout.nodes.resize,
            backgroundColor: VETheme.color.primaryShadow,
            clipboard: {
              name: "resize_timeline",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_VERTICAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            updateCustom: function() {
              static resetContainerTimer = function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }

                //container.surfaceTick.skip()
                //container.updateTimer.time = container.updateTimer.duration + random(container.updateTimer.duration / 2.0)
                container.updateTimer.time = clamp(container.updateTimer.time, container.updateTimer.duration * 0.9500, container.updateTimer.duration * 2.0)
              }

              var editorIO = Beans.get(BeanVisuEditorIO)
              var mouse = editorIO.mouse
              if (mouse.hasMoved() && mouse.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseY())
                this.context.controller.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

                // reset accordion timer to avoid ghost effect,
                // because timeline height is affecting accordion height
                var accordion = Beans.get(BeanVisuEditorController).accordion
                accordion.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)
                accordion.eventInspector.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)
                accordion.templateToolbar.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

                if (!mouse_check_button(mb_left)) {
                  Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(position) {
              var controller = Beans.get(BeanVisuController)
              var editor = Beans.get(BeanVisuEditorController)
              var node = Beans.get(BeanVisuEditorController).layout.nodes.timeline
              node.percentageHeight = abs((GuiHeight() - 24) - position) / (GuiHeight() - 24)

              var events = editor.uiService.find("ve-timeline-events")
              if (Core.isType(events, UI) && Optional.is(events.updateTimer)) {
                UIUtil.clampUpdateTimerToCooldown(events, "ve-timeline-events", this.context.updateTimerCooldown)
                //events.updateTimer.time = events.updateTimer.duration + random(events.updateTimer.duration / 2.0)
              }
            }),
            onMousePressedLeft: function(event) {
              Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
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
          },
          "resize_horizontal": {
            type: UIButton,
            layout: layout.nodes.resizeHorizontal,
            backgroundColor: VETheme.color.primaryShadow,
            clipboard: {
              name: "resize_horizontal",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_HORIZONTAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            updateCustom: function() {
              static resetContainerTimer = function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }

                //container.surfaceTick.skip()
                //container.updateTimer.time = container.updateTimer.duration + random(container.updateTimer.duration / 2.0)
                container.updateTimer.time = clamp(container.updateTimer.time, container.updateTimer.duration * 0.9500, container.updateTimer.duration * 2.0)
              }

              var editorIO = Beans.get(BeanVisuEditorIO)
              var mouse = editorIO.mouse
              if (mouse.hasMoved() && mouse.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseX())
                this.context.controller.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

                // reset accordion timer to avoid ghost effect,
                // because timeline height is affecting accordion height
                var accordion = Beans.get(BeanVisuEditorController).accordion
                accordion.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)
                accordion.eventInspector.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)
                accordion.templateToolbar.containers.forEach(UIUtil.clampUpdateTimerToCooldown, this.context.updateTimerCooldown)

                if (!mouse_check_button(mb_left)) {
                  Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(position) {
              var ui = this.context
              var nodes = ui.layout.context.nodes
              var percentageWidth = abs(1.0 - ((GuiWidth() - position) / GuiWidth()))
              if (nodes.form.percentageWidth == percentageWidth 
                  && nodes.settings.percentageWidth == percentageWidth) {
                return
              }

              nodes.form.percentageWidth = percentageWidth
              nodes.settings.percentageWidth = percentageWidth
              ui.areaWatchdog.signal()
              ui.controller.containers.forEach(UIUtil.clampUpdateTimerToCooldown, ui.updateTimerCooldown)
            }),
            onMousePressedLeft: function(event) {
              Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
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
      },
      "ve-timeline-form": {
        name: "ve-timeline-form",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.sideShadow).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        controller: controller,
        layout: layout.nodes.form,
        timeline: controller,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        onInit: function() {
          this.addUIComponents(
            new Array(Struct, [
              new UIComponent({
                name: "ve-timeline-form",  
                template: VEComponents.get("text-field-button"),
                layout: VELayouts.get("text-field-button-channel"),
                config: { 
                  layout: { type: UILayoutType.VERTICAL },
                  label: { text: "Name" },
                  field: { store: { key: "new-channel-name" } },
                  button: { 
                    label: { 
                      text: "Add",
                      font: "font_inter_8_bold",
                    },
                    onMouseHoverOver: function(event) {
                      this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
                    },
                    onMouseHoverOut: function(event) {
                      this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
                    },
                    callback: function() {
                      var initialized = this.context.controller.containers
                        .get("ve-timeline-events").state
                        .get("initialized")
                      if (!initialized) {
                        return
                      }

                      this.context.controller.containers
                        .get("ve-timeline-channels")
                        .addChannel(this.context.state
                          .get("store")
                          .getValue("new-channel-name"))
                    }},
                },
              }),
            ]),
            new UILayout({
              area: this.area,
              width: function() { return this.area.getWidth() },
            })
          )
        }
      },
      "ve-timeline-channels": {
        name: "ve-timeline-channels",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "dragItem": null,
        }),
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.timeline.channels.updateTimer", 60), { loop: Infinity, shuffle: true }),
        controller: controller,
        layout: layout.nodes.channels,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        _render: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable"))),
        updateVerticalSelectedIndex: new BindIntent(Callable.run(UIUtil.templates.get("updateVerticalSelectedIndex"))),
        render: function() {
          this.updateVerticalSelectedIndex(32)
          this._render()

          ///@todo replace with Promise in clipboard
          var dragItem = this.state.get("dragItem")
          if (Optional.is(dragItem) 
            && !mouse_check_button(mb_left) 
            && !mouse_check_button_released(mb_left)) {
            this.state.set("dragItem", null)
            dragItem = null
          }

          if (Optional.is(dragItem)) {
            var mouseX = device_mouse_x_to_gui(0)
            var mouseY = device_mouse_y_to_gui(0)
            var areaX = this.area.getX()
            var areaY = this.area.getY()
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
              draw_sprite_ext(texture_bazyl_cursor, 0, mouseX, mouseY, 1.0, 1.0, 0.0, c_white, 0.5)
            }
          }
          return this
        },
        fetchViewHeight: function() {
          return (32 * this.collection.size())
        },
        scrollbarY: { align: HAlign.LEFT },
        _onMousePressedLeft: new BindIntent(Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY"))),
        _onMouseWheelUp: new BindIntent(Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY"))),
        _onMouseWheelDown: new BindIntent(Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY"))),
        onMousePressedLeft: function(event) {
          this._onMousePressedLeft(event)
          this.finishUpdateTimer()

          var events = this.controller.containers.get("ve-timeline-events")
          if (Optional.is(events)) {
            events.offset.y = this.offset.y
            events.finishUpdateTimer()
          }
        },
        onMouseWheelUp: function(event) {
          this._onMouseWheelUp(event)
          this.finishUpdateTimer()

          var events = this.controller.containers.get("ve-timeline-events")
          if (Optional.is(events)) {
            events.offset.y = this.offset.y
            events.finishUpdateTimer()
          }
        },
        onMouseWheelDown: function(event) {
          this._onMouseWheelDown(event)
          this.finishUpdateTimer()

          var events = this.controller.containers.get("ve-timeline-events")
          if (Optional.is(events)) {
            events.offset.y = this.offset.y
            events.finishUpdateTimer()
          }
        },
        onMouseDragLeft: function(event) {
          var mouse = Beans.get(BeanVisuEditorIO).mouse
          var name = Struct.get(mouse.getClipboard(), "name")
          if (name == "resize_accordion"
              || name == "resize_brush_toolbar"
              || name == "resize_brush_inspector"
              || name == "resize_template_inspector"
              || name == "resize_timeline"
              || name == "resize_horizontal"
              || name == "resize_template_title") {
            return
          }

          var initialized = this.controller.containers
            .get("ve-timeline-events").state
            .get("initialized")
          if (!initialized) {
            return false
          }

          var component = this.collection.components.find(function(component) {
            var text = component.items.find(function(item) {
              return item.type == UIText
            })
  
            return Optional.is(text)
              ? text.backgroundColor == ColorUtil.fromHex(text.colorHoverOver).toGMColor()
              : false
          })

          if (Optional.is(component)) {
            this.state.set("dragItem", component)
            Beans.get(BeanVisuEditorIO).mouse.setClipboard(component)
          }
        },
        onMouseDropLeft: function(event) {
          var initialized = this.controller.containers
            .get("ve-timeline-events").state
            .get("initialized")
          if (!initialized) {
            return false
          }

          var dragItem = this.state.get("dragItem")
          if (Optional.is(dragItem) && Beans.get(BeanVisuEditorIO).mouse.getClipboard() == dragItem) {
            this.state.set("dragItem", null)
            Beans.get(BeanVisuEditorIO).mouse.setClipboard(null)

            var component = this.collection.components.find(function(component) {
              var text = component.items.find(function(item) {
                return item.type == UIText
              })

              return Optional.is(text)
                ? text.backgroundColor == ColorUtil.fromHex(text.colorHoverOver).toGMColor()
                : false
            })

            if (Optional.is(component)) {
              var track = Beans.get(BeanVisuController).trackService.track
              var from = dragItem.index
              var to = component.index
              var size = track.channels.size()
              if (from < 0 || from >= size)
                || (to < 0 || to >= size) {
                return
              }

              var array = GMArray.create(String, size, "")
              track.channels.forEach(function(channel, key, array) {
                array.set(channel.index, channel.name)
              }, array)

              array.move(from, to)
                .forEach(function(name, index, channels) {
                  channels.get(name).index = index
                }, track.channels)

              this.onInit()
              this.finishUpdateTimer()

              var events = this.controller.containers.get("ve-timeline-events")
              if (Optional.is(events)) {
                events.onInit()
                events.finishUpdateTimer()
              }
            }
          } else {
            var mouse = Beans.get(BeanVisuEditorIO).mouse
            var dropEvent = mouse.getClipboard()
            if (Core.isType(dropEvent, Promise)) {
              dropEvent.fullfill()
            }

            if (Core.isType(Struct.get(dropEvent, "drop"), Callable)) {
              dropEvent.drop()
            }
            mouse.clearClipboard()
          }
        },
        onInit: function() {
          this.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
          this.collection = new UICollection(this, { layout: this.layout })
          
          var trackService = Beans.get(BeanVisuController).trackService
          if (!Core.isType(trackService.track, Track)) {
            return
          }

          var sorted = new Map(Number, String)
          var context = this
          trackService.track.channels.forEach(function(channel, name, sorted) {
            sorted.set(channel.index, name)
          }, sorted)

          IntStream.forEach(0, sorted.size(), function(item, index, acc) {
            acc.context.addChannel(acc.sorted.get(item))
          }, { sorted: sorted, context: context })
        },

        ///@param {String} name
        addChannel: new BindIntent(function(name) {
          var trackService = Beans.get(BeanVisuController).trackService
          if (!Core.isType(trackService.track, Track)) {
            throw new Exception("Load track before adding new channel")
          }

          var channel = Assert.isType(trackService.track
            .addChannel(name).channels.get(name), TrackChannel)
          this.collection.add(new UIComponent({
            name: name,
            template: VEComponents.get("channel-entry"),
            layout: VELayouts.get("channel-entry"),
            config: {
              label: { text: name },
              settings: {
                sprite: { name: "texture_ve_icon_settings" },
                callback: function() {
                  if (!Core.isType(Struct.get(this, "callbackData"), String)) {
                    return
                  }

                  var channel = Beans.get(BeanVisuController).trackService.track.channels
                    .find(function(channel, name, target) {
                      return name == target
                    }, this.callbackData)
                  if (!Core.isType(channel, TrackChannel)) {
                    return
                  }
                  
                  var editor = Beans.get(BeanVisuEditorController)
                  var target = editor.store.get("channel-settings-target")
                  var name = editor.store.get("channel-settings-name")
                  var config = editor.store.get("channel-settings-config")
                  if (!Core.isType(target, StoreItem)
                      || !Core.isType(name, StoreItem)
                      || !Core.isType(config, StoreItem)) {
                    return
                  }

                  config.set(JSON.stringify((Core.isType(Struct.get(channel.settings, "serialize"), Callable)
                    ? channel.settings.serialize()
                    : channel.settings), { pretty: true } ))
                  target.set(this.callbackData)
                  name.set(this.callbackData)
                  this.context.controller.channelsMode = "settings"
                },
                callbackData: name,
              },
              remove: {
                sprite: { name: "texture_ve_icon_trash" },
                callback: function() {
                  this.context.removeChannel(this.component.name)
                },
              },
              mute: {
                channelIndex: channel.index,
                spriteOn: { name: "visu_texture_checkbox_muted_on" },
                spriteOff: { name: "visu_texture_checkbox_muted_off" },
                value: channel.muted,
                callback: function(event) {
                  var channel = Beans.get(BeanVisuController).trackService.track.channels
                    .find(function(channel, name, index) {
                      return channel.index == index
                    }, this.channelIndex)
                  
                  if (Optional.is(channel)) {
                    channel.muted = this.value
                  }
                }
              },
            },
          }))
        }),

        ///@param {String} name
        removeChannel: new BindIntent(function(name) {
          var initialized = this.controller.containers
            .get("ve-timeline-events").state
            .get("initialized")
          if (!initialized) {
            return
          }

          Beans.get(BeanVisuController).trackService.track.removeChannel(name)
          this.onInit()
          this.controller.containers.get("ve-timeline-events").onInit()
          
        }),
      },
      "ve-timeline-channel-settings": {
        name: "ve-timeline-channel-settings",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        controller: controller,
        layout: layout.nodes.settings,
        timeline: controller,
        scrollbarY: { align: HAlign.LEFT },
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable")),
        onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
        onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          this.addUIComponents(
            new Array(Struct, [
              new UIComponent({
                name: "ve-timeline-channel-settings-title",
                template: VEComponents.get("property"),
                layout: VELayouts.get("property"),
                config: { 
                  layout: { type: UILayoutType.VERTICAL },
                  label: { text: "Edit channel" },
                },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-name",  
                template: VEComponents.get("text-field"),
                layout: VELayouts.get("text-field"),
                config: { 
                  layout: { 
                    type: UILayoutType.VERTICAL,
                    margin: { top: 4 },
                  },
                  label: { text: "Name" },
                  field: { store: { key: "channel-settings-name" } },
                },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-name-line-h",
                template: VEComponents.get("line-h"),
                layout: VELayouts.get("line-h"),
                config: { layout: { type: UILayoutType.VERTICAL } },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-config-title",  
                template: VEComponents.get("property"),
                layout: VELayouts.get("property"),
                config: { 
                  layout: { type: UILayoutType.VERTICAL },
                  label: { 
                    text: "Config",
                    backgroundColor: VETheme.color.accentShadow,
                  },
                  checkbox: {
                    backgroundColor: VETheme.color.accentShadow,
                  },
                  input: {
                    backgroundColor: VETheme.color.accentShadow,
                  },
                },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-config",
                template: VEComponents.get("text-area"),
                layout: VELayouts.get("text-area"),
                config: { 
                  layout: { type: UILayoutType.VERTICAL },
                  field: { 
                    v_grow: true,
                    w_min: 224,
                    store: { key: "channel-settings-config" },
                    updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
                  },
                },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-config-line-h",
                template: VEComponents.get("line-h"),
                layout: VELayouts.get("line-h"),
                config: { layout: { type: UILayoutType.VERTICAL } },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-apply",
                template: VEComponents.get("button"),
                layout: VELayouts.get("button"),
                config: {
                  label: {
                    font: "font_inter_10_bold",
                    text: "Apply",
                  },
                  callback: function() {
                    this.context.timeline.channelsMode = "list"
                    if (Core.isType(GMTFContext.get(), GMTF)) {
                      if (Core.isType(GMTFContext.get().uiItem, UIItem)) {
                        GMTFContext.get().uiItem.update()
                      }
                      GMTFContext.get().unfocus()
                    }

                    var editor = Beans.get(BeanVisuEditorController)
                    var target = editor.store.get("channel-settings-target")
                    var name = editor.store.get("channel-settings-name")
                    var config = editor.store.get("channel-settings-config")
                    if (!Core.isType(target, StoreItem)
                        || !Core.isType(name, StoreItem)
                        || !Core.isType(config, StoreItem)) {
                      return
                    }
  
                    var channels = Beans.get(BeanVisuController).trackService.track.channels
                    var channel = channels.get(target.get())
                    if (!Core.isType(channel, TrackChannel)) {
                      return
                    }

                    var containers = this.context.controller.containers
                    var channelsContainer = containers.get("ve-timeline-channels")
                    var eventsContainer = containers.get("ve-timeline-events")
                    if (!Core.isType(channelsContainer, UI)
                        || !Core.isType(eventsContainer, UI)) {
                      return
                    }

                    var settings = channel.parseSettings(JSON.parse(config.get()))
                    if (!Core.isType(settings, Struct)) {
                      return
                    }
                    channel.settings = settings

                    if (name.get() != target.get() && !channels.contains(name.get())) {
                      channels.remove(channel.name)
                      channel.name = name.get()
                      channels.set(channel.name, channel)
                      channelsContainer.onInit()
                      eventsContainer.onInit()
                    }
                  },
                  layout: { type: UILayoutType.VERTICAL, height: function() { return 28 } },
                  colorHoverOver: VETheme.color.primaryShadow,
                  colorHoverOut: VETheme.color.primaryDark,
                  backgroundColor: VETheme.color.primaryDark,
                  backgroundMargin: { top: 1, bottom: 2, left: 4, right: 5 },
                  onMouseHoverOver: function(event) {
                    this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
                  },
                  onMouseHoverOut: function(event) {
                    this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
                  },
                },
              }),
              new UIComponent({
                name: "ve-timeline-channel-settings-discard",
                template: VEComponents.get("button"),
                layout: VELayouts.get("button"),
                config: {
                  label: {
                    font: "font_inter_10_bold",
                    text: "Discard",
                  },
                  callback: function() {
                    this.context.timeline.channelsMode = "list"
                    if (Core.isType(GMTFContext.get(), GMTF)) {
                      if (Core.isType(GMTFContext.get().uiItem, UIItem)) {
                        GMTFContext.get().uiItem.update()
                      }
                      GMTFContext.get().unfocus()
                    }

                    var editor = Beans.get(BeanVisuEditorController)
                    var target = editor.store.get("channel-settings-target")
                    var name = editor.store.get("channel-settings-name")
                    var config = editor.store.get("channel-settings-config")
                    if (!Core.isType(target, StoreItem)
                        || !Core.isType(name, StoreItem)
                        || !Core.isType(config, StoreItem)) {
                      return
                    }

                    target.set("")
                    name.set("")
                    config.set("{}")
                  },
                  layout: { type: UILayoutType.VERTICAL, height: function() { return 28 } },
                  colorHoverOver: VETheme.color.deny,
                  colorHoverOut: VETheme.color.denyShadow,
                  backgroundColor: VETheme.color.denyShadow,
                  backgroundMargin: { top: 2, bottom: 3, left: 4, right: 5 },
                  onMouseHoverOver: function(event) {
                    this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
                  },
                  onMouseHoverOut: function(event) {
                    this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
                  },
                },
              })
            ]),
            new UILayout({
              area: this.area,
              width: function() { return this.area.getWidth() },
            })
          )
        }
      },
      "ve-timeline-events": {
        name: "ve-timeline-events",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "chunkService": controller.factoryChunkService(),
          "viewSize": Beans.get(BeanVisuEditorController).store.getValue("timeline-zoom"),
          "speed": 2.0,
          "position": 0,
          "amount": 0,
          "time": null,
          "lines-alpha": 1.0,
          "lines-thickness": 0.2,
          "lines-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          "lines-color-accentLight": ColorUtil.parse(VETheme.color.primaryLight).toGMColor(),
          "bkg-color": ColorUtil.parse(VETheme.color.sideLight).toGMColor(),//ColorUtil.fromHex(VETheme.color.primaryShadow).toGMColor(),
          "initialized": false,
          "initializeChannels": false,
        }),
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.timeline.timeline-events.updateTimer", 60), { loop: Infinity }),
        controller: controller,
        layout: layout.nodes.events,
        lastIndex: 0,
        selectedSprite: SpriteUtil.parse({ 
          name: "texture_selected_event",
          speed: 24,
        }),
        fetchViewHeight: function() {
          return (32 * this.state.get("amount"))
        },
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        updateCustom: function() {
          var store = Beans.get(BeanVisuEditorController).store

          //if (mouse_check_button(mb_right) && keyboard_check(vk_control)) {
          //  var mouseX = device_mouse_x_to_gui(0)
          //  var mouseY = device_mouse_y_to_gui(0)
          //  var areaX = this.area.getX()
          //  var areaY = this.area.getY()
          //  var areaWidth = this.area.getWidth()
          //  var areaHeight = this.area.getHeight()
          //  if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
          //    this.updateTimer.time = this.updateTimer.duration + random(this.updateTimer.duration / 2.0)
          //    this.items.forEach(this.itemMouseDeselectEvent, { data: { x: mouseX, y: mouseY } })
          //  }
          //}

          var trackService = Beans.get(BeanVisuController).trackService
          if (!trackService.isTrackLoaded()) {
            return
          }
          
          var track = trackService.track
          this.state.set("amount", track.channels.size())

          ///@todo refactor
          var time = this.state.get("time") == null 
            ? trackService.time
            : this.state.get("time")
          this.state.set("time", null)

          ///@todo refactor
          var ruler = this.controller.containers.get("ve-timeline-ruler")
          if (Core.isType(ruler, UI)) {
            this.offset.x = -1 * ruler.state.get("camera")
            var mouseXTime = ruler.state.get("mouseXTime")
            if (Optional.is(mouseXTime)) {
              time = mouseXTime
            }
          }

          var chunkService = this.state.get("chunkService")
          this.items = chunkService.update(time).activeChunks

          ///@todo refactor
          var spd = this.area.getWidth() / this.state.get("viewSize")
          var position = spd * time
          if (this.state.get("speed") != spd) {
            chunkService.forEach(function(item, key, container) {
              var timestamp = item.state.get("timestamp")
              var xx = container.getXFromTimestamp(timestamp)
              item.area.setX(xx)
            }, this)
          }
          this.state.set("speed", spd)
          this.state.set("position", position)

          //if ((mouse_check_button(mb_right) && !keyboard_check(vk_control))
          //    || (mouse_check_button(mb_left) && store.getValue("tool") == ToolType.ERASE)) {
          if ((mouse_check_button(mb_right))
              || (mouse_check_button(mb_left) && store.getValue("tool") == ToolType.ERASE)) {
            var mouseX = device_mouse_x_to_gui(0)
            var mouseY = device_mouse_y_to_gui(0)
            var areaX = this.area.getX()
            var areaY = this.area.getY()
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
              this.finishUpdateTimer()
              this.items.forEach(this.itemMouseEraseEvent, { 
                data: {
                  x: mouseX, 
                  y: mouseY, 
                  store: store,
                },
              })
            }
          }

          ///@todo refactor
          if (this.state.get("initialized") == false) {
            var initializeChannels = this.state.get("initializeChannels")
            if (initializeChannels == null) {
              initializeChannels = new Queue(String, trackService.track.channels.keys().getContainer())
              this.state.set("initializeChannels", initializeChannels)
            }

            var container = this
            var initializeChannel = initializeChannels.pop()
            if (initializeChannel != null) {
              var channel = trackService.track.channels.get(initializeChannel)
              channel.events.forEach(function(event, index, acc) {
                ///@description do not use addEvent as TrackEvent already exists
                var uiItem = acc.container.factoryEventUIItem(acc.channel.name, event)
                acc.container.add(uiItem, uiItem.name)
              }, { channel: channel, container: container })
              
              this.finishUpdateTimer()
              return
            }
            
            this.state.get("store").get("timeline-zoom")
              .addSubscriber({ 
                name: this.name,
                callback: function(zoom, context) { 
                  context.state.set("viewSize", zoom)
                },
                data: container,
                overrideSubscriber: true,
              })

            this.state.set("initialized", true)
          }
        },
        update: function() {
          if (this.enableScrollbarY && Struct.get(this.scrollbarY, "isDragEvent")) {
            if (mouse_check_button(mb_left) ///@todo button should be a parameter
              && Optional.is(Struct.get(this, "onMousePressedLeft"))) {
              this.onMousePressedLeft(new Event("MouseOnLeft", { 
                x: MouseUtil.getMouseX(), 
                y: MouseUtil.getMouseY(),
              }))
            } else {
              Struct.set(scrollbarY, "isDragEvent", false)
            }
          }

          if (Optional.is(this.updateCustom)) {
            this.updateCustom()
          }

          if (Optional.is(this.updateArea)) {
            if (Optional.is(this.updateTimer)) {
              if (this.updateTimer.update().finished) {
                this.updateArea()
                if (Optional.is(this.updateItems)) {
                  this.updateItems()
                }
              }
            } else {
              this.updateArea()
              if (Optional.is(this.updateItems)) {
                this.updateItems()
              }
            }
          }
        },
        renderClipboard: new BindIntent(function() {
          var dropEvent = Beans.get(BeanVisuEditorIO).mouse.getClipboard()
          if (!Optional.is(dropEvent)) {
            return
          } else if (Core.isType(dropEvent, Promise) && 
            Struct.get(Struct.get(dropEvent.state, "event"), "name") == "mouse-select-event") {
            this.renderClipboardSelectEvent(dropEvent.state.event)
          } else if (Core.isType(dropEvent, TrackEvent)) {
            this.renderClipboardTrackEvent(dropEvent)
          }
        }),
        renderClipboardSelectEvent: new BindIntent(function(selectEvent) { 
          var index = this.getChannelIndexFromMouseY(MouseUtil.getMouseY())
          if (!Optional.is(index)) {
            index = MouseUtil.getMouseY() < this.area.getY() ? 0 : this.lastIndex
          }
          this.lastIndex = index
          var timestamp = this.getTimestampFromMouseX(MouseUtil.getMouseX())
          var previousX = this.getXFromTimestamp(selectEvent.data.timestampFrom) + this.offset.x
          var nextX = this.getXFromTimestamp(timestamp) + this.offset.x
          var previousY = (selectEvent.data.channelIndexFrom * 32) + this.offset.y + 16
          var nextY = (index * 32) + this.offset.y + 16
          nextY = MouseUtil.getMouseY() - this.area.getY()

          //rectangle: function(beginX, beginY, endX, endY, outline = false, color1 = null, color2 = null, color3 = null, color4 = null, alpha = null) {
          GPU.render.rectangle(previousX, previousY, nextX, nextY, false, c_blue, c_blue, c_blue, c_blue, 0.33)
          GPU.render.rectangle(previousX, previousY, nextX, nextY, true, c_white, c_white, c_white, c_white, 0.33)
        }),
        renderClipboardTrackEvent: new BindIntent(function(trackEvent) {
          var index = this.getChannelIndexFromMouseY(MouseUtil.getMouseY())
          if (!Optional.is(index)) {
            index = MouseUtil.getMouseY() < this.area.getY() ? 0 : this.lastIndex
          }
          this.lastIndex = index

          var icon = Struct.get(trackEvent.data, "icon")
          if (!Core.isType(icon, Struct)) {
            return
          }

          if (!mouse_check_button(mb_left) && !mouse_check_button_released(mb_left)) {
            Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
            Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
            return
          }

          var timestamp = this.getTimestampFromMouseX(MouseUtil.getMouseX())
          var store = Beans.get(BeanVisuEditorController).store
          if (store.getValue("snap")) {
            var bpmSub = store.getValue("bpm-sub")
            var bpm = store.getValue("bpm") * bpmSub
            timestamp = floor(timestamp / (60 / bpm)) * (60 / bpm)
          }

          var previousX = this.getXFromTimestamp(trackEvent.timestamp)
          var nextX = this.getXFromTimestamp(timestamp)
          var eventY = index * 32
          var line = new TexturedLine({ 
            thickness: 2.0,
            alpha: 0.5,
            blend: timestamp - trackEvent.timestamp > 0 ? "#00FF00" : "#FF0000",
          })
          
          var label = new UILabel({
            text: $"{(timestamp - trackEvent.timestamp > 0 ? "+" : "-")} {String.formatTimestampMilisecond(abs(timestamp - trackEvent.timestamp))}",
            font: "font_inter_10_bold",
            color: VETheme.color.textFocus,
            align: { v: VAlign.CENTER, h: HAlign.CENTER },
            outline: true,
            outlineColor: "#000000",
            useScale: false,
          })

          //render previous
          SpriteUtil.parse(icon)
            .setAlpha(0.3)
            .scaleToFillStretched(32, 32)
            .render(
              this.offset.x + previousX,
              this.offset.y + eventY
            )

          //render line
          line.render(
            this.offset.x + previousX + 16,
            this.offset.y + eventY + 16,
            this.offset.x + nextX + 16,
            this.offset.y + eventY + 16 
          )

          //render next
          SpriteUtil.parse(icon)
            .setAlpha(0.8)
            .scaleToFillStretched(32, 32)
            .render(
              this.offset.x + nextX,
              this.offset.y + eventY
            )

          //render timestamp
          label.render(
            16 + this.offset.x + min(previousX, nextX) + (abs(previousX - nextX) / 2),
            16 + this.offset.y + eventY,
          )
        }),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderSurface: function() {
          var trackEvent = Beans.get(BeanVisuEditorIO).mouse.getClipboard()

          // background
          var color = this.state.getDefault("background-color", c_black)
          var alpha = this.state.getDefault("background-alpha", 0.0)
          GPU.render.clear(color, alpha)

          var offsetX = this.offset.x
          var offsetY = this.offset.y
          var areaWidth = this.area.getWidth()
          var areaHeight = this.area.getHeight()
          var thickness = this.state.get("lines-thickness")
          var alpha = this.state.get("lines-alpha")
          var color = this.state.get("lines-color")
          var colorAccent = this.state.get("lines-color-accentLight")
          var bkgColor = this.state.get("bkg-color")
          var editor = Beans.get(BeanVisuEditorController)
          var bpm = editor.store.getValue("bpm")
          var bpmCount = editor.store.getValue("bpm-count")
          var bpmSub = editor.store.getValue("bpm-sub")
          var bpmWidth = ((this.area.getWidth() / this.state.get("viewSize")) * 60) / bpm
          var bpmSize = ceil(this.area.getWidth() / bpmWidth)

          // background
          var bkgStartIndex = ((offsetY div 32) mod 2 != 0) ? 1 : 0
          var bkgSize = this.state.get("amount")
          if (areaWidth > 0) {
            for (var bkgIndex = bkgStartIndex; bkgIndex < bkgSize; bkgIndex += 2) {
              var bkgY = (offsetY mod 32) + (bkgIndex * 32)
              draw_sprite_ext(texture_white, 0.0, 0, bkgY, areaWidth / 64, 0.5, 0.0, bkgColor, 1.0)
            }
          }

          var collide = this.area.collide(MouseUtil.getMouseX(), MouseUtil.getMouseY())
          var brushSprite = editor.brushToolbar.store.getValue("brush-sprite")
          if (collide && Optional.is(brushSprite)) {
            var brushTimestamp = this.getTimestampFromMouseX(MouseUtil.getMouseX())
            if (editor.store.getValue("snap") || keyboard_check(vk_control)) {
              brushTimestamp = floor(brushTimestamp / (60 / (bpm * bpmSub))) * (60 / (bpm * bpmSub))
            }

            var channelIndex = this.getChannelIndexFromMouseY(MouseUtil.getMouseY())
            if (!Optional.is(channelIndex)) {
              channelIndex = MouseUtil.getMouseY() < this.area.getY() ? 0 : this.lastIndex
            }

            brushSprite.setAlpha(0.5).scaleToFit(32, 32).render(
              this.getXFromTimestamp(brushTimestamp) + this.offset.x,
              (32 * channelIndex) + this.offset.y
            )
          }

          // items
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.surfaceTick.previous = this.updateTimer.finished
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY

          // lines
          var linesSize = this.state.get("amount") + 1
          if (linesSize <= 1.0) {
            return this
          }

          var _alpha = draw_get_alpha()
          draw_set_alpha(alpha)
          for (var linesIndex = 0; linesIndex < linesSize; linesIndex++) {
            var linesY = (offsetY mod 32) + (linesIndex * 32)
            draw_line_color(0, linesY, areaWidth, linesY, color, color)
            //GPU.render.texturedLine(0, linesY, areaWidth, linesY, thickness, alpha, color)
          }
          draw_set_alpha(_alpha)

          /// bpm
          var bpmX = 0
          var bpmY = round(clamp((linesSize - 1) * 32, 0, areaHeight))
          var _thickness = thickness
          var bpmCountIndex = floor(abs(this.offset.x) / bpmWidth)
          _alpha = draw_get_alpha()
          var isMain = false
          draw_set_alpha(alpha * 0.66)
          if (bpmSub > 1) {
            var bpmSubLength = round(bpmWidth / bpmSub)
            for (var bpmIndex = 0; bpmIndex <= bpmSize; bpmIndex++) {
              bpmX = floor((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              _thickness = bpmCount > 0 && bpmCountIndex mod bpmCount == 0 ? thickness * 4 : thickness
              isMain = bpmCount > 0 && bpmCountIndex mod bpmCount == 0
              bpmCountIndex++
              if (isMain) {
                draw_set_alpha(alpha)
                draw_line_color(bpmX, 0, bpmX, bpmY, colorAccent, colorAccent)
                draw_set_alpha(alpha * 0.66)
              } else {
                draw_line_color(bpmX, 0, bpmX, bpmY, color, color)
              }
            }

            draw_set_alpha(alpha * 0.25)
            for (var bpmIndex = 0; bpmIndex <= bpmSize; bpmIndex++) {
              bpmX = floor((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              for (var bpmSubIndex = 1; bpmSubIndex < bpmSub; bpmSubIndex++) {
                draw_line_color(
                  bpmX + (bpmSubIndex * bpmSubLength), 
                  0, 
                  bpmX + (bpmSubIndex * bpmSubLength), 
                  bpmY,
                  color, 
                  color
                )
              }
            }
          } else {
            for (var bpmIndex = 0; bpmIndex <= bpmSize; bpmIndex++) {
              bpmX = round((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              _thickness = bpmCount > 0 && bpmCountIndex mod bpmCount == 0 ? thickness * 4 : thickness
              bpmCountIndex++
              //GPU.render.texturedLine(bpmX, 0, bpmX, bpmY, _thickness, alpha, color)
              if (isMain) {
                draw_set_alpha(alpha)
                draw_line_color(bpmX, 0, bpmX, bpmY, colorAccent, colorAccent)
                draw_set_alpha(alpha * 0.66)
              } else {
                draw_line_color(bpmX, 0, bpmX, bpmY, color, color)
              }
            }
          }
          draw_set_alpha(_alpha)

          this.renderClipboard()

          var context = this
          var controller = Beans.get(BeanVisuEditorController)
          var selectedEvent = controller.store.getValue("selected-event")
          var selectedEvents = controller.store.getValue("selected-events")
          if (Optional.is(selectedEvent) && Optional.is(selectedEvents)) {
            selectedEvents.forEach(function(selectedEvent, key, acc) {
              var context = acc.context
              var index = acc.index
              var xx = context.getXFromTimestamp(selectedEvent.data.timestamp) + context.offset.x
              var yy = context.getYFromChannelName(selectedEvent.channel) + context.offset.y
              context.selectedSprite
                .setBlend(key == acc.name ? acc.color : c_white)
                .setAnimate(index == 0)
                .render(xx, yy)
                .setBlend(c_white)
                .setAnimate(true)
              acc.index = index + 1
            }, { 
              context: context, 
              index: 0, 
              name: selectedEvent.name, 
              color: c_lime,//selectedEvents.size() > 1 ? c_lime : c_white,
            })
          }

          DeltaTime.deltaTime = delta
        },
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable"))),
        render: function() {
          var displayService = Beans.get(BeanVisuController).displayService
          var collide = this.area.collide(MouseUtil.getMouseX(), MouseUtil.getMouseY())
          var cursor = displayService.getCursor()
          if (collide) {
            var tool = Beans.get(BeanVisuEditorController).store.getValue("tool")
            switch (tool) {
              case ToolType.SELECT:
                displayService.setCursor(Cursor.NONE)
                cursor_sprite = texture_ve_cursor_tool_select
                break
              case ToolType.CLONE:
                displayService.setCursor(Cursor.NONE)
                cursor_sprite = texture_ve_cursor_tool_clone
                break
              case ToolType.BRUSH:
                displayService.setCursor(Cursor.NONE)
                cursor_sprite = texture_ve_cursor_tool_brush
                break
              case ToolType.ERASE:
                displayService.setCursor(Cursor.NONE)
                cursor_sprite = texture_ve_cursor_tool_erase
                break
            }
          } else {
            if (cursor == Cursor.NONE) {
              displayService.setCursor(Cursor.DEFAULT)
            }

            if (cursor_sprite != -1) {
              cursor_sprite = -1
            }
          }

          this.renderDefaultScrollable()
        },
        onInit: function() {
          this.deselect()
          this.scrollbarY = null
          this.lastIndex = 0
          this.state.set("amount", 0)
          this.state.set("initialized", false)
          this.state.set("initializeChannels", null)
          this.state.set("chunkService", this.controller.factoryChunkService())
          this.updateCustom()
          this.updateArea()
        },
        onDestroy: function() {
          this.state.get("store")
            .get("timeline-zoom")
            .removeSubscriber(this.name)
        },
        _onMouseWheelUp: new BindIntent(Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY"))),
        _onMouseWheelDown: new BindIntent(Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY"))),
        onMouseWheelUp: function(event) {
          this._onMouseWheelUp(event)
          this.finishUpdateTimer()

          var channels = this.controller.containers.get("ve-timeline-channels")
          if (Optional.is(channels)) {
            channels.offset.y = this.offset.y
            channels.finishUpdateTimer()
          }
        },
        onMouseWheelDown: function(event) {
          this._onMouseWheelDown(event)
          this.finishUpdateTimer()

          var channels = this.controller.containers.get("ve-timeline-channels")
          if (Optional.is(channels)) {
            channels.offset.y = this.offset.y
            channels.finishUpdateTimer()
          }
        },
        handleMouseDropSelectEvent: new BindIntent(function(selectEvent) {
          var timestampFrom = selectEvent.data.timestampFrom
          var channelIndexFrom = selectEvent.data.channelIndexFrom
          var timestampTo = this.getTimestampFromMouseX(MouseUtil.getMouseX())
          var channelIndexTo = this.getChannelIndexFromMouseY(MouseUtil.getMouseY())
          if (!Optional.is(channelIndexTo)) {
            channelIndexTo = MouseUtil.getMouseY() < this.area.getY() ? 0 : this.lastIndex
          }

          var from = {
            channelIndex: min(channelIndexFrom, channelIndexTo),
            timestamp: min(timestampFrom, timestampTo),
          }
          var to = {
            channelIndex: max(channelIndexFrom, channelIndexTo),
            timestamp: max(timestampFrom, timestampTo),
          }

          var track = Beans.get(BeanVisuController).trackService.track
          var channels = track.channels.filter(function(channel, name, acc) {
            return channel.index >= acc.from && channel.index <= acc.to
          }, {
            from: from.channelIndex,
            to: to.channelIndex,
          })

          this.deselect()

          var width = (this.state.get("viewSize") * 32) / this.area.getWidth()
          this.items.forEach(function(item, key, acc) {
            var timestamp = item.state.get("timestamp")
            if ((timestamp < acc.from 
                && timestamp + acc.width < acc.from) 
                || timestamp > acc.to) {
              return
            }

            var channel = item.state.get("channel")
            if (!acc.channels.contains(channel)) {
              return
            }

            acc.select({
              name: item.name,
              channel: channel,
              data: item.state.get("event"),
            }, true)
          }, {
            from: from.timestamp,
            to: to.timestamp,
            channels: channels,
            select: this.select,
            width: width,
          })
        }),
        handleMouseDropTrackEvent: new BindIntent(function(event, trackEvent) {
          var sourceChannel = Struct.get(trackEvent, "channelName")
          var track = Beans.get(BeanVisuController).trackService.track 
          var store = Beans.get(BeanVisuEditorController).store
          if (!track.channels.contains(sourceChannel)) {
            Logger.warn("VETimeline", $"Track does not contain the source channel '{sourceChannel}'")
            return
          }

          var targetChannel = this.getChannelNameFromMouseY(event.data.y)
          if (!Optional.is(targetChannel)) {
            var collection = this.controller.containers
              .get("ve-timeline-channels").collection
            targetChannel = collection
              .findKeyByIndex(collection.size() - 1)
            
            if (!Optional.is(targetChannel)) {
              Logger.warn("VETimeline", "Unable to find targetChannel")
              return
            }
          }

          var selectedEvents = store.getValue("selected-events")
            .map(function(selectedEvent, key) { return selectedEvent })
          var contextEvent = selectedEvents.get(trackEvent.eventName)
          if (!Optional.is(contextEvent)) {
            contextEvent = {
              name: trackEvent.eventName,
              channel: trackEvent.channelName,
              data: trackEvent,
            }
            selectedEvents.add(contextEvent, trackEvent.eventName)
          }

          var trackEventConfig = trackEvent.serialize()
          var timestamp = trackEventConfig.timestamp
          trackEventConfig.timestamp = this.getTimestampFromMouseX(event.data.x)
          if (store.getValue("snap") || keyboard_check(vk_control)) {
            var bpmSub = store.getValue("bpm-sub")
            var bpm = store.getValue("bpm") * bpmSub
            trackEventConfig.timestamp = floor(trackEventConfig.timestamp / (60 / bpm)) * (60 / bpm)
          }

          var removeTransactions = selectedEvents.map(function(selectedEvent, key, context) {
            var transactionService = context.controller.transactionService
            var sizeBefore = transactionService.applied.size()
            context.removeEvent(selectedEvent.channel, selectedEvent.name)
            Assert.isTrue(sizeBefore == transactionService.limit 
              || sizeBefore == transactionService.applied.size() - 1, 
              "different removeEvent applied size was expected")

            var removeTransaction = transactionService.peekApplied()
            Assert.isTrue(Core.isType(removeTransaction, Transaction) 
              && removeTransaction.name == "Remove event"
              && removeTransaction == transactionService.applied.pop(),
              "Transaction name must be 'Remove event'")

            return removeTransaction
          }, this)

          var context = this
          var newEvents = new Map(String, Struct)
          var addTransactions = selectedEvents.map(function(selectedEvent, key, acc) {
            var channel = acc.context.getMovedChannelName(acc.sourceChannel, acc.targetChannel, selectedEvent.channel)
            var transactionService = acc.context.controller.transactionService
            var trackEventConfig = selectedEvent.data.serialize()
            trackEventConfig.timestamp = clamp(trackEventConfig.timestamp + acc.offset, 0.0, acc.duration - 0.2)
            var sizeBefore = transactionService.applied.size()
            var uiItem = acc.context.addEvent(channel, new TrackEvent(trackEventConfig, {
              handlers: Beans.get(BeanVisuController).trackService.handlers,
            }), selectedEvent.name)

            var contextEvent = acc.contextEvent
            if (contextEvent.name == selectedEvent.name) {
              contextEvent.name = uiItem.name
              contextEvent.channel = channel
              contextEvent.data = uiItem.state.get("event")
            }

            Assert.isTrue(sizeBefore == transactionService.limit 
              || sizeBefore == transactionService.applied.size() - 1,
              "different addEvent applied size was expected")
            var addTransaction = transactionService.peekApplied()
            Assert.isTrue(Core.isType(addTransaction, Transaction) 
              && addTransaction.name == "Add event"
              && addTransaction == transactionService.applied.pop(), 
              "Transaction name must be 'Add event'")

            acc.newEvents.add({
              name: uiItem.name,
              channel: channel,
              data: uiItem.state.get("event")
            }, uiItem.name)

            return addTransaction
          }, {
            context: context,
            offset: trackEventConfig.timestamp - timestamp,
            contextEvent: contextEvent,
            sourceChannel: sourceChannel,
            targetChannel: targetChannel,
            newEvents: newEvents,
            duration: Beans.get(BeanVisuController).trackService.duration,
          })

          var transaction = new Transaction({
            name: "Move event",
            data: {
              add: addTransactions,
              remove: removeTransactions,
              name: contextEvent.name,
              restoreName: function(name) {
                var store = Beans.get(BeanVisuEditorController).store
                var selectedEvent = store.getValue("selected-event")
                if (Optional.is(selectedEvent) 
                  && selectedEvent.name != name) {
                  var foundEvent = store.getValue("selected-events")
                    .find(function(event, key, name) {
                      return event.name == name
                    }, name)
                  if (Optional.is(foundEvent)) {
                    store.get("selected-event").set(foundEvent)
                  }
                }
              },
            },
            apply: function() {
              for (var index = 0; index < this.data.add.size(); index++) {
                this.data.remove.get(this.data.remove.keys().get(index)).apply()
                this.data.add.get(this.data.add.keys().get(index)).apply()
              }

              this.data.restoreName(this.data.name)
              return this
            },
            rollback: function() {
              for (var index = 0; index < this.data.add.size(); index++) {
                this.data.add.get(this.data.add.keys().get(index)).rollback()
                this.data.remove.get(this.data.remove.keys().get(index)).rollback()
              }

              this.data.restoreName(this.data.name)
              return this
            }
          })

          var transactionService = this.controller.transactionService
          transactionService.applied.push(transaction)

          ///@description select
          store.getValue("selected-events").clear()
          newEvents.forEach(function(newEvent, key, name) {
            var store = Beans.get(BeanVisuEditorController).store
            if (key == name) {
              store.get("selected-event").set(newEvent)
            }
            store.getValue("selected-events").add(newEvent, key)
          }, contextEvent.name)

          var inspector = Beans.get(BeanVisuEditorController).uiService.find("ve-event-inspector-properties")
          if (Optional.is(inspector)) {
            inspector.finishUpdateTimer()
          }
        }),
        onMouseDropLeft: function(event) {
          this.finishUpdateTimer()

          var mouse = Beans.get(BeanVisuEditorIO).mouse
          var dropEvent = mouse.getClipboard()
          mouse.clearClipboard()
          if (Core.isType(dropEvent, Promise)) {
            dropEvent.fullfill()
          } else if (Core.isType(dropEvent, TrackEvent)) {
            this.handleMouseDropTrackEvent(event, dropEvent)
          } else if (Core.isType(Struct.get(dropEvent, "drop"), Callable)) {
            dropEvent.drop()
          }
        },

        onMousePressedLeft: function(event) {
          this.finishUpdateTimer()
        },

        onMousePressedRight: function(event) {
          this.finishUpdateTimer()
        },
        
        onMouseReleasedLeft: function(event) {
          try {
            this.finishUpdateTimer()
            
            var initialized = this.controller.containers
              .get("ve-timeline-events").state
              .get("initialized")
            if (!initialized) {
              return false
            }
            
            var store = Beans.get(BeanVisuEditorController).store
            var tool = store.getValue("tool")
            switch (tool) {
              case ToolType.SELECT:
                ///@description deselect
                this.deselect()
                break
              case ToolType.BRUSH:
                var brush = Beans.get(BeanVisuEditorController).brushToolbar.store
                  .getValue("brush")
                if (!Optional.is(brush)) {
                  //Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                  //  { message: "No brush has been selected!" }))
                  break
                }

                var trackEvent = this.factoryTrackEventFromEvent(event)
                var channel = this.getChannelNameFromMouseY(event.data.y)
                var uiItem = this.addEvent(channel, trackEvent)
  
                ///@description select
                this.select({
                  name: uiItem.name,
                  channel: channel,
                  data: uiItem.state.get("event"),
                }, keyboard_check(vk_control))

                var inspector = Beans.get(BeanVisuEditorController).uiService.find("ve-event-inspector-properties")
                if (Optional.is(inspector)) {
                  inspector.finishUpdateTimer()
                }
                
                break
              case ToolType.CLONE:
                var selectedEvent = store.getValue("selected-event")
                if (!Optional.is(selectedEvent)) {
                  break
                }

                var trackEvent = selectedEvent.data
                if (!Core.isType(trackEvent, TrackEvent)) {
                  break
                }

                var sourceChannel = selectedEvent.channel
                var track = Beans.get(BeanVisuController).trackService.track 
                if (!track.channels.contains(sourceChannel)) {
                  Logger.warn("VETimeline", $"Track does not contain the source channel '{sourceChannel}'")
                  break
                }

                var targetChannel = this.getChannelNameFromMouseY(event.data.y)
                if (!Optional.is(targetChannel)) {
                  var collection = this.controller.containers
                    .get("ve-timeline-channels").collection
                  targetChannel = collection
                    .findKeyByIndex(collection.size() - 1)
                  
                  if (!Optional.is(targetChannel)) {
                    Logger.warn("VETimeline", "Unable to find targetChannel")
                    break
                  }
                }

                var selectedEvents = store.getValue("selected-events")
                  .map(function(selectedEvent, key) { return selectedEvent })
                var contextEvent = selectedEvents.get(selectedEvent.name)
                if (!Optional.is(contextEvent)) {
                  contextEvent = {
                    name: selectedEvent.name,
                    channel: selectedEvent.channel,
                    data: trackEvent,
                  }
                  selectedEvents.add(contextEvent)
                }

                var trackEventConfig = trackEvent.serialize()
                var timestamp = trackEventConfig.timestamp
                trackEventConfig.timestamp = this.getTimestampFromMouseX(event.data.x)
                if (store.getValue("snap") || keyboard_check(vk_control)) {
                  var bpmSub = store.getValue("bpm-sub")
                  var bpm = store.getValue("bpm") * bpmSub
                  trackEventConfig.timestamp = floor(trackEventConfig.timestamp / (60 / bpm)) * (60 / bpm)
                }

                var context = this
                var newEvents = new Map(String, Struct)
                var addTransactions = selectedEvents.map(function(selectedEvent, key, acc) {
                  var channel = acc.context.getMovedChannelName(acc.sourceChannel, acc.targetChannel, selectedEvent.channel)
                  var transactionService = acc.context.controller.transactionService
                  var trackEventConfig = selectedEvent.data.serialize()
                  trackEventConfig.timestamp = clamp(trackEventConfig.timestamp + acc.offset, 0.0, acc.duration - 0.2)
                  var sizeBefore = transactionService.applied.size()
                  var uiItem = acc.context.addEvent(channel, new TrackEvent(trackEventConfig, {
                    handlers: Beans.get(BeanVisuController).trackService.handlers,
                  }))

                  var contextEvent = acc.contextEvent
                  if (contextEvent.name == selectedEvent.name) {
                    contextEvent.name = uiItem.name
                    contextEvent.channel = channel
                    contextEvent.data = uiItem.state.get("event")
                  }

                  Assert.isTrue(sizeBefore == transactionService.limit 
                    || sizeBefore == transactionService.applied.size() - 1,
                    "different addEvent applied size was expected")
                  var addTransaction = transactionService.peekApplied()
                  Assert.isTrue(Core.isType(addTransaction, Transaction) 
                    && addTransaction.name == "Add event"
                    && addTransaction == transactionService.applied.pop(), 
                    "Transaction name must be 'Add event'")

                  acc.newEvents.add({
                    name: uiItem.name,
                    channel: channel,
                    data: uiItem.state.get("event")
                  }, uiItem.name)

                  return addTransaction
                }, {
                  context: context,
                  offset: trackEventConfig.timestamp - timestamp,
                  sourceChannel: sourceChannel,
                  targetChannel: targetChannel,
                  newEvents: newEvents,
                  contextEvent: contextEvent,
                  duration: Beans.get(BeanVisuController).trackService.duration,
                })

                var transaction = new Transaction({
                  name: "Clone event",
                  data: {
                    add: addTransactions,
                    name: contextEvent.name,
                    restoreName: function(name) {
                      var store = Beans.get(BeanVisuEditorController).store
                      var selectedEvent = store.getValue("selected-event")
                      if (Optional.is(selectedEvent) 
                        && selectedEvent.name != name) {
                        var foundEvent = store.getValue("selected-events")
                          .find(function(event, key, name) {
                            return event.name == name
                          }, name)
                        if (Optional.is(foundEvent)) {
                          store.get("selected-event").set(foundEvent)
                        }
                      }
                    },
                  },
                  apply: function() {
                    this.data.add.forEach(function(transaction) { transaction.apply() })
                    this.data.restoreName(this.data.name)
                    return this
                  },
                  rollback: function() {
                    this.data.add.forEach(function(transaction) { transaction.rollback() })
                    this.data.restoreName(this.data.name)
                    return this
                  }
                })

                var transactionService = this.controller.transactionService
                transactionService.applied.push(transaction)

                ///@description select
                store.getValue("selected-events").clear()
                newEvents.forEach(function(newEvent, key, name) {
                  var store = Beans.get(BeanVisuEditorController).store
                  if (key == name) {
                    store.get("selected-event").set(newEvent)
                  }
                  store.getValue("selected-events").add(newEvent, key)
                }, contextEvent.name)

                var inspector = Beans.get(BeanVisuEditorController).uiService.find("ve-event-inspector-properties")
                if (Optional.is(inspector)) {
                  inspector.finishUpdateTimer()
                }
            
                break
            }
          } catch (exception) {
            var message = $"onMouseReleasedLeft exception: {exception.message}"
            Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
            Logger.error("VETimeline", message)
          }
        },

        onMouseReleasedRight: function(event) {
          this.finishUpdateTimer()
          
          var initialized = this.controller.containers
            .get("ve-timeline-events").state
            .get("initialized")
          if (!initialized) {
            return false
          }

          var store = Beans.get(BeanVisuEditorController).store
          var tool = store.getValue("tool")
          switch (tool) {
            case ToolType.SELECT:
            case ToolType.BRUSH:
            case ToolType.CLONE:
            case ToolType.ERASE:
              ///@description deselect
              if (!keyboard_check(vk_control)) {
                this.deselect() 
              }
              break
          }
        },

        onMouseDragLeft: function(event) {
          var mouse = Beans.get(BeanVisuEditorIO).mouse
          var name = Struct.get(mouse.getClipboard(), "name")
          if (name == "resize_accordion"
              || name == "resize_brush_toolbar"
              || name == "resize_brush_inspector"
              || name == "resize_template_inspector"
              || name == "resize_timeline"
              || name == "resize_horizontal"
              || name == "resize_template_title") {
            return
          }

          var store = Beans.get(BeanVisuEditorController).store
          var tool = store.getValue("tool")
          if (tool != ToolType.SELECT) {
            return
          }

          var timestampFrom = this.getTimestampFromMouseX(event.data.x)
          var channelIndexFrom = this.getChannelIndexFromMouseY(event.data.y)
          if (!Optional.is(channelIndexFrom)) {
            return
          }

          var context = this
          Beans.get(BeanVisuEditorIO).mouse.setClipboard(new Promise()
            .setState({
              handler: context.handleMouseDropSelectEvent,
              event: new Event("mouse-select-event", {
                timestampFrom: timestampFrom,
                channelIndexFrom: channelIndexFrom,
              }),
            })
            .whenSuccess(function() {
              this.state.handler(this.state.event)
            }))
        },

        ///@param {UIItem} item
        ///@param {String} key
        ///@param {Event} event
        itemMouseEraseEvent: new BindIntent(function(item, key, event) {
          if (!item.collide(event)) {
            return
          }

          var channelName = this.getChannelNameFromMouseY(event.data.y)
          if (Optional.is(channelName)) {
            this.removeEvent(channelName, item.name)
          }

          var selected = event.data.store.getValue("selected-event")
          if (Optional.is(selected) && selected.name == item.name) {
            event.data.store.get("selected-event").set(null)
          }
        }),

        ///@param {UIItem} item
        ///@param {String} key
        ///@param {Event} event
        itemMouseDeselectEvent: new BindIntent(function(item, key, event) {
          if (!item.collide(event)) {
            return
          }

          ///@description deselect
          item.context.deselect({ name: item.name })
        }),
    
        ///@param {Number} timestamp
        ///@return {Number}
        getXFromTimestamp: new BindIntent(function(timestamp) {
          return (this.area.getWidth() / this.state.get("viewSize")) * timestamp
        }),

        ///@param {String} channel
        ///@return {Number}
        getYFromChannelName: new BindIntent(function(channel) {
          return this.controller.containers
            .get("ve-timeline-channels").collection
            .get(channel).index * 32 
        }),

        ///@param {Number} mouseX
        ///@return {Number}
        getTimestampFromMouseX: new BindIntent(function(mouseX) {
          return (mouseX - this.area.getX() - this.offset.x) 
            / (this.area.getWidth() / this.state.get("viewSize"))
        }),

        ///@param {Number} mouseY
        ///@return {?String}
        getChannelNameFromMouseY: new BindIntent(function(mouseY) {
          var channelName = this.controller.containers
            .get("ve-timeline-channels").collection
            .findKeyByIndex((mouseY - this.area.getY() - this.offset.y) div 32)
          return Optional.is(channelName) ? channelName : null
        }),

        ///@param {Number} mouseY
        ///@return {?Number}
        getChannelIndexFromMouseY: new BindIntent(function(mouseY) {
          var channel = this.controller.containers
            .get("ve-timeline-channels").collection
            .findByIndex((mouseY - this.area.getY() - this.offset.y) div 32)
          return Optional.is(channel) ? channel.index : null
        }),

        ///@param {Number} timestamp
        ///@param {VEBrushTemplate} template
        ///@return {TrackEvent}
        factoryTrackEventFromBrushTemplate: new BindIntent(function(timestamp, template) {
          return new TrackEvent({
            "timestamp": timestamp,
            "callable": template.type,
            "data": Struct.appendUnique(
              {
                "icon": {
                  name: template.texture,
                  blend: template.color,
                },
              }, 
              template.properties
            ),
          },
          { handlers: Beans.get(BeanVisuController).trackService.handlers })
        }),

        ///@param {Event} event
        ///@return {TrackEvent}
        factoryTrackEventFromEvent: new BindIntent(function(event) {
          var timestamp = this.getTimestampFromMouseX(event.data.x)
          var store = Beans.get(BeanVisuEditorController).store
          if (store.getValue("snap") || keyboard_check(vk_control)) {
            var bpmSub = store.getValue("bpm-sub")
            var bpm = store.getValue("bpm") * bpmSub
            timestamp = floor(timestamp / (60 / bpm)) * (60 / bpm)
          }
          
          var brushToolbar = Beans.get(BeanVisuEditorController).brushToolbar
          return this.factoryTrackEventFromBrushTemplate(timestamp, brushToolbar.store
            .getValue("brush")
            .toTemplate())
        }),

        ///@param {String} channelName
        ///@param {TrackEvent} event
        ///@param {?String} [_name]
        ///@return {UIItem}
        factoryEventUIItem: new BindIntent(function(channelName, event, _name = null) { 
          var _x = this.getXFromTimestamp(event.timestamp) 
          var key = this.items.generateKey(event.timestamp * (100 + random(1000000) + random(100000)))
          var name = Core.isType(_name, String) ? _name : $"channel_{channelName}_event_{key}"
          var component = this.controller.containers
            .get("ve-timeline-channels").collection
            .get(channelName)

          return UIButton(
            name,
            {
              area: { x: _x, width: 32, height: 32 },
              state: new Map(String, any, {
                "timestamp": event.timestamp,
                "event": event,
                "channel": channelName,
              }),
              component: component,
              sprite: Struct.getIfType(event.data, "icon", Struct, { name: "texture_missing" }),
              updateArea: function() {
                this.area.setY(this.component.index * this.area.getHeight())
              },
              onMouseDragLeft: function(event) {
                var mouse = Beans.get(BeanVisuEditorIO).mouse
                var name = Struct.get(mouse.getClipboard(), "name")
                if (name == "resize_accordion"
                    || name == "resize_brush_toolbar"
                    || name == "resize_brush_inspector"
                    || name == "resize_template_inspector"
                    || name == "resize_timeline"
                    || name == "resize_horizontal"
                    || name == "resize_template_title") {
                  return
                }
                
                var store = Beans.get(BeanVisuEditorController).store
                var tool = store.getValue("tool")
                if (tool != ToolType.SELECT) {
                  return
                }

                var channelName = this.state.get("channel")
                if (!Optional.is(channelName)) {
                  return
                }
                
                var trackEvent = this.state.get("event")
                if (!Core.isType(trackEvent, TrackEvent)) {
                  return
                }

                Struct.set(trackEvent, "eventName", this.name)
                Struct.set(trackEvent, "channelName", channelName)
                Beans.get(BeanVisuEditorIO).mouse.setClipboard(trackEvent)

                this.context.select({
                  name: this.name,
                  channel: channelName,
                  data: trackEvent,
                }, !keyboard_check(vk_control))
              },
              onMouseReleasedLeft: function(event) {
                var context = this
                var trackEvent = this.state.get("event")
                var channel = this.state.get("channel")
                if (!Core.isType(trackEvent, TrackEvent)
                  || !Core.isType(channel, String)) {
                  return
                }

                var initialized = this.context.controller.containers
                  .get("ve-timeline-events").state
                  .get("initialized")
                if (!initialized) {
                  return false
                }
                
                var store = Beans.get(BeanVisuEditorController).store
                var tool = store.getValue("tool")
                switch (tool) {
                  case ToolType.ERASE:
                    var channelName = this.context.getChannelNameFromMouseY(event.data.y)
                    if (Optional.is(channelName)) {
                      this.context.removeEvent(channelName, this.name)
                    }

                    var selected = store.getValue("selected-event")
                    if (Optional.is(selected) && selected.name == this.name) {
                      store.get("selected-event").set(null)
                    }
                    break
                  case ToolType.BRUSH:

                  case ToolType.CLONE:
                  case ToolType.SELECT:
                    ///@description select
                    context.context.select({
                      name: context.name,
                      channel: channel,
                      data: trackEvent,
                    }, keyboard_check(vk_control))
                    
                    var inspector = Beans.get(BeanVisuEditorController).uiService.find("ve-event-inspector-properties")
                    if (Optional.is(inspector)) {
                      inspector.finishUpdateTimer()
                    }

                    break
                }
              },
              onMousePressedRight: function(event) {
                var channelName = this.context.getChannelNameFromMouseY(event.data.y)
                if (Optional.is(channelName) && !keyboard_check(vk_control)) {
                  this.context.removeEvent(channelName, this.name)
                }

                this.context.deselect({ name: this.name })
              },
            }
          )
        }),

        ///@param {String} channelName
        ///@param {TrackEvent} event
        ///@return {?UIItem}
        addEvent: new BindIntent(function(channelName, event, _key = null) {
          if (!Core.isType(event, TrackEvent)) {
            return null
          }

          if (!Core.isType(Beans.get(BeanVisuController).trackService.track, Track)) {
            throw new Exception("Load track before adding event on timeline")
          }

          var context = this
          var transaction = new Transaction({
            name: "Add event",
            data: {
              context: context,
              channelName: channelName,
              name: name,
              uiItem: null,
              event: event,
              key: _key,
            },
            apply: function() {
              var trackEvent = this.data.event
              var track = Beans.get(BeanVisuController).trackService.track
              if (!Core.isType(track, Track)) {
                Logger.warn("VETimeline", "Load track before adding event on timeline")
                return this
              }
      
              var uiItem = this.data.context.factoryEventUIItem(this.data.channelName, trackEvent, this.data.key)
              track.addEvent(this.data.channelName, trackEvent)
              this.data.context.add(uiItem, uiItem.name)

              this.data.key = uiItem.name
              this.data.name = uiItem.name
              this.data.uiItem = uiItem
              this.data.event = trackEvent
              this.data.context.finishUpdateTimer()

              ///@description select
              this.data.context.select({
                name: uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              }, keyboard_check(vk_control))

              return this
            },
            rollback: function() {
              Beans.get(BeanVisuController).trackService.track
                .removeEvent(this.data.channelName, this.data.event)
              this.data.context.remove(this.data.uiItem.name)
              this.data.key = this.data.uiItem.name

              ///@description deselect
              this.data.context.deselect({
                name: this.data.uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              })

              this.data.context.finishUpdateTimer()

              return this
            },
          })

          return this.controller.transactionService.add(transaction).peekApplied().data.uiItem
        }),

        ///@param {String} channel
        ///@param {String} name
        removeEvent: new BindIntent(function(channelName, name) {
          var editor = this.controller.editor
          var uiItem = this.items.get(name)
          var event = uiItem.state.get("event")
          if (!Core.isType(uiItem, UIItem)
            || !Core.isType(event, TrackEvent)) {
            return
          }

          var context = this
          var transaction = new Transaction({
            name: "Remove event",
            data: {
              context: context,
              channelName: channelName,
              name: name,
              uiItem: uiItem,
              event: event,
              key: name,
            },
            apply: function() {
              Beans.get(BeanVisuController).trackService.track
                .removeEvent(this.data.channelName, this.data.event)
              this.data.context.remove(this.data.uiItem.name)
              this.data.key = this.data.uiItem.name

              ///@description deselect
              this.data.context.deselect({
                name: this.data.uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              })

              this.data.context.finishUpdateTimer()

              return this
            },
            rollback: function() {
              var trackEvent = this.data.event
              var track = Beans.get(BeanVisuController).trackService.track
              if (!Core.isType(track, Track)) {
                Logger.warn("VETimeline", "Load track before adding event on timeline")
                return this
              }
      
              var uiItem = this.data.context.factoryEventUIItem(this.data.channelName, trackEvent, this.data.key)
              track.addEvent(this.data.channelName, trackEvent)
              this.data.context.add(uiItem, uiItem.name)

              this.data.key = uiItem.name
              this.data.name = uiItem.name
              this.data.uiItem = uiItem
              this.data.event = trackEvent
              
              this.data.context.finishUpdateTimer()

              ///@description select
              this.data.context.select({
                name: uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              }, keyboard_check(vk_control))

              return this
            },
          })

          this.controller.transactionService.add(transaction)
        }),

        ///@param {String} channel
        ///@param {TrackEvent} event
        ///@param {String} name
        ///@return {?UIItem}
        updateEvent: new BindIntent(function(channelName, event, name) {
          //var chunkService = this.state.get("chunkService")   
          var uiItem = this.items.get(name)
          this.remove(name)
          
          uiItem = this.factoryEventUIItem(channelName, event, name)
          this.add(uiItem, uiItem.name)
          //if (Optional.is(uiItem.updateArea)) {
          //  uiItem.updateArea()
          //}
          return uiItem
        }),

        ///@param {String} sourceChannel
        ///@param {String} targetChannel
        ///@param {String} eventChannel
        ///@throws {Exception}
        ///@return {String}
        getMovedChannelName: new BindIntent(function(sourceChannel, targetChannel, eventChannel) {
          var track = Beans.get(BeanVisuController).trackService.track
          var source = track.channels.get(sourceChannel)
          var target = track.channels.get(targetChannel)
          var event = track.channels.get(eventChannel)
          var size = track.channels.size()
          var index = clamp(event.index + target.index - source.index, 0, size - 1)
          var channel = track.channels.find(function(channel, name, index) {
            return channel.index == index
          }, index)
          Assert.isType(channel, TrackChannel)

          return channel.name
        }),

        ///@param {Struct} contextEvent
        ///@return {UI}
        select: new BindIntent(function(contextEvent, isControl) {
          var store = Beans.get(BeanVisuEditorController).store
          var selectedEvent = store.getValue("selected-event")
          var selectedEvents = store.getValue("selected-events")
          if (!isControl) {
            selectedEvents.clear().add(contextEvent, contextEvent.name)
            if (!Optional.is(selectedEvent) 
              || contextEvent.name != selectedEvent.name) {
              store.get("selected-event").set(contextEvent)
            }
          } else {
            if (!selectedEvents.contains(contextEvent.name)) {
              selectedEvents.add(contextEvent, contextEvent.name)
              if (!Optional.is(selectedEvent) 
                || selectedEvent.name != contextEvent.name) {
                store.get("selected-event").set(contextEvent)
              }
            } else if (Optional.is(selectedEvent)) {
              if (selectedEvent.name != contextEvent.name) {
                store.get("selected-event").set(contextEvent)
              } else {
                selectedEvents.remove(contextEvent.name)
                store.get("selected-event").set(selectedEvents.getFirst())
              }
            } else {
              //store.get("selected-event").set(contextEvent)
            }
          }

          return this
        }),

        ///@param {?Struct} [contextEvent]
        ///@return {UI}
        deselect: new BindIntent(function(contextEvent = null) {
          var store = Beans.get(BeanVisuEditorController).store

          if (Optional.is(contextEvent)) {
            var selectedEvent = store.getValue("selected-event")
            if (Optional.is(selectedEvent) 
              && selectedEvent.name == contextEvent.name) {
              store.get("selected-event").set(null)
            }
            
            var selectedEvents = store.getValue("selected-events")
            if (Optional.is(selectedEvents)) {
              selectedEvents.remove(contextEvent.name)
              if (selectedEvents.size() > 0) {
                store.get("selected-event").set(selectedEvents.getFirst())
              }
            }
          } else {
            if (Optional.is(store.getValue("selected-event"))) {
              store.get("selected-event").set(null)
            }
  
            if (store.getValue("selected-events").size() > 0) {
              store.getValue("selected-events").clear()
            }
          }
          
          return this
        }),

      },
      "ve-timeline-ruler": {
        name: "ve-timeline-ruler",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.sideShadow).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "viewSize": Beans.get(BeanVisuEditorController).store.getValue("timeline-zoom"),
          "stepSize": 2,
          "speed": 2.0,
          "position": 0,
          "camera": 0,
          "cameraPrevious": null,
          "time": null,
          "mouseX": null,
          "mouseXSensitivity": 48,
          "color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          "textColor": ColorUtil.fromHex(VETheme.color.primaryLight).toGMColor(),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        controller: controller,
        layout: layout.nodes.ruler,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        updateCustom: function() {
          var controller = Beans.get(BeanVisuController)
          var trackService = controller.trackService
          var duration = trackService.duration
          var width = this.area.getWidth()
          var viewSize = this.state.get("store").getValue("timeline-zoom")
          var spd = width / viewSize
          var time = this.state.get("time")
          var mouseX = this.state.get("mouseX")
          if (mouseX != null) {
            var _time = (mouseX - MouseUtil.getMouseX()) / this.state.get("mouseXSensitivity")
            time = time == null
              ? clamp(trackService.time - _time, 0, duration)
              : clamp(time - _time, 0, duration)
            this.state.set("mouseXTime", time)
          }

          var position = time == null ? spd * trackService.time : spd * time
          var camera = this.state.get("camera")
          var cameraPrevious = this.state.get("cameraPrevious")
          var maxWidth = spd * duration
          var stateName = controller.fsm.getStateName()

          if ((stateName == "play" || stateName == "paused" || time != null) 
            && ((position > camera + width) || (position < camera))) {
            camera = clamp(position - (width / 2), 0, maxWidth - width)
          }
          
          this.state.set("camera", camera)
          this.state.set("cameraPrevious", camera)
          this.state.set("position", position)
          this.state.set("speed", spd)
          if (stateName != "rewind") {
            this.state.set("time", null)
          }
          this.offset.x = -1 * camera

          var events = this.controller.containers.get("ve-timeline-events")
          if (Optional.is(events) && camera != cameraPrevious) {
            events.finishUpdateTimer()
          }

          if (Optional.is(mouseX) && !mouse_check_button(mb_left)) {
            var timestamp = this.state.get("mouseXTime")
            if (timestamp + FRAME_MS >= duration) {
              timestamp = duration - (FRAME_MS * 4.0)
            }
            this.state.set("mouseX", null)
            this.state.set("time", timestamp)
            Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
            Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
            return controller.send(new Event("rewind", { 
              timestamp: timestamp,
            }))
          }

          if (Optional.is(this.state.get("mouseXTime")) && !mouse_check_button(mb_left)) {
            this.state.set("mouseXTime", null)
          }
        },
        renderSurface: function() {
          var bkgColor = this.state.getDefault("background-color", c_black)
          var alpha = this.state.getDefault("background-alpha", 0.0)
          GPU.render.clear(bkgColor, alpha)

          var _x = this.area.x
          var _y = this.area.y
          var width = this.area.getWidth()
          var viewSize = this.state.get("store").getValue("timeline-zoom")
          var stepSize = this.state.get("stepSize")
          var spd = this.state.get("speed")
          var position = this.state.get("position")
          var camera = this.state.get("camera")
          var timestamp = camera div spd
          var beginX = (timestamp * spd) - camera
          var beginY = 0
          var color = this.state.get("color")
          var textColor = this.state.get("textColor")
          var height = this.area.getHeight()
          GPU.set.font(font_inter_8_bold)
          GPU.set.align.h(HAlign.LEFT)
          GPU.set.align.v(VAlign.BOTTOM)
          for (var index = 0; index < viewSize; index++) {
            var _beginX = beginX + (spd * index * stepSize)
            draw_line_color(
              _beginX,
              beginY,
              _beginX,
              beginY + height + 4,
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.5)),
              beginY,
              _beginX + (spd * (stepSize * 0.5)),
              beginY + (height * 0.66),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.125)),
              beginY,
              _beginX + (spd * (stepSize * 0.125)),
              beginY + (height * 0.33),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.25)),
              beginY,
              _beginX + (spd * (stepSize * 0.25)),
              beginY + (height * 0.5),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.375)),
              beginY,
              _beginX + (spd * (stepSize * 0.375)),
              beginY + (height * 0.33),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.625)),
              beginY,
              _beginX + (spd * (stepSize * 0.625)),
              beginY + (height * 0.33),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.75)),
              beginY,
              _beginX + (spd * (stepSize * 0.75)),
              beginY + (height * 0.5),
              textColor, color
            )

            draw_line_color(
              _beginX + (spd * (stepSize * 0.875)),
              beginY,
              _beginX + (spd * (stepSize * 0.875)),
              beginY + (height * 0.33),
              textColor, color
            )
            
            draw_text_color(
              beginX + (spd * index * stepSize) + 4, 
              beginY + height + 1, 
              String.formatTimestamp(timestamp + (index * stepSize)), 
              textColor, textColor, color, color, 
              1.0
            )
          }
        },
        renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates
          .get("renderDefaultScrollable"))),
        rulerSprite: SpriteUtil.parse({ 
          name: "texture_ve_timeline_ruler", 
          blend: VETheme.color.ruler,
        }),
        render: function() {
          if (!this.controller.containers.contains("ve-timeline-events")) {
            return
          }

          this.area.setHeight(this.area.getHeight() + 8)
          this.area.setY(this.area.getY() - 6)
          this.renderDefaultScrollable()
          this.area.setY(this.area.getY() + 6)
          this.area.setHeight(this.area.getHeight() - 8)

          if (!Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
            return
          }
          
          var position = this.state.get("position")
          var camera = this.state.get("camera")
          var rulerX = this.area.getX() + (position - camera)
          var rulerY = this.area.getY()
          var height = this.area.getHeight() + this.controller.containers
            .get("ve-timeline-events").area.getHeight()
          var thickness = 0.5
          var alpha = 1.0
          var color = this.rulerSprite.getBlend()
          GPU.render.texturedLine(rulerX, rulerY, rulerX, rulerY + height, thickness + 0.1, alpha, c_black)
          GPU.render.texturedLine(rulerX, rulerY, rulerX, rulerY + height, thickness, alpha, color)
          this.rulerSprite.render(
            rulerX - (this.rulerSprite.getWidth() / 2),
            rulerY
          )
        },
        onMouseDragLeft: function(event) {
          if (!Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
            return
          }
          
          var context = this
          var mouse = Beans.get(BeanVisuEditorIO).mouse
          var name = Struct.get(mouse.getClipboard(), "name")
          if (name == "resize_accordion"
              || name == "resize_brush_toolbar"
              || name == "resize_brush_inspector"
              || name == "resize_template_inspector"
              || name == "resize_timeline"
              || name == "resize_horizontal"
              || name == "resize_template_title") {
            return
          }
          
          this.state.set("mouseX", event.data.x)
          
          mouse.setClipboard(new Promise()
            .setState({
              context: context,
              callback: context.releaseMouseX,
            })
            .whenSuccess(function() {
              Callable.run(Struct.get(this.state, "callback"))
            })
          )
        },
        releaseMouseX: new BindIntent(function() {
          var duration = Beans.get(BeanVisuController).trackService.duration
          var timestamp = this.state.get("mouseXTime")
          if (timestamp + FRAME_MS >= duration) {
            timestamp = duration - (FRAME_MS * 4.0)
          }
          this.state.set("mouseX", null)
          this.state.set("mouseXTime", null)
          this.state.set("time", timestamp)
          return Beans.get(BeanVisuController).send(new Event("rewind", { 
            timestamp: timestamp,
          }))
        }),
      },
    })

    return new Task("init-container")
      .setState({
        context: controller,
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
      this.transactionService.clear()
      this.containers.forEach(function(container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETimeline}
  update = function() { 
    try {
      this.dispatcher.update()
      this.transactionService.update()
    } catch (exception) {
      var message = $"VETimeline dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}
