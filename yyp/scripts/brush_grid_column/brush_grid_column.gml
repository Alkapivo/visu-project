///@package io.alkapivo.visu.editor.service.brush.grid

///@param {Struct} json
///@return {Struct}
function brush_grid_column(json) {
  return {
    name: "brush_grid_column",
    store: new Map(String, Struct, {
      "gr-c_use-mode": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-mode"),
      },
      "gr-c_mode": {
        type: String,
        value: Struct.get(json, "gr-c_mode"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: GridMode.keys(),
      },
      "gr-c_use-amount": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-amount"),
      },
      "gr-c_amount": {
        type: NumberTransformer,
        value: Struct.get(json, "gr-c_amount"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 999.9),
      },
      "gr-c_change-amount": {
        type: Boolean,
        value: Struct.get(json, "gr-c_change-amount"),
      },
      "gr-c_use-main-col": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-main-col"),
      },
      "gr-c_main-col": {
        type: Color,
        value: Struct.get(json, "gr-c_main-col"),
      },
      "gr-c_main-col-spd": {
        type: Number,
        value: Struct.get(json, "gr-c_main-col-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "gr-c_use-main-alpha": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-main-alpha"),
      },
      "gr-c_main-alpha": {
        type: NumberTransformer,
        value: Struct.get(json, "gr-c_main-alpha"),
        passthrough: UIUtil.passthrough.getNormalizedNumberTransformer(),
      },
      "gr-c_change-main-alpha": {
        type: Boolean,
        value: Struct.get(json, "gr-c_change-main-alpha"),
      },
      "gr-c_use-main-size": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-main-size"),
      },
      "gr-c_main-size": {
        type: NumberTransformer,
        value: Struct.get(json, "gr-c_main-size"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 9999.9),
      },
      "gr-c_change-main-size": {
        type: Boolean,
        value: Struct.get(json, "gr-c_change-main-size"),
      },
      "gr-c_use-side-col": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-side-col"),
      },
      "gr-c_side-col": {
        type: Color,
        value: Struct.get(json, "gr-c_side-col"),
      },
      "gr-c_side-col-spd": {
        type: Number,
        value: Struct.get(json, "gr-c_side-col-spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "gr-c_use-side-alpha": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-side-alpha"),
      },
      "gr-c_side-alpha": {
        type: NumberTransformer,
        value: Struct.get(json, "gr-c_side-alpha"),
        passthrough: UIUtil.passthrough.getNormalizedNumberTransformer(),
      },
      "gr-c_change-side-alpha": {
        type: Boolean,
        value: Struct.get(json, "gr-c_change-side-alpha"),
      },
      "gr-c_use-side-size": {
        type: Boolean,
        value: Struct.get(json, "gr-c_use-side-size"),
      },
      "gr-c_side-size": {
        type: NumberTransformer,
        value: Struct.get(json, "gr-c_side-size"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 9999.9),
      },
      "gr-c_change-side-size": {
        type: Boolean,
        value: Struct.get(json, "gr-c_change-side-size"),
      },
    }),
    components: new Array(Struct, [
      {
        name: "gr-c_use-mode",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Columns render mode",
            enable: { key: "gr-c_use-mode" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "gr-c_use-mode" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "gr-c_mode",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "",
            enable: { key: "gr-c_use-mode" },
          },
          previous: { 
            enable: { key: "gr-c_use-mode" },
            store: { key: "gr-c_mode" },
          },
          preview: Struct.appendRecursive({ 
            enable: { key: "gr-c_use-mode" },
            store: { key: "gr-c_mode" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            enable: { key: "gr-c_use-mode" },
            store: { key: "gr-c_mode" },
          },
        },
      },
      {
        name: "gr-c_mode-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "gr-c_amount",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Amount",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "gr-c_use-amount" },
            },
            field: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_use-amount" },
            },
            decrease: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_use-amount" },
              factor: -0.25,
            },
            increase: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_use-amount" },
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-amount" },
            },
            title: { 
              text: "Override",
              enable: { key: "gr-c_use-amount" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "gr-c_change-amount" },
            },
            field: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
            },
            decrease: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
              factor: -0.25,
            },
            increase: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_change-amount" },
            },
            title: { 
              text: "Change",
              enable: { key: "gr-c_change-amount" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "gr-c_change-amount" },
            },
            field: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
            },
            decrease: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },            
              factor: 0.01,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "gr-c_change-amount" },
            },
            field: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
            },
            decrease: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },
              factor: -0.001,
            },
            increase: {
              store: { key: "gr-c_amount" },
              enable: { key: "gr-c_change-amount" },            
              factor: 0.001,
            },
          },
        },
      },
      {
        name: "gr-c_amount-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "gr-c_main-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Main columns",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "gr-c_main-size",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          value: {
            label: {
              text: "Thickness",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "gr-c_use-main-size" },
            },
            field: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_use-main-size" },
            },
            decrease: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_use-main-size" },
              value: -0.25,
            },
            increase: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_use-main-size" },
              value: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-main-size" },
            },
            title: { 
              text: "Override",
              enable: { key: "gr-c_use-main-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "gr-c_change-main-size" },
            },
            field: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
            },
            decrease: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: -0.25,
            },
            increase: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_change-main-size" },
            },
            title: { 
              text: "Change",
              enable: { key: "gr-c_change-main-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "gr-c_change-main-size" },
            },
            field: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
            },
            decrease: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: -0.01,
            },
            increase: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: 0.01,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "gr-c_change-main-size" },
            },
            field: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
            },
            decrease: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: -0.001,
            },
            increase: {
              store: { key: "gr-c_main-size" },
              enable: { key: "gr-c_change-main-size" },
              value: 0.001,
            },
          },
        },
      },
      {
        name: "gr-c_main-size-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "gr-c_main-alpha",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Alpha",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "gr-c_use-main-alpha" },
            },
            field: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_use-main-alpha" },
            },
            decrease: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_use-main-alpha" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_use-main-alpha" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-main-alpha" },
            },
            title: { 
              text: "Override",
              enable: { key: "gr-c_use-main-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "gr-c_change-main-alpha" },
            },
            field: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
            },
            decrease: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_change-main-alpha" },
            },
            title: { 
              text: "Change",
              enable: { key: "gr-c_change-main-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "gr-c_change-main-alpha" },
            },
            field: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
            },
            decrease: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: -0.001,
            },
            increase: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: 0.001,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "gr-c_change-main-alpha" },
            },
            field: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
            },
            decrease: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: -0.0001,
            },
            increase: {
              store: { key: "gr-c_main-alpha" },
              enable: { key: "gr-c_change-main-alpha" },
              factor: 0.0001,
            },
          },
        },
      },
      {
        name: "gr-c_main-col",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: {
              text: "Color",
              enable: { key: "gr-c_use-main-col" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-main-col" },
              backgroundColor: VETheme.color.side,
            },
            input: { 
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
              backgroundColor: VETheme.color.side,
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "gr-c_use-main-col" },
            },
            field: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
            slider: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "gr-c_use-main-col" },
            },
            field: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
            slider: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "gr-c_use-main-col" },
            },
            field: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
            slider: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "gr-c_use-main-col" },
            },
            field: {
              store: { key: "gr-c_main-col" },
              enable: { key: "gr-c_use-main-col" },
            },
          },
        },
      },
      {
        name: "gr-c_main-col-spd",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Duration",
            enable: { key: "gr-c_use-main-col" },
          },  
          field: { 
            store: { key: "gr-c_main-col-spd" },
            enable: { key: "gr-c_use-main-col" },
          },
          decrease: {
            store: { key: "gr-c_main-col-spd" },
            enable: { key: "gr-c_use-main-col" },
            factor: -0.1,
          },
          increase: {
            store: { key: "gr-c_main-col-spd" },
            enable: { key: "gr-c_use-main-col" },
            factor: 0.1,
          },
          stick: {
            store: { key: "gr-c_main-col-spd" },
            enable: { key: "gr-c_use-main-col" },
          },
          checkbox: { },
        },
      },
      {
        name: "gr-c_main-col-spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "gr-c_side-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Side columns",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "gr-c_side-size",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          value: {
            label: {
              text: "Thickness",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "gr-c_use-side-size" },
            },
            field: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_use-side-size" },
            },
            decrease: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_use-side-size" },
              factor: -0.25,
            },
            increase: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_use-side-size" },
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-side-size" },
            },
            title: { 
              text: "Override",
              enable: { key: "gr-c_use-side-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "gr-c_change-side-size" },
            },
            field: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
            },
            decrease: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: -0.25,
            },
            increase: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_change-side-size" },
            },
            title: { 
              text: "Change",
              enable: { key: "gr-c_change-side-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "gr-c_change-side-size" },
            },
            field: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
            },
            decrease: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: 0.01,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "gr-c_change-side-size" },
            },
            field: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
            },
            decrease: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: -0.001,
            },
            increase: {
              store: { key: "gr-c_side-size" },
              enable: { key: "gr-c_change-side-size" },
              factor: 0.001,
            },
          },
        },
      },
      {
        name: "gr-c_side-size-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "gr-c_side-alpha",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Alpha",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "gr-c_use-side-alpha" },
            },
            field: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_use-side-alpha" },
            },
            decrease: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_use-side-alpha" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_use-side-alpha" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-side-alpha" },
            },
            title: { 
              text: "Override",
              enable: { key: "gr-c_use-side-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "gr-c_change-side-alpha" },
            },
            field: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
            },
            decrease: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
              factor: -0.01,
            },
            increase: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" }, 
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_change-side-alpha" },
            },
            title: { 
              text: "Change",
              enable: { key: "gr-c_change-side-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "gr-c_change-side-alpha" },
            },
            field: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
            },
            decrease: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
              factor: -0.001,
            },
            increase: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" }, 
              factor: 0.001,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "gr-c_change-side-alpha" },
            },
            field: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
            },
            decrease: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" },
              factor: -0.0001,
            },
            increase: {
              store: { key: "gr-c_side-alpha" },
              enable: { key: "gr-c_change-side-alpha" }, 
              factor: 0.0001,
            },
          },
        },
      },
      {
        name: "gr-c_side-col",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { 
            type: UILayoutType.VERTICAL,
            hex: { margin: { top: 0 } },
          },
          title: { 
            label: {
              text: "Color",
              enable: { key: "gr-c_use-side-col" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "gr-c_use-side-col" },
              backgroundColor: VETheme.color.side,
            },
            input: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
              backgroundColor: VETheme.color.side,
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "gr-c_use-side-col" },
            },
            field: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
            slider: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "gr-c_use-side-col" },
            },
            field: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
            slider: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "gr-c_use-side-col" },
            },
            field: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
            slider: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "gr-c_use-side-col" },
            },
            field: {
              store: { key: "gr-c_side-col" },
              enable: { key: "gr-c_use-side-col" },
            },
          },
        },
      },
      {
        name: "gr-c_side-col-spd",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Duration",
            enable: { key: "gr-c_use-side-col" },
          },  
          field: { 
            store: { key: "gr-c_side-col-spd" },
            enable: { key: "gr-c_use-side-col" },
          },
          decrease: {
            store: { key: "gr-c_side-col-spd" },
            enable: { key: "gr-c_use-side-col" },
            factor: -0.1,
          },
          increase: {
            store: { key: "gr-c_side-col-spd" },
            enable: { key: "gr-c_use-side-col" },
            factor: 0.1,
          },
          stick: {
            store: { key: "gr-c_side-col-spd" },
            enable: { key: "gr-c_use-side-col" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
    ]),
  }
}