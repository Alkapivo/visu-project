///@package io.alkapivo.core.service.deltatime

///@static
function _DeltaTime() constructor {
	
  ///@private
	///@type {Number}
  deltaTime = 0
	
  ///@private
	///@type {Number}
  fpsMin = 2
	
  ///@private
	///@type {Number}
	deltaTimePrecision = 1000000.0
	
	///@private
  ///@type {Number}
	deltaTimePrevious = 0.0
	
  ///@private
	///@type {Boolean}
	deltaTimeRestored = false
  
  ///@param {Number} value
  ///@return {Number}
  static apply = function(value) {
    return this.deltaTime * value
  }

  ///@return {Number}
  static get = function() {
    gml_pragma("forceinline")
    return this.deltaTime
  }

  ///@return {DeltaTime}
  static update = function() {
    gml_pragma("forceinline")
    this.deltaTimePrevious = this.deltaTime;
    this.deltaTime = delta_time / this.deltaTimePrecision;
    if (this.deltaTime > 1 / this.fpsMin) {
      if (this.deltaTimeRestored) {
        this.deltaTime = 1 / this.fpsMin;	
      } else {
        this.deltaTime = this.deltaTimePrevious;
        this.deltaTimeRestored = true;
      }
    } else {
      this.deltaTimeRestored = false;	
    }
    this.deltaTime = clamp(this.deltaTime * GAME_FPS, 1.0, 5.0);
    return this
  }
}
global.__DeltaTime = new _DeltaTime()
#macro DeltaTime global.__DeltaTime
