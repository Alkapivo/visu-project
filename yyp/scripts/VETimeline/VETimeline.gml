///@package io.alkapivo.visu.editor.ui

///@enum
function _ToolType(): Enum() constructor {
  SELECT = "tool_select"
  BRUSH = "tool_brush"
  ERASE = "tool_erase"
  CLONE = "tool_clone"
}
global.__ToolType = new _ToolType()
#macro ToolType global.__ToolType


///@param {VisuEditor} _editor
function VETimeline(_editor) constructor {

  ///@type {VisuEditor}
  editor = Assert.isType(_editor, VisuEditor)
  
  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

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
              - this.context.nodes.resize.height() },
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
  ///@return {Map<String, UI>}
  factoryContainers = function(parent) {
    var controller = this
    var layout = this.factoryLayout(parent)
    return new Map(String, UI, {
      "_ve-timeline-background": new UI({
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
                Beans.get(BeanVisuEditor).accordion.containers.forEach(function(container) {
                  if (!Optional.is(container.updateTimer)) {
                    return
                  }

                  container.surfaceTick.skip()
                  container.updateTimer.time = container.updateTimer.duration
                })

                if (!mouse_check_button(mb_left)) {
                  MouseUtil.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(position) {
              var controller = Beans.get(BeanVisuController)
              var node = Beans.get(BeanVisuEditor).layout.nodes.timeline
              node.percentageHeight = abs((GuiHeight() - 24) - position) / (GuiHeight() - 24)

              var events = controller.uiService.find("ve-timeline-events")
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
      }),
      "ve-timeline-form": new UI({
        name: "ve-timeline-form",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          "store": Beans.get(BeanVisuEditor).store,
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
      }),
      "ve-timeline-channels": new UI({
        name: "ve-timeline-channels",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
          "store": Beans.get(BeanVisuEditor).store,
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
          Beans.get(BeanVisuController).trackService.track.removeChannel(name)
          this.onInit()
          this.controller.containers.get("ve-timeline-events").onInit()
          
        }),
      }),
      "ve-timeline-events": new UI({
        name: "ve-timeline-events",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.dark).toGMColor(),
          "store": Beans.get(BeanVisuEditor).store,
          "chunkService": controller.factoryChunkService(),
          "viewSize": Beans.get(BeanVisuEditor).store.getValue("timeline-zoom"),
          "speed": 2.0,
          "position": 0,
          "amount": 0,
          "time": null,
          "lines-alpha": 1.0,
          "lines-thickness": 0.2,
          "lines-color": ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
          "initialized": false
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
          return (32 * this.state.get("amount")) + 8
        },
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        updateCustom: function() {
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
          var ruler = this.controller.containers.get("ve-timeline-ruler")
          if (Core.isType(ruler, UI)) {
            this.offset.x = -1 * ruler.state.get("camera")
          }

          ///@todo refactor
          if (this.state.get("initialized") == false) {
            this.state.set("initialized", true)
            trackService.track.channels.forEach(function(channel, name, container) {
              channel.events.forEach(function(event, index, acc) {
                ///@description do not use addEvent as TrackEvent already exists
                var uiItem = acc.container.factoryEventUIItem(acc.channel.name, event)
                acc.container.add(uiItem, uiItem.name)
              }, { channel: channel, container: container })
            }, this)

            var container = this
            this.state.get("store").get("timeline-zoom")
              .addSubscriber({ 
                name: this.name,
                callback: function(zoom, context) { 
                  context.state.set("viewSize", zoom)
                },
                data: container,
                overrideSubscriber: true,
              })
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

          var timestamp = this.getTimestampFromMouseX(MouseUtil.getMouseX())
          var store = Beans.get(BeanVisuEditor).store
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
          

          var offsetX = this.offset.x
          var offsetY = this.offset.y
          var areaWidth = this.area.getWidth()
          var areaHeight = this.area.getHeight()
          var thickness = this.state.get("lines-thickness")
          var alpha = this.state.get("lines-alpha")
          var color = this.state.get("lines-color")
          var editor = Beans.get(BeanVisuEditor)
          var bpmSub = editor.store.getValue("bpm-sub")
          var bpm = editor.store.getValue("bpm")
          var bpmWidth = ((this.area.getWidth() / this.state.get("viewSize")) * 60) / bpm
          var bpmSize = ceil(this.area.getWidth() / bpmWidth)

          // lines
          var linesSize = this.state.get("amount") + 1
          for (var linesIndex = 0; linesIndex < linesSize; linesIndex++) {
            var linesX = (offsetY mod 32) + (linesIndex * 32)
            GPU.render.texturedLine(0, linesX, areaWidth, linesX, thickness, alpha,color)
          }

          /// bpm
          var bpmX = 0
          var bpmY = round(clamp((linesSize - 1) * 32, 0, areaHeight))
          if (bpmSub > 1) {
            var bpmSubLength = round(bpmWidth / bpmSub)
            for (var bpmIndex = 0; bpmIndex < bpmSize; bpmIndex++) {
              bpmX = round((bpmIndex * bpmWidth) - (abs(this.offset.x) mod bpmWidth))
              GPU.render.texturedLine(bpmX, 0, bpmX, bpmY, thickness, alpha, color)
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
              GPU.render.texturedLine(bpmX, 0, bpmX, bpmY, thickness, alpha, color)
            }
          }

          this.renderClipboard()

          var selectedItem = Beans.get(BeanVisuEditor).store.getValue("selected-event")
          if (Optional.is(selectedItem)) {
            var xx = this.getXFromTimestamp(selectedItem.data.timestamp) + this.offset.x
            var yy = this.getYFromChannelName(selectedItem.channel) + this.offset.y
            this.selectedSprite.render(xx, yy)
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
          var trackEvent = MouseUtil.getClipboard()
          var channelName = Struct.get(trackEvent, "channelName")
          MouseUtil.clearClipboard()
          if (Optional.is(this.updateTimer)) {
            this.updateTimer.finish()
          }

          if (!Core.isType(trackEvent, TrackEvent)
            || !Beans.get(BeanVisuController).trackService.track.channels
              .contains(channelName)) {
            return
          }

          this.removeEvent(channelName, trackEvent.eventName)

          trackEvent = trackEvent.serialize()
          trackEvent.timestamp = this.getTimestampFromMouseX(event.data.x)
          var store = Beans.get(BeanVisuEditor).store
          if (store.getValue("snap") || keyboard_check(vk_control)) {
            var bpmSub = store.getValue("bpm-sub")
            var bpm = store.getValue("bpm") * bpmSub
            trackEvent.timestamp = floor(trackEvent.timestamp / (60 / bpm)) * (60 / bpm)
          }

          var channel = this.getChannelNameFromMouseY(event.data.y)
          if (!Optional.is(channel)) {
            var size = this.controller.containers
              .get("ve-timeline-channels").collection
              .size()

            channel = this.controller.containers
              .get("ve-timeline-channels").collection
              .findKeyByIndex(size - 1)
            if (!Optional.is(channel)) {
              return
            }
          }

          var uiItem = this.addEvent(channel, new TrackEvent(trackEvent, {
            handlers: Beans.get(BeanVisuController).trackService.handlers,
          }))

          ///@description select
          Beans.get(BeanVisuEditor).store
            .get("selected-event")
            .set({
              name: uiItem.name,
              channel: channel,
              data: uiItem.state.get("event"),
            })

          var inspector = Beans.get(BeanVisuController).uiService
            .find("ve-event-inspector-properties")
          if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
            inspector.updateTimer.finish()
          }
        },
        
        onMouseReleasedLeft: function(event) {
          try {
            if (Optional.is(this.updateTimer)) {
              this.updateTimer.finish()
            }
            
            var store = Beans.get(BeanVisuEditor).store
            var tool = store.getValue("tool")
            switch (tool) {
              case ToolType.SELECT:
                ///@description deselect
                var store = Beans.get(BeanVisuEditor).store
                if (Optional.is(store.getValue("selected-event"))) {
                  store.get("selected-event").set(null)
                }
                break
              case ToolType.BRUSH:
                var brush = Beans.get(BeanVisuEditor).brushToolbar.store
                  .getValue("brush")
                if (!Optional.is(brush)) {
                  Beans.get(BeanVisuController).send(new Event("spawn-popup", 
                    { message: "No brush has been selected!" }))
                  break
                }

                var trackEvent = this.factoryTrackEventFromEvent(event)
                var channel = this.getChannelNameFromMouseY(event.data.y)
                var uiItem = this.addEvent(channel, trackEvent)
  
                ///@description select
                store.get("selected-event").set({
                  name: uiItem.name,
                  channel: channel,
                  data: uiItem.state.get("event"),
                })

                var inspector = Beans.get(BeanVisuController).uiService
                  .find("ve-event-inspector-properties")
                if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
                  inspector.updateTimer.finish()
                }
                break
              case ToolType.CLONE:
                var selected = store.getValue("selected-event")
                if (Optional.is(selected)) {
                  var channel = this.getChannelNameFromMouseY(event.data.y)
                  var trackEvent = selected.data.serialize()
                  trackEvent.timestamp = this.getTimestampFromMouseX(event.data.x)

                  if (store.getValue("snap") || keyboard_check(vk_control)) {
                    var bpmSub = store.getValue("bpm-sub")
                    var bpm = store.getValue("bpm") * bpmSub
                    trackEvent.timestamp = floor(trackEvent.timestamp / (60 / bpm)) * (60 / bpm)
                  }

                  if (!Optional.is(channel)) {
                    var size = this.controller.containers
                      .get("ve-timeline-channels").collection
                      .size()

                    channel = this.controller.containers
                      .get("ve-timeline-channels").collection
                      .findKeyByIndex(size - 1)
                  }

                  if (Optional.is(channel)) {
                    var uiItem = this.addEvent(channel, new TrackEvent(trackEvent, {
                      handlers: Beans.get(BeanVisuController).trackService.handlers,
                    }))

                    ///@description select
                    store.get("selected-event").set({
                      name: uiItem.name,
                      channel: channel,
                      data: uiItem.state.get("event"),
                    })

                    var inspector = Beans.get(BeanVisuController).uiService
                      .find("ve-event-inspector-properties")
                    if (Core.isType(inspector, UI) && Optional.is(inspector.updateTimer)) {
                      inspector.updateTimer.finish()
                    }
                  }
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
          
          var store = Beans.get(BeanVisuEditor).store
          var tool = store.getValue("tool")
          switch (tool) {
            case ToolType.SELECT:
            case ToolType.BRUSH:
            case ToolType.CLONE:
            case ToolType.ERASE:
              ///@description deselect
              var store = Beans.get(BeanVisuEditor).store
              if (Optional.is(store.getValue("selected-event"))) {
                store.get("selected-event").set(null)
              }
              break
          }
        },
    
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
          var store = Beans.get(BeanVisuEditor).store
          if (store.getValue("snap") || keyboard_check(vk_control)) {
            var bpmSub = store.getValue("bpm-sub")
            var bpm = store.getValue("bpm") * bpmSub
            timestamp = floor(timestamp / (60 / bpm)) * (60 / bpm)
          }
          
          return this.factoryTrackEventFromBrushTemplate(
            timestamp,
            Beans.get(BeanVisuEditor).brushToolbar.store
              .getValue("brush")
              .toTemplate())
        }),

        ///@param {String} channelName
        ///@param {TrackEvent} event
        ///@return {UIItem}
        factoryEventUIItem: new BindIntent(function(channelName, event) { 
          var _x = this.getXFromTimestamp(event.timestamp) 
          var key = this.items.generateKey(event.timestamp * (100 + random(1000000) + random(100000)))
          var name = $"channel_{channelName}_event_{key}"
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

                var events = Beans
                  .get(BeanVisuEditor).timeline.containers
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
                
                var store = Beans.get(BeanVisuEditor).store
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
                    Beans.get(BeanVisuEditor).store
                      .get("selected-event")
                      .set({
                        name: context.name,
                        channel: channel,
                        data: trackEvent,
                      })
                    
                    var inspector = Beans.get(BeanVisuController).uiService
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

                var store = Beans.get(BeanVisuEditor).store
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
        addEvent: new BindIntent(function(channelName, event) {
          if (!Core.isType(event, TrackEvent)) {
            return null
          }

          if (!Core.isType(Beans.get(BeanVisuController).trackService.track, Track)) {
            throw new Exception("Load track before adding event on timeline")
          }

          var track = Beans.get(BeanVisuController).trackService.track
          var uiItem = this.factoryEventUIItem(channelName, event)
          track.addEvent(channelName, event)
          this.add(uiItem, uiItem.name)
          return uiItem
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
          Beans.get(BeanVisuController).trackService.track
            .removeEvent(channelName, event)
          this.remove(uiItem.name)
          
          ///@description deselect
          var selectedEvent = editor.store.getValue("selected-event")
          if (Core.isType(selectedEvent, Struct)
            && name == selectedEvent.name) {
            editor.store.get("selected-event").set(null)
          }
        }),

        ///@param {String} channel
        ///@param {TrackEvent} event
        ///@param {String} name
        ///@return {?UIItem}
        updateEvent: new BindIntent(function(channelName, event, name) {
          //var chunkService = this.state.get("chunkService")   
          var uiItem = this.items.get(name)
          this.remove(name)
          
          uiItem = this.factoryEventUIItem(channelName, event)
          this.add(uiItem, uiItem.name)
          if (Optional.is(uiItem.updateArea)) {
            uiItem.updateArea()
          }
          return uiItem
        }), 
      }),
      "ve-timeline-ruler": new UI({
        name: "ve-timeline-ruler",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
          "store": Beans.get(BeanVisuEditor).store,
          "viewSize": Beans.get(BeanVisuEditor).store.getValue("timeline-zoom"),
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
          var trackService = Beans.get(BeanVisuController).trackService
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
          if (position > camera + width) || (position < camera) {
            camera = clamp(position - width / 2, 0, maxWidth - width)
          }
          this.state.set("camera", camera)
          this.state.set("cameraPrevious", camera)
          this.state.set("position", position)
          this.state.set("speed", spd)
          this.state.set("time", null)
          this.offset.x = -1 * camera

          if (camera != cameraPrevious) {
            var events = this.controller.containers.get("ve-timeline-events")
            if (Core.isType(events, UI) 
              && Core.isType(events.updateTimer, Timer)) {
              events.updateTimer.finish()
            }
          }

          if (Optional.is(mouseX) && !mouse_check_button(mb_left)) {
            var timestamp = this.state.get("mouseXTime")
            this.state.set("mouseX", null)
            this.state.set("mouseXTime", null)
            MouseUtil.clearClipboard()
            return Beans.get(BeanVisuController).send(new Event("rewind", { 
              timestamp: timestamp,
            }))
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
      }),
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      var context = this
      this.containers = this.factoryContainers(event.data.layout)
      IntStream.forEach(0, this.containers.size(), function(iterator, index, acc) {
        acc.uiService.send(new Event("add", {
          container: acc.containers.get(acc.keys[iterator]),
          replace: true,
        }))
      }, {
        keys: GMArray.sort(context.containers.keys().getContainer()),
        containers: context.containers,
        uiService: Beans.get(BeanVisuController).uiService,
      })
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
    } catch (exception) {
      var message = $"VETimeline dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}
