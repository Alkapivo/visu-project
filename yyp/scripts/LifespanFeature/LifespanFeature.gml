///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function LifespanFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: LifespanFeature,

    ///@type {Timer}
    lifespanTimer: new Timer(data.duration),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.lifespan = this.lifespanTimer.update().time
      if (this.lifespanTimer.finished) {
        item.signal("kill")
      }
    },
  }))
}