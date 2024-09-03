///@package io.alkapivo.visu.service.coin

function CoinService(config = {}): Service() constructor {

  ///@type {Array<Coin>}
  coins = new Array(Coin)

  ///@type {Map<String, CoinTemplate>}
  templates = new Map(String, CoinTemplate)
  
  ///@type {Stack<Number>}
  gc = new Stack(Number)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-coin": function(event) {
      var template = new CoinTemplate(event.data.template, this.templates
        .get(event.data.template)
        .serialize())
      Struct.set(template, "x", Assert.isType(event.data.x, Number))
      Struct.set(template, "y", Assert.isType(event.data.y, Number))
      
      this.coins.add(new Coin(template))
    },
    "clear-coins": function(event) {
      this.coins.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear().set("coin-default", new CoinTemplate("coin-default", {
        "sprite": { "name": "texture_baron" },
        "category": CoinCategory.POINT,
      }))
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }
  
  ///@private
  ///@param {Coin} coin
  ///@param {Number} index
  ///@param {Struct} acc
  updateCoin = function(coin, index, acc) {
    coin.move()
    if (acc.player != null && coin.collide(acc.player)) {
      acc.player.stats.dispatchCoin(coin)
      acc.gc.push(index)
    } else {
      var view = acc.view
      var length = Math.fetchLength(
        coin.x, coin.y,
        view.x + (view.width / 2.0), 
        view.y + (view.height / 2.0)
      )

      if (length > GRID_ITEM_FRUSTUM_RANGE) {
        acc.gc.push(index)
      }
    }
  }
  
  ///@override
  ///@return {CoinService}
  update = function() { 
    this.dispatcher.update()

    var controller = Beans.get(BeanVisuController)
    this.coins.forEach(this.updateCoin, {
      player: controller.playerService.player,
      gc: this.gc,
      view: controller.gridService.view,
    })

    if (this.gc.size() > 0) {
      this.coins.removeMany(this.gc)
    }
    return this
  } 
}