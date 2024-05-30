///@package io.alkapivo.visu.service.bullet

///@param {String}
///@param {Struct} json
function BulletTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Struct}
  sprite = Assert.isType(Struct.get(json, "sprite"), Struct)

  ///@type {?Struct}
  mask = Struct.contains(json, "mask")
    ? Assert.isType(json.mask, Struct)
    : null

  ///@type {Struct}
  gameModes = Struct.appendUnique(
    Struct.filter(Struct.getDefault(json, "gameModes", {}), function(gameMode, key) { 
      return Core.isType(gameMode, Struct) && Core.isEnum(key, GameMode)
    }),
    BULLET_GAME_MODES
  )

  ///@return {Struct}
  serialize = function() {
    var json = {
      sprite: this.sprite,
      gameModes: this.gameModes,
    }

    if (Optional.is(this.mask)) {
      Struct.set(json, "mask", this.mask)
    }

    return JSON.clone(json)
  }
}


///@param {BulletTemplate} template
function Bullet(template): GridItem(template) constructor {

  ///@type {Player|Shroom}
  producer = template.producer
  Assert.isTrue(this.producer == Player || this.producer == Shroom)
  
  ///@private
  ///@param {GridView} view
  ///@return {Bullet}
  healthcheck = function(view) {
    var distance = Math.getDistance(this.x, this.y,
      view.x + (view.width / 2.0),
      view.y + (view.height / 2.0)
    )

    if (distance > BULLET_MAX_DISTANCE) {
      var event = new Event("remove-bullet", key)
      service.dispatcher.send(service.dispatcher, event)
    }

    return this
  }
  
  ///@private
  ///@param {VisuController} controller
  ///@type {Callable}
  _update = method(this, this.update)

  ///@param {VisuController} controller
  ///@return {Bullet}
  update = function(controller) {
    //this.healthcheck(controller.gridService.view)
    this._update(controller)    
    return this
  }

  this.gameModes
    .set(GameMode.RACING, BulletRacingGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "racing", {})))
    .set(GameMode.BULLETHELL, BulletBulletHellGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    .set(GameMode.PLATFORMER, BulletPlatformerGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "platformer", {})))
}
