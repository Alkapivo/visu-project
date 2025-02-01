///@package io.alkapivo.core.service.video

///@description https://github.com/YoYoGames/GameMaker-Bugs/issues/2543
#macro GMVideoSurface "GMVideoSurface"

///@enum
function _VideoStatus(): Enum() constructor {
  CLOSED = video_status_closed
  PREPARING = video_status_preparing
  PLAYING = video_status_playing
  PAUSED = video_status_paused
}
global.__VideoStatus = new _VideoStatus()
#macro VideoStatus global.__VideoStatus


///@enum
function _VideoFormat(): Enum() constructor {
  RGBA = video_format_rgba
  YUV = video_format_yuv
}
global.__VideoFormat = new _VideoFormat()
#macro VideoFormat global.__VideoFormat


///@static
///@type {Map<VideoStatus, String>}
global.__VideoStatusNames = new Map()
#macro VideoStatusNames global.__VideoStatusNames
VideoStatusNames.set(VideoStatus.CLOSED, "CLOSED")
VideoStatusNames.set(VideoStatus.PREPARING, "PREPARING")
VideoStatusNames.set(VideoStatus.PLAYING, "PLAYING")
VideoStatusNames.set(VideoStatus.PAUSED, "PAUSED")


///@param {?Struct} [config]
function VideoSurface(config = null): Surface(config) constructor {

  ///@override
  ///@param {?Number} [width]
  ///@param {?Number} [height]
  ///@return {Surface}
  update = function(width = null, height = null) {
    this.asset = null
    var status = video_get_status()
    if (status != VideoStatus.PLAYING && status != VideoStatus.PAUSED) {
      return this
    }

    var data = video_draw()
    Struct.set(this, "videoData", data)
    if (!Core.isType(data, GMArray) || data[0] == -1) {
      return this
    }

    this.asset = data[1]
    this.width = surface_get_width(this.asset)
    this.height = surface_get_height(this.asset)
    return this
  }

  ///@override
  //@return {Surface}
  renderOn = function(callback, data) {
    if (!Core.isType(this.asset, GMVideoSurface)) {
      return this
    }

    GPU.set.surface(this)
    callback(data)
    GPU.reset.surface()
    return this
  }

  ///@override
  ///@param {Number} [x]
  ///@param {Number} [y]
  ///@param {Number} [width]
  ///@param {Number} [height]
  ///@param {Number} [alpha]
  ///@param {GMColor} [blend]
  ///@param {?BlendConfig} [blendConfig]
  ///@return {Surface}
  render = function(x = 0, y = 0, width = null, height = null, alpha = 1.0, blend = c_white, blendConfig = null) {
    if (!Core.isType(this.asset, GMVideoSurface)) {
      return this
    }

    var _width = Core.isType(width, Number) && width > 1 ? width : this.width
    var _height = Core.isType(height, Number) && height > 1 ? height : this.height
    if (Optional.is(blendConfig)) {
      blendConfig.set()
      draw_surface_stretched_ext(this.asset, x, y, _width, _height, blend, alpha)
      blendConfig.reset()
    } else {
      draw_surface_stretched_ext(this.asset, x, y, _width, _height, blend, alpha)
    }
    
    return this
  }

  ///@override
  ///@param {Number} width
  ///@param {Number} height
  ///@return {Surface}
  scaleToFill = function(width, height) {
    if (!Core.isType(this.asset, GMVideoSurface)) {
      return this
    }

    var surfaceWidth = surface_get_width(this.asset)
    var surfaceHeight = surface_get_height(this.asset)
    var scale = max(width / surfaceWidth, height / surfaceHeight)
    this.width = surfaceWidth * scale
    this.height = surfaceHeight * scale
    return this
  }

  ///@override
  free = function() { }
}


///@param {Struct} json
function Video(json) constructor {

  ///@type {String}
  path = Assert.isType(Struct.get(json, "path"), String)

  ///@type {Number}
  timestamp = Assert.isType(Struct.getDefault(json, "timestamp", 0.0), Number)

  ///@type {Volume}
  volume = Assert.isType(Struct.getDefault(json, "volume", 1.0), Number)

  ///@type {Boolean}
  loop = Assert.isType(Struct.getDefault(json, "loop", false), Boolean)

  ///@type {Surface}
  surface = Assert.isType(new VideoSurface(1, 1), VideoSurface)

  ///@return {VideoStatus}
  getStatus = function() {
    return video_get_status()
  }

  ///@return {String}
  getStatusName = function() {
    return VideoStatusNames.get(this.getStatus())
  }

  ///@return {Number}
  getPosition = function() {
    return video_get_position() / 1000
  }

  ///@return {Number}
  getDuration = function() {
    return video_get_duration() / 1000
  }

  ///@return {Number}
  getVolume = function() {
    return video_get_volume()
  }

  ///@return {VideoFormat}
  getFormat = function() {
    return video_get_format()
  }

  ///@return {Boolean}
  isLoaded = function() {
    var status = this.getStatus()
    return status == VideoStatus.PLAYING || status == VideoStatus.PAUSED
  }

  ///@param {Number} timestamp
  ///@return {Video}
  setTimestamp = function(timestamp) {
    this.timestamp = Assert.isType(timestamp, Number)
    return this
  }

  ///@return {Video}
  open = function() {
    this.close()
    video_open($"{this.path}")
    this.setVolume(this.volume).setLoop(this.loop)
    return this
  }

  ///@return {Video}
  close = function() {
    if (this.getStatus() != VideoStatus.CLOSED) {
      Logger.debug("Video", "close")
      video_close()
    }
    return this
  }

  ///@return {Video}
  pause = function() {
    if (this.getStatus() == VideoStatus.PLAYING) {
      Logger.debug("Video", $"pause at: {this.getPosition()}")
      video_pause()
    }
    return this
  }

  ///@return {Video}
  resume = function() {
    if (this.getStatus() == VideoStatus.PAUSED) {
      Logger.debug("Video", $"resume on: {this.getPosition()}")
      video_resume()
    }
    return this
  }

  ///@param {Number} timestamp
  ///@return {Video}
  seek = function(timestamp) {
    var time = clamp(floor(timestamp * 1000), 0, floor(this.getDuration() * 1000))
    Logger.debug("Video", $"seek to: {time}")
    video_seek_to(time)
    return this
  }

  ///@param {Number} volume
  ///@return {Video}
  setVolume = function(volume) {
    video_set_volume(clamp(volume, 0.0, 1.0))
    return this
  }

  ///@param {Boolean} loop
  ///@return {Video}
  setLoop = function(loop) {
    this.loop = loop
    video_enable_loop(loop)
    return this
  }
}


///@static
function _VideoUtil() constructor {

  ///@return {VideoUtil}
  runGC = function() {
    Logger.debug("Video", $"gcVideo, video status before: {VideoStatusNames.get(video_get_status())}")
    video_close()
    Logger.debug("Video", $"gcVideo, video status after: {VideoStatusNames.get(video_get_status())}")
    return this
  }
}
global.__VideoUtil = new _VideoUtil()
#macro VideoUtil global.__VideoUtil
