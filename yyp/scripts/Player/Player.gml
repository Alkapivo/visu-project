///@package io.alkapivo.visu.service.player

///@param {Struct} json
function PlayerTemplate(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {Struct}
  sprite = Assert.isType(json.sprite, Struct)

  ///@type {?Struct}
  mask = Core.isType(Struct.get(json, "mask"), Struct) ? json.mask : null

  ///@type {Keyboard}
  keyboard = new Keyboard(json.keyboard)

  ///@type {Struct}
  gameModes = Struct.appendUnique(
    Struct.filter(Struct.getDefault(json, "gameModes", {}), function(gameMode, key) { 
      return Core.isType(gameMode, Struct) && Core.isEnum(key, GameMode)
    }),
    PLAYER_GAME_MODES
  )

  ///@return {Struct}
  serialize = function() {
    var json = {
      sprite: this.sprite,
      gameModes: this.gameModes,
      keyboard: this.keyboard,
    }

    if (Core.isType(this.mask, Struct)) {
      Struct.set(json, "mask", this.mask)
    }

    return JSON.clone(json)
  }
}

///@param {PlayerTemplate} json
function Player(template): GridItem(template) constructor {

  ///@type {Keyboard}
  keyboard = Assert.isType(template.keyboard, Keyboard)

  ///@private
  ///@param {VisuController} controller
  ///@return {GridItem}
  _update = method(this, this.update)
  
  ///@override
  ///@return {GridItem}
  update = function(controller) {
    this.keyboard.update()
    this._update(controller)

    var view = controller.gridService.view
    if (controller.editor.store.getValue("target-locked-x")) {
      var width = controller.gridService.properties.borderHorizontalLength
      var offsetX = (this.sprite.getWidth()) / GRID_SERVICE_PIXEL_WIDTH
      var anchorX = view.x //(view.width * floor(view.x / view.width)) 
      this.x = clamp(
        this.x,
        clamp(anchorX - width + offsetX + (view.width / 2.0), 0.0, view.worldWidth),
        clamp(anchorX + width - offsetX + (view.width / 2.0), 0.0, view.worldWidth)
      )
      //Core.print("x", this.x, "anchorX", anchorX, "follow.x", view.follow.target.x, "view.x", view.x)
    }

    if (controller.editor.store.getValue("target-locked-y")) {
      var height = controller.gridService.properties.borderVerticalLength
      var anchorY = view.y //(view.height * floor(view.y / view.height))
      var platformerY = this.y
      this.y = clamp(
        this.y, 
        clamp(anchorY - height + (view.height / 2.0), 0.0, view.worldHeight),
        clamp(anchorY + height + (view.height / 2.0), 0.0, view.worldHeight)
      )
      if (this.gameMode != null 
        && this.gameMode.type == PlayerPlatformerGameMode
        && controller.gridRenderer.player2DCoords.y > controller.gridRenderer.gridSurface.height) {

        this.y = clamp(platformerY, 0.0, view.worldHeight + view.height)
        controller.editor.store.get("target-locked-y").set(false)
      }
    }

    this.x = clamp(this.x, 0.0, view.worldWidth)
    this.y = clamp(this.y, 0.0, view.worldHeight)
    return this
  }

  this.gameModes
    .set(GameMode.RACING, PlayerRacingGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "racing", {})))
    .set(GameMode.BULLETHELL, PlayerBulletHellGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    .set(GameMode.PLATFORMER, PlayerPlatformerGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "platformer", {})))
}
