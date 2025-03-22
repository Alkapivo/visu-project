///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function ShootFeature(json) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)

  var amount = Core.isType(Struct.get(data, "amount"), Number) ? data.amount : 1.0,
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
    amount: amount,

    ///@private
    ///@type {Number}
    angle: Core.isType(Struct.get(data, "angle"), Number) ? data.angle : 0.0,

    ///@private
    ///@type {Number}
    angleStep: Core.isType(Struct.get(data, "angleStep"), Number) ? data.angleStep : (360.0 / amount),

    ///@type {Boolean}
    targetPlayer: Core.isType(Struct.get(data, "targetPlayer"), Boolean) ? data.targetPlayer : false,

    ///@type {Number}
    randomAngle: Core.isType(Struct.get(data, "randomRange"), Number) ? data.randomRange : 0.0,

    ///@type {Number}
    randomSpeed: Core.isType(Struct.get(data, "randomSpeed"), Number) ? data.randomSpeed : 0.0,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (!this.cooldown.update().finished 
        || this.cooldown.loop == this.cooldown.loopCounter) {
        return
      }

      var angle = item.angle + this.angle
      if (this.targetPlayer) {
        var player = Beans.get(BeanVisuController).playerService.player
        if (Core.isType(player, Player)) {
          angle = Math.fetchPointsAngle(item.x, item.y, player.x, player.y) 
            + this.angle
        }
      }

      for (var index = 0; index < amount; index++) {
        controller.bulletService.spawnBullet(
          this.bullet, 
          item.x, 
          item.y,
          angle + (index * this.angleStep) + (random(this.randomAngle) * choose(1, -1)),
          this.speed + (random(this.randomSpeed) * choose(1, -1)),
          Shroom
        )

        //controller.bulletService.send(new Event("spawn-bullet", {
        //  x: item.x,
        //  y: item.y,
        //  angle: angle 
        //    + (index * this.angleStep) 
        //    + (random(this.randomAngle) * choose(1, -1)),
        //  speed: this.speed
        //    + (random(this.randomSpeed) * choose(1, -1)),
        //  producer: Shroom,
        //  template: this.bullet,
        //}))
      }
    },
  }))
}