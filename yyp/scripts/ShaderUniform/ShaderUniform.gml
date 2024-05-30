///@package io.alkapivo.core.renderer.shader

#macro GMShaderUniform "GMShaderUniform"

///@enum
function _ShaderUniformType(): Enum() constructor {
  COLOR = ShaderUniformColor
  FLOAT = ShaderUniformFloat
  VECTOR2 = ShaderUniformVector2
  VECTOR3 = ShaderUniformVector3
  VECTOR4 = ShaderUniformVector4
  RESOLUTION = ShaderUniformResolution
}
global.__ShaderUniformType = new _ShaderUniformType()
#macro ShaderUniformType global.__ShaderUniformType


///@interface
///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniform(_asset, _name, _type) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {ShaderUniformType}
  type = Assert.isEnumKey(_type, ShaderUniformType)

  ///@type {GMShaderUniform}
  asset = Assert.isType(shader_get_uniform(_asset, this.name), GMShaderUniform)

  ///@param {any} value
  static set = function(value) { }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformColor(_asset, _name, _type = ShaderUniformType.COLOR): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Color} color
  static set = function(color) {
    shader_set_uniform_f(this.asset, color.red, color.green, color.blue, color.alpha)
  }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformFloat(_asset, _name, _type = ShaderUniformType.FLOAT): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Number} value
  static set = function(value) {
    shader_set_uniform_f(this.asset, value)
  }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformVector2(_asset, _name, _type = ShaderUniformType.VECTOR2): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Vector2} vec2
  static set = function(vec2) {
    shader_set_uniform_f(this.asset, vec2.x, vec2.y)
  }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformVector3(_asset, _name, _type = ShaderUniformType.VECTOR3): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Vector3} vec3
  static set = function(vec3) {
    shader_set_uniform_f(this.asset, vec3.x, vec3.y, vec3.z)
  }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformVector4(_asset, _name, _type = ShaderUniformType.VECTOR4): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Vector4} vec4
  static set = function(vec4) {
    shader_set_uniform_f(this.asset, vec4.x, vec4.y, vec4.z, vec4.a)
  }
}


///@param {GMShader} _asset
///@param {String} _name
///@param {ShaderUniformType} _type
function ShaderUniformResolution(_asset, _name, _type = ShaderUniformType.RESOLUTION): ShaderUniform(_asset, _name, _type) constructor {

  ///@override
  ///@param {Vector2} vec2
  static set = function(vec2) {
    shader_set_uniform_f(this.asset, vec2.x, vec2.y)
  }
}
