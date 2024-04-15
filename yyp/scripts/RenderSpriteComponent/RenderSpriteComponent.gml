///@package io.alkapivo.visu.

///@param {Struct} json
function RenderSpriteComponent(json) constructor {

  ///@type {Sprite}
  sprite = Assert.isType(SpriteUtil.parse(json), Sprite)
}