///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json]
///@return {GridItemFeature}
function SpriteFeature(json = {}) {
  var sprite = Assert.isType(SpriteUtil.parse(json.sprite), Sprite)
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SpriteFeature,

    ///@type {Sprite}
    sprite: sprite,

    ///@type {Rectangle}
    mask: new Rectangle(Optional.is(Struct.get(json, "mask")) 
      ? json.mask
      : { 
        x: 0, 
        y: 0, 
        width: sprite.getWidth(), 
        height: sprite.getHeight()
      }),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.setSprite(this.sprite)
      item.setMask(this.mask)
    },
  }))
}