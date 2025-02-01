///@package io.alkapivo.visu.editor.service.brush._old.shader

///@param {Struct} json
///@return {Struct}
function migrateShaderSpawnEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "ef-shd_template": Struct.getIfType(json, "shader-spawn_template", String, "shader-default"),
    "ef-shd_duration": Struct.getIfType(json, "shader-spawn_duration", Number, 5.0),
    "ef-shd_fade-in": Struct.getIfType(json, "shader-spawn_fade-in", Number, 1.0),
    "ef-shd_fade-out": Struct.getIfType(json, "shader-spawn_fade-out", Number, 1.0),
    "ef-shd_alpha": Struct.getIfType(json, "shader-spawn_alpha-max", Number, 1.0),
    "ef-shd_pipeline": migrateShaderPipelineType(Struct.getDefault(json, "shader-spawn_pipeline", ShaderPipelineType.COMBINED)),
    "ef-shd_use-merge-cfg": Struct.getIfType(json, "shader-spawn_use-merge-properties", Boolean, false),
    "ef-shd_merge-cfg": Struct.getIfType(json, "shader-spawn_merge-properties", Struct, {}),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_shader_spawn(json = null) {
  return {
    name: "brush_shader_spawn",
    store: new Map(String, Struct, {
      "shader-spawn_pipeline": {
        type: String,
        value: migrateShaderPipelineType(Struct.get(json, "shader-spawn_pipeline")),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: ShaderPipelineType.keys(),
      },
      "shader-spawn_template": {
        type: String,
        value: Struct.getDefault(json, "shader-spawn_template", "shader-default"),
        passthrough: function(value) {
          var shaderPipeline = Beans.get(BeanVisuController).shaderPipeline
          return shaderPipeline.templates.contains(value) || Visu.assets().shaderTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "shader-default")
        },
      },
      "shader-spawn_duration": {
        type: Number,
        value: Struct.getDefault(json, "shader-spawn_duration", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3600.0) 
        },
      },
      "shader-spawn_fade-in": {
        type: Number,
        value: Struct.getDefault(json, "shader-spawn_fade-in", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.0) 
        },
      },
      "shader-spawn_fade-out": {
        type: Number,
        value: Struct.getDefault(json, "shader-spawn_fade-out", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.0) 
        },
      },
      "shader-spawn_alpha-max": {
        type: Number,
        value: Struct.getDefault(json, "shader-spawn_alpha-max", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0) 
        },
      },
      "shader-spawn_use-merge-properties": {
        type: Boolean,
        value: Struct.getDefault(json, "shader-spawn_use-merge-properties", false),
      },
      "shader-spawn_merge-properties": {
        type: String,
        value: JSON.stringify(Struct.getIfType(json, "shader-spawn_merge-properties", Struct, {}), { pretty: true }),
        serialize: function() {
          return JSON.parse(this.get())
        },
        validate: function(value) {
          Assert.isType(JSON.parse(value), Struct)
        },
      },
    }),
    components: new Array(Struct, [
      {
        name: "shader-spawn_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "shader-spawn_template" } },
        },
      },
      {
        name: "shader-spawn_duration",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Duration" },
          field: { store: { key: "shader-spawn_duration" } },
        },
      },
      {
        name: "shader-spawn_fade-in",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade in" },
          field: { store: { key: "shader-spawn_fade-in" } },
        },
      },
      {
        name: "shader-spawn_fade-out",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Fade out" },
          field: { store: { key: "shader-spawn_fade-out" } },
        },
      },
      {
        name: "shader-spawn_alpha-max",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Alpha",
          },
          field: { 
            store: { key: "shader-spawn_alpha-max" },
          },
          slider:{
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "shader-spawn_alpha-max" },
          },
        },
      },
      {
        name: "shader-spawn_pipeline",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Pipeline" },
          previous: { store: { key: "shader-spawn_pipeline" } },
          preview: Struct.appendRecursive({ 
            store: { key: "shader-spawn_pipeline" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "shader-spawn_pipeline" } },
        },
      },
      {
        name: "shader-spawn_use-merge-properties",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Merge properties",
            enable: { key: "shader-spawn_use-merge-properties" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shader-spawn_use-merge-properties" },
          },
        },
      },
      {
        name: "shader-spawn_merge-properties",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "shader-spawn_merge-properties" },
            enable: { key: "shader-spawn_use-merge-properties" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
    ]),
  }
}