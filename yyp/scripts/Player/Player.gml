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


///@param {PlayerStats} _stats
///@param {Struct} json
function PlayerStat(_stats, json) constructor {
  
  ///@type {PlayerStats}
  stats = Assert.isType(_stats, PlayerStats)

  ///@private
  ///@type {Number}
  value = Assert.isType(json.value, Number)

  ///@private
  ///@final
  ///@type {Number}
  minValue = Assert.isType(json.minValue, Number)

  ///@private
  ///@final
  ///@type {Number}
  maxValue = Assert.isType(json.maxValue, Number)

  ///@private
  ///@param {Number} previous
  ///@return {VisuPlayerStat}
  onValueUpdate = method(this, Core.isType(Struct
    .get(json, "onValueUpdate"), Callable) 
      ? json.onValueUpdate : function(previous) { return this })

  ///@private
  ///@return {VisuPlayerStat}
  onMinValueExceed = method(this, Core.isType(Struct
    .get(json, "onMinValueExceed"), Callable) 
      ? json.onMinValueExceed : function() { return this })
  
  ///@private
  ///@return {VisuPlayerStat}
  onMaxValueExceed = method(this, Core.isType(Struct
    .get(json, "onMaxValueExceed"), Callable) 
      ? json.onMaxValueExceed : function() { return this })

  ///@return {Number}
  get = function() { 
    return this.value
  }

  ///@return {Number}
  getMin = function() { 
    return this.minValue
  }

  ///@return {Number}
  getMax = function() { 
    return this.maxValue
  }

  ///@param {Number} value
  ///@return {VisuPlayerStat}
  set = function(value) {
    this.value = clamp(value, this.minValue, this.maxValue)
    return this
  }

  ///@param {Number} value
  ///@return {VisuPlayerStat}
  apply = function(value) {
    var previous = this.value
    var next = this.value + value
    this.set(next).onValueUpdate(previous)

    if (next < this.minValue) {
      this.onMinValueExceed()
    } else if (next > this.maxValue) {
      this.onMaxValueExceed()
    }

    return this
  }
}

///@param {Player} _player
///@param {Struct} json
function PlayerStats(_player, json) constructor {

  ///@type {Player}
  player = Assert.isType(_player, Player)

  ///@type {Number}
  force = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "force"), {
    value: 0,
    minValue: 0,
    maxValue: 250,
    onValueUpdate: function(previous) { 
      var value = this.get()
      if (previous < value) {
        Core.print("Force incremented from", previous, "to", value)
      } else if (previous > value) {
        Core.print("Force decremented from", previous, "to", value)
      }
      return this
    },
    onMinValueExceed: function() { 
      Core.print("Force already reached minimum")
      return this
    },
    onMaxValueExceed: function() { 
      Core.print("Force alread reached maximum")
      return this
    },
  }))

  ///@type {Number}
  point = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "point"), {
    value: 0,
    minValue: 0,
    maxValue: 9999999,
    onValueUpdate: function(previous) { 
      var value = this.get()
      if (previous < value) {
        Core.print("Points incremented from", previous, "to", value)
      } else if (previous > value) {
        Core.print("Points decremented from", previous, "to", value)
      }
      return this
    },
    onMinValueExceed: function() { 
      Core.print("Points already reached minimum")
      return this
    },
    onMaxValueExceed: function() { 
      Core.print("Points already reached maximum")
      return this
    },
  }))

  ///@type {Number}
  bomb = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "bomb"), {
    value: 5,
    minValue: 0,
    maxValue: 10,
    onValueUpdate: function(previous) { 
      var value = this.get()
      if (previous < value) {
        Beans.get(BeanVisuController).shakeHUD()
        //Core.print("Bomb added from", previous, "to", value)
      } else if (previous > value) {
        //Core.print("Bomb reduced from", previous, "to", value)
        Beans.get(BeanVisuController).shakeHUD()
        view_track_event.brush_view_glitch({
          "view-glitch_shader-rng-seed":0.46406799999999998,
          "view-glitch_use-factor":true,
          "view-glitch_shader-intensity":1.2015499999999999,
          "view-glitch_factor":0.15789500000000001,
          "view-glitch_use-config":true,
          "view-glitch_line-speed":0.104141,
          "view-glitch_line-shift":0.085999999999999999,
          "view-glitch_line-resolution":0.953488,
          "view-glitch_line-vertical-shift":0.13178300000000001,
          "view-glitch_line-drift":0.1760000000000003,
          "view-glitch_jumble-speed":5.8160780000000001,
          "view-glitch_jumble-shift":0.4046299999999999,
          "view-glitch_jumble-resolution":0.34000000000000002,
          "view-glitch_jumble-jumbleness":0.82999999999999996,
          "view-glitch_shader-dispersion":0.3000000000000001,
          "view-glitch_shader-channel-shift":0.054421000000000002,
          "view-glitch_shader-noise-level":0.5883700000000001,
          "view-glitch_shader-shakiness":6.9549329999999996,
        })
        this.stats.setBombCooldown(1.0)
        this.stats.setGodModeCooldown(2.0)
        Beans.get(BeanVisuController).shroomService.shrooms
          .forEach(function(shroom) {
            shroom.signal("kill")
          })
      }
      return this
    },
    onMinValueExceed: function() { 
      //Core.print("There is no bomb to be used")
      return this
    },
    onMaxValueExceed: function() { 
      //Core.print("Bombs are maxed out")
      return this
    },
  }))

  ///@type {PlayerStat}
  life = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "life"), {
    value: 3,
    minValue: 0,
    maxValue: 10,
    onValueUpdate: function(previous) { 
      var value = this.get()
      if (previous < value) {
        Beans.get(BeanVisuController).shakeHUD()
        //Core.print("Life added from", previous, "to", value)
      } else if (previous > value) {
        Beans.get(BeanVisuController).shakeHUD()
        //Core.print("Life reduced from", previous, "to", value)
        this.stats.setGodModeCooldown(3.0)
      }
      return this
    },
    onMinValueExceed: function() { 
      this.value = 3
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: "Player life < 0. Respawn player with life: 3" }))
      //Core.print("Die!")
      //var controller = Beans.get(BeanVisuController)
      //controller.send(new Event("rewind", { timestamp: 0.0, resume: false }))
      //controller.playerService.send(new Event("clear-player"))
      return this
    },
    onMaxValueExceed: function() { 
      //Core.print("Life is maxed out")
      return this
    },
  }))

  ///@private
  ///@type {Number}
  godModeCooldown = 0.0

  ///@private
  ///@type {Number}
  bombCooldown = 0.0

  ///@param {Number} cooldown
  ///@return {PlayerStats}
  setGodModeCooldown = function(cooldown) {
    this.godModeCooldown = abs(cooldown)
    return this
  }

  ///@param {Number} cooldown
  ///@return {PlayerStats}
  setBombCooldown = function(cooldown) {
    this.bombCooldown = abs(cooldown)
    return this
  }

  ///@param {Coin} coin
  ///@throws {Exception}
  ///@return {PlayerStats}
  dispatchCoin = function(coin) {
    switch (coin.category) {
      case CoinCategory.FORCE:
        this.force.apply(coin.amount)
        break
      case CoinCategory.POINT:
        this.point.apply(coin.amount)
        break
      case CoinCategory.BOMB:
        this.bomb.apply(coin.amount)
        break
      case CoinCategory.LIFE:
        this.life.apply(coin.amount)
        break
      default:
        throw new Exception($"PlayerStats coin dispatcher for CoinCategory'{category}' wasn't found")
        break
    }

    return this
  }

  ///@return {PlayerStats}
  dispatchBomb = function() {
    if (this.bombCooldown == 0.0) {
      this.bomb.apply(-1)
    }

    return this
  }
  
  ///@return {PlayerStats}
  dispatchDeath = function() {
    if (this.godModeCooldown == 0.0) {
      this.life.apply(-1)
    }

    return this
  }

  ///@return {PlayerStats}
  update = function() {
    var step = DeltaTime.apply(FRAME_MS)
    this.setGodModeCooldown(this.godModeCooldown > step ? this.godModeCooldown - step : 0.0)
    this.setBombCooldown(this.bombCooldown > step ? this.bombCooldown - step : 0.0)

    return this
  }
}


///@param {Struct} template
function Player(template): GridItem(template) constructor {

  ///@type {Keyboard}
  keyboard = Assert.isType(template.keyboard, Keyboard)

  ///@type {PlayerStats}
  stats = new PlayerStats(this, Struct.get(template, "stats"))

  ///@private
  ///@param {VisuController} controller
  ///@return {GridItem}
  _update = method(this, this.update)
  
  ///@override
  ///@return {GridItem}
  update = function(controller) {
    this.keyboard.update()
    this._update(controller)
    this.stats.update()

    var view = controller.gridService.view
    var targetLocked = controller.gridService.targetLocked
    if (targetLocked.isLockedX) { 
      var width = controller.gridService.properties.borderHorizontalLength
      var offsetX = (this.sprite.getWidth()) / GRID_SERVICE_PIXEL_WIDTH
      var anchorX = view.x
      this.x = clamp(
        this.x,
        clamp(anchorX - width + offsetX + (view.width / 2.0), 0.0, view.worldWidth),
        clamp(anchorX + width - offsetX + (view.width / 2.0), 0.0, view.worldWidth)
      )
    }

    if (targetLocked.isLockedY) {
      var height = controller.gridService.properties.borderVerticalLength
      var anchorY = view.y
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
        targetLocked.isLockedY = false
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
