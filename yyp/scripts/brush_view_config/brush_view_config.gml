///@package io.alkapivo.visu.editor.service.brush.view

///@param {?Struct} [json]
///@return {Struct}
function brush_view_config(json = null) {
  return {
    name: "brush_view_config",
    store: new Map(String, Struct, {
      "view-config_use-render-particles": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-render-particles", false),
      },
      "view-config_render-particles": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_render-particles", false),
      },
      "view-config_use-transform-particles-z": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-particles-z", false),
      },
      "view-config_transform-particles-z": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-particles-z",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-render-video": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-render-video", false),
      },
      "view-config_render-video": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_render-video", false),
      },
    }),
    components: new Array(Struct, [
      {
        name: "view-config_use-render-particles",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render particles",
            enable: { key: "view-config_use-render-particles" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-render-particles" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_render-particles" },
            enable: { key: "view-config_use-render-particles" },
          }
        },
      },
      {
        name: "view-config_transform-particles-z",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform particle z",
              enable: { key: "view-config_use-transform-particles-z" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-particles-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-particles-z" },
            },
            field: {
              store: { key: "view-config_transform-particles-z" },
              enable: { key: "view-config_use-transform-particles-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-particles-z" },
            },
            field: {
              store: { key: "view-config_transform-particles-z" },
              enable: { key: "view-config_use-transform-particles-z" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-particles-z" },
            },
            field: {
              store: { key: "view-config_transform-particles-z" },
              enable: { key: "view-config_use-transform-particles-z" },
            },
          },
        },
      },
      {
        name: "view-config_use-render-videos",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render video",
            enable: { key: "view-config_use-render-video" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-render-video" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_render-video" },
            enable: { key: "view-config_use-render-video" },
          }
        },
      },
    ]),
  }
}