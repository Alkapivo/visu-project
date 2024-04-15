///@package io.alkapivo.core.renderer.shader

///@enum
function _ShaderPipelineTaskTransformerType(): Enum() constructor {
  COLOR = ColorTransformer
  FLOAT = NumberTransformer
  VECTOR2 = Vector2Transformer
  VECTOR3 = Vector3Transformer
  VECTOR4 = Vector4Transformer
  RESOLUTION = ResolutionTransformer
}
global.__ShaderPipelineTaskTransformerType = new _ShaderPipelineTaskTransformerType()
#macro ShaderPipelineTaskTransformerType global.__ShaderPipelineTaskTransformerType


///@param {String} _name
///@param {Struct} json
function ShaderPipelineTaskTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Shader}
  shader = Assert.isType(ShaderUtil.fetch(Struct.get(json, "shader")), Shader)

  ///@type {Map<String, Struct>}
  properties = new Map(String, Transformer)

  var jsonProperties = Struct.get(json, "properties")
  if (Core.isType(jsonProperties, Struct)) {
    this.properties = Struct.toMap(jsonProperties, String, Transformer).map(function (struct, name, shader) {
      var uniform = this.shader.uniforms.get(name)
      Assert.isType(uniform, ShaderUniform, "uniform")
      var prototype = ShaderPipelineTaskTransformerType.get(uniform.type)
      Assert.isEnum(prototype, ShaderPipelineTaskTransformerType)
      var transformer = new prototype(struct)
      Assert.isType(transformer, prototype, "transformer")
      return transformer
    }, this.shader)
  }
  Assert.isType(this.properties, Map, "properties")
}


///@param {ShaderUniform} _uniform
///@param {Transformer} _transformer
function ShaderPipelineTaskProperty(_uniform, _transformer) constructor {

  ///@type {ShaderUniform}
  uniform = Assert.isType(_uniform, ShaderUniform)

  ///@type {Transformer}
  transformer = Assert.isType(_transformer, Transformer)
}


///@param {Controller} controller
///@param {Struct} [config]
function ShaderPipeline(config = {}): Service() constructor {

  static factoryShaderPipelineTaskTemplate = function(_name, json) {
    static addToMergeQueue = function(callback, mergeQueue, name, json) {
      mergeQueue.add(name)
      
      if (!Core.isType(Struct.get(json, "inherit"), String)) {
        return mergeQueue
      }

      var inherit = Struct.get(json, "inherit")
      var cyclic = mergeQueue.filter(function (template, index, current) {
        return template == current
      }, inherit)

      if (cyclic.size() > 0) {
        return mergeQueue
      }

      if (!this.templates.contains(inherit)) {
        return mergeQueue
      }

      var parentJson = this.templates.get(inherit)
      return callback(callback, mergeQueue, inherit, parentJson)
    }

    if (Core.isType(Struct.get(json, "inherit"), String)) {
      var acc = {
        mergeQueue: addToMergeQueue(addToMergeQueue, new Array(), _name, json),
        shader: null,
        properties: {},
        templates: this.templates,
      }

      IntStream.forEach(acc.mergeQueue.size() - 1, 0, function (index, no, acc) {
        var template = acc.templates.get(acc.mergeQueue.get(index))
        if (!Core.isType(template, Struct)) {
          return
        }
        
        if (Core.isType(Struct.get(template, "shader"), String)) {
          acc.shader = Struct.get(template, "shader")
        }

        if (Core.isType(template.properties, Struct)) {
          Struct.forEach(template.properties, function (property, key, acc) {
            Struct.set(acc.properties, key, property)
          }, acc)
        }
      }, acc)
      Struct.set(json, "shader", acc.shader)
      Struct.set(json, "properties", acc.properties)
    }
    
    return new ShaderPipelineTaskTemplate(_name, json)
  }

  ///@type {Map<String, ShaderTemplate>}
  templates = Struct.contains(config, "templates")
     ? Assert.isType(config.templates, Map)
     : new Map(String, ShaderTemplate)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-shader": function (event) {
      static mapProperties = function (property, name, uniforms) {
        return new ShaderPipelineTaskProperty(uniforms.get(name), property)
      }

      var templateName = Assert.isType(Struct.get(event.data, "template"), String)
      var json = Assert.isType(this.templates.get(templateName), ShaderTemplate)
      var duration = Assert.isType(Struct.get(event.data, "duration"), Number)
      var template = Assert.isType(this.factoryShaderPipelineTaskTemplate(
        templateName, json), ShaderPipelineTaskTemplate)
      var fadeIn = Assert.isType(Struct.getDefault(event.data, "fadeIn", 1.0), Number)
      var fadeOut = Assert.isType(Struct.getDefault(event.data, "fadeOut", 1.0), Number)
      var alphaMax = Assert.isType(Struct.getDefault(event.data, "alphaMax", 1.0), Number)
      var properties = template.properties.map(mapProperties, template.shader.uniforms,
        String, ShaderPipelineTaskProperty)
      var task = new Task("shader-effect")
        .setTimeout(duration)
        .whenTimeout(function() {
          this.fullfill()
        })
        .setState(new Map(String, any, {
          name: template.name,
          shader: template.shader,
          alpha: 0.0,
          alphaMax: alphaMax,
          fadeIn: fadeIn,
          fadeOut: fadeOut,
          properties: properties
        }))
        .whenUpdate(function() {
          static updateAlpha = function(task) {
            var fadeIn = task.state.get("fadeIn")
            var fadeOut = task.state.get("fadeOut")
            var alpha = task.state.get("alpha")
            var alphaMax = task.state.get("alphaMax")
            var timer = task.timeout
            if (timer.time < fadeIn) {
              alpha = clamp(timer.time / fadeIn, 0.0, 1.0)
            } else if (timer.time > timer.duration - fadeOut) {
              alpha = clamp((timer.duration - timer.time) / fadeOut, 0.0, 1.0)
            } else {
              alpha = 1.0
            }
            task.state.set("alpha", min(alpha, alphaMax))
          }

          static updateProperty = function(property) {
            property.transformer.update()
          }

          updateAlpha(this)
          this.state.get("properties").forEach(updateProperty)
        })
        
      this.executor.add(task)
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@type {EventPump}
  executor = new TaskExecutor(this)

  ///@return {ShaderPipeline}
  update = function() {
    this.dispatcher.update()
    this.executor.update()
    return this
  }

  ///@param {Callable} handler
  ///@param {any} data
  ///@return {ShaderPipeline}
  render = function(handler, data) {
    static setShaderProperty = function (property) {
      var value = property.transformer.get()
      property.uniform.set(value)
    }

    var size = this.executor.tasks.size()
    for (var index = 0; index < size; index++) {
      var task = this.executor.tasks.get(index)
      if (task.name != "shader-effect") {
        continue
      }

      var shader = task.state.get("shader")
      var properties = task.state.get("properties")
      GPU.set.shader(shader)
      properties.forEach(setShaderProperty)
      handler(task, index, data)
      GPU.reset.shader()
    }
    return this
  }
}
