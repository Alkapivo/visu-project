///@package io.alkapivo.visu.

///@enum
function _GridEntityType(): Enum() constructor {
  BULLET = "bullet"
  ENEMY = "enemy"
  PLAYER = "player"
}
global.__GridEntityType = new _GridEntityType()
#macro GridEntityType global.__GridEntityType


///@static
///@type {Map<Callable, String>}
global.__GridComponentNames = new Map(Callable, String, {
  DamageComponent: "damage",
  GameModeComponent: "gameMode",
  HealthComponent: "health",
  HitBoxComponent: "hitBox",
  LifespawnComponent: "lifespawn",
  ParticleBurstComponent: "particleBurst",
  PositionComponent: "position",
  RenderSpriteComponent: "renderSprite",
  ShootComponent: "shoot",
  VelocityComponent: "velocity",
})
#macro GridComponentNames global.__GridComponentNames


///@param {Struct} json
function GridEntity(json) constructor {

  ///@type {GridEntityType}
  type = Assert.isEnum(json.type, GridEntityType)

  ///@type {?String}
  key = Struct.contains(json, "key")
    ? Assert.isType(json.key, String)
    : null

  ///@type {GridItemSignals}
  signals = new GridItemSignals()

  ///@return {GridEntityType}
  static getType = function() {
    return this.type
  }

  ///@return {?String}
  static getKey = function() {
    return this.key
  }

  ///@param {String} key
  ///@return {GridEntity}
  static setKey = function(key) {
    this.key = Assert.isType(key, String)
    return this
  }

  ///@param {any} name
  ///@param {any} [value]
  ///@return {GridEntity}
  static signal = function(name, value = true) { 
    this.signals.set(name, value)
    return this
  }

  ///@private
  ///@param {Struct} json
  static installComponents = function(json) {
    var entity = this
    GridComponentNames.forEach(function(name, prototype, acc) {
      var factory = Core.getConstructor(prototype)
      Struct.set(acc.entity, name, Struct.contains(acc.json, name)
        ? new factory(Struct.get(acc.json, name))
        : null)
    }, { entity: entity, json: json })
  }

  this.installComponents(json)
}
