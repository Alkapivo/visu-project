///@package io.alkapivo.visu.

///@param {Struct} json
function VelocityComponent(json) constructor {
  
  ///@type {Number}
  angle = Assert.isType(json.angle, Number)
  
  ///@type {Number}
  speed = Assert.isType(json.speed, Number)
}
