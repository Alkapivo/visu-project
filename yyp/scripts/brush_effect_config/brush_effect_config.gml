///@package io.alkapivo.visu.editor.service.brush.effect

///@param {Struct} json
///@return {Struct}
function brush_effect_config(json) {
  return {
    name: "brush_effect_config",
    store: new Map(String, Struct, {
      "ef-cfg_use-render-shd-bkg": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-render-shd-bkg"),
      },
      "ef-cfg_render-shd-bkg": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_render-shd-bkg"),
      },
      "ef-cfg_cls-shd-bkg": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-shd-bkg"),
      },
      "ef-cfg_use-render-shd-gr": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-render-shd-gr"),
      },
      "ef-cfg_render-shd-gr": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_render-shd-gr"),
      },
      "ef-cfg_cls-shd-gr": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-shd-gr"),
      },
      "ef-cfg_use-render-shd-all": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-render-shd-all"),
      },
      "ef-cfg_render-shd-all": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_render-shd-all"),
      },
      "ef-cfg_cls-shd-all": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-shd-all"),
      },
      "ef-cfg_use-render-glt": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-render-glt"),
      },
      "ef-cfg_render-glt": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_render-glt"),
      },
      "ef-cfg_cls-glt": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-glt"),
      },
      "ef-cfg_use-render-part": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-render-part"),
      },
      "ef-cfg_render-part": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_render-part"),
      },
      "ef-cfg_cls-part": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-part"),
      },
      "ef-cfg_use-cls-frame": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-cls-frame"),
      },
      "ef-cfg_cls-frame": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_cls-frame"),
      },
      "ef-cfg_use-cls-frame-col": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-cls-frame-col"),
      },
      "ef-cfg_cls-frame-col": {
        type: Color,
        value: Struct.get(json, "ef-cfg_cls-frame-col"),
      },
      "ef-cfg_cls-frame-col-spd": {
        type: Number,
        value: Struct.get(json, "ef-cfg_cls-frame-col-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "ef-cfg_cls-frame-alpha": {
        type: NumberTransformer,
        value: Struct.get(json, "ef-cfg_cls-frame-alpha"),
        passthrough: UIUtil.passthrough.getNormalizedNumberTransformer(),
      },
      "ef-cfg_use-cls-frame-alpha": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-cls-frame-alpha"),
      },
      "ef-cfg_change-cls-frame-alpha": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_change-cls-frame-alpha"),
      },
      "ef-cfg_use-particle-z": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_use-particle-z"),
      },
      "ef-cfg_particle-z": {
        type: NumberTransformer,
        value: Struct.get(json, "ef-cfg_particle-z"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99999.9),
      },
      "ef-cfg_change-particle-z": {
        type: Boolean,
        value: Struct.get(json, "ef-cfg_change-particle-z"),
      },
    }),
    components: new Array(Struct, [
      {
        name: "ef-cfg_render",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "ef-cfg_render-shd-bkg",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Background shaders",
            enable: { key: "ef-cfg_use-render-shd-bkg" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-render-shd-bkg" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_render-shd-bkg" },
            enable: { key: "ef-cfg_use-render-shd-bkg" },
          },
        },
      },
      {
        name: "ef-cfg_render-shd-gr",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Grid shaders",
            enable: { key: "ef-cfg_use-render-shd-gr" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-render-shd-gr" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_render-shd-gr" },
            enable: { key: "ef-cfg_use-render-shd-gr" },
          },
        },
      },
      {
        name: "ef-cfg_render-shd-all",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Combined shaders",
            enable: { key: "ef-cfg_use-render-shd-all" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-render-shd-all" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_render-shd-all" },
            enable: { key: "ef-cfg_use-render-shd-all" },
          },
        },
      },
      {
        name: "ef-cfg_render-glt",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Glitches",
            enable: { key: "ef-cfg_use-render-glt" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-render-glt" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_render-glt" },
            enable: { key: "ef-cfg_use-render-glt" },
          },
        },
      },
      {
        name: "ef-cfg_render-part",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Particles",
            enable: { key: "ef-cfg_use-render-part" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-render-part" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_render-part" },
            enable: { key: "ef-cfg_use-render-part" },
          },
        },
      },
      {
        name: "ef-cfg_cls-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-cfg_cls",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "ef-cfg_cls-shd-bkg",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Background shaders",
            enable: { key: "ef-cfg_cls-shd-bkg" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_cls-shd-bkg" },
          },
        },
      },
      {
        name: "ef-cfg_cls-shd-gr",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Grid shaders",
            enable: { key: "ef-cfg_cls-shd-gr" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_cls-shd-gr" },
          },
        },
      },
      {
        name: "ef-cfg_cls-shd-all",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Combined shaders",
            enable: { key: "ef-cfg_cls-shd-all" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_cls-shd-all" },
          },
        },
      },
      {
        name: "ef-cfg_cls-glt",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Glitches",
            enable: { key: "ef-cfg_cls-glt" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_cls-glt" },
          },
        },
      },
      {
        name: "ef-cfg_cls-part",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Particles",
            enable: { key: "ef-cfg_cls-part" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_cls-part" },
          },
        },
      },
      {
        name: "ef-cfg_cls-frame-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-cfg_cls-frame",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear shader surface frame",
            enable: { key: "ef-cfg_use-cls-frame" },
            backgroundColor: VETheme.color.accentShadow 
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-cfg_use-cls-frame" },
            backgroundColor: VETheme.color.accentShadow 
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "ef-cfg_cls-frame" },
            enable: { key: "ef-cfg_use-cls-frame" },
            backgroundColor: VETheme.color.accentShadow 
          },
        },
      },
      {
        name: "ef-cfg_cls-frame-col",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 0, bottom: 0 },
          },
          line: { disable: true },
          title: {
            label: { 
              text: "Color",
              //color: VETheme.color.textShadow,
              enable: { key: "ef-cfg_use-cls-frame-col" },
              //backgroundColor: VETheme.color.side,
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "ef-cfg_use-cls-frame-col" },
              //backgroundColor: VETheme.color.side,
            },
            input: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
              //backgroundColor: VETheme.color.side,
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            field: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            slider: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            field: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            slider: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            field: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            slider: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
            field: { 
              store: { key: "ef-cfg_cls-frame-col" },
              enable: { key: "ef-cfg_use-cls-frame-col" },
            },
          },
        },
      },
      {
        name: "ef-cfg_cls-frame-col-spd",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Duration",
            enable: { key: "ef-cfg_use-cls-frame-col" },
          },  
          field: { 
            store: { key: "ef-cfg_cls-frame-col-spd" },
            enable: { key: "ef-cfg_use-cls-frame-col" },
          },
          decrease: {
            store: { key: "ef-cfg_cls-frame-col-spd" },
            enable: { key: "ef-cfg_use-cls-frame-col" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-cfg_cls-frame-col-spd" },
            enable: { key: "ef-cfg_use-cls-frame-col" },
            factor: 0.01,
          },
          stick: {
            store: { key: "ef-cfg_cls-frame-col-spd" },
            enable: { key: "ef-cfg_use-cls-frame-col" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-cfg_cls-frame-col-spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-cfg_cls-frame-alpha",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Alpha",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "ef-cfg_use-cls-frame-alpha" },
            },
            field: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_use-cls-frame-alpha" },
            },
            decrease: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_use-cls-frame-alpha" },
              factor: -0.01,
            },
            increase: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_use-cls-frame-alpha" },
              factor: 0.001,
            },
            stick: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_use-cls-frame-alpha" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "ef-cfg_use-cls-frame-alpha" },
            },
            title: { 
              text: "Override",
              enable: { key: "ef-cfg_use-cls-frame-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            field: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            decrease: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha"},
              factor: -0.01,
            },
            increase: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.001,
            },
            stick: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            title: { 
              text: "Change",
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            field: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            decrease: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: -0.01,
            },
            increase: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.001,
            },
            stick: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.01,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            field: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
            },
            decrease: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.01,
            },
            increase: { 
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.001,
            },
            stick: {
              store: { key: "ef-cfg_cls-frame-alpha" },
              enable: { key: "ef-cfg_change-cls-frame-alpha" },
              factor: 0.01,
            },
          },
        },
      },
      {
        name: "ef-cfg_cls-frame-alpha-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-cfg_particle-z",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Particle Z",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "ef-cfg_use-z" },
            },
            field: {
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_use-particle-z" },
            },
            decrease: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_use-particle-z" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_use-particle-z" },
              factor: 1.0,
            },
            stick: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_use-particle-z" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "ef-cfg_use-particle-z" },
            },
            title: { 
              text: "Override",
              enable: { key: "ef-cfg_use-particle-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "ef-cfg_change-particle-z" },
            },
            field: {
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
            },
            decrease: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 1.0,
            },
            stick: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "ef-cfg_change-particle-z" },
            },
            title: { 
              text: "Change",
              enable: { key: "ef-cfg_change-particle-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "ef-cfg_change-particle-z" },
            },
            field: {
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
            },
            decrease: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: -0.01,
            },
            increase: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 0.01,
            },
            stick: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 0.01,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "ef-cfg_change-particle-z" },
            },
            field: {
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
            },
            decrease: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: -0.001,
            },
            increase: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 0.001,
            },
            stick: { 
              store: { key: "ef-cfg_particle-z" },
              enable: { key: "ef-cfg_change-particle-z" },
              factor: 0.001,
            },
          },
        },
      },
    ]),
  }
}