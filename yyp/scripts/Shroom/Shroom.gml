///@package io.alkapivo.visu.service.shroom

///@param {String} _name
///@param {Struct} json
function ShroomTemplate(_name, json) constructor {

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
    SHROOM_GAME_MODES
  )

  //@return {Struct}
  serialize = function() {
    var json = {
      name: this.name,
      sprite: this.sprite,
      gameModes: this.gameModes,
    }

    if (Optional.is(this.mask)) {
      Struct.set(json, "mask", this.mask)
    }

    return JSON.clone(json)
  }
}

 
///@param {ShroomTemplate} template
function Shroom(template): GridItem(template) constructor {
  
  ///@private
  ///@type {Map<String, any>}
  state = Struct.getDefault(template, "state", new Map(String, any))

  ///@private
  ///@param {VisuController} controller
  ///@type {Callable}
  _update = method(this, this.update)

  ///@param {VisuController} controller
  ///@return {Shroom}
  update = function(controller) {
    this._update(controller)    
    return this
  }

  this.gameModes
    .set(GameMode.RACING, ShroomRacingGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "racing", {})))
    .set(GameMode.BULLETHELL, ShroomBulletHellGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    .set(GameMode.PLATFORMER, ShroomPlatformerGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "platformer", {})))
}
