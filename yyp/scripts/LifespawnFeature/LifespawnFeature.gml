///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json]
///@return {GridItemFeature}
function LifespawnFeature(json = {}) {
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: LifespawnFeature,

    ///@type {Timer}
    timer: new Timer(json.duration),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.lifespawn = this.timer.update().time
      if (this.timer.finished) {
        item.signal("kill")
      }
    },
  }))
}