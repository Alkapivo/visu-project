///@package io.alkapivo.core.lang

///@static
function _Global() constructor {

  ///@param {?String} name
  ///@param {any} [defaultValue]
  ///@return {any}
  static get = function(name, defaultValue = null) {
    gml_pragma("forceinline")
    return Global.exists(name) ? variable_global_get(name) : defaultValue
  }

  ///@param {?String} name
  ///@param {any} value
  ///@return {Global}
  static set = function(name, value) {
    gml_pragma("forceinline")
    if (Global.exists(name)) {
      variable_global_set(name, value)
    }
    
    return this
  }

  ///@param {?String} name
  ///@param {any} [defaultValue]
  ///@return {any}
  static inject = function(name, defaultValue) {
    gml_pragma("forceinline")
    if (!Global.exists(name)) {
      Global.set(name, defaultValue)
    }

    return this.get(name, defaultValue)
  }

  ///@param {?String} name
  ///@return {Boolean}
  static exists = function(name) {
    gml_pragma("forceinline")
    return Core.isType(name, String) && variable_global_exists(name)
  }
}
global.__Global = new _Global()
#macro Global global.__Global
