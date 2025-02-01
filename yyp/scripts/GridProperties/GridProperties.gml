///@package io.alkapivo.visu.service.grid

///@param {Struct} [config]
function GridProperties(config = {}) constructor {

  ///@type {Number}
  speed = Assert.isType(Struct
    .getDefault(config, "properties.speed", (FRAME_MS / 4) * 1000), Number)

  #region channels
  ///@type {Number}
  channels = Assert.isType(Struct
    .getDefault(config, "properties.channels", 3), Number)

  ///@type {Color}
  channelsPrimaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.channelsPrimaryColor", "#023ef2")), Color)

  ///@type {Color}
  channelsSecondaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.channelsSecondaryColor", "#ff11bb")), Color)

  ///@type {Number}
  channelsPrimaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.channelsPrimaryAlpha", 0.9), Number)

  ///@type {Number}
  channelsSecondaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.channelsSecondaryAlpha", 0.8), Number)  

  ///@type {Number}
  channelsPrimaryThickness = Assert.isType(Struct
      .getDefault(config, "properties.channelsPrimaryThickness", 10), Number)

  ///@type {Number}
  channelsSecondaryThickness = Assert.isType(Struct
    .getDefault(config, "properties.channelsSecondaryThickness", 10), Number)

  ///@type {String}
  channelsMode = Assert.isType(Struct
    .getDefault(config, "properties.channelsMode", "DUAL"), String)
  #endregion

  #region separators
  ///@type {Number}
  separators = Assert.isType(Struct
    .getDefault(config, "properties.separators", 10), Number)

  ///@type {Color}
  separatorsPrimaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.separatorsPrimaryColor ", "#023ef2")), Color)

  ///@type {Color}
  separatorsSecondaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.separatorsSecondaryColor ", "#4c47cc")), Color)

  ///@type {Number}
  separatorsPrimaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.separatorsPrimaryAlpha", 0.8), Number)

  ///@type {Number}
  separatorsSecondaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryAlpha", 0.7), Number)  

  ///@type {Number}
  separatorsPrimaryThickness = Assert.isType(Struct
      .getDefault(config, "properties.separatorsPrimaryThickness", 6), Number)

  ///@type {Number}
  separatorsSecondaryThickness = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryThickness", 6), Number)

  ///@type {String}
  separatorsMode = Assert.isType(Struct
    .getDefault(config, "properties.separatorsMode", "DUAL"), String)
  #endregion

  #region borders
  ///@type {Color}
  borderVerticalColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderVerticalColor ", "#ff0000")), Color)

  ///@type {Number}
  borderVerticalAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderVerticalAlpha", 1.0), Number)

  ///@type {Number}
  borderVerticalThickness = Assert.isType(Struct
      .getDefault(config, "properties.borderVerticalThickness", 16), Number)

  ///@type {Color}
  borderHorizontalColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderHorizontalColor ", "#ff0000")), Color)

  ///@type {Number}
  borderHorizontalAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalAlpha", 0.0), Number)  

  ///@type {Number}
  borderHorizontalThickness = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalThickness", 16), Number)

  ///@type {Number}
  borderHorizontalLength = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalLength", 1), Number)

  ///@type {Number}
  borderVerticalLength = Assert.isType(Struct
    .getDefault(config, "properties.borderVerticalLength", 1), Number)
  #endregion
  
  #region enable/disable rendering
  ///@type {Boolean}
  renderGrid = Assert.isType(Struct
    .getDefault(config, "properties.renderGrid", true), Boolean)
  
  ///@type {Boolean}
  renderElements = Assert.isType(Struct
    .getDefault(config, "properties.renderElements", true), Boolean)

  ///@type {Boolean}
  renderBullets = Assert.isType(Struct
    .getDefault(config, "properties.renderBullets", true), Boolean)

  ///@type {Boolean}
  renderShrooms = Assert.isType(Struct
    .getDefault(config, "properties.renderShrooms", true), Boolean)

  ///@type {Boolean}
  renderCoins = Assert.isType(Struct
    .getDefault(config, "properties.renderCoins", true), Boolean)

  ///@type {Boolean}
  renderPlayer = Struct.getIfType(config, "properties.renderPlayer", Boolean, true)

  ///@type {Boolean}
  renderBackground = Assert.isType(Struct
    .getDefault(config, "properties.renderBackground", true), Boolean)

  ///@type {Boolean}
  renderVideo = Assert.isType(Struct
    .getDefault(config, "properties.renderVideo", true), Boolean)

  ///@type {Boolean}
  renderVideoAfter = Assert.isType(Struct
    .getDefault(config, "properties.renderVideoAfter", false), Boolean)

  ///@type {Boolean}
  renderForeground = Assert.isType(Struct
    .getDefault(config, "properties.renderForeground", true), Boolean)

  ///@type {Boolean}
  renderGridShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderGridShaders", true), Boolean)

  ///@type {Boolean}
  renderBackgroundShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderBackgroundShaders", true), Boolean)

  ///@type {Boolean}
  renderCombinedShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderCombinedShaders", true), Boolean)

  ///@type {Boolean}
  renderParticles = Assert.isType(Struct
    .getDefault(config, "properties.renderParticles", true), Boolean)

      ///@type {Boolean}
  renderSubtitles = Assert.isType(Struct
    .getDefault(config, "properties.renderSubtitles", true), Boolean)
  #endregion

  #region support-grid
  ///@type {Number}
  renderSupportGrid = Assert.isType(Struct
    .getDefault(config, "properties.renderSupportGrid", true), Boolean)

  ///@type {Number}
  supportGridTreshold = Assert.isType(Struct
    .getDefault(config, "properties.supportGridTreshold", 2), Number)

  ///@type {Number}
  supportGridAlpha = Assert.isType(Struct
    .getDefault(config, "properties.supportGridAlpha", 0.33), Number)

  ///@type {Color}
  supportGridBlendColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.supportGridColor", "#ffffff")), Color)

  ///@type {BlendConfig}
  supportGridBlendConfig = new BlendConfig(Struct
    .getIfType(config, "properties.supportGridBlendConfig", Struct))
  #endregion

  ///@type {Color}
  gridClearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.gridClearColor", "#00000000")), Color)

  ///@type {Boolean}
  gridClearFrame = Assert.isType(Struct
    .getDefault(config, "properties.gridClearFrame", true), Boolean)

  ///@type {Number}
  gridClearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.gridClearFrameAlpha", 0.0), Number)

  ///@type {BlendConfig}
  gridBlendConfig = new BlendConfig(Struct
    .getIfType(config, "properties.gridBlendConfig", Struct))

  ///@type {Color}
  shaderClearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.shaderClearColor", "#00000000")), Color)

  ///@type {Boolean}
  shaderClearFrame = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrame", true), Boolean)

  ///@type {Number}
  shaderClearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrameAlpha", 0.0), Number)
  
  ///@type {Number}
  videoAlpha = Assert.isType(Struct
    .getDefault(config, "properties.videoAlpha", 1.0), Number)

  ///@type {Color}
  videoBlendColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.videoBlendColor", "#ffffff")), Color)
  
  ///@type {BlendConfig}
  videoBlendConfig = new BlendConfig(Struct
    .getIfType(config, "properties.videoBlendConfig", Struct))

  ///@type {Struct}
  depths = {
    channelZ: 1,
    separatorZ: 2,
    gridZ: 1,
    bulletZ: 2048,
    shroomZ: 2049,
    coinZ: 2047,
    particleZ: 1024,
    playerZ: 2051,
  }
  
  ///@private
  ///@type {Timer}
  separatorTimer = new Timer(FRAME_MS, { amount: this.speed / 1000, loop: Infinity })

  ///@param {GridService} gridService
  ///@return {GridProperties}
  static update = function(gridService) {
    this.separatorTimer.duration = ((gridService.view.height * 2) / this.separators)
    this.separatorTimer.update()
    this.separatorTimer.amount = (this.speed / 1000) - DeltaTime.apply(gridService.view.derivativeY)

    this.gridClearColor.alpha = this.gridClearFrameAlpha
    this.shaderClearColor.alpha = this.shaderClearFrameAlpha
    return this
  }
}

