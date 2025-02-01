///@package io.alkapivo.core.renderer

#macro GMSurface "GMSurface"

///@type {Number}
global.__SURFACE_MAX_WIDTH = 8192
#macro SURFACE_MAX_WIDTH global.__SURFACE_MAX_WIDTH

///@type {Number}
global.__SURFACE_MAX_HEIGHT = 8192
#macro SURFACE_MAX_HEIGHT global.__SURFACE_MAX_HEIGHT

///@enum
function _SurfaceFormat(): Enum() constructor {
  RGBA8UNORM = surface_rgba8unorm
}
global.__SurfaceFormat = new _SurfaceFormat()
#macro SurfaceFormat global.__SurfaceFormat


///@param {Number} _width
///@param {Number} _height
///@param {SurfaceFormat} [_format]
///@param {?Struct} [config]
///@param {GMSurface} _asset
///_width, _height, _format = SurfaceFormat.RGBA8UNORM, _asset = null
function Surface(config = null) constructor {

  ///@type {Number}
  width = Assert.isType(clamp(Struct
    .getDefault(config, "width", 1), 1, SURFACE_MAX_WIDTH), Number)

  ///@type {Number}
  height = Assert.isType(clamp(Struct
    .getDefault(config, "height", 1), 1, SURFACE_MAX_HEIGHT), Number)

  ///@type {SurfaceFormat}
  format = Assert.isEnum(Struct
    .getDefault(config, "format", SurfaceFormat.RGBA8UNORM), SurfaceFormat)

  ///@type {?GMSurface}
  asset = Struct.contains(config, "asset")
    ? Assert.isType(Struct.get(config, "asset"), GMSurface)
    : null

  ///@type {Boolean}
  updated = false

  ///@param {?Number} [width]
  ///@param {?Number} [height]
  ///@return {Surface}
  static update = function(width = null, height = null) {
    this.updated = false
    if (Core.isType(width, Number) && width > 2) {
      this.width = round(width)
    }

    if (Core.isType(height, Number) && height > 2) {
      this.height = round(height)
    }

    if (!Core.isType(this.asset, GMSurface)) {
      this.asset = surface_create(this.width, this.height, this.format)
      this.updated = true
    }

    if (surface_get_format(this.asset) != this.format) {
      this.asset = surface_create(this.width, this.height, this.format)
      this.updated = true
    }

    if (surface_get_width(this.asset) != this.width
      || surface_get_height(this.asset) != this.height) {

      surface_resize(this.asset, this.width, this.height);
      this.updated = true
    }
    return this
  }

  ///@return {Surface}
  static renderOn = function(callback, data) {
    if (!Core.isType(this.asset, GMSurface)) {
      Logger.error("Surface", "renderOn fatal error")
      return
    }

    GPU.set.surface(this)
    callback(data)
    GPU.reset.surface()
    return this
  }

  ///@return {Surface}
  static render = function(x = 0, y = 0, alpha = 1.0) {
    if (!Core.isType(this.asset, GMSurface)) {
      Logger.error("Surface", "render fatal error")
      return this
    }

    draw_surface_ext(this.asset, x, y, 1.0, 1.0, 0.0, c_white, alpha)
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@param {Number} [x]
  ///@param {Number} [y]
  ///@param {Number} [alpha]
  ///@param {GMColor} [blend]
  ///@param {?BlendConfig} [blendConfig]
  ///@return {Surface}
  static renderStretched = function(width, height, x = 0, y = 0, alpha = 1.0, blend = c_white, blendConfig = null) {
    if (!Core.isType(this.asset, GMSurface)) {
      Logger.error("Surface", "render fatal error")
      return this
    }

    if (Optional.is(blendConfig)) {
      blendConfig.set()
      draw_surface_stretched_ext(this.asset, x, y, width, height, blend, alpha)
      blendConfig.reset()
    } else {
      draw_surface_stretched_ext(this.asset, x, y, width, height, blend, alpha)
    }

    return this
  }

  ///@param {Number} [x]
  ///@param {Number} [y]
  ///@param {Number} [angle]
  ///@param {Number} [alpha]
  ///@param {Number} [xOrigin]
  ///@param {Number} [yOrigin]
  ///@param {Number} [xScale]
  ///@param {Number} [yScale]
  ///@return {Surface}
  static renderScaledAndRotated = function(x = 0, y = 0, angle = 0.0, alpha = 1.0, xOrigin = 0.5, yOrigin = 0.5, xScale = 1.0, yScale = 1.0) {
    var surfaceXOrigin = this.width * xOrigin
    var surfaceYOrigin = this.height * yOrigin
    var surfaceXOriginBegin = 0
    var surfaceYOriginBegin = 0
    var surfaceXOriginEnd = this.width
    var surfaceYOriginEnd = this.height
    var xPoint = x + ((this.width * xOrigin) - (dcos(angle) * (surfaceXOrigin * xScale)) - (dsin(angle) * (surfaceYOrigin * yScale)));
    var yPoint = y + ((this.height * yOrigin) - (dcos(angle) * (surfaceYOrigin * yScale)) + (dsin(angle) * (surfaceXOrigin * xScale)));
    draw_surface_general(
			this.asset,
			surfaceXOriginBegin,
			surfaceYOriginBegin,
			surfaceXOriginEnd,
			surfaceYOriginEnd,
			xPoint,
			yPoint,
			xScale,
			yScale,
			angle,
			c_white,
			c_white,
			c_white,
			c_white,
			alpha
    )
    return this
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {Surface}
  static scaleToFill = function(width, height) {
    if (width < 2 || height < 2) {
      return this
    }

    if (!Core.isType(this.asset, GMSurface)) {
      Logger.error("Surface", "scaleToFill fatal error")
      return
    }
    
    var surfaceWidth = surface_get_width(this.asset)
    var surfaceHeight = surface_get_height(this.asset)
    var scale = max(width / surfaceWidth, height / surfaceHeight)
    this.width = surfaceWidth * scale
    this.height = surfaceHeight * scale
    surface_resize(this.asset, this.width, this.height)
    return this
  }

  static free = function() {
    if (Core.isType(this.asset, GMSurface)) {
      surface_free(this.asset)
    }
  }
}
