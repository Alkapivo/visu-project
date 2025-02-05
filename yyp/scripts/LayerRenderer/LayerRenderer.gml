///@package io.alkapivo.visu.renderer

///@param {?Struct} [config]
function LayerRenderer(config = null) {

  ///@type {Array<Task>}
  textures = new Array(Task).enableGC()

  ///@type {Array<Task>}
  colors = new Array(Task).enableGC()

  ///@type {Struct}
  video = {
    alpha: 1.0,
    blendColor: c_white,
    blendConfig: null,
    setAlpha: function(alpha) {
      this.alpha = alpha
      return this
    },
    setBlendColor: function(blendColor) {
      this.blendColor = blendColor
      return this
    },
    setBlendConfig: function(blendConfig) {
      this.blendConfig = blendConfig
      return this
    },
  }

  ///@type {Array<Callable>}
  order = new Array(Callable, Struct.getIfType(config, "order", GMArray, []))

  ///@param {...String} name
  ///@return {LayerRenderer}
  setOrder = function(/*...name*/) {
    this.order.clear()
    for (var index = 0; index < argument_count; index++) {
      var name = argument[index]
      var callback = null
      switch (name) {
        case "textures": callback = this.renderTextures
          break
        case "colors": callback = this.renderColors
          break
        case "video": callback = this.renderVideo
          break
        default: Logger.warn("LayerRenderer", $"No render handler for: {name}")
          break
      }

      if (Optional.is(callback)) {
        this.order.add(callback)
      }
    }
  }

  ///@private
  ///@param {Task} task
  ///@param {any} iterator
  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  renderColor = function(task, iterator, area) {
    var color = task.state.get("color").toGMColor()
    GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
    GPU.set.blendEquation(task.state.get("blendEquation"), task.state.get("blendEquationAlpha"))
    GPU.render.rectangle(area.getX(), area.getY(), area.getWidth(), area.getHeight(), 
      false, color, color, color, color, task.state.get("color").alpha)
    GPU.reset.blendEquation()
    GPU.reset.blendMode()
    return this
  }

  ///@private
  ///@param {Task} task
  ///@param {any} iterator
  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  renderTexture = function(task, iterator, area) {
    var width = area.getWidth()
    var height = area.getHeight()
    var sprite = task.state.get("sprite").scaleToFill(width, height)
      .setScaleX(sprite.getScaleX() * task.state.get("xScale"))
      .setScaleY(sprite.getScaleY() * task.state.get("yScale"))
    var render = task.state.get("tiled") 
      ? sprite.renderTiled
      : sprite.render

    GPU.set.blendModeExt(task.state.get("blendModeSource"), task.state.get("blendModeTarget"))
    GPU.set.blendEquation(task.state.get("blendEquation"), task.state.get("blendEquationAlpha"))
    render(
      ((sprite.texture.offsetX / sprite.getWidth()) * width) 
        - ceil(((sprite.getWidth() * sprite.getScaleX()) - width) / 2.0) 
        + task.state.get("x"),
      ((sprite.texture.offsetY / sprite.getHeight()) * height) 
        - ceil(((sprite.getHeight() * sprite.getScaleY()) - height) / 2.0) 
        + task.state.get("y")
    )
    GPU.reset.blendEquation()
    GPU.reset.blendMode()

    task.state.set("surfaceWidth", area.getWidth())
    task.state.set("surfaceHeight", area.getHeight())
    return this
  }

  ///@private
  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  renderColors = function(area) {
    this.colors.forEach(this.renderColor, area)
    return this
  }
  
  ///@private
  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  renderTextures = function(area) {
    this.textures.forEach(this.renderTexture, area)
    return this
  }
  
  ///@private
  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  renderVideo = function(area) {
    var video = Beans.get(BeanVisuController).videoService.getVideo()
    if (!Optional.is(video) || !video.isLoaded()) {
      return this
    }

    video.surface.update()

    var width = area.getWidth()
    var height = area.getHeight()
    var scale = max(width / video.surface.width, height / video.surface.height)
    var _width = ceil(video.surface.width * scale)
    var _height = ceil(video.surface.height * scale)
    var _x = -1 * ceil((_width - width) / 2.0)
    var _y = -1 * ceil((_height - height) / 2.0)

    video.surface.render(_x, _y, _width, _height, this.video.alpha, this.video.blendColor, this.video.blendConfig)

    return this 
  }

  ///@return {LayerRenderer}
  clear = function() {
    this.textures.forEach(TaskUtil.fullfill).clear()
    this.colors.forEach(TaskUtil.fullfill).clear()
    return this
  }

  ///@return {LayerRenderer}
  update = function() {
    static gc = function(task, index, tasks) {
      if (TaskUtil.filterFinished(task)) {
        tasks.gc.add(index)
      }
    }

    this.textures.forEach(gc, this.textues).runGC()
    this.colors.forEach(gc, this.colors).runGC()

    return this
  }

  ///@param {Rectangle} area
  ///@return {LayerRenderer}
  render = function(area) {
    this.order.forEach(Lambda.callback, area)
    return this
  }
}