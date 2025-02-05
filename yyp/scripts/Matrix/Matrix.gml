///@package io.alkapivo.renderer

#macro GMMatrix "GMMatrix"


///@enum
function _MatrixType(): Enum() constructor {
  VIEW = matrix_view
  PROJECTION = matrix_projection
  WORLD = matrix_world
}
global.__MatrixType = new _MatrixType()
#macro MatrixType global.__MatrixType


///@static
function _MatrixUtil() constructor {

  ///@param {MatrixType} type
  ///@return {GMMatrix}
  get = function(type) {
    return matrix_get(type)
  }

  ///@param {MatrixType} type
  ///@param {GMMatrix} matrix
  set = function(type, matrix) {
    matrix_set(type, matrix)
    return this
  }

  ///@param {GMMatrix} a
  ///@param {GMMatrix} b
  ///@return {GMMatrix}
  multiply = function(a, b) {
    return matrix_multiply(a, b)
  }

  ///@param {GMMatrix} matrix
  ///@param {Vector3} vec3
  ///@param {Boolean} [factoryVector]
  ///@return {Vector3}
  transformVertex = function(matrix, vec3, factoryVector = false) {
    var array = matrix_transform_vertex(matrix, vec3.x, vec3.y, vec3.z)
    if (factoryVector) {
      return new Vector3(array[0], array[1], array[2])
    }

    vec3.x = array[0]
    vec3.y = array[1]
    vec3.z = array[2]

    return vec3
  }

  ///@param {Number} [x]
  ///@param {Number} [y]
  ///@param {Number} [z]
  ///@param {Number} [xRotation]
  ///@param {Number} [yRotation]
  ///@param {Number} [zRotation]
  ///@param {Number} [xScale]
  ///@param {Number} [yScale]
  ///@param {Number} [zScale]
  ///@return {GMMatrix}
  build = function(x = 0.0, y = 0.0, z = 0.0, xRotation = 0.0, yRotation = 0.0, zRotation = 0.0, xScale = 0.0, yScale = 0.0, zScale = 0.0) {
    return matrix_build(x, y, z, xRotation, yRotation, zRotation, xScale, yScale, zScale)
  }

  ///@return {GMMatrix}
  buildId = function() {
    return matrix_build_identity()
  }

  ///@param {Number} [xFrom]
  ///@param {Number} [yFrom]
  ///@param {Number} [zFrom]
  ///@param {Number} [xTo]
  ///@param {Number} [yTo]
  ///@param {Number} [zTo]
  ///@param {Number} [xUp]
  ///@param {Number} [yUp]
  ///@param {Number} [zUp]
  ///@return {GMMatrix}
  buildLookAt = function(xFrom = 0.0, yFrom = 0.0, zFrom = 0.0, xTo = 0.0, yTo = 0.0, zTo = 0.0, xUp = 0.0, yUp = 0.0, zUp = 0.0) {
    return matrix_build_lookat(xFrom, yFrom, zFrom, xTo, yTo, zTo, xUp, yUp, zUp)
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@param {Number} [zNear]
  ///@param {Number} [zFar]
  ///@return {GMMatrix}
  buildProjectionOrtho = function(width, height, zNear = 1.0, zFar = 32000.0) {
    return matrix_build_projection_ortho(width, height, zNear, zFar)
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@param {Number} [zNear]
  ///@param {Number} [zFar]
  ///@return {GMMatrix}
  buildProjectionPerspective = function(width, height, zNear = 1.0, zFar = 32000.0) {
    return matrix_build_projection_perspective(width, height, zNear, zFar)
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@param {Number} [zNear]
  ///@param {Number} [zFar]
  ///@return {GMMatrix}
  buildProjectionPerspectiveFOV = function(width, height, zNear = 1.0, zFar = 32000.0) {
    return matrix_build_projection_perspective_fov(width, height, zNear, zFar)
  }
}
