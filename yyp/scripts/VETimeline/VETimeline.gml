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

  ///@type {TransactionService}
  transactionService = new TransactionService()

  ///@private
  ///@param {Struct} context
  ///@return {ChunkService}
  factoryChunkService = function() {
    return new ChunkService(this, {
      step: 15,
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
          form: {
            name: "timeline.form",
            minWidth: 200,
            maxWidth: 320,
            percentageWidth: 0.2,
            width: function() { return clamp(
              max(this.percentageWidth * this.context.context.context.width(), 
              this.minWidth), this.minWidth, this.maxWidth) },
            height: function() { return 32 },
            x: function() { return 0 },
            y: function() { return this.context.y() + this.context.nodes.resize.height() },
            
          },
          ruler: {
            name: "timeline.ruler",
            width: function() { return this.context.width() 
              - this.context.nodes.form.width()
              - this.margin.left
              - this.margin.right },
            height: function() { return this.context.nodes.form.height() 
              - this.margin.top
              - this.margin.bottom },
            margin: { top: 8, bottom: 2, left: 8, right: 8 },
            x: function() { return this.context.nodes.form.width() + this.margin.left },
            y: function() { return this.context.y() + this.margin.top + this.context.nodes.resize.height() },
          },
          channels: {
            name: "timeline.channels",
            margin: { left: 10, right: 0 },
            width: function() { return this.context.nodes.form.width() 
              - this.margin.left - this.margin.right },
            height: function() { return this.context.height() 
              - this.context.nodes.form.height()
              - this.context.nodes.resize.height() },
            x: function() { return this.context.x() + this.margin.left },
            y: function() { return this.context.nodes.ruler.bottom() },
          },
          events: {
            name: "timeline.events",
            width: function() { return this.context.width() 
              - this.context.nodes.channels.width()
              - this.context.nodes.channels.margin.left
              - this.context.nodes.channels.margin.right
              - this.margin.left
              - this.margin.right },
            height: function() { return this.context.height() 
              - this.context.nodes.ruler.height()
              - this.context.nodes.resize.height() - 12 },
            margin: { top: 0, bottom: 0, left: 8, right: 8 },
            x: function() { return this.context.nodes.channels.right() 
              + this.margin.left},
            y: function() { return this.context.nodes.ruler.bottom() },
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
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),

        }),
        controller: controller,
        updateTimer: new Timer(FRAME_MS * 6, { loop: Infinity, shuffle: true }),
        layout: layout.nodes.background,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        items: {
          "resize_timeline": {
            type: UIButton,
            layout: layout.nodes.resize,
            backgroundColor: VETheme.color.primary,
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

                container.surfaceTick.skip()
                container.updateTimer.time = container.updateTimer.duration
              }

              if (MouseUtil.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseY())
                this.context.controller.containers.forEach(function(container) {
                  if (!Optional.is(container.updateTimer)) {
                    return
                  }

                  container.surfaceTick.skip()
                  container.updateTimer.time = container.updateTimer.duration
                })

                // reset accordion timer to avoid ghost effect,
                // because timeline height is affecting accordion height
                var accordion = Beans.get(BeanVisuEditorController).accordion
                accordion.containers.forEach(resetContainerTimer)
                accordion.eventInspector.containers.forEach(resetContainerTimer)
                accordion.templateToolbar.containers.forEach(resetContainerTimer)

                if (!mouse_check_button(mb_left)) {
                  MouseUtil.clearClipboard()
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
                events.updateTimer.finish()
              }
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
      },
      "ve-timeline-form": {
        name: "ve-timeline-form",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
        }),
        updateTimer: new Timer(FRAME_MS * 6, { loop: Infinity, shuffle: true }),
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
                layout: VELayouts.get("text-field-button"),
                config: { 
                  layout: { type: UILayoutType.VERTICAL },
                  label: { text: "Name" },
                  field: { store: { key: "new-channel-name" } },
                  button: { 
                    label: { text: "Add" },
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
          "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "dragItem": null,
        }),
        updateTimer: new Timer(FRAME_MS * 60, { loop: Infinity, shuffle: true }),
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
          var events = this.controller.containers.get("ve-timeline-events")
          events.offset.y = this.offset.y

          if (Optional.is(events.updateTimer)) {
            events.updateTimer.finish()
          }
        },
        onMouseWheelUp: function(event) {
          this._onMouseWheelUp(event)
          var events = this.controller.containers.get("ve-timeline-events")
          events.offset.y = this.offset.y
          events.updateTimer.finish()
        },
        onMouseWheelDown: function(event) {
          this._onMouseWheelDown(event)
          var events = this.controller.containers.get("ve-timeline-events")
          events.offset.y = this.offset.y
          
          if (Optional.is(events.updateTimer)) {
            events.updateTimer.finish()
          }
        },
        onMouseDragLeft: function(event) {
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
            MouseUtil.setClipboard(component)
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
          if (Optional.is(dragItem) && MouseUtil.getClipboard() == dragItem) {
            this.state.set("dragItem", null)
            MouseUtil.setClipboard(null)

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
              if (Optional.is(this.updateTimer)) {
                this.updateTimer.finish()
              }

              var events = this.controller.containers.get("ve-timeline-events")
              events.onInit()

              if (Optional.is(events.updateTimer)) {
                events.updateTimer.finish()
              }
            }
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
              label: { 
                text: name,
                colorHoverOver: VETheme.color.accentShadow,
                colorHoverOut: VETheme.color.primaryShadow,
              },
              button: { 
                sprite: {
                  name: "texture_ve_icon_trash",
                  blend: VETheme.color.textShadow,
                },
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
      "ve-timeline-events": {
        name: "ve-timeline-events",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "chunkService": controller.factoryChunkService(),
          "viewSize": Beans.get(BeanVisuEditorController).store.getValue("timeline-zoom"),
          "speed": 2.0,
          "position": 0,
          "amount": 0,
          "time": null,
          "lines-alpha": 1.0,
          "lines-thickness": 0.2,
          "lines-color": ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
          "bkg-color": ColorUtil.fromHex(VETheme.color.primaryShadow).toGMColor(),
          "initialized": false,
          "initializeChannels": false,
        }),
        updateTimer: new Timer(FRAME_MS * 60, { loop: Infinity }),
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
          if (mouse_check_button(mb_right) 
            || (mouse_check_button(mb_left) 
            && store.getValue("tool") == ToolType.ERASE)) {
            var mouseX = device_mouse_x_to_gui(0)
            var mouseY = device_mouse_y_to_gui(0)
            var areaX = this.area.getX()
            var areaY = this.area.getY()
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            if (point_in_rectangle(mouseX, mouseY, areaX, areaY, areaX + areaWidth, areaY + areaHeight)) {
              this.updateTimer.time = this.updateTimer.duration
              this.items.forEach(this.itemMouseEraseEvent, { 
                data: {
                  x: mouseX, 
                  y: mouseY, 
                  store: store,
                },
              })
            }
          }

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
              this.updateTimer.finish()
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
        renderClipboard: new BindIntent(function() {
          var trackEvent = MouseUtil.getClipboard()
          if (!Core.isType(trackEvent, TrackEvent)) {
            return
          }

          var index = this.getChannelIndexFromMouseY(MouseUtil.getMouseY())
          if (!Optional.is(index)) {
            index = this.lastIndex
          }
          this.lastIndex = index

          var icon = Struct.get(trackEvent.data, "icon")
          if (!Core.isType(icon, Struct)) {
            return
          }

          if (!mouse_check_button(mb_left) && !mouse_check_button_released(mb_left)) {
            MouseUtil.clearClipboard()
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
            font: "font_inter_10_regular",
            color: VETheme.color.textFocus,
            align: { v: VAlign.CENTER, h: HAlign.CENTER },
            outline: true,
            outlineColor: "#000000"
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
            16 + this.offset.y + eventY
          )
        }),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderSurface: function() {
          var trackEvent = MouseUtil.getClipboard()

          // background
          var color = this.state.get("background-color")
          GPU.render.clear(Core.isType(color, GMColor) 
            ? ColorUtil.fromGMColor(color) 
            : ColorUtil.BLACK_TRANSPARENT)

          var offsetX = this.offset.x
          var offsetY = this.offset.y
          var areaWidth = this.area.getWidth()
          var areaHeight = this.area.getHeight()
          var thickness = this.state.get("lines-thickness")
          var alpha = this.state.get("lines-alpha")
          var color = this.state.get("lines-color")
          var bkgColor = this.state.get("bkg-color")
          var editor = Beans.get(BeanVisuEditorController)
          var bpm = editor.store.getValue("bpm")
          var bpmCount = editor.store.getValue("bpm-count")
          var bpmSub = editor.store.getValue("bpm-sub")
          var bpmWidth = ((this.area.getWidth() / this.state.get("viewSize")) * 60) / bpm
          var bpmSize = ceil(this.area.getWidth() / bpmWidth)

          // background
          var bkgSize = this.state.get("amount")
          for (var bkgIndex = 0; bkgIndex < bkgSize; bkgIndex += 2) {
            var bkgY = (offsetY mod 32) + (bkgIndex * 32)
            draw_sprite_ext(texture_white, 0.0, 0, bkgY, areaWidth / 64, 0.5, 0.0, bkgColor, 1.0)
          }

          // lines
          var linesSize = this.state.get("amount") + 1
          for (var linesIndex = 0; linesIndex < linesSize; linesIndex++) {
            var linesY = (offsetY mod 32) + (linesIndex * 32)
            GPU.render.texturedLine(0, linesY, areaWidth, linesY, thickness, alpha, color)
          }

          // items
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY

          /// bpm
          var bpmX = 0
          var bpmY = round(clamp((linesSize - 1) * 32, 0, areaHeight))
          var _thickness = thickness
          var bpmCountIndex = floor(abs(this.offset.x) / bpmWidth)
          if (bpmSub > 1) {
            var bpmSubLength = round(bpmWidth / bpmSub)
            for (var bpmIndex = 0; bpmIndex < bpmSize; bpmIndex++) {
              bpmX = round((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              _thickness = bpmCount > 0 && bpmCountIndex mod bpmCount == 0 ? thickness * 4 : thickness
              bpmCountIndex++
              GPU.render.texturedLine(bpmX, 0, bpmX, bpmY, _thickness, alpha, color)
              for (var bpmSubIndex = 1; bpmSubIndex <= bpmSub; bpmSubIndex++) {
                GPU.render.texturedLine(
                  bpmX + (bpmSubIndex * bpmSubLength), 
                  0, 
                  bpmX + (bpmSubIndex * bpmSubLength), 
                  bpmY, 
                  thickness, 
                  alpha * 0.5, 
                  color
                )
              }
            }
          } else {
            for (var bpmIndex = 0; bpmIndex < bpmSize; bpmIndex++) {
              bpmX = round((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              _thickness = bpmCount > 0 && bpmCountIndex mod bpmCount == 0 ? thickness * 4 : thickness
              bpmCountIndex++
              GPU.render.texturedLine(bpmX, 0, bpmX, bpmY, _thickness, alpha, color)
            }
          }

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
              color: selectedEvents.size() > 1 ? c_lime : c_white,
            })
          }

          DeltaTime.deltaTime = delta
        },
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollable")),
        onInit: function() {
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
          this.controller.containers.get("ve-timeline-channels").offset.y = this.offset.y
          if (Optional.is(this.updateTimer)) {
            this.updateTimer.finish()
          }
        },
        onMouseWheelDown: function(event) {
          this._onMouseWheelDown(event)
          this.controller.containers.get("ve-timeline-channels").offset.y = this.offset.y
          if (Optional.is(this.updateTimer)) {
            this.updateTimer.finish()
          }
        },
        onMouseDropLeft: function(event) {
          if (Optional.is(this.updateTimer)) {
            this.updateTimer.finish()
          }

          var trackEvent = MouseUtil.getClipboard()
          MouseUtil.clearClipboard()
          if (!Core.isType(trackEvent, TrackEvent)) {
            return
          }

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
            trackEventConfig.timestamp += acc.offset
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

          var inspector = Beans.get(BeanVisuEditorController).uiService
            .find("ve-event-inspector-properties")
          if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
            inspector.updateTimer.finish()
          }
        },

        onMousePressedLeft: function(event) {
          this.updateTimer.time = this.updateTimer.duration
        },

        onMousePressedRight: function(event) {
          this.updateTimer.time = this.updateTimer.duration
        },
        
        onMouseReleasedLeft: function(event) {
          try {
            if (Optional.is(this.updateTimer)) {
              this.updateTimer.finish()
            }

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
                })

                var inspector = Beans.get(BeanVisuEditorController).uiService
                  .find("ve-event-inspector-properties")
                if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
                  inspector.updateTimer.finish()
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
                  trackEventConfig.timestamp += acc.offset
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

                var inspector = Beans.get(BeanVisuEditorController).uiService
                  .find("ve-event-inspector-properties")
                if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
                  inspector.updateTimer.finish()
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
          if (Optional.is(this.updateTimer)) {
            this.updateTimer.finish()
          }
          
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
              this.deselect()
              break
          }
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
        ///@return {Number}
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
          
          return this.factoryTrackEventFromBrushTemplate(
            timestamp,
            Beans.get(BeanVisuEditorController).brushToolbar.store
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
              sprite: event.data.icon,
              updateArea: function() {
                this.area.setY(this.component.index * this.area.getHeight())
              },
              onMouseDragLeft: function(event) {
                var store = Beans.get(BeanVisuEditorController).store
                var tool = store.getValue("tool")
                if (tool == ToolType.ERASE) {
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
                MouseUtil.setClipboard(trackEvent)

                this.context.select({
                  name: this.name,
                  channel: channelName,
                  data: trackEvent,
                })

                var events = Beans
                  .get(BeanVisuEditorController).timeline.containers
                  .get("ve-timeline-events")
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
                    })
                    
                    var inspector = Beans.get(BeanVisuEditorController).uiService
                      .find("ve-event-inspector-properties")
                    if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
                      inspector.updateTimer.finish()
                    }
                    break
                }
              },
              onMousePressedRight: function(event) {
                var channelName = this.context.getChannelNameFromMouseY(event.data.y)
                if (Optional.is(channelName)) {
                  this.context.removeEvent(channelName, this.name)
                }

                var store = Beans.get(BeanVisuEditorController).store
                var selected = store.getValue("selected-event")
                if (Optional.is(selected) && selected.name == this.name) {
                  store.get("selected-event").set(null)
                }
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
              this.data.context.updateTimer.time = this.data.context.updateTimer.duration

              ///@description select
              this.data.context.select({
                name: uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              })

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

              this.data.context.updateTimer.time = this.data.context.updateTimer.duration

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

              this.data.context.updateTimer.time = this.data.context.updateTimer.duration

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
              this.data.context.updateTimer.time = this.data.context.updateTimer.duration

              ///@description select
              this.data.context.select({
                name: uiItem.name,
                channel: this.data.channelName,
                data: this.data.event,
              })

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
          if (Optional.is(uiItem.updateArea)) {
            uiItem.updateArea()
          }
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
        select: new BindIntent(function(contextEvent) {
          var store = Beans.get(BeanVisuEditorController).store
          var selectedEvent = store.getValue("selected-event")
          var selectedEvents = store.getValue("selected-events")
          if (!keyboard_check(vk_control)) {
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

            store.getValue("selected-events").remove(contextEvent.name)
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
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
          "store": Beans.get(BeanVisuEditorController).store,
          "viewSize": Beans.get(BeanVisuEditorController).store.getValue("timeline-zoom"),
          "stepSize": 2,
          "speed": 2.0,
          "position": 0,
          "camera": 0,
          "cameraPrevious": null,
          "time": null,
          "mouseX": null,
          "mouseXSensitivity": 30,
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        controller: controller,
        layout: layout.nodes.ruler,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        updateCustom: function() {
          var controller = Beans.get(BeanVisuController)
          var trackService = controller.trackService
          var width = this.area.getWidth()
          var viewSize = this.state.get("store").getValue("timeline-zoom")
          var spd = width / viewSize
          var time = this.state.get("time")
          var mouseX = this.state.get("mouseX")
          var duration = trackService.duration
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
          if (controller.fsm.getStateName() == "play" || time != null) 
            && ((position > camera + width) || (position < camera)) {
            camera = clamp(position - width / 2, 0, maxWidth - width)
          }
          this.state.set("camera", camera)
          this.state.set("cameraPrevious", camera)
          this.state.set("position", position)
          this.state.set("speed", spd)
          this.state.set("time", null)
          this.offset.x = -1 * camera

          var events = this.controller.containers.get("ve-timeline-events")
          if (Core.isType(events, UI)) {
            if (camera != cameraPrevious && Core.isType(events.updateTimer, Timer)) {
              events.updateTimer.finish()
            }
          }

          if (Optional.is(mouseX) && !mouse_check_button(mb_left)) {
            var timestamp = this.state.get("mouseXTime")
            this.state.set("mouseX", null)
            MouseUtil.clearClipboard()
            return controller.send(new Event("rewind", { 
              timestamp: timestamp,
            }))
          }

          if (Optional.is(this.state.get("mouseXTime")) && !mouse_check_button(mb_left)) {
            this.state.set("mouseXTime", null)
          }
        },
        renderSurface: function() {
          var bkgColor = this.state.get("background-color")
          GPU.render.clear(Core.isType(bkgColor, GMColor) 
            ? ColorUtil.fromGMColor(bkgColor) 
            : ColorUtil.BLACK_TRANSPARENT)

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
          var color = ColorUtil.fromHex(VETheme.color.accent).toGMColor()
          var textColor = ColorUtil.fromHex(VETheme.color.textShadow).toGMColor()
          var height = this.area.getHeight()
          draw_set_font(font_inter_10_regular)
          draw_set_halign(HAlign.LEFT)
          draw_set_valign(VAlign.BOTTOM)
          for (var index = 0; index < viewSize; index++) {
            var label = String.formatTimestamp(timestamp + (index * stepSize))
            draw_line_color(
              beginX + (spd * index * stepSize),
              beginY,
              beginX + (spd * index * stepSize),
              beginY + height,
              color, color
            )

            draw_line_color(
              beginX + (spd * (index + (stepSize / 2.0))),
              beginY,
              beginX + (spd * (index + (stepSize / 2.0))),
              beginY + (height / 2),
              color, color
            )

            draw_line_color(
              beginX + (spd * (index + (stepSize / 4.0))),
              beginY,
              beginX + (spd * (index + (stepSize / 4.0))),
              beginY + (height / 4),
              color, color
            )
            
            draw_text_color(
              beginX + (spd * index * stepSize) + 4, 
              beginY + height - 2, 
              label, 
              textColor, textColor, textColor, textColor, 
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

          this.renderDefaultScrollable()
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
          var context = this
          this.state.set("mouseX", event.data.x)
          MouseUtil.setClipboard(new Promise()
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
          var timestamp = this.state.get("mouseXTime")
          this.state.set("mouseX", null)
          this.state.set("mouseXTime", null)
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
      this.containers.forEach(function (container, key, uiService) {
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
