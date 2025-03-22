///@package io.alkapivo.visu.editor.service.brush.effect

///@param {?Struct} [json]
///@return {Struct}
function brush_effect_glitch(json = null) {
  return {
    name: "brush_effect_glitch",
    store: new Map(String, Struct, {
      "ef-glt_use-fade-out": {
        type: Boolean,
        value: Struct.get(json, "ef-glt_use-fade-out"),
      },
      "ef-glt_fade-out": {
        type: Number,
        value: Struct.get(json, "ef-glt_fade-out"),
        passthrough: UIUtil.passthrough.getNormalizedStringNumber(),
      },
      "ef-glt_use-config": {
        type: Boolean,
        value: Struct.get(json, "ef-glt_use-config"),
      },
      "ef-glt_line-spd": {
        type: Number,
        value: Struct.get(json, "ef-glt_line-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 0.5),
      },
      "ef-glt_line-shift": {
        type: Number,
        value: Struct.get(json, "ef-glt_line-shift"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 0.05),
      },
      "ef-glt_line-res": {
        type: Number,
        value: Struct.get(json, "ef-glt_line-res"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 3.0),
      },
      "ef-glt_line-v-shift": {
        type: Number,
        value: Struct.get(json, "ef-glt_line-v-shift"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_line-drift": {
        type: Number,
        value: Struct.get(json, "ef-glt_line-drift"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_jumb-spd": {
        type: Number,
        value: Struct.get(json, "ef-glt_jumb-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 25.0),
      },
      "ef-glt_jumb-shift": {
        type: Number,
        value: Struct.get(json, "ef-glt_jumb-shift"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_jumb-res": {
        type: Number,
        value: Struct.get(json, "ef-glt_jumb-res"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_jumb-chaos": {
        type: Number,
        value: Struct.get(json, "ef-glt_jumb-chaos"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_shd-dispersion": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-dispersion"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 0.5),
      },
      "ef-glt_shd-ch-shift": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-ch-shift"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 0.05),
      },
      "ef-glt_shd-noise": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-noise"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_shd-shakiness": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-shakiness"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 10.0),
      },
      "ef-glt_shd-rng-seed": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-rng-seed"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 1.0),
      },
      "ef-glt_shd-intensity": {
        type: Number,
        value: Struct.get(json, "ef-glt_shd-intensity"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 5.0),
      },  
    }),
    components: new Array(Struct, [
      {
        name: "ef-glt_fade-out-slider",  
        template: VEComponents.get("numeric-slider"),
        layout: VELayouts.get("numeric-slider"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Factor",
            font: "font_inter_10_bold",
            color: VETheme.color.textShadow,
            offset: { y: 14 },
            //enable: { key: "ef-glt_use-fade-out" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.001 / 1.0,
            store: { key: "ef-glt_fade-out" },
            enable: { key: "ef-glt_use-fade-out" },
          },
        },
      },
      {
        name: "ef-glt_fade-out",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          field: { 
            store: { key: "ef-glt_fade-out"
          },
            enable: { key: "ef-glt_use-fade-out" },
          },
          increase: {
            factor: 0.001,
            store: { key: "ef-glt_fade-out" },
            enable: { key: "ef-glt_use-fade-out" },
          },
          decrease: {
            factor: -0.001,
            store: { key: "ef-glt_fade-out" },
            enable: { key: "ef-glt_use-fade-out" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-glt_use-fade-out" },
          },
          title: { 
            text: "Enable",
            enable: { key: "ef-glt_use-fade-out" },
          },
        },
      },
      {
        name: "ef-glt_use-config_line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-glt_use-config",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Glitch config",
            enable: { key: "ef-glt_use-config" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-glt_use-config" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "ef-glt_line-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Line",
            color: VETheme.color.textShadow,
            //enable: { key: "ef-glt_use-config" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "ef-glt_line-spd",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 4.0 },
          },
          label: { 
            text: "Speed",
            enable: { key: "ef-glt_use-config" }
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_line-spd" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 0.5,
            snapValue: 0.01 / 0.5,
            store: { key: "ef-glt_line-spd" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_line-spd" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_line-spd" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        },
      },
      {
        name: "ef-glt_line-shift",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Shift",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_line-shift" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 0.05,
            snapValue: 0.001 / 0.05,
            store: { key: "ef-glt_line-shift" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_line-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.001,
          },
          increase: {
            store: { key: "ef-glt_line-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.001,
          },
        }
      },
      {
        name: "ef-glt_line-res",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Resolution",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_line-res" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 3.0,
            snapValue: 0.01 / 3.0,
            store: { key: "ef-glt_line-res" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_line-res" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_line-res" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_line-v-shift",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "V shift",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_line-v-shift" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_line-v-shift" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_line-v-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_line-v-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_line-drift",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { bottom: 4.0 },
          },
          label: {
            text: "Drift",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_line-drift" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_line-drift" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_line-drift" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_line-drift" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_jumb-title_line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-glt_jumb-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Jumble",
            color: VETheme.color.textShadow,
            //enable: { key: "ef-glt_use-config" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "ef-glt_jumb-spd",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 4.0 },
          },
          label: {
            text: "Speed",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_jumb-spd" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 25.0,
            snapValue: 0.1 / 25.0,
            store: { key: "ef-glt_jumb-spd" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_jumb-spd" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.1,
          },
          increase: {
            store: { key: "ef-glt_jumb-spd" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.1,
          },
        }
      },
      {
        name: "ef-glt_jumb-shift",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Shift",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_jumb-shift" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_jumb-shift" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_jumb-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_jumb-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_jumb-res",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Resolution",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_jumb-res" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_jumb-res" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_jumb-res" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_jumb-res" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_jumb-chaos",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { bottom: 4.0 },
          },
          label: {
            text: "Chaos",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_jumb-chaos" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_jumb-chaos" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_jumb-chaos" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_jumb-chaos" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_shd-title_line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-glt_shd-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Shader",
            color: VETheme.color.textShadow,
            //enable: { key: "ef-glt_use-config" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "ef-glt_shd-dispersion",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 4.0 },
          },
          label: {
            text: "Dispersion",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_shd-dispersion" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 0.5,
            snapValue: 0.001 / 0.5,
            store: { key: "ef-glt_shd-dispersion" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-dispersion" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.001,
          },
          increase: {
            store: { key: "ef-glt_shd-dispersion" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.001,
          },
        }
      },
      {
        name: "ef-glt_shd-ch-shift",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Ch. shift",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_shd-ch-shift" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 0.05,
            snapValue: 0.0001 / 0.05,
            store: { key: "ef-glt_shd-ch-shift" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-ch-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.001,
          },
          increase: {
            store: { key: "ef-glt_shd-ch-shift" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.001,
          },
        }
      },
      {
        name: "ef-glt_shd-noise",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Noise level",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_shd-noise" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_shd-noise" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-noise" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_shd-noise" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_shd-shakiness",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Shakiness",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_shd-shakiness" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 10.0,
            snapValue: 0.1 / 10.0,
            store: { key: "ef-glt_shd-shakiness" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-shakiness" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.1,
          },
          increase: {
            store: { key: "ef-glt_shd-shakiness" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.1,
          },
        }
      },
      {
        name: "ef-glt_shd-rng-seed",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "RNG seed",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            enable: { key: "ef-glt_use-config" },
            store: { key: "ef-glt_shd-rng-seed" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-glt_shd-rng-seed" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-rng-seed" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_shd-rng-seed" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
      {
        name: "ef-glt_shd-intensity",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: {
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { bottom: 4.0 },
          },
          label: {
            text: "Intensity",
            enable: { key: "ef-glt_use-config" },
          },
          field: { 
            store: { key: "ef-glt_shd-intensity" },
            enable: { key: "ef-glt_use-config" },
          },
          slider: {
            minValue: 0.0,
            maxValue: 5.0,
            snapValue: 0.01 / 5.0,
            store: { key: "ef-glt_shd-intensity" },
            enable: { key: "ef-glt_use-config" },
          },
          decrease: {
            store: { key: "ef-glt_shd-intensity" },
            enable: { key: "ef-glt_use-config" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-glt_shd-intensity" },
            enable: { key: "ef-glt_use-config" },
            factor: 0.01,
          },
        }
      },
    ]),
  }
}