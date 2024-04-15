///@package io.alkapivo.core.service.sound

#macro BeanSoundService "SoundService"
function SoundService(): Service() constructor {

  ///@type {Map<String, GMSound>}
  sounds = new Map(String, any)

  ///@type {Map<String, SoundIntent>}
  intents = new Map(String, SoundIntent)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, { }))

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
    this.intents.clear()
    return this
  }
}

