///@package io.alkapivo.visu.editor.service.brush.view

///@type {String[]}
global.__VISU_FONT = [
  "font_kodeo_mono_10_regular",
  "font_kodeo_mono_12_regular",
  "font_kodeo_mono_18_regular",
  "font_kodeo_mono_28_regular",
  "font_kodeo_mono_48_regular",

  "font_kodeo_mono_10_bold",
  "font_kodeo_mono_12_bold",
  "font_kodeo_mono_18_bold",
  "font_kodeo_mono_28_bold",
  "font_kodeo_mono_48_bold",

  "font_inter_8_regular",
  "font_inter_10_regular",
  "font_inter_12_regular",
  "font_inter_18_regular",
  "font_inter_24_regular",
  "font_inter_28_regular",

  "font_inter_8_bold",
  "font_inter_10_bold",
  "font_inter_12_bold",
  "font_inter_18_bold",
  "font_inter_24_bold",
  "font_inter_28_bold",

  "font_consolas_10_regular",
  "font_consolas_12_regular",
  "font_consolas_18_regular",
  "font_consolas_28_regular",

  "font_consolas_10_bold",
  "font_consolas_12_bold",
  "font_consolas_18_bold",
  "font_consolas_28_bold"
]
#macro VISU_FONT global.__VISU_FONT


///@param {?Struct} [json]
///@return {Struct}
function brush_view_subtitle(json = null) {
  return {
    name: "brush_view_subtitle",
    store: new Map(String, Struct, {
      "vw-sub_template": {
        type: String,
        value: Struct.get(json, "vw-sub_template"),
        passthrough: UIUtil.passthrough.getCallbackValue(),
        data: {
          callback: Beans.get(BeanVisuController).subtitleTemplateExists,
          defaultValue: "subtitle-default",
        },
      },
      "vw-sub_font": {
        type: String,
        value: Struct.get(json, "vw-sub_font"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: new Array(String, VISU_FONT),
      },
      "vw-sub_fh": {
        type: Number,
        value: Struct.get(json, "vw-sub_fh"),
        passthrough: UIUtil.passthrough.getClampedStringInteger(),
        data: new Vector2(0, 999),
      },
      "vw-sub_use-timeout": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-timeout"),
      },
      "vw-sub_timeout": {
        type: Number,
        value: Struct.get(json, "vw-sub_timeout"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_col": {
        type: Color,
        value: Struct.get(json, "vw-sub_col"),
      },
      "vw-sub_use-outline": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-outline"),
      },
      "vw-sub_outline": {
        type: Color,
        value: Struct.get(json, "vw-sub_outline"),
      },
      "vw-sub_align-v": {
        type: String,
        value: Struct.get(json, "vw-sub_align-v"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: new Array("String", [ "TOP", "BOTTOM" ]),
      },
      "vw-sub_align-h": {
        type: String,
        value: Struct.get(json, "vw-sub_align-h"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: new Array("String", [ "LEFT", "CENTER", "RIGHT" ]),
      },
      "vw-sub_use-area-preview": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-area-preview"),
      },
      "vw-sub_x": {
        type: Number,
        value: Struct.get(json, "vw-sub_x"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(-5.0, 5.0),
      },
      "vw-sub_y": {
        type: Number,
        value: Struct.get(json, "vw-sub_y"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(-5.0, 5.0),
      },
      "vw-sub_w": {
        type: Number,
        value: Struct.get(json, "vw-sub_w"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 10.0),
      },
      "vw-sub_h": {
        type: Number,
        value: Struct.get(json, "vw-sub_h"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 10.0),
      },
      "vw-sub_char-spd": {
        type: Number,
        value: Struct.get(json, "vw-sub_char-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.00001, 999.9),
      },
      "vw-sub_use-nl-delay": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-nl-delay"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_nl-delay": {
        type: Number,
        value: Struct.get(json, "vw-sub_nl-delay"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_use-end-delay": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-end-delay"),
      },
      "vw-sub_end-delay": {
        type: Number,
        value: Struct.get(json, "vw-sub_end-delay"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_use-dir": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-dir"),
      },
      "vw-sub_dir": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-sub_dir"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(-9999.9, 9999.9),
      },
      "vw-sub_change-dir": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_change-dir"),
      },
      "vw-sub_use-spd": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_use-spd"),
      },
      "vw-sub_spd": {
        type: NumberTransformer,
        value: Struct.get(json, "vw-sub_spd"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_change-spd": {
        type: Boolean,
        value: Struct.get(json, "vw-sub_change-spd"),
      },
      "vw-sub_fade-in": {
        type: Number,
        value: Struct.get(json, "vw-sub_fade-in"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "vw-sub_fade-out": {
        type: Number,
        value: Struct.get(json, "vw-sub_fade-out"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
    }),
    components: new Array(Struct, [
      {
        name: "vw-sub_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "vw-sub_template" } },
        },
      },
      {
        name: "vw-sub_template-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_timeout",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lifespan",
            enable: { key: "vw-sub_use-timeout" },
          },  
          field: { 
            store: { key: "vw-sub_timeout" },
            enable: { key: "vw-sub_use-timeout" },
          },
          decrease: {
            store: { key: "vw-sub_timeout" },
            enable: { key: "vw-sub_use-timeout" },
            factor: -1.0,
          },
          increase: {
            store: { key: "vw-sub_timeout" },
            enable: { key: "vw-sub_use-timeout" },
            factor: 1.0,
          },
          stick: {
            store: { key: "vw-sub_timeout" },
            enable: { key: "vw-sub_use-timeout" },
            factor: 0.01,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-sub_use-timeout" },
          },
          title: { 
            text: "Enable",
            enable: { key: "vw-sub_use-timeout" },
          },
        },
      },
      {
        name: "vw-sub_char-spd",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Char spd.",
            font: "font_inter_10_regular",
          },
          field: { store: { key: "vw-sub_char-spd" } },
          decrease: { 
            store: { key: "vw-sub_char-spd" },
            factor: -0.1,
          },
          increase: { 
            store: { key: "vw-sub_char-spd" },
            factor: 0.1,
          },
          stick: {
            store: { key: "vw-sub_char-spd" },
            factor: 0.005,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-sub_char-spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_fade-in",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Fade in",
            font: "font_inter_10_regular",
          },
          field: { store: { key: "vw-sub_fade-in" } },
          decrease: { 
            store: { key: "vw-sub_fade-in" },
            factor: -0.25,
          },
          increase: { 
            store: { key: "vw-sub_fade-in" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-sub_fade-in" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-sub_fade-out",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Fade out",
            font: "font_inter_10_regular",
          },
          field: { store: { key: "vw-sub_fade-out" } },
          decrease: { 
            store: { key: "vw-sub_fade-out" },
            factor: -0.25,
          },
          increase: { 
            store: { key: "vw-sub_fade-out" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-sub_fade-out" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-sub_fade-out-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_delay-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Wait after",
            backgroundColor: VETheme.color.side,
            color: VETheme.color.textShadow,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "vw-sub_nl-delay",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "New line",
            enable: { key: "vw-sub_use-nl-delay" },
          },  
          field: { 
            store: { key: "vw-sub_nl-delay" },
            enable: { key: "vw-sub_use-nl-delay" },
          },
          decrease: {
            store: { key: "vw-sub_nl-delay" },
            enable: { key: "vw-sub_use-nl-delay" },
            factor: -0.25,
          },
          increase: {
            store: { key: "vw-sub_nl-delay" },
            enable: { key: "vw-sub_use-nl-delay" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-sub_nl-delay" },
            enable: { key: "vw-sub_use-nl-delay" },
            factor: 0.01,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-sub_use-nl-delay" },
          },
          title: { 
            text: "Enable",
            enable: { key: "vw-sub_use-nl-delay" },
          },
        },
      },
      {
        name: "vw-sub_end-delay",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Last line",
            enable: { key: "vw-sub_use-end-delay" },
          },  
          field: { 
            store: { key: "vw-sub_end-delay" },
            enable: { key: "vw-sub_use-end-delay" },
          },
          decrease: {
            store: { key: "vw-sub_end-delay" },
            enable: { key: "vw-sub_use-end-delay" },
            factor: -0.25,
          },
          increase: {
            store: { key: "vw-sub_end-delay" },
            enable: { key: "vw-sub_use-end-delay" },
            factor: 0.25,
          },
          stick: {
            store: { key: "vw-sub_end-delay" },
            enable: { key: "vw-sub_use-end-delay" },
            factor: 0.01,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "vw-sub_use-end-delay" },
          },
          title: { 
            text: "Enable",
            enable: { key: "vw-sub_use-end-delay" },
          },
        },
      },
      {
        name: "vw-sub_end-delay-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_area-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Render subtitles area",
            backgroundColor: VETheme.color.accentShadow,
            enable: { key: "vw-sub_use-area-preview" },
            updateCustom: function() {
              this.preRender()
              if (Core.isType(this.context.updateTimer, Timer)) {
                var inspectorType = this.context.state.get("inspectorType")
                switch (inspectorType) {
                  case VEEventInspector:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.subtitlesAreaEvent != null) {
                      shroomService.subtitlesAreaEvent.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                  case VEBrushToolbar:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.subtitlesArea != null) {
                      shroomService.subtitlesArea.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                }
              }
            },
            preRender: function() {
              var store = null
              if (Core.isType(this.context.state.get("brush"), VEBrush)) {
                store = this.context.state.get("brush").store
              }
              
              if (Core.isType(this.context.state.get("event"), VEEvent)) {
                store = this.context.state.get("event").store
              }

              if (!Optional.is(store) || !store.getValue("vw-sub_use-area-preview")) {
                return
              }

              var subX = store.getValue("vw-sub_x")
              var subY = store.getValue("vw-sub_y")
              var subWidth = store.getValue("vw-sub_w")
              var subHeight = store.getValue("vw-sub_h")
              if (!Optional.is(subX)
                  || !Optional.is(subY)
                  || !Optional.is(subWidth)
                  || !Optional.is(subHeight)) {
                return
              }
              
              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector: 
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.subtitlesAreaEvent = {
                    topLeft: {
                      x: subX,
                      y: subY,
                    },
                    topRight: {
                      x: subX + subWidth,
                      y: subY,
                    },
                    bottomLeft: {
                      x: subX,
                      y: subY + subHeight,
                    },
                    bottomRight: {
                      x: subX + subWidth,
                      y: subY + subHeight,
                    },
                    timeout: 5.0,
                  }
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.subtitlesArea = {
                    topLeft: {
                      x: subX,
                      y: subY,
                    },
                    topRight: {
                      x: subX + subWidth,
                      y: subY,
                    },
                    bottomLeft: {
                      x: subX,
                      y: subY + subHeight,
                    },
                    bottomRight: {
                      x: subX + subWidth,
                      y: subY + subHeight,
                    },
                    timeout: 5.0,
                  }
                  break
              }
            }
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            backgroundColor: VETheme.color.accentShadow,
            store: { key: "vw-sub_use-area-preview" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
        },
      },
      {
        name: "vw-sub_x",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          label: { text: "X" },
          field: { store: { key: "vw-sub_x" } },
          slider: { 
            minValue: -1.0,
            maxValue: 2.0,
            snapValue: 0.1 / 3.0,
            store: { key: "vw-sub_x" },
          },
          decrease: {
            store: { key: "vw-sub_x" },
            factor: -0.01,
          },
          increase: {
            store: { key: "vw-sub_x" },
            factor: 0.01,
          },
        },
      },
      {
        name: "vw-sub_y",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Y" },
          field: { store: { key: "vw-sub_y" } },
          slider: { 
            minValue: -1.0,
            maxValue: 2.0,
            snapValue: 0.1 / 3.0,
            store: { key: "vw-sub_y" },
          },
          decrease: {
            store: { key: "vw-sub_y" },
            factor: -0.01,
          },
          increase: {
            store: { key: "vw-sub_y" },
            factor: 0.01,
          },
        },
      },
      {
        name: "vw-sub_w",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Width" },
          field: { store: { key: "vw-sub_w" } },
          slider: { 
            minValue: -1.0,
            maxValue: 2.0,
            snapValue: 0.1 / 3.0,
            store: { key: "vw-sub_w" },
          },
          decrease: {
            store: { key: "vw-sub_w" },
            factor: -0.01,
          },
          increase: {
            store: { key: "vw-sub_w" },
            factor: 0.01,
          },
        },
      },
      {
        name: "vw-sub_h",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Height" },
          field: { store: { key: "vw-sub_h" } },
          slider: { 
            minValue: -1.0,
            maxValue: 2.0,
            snapValue: 0.1 / 3.0,
            store: { key: "vw-sub_h" },
          },
          decrease: {
            store: { key: "vw-sub_h" },
            factor: -0.01,
          },
          increase: {
            store: { key: "vw-sub_h" },
            factor: 0.01,
          },
        },
      },
      {
        name: "vw-sub_h-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_typography-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Font",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "vw-sub_font",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Face" },
          previous: { store: { key: "vw-sub_font" } },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-sub_font" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(String.replaceAll(String.replace(this.label.text, "font_", ""), "_", " "))
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "vw-sub_font" } },
        },
      },
      {
        name: "vw-sub_fh",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Spacing",
            font: "font_inter_10_regular",
          },
          field: { store: { key: "vw-sub_fh" } },
          decrease: { 
            store: { key: "vw-sub_fh" },
            factor: -1.0,
          },
          increase: { 
            store: { key: "vw-sub_fh" },
            factor: 1.0,
          },
          stick: {
            store: { key: "vw-sub_fh" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "vw-sub_fh-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_align-v",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Align X" },
          previous: { store: { key: "vw-sub_align-v" } },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-sub_align-v" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "vw-sub_align-v" } },
        },
      },
      {
        name: "vw-sub_align-h",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Align Y" },
          previous: { store: { key: "vw-sub_align-h" } },
          preview: Struct.appendRecursive({ 
            store: { key: "vw-sub_align-h" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "vw-sub_align-h" } },
        },
      },
      {
        name: "vw-sub_col",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Color", 
              backgroundColor: VETheme.color.side,
            },
            input: { 
              store: { key: "vw-sub_col" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: { backgroundColor: VETheme.color.side },
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: "vw-sub_col" } },
            slider: { store: { key: "vw-sub_col" } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: "vw-sub_col" } },
            slider: { store: { key: "vw-sub_col" } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: "vw-sub_col" } },
            slider: { store: { key: "vw-sub_col" } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: "vw-sub_col" } },
          },
        },
      },
      {
        name: "vw-sub_outline",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Outline",
              enable: { key: "vw-sub_use-outline" },
              backgroundColor: VETheme.color.side,
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-sub_use-outline" },
              backgroundColor: VETheme.color.side,
            },
            input: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
              backgroundColor: VETheme.color.side,
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "vw-sub_use-outline" },
            },
            field: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
            slider: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "vw-sub_use-outline" },
            },
            field: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
            slider: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "vw-sub_use-outline" },
            },
            field: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
            slider: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "vw-sub_use-outline" },
            },
            field: { 
              store: { key: "vw-sub_outline" },
              enable: { key: "vw-sub_use-outline" },
            },
          },
        },
      },
      {
        name: "vw-sub_outline-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_movement-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Subtitle movement",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "vw-sub_spd",
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
            },
            field: {
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_use-spd" },
            },
            decrease: { 
              store: { key: "vw-sub_spd" },
              factor: -1.0,
              enable: { key: "vw-sub_use-spd" },
            },
            increase: { 
              store: { key: "vw-sub_spd" },
              factor: 1.0,
              enable: { key: "vw-sub_use-spd" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-sub_use-spd" },
            },
            title: { 
              text: "Enable",
              enable: { key: "vw-sub_use-spd" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "vw-sub_change-spd" },
            },
            field: {
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
            },
            decrease: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-sub_change-spd" },
            },
            title: { 
              text: "Change",
              enable: { key: "vw-sub_change-spd" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "vw-sub_change-spd" },
            },
            field: {
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
            },
            decrease: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "vw-sub_change-spd" },
            },
            field: {
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
            },
            decrease: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_spd" },
              enable: { key: "vw-sub_change-spd" },
              factor: 1.0,
            },
          },
        },
      },
      {
        name: "vw-sub_spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "vw-sub_dir",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Angle",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
            },
            field: {
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_use-dir" },
            },
            decrease: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_use-dir" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_use-dir" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-sub_use-dir" },
            },
            title: { 
              text: "Enable",
              enable: { key: "vw-sub_use-dir" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "vw-sub_change-dir" },
            },
            field: {
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
            },
            decrease: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "vw-sub_change-dir" },
            },
            title: { 
              text: "Change",
              enable: { key: "vw-sub_change-dir" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "vw-sub_change-dir" },
            },
            field: {
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
            },
            decrease: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: 1.0,
            },
            checkbox: { 
              store: { 
                key: "vw-sub_dir",
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

                var itemUse = this.store.getStore().get("vw-sub_use-dir")
                if (Optional.is(itemUse) && itemUse.get()) {
                  sprite.render(
                    this.context.area.getX() + this.area.getX() + 2 + sprite.texture.offsetX * sprite.getScaleX(),
                    this.context.area.getY() + this.area.getY() + 4 + sprite.texture.offsetY * sprite.getScaleY()
                  )
                }

                var transformer = this.store.getValue()
                var itemChange = this.store.getStore().get("vw-sub_change-dir")
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
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "vw-sub_change-dir" },
            },
            field: {
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
            },
            decrease: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "vw-sub_dir" },
              enable: { key: "vw-sub_change-dir" },
              factor: 1.0,
            },
          },
        },
      },
    ]),
  }
}


/*
"brush_view_old_lyrics": function(data) {
  var controller = Beans.get(BeanVisuController)

  var align = { v: VAlign.TOP, h: HAlign.LEFT }
  var alignV = Struct.get(data, "vw-sub_align-v")
  var alignH = Struct.get(data, "vw-sub_align-h")
  if (alignV == "BOTTOM") {
    align.v = VAlign.BOTTOM
  }
  if (alignH == "CENTER") {
    align.h = HAlign.CENTER
  } else if (alignH == "RIGHT") {
    align.h = HAlign.RIGHT
  }

  controller.subtitleService.send(new Event("add")
    .setData({
      template: Struct.get(data, "vw-sub_template"),
      font: FontUtil.fetch(Struct.get(data, "vw-sub_font")),
      fontHeight: Struct.get(data, "vw-sub_fh"),
      charSpeed: Struct.get(data, "vw-sub_char-spd"),
      color: ColorUtil.fromHex(Struct.get(data, "vw-sub_col")).toGMColor(),
      outline: Struct.get(data, "vw-sub_use-outline")
        ? ColorUtil.fromHex(Struct.get(data, "vw-sub_outline")).toGMColor()
        : null,
      timeout: Struct.get(data, "vw-sub_use-timeout")
        ? Struct.get(data, "vw-sub_timeout")
        : null,
      align: align,
      area: new Rectangle({ 
        x: Struct.get(data, "vw-sub_x"),
        y: Struct.get(data, "vw-sub_y"),
        width: Struct.get(data, "vw-sub_w"),
        height: Struct.get(data, "vw-sub_h"),
      }),
      lineDelay: Struct.get(data, "vw-sub_use-nl-delay")
        ? new Timer(Struct.get(data, "vw-sub_nl-delay"))
        : null,
      finishDelay: Struct.get(data, "vw-sub_use-end-delay")
        ? new Timer(Struct.get(data, "vw-sub_end-delay"))
        : null,
      angleTransformer: Struct.get(data, "vw-sub_use-dir")
        ? new NumberTransformer(Struct.get(data, "vw-sub_dir"))
        : new NumberTransformer({ value: 0.0, target: 0.0, factor: 0.0, increase: 0.0 }),
      speedTransformer: Struct.get(data, "vw-sub_use-spd")
        ? new NumberTransformer(Struct.get(data, "vw-sub_spd"))
        : null,
      fadeIn: Struct.get(data, "vw-sub_fade-in"),
      fadeOut: Struct.get(data, "vw-sub_fade-out"),
    }))
},
*/