///@package io.alkapivo.core.service.display

///@param {Struct} json
function Display(json) constructor {

  ///@type {Number}
  width = Assert.isType(Struct.getDefault(json, "width", 1), Number)
  Assert.isTrue(this.width >= 1)

  ///@type {Number}
  height = Assert.isType(Struct.getDefault(json, "height", 1), Number)
  Assert.isTrue(this.height >= 1)

  ///@type {?Callable}
  healthcheck = Struct.contains(json, "healthcheck")
    ? method(this, Assert.isType(json.healthcheck, Callable))
    : null

  ///@return {Number}
  static getWidth = function() {
    return this.width
  }

  ///@param {Number} width
  ///@return {Display}
  static setWidth = function(width) {
    Assert.isTrue(this.width >= 1)
    this.width = Assert.isType(width, Number)
    return this
  }

  ///@return {Number}
  static getHeight = function() {
    return this.height
  }

  ///@return {Number}
  static setHeight = function(height) {
    Assert.isTrue(this.height >= 1)
    this.height = Assert.isType(height, Number)
    return this
  }

  ///@return {Display}
  static update = function() {
    if (Optional.is(this.healthcheck)) {
      this.healthcheck()
    }

    return this
  }
}

