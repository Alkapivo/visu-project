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
      if (Optional.is(shroom.signals.bulletCollision)) {
        //shroom.signal("kill")
      }
  
      if (Optional.is(shroom.signals.playerCollision)) {
        //shroom.signal("kill")
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
