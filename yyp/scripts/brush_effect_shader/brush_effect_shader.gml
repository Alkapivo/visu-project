///@package io.alkapivo.visu.editor.service.brush.effect

///@param {Struct} json
///@return {Struct}
function brush_effect_shader(json) {
  return {
    name: "brush_effect_shader",
    store: new Map(String, Struct, {
      "ef-shd_template": {
        type: String,
        value: Struct.get(json, "ef-shd_template"),
        passthrough: UIUtil.passthrough.getCallbackValue(),
        data: {
          callback: Beans.get(BeanVisuController).shaderTemplateExists,
          defaultValue: "shader-default",
        },
      },
      "ef-shd_duration": {
        type: Number,
        value: Struct.get(json, "ef-shd_duration"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999.9),
      },
      "ef-shd_fade-in": {
        type: Number,
        value: Struct.get(json, "ef-shd_fade-in"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999.9),
      },
      "ef-shd_fade-out": {
        type: Number,
        value: Struct.get(json, "ef-shd_fade-out"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999.9),
      },
      "ef-shd_alpha": {
        type: Number,
        value: Struct.get(json, "ef-shd_alpha"),
        passthrough: UIUtil.passthrough.getNormalizedStringNumber(),
      },
      "ef-shd_pipeline": {
        type: String,
        value: Struct.get(json, "ef-shd_pipeline"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: ShaderPipelineType.keys(),
      },
      "ef-shd_use-merge-cfg": {
        type: Boolean,
        value: Struct.get(json, "ef-shd_use-merge-cfg"),
      },
      "ef-shd_merge-cfg": {
        type: String,
        value: JSON.stringify(Struct.get(json, "ef-shd_merge-cfg"), { pretty: true }),
        serialize: UIUtil.serialize.getStringStruct(),
        validate: UIUtil.validate.getStringStruct(),
      },
    }),
    components: new Array(Struct, [
      {
        name: "ef-shd_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "ef-shd_template" } },
        },
      },
      {
        name: "ef-shd_template-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-shd_pipeline",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 0 },
          },
          label: { text: "Pipeline" },
          previous: { store: { key: "ef-shd_pipeline" } },
          preview: Struct.appendRecursive({ 
            store: { key: "ef-shd_pipeline" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "ef-shd_pipeline" } },
        },
      },
      {
        name: "ef-shd_pipeline-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-shd_alpha",  
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Alpha",
          },
          field: { 
            store: { key: "ef-shd_alpha" },
          },
          slider:{
            minValue: 0.0,
            maxValue: 1.0,
            snapValue: 0.01 / 1.0,
            store: { key: "ef-shd_alpha" },
          },
          decrease: {
            store: { key: "ef-shd_alpha" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-shd_alpha" },
            factor: 0.01,
          },
        },
      },
      {
        name: "ef-shd_duration",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Duration",
          },  
          field: { 
            store: { key: "ef-shd_duration" },
          },
          decrease: {
            store: { key: "ef-shd_duration" },
            factor: -1.0,
          },
          increase: {
            store: { key: "ef-shd_duration" },
            factor: 1.0,
          },
          stick: {
            store: { key: "ef-shd_duration" },
            factor: 0.001,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-shd_duration-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-shd_fade-in",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Fade in",
          },  
          field: { 
            store: { key: "ef-shd_fade-in" },
          },
          decrease: {
            store: { key: "ef-shd_fade-in" },
            factor: -1.0,
          },
          increase: {
            store: { key: "ef-shd_fade-in" },
            factor: 1.0,
          },
          stick: {
            store: { key: "ef-shd_fade-in" },
            factor: 0.001,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-shd_fade-out",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Fade out",
          },  
          field: { 
            store: { key: "ef-shd_fade-out" },
          },
          decrease: {
            store: { key: "ef-shd_fade-out" },
            factor: -1.0,
          },
          increase: {
            store: { key: "ef-shd_fade-out" },
            factor: 1.0,
          },
          stick: {
            store: { key: "ef-shd_fade-out" },
            factor: 0.001,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-shd_fade-out-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-shd_use-merge-cfg",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Shader config",
            enable: { key: "ef-shd_use-merge-cfg" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "ef-shd_use-merge-cfg" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "ef-shd_merge-cfg",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "ef-shd_merge-cfg" },
            enable: { key: "ef-shd_use-merge-cfg" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      }
    ]),
  }
}