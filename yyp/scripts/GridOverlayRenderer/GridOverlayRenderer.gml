///@package com.alkapivo.visu.component.grid.renderer.GridOverlayRenderer

///@todo rename to sth that reflects video, background and foreground renderer
///@param {GridRenderer} _renderer
function GridOverlayRenderer(_renderer) constructor {

  ///@type {GridRenderer}
  renderer = Assert.isType(_renderer, GridRenderer)

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
      GPU.render.rectangle(0, 0, acc.width, acc.height, false, color, color, color, color, alpha)
    }

    static renderBackground = function(task, index, acc) {
      var sprite = task.state.get("sprite")
      sprite.scaleToFill(acc.width, acc.height)
        .render(
          (sprite.texture.offsetX / sprite.texture.width) * acc.width,
          (sprite.texture.offsetY / sprite.texture.height) * acc.height
        )
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
      GPU.render.rectangle(0, 0, acc.width, acc.height, false, color, color, color, color, alpha)
    }

    static renderForeground = function(task, index, acc) {
      var sprite = task.state.get("sprite")
      sprite.scaleToFill(acc.width, acc.height)
        .render(
          (sprite.texture.offsetX / sprite.texture.width) * acc.width,
          (sprite.texture.offsetY / sprite.texture.height) * acc.height
        )
    }

    GPU.set.blendMode(BlendMode.ADD)
    this.foregroundColors.forEach(renderForegroundColor, { width: width, height: height })
    this.foregrounds.forEach(renderForeground, { width: width, height: height })
    GPU.reset.blendMode()
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {GridOverlayRenderer}
  renderVideo = function(width, height) {
    var video = this.renderer.controller.videoService.getVideo()
    if (!Core.isType(video, Video) || !video.isLoaded()) {
      return this
    }

    video.surface.update().scaleToFill(width, height).render()    
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
