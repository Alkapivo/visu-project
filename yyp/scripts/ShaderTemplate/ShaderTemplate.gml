///@package io.alkapivo.core.renderer.shader

///@param {String} _name
///@param {Struct} json
function ShaderTemplate(_name, json) constructor {

  ///@type {?String}
  name = Assert.isType(_name, String)

  ///@type {?String}
  inherit = Struct.contains(json, "inherit")
    ? Assert.isType(json.inherit, String)
    : null

  ///@type {String}
  shader = Assert.isType(json.shader, String)
  if (Core.getRuntimeType() != RuntimeType.GXGAMES) {
    Assert.isType(ShaderUtil.fetch(this.shader), Shader)
  } else {
    this.shader = this.shader == "shader_art" ? "shader_art_wasm" : this.shader
  }

  ///@type {?String}
  //type = Struct.contains(json, "type") 
  //  ? Assert.isType(json.type, String) 
  //  : null

  ///@type {?Struct}
  properties = Struct.contains(json, "properties")
    ? Assert.isType(json.properties, Struct)
    : null

  ///@description remove nullable fields
  if (!Optional.is(this.inherit)) {
    Struct.remove(this, "inherit")
  }
  //if (!Optional.is(this.type)) {
  //  Struct.remove(this, "type")
  //}
  if (!Optional.is(this.properties)) {
    Struct.remove(this, "properties")
  }

  ///@return {Struct}
  serialize = function() {
    var json = {
      name: this.name,
      shader: this.shader,
    }
    
    if (Optional.is(Struct.get(this, "inherit"))) {
      Struct.set(json, "inherit", this.inherit)
    }

    if (Optional.is(Struct.get(this, "properties"))) {
      Struct.set(json, "properties", this.properties)
    }

    return JSON.clone(json)
  }
}
