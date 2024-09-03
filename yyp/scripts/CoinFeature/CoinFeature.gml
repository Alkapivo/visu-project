///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function CoinFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  return new GridItemFeature(Struct.append(json, {
    
    ///@param {Callable}
    type: CoinFeature,

    ///@type {String}
    coin: Assert.isType(data.coin, String),

    ///@type {Number}
    offsetX: Core.isType(Struct.get(data, "offsetX"), Number) ? data.offsetX : 0.0,

    ///@type {Number}
    offsetY: Core.isType(Struct.get(data, "offsetY"), Number) ? data.offsetY : 0.0,

    ///@type {Boolean}
    spawned: false,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (this.spawned) {
        return
      }

      controller.coinService.send(new Event("spawn-coin", {
        template: this.coin,
        x: item.x + (this.offsetX / GRID_SERVICE_PIXEL_WIDTH),
        y: item.y + (this.offsetY / GRID_SERVICE_PIXEL_HEIGHT),
      }))
      this.spawned = true
    },
  }))
}