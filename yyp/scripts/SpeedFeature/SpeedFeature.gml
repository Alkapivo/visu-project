///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function SpeedFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  if (Struct.contains(data, "transform")) {
    data.transform = Struct.map(data.transform, GMArray.resolveRandom)
  }

  if (Struct.contains(data, "add")) {
    data.add = Struct.map(data.add, GMArray.resolveRandom)
  }
  
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SpeedFeature,

    ///@type {?Number}
    initTransformValue: Struct.get(Struct.get(data, "transform"), "value"),

    ///@type {?NumberTransformer}
    transform: Struct.contains(data, "transform")
      ? new NumberTransformer(data.transform)
      : null,

    ///@type {?NumberTransformer}
    add: Struct.contains(data, "add")
      ? new NumberTransformer(data.add)
      : null,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (this.transform != null) {
        if (this.initTransformValue == null) {
          this.transform.value = item.speed * 1000.0
          this.transform.startValue = this.transform.value
          this.initTransformValue = this.transform.value
        }
        item.setSpeed(this.transform.update().value / 1000.0)
      }

      if (this.add != null) {
        item.setSpeed(item.speed + (this.add.update().value / 1000.0))
      }
    },
  }))
}