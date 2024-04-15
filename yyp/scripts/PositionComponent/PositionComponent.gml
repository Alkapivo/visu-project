///@package io.alkapivo.visu.

///@param {Struct} json
function PositionComponent(json) constructor {

  ///@type {Number}
  x = Assert.isType(json.x, Number)
  
  ///@type {Number}
  y = Assert.isType(json.y, Number)
}
