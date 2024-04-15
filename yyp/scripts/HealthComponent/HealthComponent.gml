///@package io.alkapivo.visu.

///@param {Struct} json
function HealthComponent(json) constructor {

  ///@type {Number}
  health = Assert.isType(json.health, Number)
}

