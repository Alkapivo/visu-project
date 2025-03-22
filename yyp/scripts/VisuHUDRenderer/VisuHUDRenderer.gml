///@package io.alkapivo.visu.renderer

function VisuHUDRenderer() constructor {

  ///@type {Boolean}
  enabled = false

  ///@private
  ///@type {Timer}
  glitchCooldown = new Timer(0.33)

  ///@private
  ///@type {BKTGlitch}
  glitchService = new BKTGlitchService()

  ///@private
  ///@type {Font}
  font = new Font(font_kodeo_mono_18_bold)

  ///@private
  ///@type {Font}
  fontGodMode = new Font(font_kodeo_mono_48_bold)

  ///@type {Number}
  fadeIn = 0.0

  ///@type {Number}
  fadeInFactor = 0.03

  ///@private
  ///@return {VisuHUDRenderer}
  setGlitchServiceConfig = function(factor = 0.0, useConfig = true) {
    var config = {
      lineSpeed: {
        defValue: 0.01,
        minValue: 0.0,
        maxValue: 0.5,
      },
      lineShift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 0.05,
      },
      lineResolution: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 3.0,
      },
      lineVertShift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 1.0,
      },
      lineDrift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleSpeed: {
        defValue: 4.5,
        minValue: 0.0,
        maxValue: 25.0,
      },
      jumbleShift: {
        defValue: 0.059999999999999998,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleResolution: {
        defValue: 0.25,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleness: {
        defValue: 0.10000000000000001,
        minValue: 0.0,
        maxValue: 1.0,
      },
      dispersion: {
        defValue: 0.002,
        minValue: 0.0,
        maxValue: 0.5,
      },
      channelShift: {
        defValue: 0.00050000000000000001,
        minValue: 0.0,
        maxValue: 0.05,
      },
      noiseLevel: {
        defValue: 0.10000000000000001,
        minValue: 0.0,
        maxValue: 1.0,
      },
      shakiness: {
        defValue: 0.5,
        minValue: 0.0,
        maxValue: 10.0,
      },
      rngSeed: {
        defValue: 0.66600000000000004,
        minValue: 0.0,
        maxValue: 1.0,
      },
      intensity: {
        defValue: 0.40000000000000002,
        minValue: 0.0,
        maxValue: 5.0,
      },
    }

    if (useConfig) {
      this.glitchService.dispatcher
        .execute(new Event("load-config", config))
    }

    this.glitchService.dispatcher
      .execute(new Event("spawn", { 
        factor: factor, 
        rng: !useConfig
      }))
    
      return this
  }

  ///@return {VisuHUDRenderer}
  sendGlitchEvent = function() {
    var value = choose(0.3, 0.4, 0.5, 0.6, 0.7)
    this.setGlitchServiceConfig(value / 100.0, false)
    this.glitchCooldown.reset()
    return this
  }

  ///@private
  ///@return {VisuHUDRenderer}
  init = function() {
    this.setGlitchServiceConfig()
    return this
  }

  ///@private
  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  renderHUD = function(layout) {
    if (!this.enabled && this.fadeIn == 0.0) {
      return
    }

    if (!this.glitchCooldown.finished) {
      if (glitchCooldown.update().finished) {
        glitchCooldown.time = glitchCooldown.duration
        this.setGlitchServiceConfig(0.0, true)
      }
    }

    var controller = Beans.get(BeanVisuController)
    var player = controller.playerService.player
    if (Core.isType(player, Player)) {
      var _x = layout.x()
      var _y = layout.y()
      var _width = layout.width()
      var _height = layout.height()

      var lifeString = ""
      repeat (player.stats.life.get()) {
        lifeString = $"{lifeString}L "
      }

      var bombString = ""
      repeat (player.stats.bomb.get()) {
        bombString = $"{bombString}B "
      }

      var point = string(player.stats.point.get())
      repeat (4 - String.size(point)) {
        point = $"0{point}"
      }

      var forceLevel = player.stats.forceLevel
      var forceTreshold = forceLevel.level < forceLevel.tresholds.size() - 1
        ? forceLevel.tresholds.get(forceLevel.level + 1)
        : (forceLevel.tresholds.size() == 0 ? 0 : forceLevel.tresholds.getLast())
      var force = forceLevel.level == forceLevel.tresholds.size() - 1
        ? "MAX"
        : $"{player.stats.force.get()} / {forceTreshold}"

      var textMask  = $"POINT: {point}\nFORCE: {force}\n LIFE: {lifeString}\n BOMB: {bombString}"
      var textLabel = $"POINT:        \nFORCE:        \n LIFE:\n BOMB:"
      var textPoint = $"       {point}\n              \n      \n      "
      var textForce = $"              \n       {force}\n      \n      "
      var textLife = $"\n\n       {lifeString}\n\n"
      var textBomb = $"\n\n\n       {bombString}"

      var xStart = _width * 0.061
      var yStart = _height * 0.08
      var offset = (this.glitchCooldown.duration - this.glitchCooldown.time) * 64

      GPU.render.text(_x + xStart + offset, _y + _height - yStart, textLabel, 1.0, 0.0, 0.20 * this.fadeIn, c_fuchsia, this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart - offset, textPoint, 1.0, 0.0, 0.66 * this.fadeIn, c_blue,    this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart - offset, textForce, 1.0, 0.0, 0.66 * this.fadeIn, c_red,     this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart + offset, _y + _height - yStart, textMask,  1.0, 0.0, 0.33 * this.fadeIn, c_white,   this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart + offset, textLife,  1.0, 0.0, 0.33 * this.fadeIn, c_lime,    this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart + offset, textBomb,  1.0, 0.0, 0.33 * this.fadeIn, c_yellow,  this.font, HAlign.LEFT, VAlign.BOTTOM)

      if (player.stats.godModeCooldown > 0) {
        var textHeight = string_height(textMask)
        var factor = 1.0 - (ceil(player.stats.godModeCooldown) - player.stats.godModeCooldown)
        GPU.render.text(
          _x + (_width / 2.0),
          _y + _height - yStart - (textHeight / 2.0),
          $"{ceil(player.stats.godModeCooldown)}",
          1.0,
          0.0,
          0.7 * this.fadeIn * factor,
          c_white,
          this.fontGodMode,
          HAlign.CENTER,
          VAlign.CENTER,
          c_black
        )

        GPU.render.text(
          _x + (_width / 2.0),
          _y + _height - yStart,
          "INVINCIBILITY",
          1.0,
          0.0,
          0.4 * this.fadeIn * (player.stats.godModeCooldown < 1.0 ? factor : 1.0),
          c_white,
          this.font,
          HAlign.CENTER,
          VAlign.BOTTOM,
          c_black
        )
      }
    }

    return this
  }

  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  update = function(layout) {
    this.glitchService.update(layout.width(), layout.height())

    if (this.enabled) {
      if (this.fadeIn < 1.0) {
        this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
      }
    } else {
      if (this.fadeIn > 0.0) {
        this.fadeIn = clamp(this.fadeIn - this.fadeInFactor, 0.0, 1.0)
      }
    }
    
    return this
  }

  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  renderGUI = function(layout) {
    this.glitchService.renderOn(this.renderHUD, layout)
    return this
  }

  this.init()
}