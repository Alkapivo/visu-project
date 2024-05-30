///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function SwingFeature(json) {
  var data = Struct.get(json, "data")
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SwingFeature,

    ///@type {Struct}
    swingTimer: new Timer(pi * 2, { 
      loop: Infinity, 
      amount: FRAME_MS * (Core.isType(Struct.get(data, "amount"), Number) 
        ? data.amount : 1.0),
    }),

    ///@type {Number}
    size: Core.isType(Struct.get(data, "size"), Number) ? data.size : 1.0,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      item.angle = item.angle + (cos(this.swingTimer.update().time) * this.size)
    },
  }))
}