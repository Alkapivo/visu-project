///@package io.alkapivo.visu.editor.service.event

///@param {UIItem} _context
///@param {?Struct} [json]
function VEEvent(_context, json = null) constructor {
  
  ///@type {UIItem}
  context = _context//Assert.isType(_context, UIItem)

  ///@type {String}
  type = Assert.isType(json.type, String) 

  ///@type {Store}
  store = new Store({
    "event-timestamp": {
      type: Number,
      value: Struct.get(json, "event-timestamp"),
      passthrough: function(value) {
        return clamp(value, 0.0, NumberUtil.parse(Beans
          .get(BeanVisuController).trackService.duration))
      }
    },
    "event-channel": {
      type: String,
      value: Struct.get(json, "event-channel"),
      passthrough: function(value) {
        var track = Beans.get(BeanVisuController).trackService.track
        return Core.isType(track, Track) && track.channels.contains(value)
          ? value
          : this.value
      }
    },
    "event-color": {
      type: Color,
      value: ColorUtil.fromHex(Struct.get(json, "event-color"), new Color(1.0, 1.0, 1.0, 1.0)),
      validate: function(value) {
        Assert.isType(ColorUtil.fromHex(value), Color)
      },
    },
    "event-texture": {
      type: String,
      value: Struct.getIfType(json, "event-texture", String, "texture_missing"),
      passthrough: function(value) {
        return Core.isType(TextureUtil.parse(value), Texture)
            && GMArray.contains(BRUSH_TEXTURES, value)
              ? value
              : this.value
      },
      data: new Array(String, BRUSH_TEXTURES),
    },
  })

  ///@type {Array<Struct>}
  components = new Array(Struct, [
    {
      name: "event-type",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: $"{Struct.get(VEBrushTypeNames, json.type)}" },
      },
    },
    {
      name: "event-timestamp",  
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Timestamp" },
        field: { store: { key: "event-timestamp" } },
      },
    },
    {
      name: "event-channel",  
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          margin: { bottom: 4 },
        },
        label: { text: "Channel" },
        field: { store: { key: "event-channel" } },
      },
    },
    {
      name: "event-texture",
      template: VEComponents.get("spin-select"),
      layout: VELayouts.get("spin-select"),
      config: {
        layout: { 
          type: UILayoutType.VERTICAL,
          height: function() { return 32 },
          margin: { top: 4, bottom: 4 },
        },
        label: { text: "Icon" },
        previous: { store: { key: "event-texture" } },
        preview: Struct.appendRecursive({ 
          store: { key: "event-texture" },
          imageBlendStoreKey: "event-color",
          updateCustom: function() {
            var key = Struct.get(this, "imageBlendStoreKey")
            if (!Optional.is(this.store)
              || !Core.isType(key, String) 
              || !Core.isType(this.image, Sprite)) {
              return
            }

            var store = this.store.getStore()
            if (!Optional.is(store)) {
              return
            }

            var item = store.get("event-color")
            if (!Optional.is(item)) {
              return
            }
            this.image.blend = item.get().toGMColor()
          },
          postRender: function() {
            if (!Optional.is(this.store)) {
              return
            }

            var item = this.store.get()
            if (!Optional.is(item)) {
              return
            }

            var data = item.data
            if (!Core.isType(data, Collection)) {
              return
            }

            var index = data.findIndex(Lambda.equal, item.get())
            if (!Optional.is(index)) {
              return
            }

            var margin = 5.0
            var width = 32.0
            var spinButtonsWidth = 2.0 * (16.0 + 5.0)
            var size = floor((this.area.getWidth() - spinButtonsWidth) / (width + margin))
            if (size <= 3.0) {
              return
            }

            if (size mod 2.0 == 0.0) {
              size -= 1.0
            }

            var from = -1.0 * floor(size / 2.0)
            var to = abs(from)
            var beginX = round(this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0) - (width / 2.0))
            var beginY = this.context.area.getY() + this.area.getY(),
            var color = ColorUtil.parse(VETheme.color.primaryLight).toGMColor()
            for (var idx = from; idx <= to; idx += 1.0) {
              if (idx == 0.0) {
                GPU.render.rectangle(
                  beginX - 1,
                  beginY - 1,
                  beginX + width + 0,
                  beginY + width + 0,
                  true,
                  color,
                  color,
                  color,
                  color,
                  0.75
                )
                
                continue
              }

              if (data.size() + idx < 0.0 || idx >= data.size()) {
                continue
              }

              var textureName = (index + idx < 0.0) || (index + idx >= data.size())
                ? (idx < 0.0 
                  ? data.get(data.size() + idx) 
                  : data.get(idx))
                : data.get(index + idx)
              
              if (!Optional.is(textureName)) {
                continue
              }

              var texture = TextureUtil.parse(textureName)
              if (!Optional.is(texture)) {
                continue
              }

              var scale = width / texture.width
              texture.render(
                beginX + (idx * (width + margin)) + (texture.offsetX * scale),
                beginY + (texture.offsetY * scale),
                0.0, scale, scale, 0.33
              )
            }
          },
          onMouseReleasedLeft: function(event) {
            if (!Optional.is(this.store)) {
              return
            }

            var item = this.store.get()
            if (!Optional.is(item)) {
              return
            }

            var data = item.data
            if (!Core.isType(data, Collection)) {
              return
            }

            var index = data.findIndex(Lambda.equal, item.get())
            if (!Optional.is(index)) {
              return
            }

            var margin = 5.0
            var width = 32.0
            var spinButtonsWidth = 2.0 * (16.0 + 5.0)
            var size = floor((this.area.getWidth() - spinButtonsWidth) / (width + margin))
            if (size <= 3.0) {
              return
            }

            if (size mod 2.0 == 0.0) {
              size -= 1.0
            }

            var from = -1.0 * floor(size / 2.0)
            var to = abs(from)
            var mouseX = event.data.x - this.context.area.getX() - this.context.offset.x
            var beginX = this.area.getX() + (this.area.getWidth() / 2.0) - (width / 2.0)
            for (var idx = from; idx <= to; idx += 1.0) {
              if (idx == 0.0 || data.size() + idx < 0.0 || idx >= data.size()) {
                continue
              }

              var textureName = (index + idx < 0.0) || (index + idx >= data.size())
                ? (idx < 0.0 
                  ? data.get(data.size() + idx) 
                  : data.get(idx))
                : data.get(index + idx)
              
              if (!Optional.is(textureName)) {
                continue
              }

              var textureX = beginX + (idx * (width + margin)) 
              if (mouseX < textureX || mouseX > textureX + width) {
                continue
              }

              item.set(textureName)
            }
          },
        }, Struct.get(VEStyles.get("spin-select-image"), "preview"), false),
        next: { store: { key: "event-texture" } },
      }
    },
    {
      name: "event-color",
      template: VEComponents.get("color-picker"),
      layout: VELayouts.get("color-picker"),
      config: {
        layout: { 
          type: UILayoutType.VERTICAL,
          hex: { margin: { top: 4 } },
        },
        red: {
          label: { text: "Red" },
          field: { store: { key: "event-color" } },
          slider: { store: { key: "event-color" } },
        },
        green: {
          label: { text: "Green" },
          field: { store: { key: "event-color" } },
          slider: { store: { key: "event-color" } },
        },
        blue: {
          label: { text: "Blue" },
          field: { store: { key: "event-color" } },
          slider: { store: { key: "event-color" } },
        },
        hex: { 
          label: { text: "Hex" },
          field: { store: { key: "event-color" } },
        },
      },
    },
    {
      name: "event_start-properties-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    }
  ])

  var eventHandler = Assert.isType(Beans.get(BeanVisuController).trackService.handlers.get(this.type), Struct)
  
  ///@type {Callable}
  serializeData = Assert.isType(Struct.get(eventHandler, "serialize"), Callable)

  ///@return {Struct}
  toTemplate = function() {
    var event = this
    return {
      channel: Assert.isType(event.store.getValue("event-channel"), String),
      event: {
        callable: Assert.isType(event.type, String),
        timestamp: Assert.isType(event.store.getValue("event-timestamp"), Number),
        data: Struct.appendUnique(
          {
            icon: {
              name: Assert.isType(event.store.getValue("event-texture"), String),
              blend: Assert.isType(event.store.getValue("event-color").toHex(), String),
            }
          },
          event.serializeData(event.store.container
            .filter(function(item) {
              return item.name != "event-timestamp"
                  && item.name != "event-channel"
                  && item.name != "event-color"
                  && item.name != "event-texture"
            })
            .toStruct(function(item) { 
              return item.serialize()
            })
          )
        ),
      }
    }
  }

  ///@description append data
  var uiHandler = Assert.isType(Callable.get(this.type), Callable)
  var eventParser = Assert.isType(Struct.get(eventHandler, "parse"), Callable)
  var data = Assert.isType(eventParser(Struct.getIfType(json, "properties", Struct, { })), Struct)
  var properties = Assert.isType(uiHandler(data), Struct)

  ///@description append StoreItems to default template
  properties.store.forEach(function(json, name, store) {
    store.add(new StoreItem(name, json))
  }, this.store)

  ///@description append components to default template
  properties.components.forEach(function(component, index, components) {
    components.add(component)
  }, this.components)

  ///@description append ending line
  this.components.add({
    name: "event_finish-properties-line-h",
    template: VEComponents.get("line-h"),
    layout: VELayouts.get("line-h"),
    config: { layout: { type: UILayoutType.VERTICAL } },
  })
}
