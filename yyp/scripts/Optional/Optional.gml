///@package io.alkapivo.core.lang.type

///@param {Prototype} prototype
function OptionalType(prototype) constructor {  

  ///@type {Prototype}
  type = prototype
}


///@static
function _Optional() constructor {
  
  ///@param {Prototype}
  ///@return {OptionalType}
  static of = function(prototype) {
    gml_pragma("forceinline")
    return new OptionalType(prototype)
  }

  ///@param {any} object
  ///@param {Type} [type]
  ///@return {Boolean}
  static is = function(object, type = null) {
    gml_pragma("forceinline")
    return object != null 
      ? (type != null ? Core.isType(object, type) : true) 
      : false
  }
}
global.__Optional = new _Optional()
#macro Optional global.__Optional
