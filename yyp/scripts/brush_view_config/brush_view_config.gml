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
      "view-config_bkt-trigger": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_bkt-trigger", false),
      },
      "view-config_bkt-use-config": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_bkt-use-config", false),
      },
      "view-config_bkt-config": {
        type: String,
        value: Struct.getDefault(json, "view-config_bkt-config", "easy"),
        validate: function(value) {
          Assert.isTrue(this.data.contains(value))
        },
        data: Beans.get(BeanVisuController).gridRenderer.bktGlitchService.configs.keys(),
      },
      "view-config_bkt-use-factor": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_bkt-use-factor", false),
      },
      "view-config_bkt-factor": {
        type: Number,
        value: Struct.getDefault(json, "view-config_bkt-factor", 0.001),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, 0.001), 0.000001, 999.9)
        }
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
      {
        name: "view-config_bkt-trigger",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Trigger BTKGlitch",
            enable: { key: "view-config_bkt-trigger" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_bkt-trigger" },
          },
        },
      },
      {
        name: "view-config_bkt-use-factor",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set BKTGlitch factor",
            enable: { key: "view-config_bkt-use-factor" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_bkt-use-factor" },
          },
        },
      },
      {
        name: "view-config_bkt-factor",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Factor",
            enable: { key: "view-config_bkt-use-factor" },
          },  
          field: { 
            store: { key: "view-config_bkt-factor" },
            enable: { key: "view-config_bkt-use-factor" },
          },
        },
      },
      {
        name: "view-config_bkt-use-config",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Load BKTGlitch config",
            enable: { key: "view-config_bkt-use-config" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_bkt-use-config" },
          },
        },
      },
      {
        name: "view-config_bkt-config",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Type",
            enable: { key: "view-config_bkt-use-config" },
          },
          previous: { 
            store: { key: "view-config_bkt-config" },
            enable: { key: "view-config_bkt-use-config" },
          },
          preview: Struct.appendRecursive({ 
            store: { key: "view-config_bkt-config" },
            enable: { key: "view-config_bkt-use-config" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { 
            store: { key: "view-config_bkt-config" },
            enable: { key: "view-config_bkt-use-config" },
          },
        },
      },
    ]),
  }
}