///@package io.alkapivo.visu.

///@param {Struct} json
function DamageComponent(json) constructor {

  ///@type {Number}
  damage = Assert.isType(json.damage, Number)
}