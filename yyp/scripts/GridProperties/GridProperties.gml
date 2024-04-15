///@package io.alkapivo.visu.service.grid

///@param {Struct} [config]
function GridProperties(config = {}) constructor {

  ///@type {Color}
  clearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.clearColor", "#00000000")), Color)

  ///@type {Boolean}
  clearFrame = Assert.isType(Struct
    .getDefault(config, "properties.clearFrame", true), Boolean)

  ///@type {Number}
  clearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.clearFrameAlpha", 0.0), Number)

  ///@type {Number}
  speed = Assert.isType(Struct
    .getDefault(config, "properties.speed", (FRAME_MS / 4) * 1000), Number)

  ///@type {Color}
  backgroundColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.backgroundColor", "#ffffff")), Color)

  #region channels
  ///@type {Number}
  channels = Assert.isType(Struct
    .getDefault(config, "properties.channels", 3), Number)

  ///@type {Color}
  channelsPrimaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.channelsPrimaryColor ", "#023ef2")), Color)

  ///@type {Color}
  channelsSecondaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.channelsSecondaryColor ", "#ff11bb")), Color)

  ///@type {Number}
  channelsPrimaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.channelsPrimaryAlpha", 1.0), Number)

  ///@type {Number}
  channelsSecondaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.channelsSecondaryAlpha", 1.0), Number)  

  ///@type {Number}
  channelsPrimaryThickness = Assert.isType(Struct
      .getDefault(config, "properties.channelsPrimaryThickness", 16), Number)

  ///@type {Number}
  channelsSecondaryThickness = Assert.isType(Struct
    .getDefault(config, "properties.channelsSecondaryThickness", 8), Number)
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
    .getDefault(config, "properties.separatorsPrimaryAlpha", 1.0), Number)

  ///@type {Number}
  separatorsSecondaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryAlpha", 1.0), Number)  

  ///@type {Number}
  separatorsPrimaryThickness = Assert.isType(Struct
      .getDefault(config, "properties.separatorsPrimaryThickness", 4), Number)

  ///@type {Number}
  separatorsSecondaryThickness = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryThickness", 2), Number)
  #endregion

  #region borders
  ///@type {Color}
  borderBottomColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderBottomColor ", "#ff0000")), Color)

  ///@type {Number}
  borderBottomAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderBottomAlpha", 1.0), Number)

  ///@type {Number}
  borderBottomThickness = Assert.isType(Struct
      .getDefault(config, "properties.borderBottomThickness", 64), Number)

  ///@type {Color}
  borderHorizontalColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderHorizontalColor ", "#ff0000")), Color)

  ///@type {Number}
  borderHorizontalAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalAlpha", 1.0), Number)  

  ///@type {Number}
  borderHorizontalThickness = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalThickness", 16), Number)
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
  renderBackground = Assert.isType(Struct
    .getDefault(config, "properties.renderBackground", true), Boolean)

  ///@type {Boolean}
  renderVideo = Assert.isType(Struct
    .getDefault(config, "properties.renderVideo", true), Boolean)

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
  renderParticles = Assert.isType(Struct
    .getDefault(config, "properties.renderParticles", true), Boolean)
  #endregion

  #region support-grid
  ///@type {Number}
  renderSupportGrid = Assert.isType(Struct
    .getDefault(config, "properties.renderSupportGrid", true), Boolean)

  ///@type {Number}
  renderSupportGridTreshold = Assert.isType(Struct
    .getDefault(config, "properties.renderSupportGridTreshold", 2), Number)

  ///@type {Number}
  renderSupportGridAlpha = Assert.isType(Struct
    .getDefault(config, "properties.renderSupportGridAlpha", 0.33), Number)
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

  ///@type {Color}
  shaderClearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.shaderClearColor", "#00000000")), Color)

  ///@type {Boolean}
  shaderClearFrame = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrame", true), Boolean)

  ///@type {Number}
  shaderClearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrameAlpha", 0.0), Number)
  

  ///@type {Struct}
  depths = {
    channelZ: 1,
    separatorZ: 2,
    bulletZ: 2048,
    shroomZ: 2049,
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
    
    


    this.clearColor.alpha = this.clearFrameAlpha
    this.gridClearColor.alpha = this.gridClearFrameAlpha
    this.shaderClearColor.alpha = this.shaderClearFrameAlpha
    return this
  }
}

