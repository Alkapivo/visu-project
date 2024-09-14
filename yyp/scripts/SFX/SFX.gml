///@package io.alkapivo.core.service.sound.sfx

///@param {Sound} _sound
function SFXContext(_sound) constructor {

  ///@type {Boolean}
  loaded = false

  ///@type {Sound}
  sound = Assert.isType(_sound, Sound)

  ///@param {Number} [volume]
  ///@return {SFXContext}
  play = function(volume = 1.0) {
    if (this.loaded) {
      return this
    }
    
    this.sound.play(volume)
    this.loaded = true
    return this
  }

  ///@return {Boolean}
  finished = function() {
    return this.loaded && !this.sound.isLoaded()
  }
}


///@param {String} _name
///@param {?Number} [_limit]
function SFX(_name, _limit = null) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {?Number}
  limit = Core.isType(_limit, Number) ? _limit : null

  ///@private
  ///@type {Queue<SFXContext>}
  queue = new Queue(SFXContext)

  ///@private
  ///@type {Stack<Number>}
  gc = new Stack(Number)

  ///@private
  ///@type {Struct}
  acc = {
    volume: 1.0,
    gc: this.gc,
  }

  ///@private
  dispatched = false

  ///@return {SFX}
  static play = function() {
    if (this.dispatched) {
      return
    }

    if (Optional.is(this.limit) && this.queue.size() >= this.limit) {
      this.queue.pop().sound.stop()
    }

    var sound = SoundUtil.fetch(this.name)
    if (Core.isType(sound, Sound)) {
      this.queue.push(new SFXContext(sound))
      this.dispatched = true
    }

    return this
  }

  ///@return {SFX}
  static pause = function() {
    static pauseSFXContext = function(sfxContext) {
      sfxContext.sound.pause()
    }

    this.queue.container.forEach(pauseSFXContext)
    return this
  }

  ///@return {SFX}
  static resume = function() {
    static resumeSFXContext = function(sfxContext) {
      sfxContext.sound.resume()
    }

    this.queue.container.forEach(resumeSFXContext)
    return this
  }

  ///@return {SFX}
  static stop = function() {
    static stopSFXContext = function(sfxContext) {
      sfxContext.sound.stop()
    }

    this.queue.forEach(stopSFXContext)
    return this
  }

  ///@param {Number} volume
  ///@return {SFX}
  static update = function(volume) {
    static updateSFX = function(sfxContext, index, acc) {
      if (sfxContext.finished()) {
        acc.gc.push(index)
        return
      }

      if (!sfxContext.loaded) {
        sfxContext.play(acc.volume)
      } else if (sfxContext.sound.getVolume() != acc.volume) {
        sfxContext.sound.setVolume(acc.volume)
      }
    }

    this.dispatched = false
    this.acc.volume = volume
    this.queue.container.forEach(updateSFX, this.acc)

    if (this.gc.size() > 0) {
      this.queue.container.removeMany(this.gc)
    }
    
    return this
  }
}