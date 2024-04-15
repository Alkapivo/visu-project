///@package io.alkapivo.core.lang

///@static
function _Vector() constructor {

  ///@param {Struct} json
  ///@param {Vector2|Vector3|Vector4} type
  ///@throws {ParseException}
  ///@return {Vector2|Vector3|Vector4}
  static parse = function(json, type) {
    switch (type) {
      case Vector2:
        return new Vector2(
          Struct.getDefault(json, "x", 0.0), 
          Struct.getDefault(json, "y", 0.0)
        )
      case Vector3:
        return new Vector3(
          Struct.getDefault(json, "x", 0.0), 
          Struct.getDefault(json, "y", 0.0), 
          Struct.getDefault(json, "z", 0.0)
        )
      case Vector4:
        return new Vector4(
          Struct.getDefault(json, "x", 0.0), 
          Struct.getDefault(json, "y", 0.0), 
          Struct.getDefault(json, "z", 0.0), 
          Struct.getDefault(json, "a", 0.0)
        )
      default:
        throw new ParseException()
    }
  }
}
global.__Vector = new _Vector()
#macro Vector global.__Vector


///@param {Number} _x
///@param {Number} _y
function Vector2(_x = 0.0, _y = 0.0) constructor {

  ///@type {Number}
  x = Assert.isType(_x, Number)

  ///@type {Number}
  y = Assert.isType(_y, Number)

  ///@param {Vector2} vec2
  ///@return {Boolean}
  static areEqual = function(vec2) {
      return this.x == vec2.x && this.y == vec2.y
  }

  ///@return {Struct}
  serialize = function() {
    return {
      x: this.x,
      y: this.y,
    }
  }
}


///@param {Number} _x
///@param {Number} _y
///@param {Number} _z
function Vector3(_x = 0.0, _y = 0.0, _z = 0.0): Vector2(_x, _y) constructor {

  ///@type {Number}
  z = Assert.isType(_z, Number)

  ///@return {Struct}
  serialize = function() {
    return {
      x: this.x,
      y: this.y,
      z: this.z,
    }
  }
}


///@param {Number} _x
///@param {Number} _y
///@param {Number} _z
///@param {Number} _a
function Vector4(_x = 0.0, _y = 0.0, _z = 0.0, _a = 0.0): Vector3(_x, _y, _z) constructor {

  ///@type {Number}
  a = Assert.isType(_a, Number)

  ///@return {Struct}
  serialize = function() {
    return {
      x: this.x,
      y: this.y,
      z: this.z,
      a: this.a,
    }
  }
}


///@param {Struct} [json]
function Rectangle(json = {}): Vector4() constructor {

  ///@override
  ///@type {Number}
  x = Assert.isType(Struct.getDefault(json, "x", 0), Number)

  ///@override
  ///@type {Number}
  y = Assert.isType(Struct.getDefault(json, "y", 0), Number)

  ///@override
  ///@type {Number}
  z = Assert.isType(Struct.getDefault(json, "width", 0), Number)

  ///@override
  ///@type {Number}
  a = Assert.isType(Struct.getDefault(json, "height", 0), Number)

  ///@return {Number}
  getX = method(this, function() {
    return this.x
  })

  ///@return {Number}
  getY = method(this, function() {
    return this.y
  })

  ///@return {Number}
  getWidth = method(this, function() {
    return this.z
  })

  ///@return {Number}
  getHeight = method(this, function() {
    return this.a
  })

  ///@param {Number} x
  ///@return {Area}
  setX = method(this, function(x) {
    this.x = x
    return this
  })

  ///@param {Number} y
  ///@return {Area}
  setY = method(this, function(y) {
    this.y = y
    return this
  })

  ///@param {Number} width
  ///@return {Area}
  setWidth = method(this, function(width) {
    this.z = width
    return this
  })

  ///@param {Number} height
  ///@return {Area}
  setHeight = method(this, function(height) {
    this.a = height
    return this
  })

  ///@param {Number} x
  ///@param {Number} y
  ///@return {Boolean}
  collide = method(this, function(x, y) {
    return x >= this.getX() 
      && x <= this.getX() + this.getWidth() 
      && y >= this.getY() 
      && y <= this.getY() + this.getHeight()
  })

  ///@override
  ///@return {Struct}
  serialize = function() {
    return {
      x: this.getX(),
      y: this.getY(),
      width: this.getWidth(),
      height: this.getHeight(),
    }
  }
}


///@param {Number} _width
///@param {Number} _height
function Ellipse(_width, _height) constructor {
    
  ///@type {Number}
  width = _width

  ///@type {Number}
  height = _height
  
  ///@private
  ///@type {Number} angle
  ///@return {Number}
  static fetchRadiusFactor = function(angle) {
    return (this.width * this.height) / sqrt(
        (power(this.width, 2) * power(sin(angle), 2)) + 
        (power(this.height, 2) * power(cos(angle), 2))
    )
  }

  ///@param {Number} angle
  ///@return {Number}
  static fetchX = function(angle) {
    return this.fetchRadiusFactor(angle) * cos(angle)
  }

  ///@param {Number} angle
  ///@return {Number}
  static fetchY = function(angle) {
    return this.fetchRadiusFactor(angle) * sin(angle)
  }

  ///@param {Number} angle
  ///@param {Vector2<Number>} [vec2]
  ///@return {Vector2<Number>}
  static fetchVector2 = function(angle, vec2 = new Vector2()) {
    vec2.x = this.fetchX(angle)
    vec2.y = this.fetchY(angle)
    return vec2
  }
}


///@static
function _Math() constructor {

  ///@param {Number} fromX
  ///@param {Number} fromY
  ///@param {Number} toX
  ///@param {Number} toY
  ///@return {Number}
  fetchAngle = function(fromX, fromY, toX, toY) {
    return point_direction(fromX, fromY, toX, toY)
  }

  ///@param {Number} fromX
  ///@param {Number} fromY
  ///@param {Number} toX
  ///@param {Number} toY
  ///@return {Number}
  fetchLength = function(fromX, fromY, toX, toY) {
    return point_distance(fromX, fromY, toX, toY)
  }

  ///@param {Number} sx1
  ///@param {Number} sy1
  ///@param {Number} sx2
  ///@param {Number} sy2
  ///@param {Number} dx1
  ///@param {Number} dy1
  ///@param {Number} dx2
  ///@param {Number} dy2
  ///@return {Boolean}
  rectangleOverlaps = function(sx1, sy1, sx2, sy2, dx1, dy1, dx2, dy2) {
    return rectangle_in_rectangle(sx1, sy1, sx2, sy2, dx1, dy1, dx2, dy2) > 0
  }

  ///@param {Number} length
  ///@param {Number} angle
  ///@return {Number}
  fetchCircleX = function(length, angle) {
    return lengthdir_x(length, angle)
  }

  ///@param {Number} length
  ///@param {Number} angle
  ///@return {Number}
  fetchCircleY = function(length, angle) {
    return lengthdir_y(length, angle)
  }

  ///@param {Number} source
  ///@param {Number} target
  ///@param {Number} [factor]
  ///@return {Number}
  transformNumber = function(source, target, factor = 1.0) {
    var dir = source < target ? 1 : -1
    var value = source + DeltaTime.apply(factor * dir)
    return dir > 0
      ? clamp(value, source, target)
      : clamp(value, target, source)
  }

  ///@param {Number} number
  ///@return {Number}
  randomNumber = function(number) {
    return random(number)
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@return {Number}
  randomNumberFromRange = function(from, to) {
    return random_range(from, to)
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@return {Number}
  randomInteger = function(number) {
    return irandom(number)
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@return {Number}
  randomIntegerFromRange = function(from, to) {
    return irandom_range(from, to)
  }

  ///@type {Number} a
  ///@type {Number} b
  ///@type {Number} [epsilon]
  areNumbersEqual = function(a, b, epsilon = 0.0) {
    return a >= b - epsilon && a <= b + epsilon
  }
}
global.__Math = new _Math()
#macro Math global.__Math