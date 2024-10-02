///@package io.alkapivo.core.service.TrackService

///@param {?Struct} _context
///@param {Struct} [config]
function TrackService(_context, config = {}): Service() constructor {

  ///@type {Struct}
  context = Assert.isType(_context, Optional.of(Struct))

  ///@type {?Track}
  track = null

  ///@type {Number}
  time = 0.0

  ///@type {Number}
  duration = 0.0

  ///@type {Map<String, Callable>}
  handlers = Struct.contains(config, "handlers")
    ? Assert.isType(config.handlers, Map)
    : new Map(String, Callable)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open-track": function(event) {
      return this.openTrack(Struct.get(event.data, "track")).track
    },
    "rewind-track": function(event) {
      return this.rewind(event.data.timestamp).track
    },
    "pause-track": function(event) {
      return this.pause().track
    },
    "resume-track": function(event) {
      return this.resume().track
    },
    "close-track": function(event) {
      this.closeTrack()
    },
  }))

  ///@param {Event} event
  ///@return {TrackService}
  send = function(event) {
    if (!Core.isType(event.promise, Promise)) {
      event.promise = new Promise()
    }
    return this.dispatcher.send(event)
  }

  ///@return {Boolean}
  isTrackLoaded = method(this, Struct.contains(config, "isTrackLoaded")
    ? Assert.isType(config.isTrackLoaded, Callable)
    : function() {
      return Core.isType(this.track, Track)
    })

  ///@param {Track} track
  ///@return {TrackService}
  ///@throws {InvalidAssertException}
  openTrack = function(track) {
    this.track = Assert.isType(track, Track)
    this.duration = this.track.audio.getLength()
    return this
  }

  ///@return {TrackService}
  closeTrack = function() {
    this.stop()
    this.track = null
    return this
  }

  ///@return {TrackService}
  resume = function() {
    if (this.isTrackLoaded()) {
      if (this.track.audio.isLoaded()) {
        this.track.audio.resume()
      } else {
        this.time = 0.0
        this.track.audio.play()
      }
    }
    return this
  }

  ///@return {TrackService}
  pause = function() {
    if (this.isTrackLoaded()) {
      this.track.audio.pause()
    }
    return this
  }

  ///@return {TrackService}
  stop = function() {
    if (this.isTrackLoaded()) {
      this.track.audio.stop()
    }
    this.time = 0.0
    return this
  }

  ///@param {Number} timestamp
  ///@return {TrackService}
  rewind = function(timestamp) {
    if (this.isTrackLoaded) {
      if (this.track.audio.isLoaded()) {
        this.track.rewind(timestamp)
      } else {
        this.time = timestamp
        this.track.audio.play().rewind(timestamp).pause()
      }
    }
    return this
  }

  ///@return {TrackService}
  update = function() {
    this.dispatcher.update()
    if (this.isTrackLoaded()) {
      this.time = this.track.audio.isLoaded()
        ? this.track.audio.getPosition()
        : this.time
      this.track.update(this.time)
    }
    return this
  }

  ///@return {Number}
  countEvents = function() {
    static sumChannelEvents = function(channel, name, counter) {
      counter.size += channel.events.size()
    }

    if (!this.isTrackLoaded()) {
      return 0
    }
    
    var counter = { size: 0 }
    this.track.channels.forEach(sumChannelEvents, counter)
    return counter.size
  }
}

