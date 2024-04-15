///@package io.alkapivo.visu.editor.service.brush.view

///@param {?Struct} [json]
///@return {Struct}
function brush_view_camera(json = null) {
  return {
    name: "brush_view_camera",
    store: new Map(String, Struct, {
      "view-config_use-lock-target-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-lock-target-x", false),
      },
      "view-config_lock-target-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_lock-target-x", false),
      },
      "view-config_use-lock-target-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-lock-target-y", false),
      },
      "view-config_lock-target-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_lock-target-y", false),
      },
      "view-config_use-transform-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-x", false),
      },
      "view-config_transform-x": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-x",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-y", false),
      },
      "view-config_transform-y": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-y",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-z": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-z", false),
      },
      "view-config_transform-z": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-z",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-zoom": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-zoom", false),
      },
      "view-config_transform-zoom": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-zoom",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-angle": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-angle", false),
      },
      "view-config_transform-angle": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-angle",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-pitch": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-pitch", false),
      },
      "view-config_transform-pitch": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-pitch",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "view-config_use-lock-target-x",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lock target X",
            enable: { key: "view-config_use-lock-target-x" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-lock-target-x" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_lock-target-x" },
            enable: { key: "view-config_use-lock-target-x" },
          },
        },
      },
      {
        name: "view-config_use-lock-target-y",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lock target Y",
            enable: { key: "view-config_use-lock-target-y" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-lock-target-y" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_lock-target-y" },
            enable: { key: "view-config_use-lock-target-y" },
          },
        },
      },
      {
        name: "view-config_transform-x",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera x",
              enable: { key: "view-config_use-transform-x" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-x" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
          increment: {
            label: { 
              text: "Increment",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
        },
      },
      {
        name: "view-config_transform-y",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform camera y",
              enable: { key: "view-config_use-transform-y" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-y" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
        },
      },
      {
        name: "view-config_transform-z",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera z",
              enable: { key: "view-config_use-transform-z" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
        },
      },
      {
        name: "view-config_transform-zoom",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera zoom",
              enable: { key: "view-config_use-transform-zoom" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-zoom" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
        },
      },
      {
        name: "view-config_transform-angle",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera angle",
              enable: { key: "view-config_use-transform-angle" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-angle" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
        },
      },
      {
        name: "view-config_transform-pitch",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera pitch",
              enable: { key: "view-config_use-transform-pitch" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-pitch" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
        },
      },
    ]),
  }
}