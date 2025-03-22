///@package io.alkapivo.core.service.deltatime

#macro BeanDeltaTimeService "DeltaTimeService"
function DeltaTimeService() constructor {

  ///@return {Number}
  static get = function() { 
    return DeltaTime.get()
  }

  ///@param {Number} value
  ///@return {Number}
  static apply = function(value) {
    gml_pragma("forceinline")
    return DeltaTime.apply(value)
  }

  ///@override
  ///@return {DeltaTimeService}
  static updateBegin = function() {
    gml_pragma("forceinline")
    DeltaTime.update()
    return this
  }
}
