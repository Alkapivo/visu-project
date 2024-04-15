///@package io.alkapivo.core.service.deltatime

#macro BeanDeltaTimeService "DeltaTimeService"
function DeltaTimeService(): Service() constructor {

  ///@return {Number}
  get = function() { 
    return DeltaTime.get()
  }

  ///@param {Number} value
  ///@return {Number}
  apply = function(value) {
    return DeltaTime.apply(value)
  }

  ///@override
  ///@return {DeltaTimeService}
  updateBegin = function() {
    DeltaTime.update()
    return this
  }
}
