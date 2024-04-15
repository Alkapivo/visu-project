///@package io.alkapivo.visu.service.bullet

///@param {Struct} json
///@return {GridItemGameMode}
function BulletIdleGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: BulletIdleGameMode,

    ///@override
    ///@param {Bullet} bullet
    ///@param {VisuController} controller
    update: function(bullet, controller) {
      if (Optional.is(bullet.signals.shroomCollision)) {
        bullet.signal("kill")
      }
  
      if (Optional.is(bullet.signals.playerCollision)) {
        bullet.signal("kill")
      }
    },
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function BulletBulletHellGameMode(json) {

  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: BulletBulletHellGameMode,

    ///@override
    ///@param {Bullet} bullet
    ///@param {VisuController} controller
    update: function(bullet, controller) {
      if (Optional.is(bullet.signals.shroomCollision)) {
        bullet.signal("kill")
      }
  
      if (Optional.is(bullet.signals.playerCollision)) {
        bullet.signal("kill")
      }
    },
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function BulletPlatformerGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: BulletPlatformerGameMode,

    ///@override
    ///@param {Bullet} bullet
    ///@param {VisuController} controller
    update: function(bullet, controller) {
      if (Optional.is(bullet.signals.shroomCollision)) {
        bullet.signal("kill")
      }
  
      if (Optional.is(bullet.signals.playerCollision)) {
        bullet.signal("kill")
      }
    },
  }))
}


///@static
///@type {Map<String, Callable>}
global.__BULLET_GAME_MODES = new Map(String, any)
  .set(GameMode.IDLE, BulletIdleGameMode)
  .set(GameMode.BULLETHELL, BulletBulletHellGameMode)
  .set(GameMode.PLATFORMER, BulletPlatformerGameMode)
#macro BULLET_GAME_MODES global.__BULLET_GAME_MODES
BULLET_GAME_MODES.valueType = Callable