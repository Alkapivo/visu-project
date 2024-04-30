///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json]
///@return {GridItemFeature}
function SwingFeature(json = {}) {

  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SwingFeature,

    ///@type {Struct}
    swingTimer: new Timer(pi * 2, { loop: Infinity, amount: Struct.getDefault(json, "amount", 1) * FRAME_MS }),

    ///@type {Number}
    size: Struct.getDefault(json, "size", 1),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.angle = item.angle + (cos(this.swingTimer.update().time) * this.size)
    },
  }))
}