///@package io.alkapivo.core.service.sound

#macro GMSound "GMSound"

///@type {Struct} json
function SoundIntent(json) constructor {

  ///@type {String}
  file = Assert.isType(json.file, String)

  ///@return {Struct}
  serialize = function() {
    return { file: this.file }
  }
}

///@type {Struct} json
function SoundTemplate(json) constructor {

  ///@type {String}
  name = Assert.isType(Struct.get(json, "name"), String)

  ///@type {Boolean}
  loop = Assert.isType(Struct.getDefault(config, "loop", false), Boolean)

  ///@type {Number}
  priority = Assert.isType(Struct.getDefault(config, "priority", 100), Number)

  ///@type {Number}
  timestamp = Assert.isType(Struct.getDefault(json, "timestamp", 0.0), Number)
}

///@type {GMSound} _asset
///@type {Struct} [config]
function Sound(_asset, config = {}) constructor {

  ///@private
  ///@type
  asset = Assert.isType(_asset, GMSound)

  ///@type {String}
  name = Assert.isType(Struct.contains(config, "name") 
    ? config.name 
    : audio_get_name(this.asset), String)

  ///@type {Number}
  duration = audio_sound_length(this.asset)

  ///@type {Boolean}
  loop = Assert.isType(Struct.getDefault(config, "loop", false), Boolean)

  ///@type {Number}
  priority = Assert.isType(Struct.getDefault(config, "priority", 100), Number)

  ///@param {Number} [volume]
  ///@return {Sound}
  play = function(volume = 1.0) {
    this.stop()
    this.soundId = audio_play_sound_ext({
      sound: this.asset,
      priority: this.priority,
      loop: this.loop,
      gain: volume,
    })
    
    return this
  }

  ///@return {Sound}
  stop = function() {
    if (Core.isType(this.soundId, GMSound)) {
      audio_stop_sound(this.soundId)
    }
    this.soundId = null
    return this
  }

  ///@return {Sound}
  pause = function() {
    if (Core.isType(this.soundId, GMSound) && !audio_is_paused(this.soundId)) {
      audio_pause_sound(this.soundId)
    }
    return this
  }

  ///@param {Number} position
  ///@return {Sound}
  rewind = function(position) {
    if (Core.isType(this.soundId, GMSound)) {
      audio_sound_set_track_position(this.soundId, position)
    }
    return this
  }

  ///@return {Sound}
  resume = function() {
    if (this.isPaused()) {
      audio_resume_sound(this.soundId)
    }
    return this
  }

  ///@return {Boolean}
  isLoaded = function() {
    return Core.isType(this.soundId, GMSound) && audio_is_playing(this.soundId)
  }

  ///@return {Boolean}
  isPaused = function() {
    return Core.isType(this.soundId, GMSound) && audio_is_paused(this.soundId)
  }

  isPlaying = function() {
    return this.isLoaded() && !audio_is_paused(this.soundId)
  }

  ///@private
  ///@type {?GMSound}
  soundId = null

  ///@return {Number}
  getPosition = function() {
    return Core.isType(this.soundId, GMSound)
      ? audio_sound_get_track_position(this.soundId)
      : 0.0
  }

  ///@return {Number}
  getLength = function() {
    return audio_sound_length(this.asset)
  }

  ///@type {Number} volume
  ///@type {Number} [time] - in seconds
  ///@return {Sound}
  setVolume = function(volume, time = 0) {
    if (Core.isType(this.soundId, GMSound)) {
      audio_sound_gain(this.soundId, volume, time * 1000)
    }
    return this
  }

  ///@return {Number}
  getVolume = function() {
    return Core.isType(this.soundId, GMSound) 
      ? audio_sound_get_gain(this.soundId) 
      : 0.0
  }
}

function _SoundUtil() constructor {

  ///@param {?String} name
  ///@return {Boolean}
  exists = function(name) {
    return Core.isType(name, String) && asset_get_index(name) != -1
  }


  ///@param {String} name
  ///@param {?GMSound} [defaultValue]
  ///@return {?GMSound}
  fetchGMSound = function(name, defaultValue = null) {
    var asset = asset_get_index(name)
    if (!Core.isType(asset, GMSound)) {
      Logger.warn("SoundUtil", $"GMSound {name} does not exists")
      return null
    }

    return asset
  }

  ///@param {String} name
  ///@param {?Struct} [config]
  ///@return {?Sound}
  fetch = function(name, _config = null) {
    var config = Struct.set(Core.isType(_config, Struct) ? _config : { name: name }, "name", name)
    var soundService = Beans.get(BeanSoundService)
    if (Optional.is(soundService)) {
      var sound = soundService.sounds.get(name)
      if (Optional.is(sound)) {
        return new Sound(sound, config)
      }
    }
    
    var asset = this.fetchGMSound(name)
    return Core.isType(asset, GMSound) ? new Sound(asset, config) : null
  }
}
global.__SoundUtil = new _SoundUtil()
#macro SoundUtil global.__SoundUtil
