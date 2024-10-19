///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function CoinFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray.resolveRandom)

  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: CoinFeature,

    ///@type {String}
    coin: Assert.isType(data.coin, String),

    ///@type {Number}
    offsetX: Struct.getIfType(data, "offsetX", Number, 0.0),

    ///@type {Number}
    offsetY: Struct.getIfType(data, "offsetY", Number, 0.0),

    ///@type {Number}
    amount: clamp(toInt(Struct.getIfType(data, "amount", Number, 1)), 1, 99),

    ///@type {Number}
    luck: clamp(Struct.getIfType(data, "luck", Number, 1.0), 0.0, 1.0),

    ///@type {Boolean}
    spawned: false,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (this.spawned) {
        return
      }

      this.spawned = true
      for (var index = 0; index < this.amount; index++) {
        if (random(1.0) > this.luck) {
          continue
        }

        var verticalOffset = choose(1.0, -1.0)
          * (((item.sprite.getWidth() * item.sprite.getScaleX()) / 2.0)
          / GRID_SERVICE_PIXEL_WIDTH)
        controller.coinService.send(new Event("spawn-coin", {
          template: this.coin,
          x: item.x + verticalOffset + (this.offsetX / GRID_SERVICE_PIXEL_WIDTH),
          y: item.y + (this.offsetY / GRID_SERVICE_PIXEL_HEIGHT),
        }))
      }
    },
  }))
}