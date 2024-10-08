///@package io.alkapivo.visu.service.shroom

///@param {Struct} json
///@return {GridItemGameMode}
function ShroomRacingGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: ShroomRacingGameMode,
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function ShroomBulletHellGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: ShroomBulletHellGameMode,

    ///@override
    ///@param {Shroom} shroom
    ///@param {VisuController} controller
    update: function(shroom, controller) {
      if (shroom.healthPoints == 0) {
        shroom.signal("kill")
      }

      if (shroom.signals.damage && !shroom.signals.kill) {
        controller.sfxService.play("shroom-damage")
      }

      if (shroom.signals.kill && (shroom.signals.bulletCollision 
        || shroom.signals.playerCollision)) {
        controller.sfxService.play("shroom-die")
      }
    },
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function ShroomPlatformerGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: ShroomPlatformerGameMode,

    ///@override
    ///@param {Shroom} shroom
    ///@param {VisuController} controller
    update: function(shroom, controller) {
      if (Optional.is(shroom.signals.bulletCollision)) {
        //shroom.signal("kill")
      }
    },
  }))
}


///@static
///@type {Struct}
global.__SHROOM_GAME_MODES = {
  "racing": ShroomRacingGameMode,
  "bulletHell": ShroomBulletHellGameMode,
  "platformer": ShroomPlatformerGameMode,
}
#macro SHROOM_GAME_MODES global.__SHROOM_GAME_MODES
