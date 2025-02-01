///@package io.alkapivo.visu.editor.service.brush._old.view_old

///@param {Struct} json
///@return {Struct}
function migrateViewOldGlitchEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "ef-glt_use-fade-out": Struct.getIfType(json, "view-glitch_use-factor", Boolean, false),
    "ef-glt_fade-out": Struct.getIfType(json, "view-glitch_factor", Number, 1.0),
    "ef-glt_use-config": Struct.getIfType(json, "view-glitch_use-config", Boolean, false),
    "ef-glt_line-spd": Struct.getIfType(json, "view-glitch_line-speed", Number, 0.0),
    "ef-glt_line-shift": Struct.getIfType(json, "view-glitch_line-shift", Number, 0.0),
    "ef-glt_line-res": Struct.getIfType(json, "view-glitch_line-resolution", Number, 0.0),
    "ef-glt_line-v-shift": Struct.getIfType(json, "view-glitch_line-vertical-shift", Number, 0.0),
    "ef-glt_line-drift": Struct.getIfType(json, "view-glitch_line-drift", Number, 0.0),
    "ef-glt_jumb-spd": Struct.getIfType(json, "view-glitch_jumble-speed", Number, 0.0),
    "ef-glt_jumb-shift": Struct.getIfType(json, "view-glitch_jumble-shift", Number, 0.0),
    "ef-glt_jumb-res": Struct.getIfType(json, "view-glitch_jumble-resolution", Number, 0.0),
    "ef-glt_jumb-chaos": Struct.getIfType(json, "view-glitch_jumble-jumbleness", Number, 0.0),
    "ef-glt_shd-dispersion": Struct.getIfType(json, "view-glitch_shader-dispersion", Number, 0.0),
    "ef-glt_shd-ch-shift": Struct.getIfType(json, "view-glitch_shader-channel-shift", Number, 0.0),
    "ef-glt_shd-noise": Struct.getIfType(json, "view-glitch_shader-noise-level", Number, 0.0),
    "ef-glt_shd-shakiness": Struct.getIfType(json, "view-glitch_shader-shakiness", Number, 0.0),
    "ef-glt_shd-rng-seed": Struct.getIfType(json, "view-glitch_shader-rng-seed", Number, 0.0),
    "ef-glt_shd-intensity": Struct.getIfType(json, "view-glitch_shader-intensity", Number, 0.0),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_view_old_glitch(json = null) {
  return {
    name: "brush_view_old_glitch",
    store: new Map(String, Struct, {
      "view-glitch_use-factor": {
        type: Boolean,
        value: Struct.getDefault(json, "view-glitch_use-factor", false),
      },
      "view-glitch_factor": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_factor", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0) 
        },
      },
      "view-glitch_use-config": {
        type: Boolean,
        value: Struct.getDefault(json, "view-glitch_use-config", true),
      },
      "view-glitch_line-speed": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_line-speed", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 0.5) 
        },
      },
      "view-glitch_line-shift": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_line-shift", 0.004),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 0.05)
        },
      },
      "view-glitch_line-resolution": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_line-resolution", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3.0)
        },
      },
      "view-glitch_line-vertical-shift": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_line-vertical-shift", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_line-drift": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_line-drift", 0.1),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_jumble-speed": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_jumble-speed", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 25.0)
        },
      },
      "view-glitch_jumble-shift": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_jumble-shift", 0.15),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_jumble-resolution": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_jumble-resolution", 0.2),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_jumble-jumbleness": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_jumble-jumbleness", 0.2),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_shader-dispersion": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-dispersion", 0.0025),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 0.5)
        },
      },
      "view-glitch_shader-channel-shift": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-channel-shift", 0.004),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 0.05)
        },
      },
      "view-glitch_shader-noise-level": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-noise-level", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_shader-shakiness": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-shakiness", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 10.0)
        },
      },
      "view-glitch_shader-rng-seed": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-rng-seed", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-glitch_shader-intensity": {
        type: Number,
        value: Struct.getDefault(json, "view-glitch_shader-intensity", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 5.0)
        },
      },      
    }),
    components: new Array(Struct, [
      {
        name: "view-glitch_use-factor",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Fade out",
            enable: { key: "view-glitch_use-factor" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-glitch_use-factor" },
          },
        },
      },
      {
        name: "view-glitch_factor",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Factor",
            enable: { key: "view-glitch_use-factor" },
          },
          field: { store: { key: "view-glitch_factor" } },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_factor" },
          },
        },
      },
      {
        name: "view-glitch_use-config",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Use config",
            enable: { key: "view-glitch_use-config" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-glitch_use-config" },
          },
        },
      },
      {
        name: "view-glitch_line",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Line",
            enable: { key: "view-glitch_use-config" },
          },
        },
      },
      {
        name: "view-glitch_line-speed",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Speed",
            enable: { key: "view-glitch_use-config" }
          },
          field: { store: { key: "view-glitch_line-speed" } },
          slider: { 
            minValue: 0.0,
            maxValue: 0.5,
            store: { key: "view-glitch_line-speed" },
            enable: { key: "view-glitch_use-config" },
          },
        },
      },
      {
        name: "view-glitch_line-shift",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Shift",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_line-shift" }},
          slider: {
            minValue: 0.0,
            maxValue: 0.05,
            store: { key: "view-glitch_line-shift" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_line-resolution",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Resolution",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_line-resolution" }},
          slider: {
            minValue: 0.0,
            maxValue: 3.0,
            store: { key: "view-glitch_line-resolution" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_line-vertical-shift",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "V shift",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_line-vertical-shift" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_line-vertical-shift" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_line-drift",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Drift",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_line-drift" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_line-drift" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_jumble",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Jumble",
            enable: { key: "view-glitch_use-config" }
          },
        },
      },
      {
        name: "view-glitch_jumble-speed",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Speed",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_jumble-speed" }},
          slider: {
            minValue: 0.0,
            maxValue: 25.0,
            store: { key: "view-glitch_jumble-speed" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_jumble-shift",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Shift",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_jumble-shift" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_jumble-shift" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_jumble-resolution",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Resolution",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_jumble-resolution" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_jumble-resolution" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_jumble-jumbleness",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Chaos",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_jumble-jumbleness" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_jumble-jumbleness" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Shader",
            enable: { key: "view-glitch_use-config" },
          },
        },
      },
      {
        name: "view-glitch_shader-dispersion",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Dispersion",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-dispersion" }},
          slider: {
            minValue: 0.0,
            maxValue: 0.5,
            store: { key: "view-glitch_shader-dispersion" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader-channel-shift",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Ch. shift",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-channel-shift" }},
          slider: {
            minValue: 0.0,
            maxValue: 0.05,
            store: { key: "view-glitch_shader-channel-shift" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader-noise-level",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Noise level",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-noise-level" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_shader-noise-level" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader-shakiness",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Shakiness",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-shakiness" }},
          slider: {
            minValue: 0.0,
            maxValue: 10.0,
            store: { key: "view-glitch_shader-shakiness" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader-rng-seed",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "RNG seed",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-rng-seed" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-glitch_shader-rng-seed" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
      {
        name: "view-glitch_shader-intensity",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: {
            text: "Intensity",
            enable: { key: "view-glitch_use-config" },
          },
          field: { store: { key: "view-glitch_shader-intensity" }},
          slider: {
            minValue: 0.0,
            maxValue: 5.0,
            store: { key: "view-glitch_shader-intensity" },
            enable: { key: "view-glitch_use-config" },
          },
        }
      },
    ]),
  }
}