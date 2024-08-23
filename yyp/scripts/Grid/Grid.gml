///@package io.alkapivo.core.collection

///@param {Number} _width
///@param {Number} _height
///@param {any} [defaultValue]
///@param {Type} [_type]
function Grid(_width, _height, defaultValue = null, _type = any) constructor {

  ///@param {Type}
  type = _type

  ///@type {Number}
  width = Assert.isType(_width, Number)

  ///@type {Number}
  height = Assert.isType(_height, Number)

  ///@type {GMArray}
  container = GMArray.createGMArray(this.height, null)
  for (var row = 0; row < this.height; row++) {
    this.container[row] = GMArray.createGMArray(this.width, defaultValue)
  }

  ///@param {Number} _x
  ///@param {Number} _y
  ///@return {any}
  get = function(_x, _y) {
    return _x < this.width && _y < this.height
      ? this.container[_y][_x]
      : null
  }

  ///@param {Number} _x
  ///@param {Number} _y
  ///@throws {AssertException}
  ///@return {Grid}
  set = function(_x, _y, value) {
    Assert.isType(value, this.type)
    if (_x >= this.width || _y >= this.height) {
      return this
    }

    this.container[_y][_x] = value
    return this
  }


  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Grid}
  forEach = function(callback, acc = null) {
    for (var _y = 0; _y < this.height; _y++) {
      for (var _x = 0; _x < this.width; _x++) {
        callback(this.container[_y][_x], _x, _y, acc)
      }
    }

    return this
  }
}