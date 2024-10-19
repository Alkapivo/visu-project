///@package io.alkapivo.visu.editor.service.brush.shader

///@param {?Struct} [json]
///@return {Struct}
function brush_shader_config(json = null) {
  return {
    name: "brush_shader_config",
    store: new Map(String, Struct, {
      "shader-config_use-render-grid-shaders": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_use-render-grid-shaders", false),
      },
      "shader-config_render-grid-shaders": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_render-grid-shaders", false),
      },
      "shader-config_use-background-grid-shaders": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_use-background-grid-shaders", false),
      },
      "shader-config_background-grid-shaders": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_background-grid-shaders", false),
      },
      "shader-config_use-clear-frame": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_use-clear-frame", false),
      },
      "shader-config_clear-frame": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_clear-frame", false),
      },
      "shader-config_use-clear-color": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_use-clear-color", false),
      },
      "shader-config_clear-color": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(json, "shader-config_clear-color"), "#000000"),
      },
      "shader-config_use-transform-clear-frame-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-config_use-transform-clear-frame-alpha", false),
      },
      "shader-config_transform-clear-frame-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "shader-config_transform-clear-frame-alpha", 
          { value: 0, target: 5, factor: 0.03, increase: 2 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "shader-config_render-grid-shaders",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render shaders",
            enable: { key: "shader-config_use-render-grid-shaders" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shader-config_use-render-grid-shaders" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "shader-config_render-grid-shaders" },
            enable: { key: "shader-config_use-render-grid-shaders" },
          },
        },
      },
      {
        name: "shader-config_background-grid-shaders",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render bkg shaders",
            enable: { key: "shader-config_use-background-grid-shaders" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shader-config_use-background-grid-shaders" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "shader-config_background-grid-shaders" },
            enable: { key: "shader-config_use-background-grid-shaders" },
          },
        },
      },
      {
        name: "shader-config_clear-frame",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear frame",
            enable: { key: "shader-config_use-clear-frame" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shader-config_use-clear-frame" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "shader-config_clear-frame" },
            enable: { key: "shader-config_use-clear-frame" },
          },
        },
      },
      {
        name: "shader-config_clear-color",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Set clear color",
              enable: { key: "shader-config_use-clear-color" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "shader-config_use-clear-color" },
            },
            input: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            }
          },
          red: {
            label: { 
              text: "Red",
              enable: { key: "shader-config_use-clear-color" },
            },
            field: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
            slider: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
          },
          green: {
            label: { 
              text: "Green",
              enable: { key: "shader-config_use-clear-color" },
            },
            field: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
            slider: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
          },
          blue: {
            label: { 
              text: "Blue",
              enable: { key: "shader-config_use-clear-color" },
            },
            field: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
            slider: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
          },
          hex: { 
            label: { 
              text: "Hex",
              enable: { key: "shader-config_use-clear-color" },
            },
            field: { 
              store: { key: "shader-config_clear-color" },
              enable: { key: "shader-config_use-clear-color" },
            },
          },
        },
      },
      {
        name: "shader-config_transform-clear-frame-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform clear frame alpha",
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
            field: { 
              store: { key: "shader-config_transform-clear-frame-alpha" },
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
            field: { 
              store: { key: "shader-config_transform-clear-frame-alpha" },
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
            field: { 
              store: { key: "shader-config_transform-clear-frame-alpha" },
              enable: { key: "shader-config_use-transform-clear-frame-alpha" },
            },
          },
        },
      },
    ]),
  }
}