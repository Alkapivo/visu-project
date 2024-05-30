///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function LifespawnFeature(json) {
  var data = Assert.isType(Struct.get(json, "data"), Struct)
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: LifespawnFeature,

    ///@type {Timer}
    lifespawnTimer: new Timer(data.duration),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.lifespawn = this.lifespawnTimer.update().time
      if (this.lifespawnTimer.finished) {
        item.signal("kill")
      }
    },
  }))
}