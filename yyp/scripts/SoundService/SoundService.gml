///@package io.alkapivo.core.service.sound

#macro GMAudioGroupID "GMAudioGroupID"

#macro BeanSoundService "SoundService"
function SoundService(): Service() constructor {

  ///@type {Map<String, GMSound>}
  sounds = new Map(String, GMSound)

  ///@type {Map<String, SoundIntent>}
  intents = new Map(String, SoundIntent)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, { }))

  ///@type {Map<String, GMAudioGroupID>}
  audioGroups = new Map(String, GMAudioGroupID)

  ///@param {GMAudioGroupID}
  ///@return {Boolean}
  loadAudioGroup = function(audioGroupId) {
    if (!Core.isType(audioGroupId, GMAudioGroupID)) {
      return false
    }

    var name = audio_group_name(audioGroupId)
    if (!Core.isType(name, String)) {
      return false
    }

    if (!audio_group_is_loaded(audioGroupId)) {
      var response = audio_group_load(audioGroupId)
      if (response) {
        this.audioGroups.set(name, audioGroupId)    
      }
      return response
    }
    
    this.audioGroups.set(name, audioGroupId)
    return true
  }

  ///@param {GMAudioGroupID}
  ///@return {SoundService}
  unloadAudioGroup = function(audioGroupId) {
    if (!Core.isType(audioGroupId, GMAudioGroupID)) {
      return this
    }

    var name = audio_group_name(audioGroupId)
    if (!Core.isType(name, String)) {
      return this
    }

    if (audio_group_is_loaded(audioGroupId)) {
      var res = audio_group_unload(audioGroupId)
      res = audio_group_unload(audioGroupId)
    }
    this.audioGroups.remove(name)

    return this
  }

  ///@override
  ///@return {SoundService}
  free = function() {
    this.sounds.forEach(function(sound, name) {
      try {
        Logger.debug("SoundService", $"Free sound '{name}'")
        audio_destroy_stream(sound)
      } catch (exception) {
        Logger.error("SoundService", $"Free sound '{name}' exception: {exception.message}")
      }
    }).clear()
    this.audioGroups.forEach(function(audioGroupId, name) {
      try {
        Logger.debug("SoundService", $"Free audioGroupId '{name}'")
        this.unloadAudioGroup(audioGroupId)
      } catch (exception) {
        Logger.error("SoundService", $"Free audioGroupId '{name}' exception: {exception.message}")
      }
    }).clear()
    this.intents.clear()
    return this
  }
}

