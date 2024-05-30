///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function SpeedFeature(json) {
  var data = Struct.get(json, "data")
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SpeedFeature,

    ///@type {?NumberTransformer}
    transform: Struct.contains(data, "transform")
      ? new NumberTransformer(data.transform)
      : null,

    add: Struct.contains(data, "add")
      ? new NumberTransformer(data.add)
      : null,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (this.transform != null) {
        item.setSpeed(this.transform.update().value)
      }

      if (this.add != null) {
        item.setSpeed(item.speed + this.add.update().value)
      }
    },
  }))
}