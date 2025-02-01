///@package io.alkapivo.visu.editor.service.brush._old.view_old

///@param {Struct} json
///@return {Struct}
function migrateViewOldWallpaperEvent(json) {
  var textureSpeed = Struct.get(json, "view-wallpaper_texture-speed")
  if (Core.isType(textureSpeed, Number)
      && Struct.getIfType(json, "view-wallpaper_use-texture-speed", Boolean, false)) {
    Struct.set(Struct.get(json, "view-wallpaper_texture"), "speed", textureSpeed)
  }

  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "vw-layer_type": migrateWallpaperType(Struct.getIfType(json, "view-wallpaper_type", String, WallpaperType.BACKGROUND)),
    "vw-layer_fade-in": Struct.getIfType(json, "view-wallpaper_fade-in-duration", Number, 0.0),
    "vw-layer_fade-out": Struct.getIfType(json, "view-wallpaper_fade-out-duration", Number, 0.0),
    "vw-layer_use-texture": Struct.getIfType(json, "view-wallpaper_use-texture", Boolean, false),
    "vw-layer_texture": Struct.getIfType(json, "view-wallpaper_texture", Struct, { name: "texture_missing" }),
    "vw-layer_use-texture-blend": Struct.getIfType(json, "view-wallpaper_use-texture-blend", Boolean, false),
    "vw-layer_texture-blend": Struct.getIfType(json, "view-wallpaper_texture-blend", String, "#ffffff"),
    "vw-layer_use-col": Struct.getIfType(json, "view-wallpaper_use-color", Boolean, false),
    "vw-layer_col": Struct.getIfType(json, "view-wallpaper_color", String, "#000000"),
    "vw-layer_cls-texture": Struct.getIfType(json, "view-wallpaper_clear-texture", Boolean, false),
    "vw-layer_cls-col": Struct.getIfType(json, "view-wallpaper_clear-color", Boolean, false),
    "vw-layer_use-blend": true,
    "vw-layer_blend-src": Struct.getIfType(json, "view-wallpaper_blend-mode-source", String, BlendModeExt.getKey(BlendModeExt.SRC_ALPHA)),
    "vw-layer_blend-dest": Struct.getIfType(json, "view-wallpaper_blend-mode-target", String, BlendModeExt.getKey(BlendModeExt.INV_SRC_ALPHA)),
    "vw-layer_blend-eq": Struct.getIfType(json, "view-wallpaper_blend-equation", String, BlendEquation.getKey(BlendEquation.ADD)),
    "vw-layer_blend-eq-alpha": Struct.getIfType(json, "view-wallpaper_blend-equation", String, BlendEquation.getKey(BlendEquation.ADD)),
    "vw-layer_use-spd": true,
    "vw-layer_spd": {
      value: Struct.getIfType(json, "view-wallpaper_speed", Number, 0.0),
      target: Struct.getIfType(Struct.get(json, "view-wallpaper_speed-transform"), "target", Number, 0.0),
      factor: Struct.getIfType(Struct.get(json, "view-wallpaper_speed-transform"), "factor", Number, 0.0),
      increase: Struct.getIfType(Struct.get(json, "view-wallpaper_speed-transform"), "increase", Number, 0.0),
    },
    "vw-layer_change-spd": Struct.getIfType(json, "view-wallpaper_use-speed-transform", Boolean, false),
    "vw-layer_use-dir": true,
    "vw-layer_dir": {
      value: Struct.getIfType(json, "view-wallpaper_angle", Number, 0.0),
      target: Struct.getIfType(Struct.get(json, "view-wallpaper_angle-transform"), "target", Number, 0.0),
      factor: Struct.getIfType(Struct.get(json, "view-wallpaper_angle-transform"), "factor", Number, 0.0),
      increase: Struct.getIfType(Struct.get(json, "view-wallpaper_angle-transform"), "increase", Number, 0.0),
    },
    "vw-layer_change-dir": Struct.getIfType(json, "view-wallpaper_use-angle-transform", Boolean, false),
    "vw-layer_use-scale-x": true,
    "vw-layer_scale-x": {
      value: Struct.getIfType(json, "view-wallpaper_xScale", Number, 1.0),
      target: Struct.getIfType(Struct.get(json, "view-wallpaper_xScale-transform"), "target", Number, 1.0),
      factor: Struct.getIfType(Struct.get(json, "view-wallpaper_xScale-transform"), "factor", Number, 1.0),
      increase: Struct.getIfType(Struct.get(json, "view-wallpaper_xScale-transform"), "increase", Number, 0.0),
    },
    "vw-layer_change-scale-x": Struct.getIfType(json, "view-wallpaper_use-xScale-transform", Boolean, false),
    "vw-layer_use-scale-y": true,
    "vw-layer_scale-y": {
      value: Struct.getIfType(json, "view-wallpaper_yScale", Number, 1.0),
      target: Struct.getIfType(Struct.get(json, "view-wallpaper_yScale-transform"), "target", Number, 1.0),
      factor: Struct.getIfType(Struct.get(json, "view-wallpaper_yScale-transform"), "factor", Number, 1.0),
      increase: Struct.getIfType(Struct.get(json, "view-wallpaper_yScale-transform"), "increase", Number, 0.0),
    },
    "vw-layer_change-scale-y": Struct.getIfType(json, "view-wallpaper_use-yScale-transform", Boolean, false),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_view_old_wallpaper(json = null) {
  if (Struct.getIfType(json, "view-wallpaper_use-texture-speed", Boolean, false)) {
    Struct.set(
      Struct.get(json, "view-wallpaper_texture"), 
      "speed", 
      Struct.get(json, "view-wallpaper_texture-speed")
    )
  }

  return {
    name: "brush_view_old_wallpaper",
    store: new Map(String, Struct, {
      "view-wallpaper_type": {
        type: String,
        value: migrateWallpaperType(Struct.getDefault(json, "view-wallpaper_type", WallpaperType.BACKGROUND)),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: WallpaperType.keys(),
      },
      "view-wallpaper_blend-mode-source": {
        type: String,
        value: Struct.getDefault(json, "view-wallpaper_blend-mode-source", "SRC_ALPHA"),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: BlendModeExt.keys(),
      },
      "view-wallpaper_blend-mode-target": {
        type: String,
        value: Struct.getDefault(json, "view-wallpaper_blend-mode-target", Struct.get(json, "view-wallpaper_type") == WallpaperType.BACKGROUND ? "INV_SRC_ALPHA" : "ONE"),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: BlendModeExt.keys(),
      },
      "view-wallpaper_blend-equation": {
        type: String,
        value: Struct.getDefault(json, "view-wallpaper_blend-equation", "ADD"),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: BlendEquation.keys(),
      },
      "view-wallpaper_fade-in-duration": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_fade-in-duration", 0.0),
        passthrough: function(value) {
          return NumberUtil.parse(value, this.value)
        },
      },
      "view-wallpaper_fade-out-duration": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_fade-out-duration", 0.0),
        passthrough: function(value) {
          return NumberUtil.parse(value, this.value)
        },
      },
      "view-wallpaper_use-color": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-color", false),
      },
      "view-wallpaper_color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "view-wallpaper_color"), "#ffffffff"),
      },
      "view-wallpaper_clear-color": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_clear-color", false),
      },
      "view-wallpaper_use-texture": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-texture", true),
      },
      "view-wallpaper_texture": {
        type: Sprite,
        value: SpriteUtil.parse(Struct
          .get(json, "view-wallpaper_texture"), 
          { name: "texture_missing" }),
      },
      "view-wallpaper_use-texture-blend": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-texture-blend", true),
      },
      "view-wallpaper_texture-blend": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "view-wallpaper_texture-blend"), "#ffffff"),
      },
      "view-wallpaper_clear-texture": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_clear-texture", false),
      },
      "view-wallpaper_angle": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_angle", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 360.0) 
        },
      },
      "view-wallpaper_use-angle-transform": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-angle-transform", false),
      },
      "view-wallpaper_angle-transform": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "view-wallpaper_angle-transform")),
      },
      "view-wallpaper_speed": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_speed", 0.0),
        passthrough: function(value) {
          return abs(NumberUtil.parse(value, this.value)) 
        },
      },
      "view-wallpaper_use-speed-transform": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-speed-transform", false),
      },
      "view-wallpaper_speed-transform": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "view-wallpaper_speed-transform")),
      },
      "view-wallpaper_xScale": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_xScale", 1.0),
        passthrough: function(value) {
          return abs(NumberUtil.parse(value, this.value)) 
        },
      },
      "view-wallpaper_use-xScale-transform": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-xScale-transform", false),
      },
      "view-wallpaper_xScale-transform": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "view-wallpaper_xScale-transform")),
      },
      "view-wallpaper_yScale": {
        type: Number,
        value: Struct.getDefault(json, "view-wallpaper_yScale", 1.0),
        passthrough: function(value) {
          return abs(NumberUtil.parse(value, this.value)) 
        },
      },
      "view-wallpaper_use-yScale-transform": {
        type: Boolean,
        value: Struct.getDefault(json, "view-wallpaper_use-yScale-transform", false),
      },
      "view-wallpaper_yScale-transform": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "view-wallpaper_yScale-transform")),
      },
    }),
    components: new Array(Struct, [
      {
        name: "view-wallpaper_type",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Type" },
          previous: { store: { key: "view-wallpaper_type" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-wallpaper_type" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-wallpaper_type" } },
        },
      },
      {
        name: "view-wallpaper_blend-mode-source",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Blend src" },
          previous: { store: { key: "view-wallpaper_blend-mode-source" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-wallpaper_blend-mode-source" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-wallpaper_blend-mode-source" } },
        },
      },
      {
        name: "view-wallpaper_blend-mode-target",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Blend dest" },
          previous: { store: { key: "view-wallpaper_blend-mode-target" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-wallpaper_blend-mode-target" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-wallpaper_blend-mode-target" } },
        },
      },
      {
        name: "view-wallpaper_blend-equation",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Blend eq" },
          previous: { store: { key: "view-wallpaper_blend-equation" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-wallpaper_blend-equation" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-wallpaper_blend-equation" } },
        },
      },
      {
        name: "view-wallpaper_fade-in-duration",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade in" },
          field: { store: { key: "view-wallpaper_fade-in-duration" } },
        },
      },
      {
        name: "view-wallpaper_fade-out-duration",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade out" },
          field: { store: { key: "view-wallpaper_fade-out-duration" } },
        },
      },
      {
        name: "view-wallpaper_color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker-alpha"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Set color",
              enable: { key: "view-wallpaper_use-color" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-color" },
            },
            input: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "view-wallpaper_use-color" },
            },
            field: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
            slider: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "view-wallpaper_use-color" },
            },
            field: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
            slider: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "view-wallpaper_use-color" },
            },
            field: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
            slider: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
          },
          alpha: {
            label: { 
              text: "Alpha",
              enable: { key: "view-wallpaper_use-color" },
            },
            field: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
            slider: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "view-wallpaper_use-color" },
            },
            field: { 
              store: { key: "view-wallpaper_color" },
              enable: { key: "view-wallpaper_use-color" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_texture",
        template: VEComponents.get("texture-field"),
        layout: VELayouts.get("texture-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Set texture",
              enable: { key: "view-wallpaper_use-texture" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-texture" },
            },
          },
          texture: {
            label: {
              text: "Texture",
              enable: { key: "view-wallpaper_use-texture" },
            }, 
            field: {
              store: { key: "view-wallpaper_texture" },
              enable: { key: "view-wallpaper_use-texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "view-wallpaper_texture" },
            enable: { key: "view-wallpaper_use-texture" },
            imageBlendStoreKey: "view-wallpaper_texture-blend",
            useImageBlendStoreKey: "view-wallpaper_use-texture-blend",
            updateCustom: function() {
              var key = Struct.get(this, "imageBlendStoreKey")
              var use = Struct.get(this, "useImageBlendStoreKey")
              if (!Core.isType(this.store, UIStore) ||
                  !Core.isType(key, String) ||
                  !Core.isType(use, String) ||
                  !Core.isType(this.image, Sprite)) {
                return
              }

              var store = this.store.getStore()
              if (!Core.isType(store, Store)) {
                return
              }

              var color = store.getValue(key)
              if (!Core.isType(color, Color)) {
                return
              }

              this.image.setBlend(store.getValue(use) ? color.toGMColor() : c_white)
            },
          },
          alpha: {
            label: {
              text: "Alpha",
              enable: { key: "view-wallpaper_use-texture" },
            },
            field: {
              store: { key: "view-wallpaper_texture" },
              enable: { key: "view-wallpaper_use-texture" },
            },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "view-wallpaper_texture" },
            },
          },
          speed: {
            label: {
              text: "Speed",
              enable: { key: "view-wallpaper_use-texture" },
            },
            field: { 
              enable: { key: "view-wallpaper_use-texture" },
              store: { key: "view-wallpaper_texture" },
            },
            checkbox: { 
              store: { key: "view-wallpaper_texture" },
              enable: { key: "view-wallpaper_use-texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: {
              text: "Animate",
              enable: { key: "view-wallpaper_use-texture" },
            },
          },
          frame: {
            label: { 
              text: "Frame",
              enable: { key: "view-wallpaper_use-texture" },
            },
            field: { 
              store: { key: "view-wallpaper_texture" },
              enable: { key: "view-wallpaper_use-texture" },
            },
            checkbox: { 
              store: { key: "view-wallpaper_texture" },
              enable: { key: "view-wallpaper_use-texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { 
              text: "Rng",
              enable: { key: "view-wallpaper_use-texture" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_texture-blend",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: { 
              text: "Texture blend",
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "view-wallpaper_use-texture" },
              store: { key: "view-wallpaper_use-texture-blend" },
            },
            input: { 
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            field: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            slider: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            field: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            slider: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            field: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            slider: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
            field: {
              store: { key: "view-wallpaper_texture-blend" },
              enable: { key: "view-wallpaper_use-texture-blend" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_clear-color",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Remove color" },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-wallpaper_clear-color" },
          },
        },
      },
      {
        name: "view-wallpaper_clear-texture",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Remove texture" },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-wallpaper_clear-texture" },
          },
        },
      },
      {
        name: "view-wallpaper_tiled",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Move",
          },
          input: {
            store: { 
              key: "view-wallpaper_angle",
              callback: function(value, data) { 
                var sprite = Struct.get(data, "sprite")
                if (!Core.isType(sprite, Sprite)) {
                  sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                  Struct.set(data, "sprite", sprite)
                }
                sprite.setAngle(value)
              },
              set: function(value) { return },
            },
            render: function() {
              if (this.backgroundColor != null) {
                var _x = this.context.area.getX() + this.area.getX()
                var _y = this.context.area.getY() + this.area.getY()
                var color = this.backgroundColor
                draw_rectangle_color(
                  _x, _y, 
                  _x + this.area.getWidth(), _y + this.area.getHeight(),
                  color, color, color, color,
                  false
                )
              }

              var sprite = Struct.get(this, "sprite")
              if (!Core.isType(sprite, Sprite)) {
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                Struct.set(this, "sprite", sprite)
              }
              sprite.scaleToFit(this.area.getWidth(), this.area.getHeight())
                .render(
                  this.context.area.getX() + this.area.getX() + sprite.texture.offsetX * sprite.getScaleX(),
                  this.context.area.getY() + this.area.getY() + sprite.texture.offsetY * sprite.getScaleY()
                )
              
              return this
            },
          }
        },
      },
      
      {
        name: "view-wallpaper_speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Speed" },
          field: { store: { key: "view-wallpaper_speed" } },
        },
      },
      {
        name: "view-wallpaper_angle",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle",
          },
          field: { 
            store: { key: "view-wallpaper_angle" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 360.0,
            store: { key: "view-wallpaper_angle" },
          },
        },
      },
      {
        name: "view-wallpaper_xScale",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "xScale" },
          field: { store: { key: "view-wallpaper_xScale" } },
        },
      },
      {
        name: "view-wallpaper_yScale",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "yScale" },
          field: { store: { key: "view-wallpaper_yScale" } },
        },
      }, 
      {
        name: "view-wallpaper_speed-transform",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform speed",
              enable: { key: "view-wallpaper_use-speed-transform" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-speed-transform"}
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
            field: {
              store: { key: "view-wallpaper_speed-transform" },
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
            field: {
              store: { key: "view-wallpaper_speed-transform" },
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
            field: { 
              store: { key: "view-wallpaper_speed-transform" },
              enable: { key: "view-wallpaper_use-speed-transform" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_angle-transform",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform angle",
              enable: { key: "view-wallpaper_use-angle-transform" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-angle-transform"}
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
            field: {
              store: { key: "view-wallpaper_angle-transform" },
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
            field: {
              store: { key: "view-wallpaper_angle-transform" },
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
            field: { 
              store: { key: "view-wallpaper_angle-transform" },
              enable: { key: "view-wallpaper_use-angle-transform" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_xScale-transform",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform xScale",
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-xScale-transform"}
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
            field: {
              store: { key: "view-wallpaper_xScale-transform" },
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
            field: {
              store: { key: "view-wallpaper_xScale-transform" },
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
            field: { 
              store: { key: "view-wallpaper_xScale-transform" },
              enable: { key: "view-wallpaper_use-xScale-transform" },
            },
          },
        },
      },
      {
        name: "view-wallpaper_yScale-transform",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform yScale",
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-wallpaper_use-yScale-transform"}
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
            field: {
              store: { key: "view-wallpaper_yScale-transform" },
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
            field: {
              store: { key: "view-wallpaper_yScale-transform" },
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
            field: { 
              store: { key: "view-wallpaper_yScale-transform" },
              enable: { key: "view-wallpaper_use-yScale-transform" },
            },
          },
        },
      },
    ]),
  }
}