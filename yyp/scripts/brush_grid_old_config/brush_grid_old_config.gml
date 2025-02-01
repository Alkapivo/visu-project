///@package io.alkapivo.visu.editor.service.brush._old.grid_old

///@param {Struct} json
///@return {Struct}
function migrateGridOldConfigEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "gr-cfg_use-render": Struct.getIfType(json, "grid-config_use-render-grid", Boolean, false),
    "gr-cfg_render": Struct.getIfType(json, "grid-config_render-grid", Boolean, false),
    "gr-cfg_use-spd": false,
    "gr-cfg_spd": Struct.getIfType(json, "grid-config_speed", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-cfg_change-spd": Struct.getIfType(json, "grid-config_use-speed", Boolean, false),
    "gr-cfg_use-cls-frame": Struct.getIfType(json, "grid-config_use-clear-frame", Boolean, false),
    "gr-cfg_cls-frame": Struct.getIfType(json, "grid-config_clear-frame", Boolean, false),
    "gr-cfg_use-cls-frame-col": Struct.getIfType(json, "grid-config_use-clear-color", Boolean, false),
    "gr-cfg_cls-frame-col": Struct.getIfType(json, "grid-config_clear-color", String, "#000000"),
    "gr-cfg_cls-frame-col-spd": 1.0,
    "gr-cfg_use-cls-frame-alpha": false,
    "gr-cfg_cls-frame-alpha": Struct.getIfType(json, "grid-config_clear-frame-alpha", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-cfg_change-cls-frame-alpha": Struct.getIfType(json, "grid-config_use-clear-frame-alpha", Boolean, false),
  }
}


///@param {Struct} json
///@return {Struct}
function migrateGridOldConfigToGridAreaEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "gr-area_use-h": false,
    "gr-area_h": Struct.getIfType(json, "grid-config_border-horizontal-width", Struct, {
      value: 2.0,
      target: 2.0,
      factor: 2.0,
      increase: 0.0,
    }),
    "gr-area_change-h": Struct.getIfType(json, "grid-config_use-border-horizontal-width", Boolean, false),
    "gr-area_use-h-col": Struct.getIfType(json, "grid-config_use-border-bottom-color", Boolean, false),
    "gr-area_h-col": Struct.getIfType(json, "grid-config_border-bottom-color", String, "#ffffff"),
    "gr-area_h-col-spd": Struct.getIfType(json, "grid-config_border-bottom-color-speed", Number, 1.0),
    "gr-area_use-h-alpha": false,
    "gr-area_h-alpha": Struct.getIfType(json, "grid-config_border-bottom-alpha", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-area_change-h-alpha": Struct.getIfType(json, "grid-config_use-border-bottom-alpha", Boolean, false),
    "gr-area_use-h-size": false,
    "gr-area_h-size": Struct.getIfType(json, "grid-config_border-bottom-size", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-area_change-h-size": Struct.getIfType(json, "grid-config_use-border-bottom-size", Boolean, false),
    "gr-area_use-v": false,
    "gr-area_v": Struct.getIfType(json, "grid-config_border-horizontal-height", Struct, {
      value: 2.0,
      target: 2.0,
      factor: 2.0,
      increase: 0.0,
    }),
    "gr-area_change-v": Struct.getIfType(json, "grid-config_use-border-horizontal-height", Boolean, false),
    "gr-area_use-v-col": Struct.getIfType(json, "grid-config_use-border-horizontal-color", Boolean, false),
    "gr-area_v-col": Struct.getIfType(json, "grid-config_border-horizontal-color", String, "#ffffff"),
    "gr-area_v-col-spd": Struct.getIfType(json, "grid-config_border-horizontal-color-speed", Number, 1.0),
    "gr-area_use-v-alpha": false,
    "gr-area_v-alpha": Struct.getIfType(json, "grid-config_border-horizontal-alpha", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-area_change-v-alpha": Struct.getIfType(json, "grid-config_use-border-horizontal-alpha", Boolean, false),
    "gr-area_use-v-size": false,
    "gr-area_v-size": Struct.getIfType(json, "grid-config_border-horizontal-size", Struct, {
      value: 1.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-area_change-v-size": Struct.getIfType(json, "grid-config_use-border-horizontal-size", Boolean, false),
  }
}


///@param {Struct} json
///@return {Struct}
function migrateGridOldConfigToEntityConfigEvent(json) {
  var useRender = Struct.getIfType(json, "grid-config_use-render-grid-elements", Boolean, false)
  var render = Struct.getIfType(json, "grid-config_render-grid-elements", Boolean, false)
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "en-cfg_use-render-shr": useRender,
    "en-cfg_render-shr": render,
    "en-cfg_use-render-player": useRender,
    "en-cfg_render-player": render,
    "en-cfg_use-render-coin": useRender,
    "en-cfg_render-coin": render,
    "en-cfg_use-render-bullet": useRender,
    "en-cfg_render-bullet": render,
    "en-cfg_cls-shr": false,
    "en-cfg_cls-player": Struct.getIfType(json, "grid-config_clear-player", Boolean, false),
    "en-cfg_cls-coin": Struct.getIfType(json, "grid-config_clear-coins", Boolean, false),
    "en-cfg_cls-bullet": Struct.getIfType(json, "grid-config_clear-bullets", Boolean, false),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_grid_old_config(json = null) {
  return {
    name: "brush_grid_old_config",
    store: new Map(String, Struct, {
      "grid-config_use-render-grid": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-render-grid", false),
      },
      "grid-config_render-grid": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_render-grid", false),
      },
      "grid-config_use-render-grid-elements": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-render-grid-elements", false),
      },
      "grid-config_render-grid-elements": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_render-grid-elements", false),
      },
      "grid-config_use-speed": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-speed", false),
      },
      "grid-config_speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_speed", 
          { value: (FRAME_MS / 4) * 1000, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-clear-frame": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-clear-frame", false),
      },
      "grid-config_clear-frame": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_clear-frame", false),
      },
      "grid-config_use-clear-color": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-clear-color", false),
      },
      "grid-config_clear-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "grid-config_clear-color"), "#000000"),
      },
      "grid-config_use-clear-frame-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-clear-frame-alpha", false),
      },
      "grid-config_clear-frame-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_clear-frame-alpha", 
          { value: 0, target: 5, factor: 0.03, increase: 2 }
        )),
      },
      "grid-config_use-gamemode": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-gamemode", false),
      },
      "grid-config_gamemode": {
        type: String,
        value: Struct.getDefault(json, "grid-config_gamemode", GameMode.keys().get(0)),
        validate: function(value) {
          Assert.isEnumKey(value, GameMode)
        },
        data: GameMode.keys(),
      },
      "grid-config_use-border-bottom-color": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-bottom-color", false),
      },
      "grid-config_border-bottom-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "grid-config_border-bottom-color"), "#ffffff"),
      },
      "grid-config_border-bottom-color-speed": {
        type: Number,
        value: Struct.getDefault(json, "grid-config_border-bottom-color-speed", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.9) 
        },
      },
      "grid-config_use-border-bottom-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-bottom-alpha", false),
      },
      "grid-config_border-bottom-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-bottom-alpha",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-border-bottom-size": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-bottom-size", false),
      },
      "grid-config_border-bottom-size": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-bottom-size",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-border-horizontal-color": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-horizontal-color", false),
      },
      "grid-config_border-horizontal-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "grid-config_border-horizontal-color"), "#ffffff"),
      },
      "grid-config_border-horizontal-color-speed": {
        type: Number,
        value: Struct.getDefault(json, "grid-config_border-horizontal-color-speed", 0.01),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.9) 
        },
      },
      "grid-config_use-border-horizontal-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-horizontal-alpha", false),
      },
      "grid-config_border-horizontal-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-horizontal-alpha",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-border-horizontal-size": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-horizontal-size", false),
      },
      "grid-config_border-horizontal-size": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-horizontal-size",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-border-horizontal-width": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-horizontal-width", false),
      },
      "grid-config_border-horizontal-width": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-horizontal-width",
          { value: 0, target: 2, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_use-border-horizontal-height": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_use-border-horizontal-height", false),
      },
      "grid-config_border-horizontal-height": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-config_border-horizontal-height",
          { value: 0, target: 2, factor: 0.01, increase: 0 }
        )),
      },
      "grid-config_clear-player": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_clear-player", false),
      },
      "grid-config_clear-bullets": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_clear-bullets", false),
      },
      "grid-config_clear-coins": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-config_clear-coins", false),
      },
    }),
    components: new Array(Struct, [
      {
        name: "grid-config_use-render-grid",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Render grid",
            enable: { key: "grid-config_use-render-grid" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_use-render-grid" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "grid-config_render-grid" },
            enable: { key: "grid-config_use-render-grid" },
          }
        },
      },
      {
        name: "grid-config_use-render-grid-elements",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Render elements",
            enable: { key: "grid-config_use-render-grid-elements" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_use-render-grid-elements" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "grid-config_render-grid-elements" },
            enable: { key: "grid-config_use-render-grid-elements" },
          }
        },
      },
      {
        name: "grid-config_speed",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform speed",
              enable: { key: "grid-config_use-speed" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-speed" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "grid-config_use-speed" },
            },
            field: { 
              store: { key: "grid-config_speed" },
              enable: { key: "grid-config_use-speed" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-speed" },
            },
            field: { 
              store: { key: "grid-config_speed" },
              enable: { key: "grid-config_use-speed" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-speed" },
            },
            field: { 
              store: { key: "grid-config_speed" },
              enable: { key: "grid-config_use-speed" },
            },
          },
        },
      },
      {
        name: "grid-config_clear-frame",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Clear frame",
            enable: { key: "grid-config_use-clear-frame" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_use-clear-frame"}
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "grid-config_clear-frame" },
            enable: { key: "grid-config_use-clear-frame" },
          },
        },
      },
      {
        name: "grid-config_clear-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Set clear color",
              enable: { key: "grid-config_use-clear-color" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-clear-color" },
            },
            input: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "grid-config_use-clear-color" },
            },
            field: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
            slider: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "grid-config_use-clear-color" },
            },
            field: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
            slider: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "grid-config_use-clear-color" },
            },
            field: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
            slider: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "grid-config_use-clear-color" },
            },
            field: { 
              store: { key: "grid-config_clear-color" },
              enable: { key: "grid-config_use-clear-color" },
            },
          },
        },
      },
      {
        name: "grid-config_clear-frame-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform clear frame alpha",
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-clear-frame-alpha"}
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
            field: {
              store: { key: "grid-config_clear-frame-alpha" },
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
            field: {
              store: { key: "grid-config_clear-frame-alpha" },
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
            field: { 
              store: { key: "grid-config_clear-frame-alpha" },
              enable: { key: "grid-config_use-clear-frame-alpha" },
            },
          },
        },
      },
      {
        name: "grid-config_use-gamemode",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Set gamemode",
            enable: { key: "grid-config_use-gamemode" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_use-gamemode" },
          },
        },
      },
      {
        name: "grid-config_gamemode",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Mode",
            enable: { key: "grid-config_use-gamemode" },
          },
          previous: { 
            enable: { key: "grid-config_use-gamemode" },
            store: { key: "grid-config_gamemode" },
          },
          preview: Struct.appendRecursive({ 
            enable: { key: "grid-config_use-gamemode" },
            store: { key: "grid-config_gamemode" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            enable: { key: "grid-config_use-gamemode" },
            store: { key: "grid-config_gamemode" },
          },
        },
      },
      {
        name: "grid-config_clear-player",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear player",
            enable: { key: "grid-config_clear-player" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_clear-player" },
          }
        },
      },
      {
        name: "grid-config_clear-bullets",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear bullets",
            enable: { key: "grid-config_clear-bullets" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_clear-bullets" },
          }
        },
      },
      {
        name: "grid-config_clear-coins",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear coins",
            enable: { key: "grid-config_clear-coins" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-config_clear-coins" },
          }
        },
      },
      {
        name: "horizontal-border",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Horizontal border",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "grid-config_border-horizontal-width",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Horizontal border length",
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-horizontal-width" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-width" },
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-width" },
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-width" },
              enable: { key: "grid-config_use-border-horizontal-width" },
            },
          },
        },
      },
      {
        name: "grid-config_border-bottom-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: {
              text: "Horizontal border color",
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-bottom-color" },
            },
            input: { 
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            field: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            slider: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            field: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            slider: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            field: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            slider: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "grid-config_use-border-bottom-color" },
            },
            field: {
              store: { key: "grid-config_border-bottom-color" },
              enable: { key: "grid-config_use-border-bottom-color" },
            },
          },
        },
      },
      {
        name: "grid-config_border-bottom-color-speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Color speed",
            enable: { key: "grid-config_use-border-bottom-color" },
          },
          field: { 
            enable: { key: "grid-config_use-border-bottom-color" },
            store: { key: "grid-config_border-bottom-color-speed" },
          },
        },
      },
      {
        name: "grid-config_border-bottom-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Horizontal border alpha",
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-bottom-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
            field: {
              store: { key: "grid-config_border-bottom-alpha" },
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
            field: {
              store: { key: "grid-config_border-bottom-alpha" },
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
            field: {
              store: { key: "grid-config_border-bottom-alpha" },
              enable: { key: "grid-config_use-border-bottom-alpha" },
            },
          },
        },
      },
      {
        name: "grid-config_border-bottom-size",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Horizontal border size",
              enable: { key: "grid-config_use-border-bottom-size" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-bottom-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-bottom-size" },
            },
            field: {
              store: { key: "grid-config_border-bottom-size" },
              enable: { key: "grid-config_use-border-bottom-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-bottom-size" },
            },
            field: {
              store: { key: "grid-config_border-bottom-size" },
              enable: { key: "grid-config_use-border-bottom-size" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-bottom-size" },
            },
            field: {
              store: { key: "grid-config_border-bottom-size" },
              enable: { key: "grid-config_use-border-bottom-size" },
            },
          },
        },
      },
      {
        name: "vertical-border",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Vertical border",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "grid-config_border-horizontal-height",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Vertical border length",
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-horizontal-height" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-height" },
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-height" },
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-height" },
              enable: { key: "grid-config_use-border-horizontal-height" },
            },
          },
        },
      },
      {
        name: "grid-config_border-horizontal-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: {
              text: "Vertical border color",
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-horizontal-color" },
            },
            input: { 
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            }
          },
          red: {
            label: {
              text: "Red",
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            slider: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
          },
          green: {
            label: {
              text: "Green",
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            slider: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
          },
          blue: {
            label: {
              text: "Blue",
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            slider: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
          },
          hex: { 
            label: {
              text: "Hex",
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-color" },
              enable: { key: "grid-config_use-border-horizontal-color" },
            },
          },
        },
      },
      {
        name: "grid-config_border-horizontal-color-speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Color speed",
            enable: { key: "grid-config_use-border-horizontal-color" },
          },
          field: { 
            enable: { key: "grid-config_use-border-horizontal-color" },
            store: { key: "grid-config_border-horizontal-color-speed" },
          },
        },
      },
      {
        name: "grid-config_border-horizontal-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Vertical border alpha",
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-horizontal-alpha" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-alpha" },
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-alpha" },
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-alpha" },
              enable: { key: "grid-config_use-border-horizontal-alpha" },
            },
          },
        },
      },
      {
        name: "grid-config_border-horizontal-size",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Vertical border size",
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-config_use-border-horizontal-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-size" },
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-size" },
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
            field: {
              store: { key: "grid-config_border-horizontal-size" },
              enable: { key: "grid-config_use-border-horizontal-size" },
            },
          },
        },
      },
    ]),
  }
}