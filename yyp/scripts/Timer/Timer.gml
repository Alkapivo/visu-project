///@package io.alkapivo.core.util

///@param {Number} _duration
///@param {Struct} [config]
function Timer(_duration, config = {}) constructor {

  ///@type {Number}
  time = 0

  ///@type {Number}
  duration = Assert.isType(_duration, Number)

  ///@type {Number}
  loopCounter = Assert.isType(Struct.getDefault(config, "loopCounter", 0), Number)

  ///@type {Boolean}
  finished = Assert.isType(Struct.getDefault(config, "finished", false), Boolean)

  ///@type {Number}
  loop = Assert.isType(Struct.getDefault(config, "loop", 1), Number)

  ///@type {Number}
  amount = Assert.isType(Struct.getDefault(config, "amount", FRAME_MS), Number)

  ///@type {?Callable}
  callback = Struct.get(config, "callback") != null
    ? Assert.isType(config.callback, Callable)
    : null

  if (Struct.getDefault(config, "shuffle", false)) {
    this.time = random(this.duration)
  }

  ///@param {any} [callbackData]
  ///@return {Timer}
  update = function(callbackData = null) {
    if (this.finished && (this.loop == Infinity || this.loopCounter < this.loop)) {
      this.finished = false
    } else if (this.finished) {
      return this
    }

    this.time += DeltaTime.apply(this.amount)
    if (this.amount > 0) {
      if (this.time < this.duration) {
        return this
      }

      this.time = this.time - (floor(this.time / this.duration) * this.duration)
      this.finished = true
    } else {
      if (this.time > 0) {
        return this
      }

      this.time = this.duration + (this.time - (floor(this.time / this.duration) * this.duration))
      this.finished = true
    }

    if (this.callback) {
      this.callback(callbackData, this)
    }

    if (this.loop != Infinity) {
      this.loopCounter++
    }
    
    return this
  }

  ///@return {Number}
  getProgress = function() {
    return this.finished ? 1.0 : clamp(this.time / this.duration, 0.0, 1.0)
  }

  ///@return {Timer}
  reset = function() {
    this.time = 0
    this.loopCounter = 0
    this.finished = false
    return this
  }

  ///@return {Struct}
  serialize = function() {
    return {
      time: this.time,
      loopCounter: this.loopCounter,
      finished: this.finished,
      duration: this.duration,
      loop: this.loop,
      amount: this.amount,
    }
  }

  ///@return {Timer}
  finish = function() {
    this.time = this.amount > 0 ? this.duration : 0.0
    return this
  }
}