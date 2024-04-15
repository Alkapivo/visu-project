///@package io.alkapivo.core.service.texture

#macro BeanTextureService "TextureService"
function TextureService(): Service() constructor {

  ///@type {Map<String, TextureTemplate>}
  templates = new Map(String, TextureTemplate)

  ///@private
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "load-texture": function(event) {
      var texture = Assert.isType(event.data, TextureIntent)
      if (templates.contains(texture.name)) {
        event.promise.reject($"Texture '{texture.name}' already exists")
        return
      }
      if (Optional.is(this.executor.tasks.find(function(task, index, name) {
        return task.state.get("name") == name
      }, texture.name))) {
        event.promise.reject($"Task for texture '{texture.name}' already exists")
        return
      }

      var asset = sprite_add_ext(texture.file, texture.frames, texture.originX, 
        texture.originY, texture.prefetch)
      var task = new Task("load-texture")
        .setPromise(event.promise)
        .setState(new Map(String, any, {
          texture: texture,
          asset: asset,
        }))
        .whenUpdate(function() { })
      this.executor.add(task)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "free": function(event) {
      this.templates.forEach(function(template, name) {
        try {
          Logger.debug("TextureService", $"Free texture '{name}'")
          sprite_delete(template.asset)
        } catch (exception) {
          Logger.error("TextureService", $"Unable to free texture '{name}'. {exception.message}")
        }
      }).clear()
    },
  }))

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {TextureService}
  update = function() {
    this.dispatcher.update()
    this.executor.update()
    return this
  }

  ///@override
  ///@return {TextureService}
  free = function() {
    this.templates.forEach(function(template, name) {
      try {
        Logger.debug("TextureService", $"Free texture '{name}'")
        sprite_delete(template.asset)
      } catch (exception) {
        Logger.error("TextureService", $"Free texture '{name}' exception: {exception.message}")
      }
    }).clear()
    return this
  }

  ///@param {Event}
  ///@return {TextureService}
  onTextureLoadedEvent = function(event) {
    var task = this.executor.tasks
      .find(function(task, index, asset) {
        return task.state.get("asset") == asset
      }, event.data.asset)
    if (!Optional.is(task)) {
      throw new Exception($"Task for file '{event.data.file}' does not exists")
    }
    
    try {
      var config = Assert.isType(task.state.get("texture"), TextureIntent)
      Assert.isTrue(event.data.status == 0)
      Assert.isTrue(event.data.httpStatus == 200)
      Struct.set(config, "asset", event.data.asset)
      Struct.set(config, "file", FileUtil.get(event.data.file))
      this.templates.add(new TextureTemplate(config.name, config), config.name)
      task.promise.fullfill(config.name)
    } catch (exception) {
      task.promise.reject(exception.message)
    }

    return this
  }
}
