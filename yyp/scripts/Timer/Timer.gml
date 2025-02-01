///@package io.alkapivo.core.util

///@param {Number} _duration
///@param {Struct} [config]
function Timer(_duration, config = {}) constructor {

  ///@type {Number}
  duration = Assert.isType(_duration, Number)

  ///@type {Number}
  time = Struct.getIfType(config, "time", Number, 0.0)

  ///@type {Number}
  loopCounter = Struct.getIfType(config, "loopCounter", Number, 0.0)

  ///@type {Boolean}
  finished = Struct.getIfType(config, "finished", Boolean, false)

  ///@type {Number}
  loop = Struct.getIfType(config, "loop", Number, 1.0)

  ///@type {Number}
  amount = Struct.getIfType(config, "amount", Number, FRAME_MS)

  ///@type {?Callable}
  callback = Struct.getIfType(config, "callback", Callable)

  if (Struct.getIfType(config, "shuffle", Boolean, false)) {
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

    this.loopCounter++
    return this
  }

  ///@return {Number}
  getProgress = function() {
    return this.finished ? 1.0 : clamp(this.time / this.duration, 0.0, 1.0)
  }

  ///@param {Number} amount
  ///@return {Timer}
  setAmount = function(amount) {
    this.amount = amount
    return this
  }

  ///@param {Number} duration
  ///@return {Timer}
  setDuration = function(duration) {
    this.duration = duration
    return this
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

  ///@param {Number} duration
  ///@return {Timer}
  changeDuration = function(duration) {
    this.duration = duration
    return this
  }
}
