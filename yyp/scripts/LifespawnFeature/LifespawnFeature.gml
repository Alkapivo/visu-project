///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json]
///@return {GridItemFeature}
function LifespawnFeature(json = {}) {
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: LifespawnFeature,

    ///@type {Timer}
    lifespawnTimer: new Timer(json.duration),

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