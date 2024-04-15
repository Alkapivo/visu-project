///@package io.alkapivo.visu.editor.service.brush.shader

///@param {?Struct} [json]
///@return {Struct}
function brush_shader_spawn(json = null) {
  return {
    name: "brush_shader_spawn",
    store: new Map(String, Struct, {
      "shader-spawn_pipeline": {
        type: String,
        value: Struct.getDefault(json, "shader-spawn_pipeline", "Grid"),
        validate: function(value) {
          Assert.isTrue(this.data.contains(value))
        },
        data: new Array(String, [ "Grid", "Background", "All" ])
      },
      "shader-spawn_template": {
        type: String,
        value: Struct.getDefault(json, "shader-spawn_template", "Wave 01"),
        passthrough: function(value) {
          return Beans.get(BeanVisuController).shaderPipeline.templates
            .contains(value) ? value : this.value
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
    }),
    components: new Array(Struct, [
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
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max alpha" },
          field: { store: { key: "shader-spawn_alpha-max" } },
        },
      },
    ]),
  }
}