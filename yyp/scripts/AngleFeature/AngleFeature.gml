///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json]
///@return {GridItemFeature}
function AngleFeature(json = {}) {
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: AngleFeature,

    ///@type {?NumberTransformer}
    transform: Struct.contains(json, "transform")
      ? new NumberTransformer(json.transform)
      : null,

    add: Struct.contains(json, "add")
      ? new NumberTransformer({
        value: 0.0,
        factor: Struct.getDefault(json.add, "factor", 1.0),
        target: Struct.getDefault(json.add, "target", 1.0),
        increase: Struct.getDefault(json.add, "increase", 0.0),
      })
      : null,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (Optional.is(this.transform)) {
        item.setAngle(this.transform.update().value)
      }

      if (Optional.is(this.add)) {
        item.setAngle(item.angle + this.add.update().value)
      }
    },
  }))
}