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
  keyboard = Assert.isType(json.keyboard, Keyboard)

  ///@type {Struct}
  gameModes = Struct.appendUnique(
    Struct.filter(Struct.getDefault(json, "gameModes", {}), function(gameMode, key) { 
      return Core.isType(gameMode, Struct) && Core.isEnum(key, GameMode)
    }),
    PLAYER_GAME_MODES
  )

  ///@type {?Struct}
  stats = Core.isType(Struct.get(json, "stats"), Struct) ? json.stats : null

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

    if (Core.isType(this.stats, Struct)) {
      Struct.set(json, "stats", this.stats)
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


///@param {PlayerStats} _stats
///@param {Struct} json
function PlayerStatLevel(_stats, json) constructor {

  ///@type {PlayerStats}
  stats = Assert.isType(_stats, PlayerStats)

  ///@type {Number}
  level = Core.isType(Struct.get(json, "level"), Number) ? json.level : 0

  ///@type {Array<Number>}
  tresholds = new Array(Number, Core.isType(Struct.get(json, "tresholds"), Array) 
    ? json.tresholds.getContainer() 
    : [ 0 ])

  ///@private
  ///@return {Number}
  getStat = method(this, Core.isType(Struct.get(json, "getStat"), Callable) 
    ? json.getStat 
    : function() { return 0 })

  ///@private
  ///@return {PlayerStatLevel}
  onLevelUp = method(this, Core.isType(Struct
    .get(json, "onLevelUp"), Callable) 
      ? json.onLevelUp : function() { return this })

  ///@return {Number}
  get = function() {
    return this.level
  }

  ///@param {Number} level
  ///@return {PlayerStatLevel}
  set = function(level) {
    this.level = level
    return this
  }

  ///@return {PlayerStatLevel}
  update = function() {
    this.tresholds.forEach(function(required, level, statLevel) {
      if (statLevel.getStat() < required) {
        return
      }
    
      if (level - 1 == statLevel.level) {
        this.set(level).onLevelUp()
      }
    }, this)

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
      var controller = Beans.get(BeanVisuController)
      var value = this.get()
      if (previous < value) {
        controller.sfxService.play("player-collect-point-or-force")
        //Core.print("Force incremented from", previous, "to", value)
      } else if (previous > value) {
        //Core.print("Force decremented from", previous, "to", value)
      }
      return this
    },
    onMinValueExceed: function() { 
      //Core.print("Force already reached minimum")
      return this
    },
    onMaxValueExceed: function() { 
      //Core.print("Force alread reached maximum")
      return this
    },
  }))

  ///@type {PlayerStatLevel}
  forceLevel = new PlayerStatLevel(this, Struct.appendUnique(Struct.get(json, "forceLevel"), {
    tresholds: Core.getProperty("visu.player.force.tresholds", new Array(Number, [ 0 ]))
      .map(function(treshold) { return treshold }),
    getStat: function() {
      return this.stats.force.get()
    },
    onLevelUp: function() {
      Beans.get(BeanVisuController).sfxService.play("player-force-level-up")
      return this
    }
  }))

  ///@type {Number}
  point = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "point"), {
    value: 0,
    minValue: 0,
    maxValue: 9999999,
    onValueUpdate: function(previous) { 
      var controller = Beans.get(BeanVisuController)
      var value = this.get()
      if (previous < value) {
        controller.sfxService.play("player-collect-point-or-force")
        //Core.print("Points incremented from", previous, "to", value)
      } else if (previous > value) {
        //Core.print("Points decremented from", previous, "to", value)
      }
      return this
    },
    onMinValueExceed: function() { 
      //Core.print("Points already reached minimum")
      return this
    },
    onMaxValueExceed: function() { 
      //Core.print("Points already reached maximum")
      return this
    },
  }))

  ///@type {PlayerStatLevel}
  pointLevel = new PlayerStatLevel(this, Struct.appendUnique(Struct.get(json, "pointLevel"), {
    tresholds: Core.getProperty("visu.player.point.tresholds", new Array(Number, [ 0 ]))
      .map(function(treshold) { return treshold }),
    getStat: function() {
      return this.stats.point.get()
    },
    onLevelUp: function() {
      this.stats.life.apply(1)
      return this
    }
  }))

  ///@type {Number}
  bomb = new PlayerStat(this, Struct.appendUnique(Struct.get(json, "bomb"), {
    value: 5,
    minValue: 0,
    maxValue: 10,
    onValueUpdate: function(previous) { 
      var controller = Beans.get(BeanVisuController)
      var value = this.get()
      if (previous < value) {
        controller.visuRenderer.hudRenderer.sendGlitchEvent()
        controller.sfxService.play("player-collect-bomb")
        //Core.print("Bomb added from", previous, "to", value)
      } else if (previous > value) {
        this.stats.setBombCooldown(5.0)
        this.stats.setGodModeCooldown(5.0)

        var view = controller.gridService.view
        var player = this.stats.player
        controller.particleService.send(controller.particleService
          .factoryEventSpawnParticleEmitter({
            particleName: "particle-player-bomb-start",
            beginX: (player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            beginY: (player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            endX: (player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            endY: (player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            duration: 0.0,
            amount: 3,
          }))
          
        var task = new Task("spawn-particle-player-bomb")
          .setTimeout(10.0)
          .setState({
            timer: new Timer(5.0),
            cooldown: new Timer(1.0, { loop: Infinity }),
          })
          .whenUpdate(function() {
            if (this.state.timer.update().finished) {
              this.fullfill()
            }

            var controller = Beans.get(BeanVisuController)
            var view = controller.gridService.view
            var player = controller.playerService.player
            if (!Core.isType(player, Player)) {
              return
            }

            if (!this.state.cooldown.update().finished) {
              return
            }

            var time = ceil(this.state.timer.finished ? this.state.timer.duration : this.state.timer.time)
            var col1 = time mod 2 != 0 ? "#371848" : "#FF00FF"
            var col2 = time mod 2 != 0 ? "#FF00FF" : "#371848"
            controller.subtitleService.send(new Event("add", {
              template: new SubtitleTemplate("sub-bomb", {
                lines: [
                  $"DROP THE BOMB"
                ],
              }),
              timeout: null,
              font: FontUtil.fetch("font_kodeo_mono_48_bold"),
              fontHeight: 96,
              color: ColorUtil.parse(col1).toGMColor(),
              outline: ColorUtil.parse(col2).toGMColor(),
              align: {
                v: VAlign.TOP,
                h: HAlign.CENTER,
              },
              area: new Rectangle({ 
                x: 0.25,
                y: 0.4,
                width: 0.5,
                height: 0.2,
              }),
              charSpeed: 0.25,
              lineDelay: new Timer(0.1),
              finishDelay: new Timer(1.0),
              angleTransformer: new NumberTransformer({
                value: 270.0,
                target: 270.0,
                factor: 0.1,
                increase: 0.0,
              }),
              speedTransformer: new NumberTransformer({
                value: 0.0,
                target: 128.0,
                factor: 0.03,
                increase: 0.0003,
              }),
              fadeIn: 0.5,
              fadeOut: 0.5,
            }))

            controller.shroomService.shrooms.forEach(function(shroom, index, player) {
              var length = Math.fetchLength(shroom.x, shroom.y, player.x, player.y)
              if (length <= 1.41) {
                shroom.signal("kill")
              }
            }, player)

            controller.particleService.send(controller.particleService
              .factoryEventSpawnParticleEmitter({
                particleName: "particle-player-bomb",
                beginX: (player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
                beginY: (player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
                endX: (player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
                endY: (player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
                duration: 1.0,
                interval: 0.5,
                amount: 2,
              }))

            controller.visuRenderer.hudRenderer.sendGlitchEvent()
            effect_track_event.brush_effect_glitch.run({
              "ef-glt_shd-rng-seed":0.26406799999999998,
              "ef-glt_use-fade-out":true,
              "ef-glt_shd-intensity":0.3015499999999999,
              "ef-glt_fade-out":0.9789500000000001,
              "ef-glt_use-config":true,
              "ef-glt_line-spd":0.104141,
              "ef-glt_line-shift":0.085999999999999999,
              "ef-glt_line-res":0.253488,
              "ef-glt_line-v-shift":0.13178300000000001,
              "ef-glt_line-drift":0.1760000000000003,
              "ef-glt_jumb-spd":0.4160780000000001,
              "ef-glt_jumb-shift":0.4046299999999999,
              "ef-glt_jumb-res":0.34000000000000002,
              "ef-glt_jumb-chaos":0.82999999999999996,
              "ef-glt_shd-dispersion":0.3000000000000001,
              "ef-glt_shd-ch-shift":0.054421000000000002,
              "ef-glt_shd-noise":0.5883700000000001,
              "ef-glt_shd-shakiness":3.9549329999999996,
            })
          })
        controller.executor.add(task)

        var time = 1
        var col1 = time mod 2 != 0 ? "#371848" : "#FF00FF"
        var col2 = time mod 2 != 0 ? "#FF00FF" : "#371848"
        controller.subtitleService.send(new Event("add", {
          template: new SubtitleTemplate("sub-bomb", {
            lines: [
              $"DROP THE BOMB"
            ],
          }),
          timeout: null,
          font: FontUtil.fetch("font_kodeo_mono_48_bold"),
          fontHeight: 96,
          color: ColorUtil.parse(col1).toGMColor(),
          outline: ColorUtil.parse(col2).toGMColor(),
          align: {
            v: VAlign.TOP,
            h: HAlign.CENTER,
          },
          area: new Rectangle({ 
            x: 0.25,
            y: 0.4,
            width: 0.5,
            height: 0.2,
          }),
          charSpeed: 0.25,
          lineDelay: new Timer(0.1),
          finishDelay: new Timer(1.00),
          angleTransformer: new NumberTransformer({
            value: 270.0,
            target: 270.0,
            factor: 0.1,
            increase: 0.0,
          }),
          speedTransformer: new NumberTransformer({
            value: 0.0,
            target: 128.0,
            factor: 0.03,
            increase: 0.0003,
          }),
          fadeIn: 0.5,
          fadeOut: 0.5,
        }))
        controller.sfxService.play("player-use-bomb")
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
    value: 4,
    minValue: 0,
    maxValue: 10,
    onValueUpdate: function(previous) { 
      var controller = Beans.get(BeanVisuController)
      var value = this.get()
      if (previous < value) {
        controller.visuRenderer.hudRenderer.sendGlitchEvent()
        controller.sfxService.play("player-collect-life")
        //Core.print("Life added from", previous, "to", value) 
      } else if (previous > value) {
        var view = controller.gridService.view
        this.stats.setGodModeCooldown(5.0)

        controller.visuRenderer.hudRenderer.sendGlitchEvent()

        if (!Visu.settings.getValue("visu.god-mode")) {
          controller.sfxService.play("player-die")
        }

        if (this.stats.bomb.get() < 3) {
          this.stats.bomb.set(3)
        }

        controller.particleService.send(controller.particleService
          .factoryEventSpawnParticleEmitter({
            particleName: "particle-player-death",
            beginX: (this.stats.player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            beginY: (this.stats.player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            endX: (this.stats.player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            endY: (this.stats.player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            duration: 0.0,
            amount: 2,
          }))

        var forceValue = this.stats.force.get()
        var forceCoinAmount = ceil((forceValue / 2.0) + irandom(forceValue / 2.0))
        this.stats.force.apply(-1 * forceValue)
        this.stats.forceLevel.set(0)
        repeat (forceCoinAmount) {
          var _x = this.stats.player.x + (choose(0.33, -0.33) * (random(view.width) / view.width))
          var _y = min(view.y + (view.height / 1.5), this.stats.player.y) - 0.5 - (0.2 * (random(view.height) / view.height))
          var angle = Math.fetchPointsAngle(
            _x,
            _y,
            view.x + (view.width / 2.0),
            view.y
          )

          var speedMin = 2.0
          var speedMax = 5.0
          var speedValue = speedMin + random(speedMax - speedMin)
          var speedFactor = clamp(
            random(speedValue) / (speedMax * 10.0), 
            speedMin / (speedMax * 10.0), 
            speedMax / (speedMax * 10.0)
          )
          var coin = {
            template: "coin-force",
            x: _x,
            y: _y,
            angle: angle,
            speed: { 
              value: -1.0 * speedValue, 
              factor: speedFactor,
            },
          }

          controller.coinService.send(new Event("spawn-coin", coin))
        }

        this.stats.player.x = view.x + (view.width / 2.0)
        this.stats.player.y = view.y + (view.height * 0.75)

        controller.particleService.send(controller.particleService
          .factoryEventSpawnParticleEmitter({
            particleName: "particle-player-respawn",
            beginX: (this.stats.player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            beginY: (this.stats.player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            endX: (this.stats.player.x - view.x) * GRID_SERVICE_PIXEL_WIDTH,
            endY: (this.stats.player.y - view.y) * GRID_SERVICE_PIXEL_HEIGHT,
            duration: 0.0,
            amount: 2,
          }))
      }
      return this
    },
    onMinValueExceed: function() { 
      if (Visu.settings.getValue("visu.god-mode")) {
        this.value = 3
        Beans.get(BeanVisuController)
          .send(new Event("spawn-popup", { 
            message: "God-mode is active, respawning player"
          }))
      } else {
        var controller = Beans.get(BeanVisuController)
        controller.send(new Event("game-over"))
      }
      
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
    this.forceLevel.update()
    this.pointLevel.update()

    return this
  }
}


///@param {Struct} template
function Player(template): GridItem(template) constructor {

  ///@type {Keyboard}
  keyboard = Assert.isType(template.keyboard, Keyboard)

  ///@type {PlayerStats}
  stats = new PlayerStats(this, Struct.get(template, "stats"))

  ///@override
  ///@return {GridItem}
  static update = function(controller) {
    this.keyboard.update()
    
    if (Optional.is(this.gameMode)) {
      gameMode.update(this, controller)
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }

    this.stats.update()

    var view = controller.gridService.view
    var targetLocked = controller.gridService.targetLocked
    if (targetLocked.isLockedX && Optional.is(targetLocked.lockX)) { 
      var horizontal = controller.gridService.properties.borderHorizontalLength / 2.0
      var width = (this.sprite.getWidth() / 2.0) / GRID_SERVICE_PIXEL_WIDTH
      var xMin = targetLocked.lockX + (view.width / 2.0) - horizontal + width
      var xMax = targetLocked.lockX + (view.width / 2.0) + horizontal - width
      var xMinOffset = xMin < 0 ? abs(xMin) : 0.0
      var xMaxOffset = xMax > view.worldWidth ? xMax - view.worldWidth : 0.0
      xMin = clamp(xMin - xMaxOffset, 0.0, view.worldWidth)
      xMax = clamp(xMax + xMinOffset, 0.0, view.worldWidth)
        
      this.x = clamp(this.x, xMin, xMax)
    }

    if (targetLocked.isLockedY && Optional.is(targetLocked.lockY)) { 
      var vertical = controller.gridService.properties.borderVerticalLength / 2.0
      var height = (this.sprite.getHeight() / 2.0) / GRID_SERVICE_PIXEL_HEIGHT
      var yMin = targetLocked.lockY + (view.height / 2.0) - vertical + height
      var yMax = targetLocked.lockY + (view.height / 2.0) + vertical - height
      var yMinOffset = yMin < 0 ? abs(yMin) : 0.0
      var yMaxOffset = yMax > view.worldHeight ? yMax - view.worldHeight : 0.0
      yMin = clamp(yMin - yMaxOffset, 0.0, view.worldHeight)
      yMax = clamp(yMax + yMinOffset, 0.0, view.worldHeight)

      this.y = clamp(this.y, yMin, yMax)
    }

    this.x = clamp(this.x, 0.0, view.worldWidth)
    this.y = clamp(this.y, 0.0, view.worldHeight)
    return this
  }

  this.gameModes
    .set(GameMode.BULLETHELL, PlayerBulletHellGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    //.set(GameMode.RACING, PlayerRacingGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "racing", {})))
    //.set(GameMode.PLATFORMER, PlayerPlatformerGameMode(Struct.getDefault(Struct.get(template, "gameModes"), "platformer", {})))
}
