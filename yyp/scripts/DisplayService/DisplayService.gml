///@package io.alkapivo.core.service

///@enum
function _Cursor(): Enum() constructor {
  DEFAULT = cr_default
  RESIZE_HORIZONTAL = cr_size_we
  RESIZE_VERTICAL = cr_size_ns
}
global.__Cursor = new _Cursor()
#macro Cursor global.__Cursor


///@param {Controller} _controller
///@param {Struct} [config]
function DisplayService(_controller, config = {}): Service() constructor {

  ///@type {Controller}
  controller = Assert.isType(_controller, Struct)

  ///@private
	///@type {Number}
	previousWidth = 0;
	
  ///@private
	///@type {Number}
	previousHeight = 0;

	///@type {Number}
	windowWidth = 0
	
	///@type {Number}
	windowHeight = 0

  ///@type {Number}
  minWidth = Core.isType(Struct.get(config, "minWidth"), Number) ? config.minWidth : 320

  ///@type {Number}
  minHeight = Core.isType(Struct.get(config, "minHeight"), Number) ? config.minHeight : 240

  ///@private
  ///@type {String}
	state = "idle"

  ///@private
  ///@type {Timer}
  timer = new Timer(FRAME_MS * 20)

  ///@return {Number}
  getWidth = function() {
    return window_get_width()
  }

  ///@return {Number}
  getHeight = function() {
    return window_get_height()
  }

  ///@return {Number}
  getDisplayWidth = function() {
    return display_get_width()
  }

  ///@return {Number}
  getDisplayHeight = function() {
    return display_get_height()
  }

  ///@return {Boolean}
  getFullscreen = function() {
    return window_get_fullscreen()
  }

  ///@return {DisplayService}
  setFullscreen = function(enable) {
    var fullscreen = this.getFullscreen()
    if (fullscreen != enable) {
      window_set_fullscreen(enable)

      if (fullscreen) {
        this.resize(this.windowWidth, this.windowHeight)
      } else {
        this.windowWidth = this.getWidth()
        this.windowHeight = this.getHeight()
      }
    }
    return this
  }

  ///@return {Cursor}
  getCursor = function(cursor) {
    return window_get_cursor()
  }

  ///@param {Cursor} cursor
  ///@return {DisplayService}
  setCursor = function(cursor) {
    window_set_cursor(cursor)
    return this
  }

  ///@return {String}
  getCaption = function() {
    return window_get_caption()
  }

  ///@param {String} caption
  ///@return {DisplayService}
  setCaption = function(caption) {
    window_set_caption(caption)
    return this
  }

  ///@param {Number} _width
  ///@param {Number} _height
  ///@return {DisplayService}
  resize = function(_width, _height) {
    var width = max(this.minWidth, _width)
    var height = max(this.minHeight, _height)
    try {
      Logger.debug("DisplayService", $"Resize from {this.previousWidth}x{this.previousHeight} to {width}x{height}")
      display_set_gui_size(width, height)
      window_set_size(width, height)
      surface_resize(application_surface, width, height)
      if (!this.getFullscreen()) {
        this.windowWidth = this.getWidth()
        this.windowHeight = this.getHeight()
      }
    } catch (exception) {
      Logger.error("ResizeEvent", exception.message)
    }
    return this
  }

  ///@return {DisplayService}
  update = function() {
    static isResizeRequired = function(context) {
      return context.previousWidth != display_get_gui_width()
        || context.previousHeight != display_get_gui_height()
    }

    if (this.state == "resized") {
      this.state = "idle"
    }

    if (this.state == "idle") {
      this.state = isResizeRequired(this)
        ? "required"
        : "idle"
    }

    if (this.state == "required") {
      if (this.timer.update().finished) {
        var width = window_get_width()
        var height = window_get_height()
        if (width > 0 && height > 0) {
          this.resize(width, height)
          this.timer.reset()
          this.state = "resized"
        }
      }
    }

    if (this.state == "idle" || this.state == "resized") {
      this.previousWidth = window_get_width()
      this.previousHeight = window_get_height()
    }
    return this
  }
}
