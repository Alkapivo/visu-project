///@package io.alkapivo.core.event

///@param {String} _name
///@param {any} [_data]
///@param {?Promise} [_promise]
function Event(_name, _data = null, _promise = null) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {any}
  data = null
  
  ///@type {?Promise}
  promise = null

  ///@param {any} data
  ///@return {Event}
  setData = function(data) {
    this.data = data
    return this
  }
  this.setData(_data)

  ///@param {?Promise} promise
  ///@return {Event}
  setPromise = function(promise = null) {
    this.promise = Assert.isType(promise, Optional.of(Promise))
    return this
  }
  this.setPromise(_promise)
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
      var task = new Task(event.name)
        .setState(new Map(String, any, {
          stage: "fade-in",
          sprite: sprite,
          alpha: originalAlpha,
          fadeInSpeed: fadeInSpeed,
          fadeOutSpeed: fadeOutSpeed,
          speed: (Core.isType(Struct.get(event.data, "speed"), Number) ? event.data.speed : 0),
          angle: (Core.isType(Struct.get(event.data, "angle"), Number) ? event.data.angle : 0),
          x: 0,
          y: 0,
          type: type,
        }))
        .whenUpdate(function() {
          var stage = this.state.get("stage")
          var sprite = this.state.get("sprite")

          var _x = this.state.get("x")
          var _y = this.state.get("y")
          var width = sprite.getWidth() * sprite.getScaleX()
          var height = sprite.getHeight() * sprite.getScaleY()
          var _speed = this.state.get("speed")
          var angle = this.state.get("angle")
          _x += Math.fetchCircleX(DeltaTime.apply(_speed), angle)
          _y += Math.fetchCircleY(DeltaTime.apply(_speed), angle)
          if (abs(_x) > width) {
            _x =  sign(_x) * (abs(_x) - ((abs(_x) div width) * width))
          }
          if (abs(_y) > height) {
            _y = sign(_y) * (abs(_y) - ((abs(_y) div height) * height))
          }
          this.state.set("x", _x)
          this.state.set("y", _y)
          
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
      executor.tasks.forEach(setFadeOut, type)
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

      var color = Assert.isType(event.data.color, Color)
      var originalAlpha = color.alpha
      var type = Assert.isType(event.data.type, String)
      color.alpha = fadeInSpeed
      var task = new Task(event.name)
        .setState(new Map(String, any, {
          stage: "fade-in",
          color: color,
          alpha: originalAlpha,
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
