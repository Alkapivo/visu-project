///@package io.alkapivo.visu.editor.service.brush

///@enum
function _VEBrushType(): Enum() constructor {
  EFFECT_SHADER = "brush_effect_shader"
  EFFECT_GLITCH = "brush_effect_glitch"
  EFFECT_PARTICLE = "brush_effect_particle"
  EFFECT_CONFIG = "brush_effect_config"
  ENTITY_SHROOM = "brush_entity_shroom"
  ENTITY_COIN = "brush_entity_coin"
  ENTITY_PLAYER = "brush_entity_player"
  ENTITY_CONFIG = "brush_entity_config"
  GRID_AREA = "brush_grid_area"
  GRID_COLUMN = "brush_grid_column"
  GRID_ROW = "brush_grid_row"
  GRID_CONFIG = "brush_grid_config"
  VIEW_CAMERA = "brush_view_camera"
  VIEW_LAYER = "brush_view_layer"
  VIEW_SUBTITLE = "brush_view_subtitle"
  VIEW_CONFIG = "brush_view_config"
}
global.__VEBrushType = new _VEBrushType()
#macro VEBrushType global.__VEBrushType


///@static
///@type {Struct}
global.__VEBrushTypeNames = {
  "brush_effect_shader": "Effect shader",
  "brush_effect_glitch": "Effect glitch",
  "brush_effect_particle": "Effect particle",
  "brush_effect_config": "Effect config",
  "brush_entity_shroom": "Entity shroom",
  "brush_entity_coin": "Entity coin",
  "brush_entity_player": "Entity player",
  "brush_entity_config": "Entity config",
  "brush_grid_area": "Grid area",
  "brush_grid_column": "Grid column",
  "brush_grid_row": "Grid row",
  "brush_grid_config": "Grid config",
  "brush_view_camera": "View camera",
  "brush_view_layer": "View layer",
  "brush_view_subtitle": "View subtitle",
  "brush_view_config": "View config"
}
#macro VEBrushTypeNames global.__VEBrushTypeNames


///@static
///@type {Array<String>}
global.__BRUSH_TEXTURES = [
  "texture_ve_icon_entity",
  "texture_ve_icon_entity_coin",
  "texture_ve_icon_entity_config",
  "texture_ve_icon_entity_player",
  "texture_ve_icon_entity_shroom",
  "texture_ve_icon_effect",
  "texture_ve_icon_effect_config",
  "texture_ve_icon_effect_glitch",
  "texture_ve_icon_effect_particle",
  "texture_ve_icon_effect_shader",
  "texture_ve_icon_grid",
  "texture_ve_icon_grid_area",
  "texture_ve_icon_grid_column",
  "texture_ve_icon_grid_config",
  "texture_ve_icon_grid_row",
  "texture_ve_icon_view",
  "texture_ve_icon_view_camera",
  "texture_ve_icon_view_config",
  "texture_ve_icon_view_layer",
  "texture_ve_icon_view_subtitle",
  "texture_ve_icon_event_1",
  "texture_ve_icon_event_10",
  "texture_ve_icon_event_11",
  "texture_ve_icon_event_12",
  "texture_ve_icon_event_13",
  "texture_ve_icon_event_14",
  "texture_ve_icon_event_15",
  "texture_ve_icon_event_16",
  "texture_ve_icon_event_17",
  "texture_ve_icon_event_18",
  "texture_ve_icon_event_19",
  "texture_ve_icon_event_2",
  "texture_ve_icon_event_20",
  "texture_ve_icon_event_21",
  "texture_ve_icon_event_3",
  "texture_ve_icon_event_4",
  "texture_ve_icon_event_5",
  "texture_ve_icon_event_6",
  "texture_ve_icon_event_7",
  "texture_ve_icon_event_8",
  "texture_ve_icon_event_9",
  "texture_coin_life",
  "texture_coin_bomb",
  "texture_coin_force",
  "texture_coin_point",
  "texture_missing",
  "texture_white",
  "texture_baron",
  "texture_bazyl"
]
#macro BRUSH_TEXTURES global.__BRUSH_TEXTURES


///@param {VEBrushTemplate} template
function VEBrush(template) constructor {
  
  ///@type {VEBrushType}
  type = Assert.isEnum(template.type, VEBrushType)
   
  ///@type {Store}
  store = new Store({
    "brush-name": {
      type: String,
      value: template.name,
    },
    "brush-color": {
      type: Color,
      value: ColorUtil.fromHex(Struct.get(template, "color"), ColorUtil.fromHex("#FFFFFF")),
      passthrough: function(value) {
        return Core.isType(value, Color) ? value : this.value
      },
    },
    "brush-texture": {
      type: String,
      value: Struct.getIfType(template, "texture", String, "texture_missing"),
      passthrough: function(value) {
        return Core.isType(TextureUtil.parse(value), Texture)
            && GMArray.contains(BRUSH_TEXTURES, value)
              ? value
              : this.value
      },
      data: new Array(String, BRUSH_TEXTURES),
    }
  })

  ///@type {Array<Struct>}
  components = new Array(Struct, [
    {
      name: "event-type",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { text: $"{Struct.get(VEBrushTypeNames, template.type)}" },
      },
    },
    {
      name: "brush_name",
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          margin: { top: 4, bottom: 4 },
        },
        label: { text: "Name" },
        field: { store: { key: "brush-name" } },
      },
    },
    {
      name: "brush_texture",
      template: VEComponents.get("spin-select"),
      layout: VELayouts.get("spin-select"),
      config: {
        layout: { 
          type: UILayoutType.VERTICAL,
          height: function() { return 32 },
          margin: { top: 4, bottom: 4 },
        },
        label: { text: "Icon" },
        previous: { store: { key: "brush-texture" } },
        preview: Struct.appendRecursive({ 
          store: { key: "brush-texture" },
          imageBlendStoreKey: "brush-color",
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

            var item = store.get("brush-color")
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
        next: { store: { key: "brush-texture" } },
      }
    },
    {
      name: "brush_color",
      template: VEComponents.get("color-picker"),
      layout: VELayouts.get("color-picker"),
      config: {
        layout: { 
          type: UILayoutType.VERTICAL,
          hex: { margin: { top: 4 } },
        },
        //title: { 
        //  label: { text: "Icon" },
        //  input: { store: { key: "brush-color" } }
        //},
        red: {
          label: { text: "Red" },
          field: { store: { key: "brush-color" } },
          slider: { store: { key: "brush-color" } },
        },
        green: {
          label: { text: "Green" },
          field: { store: { key: "brush-color" } },
          slider: { store: { key: "brush-color" } },
        },
        blue: {
          label: { text: "Blue" },
          field: { store: { key: "brush-color" } },
          slider: { store: { key: "brush-color" } },
        },
        hex: { 
          label: { text: "Hex" },
          field: { store: { key: "brush-color" } },
        },
      },
    },
    {
      name: "brush_start-properties-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { layout: { type: UILayoutType.VERTICAL } },
    }
  ])

  var eventHandler = Assert.isType(Beans.get(BeanVisuController).trackService.handlers.get(this.type), Struct)
  
  ///@type {Callable}
  serializeData = Assert.isType(Struct.get(eventHandler, "serialize"), Callable)

  ///@return {VEBrushTemplate}
  toTemplate = function() {
    var json = {
      name: Assert.isType(this.store.getValue("brush-name"), String),
      type: Assert.isEnum(this.type, VEBrushType),
      color: Assert.isType(this.store.getValue("brush-color"), Color).toHex(),
      texture: Assert.isType(this.store.getValue("brush-texture"), String),
    }

    var properties = this.serializeData(this.store.container
      .filter(function(item) {
        return item.name != "brush-name" 
            && item.name != "brush-color" 
            && item.name != "brush-texture" 
      })
      .toStruct(function(item) { 
        return item.serialize()
      })
    )
    
    if (Struct.size(properties) > 0) {
      Struct.set(json, "properties", properties)
    }

    return new VEBrushTemplate(json)
  }

  ///@description append data
  var uiHandler = Assert.isType(Callable.get(this.type), Callable)
  var eventParser = Assert.isType(Struct.get(eventHandler, "parse"), Callable)
  var data = Assert.isType(eventParser(Struct.getIfType(template, "properties", Struct, { })), Struct)
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
    name: "brush_finish-properties-line-h",
    template: VEComponents.get("line-h"),
    layout: VELayouts.get("line-h"),
    config: { layout: { type: UILayoutType.VERTICAL } },
  })
}
