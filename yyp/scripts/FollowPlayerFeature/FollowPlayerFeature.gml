///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function FollowPlayerFeature(json = {}) {
  var data = Assert.isType(Struct.get(json, "data"), Struct)
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: FollowPlayerFeature,

    ///@type {NumberTransformer}
    value: new NumberTransformer(data.value),


    ///@type {NumberTransformer}
    transformer: new NumberTransformer(),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      var player = controller.playerService.player
      if (!Optional.is(player)) {
        return
      }

      this.transformer.value = 0
      this.transformer.finished = false
      this.transformer.target = angle_difference(item.angle, Math.fetchAngle(item.x, item.y, player.x, player.y))
      this.transformer.factor = abs(this.value.factor) * sign(this.transformer.target)
      item.setAngle(item.angle - this.transformer.update().value)
    },
  }))
}