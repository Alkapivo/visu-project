///@package io.alkapivo.visu.editor.service.brush

///@enum
function _VEBrushType(): Enum() constructor {
  SHADER_SPAWN = "brush_shader_spawn"
  SHADER_OVERLAY = "brush_shader_overlay"
  SHADER_CLEAR = "brush_shader_clear"
  SHADER_CONFIG = "brush_shader_config"
  SHROOM_SPAWN = "brush_shroom_spawn"
  SHROOM_CLEAR = "brush_shroom_clear"
  SHROOM_CONFIG = "brush_shroom_config"
  VIEW_WALLPAPER = "brush_view_wallpaper"
  VIEW_CAMERA = "brush_view_camera"
  VIEW_LYRICS = "brush_view_lyrics"
  VIEW_GLITCH = "brush_view_glitch"
  VIEW_CONFIG = "brush_view_config"
  GRID_CHANNEL = "brush_grid_channel"
  GRID_CONFIG = "brush_grid_config"
  GRID_PARTICLE = "brush_grid_particle"
  GRID_PLAYER = "brush_grid_player"
  GRID_SEPARATOR = "brush_grid_separator"
}
global.__VEBrushType = new _VEBrushType()
#macro VEBrushType global.__VEBrushType


///@static
///@type {Struct}
global.__VEBrushTypeNames = {
  "brush_shader_spawn": "Shader spawn",
  "brush_shader_overlay": "Shader overlay",
  "brush_shader_clear": "Shader clear",
  "brush_shader_config": "Shader config",
  "brush_shroom_spawn": "Shroom spawn",
  "brush_shroom_clear": "Shroom clear",
  "brush_shroom_config": "Shroom config",
  "brush_view_wallpaper": "View wallpaper",
  "brush_view_camera": "View camera",
  "brush_view_lyrics": "View config",
  "brush_view_glitch": "View glitch",
  "brush_view_config": "View lyrics",
  "brush_grid_channel": "Grid channel",
  "brush_grid_config": "Grid config",
  "brush_grid_particle": "Grid particle",
  "brush_grid_player": "Grid player",
  "brush_grid_separator": "Grid separator",
}
#macro VEBrushTypeNames global.__VEBrushTypeNames


///@static
///@type {Array<String>}
global.__BRUSH_TEXTURES = [
  "texture_white",
  "texture_baron",
  "texture_bazyl",
  "texture_visu_editor_icon_event_shader",
  "texture_visu_editor_icon_event_shader_spawn",
  "texture_visu_editor_icon_event_shader_overlay",
  "texture_visu_editor_icon_event_shader_clear",
  "texture_visu_editor_icon_event_shader_config",
  "texture_visu_editor_icon_event_shroom",
  "texture_visu_editor_icon_event_shroom_spawn",
  "texture_visu_editor_icon_event_shroom_clear",
  "texture_visu_editor_icon_event_shroom_config",
  "texture_visu_editor_icon_event_grid",
  "texture_visu_editor_icon_event_grid_channel",
  "texture_visu_editor_icon_event_grid_separator",
  "texture_visu_editor_icon_event_grid_particle",
  "texture_visu_editor_icon_event_grid_player",
  "texture_visu_editor_icon_event_grid_config",
  "texture_visu_editor_icon_event_view",
  "texture_visu_editor_icon_event_view_background",
  "texture_visu_editor_icon_event_view_foreground",
  "texture_visu_editor_icon_event_view_camera",
  "texture_visu_editor_icon_event_view_config",
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
      value: ColorUtil.fromHex(template.color),
      validate: function(value) {
        Assert.isType(ColorUtil.fromHex(value), Color)
      },
    },
    "brush-texture": {
      type: String,
      value: template.texture,
      validate: function(value) {
        Assert.isType(TextureUtil.parse(value), Texture)
        Assert.isTrue(this.data.contains(value))
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
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Name" },
        field: { store: { key: "brush-name" } },
      },
    },
    {
      name: "brush_color",
      template: VEComponents.get("color-picker"),
      layout: VELayouts.get("color-picker"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        title: { 
          label: { text: "Icon" },
          input: { store: { key: "brush-color" } }
        },
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
      name: "brush_texture",
      template: VEComponents.get("spin-select"),
      layout: VELayouts.get("spin-select"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        label: { text: "Texture" },
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
        }, Struct.get(VEStyles.get("spin-select-image"), "preview"), false),
        next: { store: { key: "brush-texture" } },
      }
    }
  ])

  ///@return {VEBrushTemplate}
  toTemplate = function() {
    var json = {
      name: Assert.isType(this.store.getValue("brush-name"), String),
      type: Assert.isEnum(this.type, VEBrushType),
      color: Assert.isType(this.store.getValue("brush-color"), Color).toHex(),
      texture: Assert.isType(this.store.getValue("brush-texture"), String),
    }

    var properties = this.store.container
      .filter(function(item) {
        return item.name != "brush-name" 
          && item.name != "brush-color" 
          && item.name != "brush-texture" 
      })
      .toStruct(function(item) { 
        return item.serialize()
      })
    
    if (Struct.size(properties) > 0) {
      Struct.set(json, "properties", properties)
    }

    return new VEBrushTemplate(json)
  }

  ///@description append data
  var data = Assert.isType(Callable.run(this.type, template.properties), Struct)
  data.store.forEach(function(json, name, store) {
    store.add(new StoreItem(name, json))
  }, this.store)
  data.components.forEach(function(component, index, components) {
    components.add(component)
  }, this.components)
}
