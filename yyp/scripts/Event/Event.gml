///@package io.alkapivo.core.event

///@param {String} _name
///@param {any} [_data]
///@param {?Promise} [_promise]
function Event(_name, _data = null, _promise = null) constructor {

  ///@type {String}
  name = Assert.isType(_name, String, "Event.name must be type of String")

  ///@type {any}
  data = _data
  
  ///@type {?Promise}
  promise = Core.isType(_promise, Promise) ? _promise : null

  ///@param {any} data
  ///@return {Event}
  static setData = function(data) {
    this.data = data
    return this
  }

  ///@param {?Promise} promise
  ///@return {Event}
  static setPromise = function(promise = null) {
    this.promise = Assert.isType(promise, Optional.of(Promise), 
      "Event.promise must be type of ?Promise")
    return this
  }
}

///@static
///@type {Struct}
global.__EVENT_DISPATCHERS = {
  "transform-property": function() {
    return function(event) {
      static fullfillExistingTask = function(task, index, name) {
        if (task.name == name) {
          task.fullfill()
        }
      }

      static fetchWhenUpdate = function(transformer) {
        switch (Core.getConstructor(Core.getTypeName(transformer))) {
          case ColorTransformer: 
            return function() {
              var key = this.state.get("key")
              var container = this.state.get("container")
              var transformer = this.state.get("transformer")

              var color = Struct.get(container, key)
              transformer.value.red = color.red
              transformer.value.green = color.green
              transformer.value.blue = color.blue
              transformer.value.alpha = color.alpha

              transformer.update()
              
              color.red = transformer.value.red
              color.green = transformer.value.green
              color.blue = transformer.value.blue
              color.alpha = transformer.value.alpha

              if (transformer.finished) {
                this.fullfill()
              }
            }
          case NumberTransformer:
            return function() {
              var key = this.state.get("key")
              var container = this.state.get("container")
              var transformer = this.state.get("transformer")
              Struct.set(container, key, transformer
                .set(Struct.get(container, key)) 
                .update()
                .get())

              if (transformer.finished) {
                this.fullfill()
              }
            }
          case Vector2Transformer:
            return function() {
              var key = this.state.get("key")
              var container = this.state.get("container")
              var transformer = this.state.get("transformer")

              var vec2 = Struct.get(container, key)
              transformer.x.value = vec2.x
              transformer.x.update()
              vec2.x = transformer.x.value

              transformer.y.value = vec2.y
              transformer.y.update()
              vec2.y = transformer.y.value

              if (transformer.x.finished && transformer.y.finished) {
                this.fullfill()
              }
            }
          default:
            throw new Exception($"Unknown type in transform-property for name {event.data.name}, type: {type}")
        }
      }

      Assert.isTrue(Struct.contains(event.data.container, event.data.key))
      var task = new Task(event.data.key)
        .setState(new Map(String, any, {
          key: event.data.key,
          container: event.data.container,
          transformer: event.data.transformer,
        }))
        .whenUpdate(fetchWhenUpdate(event.data.transformer))

      event.data.executor.tasks
        .forEach(fullfillExistingTask, event.data.key)
      event.data.executor
        .add(task)
    }
  },
  "_transform-property": function() {
    return function(event) {
      static fullfillExistingTask = function(task, index, name) {
        if (task.name == name) {
          task.fullfill("New task arrived for name: '{name}'")
        }
      }

      var container = Assert.isType(event.data.container, Struct)
      Assert.isTrue(Struct.contains(container, event.data.key))

      var task = new Task(event.data.key)
        .setState(new Map(String, any, {
          container: container,
          source: Assert.isType(Struct.get(container, event.data.key), Number),
          target: Assert.isType(event.data.target, Number),
          factor: Assert.isType(event.data.factor, Number),
        }))
        .whenUpdate(function() {
          var container = this.state.get("container")
          var source = this.state.get("source")
          var target = this.state.get("target")
          var factor = this.state.get("factor")
          var dir = source < target ? 1 : -1
          var value = Struct.get(container, this.name) 
            + DeltaTime.apply(factor * dir)
          value = dir > 0
            ? clamp(value, source, target)
            : clamp(value, target, source)
          Struct.set(container, this.name, value)

          if (value == target) {
            task.fullfill()
          }
        })
      
      var executor = event.data.executor
      executor.tasks.forEach(fullfillExistingTask, event.data.key)
      executor.add(task)
    }
  },
  "fade-sprite": function() {
    return function(event) {
      static setFadeOut = function(task, iterator, type) {
        if (task.name == "fade-sprite" && task.state.get("type") == type) {
          task.state.set("stage", "fade-out")
        }
      }
    
      var fadeInSpeed = 1.0
      var fadeInDuration = Assert.isType(Struct.getDefault(event.data, "fadeInDuration", 0.0), Number)
      if (fadeInDuration > 0.0) {
        fadeInSpeed = FRAME_MS / fadeInDuration
      }

      var fadeOutSpeed = 1.0
      var fadeOutDuration = Assert.isType(Struct.getDefault(event.data, "fadeOutDuration", 0.0), Number)
      if (fadeOutDuration > 0.0) {
        fadeOutSpeed = FRAME_MS / fadeOutDuration
      }
      var sprite = Assert.isType(event.data.sprite, Sprite)
      var originalAlpha = sprite.getAlpha()
      var type = Assert.isType(event.data.type, String)
      sprite.setAlpha(fadeInSpeed)

      var _speed = Core.isType(Struct.get(event.data, "speed"), Number) ? event.data.speed : 0
      var speedTransformer = Struct.getIfType(event.data, "speedTransformer", NumberTransformer) 

      var angle = Core.isType(Struct.get(event.data, "angle"), Number) ? event.data.angle : 0
      var angleTransformer = Struct.getIfType(event.data, "angleTransformer", NumberTransformer)

      var xScale = Core.isType(Struct.get(event.data, "xScale"), Number) ? event.data.xScale : 1
      var xScaleTransformer = Struct.getIfType(event.data, "xScaleTransformer", NumberTransformer)

      var yScale = Core.isType(Struct.get(event.data, "yScale"), Number) ? event.data.yScale : 1
      var yScaleTransformer = Struct.getIfType(event.data, "yScaleTransformer", NumberTransformer)

      var blendModeSource = Core.isEnum(Struct.get(event.data, "blendModeSource"), BlendModeExt) 
        ? event.data.blendModeSource
        : BlendModeExt.SRC_ALPHA

      var blendModeTarget = Core.isEnum(Struct.get(event.data, "blendModeTarget"), BlendModeExt) 
        ? event.data.blendModeTarget
        : BlendModeExt.INV_SRC_ALPHA

      var blendEquation = Core.isEnum(Struct.get(event.data, "blendEquation"), BlendEquation) 
        ? event.data.blendEquation
        : BlendEquation.ADD

      var blendEquationAlpha = Core.isEnum(Struct.get(event.data, "blendEquationAlpha"), BlendEquation) 
        ? event.data.blendEquationAlpha
        : null
      
      var _x = Struct.getIfType(event.data, "x", Number, 0.0)
      var _y = Struct.getIfType(event.data, "y", Number, 0.0)

      var tiled = Struct.getIfType(event.data, "tiled", Boolean, false)
      var replace = Struct.getIfType(event.data, "replace", Boolean, false)
      var lifespawn = Struct.getIfType(event.data, "lifespawn", Number)
      var lifespawnTimer = Optional.is(lifespawn) ? new Timer(lifespawn) : null
      var task = new Task(event.name)
        .setState(new Map(String, any, {
          type: type,
          stage: "fade-in",
          sprite: sprite,
          alpha: originalAlpha,
          blendModeSource: blendModeSource,
          blendModeTarget: blendModeTarget,
          blendEquation: blendEquation,
          blendEquationAlpha: blendEquationAlpha,
          fadeInSpeed: fadeInSpeed,
          fadeOutSpeed: fadeOutSpeed,
          speed: _speed,
          speedTransformer: speedTransformer,
          angle: angle,
          angleTransformer: angleTransformer,
          x: _x,
          y: _y,
          xScale: xScale,
          xScaleTransformer: xScaleTransformer,
          yScale: yScale,
          yScaleTransformer: yScaleTransformer,
          tiled: tiled,
          replace: replace,
          lifespawn: lifespawnTimer,
        }))
        .whenUpdate(function() {
          var stage = this.state.get("stage")
          var sprite = this.state.get("sprite")

          var angle = this.state.get("angle")
          var angleTransformer = this.state.get("angleTransformer")
          if (Optional.is(angleTransformer)) {
            angle = angle + angleTransformer.update().value
          }

          var _speed = this.state.get("speed")
          var speedTransformer = this.state.get("speedTransformer")
          if (Optional.is(speedTransformer)) {
            _speed = speedTransformer.update().value
          }

          var xScaleTransformer = this.state.get("xScaleTransformer")
          if (Optional.is(xScaleTransformer)) {
            this.state.set("xScale", xScaleTransformer.update().value)
          }

          var yScaleTransformer = this.state.get("yScaleTransformer")
          if (Optional.is(yScaleTransformer)) {
            this.state.set("yScale", yScaleTransformer.update().value)
          }

          var _x = this.state.get("x")
          var _y = this.state.get("y")
          var width = abs(sprite.getWidth() * sprite.getScaleX())
          var height = abs(sprite.getHeight() * sprite.getScaleY())
          var surfaceWidth = this.state.get("surfaceWidth")
          var surfaceHeight = this.state.get("surfaceHeight")
          var horizontalFactor = 1.0
          var verticalFactor = 1.0

          if (Optional.is(surfaceWidth) && surfaceWidth > 0 && width > 0) {
            horizontalFactor = clamp(ceil(surfaceWidth / width), 1.0, 999999.9)
          }

          if (Optional.is(surfaceHeight) && surfaceHeight > 0 && height > 0) {
            verticalFactor = clamp(ceil(surfaceHeight / height), 1.0, 999999.9)
          }

          _x -= sign(sprite.getScaleX()) * Math.fetchCircleX(DeltaTime.apply(_speed), angle)
          _y -= sign(sprite.getScaleY()) * Math.fetchCircleY(DeltaTime.apply(_speed), angle)

          if (abs(_x) > width * horizontalFactor) {
            _x = sign(_x) * (abs(_x) - (((abs(_x) div width) + horizontalFactor) * width))
          }

          if (abs(_y) > height * verticalFactor) {
            _y = sign(_y) * (abs(_y) - (((abs(_y) div height) + verticalFactor) * height))
          }

          this.state.set("x", _x)
          this.state.set("y", _y)
          
          var lifespawn = this.state.get("lifespawn")
          if (Optional.is(lifespawn) && lifespawn.update().finished) {
            stage = "fade-out"
            this.state.set("stage", stage)
          }

          switch (stage) {
            case "idle":
              break
            case "fade-in":
              var fadeInSpeed = this.state.get("fadeInSpeed")
              var alpha = this.state.get("alpha")
              sprite.alpha = clamp(sprite.alpha + DeltaTime.apply(fadeInSpeed), 0.0, alpha)
              if (sprite.alpha >= alpha) {
                this.state.set("stage", "idle")
              }
              break
            case "fade-out":
              var fadeOutSpeed = this.state.get("fadeOutSpeed")
              sprite.alpha = clamp(sprite.alpha - DeltaTime.apply(fadeOutSpeed), 0.0, 1.0)
              if (sprite.alpha <= 0.0) {
                this.fullfill()
              }
              break
            default:
              throw new InvalidStatusException($"fade-sprite unkown stage: '{stage}', task.name: '{this.name}'")
              break
          }
        })
      
      var executor = Assert.isType(Struct.get(event.data, "executor"), TaskExecutor)
      if (replace) {
        executor.tasks.forEach(setFadeOut, type)
      }
      executor.add(task)

      var collection = Struct.get(event.data, "collection")
      if (Core.isType(collection, Collection)) {
        collection.add(task)
      }
    }
  },
  "fade-color": function() {
    return function(event) {
      static setFadeOut = function(task, iterator, type) {
        if (task.name == "fade-color" && task.state.get("type") == type) {
          task.state.set("stage", "fade-out")
        }
      }
    
      var fadeInSpeed = 1.0
      var fadeInDuration = Assert.isType(Struct.getDefault(event.data, "fadeInDuration", 0.0), Number)
      if (fadeInDuration > 0.0) {
        fadeInSpeed = FRAME_MS / fadeInDuration
      }

      var fadeOutSpeed = 1.0
      var fadeOutDuration = Assert.isType(Struct.getDefault(event.data, "fadeOutDuration", 0.0), Number)
      if (fadeOutDuration > 0.0) {
        fadeOutSpeed = FRAME_MS / fadeOutDuration
      }

      var blendModeSource = Core.isEnum(Struct.get(event.data, "blendModeSource"), BlendModeExt) 
        ? event.data.blendModeSource
        : BlendModeExt.SRC_ALPHA

      var blendModeTarget = Core.isEnum(Struct.get(event.data, "blendModeTarget"), BlendModeExt) 
        ? event.data.blendModeTarget
        : BlendModeExt.INV_SRC_ALPHA

      var blendEquation = Core.isEnum(Struct.get(event.data, "blendEquation"), BlendEquation) 
        ? event.data.blendEquation
        : BlendEquation.ADD
      
      var blendEquationAlpha = Core.isEnum(Struct.get(event.data, "blendEquationAlpha"), BlendEquation) 
        ? event.data.blendEquationAlpha
        : null

      var color = Assert.isType(event.data.color, Color)
      var originalAlpha = color.alpha
      var type = Assert.isType(event.data.type, String)
      color.alpha = fadeInSpeed
      var task = new Task(event.name)
        .setState(new Map(String, any, {
          stage: "fade-in",
          color: color,
          alpha: originalAlpha,
          blendModeSource: blendModeSource,
          blendModeTarget: blendModeTarget,
          blendEquation: blendEquation,
          blendEquationAlpha: blendEquationAlpha,
          fadeInSpeed: fadeInSpeed,
          fadeOutSpeed: fadeOutSpeed,
          type: type,
        }))
        .whenUpdate(function() {
          var stage = this.state.get("stage")
          var color = this.state.get("color")
          switch (stage) {
            case "idle":
              break
            case "fade-in":
              var fadeInSpeed = this.state.get("fadeInSpeed")
              var alpha = this.state.get("alpha")
              color.alpha = clamp(color.alpha + DeltaTime.apply(fadeInSpeed), 0.0, alpha)
              if (color.alpha >= alpha) {
                this.state.set("stage", "idle")
              }
              break
            case "fade-out":
              var fadeOutSpeed = this.state.get("fadeOutSpeed")
              color.alpha = clamp(color.alpha - DeltaTime.apply(fadeOutSpeed), 0.0, 1.0)
              if (color.alpha <= 0.0) {
                this.fullfill()
              }
              break
            default:
              throw new InvalidStatusException($"fade-color unkown stage: '{stage}', task.name: '{this.name}'")
              break
          }
        })
      
      var executor = Assert.isType(Struct.get(event.data, "executor"), TaskExecutor)
      executor.tasks.forEach(setFadeOut, type)
      executor.add(task)

      var collection = Struct.get(event.data, "collection")
      if (Core.isType(collection, Collection)) {
        collection.add(task)
      }
    }
  },
}
#macro EVENT_DISPATCHERS global.__EVENT_DISPATCHERS
