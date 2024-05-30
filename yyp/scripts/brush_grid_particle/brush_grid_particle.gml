///@package io.alkapivo.visu.editor.service.brush.grid

///@param {?Struct} [json]
///@return {Struct}
function brush_grid_particle(json = null) {

  return {
    name: "brush_grid_particle",
    store: new Map(String, Struct, {
      "grid-particle_use-preview": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-particle_use-preview", true),
      },
      "grid-particle_template": {
        type: String,
        value: Struct.getDefault(json, "grid-particle_template", "particle_default"),
      },
      "grid-particle_beginX": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_beginX", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -1.5, 2.5) 
          //return NumberUtil.parse(value, this.value)
        },
      },
      "grid-particle_beginY": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_beginY", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -2.5, 1.5)
          //return NumberUtil.parse(value, this.value)
        },
      },
      "grid-particle_endX": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_endX", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -1.5, 2.5) 
          //return NumberUtil.parse(value, this.value)
        },
      },
      "grid-particle_endY": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_endY", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -2.5, 1.5) 
          //return NumberUtil.parse(value, this.value)
        },
      },
      "grid-particle_amount": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_amount", 10),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 1, 999.0) 
        },
      },
      "grid-particle_interval": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_interval", FRAME_MS),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), FRAME_MS, 999.0) 
        },
      },
      "grid-particle_duration": {
        type: Number,
        value: Struct.getDefault(json, "grid-particle_duration", 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.0) 
        },
      },
      "grid-particle_shape": {
        type: String,
        value: Struct.getDefault(json, "grid-particle_shape", ParticleEmitterShape.keys().get(0)),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: ParticleEmitterShape.keys(),
      },
      "grid-particle_distribution": {
        type: String,
        value: Struct.getDefault(json, "grid-particle_distribution", ParticleEmitterDistribution.keys().get(0)),
        validate: function(value) {
          Assert.areEqual(true, this.data.contains(value))
        },
        data: ParticleEmitterDistribution.keys(),
      },
    }),
    components: new Array(Struct, [
      {
        name: "grid-particle_use-preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Emitter preview",
            enable: { key: "grid-particle_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
            updateCustom: function() {
              this.preRender()
              if (Core.isType(this.context.updateTimer, Timer)) {
                var inspectorType = this.context.state.get("inspectorType")
                switch (inspectorType) {
                  case VEEventInspector:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.particleAreaEvent != null) {
                      shroomService.particleAreaEvent.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                  case VEBrushToolbar:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.particleArea != null) {
                      shroomService.particleArea.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                }
              }
            },
            preRender: function() {
              var store = null
              if (Core.isType(this.context.state.get("brush"), VEBrush)) {
                store = this.context.state.get("brush").store
              }
              
              if (Core.isType(this.context.state.get("event"), VEEvent)) {
                store = this.context.state.get("event").store
              }

              if (!Optional.is(store) || !store.getValue("grid-particle_use-preview")) {
                return
              }

              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.particleAreaEvent = {
                    topLeft: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_beginX"), 
                      y: store.getValue("grid-particle_beginY"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    topRight: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_endX"), 
                      y: store.getValue("grid-particle_beginY"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_beginX"), 
                      y: store.getValue("grid-particle_endY"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomRight: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_endX"), 
                      y: store.getValue("grid-particle_endY"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    timeout: 5.0,
                  }
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.particleArea = {
                    topLeft: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_beginX"), 
                      y: store.getValue("grid-particle_beginY"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    topRight: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_endX"), 
                      y: store.getValue("grid-particle_beginY"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_beginX"), 
                      y: store.getValue("grid-particle_endY"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomRight: shroomService.factorySpawner({ 
                      x: store.getValue("grid-particle_endX"), 
                      y: store.getValue("grid-particle_endY"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    timeout: 5.0,
                  }
                  break
              }
            },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-particle_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      {
        name: "grid-particle_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Particle" },
          field: { store: { key: "grid-particle_template" } },
        },
      },
      {
        name: "grid-particle_beginX",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Begin X" },
          field: { store: { key: "grid-particle_beginX" } },
          slider: { 
            store: { key: "grid-particle_beginX" },
            minValue: -1.5,
            maxValue: 2.5,
          },
        },
      },
      {
        name: "grid-particle_beginY",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Begin Y" },
          field: { store: { key: "grid-particle_beginY" } },
          slider: { 
            store: { key: "grid-particle_beginY" },
            minValue: -2.5,
            maxValue: 1.5,
          },
        },
      },
      {
        name: "grid-particle_endX",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "End X" },
          field: { store: { key: "grid-particle_endX" } },
          slider: { 
            store: { key: "grid-particle_endX" },
            minValue: -1.5,
            maxValue: 2.5,
          },
        },
      },
      {
        name: "grid-particle_endY",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "End Y" },
          field: { store: { key: "grid-particle_endY" } },
          slider: { 
            store: { key: "grid-particle_endY" },
            minValue: -2.5,
            maxValue: 1.5,
          },
        },
      },
      {
        name: "grid-particle_amount",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Amount" },
          field: { store: { key: "grid-particle_amount" } },
        },
      },
      {
        name: "grid-particle_interval",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Interval" },
          field: { store: { key: "grid-particle_interval" } },
        },
      },
      {
        name: "grid-particle_duration",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Duration" },
          field: { store: { key: "grid-particle_duration" } },
        },
      },
      {
        name: "grid-particle_shape",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Shape" },
          previous: { store: { key: "grid-particle_shape" } },
          preview: Struct.appendRecursive({ 
            store: { key: "grid-particle_shape" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "grid-particle_shape" } },
        },
      },
      {
        name: "grid-particle_distribution",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Dist." },
          previous: { store: { key: "grid-particle_distribution" } },
          preview: Struct.appendRecursive({ 
            store: { key: "grid-particle_distribution" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "grid-particle_distribution" } },
        },
      },
    ]),
  }
}