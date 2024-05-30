///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function ShootFeature(json) {
  var data = Assert.isType(Struct.get(json, "data"), Struct)
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: ShootFeature,

    ///@type {String}
    bullet: Assert.isType(data.bullet, String),

    ///@type {?Number}
    bullets: Core.isType(Struct.get(data, "bullets"), Number) ? data.bullets : null,

    ///@type {Number}
    speed: Core.isType(Struct.get(data, "speed"), Number) ? data.speed : 20.0,

    ///@type {Number}
    interval: Core.isType(Struct.get(data, "interval"), Number) ? data.interval : 1.0,

    ///@private
    ///@type {Timer}
    cooldown: new Timer(
      Core.isType(Struct.get(data, "interval"), Number) ? data.interval : 1.0,
      { loop: Core.isType(Struct.get(data, "bullets"), Number) ? data.bullets : Infinity }
    ),

    ///@private
    ///@type {Number}
    angle: Core.isType(Struct.get(data, "angle"), Number) ? data.angle : 0.0,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (!this.cooldown.update().finished 
        || this.cooldown.loop == this.cooldown.loopCounter) {
        return
      }

      controller.bulletService.send(new Event("spawn-bullet", {
        x: item.x,
        y: item.y,
        angle: item.angle + this.angle,
        speed: this.speed,
        producer: Shroom,
        template: this.bullet,
      }))
    },
  }))
}