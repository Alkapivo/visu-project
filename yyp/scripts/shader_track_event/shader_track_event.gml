///@package io.alkapivo.visu.service.track._old

///@static
///@type {Struct}
global.__shader_track_event = {
  "brush_shader_spawn": {
    parse: function(data) {
      return Struct.appendUnique({ 
        "icon": Struct.parse.sprite(data, "icon"),
        "shader-spawn_pipeline": migrateShaderPipelineType(Struct.get(data, "shader-spawn_pipeline")),
      }, data, false)
    },
    run: function(data) {
      var eventData = {
        template: Struct.get(data, "shader-spawn_template"),
        duration: Struct.get(data, "shader-spawn_duration"),
      }

      if (Core.isType(Struct.get(data, "shader-spawn_fade-in"), Number)) {
        Struct.set(eventData, "fadeIn", Struct
          .get(data, "shader-spawn_fade-in"))
      }

      if (Core.isType(Struct.get(data, "shader-spawn_fade-out"), Number)) {
        Struct.set(eventData, "fadeOut", Struct
          .get(data, "shader-spawn_fade-out"))
      }

      if (Core.isType(Struct.get(data, "shader-spawn_alpha-max"), Number)) {
        Struct.set(eventData, "alphaMax", Struct
          .get(data, "shader-spawn_alpha-max"))
      }

      if (Struct.get(data, "shader-spawn_use-merge-properties") == true) {
        Struct.set(eventData, "mergeProperties", Struct
          .get(data, "shader-spawn_merge-properties"))
      }

      if (Core.getRuntimeType() == RuntimeType.GXGAMES &&
          Struct.contains(SHADERS_WASM, eventData.template)) {
        var wasmTemplate = Struct.get(SHADERS_WASM, eventData.template)
        Logger.debug("TrackService", $"Override shader '{eventData.template}' with '{wasmTemplate}'")
        eventData.template = wasmTemplate
      }

      var event = new Event("spawn-shader", JSON.clone(eventData))
      var controller = Beans.get(BeanVisuController)
      var pipeline = Struct.getDefault(data, "shader-spawn_pipeline", ShaderPipelineType.BACKGROUND)
      switch (pipeline) {
        case ShaderPipelineType.GRID:
          controller.shaderPipeline.send(event)
          break
        case ShaderPipelineType.BACKGROUND:
          controller.shaderBackgroundPipeline.send(event)
          break
        case ShaderPipelineType.COMBINED:
          controller.shaderCombinedPipeline.send(event)
          break
        default: throw new Exception($"Found unsupported pipeline: {pipeline}")
      }
    },
  },
  "brush_shader_overlay": {
    parse: function(data) {
      return Struct.appendUnique({ "icon": Struct.parse.sprite(data, "icon") }, data, false)
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      if (Struct.get(data, "shader-overlay_use-render-support-grid")) {
        controller.gridService.properties.renderSupportGrid = Struct.get(data, "shader-overlay_render-support-grid")
      }

      if (Struct.get(data, "shader-overlay_use-transform-support-grid-treshold") == true) {
        var transformer = Struct.get(data, "shader-overlay_transform-support-grid-treshold")
        controller.gridService.send(new Event("transform-property", {
          key: "supportGridTreshold",
          container: controller.gridService.properties,
          executor: controller.gridService.executor,
          transformer: new NumberTransformer({
            value: controller.gridService.properties.supportGridTreshold,
            target: transformer.target,
            factor: transformer.factor,
            increase: transformer.increase,
          })
        }))
      }

      if (Struct.get(data, "shader-overlay_use-transform-support-grid-alpha") == true) {
        var transformer = Struct.get(data, "shader-overlay_transform-support-grid-alpha")
        controller.gridService.send(new Event("transform-property", {
          key: "supportGridAlpha",
          container: controller.gridService.properties,
          executor: controller.gridService.executor,
          transformer: new NumberTransformer({
            value: controller.gridService.properties.supportGridAlpha,
            target: transformer.target,
            factor: transformer.factor,
            increase: transformer.increase,
          })
        }))
      }
    },
  },
  "brush_shader_clear": {
    parse: function(data) {
      return Struct.appendUnique({ 
        "icon": Struct.parse.sprite(data, "icon"),
        "shader-spawn_pipeline": migrateShaderPipelineType(Struct.get(data, "shader-spawn_pipeline")),
      }, data, false)
    },
    run: function(data) {
      static fadeOutTask = function(task, iterator, _fadeOut) {
        var fadeOut = Core.isType(_fadeOut, Number) 
          ? _fadeOut
          : task.state.getDefault("fadeOut", 0.0)
        task.state.set("fadeOut", fadeOut)
        if (task.timeout.time < task.timeout.duration - fadeOut) {
          task.timeout.time = clamp(task.timeout.duration - fadeOut, 0.0, task.timeout.duration)
        }
      }

      static amountTask = function(task, iterator, acc) {
        if (acc.amount <= 0) {
          return BREAK_LOOP
        }

        var fadeOut = Core.isType(acc.fadeOut, Number) 
          ? acc.fadeOut
          : task.state.getDefault("fadeOut", 0.0)
        task.state.set("fadeOut", fadeOut)
        if (task.timeout.time < task.timeout.duration - fadeOut) {
          acc.handler(task, iterator, fadeOut)
          acc.amount = acc.amount - 1
        }
      }

      fadeOut = null
      if (Struct.get(data, "shader-clear_use-fade-out")) {
        fadeOut = Struct.get(data, "shader-clear_fade-out")
      }

      var controller = Beans.get(BeanVisuController)
      var pipeline = Struct.getDefault(data, "shader-spawn_pipeline", ShaderPipelineType.BACKGROUND)    
      if (Struct.get(data, "shader-clear_use-clear-all-shaders") == true) {
        switch (pipeline) {
          case ShaderPipelineType.GRID:
            controller.shaderPipeline.executor.tasks.forEach(fadeOutTask, fadeOut)
            break
          case ShaderPipelineType.BACKGROUND:
            controller.shaderBackgroundPipeline.executor.tasks.forEach(fadeOutTask, fadeOut)
            break
          case ShaderPipelineType.COMBINED:
            controller.shaderCombinedPipeline.executor.tasks.forEach(fadeOutTask, fadeOut)
            break
        }
      }

      if (Struct.get(data, "shader-clear_use-clear-amount") == true) {
        var amount = Struct.getDefault(data, "shader-clear_clear-amount", 1)
        switch (pipeline) {
          case ShaderPipelineType.GRID:
            controller.shaderPipeline.executor.tasks.forEach(amountTask, {
              amount: amount,
              handler: fadeOutTask,
              fadeOut: fadeOut,
            })
            break
          case ShaderPipelineType.BACKGROUND:
            controller.shaderBackgroundPipeline.executor.tasks.forEach(amountTask, {
              amount: amount,
              handler: fadeOutTask,
              fadeOut: fadeOut,
            })
            break
          case ShaderPipelineType.COMBINED:
            controller.shaderCombinedPipeline.executor.tasks.forEach(amountTask, {
              amount: amount,
              handler: fadeOutTask,
              fadeOut: fadeOut,
            })
            break
        }
      }
    },
  },
  "brush_shader_config": {
    parse: function(data) {
      return Struct.appendUnique({ "icon": Struct.parse.sprite(data, "icon") }, data, false)
    },
    run: function(data) {
      var controller = Beans.get(BeanVisuController)
      var properties = controller.gridService.properties
      
      if (Struct.get(data, "shader-config_use-render-grid-shaders")) {
        properties.renderGridShaders = Struct.get(data, "shader-config_render-grid-shaders")
      }

      if (Struct.get(data, "shader-config_use-background-grid-shaders")) {
        properties.renderBackgroundShaders = Struct.get(data, "shader-config_background-grid-shaders")
      }

      if (Struct.get(data, "shader-config_use-clear-frame")) {
        properties.shaderClearFrame = Struct.get(data, "shader-config_clear-frame")
      }

      if (Struct.get(data, "shader-config_use-clear-color") == true) {
        controller.gridService.send(new Event("transform-property", {
          key: "shaderClearColor",
          container: controller.gridService.properties,
          executor: controller.gridService.executor,
          transformer: new ColorTransformer({
            value: controller.gridService.properties.shaderClearColor.toHex(true),
            target: Struct.get(data, "shader-config_clear-color"),
            factor: 0.01,
          })
        }))
      }
      
      if (Struct.get(data, "shader-config_use-transform-clear-frame-alpha") == true) {
        var transformer = Struct.get(data, "shader-config_transform-clear-frame-alpha")
        controller.gridService.send(new Event("transform-property", {
          key: "shaderClearFrameAlpha",
          container: controller.gridService.properties,
          executor: controller.gridService.executor,
          transformer: new NumberTransformer({
            value: controller.gridService.properties.shaderClearFrameAlpha,
            target: transformer.target,
            factor: transformer.factor,
            increase: transformer.increase,
          })
        }))
      }

      if (Struct.get(data, "shader-config_clear-shaders")) {
        controller.shaderPipeline.send(new Event("clear-shaders"))
      }

      if (Struct.get(data, "shader-config_clear-bkg-shaders")) {
        controller.shaderBackgroundPipeline.send(new Event("clear-shaders"))
      }
    },
  },
}
#macro shader_track_event global.__shader_track_event
