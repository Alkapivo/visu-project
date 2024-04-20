///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function ShootFeature(json) {
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: ShootFeature,

    ///@type {String}
    bullet: Assert.isType(json.bullet, String),

    ///@type {?Number}
    bullets: Struct.contains(json, "bullets")
      ? Assert.isType(json.bullets, Number)
      : null,

    ///@type {Number}
    speed: Assert.isType(Struct
      .getDefault(json, "speed", 20.0), Number),

    ///@type {Number}
    interval: Assert.isType(Struct
      .getDefault(json, "interval", 1.0), Number),

    ///@private
    ///@type {Timer}
    timer: new Timer(Struct.getDefault(json, "interval", 1.0), { 
      loop: Struct.contains(json, "bullets") ? json.bullets : Infinity 
    }),

    ///@private
    ///@type {Number}
    angle: Assert.isType(Struct.getDefault(json, "angle", 0.0), Number),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (!this.timer.update().finished || this.timer.loop == this.timer.loopCounter) {
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