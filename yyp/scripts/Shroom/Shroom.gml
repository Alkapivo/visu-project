///@package io.alkapivo.visu.service.shroom

///@param {String} _name
///@param {Struct} json
function ShroomTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)
  
  ///@type {Struct}
  sprite = Assert.isType(Struct.get(json, "sprite"), Struct)

  ///@type {?Struct}
  mask = Struct.getIfType(json, "mask", Struct, null)

  ///@type {?Number}
  lifespawnMax = Struct.getIfType(json, "lifespawnMax", Number, 15.0)

  ///@type {?Number}
  healthPoints = Struct.getIfType(json, "healthPoints", Number, 1.0)
  
  ///@type {Boolean}
  hostile = Struct.getIfType(json, "hostile", Boolean, true)

  ///@type {Struct}
  //gameModes = Struct.appendUnique(
  //  Struct.filter(Struct.getDefault(json, "gameModes", {}), function(gameMode, key) { 
  //    return Core.isType(gameMode, Struct) && Core.isEnum(key, GameMode)
  //  }),
  //  SHROOM_GAME_MODES
  //)
  var _bulletHell = Struct.get(Struct.get(json, "gameModes"), "bulletHell")
  gameModes = {
    bulletHell: Optional.is(_bulletHell) ? _bulletHell : {},
    platformer: {},
    racing: {}
  }

  //@return {Struct}
  serialize = function() {
    return {
      name: this.name,
      sprite: JSON.clone(this.sprite),
      mask: Optional.is(this.mask) ? JSON.clone(this.mask) : null,
      lifespawnMax: this.lifespawnMax,
      healthPoints: this.healthPoints,
      hostile: this.hostile,
      gameModes: JSON.clone(this.gameModes),
    }
  }

  serializeSpawn = function(x, y, speed, angle, uid) {
    return {
      name: this.name,
      sprite: JSON.clone(this.sprite),
      mask: Optional.is(this.mask) ? JSON.clone(this.mask) : null,
      lifespawnMax: this.lifespawnMax,
      healthPoints: this.healthPoints,
      hostile: this.hostile,
      gameModes: JSON.clone(this.gameModes),
      x: x,
      y: y,
      speed: speed,
      angle: angle,
      uid: uid,
    }
  }
}

 
///@param {Struct} template
function Shroom(template): GridItem(template) constructor {

  ///@type {Number}
  lifespawnMax = template.lifespawnMax

  ///@type {Number}
  healthPoints = template.healthPoints

  ///@type {Boolean}
  hostile = template.hostile

  ///@private
  ///@type {Map<String, any>}
  state = new Map(String, any)

  ///@param {VisuController} controller
  ///@return {Shroom}
  static update = function(controller) {
    gml_pragma("forceinline")
    if (Optional.is(this.gameMode)) {
      gameMode.update(this, controller)
    }

    this.lifespawn += DeltaTime.apply(FRAME_MS)
    if (this.lifespawn >= this.lifespawnMax) {
      this.signal("kill")
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }

    return this
  }

  this.gameModes.set(GameMode.BULLETHELL, ShroomBulletHellGameMode(template.gameModes.bulletHell))
  //this.gameModes
    //.set(GameMode.BULLETHELL, ShroomBulletHellGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    //.set(GameMode.RACING, ShroomRacingGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "racing", {})))
    //.set(GameMode.PLATFORMER, ShroomPlatformerGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "platformer", {})))
}
