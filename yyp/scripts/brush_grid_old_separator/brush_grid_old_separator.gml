///@package io.alkapivo.visu.editor.service.brush._old.grid_old

///@param {Struct} json
///@return {Struct}
function migrateGridOldSeparatorEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "gr-r_use-mode": Struct.getIfType(json, "grid-separator_use-mode", Boolean, false),
    "gr-r_mode": Struct.getIfType(json, "grid-separator_mode", String, "DUAL"),
    "gr-r_use-amount": false,
    "gr-r_amount": Struct.getIfType(json, "grid-separator_transform-amount", Struct),
    "gr-r_change-amount": Struct.getIfType(json, "grid-separator_use-transform-amount", Boolean, false),
    "gr-r_use-main-col": Struct.getIfType(json, "grid-separator_use-primary-color", Boolean, false),
    "gr-r_main-col": Struct.getIfType(json, "grid-separator_primary-color", String, "#ffffff"),
    "gr-r_main-col-spd": Struct.getIfType(json, "grid-separator_primary-color-speed", Number, 1.0),
    "gr-r_use-main-alpha": false,
    "gr-r_main-alpha": Struct.getIfType(json, "grid-separator_transform-primary-alpha", Struct),
    "gr-r_change-main-alpha": Struct.getIfType(json, "grid-separator_use-transform-primary-alpha", Boolean, false),
    "gr-r_use-main-size": false,
    "gr-r_main-size": Struct.getIfType(json, "grid-separator_transform-primary-size", Struct),
    "gr-r_change-main-size": Struct.getIfType(json, "grid-separator_use-transform-primary-size", Boolean, false),
    "gr-r_use-side-col": Struct.getIfType(json, "grid-separator_use-secondary-color", Boolean, false),
    "gr-r_side-col": Struct.getIfType(json, "grid-separator_secondary-color", String, "#ffffff"),
    "gr-r_side-col-spd": Struct.getIfType(json, "grid-separator_secondary-color-speed", Number, 1.0),
    "gr-r_use-side-alpha": false,
    "gr-r_side-alpha": Struct.getIfType(json, "grid-separator_transform-secondary-alpha", Struct),
    "gr-r_change-side-alpha": Struct.getIfType(json, "grid-separator_use-transform-secondary-alpha", Boolean, false),
    "gr-r_use-side-size": false,
    "gr-r_side-size": Struct.getIfType(json, "grid-separator_transform-secondary-size", Struct),
    "gr-r_change-side-size": Struct.getIfType(json, "grid-separator_use-transform-secondary-size", Boolean, false),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_grid_old_separator(json = null) {
  return {
    name: "brush_grid_old_separator",
    store: new Map(String, Struct, {
      "grid-separator_use-transform-amount": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-amount", false),
      },
      "grid-separator_transform-amount": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-amount",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-separator_use-mode": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-mode", false),
      },
      "grid-separator_mode": {
        type: String,
        value: Struct.getIfType(json, "grid-separator_mode", String, GridMode.DUAL),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: GridMode.keys(),
      },
      "grid-separator_use-transform-z": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-z", false),
      },
      "grid-separator_transform-z": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-z",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-separator_use-primary-color": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-primary-color", false),
      },
      "grid-separator_primary-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.getDefault(json, 
          "grid-separator_primary-color", "#ffffff")),
      },
      "grid-separator_primary-color-speed": {
        type: Number,
        value: Struct.getDefault(json, "grid-separator_primary-color-speed", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.9) 
        },
      },
      "grid-separator_use-transform-primary-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-primary-alpha", false),
      },
      "grid-separator_transform-primary-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-primary-alpha",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-separator_use-transform-primary-size": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-primary-size", false),
      },
      "grid-separator_transform-primary-size": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-primary-size",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-separator_use-secondary-color": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-secondary-color", false),
      },
      "grid-separator_secondary-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.getDefault(json, 
          "grid-separator_secondary-color", "#ffffff")),
      },
      "grid-separator_secondary-color-speed": {
        type: Number,
        value: Struct.getDefault(json, "grid-separator_secondary-color-speed", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.9) 
        },
      },
      "grid-separator_use-transform-secondary-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-secondary-alpha", false),
      },
      "grid-separator_transform-secondary-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-secondary-alpha",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-separator_use-transform-secondary-size": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-separator_use-transform-secondary-size", false),
      },
      "grid-separator_transform-secondary-size": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-separator_transform-secondary-size",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "grid-separator_transform-amount",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform amount",
              enable: { key: "grid-separator_use-transform-amount" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-amount" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-amount" },
            },
            field: {
              store: { key: "grid-separator_transform-amount" },
              enable: { key: "grid-separator_use-transform-amount" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-amount" },
            },
            field: {
              store: { key: "grid-separator_transform-amount" },
              enable: { key: "grid-separator_use-transform-amount" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-amount" },
            },
            field: {
              store: { key: "grid-separator_transform-amount" },
              enable: { key: "grid-separator_use-transform-amount" },
            },
          },
        },
      },
      {
        name: "grid-separator_use-mode",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Render mode",
            enable: { key: "grid-separator_use-mode" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-separator_use-mode" },
          },
        },
      },
      {
        name: "grid-separator_mode",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Mode",
            enable: { key: "grid-separator_use-mode" },
          },
          previous: { 
            enable: { key: "grid-separator_use-mode" },
            store: { key: "grid-separator_mode" },
          },
          preview: Struct.appendRecursive({ 
            enable: { key: "grid-separator_use-mode" },
            store: { key: "grid-separator_mode" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            enable: { key: "grid-separator_use-mode" },
            store: { key: "grid-separator_mode" },
          },
        },
      },
      {
        name: "grid-separator_transform-z",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform z",
              enable: { key: "grid-separator_use-transform-z" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-z" },
            },
            field: {
              store: { key: "grid-separator_transform-z" },
              enable: { key: "grid-separator_use-transform-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-z" },
            },
            field: {
              store: { key: "grid-separator_transform-z" },
              enable: { key: "grid-separator_use-transform-z" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-z" },
            },
            field: {
              store: { key: "grid-separator_transform-z" },
              enable: { key: "grid-separator_use-transform-z" },
            },
          },
        },
      },
      {
        name: "grid-separator_primary-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: {
              text: "Primary color",
              enable: { key: "grid-separator_use-primary-color" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-primary-color" },
            },
            input: { 
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "grid-separator_use-primary-color" },
            },
            field: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
            slider: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "grid-separator_use-primary-color" },
            },
            field: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
            slider: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "grid-separator_use-primary-color" },
            },
            field: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
            slider: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "grid-separator_use-primary-color" },
            },
            field: {
              store: { key: "grid-separator_primary-color" },
              enable: { key: "grid-separator_use-primary-color" },
            },
          },
        },
      },
      {
        name: "grid-separator_primary-color-speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Speed",
            enable: { key: "grid-separator_use-primary-color" },
          },
          field: { 
            enable: { key: "grid-separator_use-primary-color" },
            store: { key: "grid-separator_primary-color-speed" },
          },
        },
      },
      {
        name: "grid-separator_transform-primary-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform primary alpha",
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-primary-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-alpha" },
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-alpha" },
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-alpha" },
              enable: { key: "grid-separator_use-transform-primary-alpha" },
            },
          },
        },
      },
      {
        name: "grid-separator_transform-primary-size",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform primary size",
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-primary-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-size" },
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-size" },
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-primary-size" },
              enable: { key: "grid-separator_use-transform-primary-size" },
            },
          },
        },
      },
      {
        name: "grid-separator_secondary-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: {
              text: "Secondary color",
              enable: { key: "grid-separator_use-secondary-color" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-secondary-color" },
            },
            input: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "grid-separator_use-secondary-color" },
            },
            field: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
            slider: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "grid-separator_use-secondary-color" },
            },
            field: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
            slider: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "grid-separator_use-secondary-color" },
            },
            field: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
            slider: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "grid-separator_use-secondary-color" },
            },
            field: {
              store: { key: "grid-separator_secondary-color" },
              enable: { key: "grid-separator_use-secondary-color" },
            },
          },
        },
      },
      {
        name: "grid-separator_secondary-color-speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Speed",
            enable: { key: "grid-separator_use-secondary-color" },
          },
          field: { 
            enable: { key: "grid-separator_use-secondary-color" },
            store: { key: "grid-separator_secondary-color-speed" },
          },
        },
      },
      {
        name: "grid-separator_transform-secondary-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform secondary alpha",
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-secondary-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-alpha" },
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-alpha" },
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-alpha" },
              enable: { key: "grid-separator_use-transform-secondary-alpha" },
            },
          },
        },
      },
      {
        name: "grid-separator_transform-secondary-size",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform secondary size",
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-separator_use-transform-secondary-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-size" },
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-size" },
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
            field: {
              store: { key: "grid-separator_transform-secondary-size" },
              enable: { key: "grid-separator_use-transform-secondary-size" },
            },
          },
        },
      },
    ]),
  }
}