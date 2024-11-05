///@package com.alkapivo.visu.renderer.grid

///@todo rename to sth that reflects video, background and foreground renderer
function GridOverlayRenderer() constructor {

  ///@type {Array<Task>}
  backgrounds = new Array(Task).enableGC()

  ///@type {Array<Task>}
  foregrounds = new Array(Task).enableGC()

  ///@type {Array<Task>}
  backgroundColors = new Array(Task).enableGC()

  ///@type {Array<Task>}
  foregroundColors = new Array(Task).enableGC()

  ///@return {GridOverlayRenderer}
  clear = function() {
    this.backgrounds.clear()
    this.foregrounds.clear()
    this.backgroundColors.clear()
    this.foregroundColors.clear()
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {GridOverlayRenderer}
  renderBackgrounds = function(width, height) {
    static renderBackgroundColor = function(task, index, acc) {
      var color = task.state.get("color")
      var alpha = color.alpha
      color = color.toGMColor()
      GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
      GPU.set.blendEquation(task.state.get("blendEquation"))
      GPU.render.rectangle(0, 0, acc.width, acc.height, false, color, color, color, color, alpha)
      GPU.reset.blendEquation()
      GPU.reset.blendMode()
    }

    static renderBackground = function(task, index, acc) {
      var sprite = task.state.get("sprite")
      sprite.scaleToFill(acc.width, acc.height)
        .setScaleX(sprite.scaleX * task.state.get("xScale"))
        .setScaleY(sprite.scaleY * task.state.get("yScale"))
      var _x = ceil(((sprite.texture.width * sprite.getScaleX()) - acc.width) / 2.0) + task.state.get("x")
      var _y = ceil(((sprite.texture.height * sprite.getScaleY()) - acc.height) / 2.0) + task.state.get("y")
      GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
      GPU.set.blendEquation(task.state.get("blendEquation"))
      sprite.renderTiled(
        ((sprite.texture.offsetX / sprite.texture.width) * acc.width) - _x,
        ((sprite.texture.offsetY / sprite.texture.height) * acc.height) - _y
      )
      GPU.reset.blendEquation()
      GPU.reset.blendMode()
    }

    this.backgroundColors.forEach(renderBackgroundColor, { width: width, height: height })
    this.backgrounds.forEach(renderBackground, { width: width, height: height })
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {GridOverlayRenderer}
  renderForegrounds = function(width, height) {
    static renderForegroundColor = function(task, index, acc) {
      var color = task.state.get("color")
      var alpha = color.alpha
      color = color.toGMColor()
      GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
      GPU.set.blendEquation(task.state.get("blendEquation"))
      GPU.render.rectangle(0, 0, acc.width, acc.height, false, color, color, color, color, alpha)
      GPU.reset.blendEquation()
      GPU.reset.blendMode()
    }

    static renderForeground = function(task, index, acc) {
      var sprite = task.state.get("sprite")
      sprite.scaleToFill(acc.width, acc.height)
        .setScaleX(sprite.scaleX * task.state.get("xScale"))
        .setScaleY(sprite.scaleY * task.state.get("yScale"))
      var _x = ceil(((sprite.texture.width * sprite.getScaleX()) - acc.width) / 2.0) + task.state.get("x")
      var _y = ceil(((sprite.texture.height * sprite.getScaleY()) - acc.height) / 2.0) + task.state.get("y")
      GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
      GPU.set.blendEquation(task.state.get("blendEquation"))
      sprite.renderTiled(
        ((sprite.texture.offsetX / sprite.texture.width) * acc.width) - _x,
        ((sprite.texture.offsetY / sprite.texture.height) * acc.height) - _y
      )
      GPU.reset.blendEquation()
      GPU.reset.blendMode()
    }

    this.foregroundColors.forEach(renderForegroundColor, { width: width, height: height })
    this.foregrounds.forEach(renderForeground, { width: width, height: height })
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {GridOverlayRenderer}
  renderVideo = function(width, height) {
    var videoService = Beans.get(BeanVisuController).videoService
    var video = videoService.getVideo()
    if (!Core.isType(video, Video) || !video.isLoaded()) {
      return this
    }

    video.surface.update()
    var scale = max(width / video.surface.width, height / video.surface.height)
    var _width = ceil(video.surface.width * scale)
    var _height = ceil(video.surface.height * scale)
    var _x = -1 * ceil((_width - width) / 2.0)
    var _y = -1 * ceil((_height - height) / 2.0)
    video.surface.render(_x, _y, _width, _height)    
    return this
  }

  ///@return {GridOverlayRenderer}
  update = function() {
    static gcFilter = function(task, index, gc) {
      if (!Core.isType(task, Task)
        || task.name != "fade-sprite"
        || task.status == TaskStatus.FULLFILLED
        || task.status == TaskStatus.REJECTED
        || !Core.isType(task.state.get("sprite"), Sprite)) {
        
        gc.add(index)
      }
    }

    static gcColorFilter = function(task, index, gc) {
      if (!Core.isType(task, Task)
        || task.name != "fade-color"
        || task.status == TaskStatus.FULLFILLED
        || task.status == TaskStatus.REJECTED
        || !Core.isType(task.state.get("color"), Color)) {
        
        gc.add(index)
      }
    }
    
    this.backgrounds.forEach(gcFilter, this.backgrounds.gc).runGC()
    this.foregrounds.forEach(gcFilter, this.foregrounds.gc).runGC()
    this.backgroundColors.forEach(gcColorFilter, this.backgroundColors.gc).runGC()
    this.foregroundColors.forEach(gcColorFilter, this.foregroundColors.gc).runGC()
    return this
  }
}
