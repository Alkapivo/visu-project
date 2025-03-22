///@package io.alkapivo.visu.editor.service.brush.effect

///@param {Struct} json
///@return {Struct}
function brush_effect_particle(json) {
  return {
    name: "brush_effect_particle",
    store: new Map(String, Struct, {
      "ef-part_preview": {
        type: Boolean,
        value: Struct.get(json, "ef-part_preview"),
      },
      "ef-part_template": {
        type: String,
        value: Struct.get(json, "ef-part_template"),
        passthrough: UIUtil.passthrough.getCallbackValue(),
        data: {
          callback: Beans.get(BeanVisuController).particleTemplateExists,
          defaultValue: "particle-default",
        },
      },
      "ef-part_area": {
        type: Rectangle,
        value: Struct.get(json, "ef-part_area"),
        passthrough: function(value) {
          value.x = clamp(value.x, -5.0, 5.0)
          value.y = clamp(value.y, -5.0, 5.0)
          value.z = clamp(value.z, 0.0, 10.0)
          value.a = clamp(value.a, 0.0, 10.0)
          return value
        }
      },
      "ef-part_amount": {
        type: Number,
        value: Struct.get(json, "ef-part_amount"),
        passthrough: UIUtil.passthrough.getClampedStringInteger(),
        data: new Vector2(1, 999),
      },
      "ef-part_duration": {
        type: Number,
        value: Struct.get(json, "ef-part_duration"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "ef-part_interval": {
        type: Number,
        value: Struct.get(json, "ef-part_interval"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "ef-part_shape": {
        type: String,
        value: Struct.get(json, "ef-part_shape"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: ParticleEmitterShape.keys(),
      },
      "ef-part_distribution": {
        type: String,
        value: Struct.get(json, "ef-part_distribution"),
        passthrough: UIUtil.passthrough.getArrayValue(),
        data: ParticleEmitterDistribution.keys(),
      },
    }),
    components: new Array(Struct, [
      {
        name: "ef-part_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "ef-part_template" } },
        },
      },
      {
        name: "ef-part_template-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-part_shape",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Shape" },
          previous: { store: { key: "ef-part_shape" } },
          preview: Struct.appendRecursive({ 
            store: { key: "ef-part_shape" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "ef-part_shape" } },
        },
      },
      {
        name: "ef-part_distribution",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Dist." },
          previous: { store: { key: "ef-part_distribution" } },
          preview: Struct.appendRecursive({ 
            store: { key: "ef-part_distribution" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "ef-part_distribution" } },
        },
      },
      {
        name: "ef-part_distribution-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-part_amount",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Amount" },
          field: {
            store: { key: "ef-part_amount" },
            GMTF_DECIMAL: 0,
          },
          decrease: { store: { key: "ef-part_amount" } },
          increase: { store: { key: "ef-part_amount" } },
          stick: {
            store: { key: "ef-part_amount" },
            factor: 1,
            step: 10,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-part_duration",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Duration" },
          field: { store: { key: "ef-part_duration" } },
          decrease: {
            store: { key: "ef-part_duration" },
            factor: -0.01,
          },
          increase: {
            store: { key: "ef-part_duration" },
            factor: 0.01,
          },
          stick: {
            store: { key: "ef-part_duration" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-part_interval",  
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Interval" },
          field: { store: { key: "ef-part_interval" } },
          decrease: {
            store: { key: "ef-part_interval" },
            factor: -0.001,
          },
          increase: {
            store: { key: "ef-part_interval" },
            factor: 0.001,
          },
          stick: {
            store: { key: "ef-part_interval" },
            factor: 0.001,
          },
          checkbox: { },
        },
      },
      {
        name: "ef-part_area-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "ef-part_preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render emitter area",
            enable: { key: "ef-part_preview" },
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

              if (!Optional.is(store) || !store.getValue("ef-part_preview")) {
                return
              }

              var area = store.getValue("ef-part_area")
              if (!Core.isType(area, Rectangle)) {
                return
              }

              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.particleAreaEvent = {
                    topLeft: shroomService.factorySpawner({
                      x: area.getX() + 0.5,
                      y: area.getY() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    topRight: shroomService.factorySpawner({
                      x: area.getX() + area.getWidth() + 0.5,
                      y: area.getY() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({
                      x: area.getX() + 0.5,
                      y: area.getY() + area.getHeight() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomRight: shroomService.factorySpawner({
                      x: area.getX() + area.getWidth() + 0.5,
                      y: area.getY() + area.getHeight() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    timeout: 5.0,
                  }
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.particleArea = {
                    topLeft: shroomService.factorySpawner({
                      x: area.getX() + 0.5,
                      y: area.getY() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    topRight: shroomService.factorySpawner({
                      x: area.getX() + area.getWidth() + 0.5,
                      y: area.getY() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({
                      x: area.getX() + 0.5,
                      y: area.getY() + area.getHeight() + 0.5,
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomRight: shroomService.factorySpawner({
                      x: area.getX() + area.getWidth() + 0.5,
                      y: area.getY() + area.getHeight() + 0.5,
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
            store: { key: "ef-part_preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      {
        name: "ef-part_area",
        template: VEComponents.get("vec4-slider-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          x: {
            label: { text: "X" },
            field: { store: { key: "ef-part_area" } },
            slider: {
              snapValue: 0.01 / 10.0,
              minValue: -5.0,
              maxValue: 5.0,
              store: { key: "ef-part_area" }
            },
            decrease: {
              store: { key: "ef-part_area" },
              factor: -0.01,
            },
            increase: {
              store: { key: "ef-part_area" },
              factor: 0.01,
            },
          },
          y: {
            label: { text: "Y" },
            field: { store: { key: "ef-part_area" } },
            slider: {
              snapValue: 0.01 / 10.0,
              minValue: -5.0,
              maxValue: 5.0,
              store: { key: "ef-part_area" }
            },
            decrease: {
              store: { key: "ef-part_area" },
              factor: -0.01,
            },
            increase: {
              store: { key: "ef-part_area" },
              factor: 0.01,
            },
          },
          z: {
            label: { text: "Width" },
            field: { store: { key: "ef-part_area" } },
            slider: {
              snapValue: 0.01 / 10.0,
              minValue: 0.0,
              maxValue: 10.0,
              store: { key: "ef-part_area" }
            },
            decrease: {
              store: { key: "ef-part_area" },
              factor: -0.01,
            },
            increase: {
              store: { key: "ef-part_area" },
              factor: 0.01,
            },
          },
          a: {
            label: { text: "Height" },
            field: { store: { key: "ef-part_area" } },
            slider: {
              snapValue: 0.01 / 10.0,
              minValue: 0.0,
              maxValue: 10.0,
              store: { key: "ef-part_area" },
            },
            decrease: {
              store: { key: "ef-part_area" },
              factor: -0.01,
            },
            increase: {
              store: { key: "ef-part_area" },
              factor: 0.01,
            },
          },
        },
      },
    ]),
  }
}