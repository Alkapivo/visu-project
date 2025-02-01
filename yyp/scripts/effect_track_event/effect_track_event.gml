///@package io.alkapivo.visu.service.track

///@enum
function _ShaderPipelineType(): Enum() constructor {
  BACKGROUND = "BACKGROUND"
  GRID = "GRID"
  COMBINED = "COMBINED"
}
global.__ShaderPipelineType = new _ShaderPipelineType()
#macro ShaderPipelineType global.__ShaderPipelineType


///@param {String} type
///@return {ShaderPipelineType}
function migrateShaderPipelineType(type) {
  switch (type) {
    case ShaderPipelineType.BACKGROUND:
    case "Background": 
      return ShaderPipelineType.BACKGROUND
    case ShaderPipelineType.GRID:
    case "Grid":
      return ShaderPipelineType.GRID
    case ShaderPipelineType.COMBINED:
    case "All":
      return ShaderPipelineType.COMBINED
    default: 
      Logger.warn("migrateShaderPipelineType", $"Found unsupported type: '{type}'. Return default value: '{ShaderPipelineType.COMBINED}'")
      return ShaderPipelineType.COMBINED
  }
}


///@static
///@type {Struct}
global.__effect_track_event = {
  "brush_effect_shader": {
    parse: function(data) {
      var template = Struct.parse.text(data, "ef-shd_template", "shader-default")
      if (Core.getRuntimeType() == RuntimeType.GXGAMES
          && Struct.contains(SHADERS_WASM, template)) {
        var wasmTemplate = Struct.get(SHADERS_WASM, eventData.template)
        Logger.debug("Track", $"Override shader '{template}' with '{wasmTemplate}'")
        template = wasmTemplate
      }
      
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "ef-shd_template": template,
        "ef-shd_duration": Struct.parse.number(data, "ef-shd_duration", 5.0, 0.0, 9999.9),
        "ef-shd_fade-in": Struct.parse.number(data, "ef-shd_fade-in", 1.0, 0.0, 9999.9),
        "ef-shd_fade-out": Struct.parse.number(data, "ef-shd_fade-out", 1.0, 0.0, 9999.9),
        "ef-shd_alpha": Struct.parse.normalizedNumber(data, "ef-shd_alpha", 1.0),
        "ef-shd_pipeline": Struct.parse.enumerable(data, "ef-shd_pipeline", ShaderPipelineType, ShaderPipelineType.BACKGROUND),
        "ef-shd_use-merge-cfg": Struct.parse.boolean(data, "ef-shd_use-merge-cfg"),
        "ef-shd_merge-cfg": Struct.getIfType(data, "ef-shd_merge-cfg", Struct, { }),
      }
    },
    run: function(data) {
      static getPipeline = function(data, key) {
        var controller = Beans.get(BeanVisuController)
        var pipeline = Struct.get(data, key)
        switch (pipeline) {
          case ShaderPipelineType.BACKGROUND: return controller.shaderBackgroundPipeline
          case ShaderPipelineType.GRID: return controller.shaderPipeline
          case ShaderPipelineType.COMBINED: return controller.shaderCombinedPipeline
          default: 
            Logger.warn("Track", $"Found unsupported pipeline: {pipeline}. Return default: 'shaderBackgroundPipeline'")
            return controller.shaderBackgroundPipeline
        }
      }

      ///@description feature effect.shader.spawn
      getPipeline(data, "ef-shd_pipeline").send(new Event("spawn-shader", {
        template: Struct.get(data, "ef-shd_template"),
        duration: Struct.get(data, "ef-shd_duration"),
        fadeIn: Struct.get(data, "ef-shd_fade-in"),
        fadeOut: Struct.get(data, "ef-shd_fade-out"),
        alphaMax: Struct.get(data, "ef-shd_alpha"),
        mergeProperties: Struct.get(data, "ef-shd_use-merge-cfg") 
          ? Struct.get(data, "ef-shd_merge-cfg") 
          : null,
      }))
    },
  },
  "brush_effect_glitch": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "ef-glt_use-fade-out": Struct.parse.boolean(data, "ef-glt_use-fade-out"),
        "ef-glt_fade-out": Struct.parse.number(data, "ef-glt_fade-out", 0.01, 0.0, 1.0),
        "ef-glt_use-config": Struct.parse.boolean(data, "ef-glt_use-config"),
        "ef-glt_line-spd": Struct.parse.number(data, "ef-glt_line-spd", 0.01, 0.0, 0.5),
        "ef-glt_line-shift": Struct.parse.number(data, "ef-glt_line-shift", 0.004, 0.0, 0.05),
        "ef-glt_line-res": Struct.parse.number(data, "ef-glt_line-res", 1.0, 0.0, 3.0),
        "ef-glt_line-v-shift": Struct.parse.number(data, "ef-glt_line-v-shift", 0.0, 0.0, 1.0),
        "ef-glt_line-drift": Struct.parse.number(data, "ef-glt_line-drift", 0.1, 0.0, 1.0),
        "ef-glt_jumb-spd": Struct.parse.number(data, "ef-glt_jumb-spd", 1.0, 0.0, 25.0),
        "ef-glt_jumb-shift": Struct.parse.number(data, "ef-glt_jumb-shift", 0.15, 0.0, 1.0),
        "ef-glt_jumb-res": Struct.parse.number(data, "ef-glt_jumb-res", 0.2, 0.0, 1.0),
        "ef-glt_jumb-chaos": Struct.parse.number(data, "ef-glt_jumb-chaos", 0.2, 0.0, 1.0),
        "ef-glt_shd-dispersion": Struct.parse.number(data, "ef-glt_shd-dispersion", 0.0025, 0.0, 0.5),
        "ef-glt_shd-ch-shift": Struct.parse.number(data, "ef-glt_shd-ch-shift", 0.004, 0.0, 0.05),
        "ef-glt_shd-noise": Struct.parse.number(data, "ef-glt_shd-noise", 0.5, 0.0, 1.0),
        "ef-glt_shd-shakiness": Struct.parse.number(data, "ef-glt_shd-shakiness", 0.5, 0.0, 10.0),
        "ef-glt_shd-rng-seed": Struct.parse.number(data, "ef-glt_shd-rng-seed", 0.0, 0.0, 1.0),
        "ef-glt_shd-intensity": Struct.parse.number(data, "ef-glt_shd-intensity", 1.0, 0.0, 5.0),
      }
    },
    run: function(data) {
      var pump = Beans.get(BeanVisuController).visuRenderer.gridRenderer.glitchService.dispatcher

      ///@description feature TODO effect.glitch.config
      if (Struct.get(data, "ef-glt_use-config")) {
        pump.execute(new Event("load-config", {
          lineSpeed: {
            defValue: Struct.get(data, "ef-glt_line-spd"),
            minValue: 0.0,
            maxValue: 0.5,
          },
          lineShift: {
            defValue: Struct.get(data, "ef-glt_line-shift"),
            minValue: 0.0,
            maxValue: 0.05,
          },
          lineResolution: {
            defValue: Struct.get(data, "ef-glt_line-res"),
            minValue: 0.0,
            maxValue: 3.0,
          },
          lineVertShift: {
            defValue: Struct.get(data, "ef-glt_line-v-shift"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          lineDrift: {
            defValue: Struct.get(data, "ef-glt_line-drift"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          jumbleSpeed: {
            defValue: Struct.get(data, "ef-glt_jumb-spd"),
            minValue: 0.0,
            maxValue: 25.0,
          },
          jumbleShift: {
            defValue: Struct.get(data, "ef-glt_jumb-shift"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          jumbleResolution: {
            defValue: Struct.get(data, "ef-glt_jumb-res"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          jumbleness: {
            defValue: Struct.get(data, "ef-glt_jumb-chaos"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          dispersion: {
            defValue: Struct.get(data, "ef-glt_shd-dispersion"),
            minValue: 0.0,
            maxValue: 0.5,
          },
          channelShift: {
            defValue: Struct.get(data, "ef-glt_shd-ch-shift"),
            minValue: 0.0,
            maxValue: 0.05,
          },
          noiseLevel: {
            defValue: Struct.get(data, "ef-glt_shd-noise"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          shakiness: {
            defValue: Struct.get(data, "ef-glt_shd-shakiness"),
            minValue: 0.0,
            maxValue: 10.0,
          },
          rngSeed: {
            defValue: Struct.get(data, "ef-glt_shd-rng-seed"),
            minValue: 0.0,
            maxValue: 1.0,
          },
          intensity: {
            defValue: Struct.get(data, "ef-glt_shd-intensity"),
            minValue: 0.0,
            maxValue: 5.0,
          },
        }))
      }

      ///@description feature TODO effect.glitch.spawn
      pump.execute(new Event("spawn", { 
        factor: (Struct.get(data, "ef-glt_use-fade-out")  ///@todo NumberTransformer
          ? (Struct.get(data, "ef-glt_fade-out") / 100.0) 
          : 0.0),
        rng: !Struct.get(data, "ef-glt_use-config"),
      }))
    },
  },
  "brush_effect_particle": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "ef-part_preview": Struct.parse.boolean(data, "ef-part_preview"),
        "ef-part_template": Struct.parse.text(data, "ef-part_template", "particle-default"),
        "ef-part_area": Struct.parse.rectangle(data, "ef-part_area", { width: 1.0, height: 1.0 }),
        "ef-part_amount": Struct.parse.integer(data, "ef-part_amount", 1, 1, 999),
        "ef-part_duration": Struct.parse.number(data, "ef-part_duration", 0.0, 0, 999.9),
        "ef-part_interval": Struct.parse.number(data, "ef-part_interval", 0.0, 0, 999.9),
        "ef-part_shape": Struct.parse.enumerableKey(data, "ef-part_shape", 
          ParticleEmitterShape, ParticleEmitterShape.RECTANGLE),
        "ef-part_distribution": Struct.parse.enumerableKey(data, "ef-part_distribution",
          ParticleEmitterDistribution, ParticleEmitterDistribution.LINEAR),
      }
    },
    run: function(data) {
      var particleService = Beans.get(BeanVisuController).particleService
      var area = Struct.get(data, "ef-part_area")

      ///@description feature TODO effect.particle.spawn
      particleService.send(particleService
        .factoryEventSpawnParticleEmitter(
          {
            particleName: Struct.get(data, "ef-part_template"),
            ///@todo investigate why + 0.5?
            beginX: (area.getX() + 0.5) * GRID_SERVICE_PIXEL_WIDTH,
            beginY: (area.getY() + 0.5) * GRID_SERVICE_PIXEL_HEIGHT,
            endX: (area.getX() + area.getWidth() + 0.5) * GRID_SERVICE_PIXEL_WIDTH,
            endY: (area.getY() + area.getHeight() + 0.5) * GRID_SERVICE_PIXEL_HEIGHT,
            amount: Struct.get(data, "ef-part_amount"),
            interval: Struct.get(data, "ef-part_interval"),
            duration: Struct.get(data, "ef-part_duration"),
            shape: ParticleEmitterShape.get(Struct.get(data, "ef-part_shape")),
            distribution: ParticleEmitterDistribution.get(Struct.get(data, "ef-part_distribution")),
          }, 
        ))
    },
  },
  "brush_effect_config": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "ef-cfg_use-render-shd-bkg": Struct.parse.boolean(data, "ef-cfg_use-render-shd-bkg"),
        "ef-cfg_render-shd-bkg": Struct.parse.boolean(data, "ef-cfg_render-shd-bkg"),
        "ef-cfg_cls-shd-bkg": Struct.parse.boolean(data, "ef-cfg_cls-shd-bkg"),
        "ef-cfg_use-render-shd-gr": Struct.parse.boolean(data, "ef-cfg_use-render-shd-gr"),
        "ef-cfg_render-shd-gr": Struct.parse.boolean(data, "ef-cfg_render-shd-gr"),
        "ef-cfg_cls-shd-gr": Struct.parse.boolean(data, "ef-cfg_cls-shd-gr"),
        "ef-cfg_use-render-shd-all": Struct.parse.boolean(data, "ef-cfg_use-render-shd-all"),
        "ef-cfg_render-shd-all": Struct.parse.boolean(data, "ef-cfg_render-shd-all"),
        "ef-cfg_cls-shd-all": Struct.parse.boolean(data, "ef-cfg_cls-shd-all"),
        "ef-cfg_use-render-glt": Struct.parse.boolean(data, "ef-cfg_use-render-glt"),
        "ef-cfg_render-glt": Struct.parse.boolean(data, "ef-cfg_render-glt"),
        "ef-cfg_cls-glt": Struct.parse.boolean(data, "ef-cfg_cls-glt"),
        "ef-cfg_use-render-part": Struct.parse.boolean(data, "ef-cfg_use-render-part"),
        "ef-cfg_render-part": Struct.parse.boolean(data, "ef-cfg_render-part"),
        "ef-cfg_cls-part": Struct.parse.boolean(data, "ef-cfg_cls-part"),
        "ef-cfg_use-cls-frame": Struct.parse.boolean(data, "ef-cfg_use-cls-frame"),
        "ef-cfg_cls-frame": Struct.parse.boolean(data, "ef-cfg_cls-frame"),
        "ef-cfg_use-cls-frame-col": Struct.parse.boolean(data, "ef-cfg_use-cls-frame-col"),
        "ef-cfg_cls-frame-col": Struct.parse.color(data, "ef-cfg_cls-frame-col"),
        "ef-cfg_cls-frame-col-spd": Struct.parse.number(data, "ef-cfg_cls-frame-col-spd", 1.0, 0.0, 999.9),
        "ef-cfg_cls-frame-alpha": Struct.parse.normalizedNumberTransformer(data, "ef-cfg_cls-frame-alpha"),
        "ef-cfg_use-cls-frame-alpha": Struct.parse.boolean(data, "ef-cfg_use-cls-frame-alpha"),
        "ef-cfg_change-cls-frame-alpha": Struct.parse.boolean(data, "ef-cfg_change-cls-frame-alpha"),
      }
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor
      
      ///@description feature TODO effect.shader.bkg.render
      Visu.resolveBooleanTrackEvent(data,
        "ef-cfg_use-render-shd-bkg",
        "ef-cfg_render-shd-bkg",
        "renderBackgroundShaders",
        properties)

      ///@description feature TODO effect.shader.grid.render
      Visu.resolveBooleanTrackEvent(data,
        "ef-cfg_use-render-shd-gr",
        "ef-cfg_render-shd-gr",
        "renderGridShaders",
        properties)

      ///@description feature TODO effect.shader.all.render
      Visu.resolveBooleanTrackEvent(data,
        "ef-cfg_use-render-shd-all",
        "ef-cfg_render-shd-all",
        "renderCombinedShaders",
        properties)

      ///@description feature TODO effect.shader.all.render
      Visu.resolveBooleanTrackEvent(data,
        "ef-cfg_use-cls-frame",
        "ef-cfg_cls-frame",
        "shaderClearFrame",
        properties)

      ///@description feature TODO effect.shader.frame.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "ef-cfg_use-cls-frame-col",
        "ef-cfg_cls-frame-col",
        "ef-cfg_cls-frame-col-spd",
        "shaderClearColor",
        properties, pump, executor)

      ///@description feature TODO effect.shader.frame.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "ef-cfg_use-cls-frame-alpha",
        "ef-cfg_cls-frame-alpha",
        "ef-cfg_change-cls-frame-alpha",
        "shaderClearFrameAlpha",
        properties, pump, executor)

      ///@description feature TODO shader-pipeline.background.clear
      Visu.resolveSendEventTrackEvent(data, 
        "ef-cfg_cls-shd-bkg",
        "clear-shaders",
        null,
        controller.shaderBackgroundPipeline.dispatcher)

      ///@description feature TODO shader-pipeline.grid.clear
      Visu.resolveSendEventTrackEvent(data, 
        "ef-cfg_cls-shd-gr",
        "clear-shaders",
        null,
        controller.shaderPipeline.dispatcher)

      ///@description feature TODO shader-pipeline.all.clear
      Visu.resolveSendEventTrackEvent(data, 
        "ef-cfg_cls-shd-all",
        "clear-shaders",
        null,
        controller.shaderCombinedPipeline.dispatcher)
    },
  },
}
#macro effect_track_event global.__effect_track_event