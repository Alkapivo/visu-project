///@package io.alkapivo.visu.editor.service.brush.view

global.__VISU_FONT = [
  "font_inter_8_regular",
  "font_inter_10_regular",
  "font_inter_12_regular",
  "font_inter_24_regular",
  "font_consolas_10_regular",
  "font_consolas_10_bold",
  "font_consolas_12_bold",
]
#macro VISU_FONT global.__VISU_FONT

///@param {?Struct} [json]
///@return {Struct}
function brush_view_lyrics(json = null) {
  return {
    name: "brush_view_lyrics",
    store: new Map(String, Struct, {
      "view-lyrics_template": {
        type: String,
        value: Struct.getDefault(json, "view-lyrics-template", "lyrics ID"),
        passthrough: function(value) {
          return Beans.get(BeanVisuController).lyricsService.templates
            .contains(value) ? value : "lyrics ID"
        },
      },
      "view-lyrics_font": {
        type: String,
        value: Struct.getDefault(json, "view-lyrics_font", VISU_FONT[0]),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: new Array(String, VISU_FONT)
      },
      "view-lyrics_font-height": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_font-height", 12),
        passthrough: function(value) {
          return NumberUtil.parse(value, this.value)
        },
      },
      "view-lyrics_use-timeout": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-timeout", false),
      },
      "view-lyrics_timeout": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_timeout", 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 999.0)
        },
      },
      "view-lyrics_color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.getDefault(json, "view-lyrics-color"), "#ffffff"),
      },
      "view-lyrics_use-outline": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-outline", false),
      },
      "view-lyrics_outline": {
        type: Color,
        value: ColorUtil.fromHex(Struct.getDefault(json, "view-lyrics-outline"), "#000000"),
      },
      "view-lyrics_align-v": {
        type: String,
        value: Struct.getDefault(json, "view-lyrics_align-v", "TOP"),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: new Array("String", [ "TOP", "BOTTOM" ]),
      },
      "view-lyrics_align-h": {
        type: String,
        value: Struct.getDefault(json, "view-lyrics_align-h", "LEFT"),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: new Array("String", [ "LEFT", "CENTER", "RIGHT" ]),
      },
      "view-lyrics_x": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_x", 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 1)
        },
      },
      "view-lyrics_y": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_y", 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 1)
        },
      },
      "view-lyrics_width": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_width", 1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 1)
        },
      },
      "view-lyrics_height": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_height", 1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 1)
        },
      },
      "view-lyrics_char-speed": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_char-speed", 1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.000001, 999.0)
        },
      },
      "view-lyrics_use-line-delay": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-line-delay", false),
      },
      "view-lyrics_line-delay": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_line-delay", 1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.000001, 999.0)
        },
      },
      "view-lyrics_use-finish-delay": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-finish-delay", false),
      },
      "view-lyrics_finish-delay": {
        type: Number,
        value: Struct.getDefault(json, "view-lyrics_finish-delay", 1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.000001, 999.0)
        },
      },
      "view-lyrics_use-transform-angle": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-transform-angle", false),
      },
      "view-lyrics_transform-angle": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-lyrics_transform-angle", 
          { value: 0, target: 360, factor: 0.1, increase: 0 }
        )),
      },
      "view-lyrics_use-transform-speed": {
        type: Boolean,
        value: Struct.getDefault(json, "view-lyrics_use-transform-speed", false),
      },
      "view-lyrics_transform-speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-lyrics_transform-speed", 
          { value: 0, target: 8, factor: 0.01, increase: 0 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "view-lyrics_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "view-lyrics_template" } },
        },
      },
      {
        name: "view-lyrics_font",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Font" },
          previous: { store: { key: "view-lyrics_font" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-lyrics_font" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-lyrics_font" } },
        },
      },
      {
        name: "view-lyrics_font-height",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Font H" },
          field: { store: { key: "view-lyrics_font-height" } },
        },
      },
      {
        name: "view-lyrics_char-speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Speed" },
          field: { store: { key: "view-lyrics_char-speed" } },
        },
      },
      {
        name: "view-lyrics_use-line-delay",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set new line delay",
            enable: { key: "view-lyrics_use-line-delay" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-lyrics_use-line-delay" },
          },
        },
      },
      {
        name: "view-lyrics_line-delay",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Time",
            enable: { key: "view-lyrics_use-line-delay" },
          },  
          field: { 
            store: { key: "view-lyrics_line-delay" },
            enable: { key: "view-lyrics_use-line-delay" },
          },
        },
      },
      {
        name: "view-lyrics_use-finish-delay",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set ending delay",
            enable: { key: "view-lyrics_use-finish-delay" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-lyrics_use-finish-delay" },
          },
        },
      },
      {
        name: "view-lyrics_finish-delay",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Time",
            enable: { key: "view-lyrics_use-finish-delay" },
          },  
          field: { 
            store: { key: "view-lyrics_finish-delay" },
            enable: { key: "view-lyrics_use-finish-delay" },
          },
        },
      },
      {
        name: "view-lyrics_use-timeout",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set timeout",
            enable: { key: "view-lyrics_use-timeout" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-lyrics_use-timeout" },
          },
        },
      },
      {
        name: "view-lyrics_timeout",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Timeout",
            enable: { key: "view-lyrics_use-timeout" },
          },  
          field: { 
            store: { key: "view-lyrics_timeout" },
            enable: { key: "view-lyrics_use-timeout" },
          },
        },
      },
      {
        name: "view-lyrics_color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Text color" },  
            input: { store: { key: "view-lyrics_color" } }
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: "view-lyrics_color" } },
            slider: { store: { key: "view-lyrics_color" } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: "view-lyrics_color" } },
            slider: { store: { key: "view-lyrics_color" } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: "view-lyrics_color" } },
            slider: { store: { key: "view-lyrics_color" } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: "view-lyrics_color" } },
          },
        },
      },
      {
        name: "view-lyrics_outline",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Outline color",
              enable: { key: "view-lyrics_use-outline" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-lyrics_use-outline" },
            },
            input: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "view-lyrics_use-outline" },
            },
            field: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
            slider: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "view-lyrics_use-outline" },
            },
            field: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
            slider: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "view-lyrics_use-outline" },
            },
            field: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
            slider: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "view-lyrics_use-outline" },
            },
            field: { 
              store: { key: "view-lyrics_outline" },
              enable: { key: "view-lyrics_use-outline" },
            },
          },
        },
      },
      {
        name: "view-lyrics_align",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Align" },
        },
      },
      {
        name: "view-lyrics_align-v",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Type" },
          previous: { store: { key: "view-lyrics_align-v" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-lyrics_align-v" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-lyrics_align-v" } },
        },
      },
      {
        name: "view-lyrics_align-h",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Type" },
          previous: { store: { key: "view-lyrics_align-h" } },
          preview: Struct.appendRecursive({ 
            store: { key: "view-lyrics_align-h" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "view-lyrics_align-h" } },
        },
      },
      {
        name: "view-lyrics_area",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Area" },
        },
      },
      {
        name: "view-lyrics_x",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "X" },
          field: { store: { key: "view-lyrics_x" } },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-lyrics_x" },
          },
        },
      },
      {
        name: "view-lyrics_y",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Y" },
          field: { store: { key: "view-lyrics_y" } },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-lyrics_y" },
          },
        },
      },
      {
        name: "view-lyrics_width",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Width" },
          field: { store: { key: "view-lyrics_width" } },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-lyrics_width" },
          },
        },
      },
      {
        name: "view-lyrics_height",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Height" },
          field: { store: { key: "view-lyrics_height" } },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-lyrics_height" },
          },
        },
      },
      {
        name: "view-lyrics_transform-angle",
        template: VEComponents.get("transform-numeric-uniform"),
        layout: VELayouts.get("transform-numeric-uniform"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform angle",
              enable: { key: "view-lyrics_use-transform-angle" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-lyrics_use-transform-angle" },
            },
          },
          value: {
            label: {
              text: "Value",
              enable: { key: "view-lyrics_use-transform-angle" },
            },
            field: {
              store: { key: "view-lyrics_transform-angle" },
              enable: { key: "view-lyrics_use-transform-angle" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-lyrics_use-transform-angle" },
            },
            field: {
              store: { key: "view-lyrics_transform-angle" },
              enable: { key: "view-lyrics_use-transform-angle" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-lyrics_use-transform-angle" },
            },
            field: {
              store: { key: "view-lyrics_transform-angle" },
              enable: { key: "view-lyrics_use-transform-angle" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-lyrics_use-transform-angle" },
            },
            field: {
              store: { key: "view-lyrics_transform-angle" },
              enable: { key: "view-lyrics_use-transform-angle" },
            },
          },
        },
      },
      {
        name: "view-lyrics_transform-speed",
        template: VEComponents.get("transform-numeric-uniform"),
        layout: VELayouts.get("transform-numeric-uniform"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform speed",
              enable: { key: "view-lyrics_use-transform-speed" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-lyrics_use-transform-speed" },
            },
          },
          value: {
            label: {
              text: "Value",
              enable: { key: "view-lyrics_use-transform-speed" },
            },
            field: {
              store: { key: "view-lyrics_transform-speed" },
              enable: { key: "view-lyrics_use-transform-speed" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-lyrics_use-transform-speed" },
            },
            field: {
              store: { key: "view-lyrics_transform-speed" },
              enable: { key: "view-lyrics_use-transform-speed" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-lyrics_use-transform-speed" },
            },
            field: {
              store: { key: "view-lyrics_transform-speed" },
              enable: { key: "view-lyrics_use-transform-speed" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-lyrics_use-transform-speed" },
            },
            field: {
              store: { key: "view-lyrics_transform-speed" },
              enable: { key: "view-lyrics_use-transform-speed" },
            },
          },
        },
      },
    ]),
  }
}