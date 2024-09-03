///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function ShootFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: ShootFeature,

    ///@type {String}
    bullet: Assert.isType(data.bullet, String),

    ///@type {?Number}
    bullets: Core.isType(Struct.get(data, "bullets"), Number) ? data.bullets : null,

    ///@type {Number}
    speed: Core.isType(Struct.get(data, "speed"), Number) ? data.speed : 20.0,

    ///@private
    ///@type {Timer}
    cooldown: new Timer(
      Core.isType(Struct.get(data, "interval"), Number) ? data.interval : 0.0,
      { loop: Core.isType(Struct.get(data, "bullets"), Number) ? data.bullets + 1 : Infinity }
    ),

    ///@private
    ///@type {Number}
    angle: Core.isType(Struct.get(data, "angle"), Number) ? data.angle : 0.0,

    ///@type {Boolean}
    targetPlayer: Core.isType(Struct.get(data, "targetPlayer"), Boolean) ? data.targetPlayer : false,

    ///@type {Number}
    randomRange: Core.isType(Struct.get(data, "randomRange"), Number) ? data.randomRange : 0,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (!this.cooldown.update().finished 
        || this.cooldown.loop == this.cooldown.loopCounter) {
        return
      }

      var randomAngle = random(this.randomRange) * choose(1, -1)
      var angle = item.angle + this.angle + randomAngle
      if (this.targetPlayer) {
        var player = Beans.get(BeanVisuController).playerService.player
        if (Core.isType(player, Player)) {
          angle = Math.fetchAngle(item.x, item.y, player.x, player.y) 
            + randomAngle
        }
      }

      controller.bulletService.send(new Event("spawn-bullet", {
        x: item.x,
        y: item.y,
        angle: angle,
        speed: this.speed,
        producer: Shroom,
        template: this.bullet,
      }))
    },
  }))
}