///@package io.alkapivo.visu.editor.service.brush.view

///@enum
function _WallpaperType(): Enum() constructor {
  BACKGROUND = "BACKGROUND"
  FOREGROUND = "FOREGROUND"
}
global.__WallpaperType = new _WallpaperType()
#macro WallpaperType global.__WallpaperType

///@param {String} type
///@return {ShaderPipelineType}
function migrateWallpaperType(type) {
  switch (type) {
    case WallpaperType.BACKGROUND:
    case "Background": return WallpaperType.BACKGROUND
    case WallpaperType.FOREGROUND:
    case "Foreground": return WallpaperType.FOREGROUND
    default: 
      Logger.warn("migrateWallpaperType", $"Found unsupported type: '{type}'. Return default value: '{WallpaperType.BACKGROUND}'")
      return ShaderPipelineType.COMBINED
  }
}

///@param {?Struct} [json]
///@return {Struct}
function brush_view_layer(json = null) {
  return {
    name: "brush_view_layer",
    store: new Map(String, Struct, {
      "vw-layer_type": {
        type: String,
        value: Struct.get(json, "vw-layer_type"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: WallpaperType.keys(),
      },
      "vw-layer_fade-in": {
        type: Number,
        value: Struct.get(json, "vw-layer_fade-in"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
      "vw-layer_fade-out": {
        type: Number,
        value: Struct.get(json, "vw-layer_fade-out"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
      "vw-layer_use-texture": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-texture"),
      },
      "vw-layer_texture": {
        type: Sprite,
        value: Struct.get(json, "vw-layer_texture"),
      },
      "vw-layer_use-texture-blend": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-texture-blend"),
      },
      "vw-layer_texture-blend": {
        type: Color,
        value: Struct.get(json, "vw-layer_texture-blend"),
      },
      "vw-layer_use-col": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-col"),
      },
      "vw-layer_col": {
        type: Color,
        value: Struct.get(json, "vw-layer_col"),
      },
      "vw-layer_cls-texture": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_cls-texture"),
      },
      "vw-layer_cls-col": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_cls-col"),
      },
      "vw-layer_use-blend": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-blend"),
      },
      "vw-layer_blend-src": {
        type: String,
        value: Struct.get(json, "vw-layer_blend-src"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: BlendModeExt.keys(),
      },
      "vw-layer_blend-dest": {
        type: String,
        value: Struct.get(json, "vw-layer_blend-dest"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: BlendModeExt.keys(),
      },
      "vw-layer_blend-eq": {
        type: String,
        value: Struct.get(json, "vw-layer_blend-eq"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: BlendEquation.keys(),
      },
      "vw-layer_blend-eq-alpha": {
        type: String,
        value: Struct.get(json, "vw-layer_blend-eq-alpha"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: BlendEquation.keys(),
      },
      "vw-layer_use-spd": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-spd"),
      },
      "vw-layer_spd": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-layer_spd"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99.9),
      },
      "vw-layer_change-spd": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_change-spd"),
      },
      "vw-layer_use-dir": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-dir"),
      },
      "vw-layer_dir": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-layer_dir"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(-9999.9, 9999.9),
      },
      "vw-layer_change-dir": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_change-dir"),
      },
      "vw-layer_use-scale-x": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-scale-x"),
      },
      "vw-layer_scale-x": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-layer_scale-x"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(-99.9, 99.9),
      },
      "vw-layer_change-scale-x": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_change-scale-x"),
      },
      "vw-layer_use-scale-y": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-scale-y"),
      },
      "vw-layer_scale-y": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-layer_scale-y"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(-99.9, 99.9),
      },
      "vw-layer_change-scale-y": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_change-scale-y"),
      },
      "vw-layer_use-texture-tiled": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-texture-tiled"),
      },
      "vw-layer_use-texture-replace": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_use-texture-replace"),
      },
      "vw-layer_texture-reset-pos": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_texture-reset-pos"),
      },
      "vw-layer_texture-use-lifespawn": {
        type: Boolean,
        value: Struct.get(json, "vw-layer_texture-use-lifespawn"),
      },
      "vw-layer_texture-lifespawn": {
        type: Number,
        value: Struct.get(json, "vw-layer_texture-lifespawn"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999.9),
      },
    }),
    components: new Array(Struct, [
      {
        name: "vw-layer_type",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Type",
            font: "font_inter_10_bold",
            color: VETheme.color.text,
          },
          previous: { store: { key: "vw-layer_type" } },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-layer_type" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "vw-layer_type" } },
        },
      },
      {
        name: "vw-layer_type-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_blend-mode-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Layer blend mode",
            backgroundColor: VETheme.color.side,
            enable: { key: "vw-layer_use-blend" },
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_use-blend" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "vw-layer_blend-src",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Source",
            enable: { key: "vw-layer_use-blend" },
          },
          previous: {
            store: { key: "vw-layer_blend-src" },
            enable: { key: "vw-layer_use-blend" },
          },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-layer_blend-src" },
            enable: { key: "vw-layer_use-blend" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            store: { key: "vw-layer_blend-src" },
            enable: { key: "vw-layer_use-blend" },
          },
        },
      },
      {
        name: "vw-layer_blend-dest",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Target",
            enable: { key: "vw-layer_use-blend" },
          },
          previous: {
            store: { key: "vw-layer_blend-dest" },
            enable: { key: "vw-layer_use-blend" },
          },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-layer_blend-dest" },
            enable: { key: "vw-layer_use-blend" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            store: { key: "vw-layer_blend-dest" },
            enable: { key: "vw-layer_use-blend" },
          },
        },
      },
      {
        name: "vw-layer_blend-eq",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Equation",
            enable: { key: "vw-layer_use-blend" },
          },
          previous: {
            store: { key: "vw-layer_blend-eq" },
            enable: { key: "vw-layer_use-blend" },
          },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-layer_blend-eq" },
            enable: { key: "vw-layer_use-blend" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: {
            store: { key: "vw-layer_blend-eq" },
            enable: { key: "vw-layer_use-blend" },
          },
        },
      },
      {
        name: "vw-layer_blend-eq-alpha",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Eq. alpha",
            enable: { key: "vw-layer_use-blend" },
          },
          previous: {
            store: { key: "vw-layer_blend-eq-alpha" },
            enable: { key: "vw-layer_use-blend" },
          },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-layer_blend-eq-alpha" },
            enable: { key: "vw-layer_use-blend" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(this.label.text, "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: {
            store: { key: "vw-layer_blend-eq-alpha" },
            enable: { key: "vw-layer_use-blend" },
          },
        },
      },
      {
        name: "vw-layer_blend-eq-alpha-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_texture-lifespawn",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lifespawn",
            enable: { key: "vw-layer_texture-use-lifespawn" },
          },
          field: { 
            store: { key: "vw-layer_texture-lifespawn" },
            enable: { key: "vw-layer_texture-use-lifespawn" },
          },
          decrease: {
            store: { key: "vw-layer_texture-lifespawn" },
            enable: { key: "vw-layer_texture-use-lifespawn" },
            factor: -0.25,
          },
          increase: {
            store: { key: "vw-layer_texture-lifespawn" },
            enable: { key: "vw-layer_texture-use-lifespawn" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-layer_texture-lifespawn" },
            enable: { key: "vw-layer_texture-use-lifespawn" },
            factor: 0.001,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_texture-use-lifespawn" },
          },
          title: { 
            text: "Override",
            enable: { key: "vw-layer_texture-use-lifespawn" },
          },
        }
      },
      {
        name: "vw-layer_lifespawn-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_fade-in",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade in" },
          field: { store: { key: "vw-layer_fade-in" } },
          decrease: {
            store: { key: "vw-layer_fade-in" },
            factor: -0.25,
          },
          increase: {
            store: { key: "vw-layer_fade-in" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-layer_fade-in" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-layer_fade-out",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade out" },
          field: { store: { key: "vw-layer_fade-out" } },
          decrease: {
            store: { key: "vw-layer_fade-out" },
            factor: -0.25,
          },
          increase: {
            store: { key: "vw-layer_fade-out" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-layer_fade-out" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-layer_fade-out-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-cls-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Remove layer",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "vw-layer_cls-texture",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Texture",
            enable: { key: "vw-layer_cls-texture" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_cls-texture" },
          },
        },
      },
      {
        name: "vw-layer_cls-col",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Color",
            enable: { key: "vw-layer_cls-col" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_cls-col" },
          },
        },
      },
      {
        name: "vw-layer_cls-col-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_use-texture",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Texture layer",
            backgroundColor: VETheme.color.accentShadow,
            enable: { key: "vw-layer_use-texture" },
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_use-texture" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "vw-layer_use-texture-tiled",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render texture tiled",
            enable: {
              keys: [ 
                { key: "vw-layer_use-texture" },
                { key: "vw-layer_use-texture-tiled" }
              ],
            },
            updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_use-texture-tiled" },
            enable: { key: "vw-layer_use-texture" },
          },
        },
      },
      {
        name: "vw-layer_use-texture-replace",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Replace texture layer",
            enable: {
              keys: [ 
                { key: "vw-layer_use-texture" },
                { key: "vw-layer_use-texture-replace" }
              ],
            },
            updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_use-texture-replace" },
            enable: { key: "vw-layer_use-texture" },
          },
        },
      },
      {
        name: "vw-layer_texture-reset-pos",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Restart texture position",
            enable: {
              keys: [ 
                { key: "vw-layer_use-texture" },
                { key: "vw-layer_texture-reset-pos" }
              ],
            },
            updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_texture-reset-pos" },
            enable: { key: "vw-layer_use-texture" },
          },
        },
      },
      {
        name: "vw-layer_texture",
        template: VEComponents.get("texture-field"),
        layout: VELayouts.get("texture-field"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 2 },
          },
          texture: {
            label: { enable: { key: "vw-layer_use-texture" } }, 
            field: {
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "vw-layer_texture" },
            enable: { key: "vw-layer_use-texture" },
            imageBlendStoreKey: "vw-layer_texture-blend",
            useImageBlendStoreKey: "vw-layer_use-texture-blend",
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
          resolution: {
            store: { key: "vw-layer_texture" },
            enable: { key: "vw-layer_use-texture" },
          },
          frame: {
            label: { enable: { key: "vw-layer_use-texture" } },
            field: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            decrease: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            increase: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            checkbox: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { enable: { key: "vw-layer_use-texture" } },
          },
          speed: {
            label: { enable: { key: "vw-layer_use-texture" } },
            field: { 
              enable: { key: "vw-layer_use-texture" },
              store: { key: "vw-layer_texture" },
            },
            decrease: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            increase: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            checkbox: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { enable: { key: "vw-layer_use-texture" } },
          },
          alpha: {
            label: { enable: { key: "vw-layer_use-texture" } },
            field: { 
              enable: { key: "vw-layer_use-texture" },
              store: { key: "vw-layer_texture" },
            },
            decrease: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            increase: { 
              store: { key: "vw-layer_texture" },
              enable: { key: "vw-layer_use-texture" },
            },
            slider: { 
              store: { key: "vw-layer_texture" },
            },
          },
        },
      },
      {
        name: "vw-layer_texture-blend-property",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Blend texture",
            //color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
            enable: {
              keys: [ 
                { key: "vw-layer_use-texture" },
                { key: "vw-layer_use-texture-blend" }
              ],
            },
            updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-layer_use-texture-blend" },
            enable: { key: "vw-layer_use-texture" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      /*
      {
        name: "vw-layer_texture-blend-title",
        template: VEComponents.get("double-checkbox"),
        layout: VELayouts.get("double-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          checkbox1: { },
          label1: { },
          checkbox2: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            enable: { key: "vw-layer_use-texture" },
            store: { key: "vw-layer_use-texture-blend" },
            backgroundColor: VETheme.color.side,
          },
          label2: {
            //font: "font_inter_10_regular",
            color: VETheme.color.text,
            backgroundColor: VETheme.color.side,
            text: "Blend",
            enable: {
              keys: [ 
                { key: "vw-layer_use-texture" },
                { key: "vw-layer_use-texture-blend" }
              ],
            },
            updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
          },
        },
      },
      */
      {
        name: "vw-layer_texture-blend",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          red: {
            label: {
              text: "Red",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            increase: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            slider: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          green: {
            label: {
              text: "Green",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            increase: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            slider: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            increase: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            slider: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_texture-blend" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-texture-blend" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
        },
      },
      {
        name: "vw-layer_texture-blend-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_position-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Texture layer movement",
            //color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
            enable: { key: "vw-layer_use-texture" },
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "vw-layer_spd",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          value: {
            label: {
              text: "Speed",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "vw-layer_use-spd" },
            },
            field: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,        
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_use-spd" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Override",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          target: {
            label: {
              text: "Target",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_change-spd" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Change",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.01,
            },
            increase: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.01,
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.001,
            },
            increase: {
              store: { key: "vw-layer_spd" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.001,      
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-spd" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
        },
      },
      {
        name: "vw-layer_spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_dir",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Angle",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "vw-layer_use-dir" },
            },
            field: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,        
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "vw-layer_use-texture" },
              store: { key: "vw-layer_use-dir" },
            },
            title: { 
              text: "Override",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            }
          },
          target: {
            label: {
              text: "Target",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "vw-layer_use-texture" },
              store: { key: "vw-layer_change-dir" },
            },
            title: { 
              text: "Change",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.01,
            },
            increase: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.01,
            },
            checkbox: { 
              store: { 
                key: "vw-layer_dir",
                callback: function(value, data) { 
                  if (!Core.isType(value, NumberTransformer)) {
                    return
                  }

                  var sprite = Struct.get(data, "sprite")
                  if (!Core.isType(sprite, Sprite)) {
                    sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
                    Struct.set(data, "sprite", sprite)
                  }

                  sprite.setAngle(value.value)
                },
                set: function(value) { return },
              },
              render: function() {
                var sprite = Struct.get(this, "sprite")
                if (!Core.isType(sprite, Sprite)) {
                  sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
                  Struct.set(this, "sprite", sprite)
                }

                sprite.scaleToFit(this.area.getWidth() * 2, this.area.getHeight() * 2)

                var itemUse = this.store.getStore().get("vw-layer_use-dir")
                if (Optional.is(itemUse) && itemUse.get()) {
                  sprite.render(
                    this.context.area.getX() + this.area.getX() + 2 + sprite.texture.offsetX * sprite.getScaleX(),
                    this.context.area.getY() + this.area.getY() + 4 + sprite.texture.offsetY * sprite.getScaleY()
                  )
                }

                var transformer = this.store.getValue()
                var itemChange = this.store.getStore().get("vw-layer_change-dir")
                if (Optional.is(itemChange) && itemChange.get() && Optional.is(transformer)) {
                  var alpha = sprite.getAlpha()
                  sprite.setAngle(transformer.target)
                    .setAlpha(alpha * 0.66)
                    .render(
                      this.context.area.getX() + this.area.getX() + 2 + sprite.texture.offsetX * sprite.getScaleX(),
                      this.context.area.getY() + this.area.getY() + 4 + sprite.texture.offsetY * sprite.getScaleY()
                    )
                    .setAngle(transformer.value)
                    .setAlpha(alpha)
                }
                
                return this
              },
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.001,
            },
            increase: {
              store: { key: "vw-layer_dir" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.001,      
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-dir" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
        },
      },
      {
        name: "vw-layer_dir-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_scale-x",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Scale X",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "vw-layer_use-scale-x" },
            },
            field: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,        
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_use-scale-x" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Override",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          target: {
            label: {
              text: "Target",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_change-scale-x" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Change",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.01,
            },
            increase: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.01,
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { },
          },
          increase: {
            label: {
              text: "Increase",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.001,
            },
            increase: {
              store: { key: "vw-layer_scale-x" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.001,      
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-x" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { },
          },
        },
      },
      {
        name: "vw-layer_scale-x-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_scale-y",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Scale Y",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "vw-layer_use-scale-y" },
            },
            field: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,        
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_use-scale-y" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Override",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_use-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          target: {
            label: {
              text: "Target",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.25,
            },
            increase: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.25,
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_change-scale-y" },
              enable: { key: "vw-layer_use-texture" },
            },
            title: { 
              text: "Change",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.01,
            },
            increase: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.01,
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { },
          },
          increase: {
            label: {
              text: "Increase",
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            field: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            decrease: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: -0.001,
            },
            increase: {
              store: { key: "vw-layer_scale-y" },
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
              factor: 0.001,      
            },
            stick: {
              enable: {
                keys: [ 
                  { key: "vw-layer_use-texture" },
                  { key: "vw-layer_change-scale-y" }
                ],
              },
              updateEnable: Callable.run(UIItemUtils.templates.get("updateEnableKeys")),
            },
            checkbox: { },
          },
        },
      },
      {
        name: "vw-layer-col-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-layer_col",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker-alpha"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Color layer",
              enable: { key: "vw-layer_use-col" },
              backgroundColor: VETheme.color.accentShadow,
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-layer_use-col" },
              backgroundColor: VETheme.color.accentShadow,
            },
            input: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
              backgroundColor: VETheme.color.accentShadow,
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "vw-layer_use-col" },
            },
            field: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
            slider: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "vw-layer_use-col" },
            },
            field: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
            slider: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "vw-layer_use-col" },
            },
            field: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
            slider: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
          },
          alpha: {
            label: { 
              text: "Alpha",
              enable: { key: "vw-layer_use-col" },
            },
            field: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
            slider: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "vw-layer_use-col" },
            },
            field: { 
              store: { key: "vw-layer_col" },
              enable: { key: "vw-layer_use-col" },
            },
          },
          line: { disable: true },
        },
      },
    ]),
  }
}