///@package io.alkapivo.visu.editor.service.brush._old.shader

///@param {Struct} json
///@return {Struct}
function migrateShaderOverlayEvent(json) {
  //Logger.debug("Track", "migrateShaderOverlayEvent is not implemented")
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "gr-cfg_use-render-focus-grid": Struct.getIfType(json, "shader-overlay_use-render-support-grid", Boolean, false),
    "gr-cfg_render-focus-grid": Struct.getIfType(json, "shader-overlay_render-support-grid", Boolean, false),
    "gr-cfg_use-focus-grid-treshold": false,
    "gr-cfg_focus-grid-treshold": Struct.getIfType(json, "shader-overlay_transform-support-grid-treshold", Struct, {
      value: 0.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-cfg_change-focus-grid-treshold": Struct.getIfType(json, "shader-overlay_use-transform-support-grid-treshold", Boolean, false),
    "gr-cfg_use-focus-grid-alpha": false,
    "gr-cfg_focus-grid-alpha": Struct.getIfType(json, "shader-overlay_transform-support-grid-alpha", Struct, {
      value: 0.0,
      target: 1.0,
      factor: 1.0,
      increase: 0.0,
    }),
    "gr-cfg_change-focus-grid-alpha": Struct.getIfType(json, "shader-overlay_use-transform-support-grid-alpha", Boolean, false),
    "gr-cfg_focus-grid-use-blend": true,
    "gr-cfg_focus-grid-blend-src": BlendModeExt.getKey(BlendModeExt.SRC_ALPHA),
    "gr-cfg_focus-grid-blend-dest": BlendModeExt.getKey(BlendModeExt.ONE),
    "gr-cfg_focus-grid-blend-eq": BlendEquation.getKey(BlendEquation.ADD),
    "gr-cfg_focus-grid-blend-eq-alpha": BlendEquation.getKey(BlendEquation.ADD),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_shader_overlay(json = null) {
  return {
    name: "brush_shader_overlay",
    store: new Map(String, Struct, {
      "shader-overlay_use-render-support-grid": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-overlay_use-render-support-grid", false),
      },
      "shader-overlay_render-support-grid": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-overlay_render-support-grid", false),
      },
      "shader-overlay_use-transform-support-grid-treshold": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-overlay_use-transform-support-grid-treshold", false),
      },
      "shader-overlay_transform-support-grid-treshold": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "shader-overlay_transform-support-grid-treshold", 
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "shader-overlay_use-transform-support-grid-alpha": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-overlay_use-transform-support-grid-alpha", false),
      },
      "shader-overlay_transform-support-grid-alpha": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "shader-overlay_transform-support-grid-alpha", 
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "shader-overlay_use-render-support-grid",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render support grid",
            enable: { key: "shader-overlay_use-render-support-grid" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shader-overlay_use-render-support-grid" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "shader-overlay_render-support-grid" },
            enable: { key: "shader-overlay_use-render-support-grid" },
          },
        },
      },
      {
        name: "shader-overlay_transform-support-grid-treshold",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform support grid treshold",
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-treshold" },
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-treshold" },
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-treshold" },
              enable: { key: "shader-overlay_use-transform-support-grid-treshold" },
            },
          },
        },
      },
      {
        name: "shader-overlay_transform-support-grid-alpha",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform support grid alpha",
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-alpha" },
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-alpha" },
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
            field: { 
              store: { key: "shader-overlay_transform-support-grid-alpha" },
              enable: { key: "shader-overlay_use-transform-support-grid-alpha" },
            },
          },
        },
      },
    ]),
  }
}