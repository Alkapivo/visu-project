///@package io.alkapivo.core.service.sound.sfx

function SFXService(): Service() constructor {

  ///@type {Number}
  volume = 0.5

  ///@private
  ///@type {Map<String, SFX>}
  sfxs = new Map(String, SFX)

  ///@param {String} name
  ///@return {Boolean}
  contains = function(name) {
    return Core.isType(this.sfxs.get(name), SFX)
  }

  ///@param {String} name
  ///@return {?SFX}
  get = function(name) {
    return this.contains(name) ? this.sfxs.get(name) : null
  }

  ///@param {String} name
  ///@param {SFX} sfx
  ///@return {SFXService}
  set = function(name, sfx) {
    Logger.debug("SFXService", $"Set SFX \"{name}\".")
    this.sfxs.set(name, sfx)
    return this
  }

  ///@return {Number}
  getVolume = function() {
    return this.volume
  }

  ///@param {Number} volume
  ///@return {SFXService}
  setVolume = function(volume) {
    this.volume = clamp(volume, 0.0, 1.0)
    return this.update()
  }

  ///@param {String} name
  ///@return {SFXService}
  remove = function(name) {
    Logger.debug("SFXService", $"Remove SFX \"{name}\".")
    var sfx = this.get(name)
    if (Optional.is(sfx)) {
      sfx.play()
    }

    this.sfxs.remove(name)
    return this
  }

  ///@param {String} name
  ///@return {SFXService}
  play = function(name) {
    var sfx = this.get(name)
    if (Optional.is(sfx) && !sfx.dispatched) {
      sfx.play()
    }

    return this
  }

  ///@return {SFXService}
  update = function() {
    static updateSFX = function(sfx, name, volume) {
      sfx.update(volume)
    }

    this.sfxs.forEach(updateSFX, this.volume)
    return this
  }

  ///@return {SFXService}
  free = function() {
    static freeSFX = function(sfx, name) {
      try {
        Logger.debug("SFXService", $"Free SFX \"{name}\".")
        sfx.stop()
      } catch (exception) {
        Logger.error("SFXService", $"Unable to free SFX \"{name}\".")
      }
    }

    this.sfxs.forEach(freeSFX)
    return this
  }
}