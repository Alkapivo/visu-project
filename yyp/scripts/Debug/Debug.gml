///@package io.alkapivo.core.util

///@param {String} _name
///@param {Number} [_size]
function DebugTimer(_name, _size = 60) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Number}
  value = 0.0

  ///@type {Number}
  maxSize = Assert.isType(_size, Number)

  ///@private
  ///@type {Number}
  a = 0.0

  ///@private
  ///@type {Number}
  b = 0.0

  ///@private
  ///@type {Number}
  size = 0.0

  ///@return {DebugTimer}
  start = function() {
    this.a = get_timer()
    if (this.size > this.maxSize) {
      this.size = 0
      this.value = 0
    }

    return this
  }

  ///@return {DebugTimer}
  finish = function() {
    this.b = get_timer()
    this.size = this.size + 1
    this.value = this.value + ((this.b - this.a) / 1000)
    return this
  }

  ///@return {Number} time in ms (there are 1000 miliseconds per second)
  getValue = function() {
    return this.size > 0 ? this.value / this.size : 0.0
  }

  ///@return {String}
  getMessage = function() {
    return $"{this.name} avg: {string_format(this.getValue(), 1, 4)} ms"
  }
}


/** Example:
 * new DebugNumericKeyboardValue({
    name: "debugLine",
    value: -10,
    factor: 1,
    keyIncrement: ord("T"),
    keyDecrement: ord("Y"),
    pressed: true,
  })
 */
///@param {Struct} config
function DebugNumericKeyboardValue(config) constructor {

  ///@type {String}
  name = Assert.isType(config.name, String)

  ///@type {Number}
  value = Assert.isType(config.value, Number)

  ///@type {Number}
  factor = Core.isType(Struct.get(config, "factor"), Number) ? config.factor : 1

  ///@type {?Number}
  minValue = Core.isType(Struct.get(config, "minValue"), Number) ? config.minValue : null

  ///@type {?Number}
  maxValue = Core.isType(Struct.get(config, "maxValue"), Number) ? config.maxValue : null

  ///@type {Number}
  keyIncrement = Assert.isType(config.keyIncrement, Number)

  ///@type {Number}
  keyDecrement = Assert.isType(config.keyDecrement, Number)

  ///@type {Boolean}
  pressed = Core.isType(Struct.get(config, "pressed"), Boolean) ? config.pressed : false

  ///@return {DebugNumericKeyboardValue}
  update = function() {
    var keyFunction = this.pressed ? keyboard_check_pressed : keyboard_check
    if (keyFunction(this.keyIncrement)) {
      this.value = this.value + this.factor
      if (Optional.is(this.minValue) && this.value < this.minValue) {
        this.value = this.minValue
      }
      if (Optional.is(this.maxValue) && this.value > this.maxValue) {
        this.value = this.maxValue
      }

      Logger.debug(this.name, $"Increment: {this.value}")
    }

    if (keyFunction(this.keyDecrement)) {
      this.value = this.value - this.factor
      if (Optional.is(this.minValue) && this.value < this.minValue) {
        this.value = this.minValue
      }
      if (Optional.is(this.maxValue) && this.value > this.maxValue) {
        this.value = this.maxValue
      }

      Logger.debug(this.name, $"Decrement: {this.value}")
    }

    return this
  }
}
