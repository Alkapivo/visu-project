///@package com.alkapivo.visu.service.grid.GridRenderer

///@param {Controller} _controller
///@param {Struct} [config]
function GridRenderer(_controller, config = {}) constructor {

  ///@todo move from GridRenderer
  application_surface_draw_enable(false)
  gpu_set_ztestenable(false)
	gpu_set_zwriteenable(false)
	gpu_set_cullmode(cull_counterclockwise)

  ///@type {Controller}
  controller = Assert.isType(_controller, Struct)

  ///@type {GridOverlayRenderer}
  overlayRenderer = new GridOverlayRenderer(this)

  ///@type {Surface}
  gameSurface = new Surface({ width: GuiWidth(), height: GuiHeight() })

  ///@type {Surface}
  backgroundSurface = new Surface({ width: GuiWidth(), height: GuiHeight() })

  ///@type {Surface}
  gridSurface = new Surface({ width: GuiWidth(), height: GuiHeight() })

  ///@type {Surface}
  shaderSurface = new Surface({ width: GuiWidth(), height: GuiHeight() })

  ///@type {GridCamera}
  camera = new GridCamera()
  
  ///@type {GMVertexBuffer}
  vertexBuffer = new DefaultVertexBuffer(new Array(DefaultVertex, [
	  new DefaultVertex(0, 0, 0, 0, 0, 1, 0, 0, ColorUtil.WHITE, 1),
    new DefaultVertex(GRID_SERVICE_PIXEL_WIDTH, 0, 0,  0, 0, 1, 1, 0, ColorUtil.WHITE, 1),
    new DefaultVertex(GRID_SERVICE_PIXEL_WIDTH, GRID_SERVICE_PIXEL_HEIGHT, 0, 0, 0, 1, 1, 1, ColorUtil.WHITE, 1),
    new DefaultVertex(GRID_SERVICE_PIXEL_WIDTH, GRID_SERVICE_PIXEL_HEIGHT, 0, 0, 0, 1, 1, 1, ColorUtil.WHITE, 1),
    new DefaultVertex(0, GRID_SERVICE_PIXEL_HEIGHT, 0, 0, 0, 1, 0, 1, ColorUtil.WHITE, 1),
    new DefaultVertex(0, 0, 0, 0, 0, 1, 0, 0, ColorUtil.WHITE, 1)
  ])).build().buffer

  ///@type {BKTGlitch}
  bktGlitchService = new BKTGlitchService()

  ///@private
  ///@type {Timer}
  ///@description Z demo
  playerZTimer = new Timer(pi * 2, { loop: Infinity }) 

  ///@private
  ///@type {Struct}
  player2DCoords = { x: 0, y: 0 }

  ///@private
  ///@type {Sprite}
  playerHintPointer = Assert.isType(SpriteUtil.parse({ name: "texture_bullet" }), Sprite)

  ///@private
  ///@type {Font}
  playerHintFont = Assert.isType(FontUtil.parse({ name: "font_inter_24_regular" }), Font)

  ///@private
  ///@param {Texture}
  textureLine = new Texture(texture_grid_line_alpha)

  ///@private
  ///@return {GridRenderer}
  renderSeparators = function() {
    //return this;
    var gridService = this.controller.gridService
    var properties = gridService.properties
    var view = gridService.view
    if (!properties.renderGrid) || (properties.separators <= 0) {
      return this
    }

    var separators = properties.separators
    var primaryColor = properties.separatorsPrimaryColor.toGMColor()
    var primaryAlpha = properties.separatorsPrimaryAlpha
    var primaryThickness = properties.separatorsPrimaryThickness
    var secondaryColor = properties.separatorsSecondaryColor.toGMColor()
    var secondaryAlpha = properties.separatorsSecondaryAlpha
    var secondaryThickness = gridService.properties.separatorsSecondaryThickness
    var separatorHeight = (view.height * 2) / separators
    var time = gridService.properties.separatorTimer.time
    var offset = 2.0
    var separatorsSize = separators * 3
    var secondaryTreshold = separatorsSize / 3
    var duration = gridService.properties.separatorTimer.duration

    var borderRatio = clamp(1.0 - (time / duration), 0.0, 1.0)
    var size = floor(separatorsSize)
    var primaryBegin = round(secondaryTreshold)
    var primaryEnd = round(size - secondaryTreshold)
    for (var index = -1 * primaryBegin; index <= primaryBegin; index++) {
      var beginX = -4.0 * GRID_SERVICE_PIXEL_WIDTH
      var beginY = ((-6.0 * view.height) + (index * separatorHeight) + offset + time) * GRID_SERVICE_PIXEL_HEIGHT
      var endX = (view.width + 4.0) * GRID_SERVICE_PIXEL_WIDTH
      var endY = beginY
      var _alpha = index == (-1 * primaryBegin) ? secondaryAlpha * (1.0 - borderRatio) : secondaryAlpha
      if (index + 1 > primaryBegin) {
        _alpha = secondaryAlpha * borderRatio
      } else if (index < 0.0) {
        _alpha = ((primaryBegin - abs(index)) / primaryBegin) * _alpha
      }

      GPU.render.texturedLineSimple(
        beginX, beginY, 
        endX, endY, 
        secondaryThickness, 
        _alpha, 
        secondaryColor,
        this.textureLine
      )
    }

    for (var index = primaryEnd; index <= size; index++) {
      var beginX = -4.0 * GRID_SERVICE_PIXEL_WIDTH
      var beginY = ((-6 * view.height) + (index * separatorHeight) + offset + time) * GRID_SERVICE_PIXEL_HEIGHT
      var endX = (view.width + 4.0) * GRID_SERVICE_PIXEL_WIDTH
      var endY = beginY
      var _alpha = index == primaryEnd ? secondaryAlpha * (1.0 - borderRatio) : secondaryAlpha
      if (index + 1 > size) {
        _alpha = secondaryAlpha * borderRatio
      }

      GPU.render.texturedLineSimple(
        beginX, beginY, 
        endX, endY, 
        secondaryThickness, 
        _alpha, 
        secondaryColor,
        this.textureLine
      )
    }

    for (var index = primaryBegin; index <= primaryEnd; index++) {
      var beginX = -4.0 * GRID_SERVICE_PIXEL_WIDTH
      var beginY = ((-6 * view.height) + (index * separatorHeight) + offset + time) * GRID_SERVICE_PIXEL_HEIGHT
      var endX = (view.width + 4.0) * GRID_SERVICE_PIXEL_WIDTH
      var endY = beginY
      var alpha = index == primaryBegin ? primaryAlpha * (1.0 - borderRatio) : primaryAlpha
      if (index + 1 > primaryEnd) {
        alpha = primaryAlpha * borderRatio
      }
      var thickness = index == primaryBegin ? primaryThickness * (1.0 - borderRatio) : primaryThickness
      if (index + 1 > primaryEnd) {
        thickness = primaryThickness * borderRatio
      }

      GPU.render.texturedLineSimple(
        beginX, beginY, 
        endX, endY, 
        max(thickness, secondaryThickness), 
        alpha, 
        primaryColor,
        this.textureLine
      )
    }

    return this
  }

  ///@private
  ///@return {GridRenderer}
  renderChannels = function() {

    var gridService = this.controller.gridService
    var properties = gridService.properties
    if (!gridService.properties.renderGrid || properties.channels <= 0) {
      return this
    }

    var view = gridService.view
    var primaryColor = properties.channelsPrimaryColor.toGMColor()
    var primaryAlpha = properties.channelsPrimaryAlpha
    var primaryThickness = properties.channelsPrimaryThickness
    var secondaryColor = properties.channelsSecondaryColor.toGMColor()
    var secondaryAlpha = properties.channelsSecondaryAlpha
    var secondaryThickness = properties.channelsSecondaryThickness
    var channels = properties.channels
    var channelWidth = view.width / channels
    var viewXOffset = channelWidth * (floor(view.x / view.width) - view.x)
    var thickness = primaryThickness
    var alpha = primaryAlpha
    var color = primaryColor
    var viewHeight = gridService.view.height
    var borderSize = 5.0
    var primaryBeginIdx = ceil(borderSize * channels)
    var primaryEndIdx = primaryBeginIdx + floor(channels) 
    var idx = 0

    var _borderSize = borderSize * channels
    for (var index = -1 * borderSize * channels; index <= channels + borderSize * channels; index++) {
      var beginX = (viewXOffset + (index * channelWidth)) * GRID_SERVICE_PIXEL_WIDTH
      var beginY = -6.0 * GRID_SERVICE_PIXEL_HEIGHT
      var endX = beginX
      var endY = (viewHeight + 6.0) * GRID_SERVICE_PIXEL_HEIGHT
      var _thickness = index >= 0 && index < channels ? primaryThickness : secondaryThickness
      var _alpha = _thickness == primaryThickness ? primaryAlpha : secondaryAlpha
      var _color = _thickness == primaryThickness ? primaryColor : secondaryColor
      
      if (idx == primaryBeginIdx) {
        var factorA = (abs(viewXOffset) / channelWidth)
        var factorB = 1.0 - (abs(viewXOffset) / channelWidth)
        GPU.render.texturedLineSimple(beginX, beginY, endX, endY, secondaryThickness, secondaryAlpha * factorA, secondaryColor, this.textureLine) 
        GPU.render.texturedLineSimple(beginX, beginY, endX, endY, primaryThickness * factorB, primaryAlpha, primaryColor, this.textureLine)
      } else if (idx == primaryEndIdx) {
        var factorA = 1.0 - (abs(viewXOffset) / channelWidth)
        var factorB = (abs(viewXOffset) / channelWidth)
        GPU.render.texturedLineSimple(beginX, beginY, endX, endY, secondaryThickness, secondaryAlpha * factorA, secondaryColor, this.textureLine) 
        GPU.render.texturedLineSimple(beginX, beginY, endX, endY, primaryThickness * factorB, primaryAlpha, primaryColor, this.textureLine)
      } else {
        if (index < 0) {
          _alpha = _alpha * ((index + _borderSize) / _borderSize)
        } else if (index > channels) {
          _alpha = _alpha * (_borderSize - (index - channels)) / _borderSize
        }
        
        GPU.render.texturedLineSimple(beginX, beginY, endX, endY, _thickness, _alpha, _color, this.textureLine)
      }
      
      idx = idx + 1
    }
    return this
  }

  ///@private
  renderBorders = function() {
    static renderTop = function(controller) {
      if (!controller.gridService.targetLocked.isLockedY) {
        return
      }

      var gridService = this.controller.gridService
      var view = gridService.view
      var height = gridService.properties.borderVerticalLength
      var beginX = -3.0 * GRID_SERVICE_PIXEL_WIDTH
      var anchorY = view.y//(view.height * floor(view.y / view.height))
      var beginY = GRID_SERVICE_PIXEL_HEIGHT * (clamp(anchorY - height + (view.height / 2.0), 0.0, view.worldHeight) - view.y)
      var endX = (3.0 + view.width) * GRID_SERVICE_PIXEL_WIDTH
      var endY = beginY
      GPU.render.texturedLineSimple(
        beginX, beginY, endX, endY, 
        gridService.properties.borderVerticalThickness, 
        gridService.properties.borderVerticalAlpha,
        gridService.properties.borderVerticalColor.toGMColor(),
        this.textureLine
      )
    }

    static renderBottom = function(controller) {
      var gridService = this.controller.gridService
      var view = gridService.view
      var height = gridService.properties.borderVerticalLength
      var anchorY = view.y//view.height * floor(view.y / view.height)
      var beginX = GRID_SERVICE_PIXEL_WIDTH * -3.0
      var beginY = GRID_SERVICE_PIXEL_HEIGHT * (controller.gridService.targetLocked.isLockedY
        ? clamp(anchorY + height + (view.height / 2.0), 0.0, view.worldHeight) - view.y
        : clamp(view.worldHeight - view.y, 0.0, view.worldHeight))
      var endX = GRID_SERVICE_PIXEL_WIDTH * (view.width + 3.0)
      var endY = beginY
      GPU.render.texturedLineSimple(
        beginX, beginY, endX, endY, 
        gridService.properties.borderVerticalThickness, 
        gridService.properties.borderVerticalAlpha,
        gridService.properties.borderVerticalColor.toGMColor(),
        this.textureLine
      )
    }

    static renderRight = function(controller) {
      var gridService = this.controller.gridService
      var view = gridService.view
      var beginX = (0.5 + gridService.properties.borderHorizontalLength) * GRID_SERVICE_PIXEL_WIDTH
      var beginY = -3.0 * GRID_SERVICE_PIXEL_HEIGHT
      var endX = beginX
      var endY = (3.0 + view.height) * GRID_SERVICE_PIXEL_HEIGHT

      GPU.render.texturedLineSimple(
        beginX, beginY, endX, endY, 
        gridService.properties.borderHorizontalThickness, 
        gridService.properties.borderHorizontalAlpha,
        gridService.properties.borderHorizontalColor.toGMColor(),
        this.textureLine
      )
    }

    static renderLeft = function(controller) {
      var gridService = this.controller.gridService
      var view = gridService.view
      var beginX = (0.5 - gridService.properties.borderHorizontalLength) * GRID_SERVICE_PIXEL_WIDTH
      var beginY = -3.0 * GRID_SERVICE_PIXEL_HEIGHT
      var endX = beginX
      var endY = (3.0 + view.height) * GRID_SERVICE_PIXEL_HEIGHT
      
      GPU.render.texturedLineSimple(
        beginX, beginY, endX, endY, 
        gridService.properties.borderHorizontalThickness, 
        gridService.properties.borderHorizontalAlpha,
        gridService.properties.borderHorizontalColor.toGMColor(),
        this.textureLine
      )
    }

    renderTop(this.controller)
    renderBottom(this.controller)
    renderLeft(this.controller)
    renderRight(this.controller)
  }

  ///@private
  ///@param {Number} baseX
  ///@param {Number} baseY
  ///@return {GridRenderer}
  renderPlayer = function(baseX, baseY) { 
    var player = this.controller.playerService.player
    if (!this.controller.gridService.properties.renderElements
      || !Core.isType(player, Player)) {
      this.player2DCoords.x = null
      this.player2DCoords.y = null
      return this
    }

    var gridService = this.controller.gridService
    var useBlendAsZ = false
    if (useBlendAsZ) {
      shader_set(shader_gml_use_blend_as_z)
      shader_set_uniform_f(shader_get_uniform(shader_gml_use_blend_as_z, "size"), 1024.0)
      player.sprite.blend = (sin(this.playerZTimer.update().time) * 0.5 + 0.5) * 255     
      player.sprite.render(
        (player.x - (player.sprite.texture.width / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) + ((player.sprite.texture.offsetX * player.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH)  - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (player.y - (player.sprite.texture.height / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) + ((player.sprite.texture.offsetY * player.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT)  - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT
      )
      
      /*
      GPU.render.rectangle(
        (player.x - ((player.mask.getWidth() * player.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (player.y - ((player.mask.getHeight() * player.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        (player.x + ((player.mask.getWidth() * player.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (player.y + ((player.mask.getHeight() * player.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        false, 
        c_lime
      )
      */
      
      shader_reset()
    } else {
      var _x = (player.x - ((player.sprite.texture.width * player.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) + ((player.sprite.texture.offsetX * player.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
      var _y = (player.y - ((player.sprite.texture.height * player.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) + ((player.sprite.texture.offsetY * player.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT
      var alpha = player.sprite.alpha
      player.sprite
        .setAlpha(alpha * ((cos(player.stats.godModeCooldown * 15.0) + 2.0) / 3.0))
        .render(_x, _y)
        .setAlpha(alpha)
      this.player2DCoords = Math.project3DCoordsOn2D(_x + baseX, _y + baseY,this.controller.gridService.properties.depths.playerZ, this.camera.viewMatrix, this.camera.projectionMatrix, this.gridSurface.width, this.gridSurface.height)
      /*
      GPU.render.rectangle(
        (player.x - ((player.mask.getWidth() * player.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (player.y - ((player.mask.getHeight() * player.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        (player.x + ((player.mask.getWidth() * player.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (player.y + ((player.mask.getHeight() * player.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        false, 
        c_lime
      )
      */
    }
    
    return this
  }

  ///@private
  ///@return {GridRenderer}
  renderShrooms = function() {
    static renderShroom = function(shroom, index, gridService) {
      var alpha = shroom.sprite.getAlpha()
      shroom.sprite
        .setAlpha(alpha * shroom.fadeIn)
        .render(
          (shroom.x - ((shroom.sprite.texture.width * shroom.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) + ((shroom.sprite.texture.offsetX * shroom.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH)  - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
          (shroom.y - ((shroom.sprite.texture.height * shroom.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) + ((shroom.sprite.texture.offsetY * shroom.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT
        )
        .setAlpha(alpha)
      
      /*
      GPU.render.rectangle(
        (shroom.x - ((shroom.mask.getWidth() * shroom.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (shroom.y - ((shroom.mask.getHeight() * shroom.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        (shroom.x + ((shroom.mask.getWidth() * shroom.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (shroom.y + ((shroom.mask.getHeight() * shroom.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        false, 
        c_red
      )
      */
    }

    var gridService = this.controller.gridService
    if (!gridService.properties.renderElements 
      || !gridService.properties.renderShrooms) {
      return this
    }

    this.controller.shroomService.shrooms.forEach(renderShroom, gridService)

    // Render spawner
    var spawner = this.controller.shroomService.spawner
    if (Core.isType(spawner, Struct)) {
      spawner.sprite.render(
        (spawner.x * GRID_SERVICE_PIXEL_WIDTH) - ((spawner.sprite.getWidth() * spawner.sprite.getScaleX()) / 2.0), 
        (spawner.y * GRID_SERVICE_PIXEL_HEIGHT) - ((spawner.sprite.getHeight() * spawner.sprite.getScaleY()) / 2.0)
      )

      this.controller.shroomService.spawner.timeout--
      if (this.controller.shroomService.spawner.timeout <= 0) {
        this.controller.shroomService.spawner = null
      }
    }

    var spawnerEvent = this.controller.shroomService.spawnerEvent
    if (Core.isType(spawnerEvent, Struct)) {
      spawnerEvent.sprite.render(
        (spawnerEvent.x * GRID_SERVICE_PIXEL_WIDTH) - ((spawnerEvent.sprite.getWidth() * spawnerEvent.sprite.getScaleX()) / 2.0), 
        (spawnerEvent.y * GRID_SERVICE_PIXEL_HEIGHT) - ((spawnerEvent.sprite.getHeight() * spawnerEvent.sprite.getScaleY()) / 2.0)
      )

      this.controller.shroomService.spawnerEvent.timeout--
      if (this.controller.shroomService.spawnerEvent.timeout <= 0) {
        this.controller.shroomService.spawnerEvent = null
      }
    }

    // Render particleArea
    var particleArea = this.controller.shroomService.particleArea
    if (Core.isType(particleArea, Struct)) {
      particleArea.topLeft.sprite.render(
        particleArea.topLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        particleArea.topLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleArea.topRight.sprite.render(
        particleArea.topRight.x * GRID_SERVICE_PIXEL_WIDTH,
        particleArea.topRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleArea.bottomLeft.sprite.render(
        particleArea.bottomLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        particleArea.bottomLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleArea.bottomRight.sprite.render(
        particleArea.bottomRight.x * GRID_SERVICE_PIXEL_WIDTH,
        particleArea.bottomRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )

      this.controller.shroomService.particleArea.timeout--
      if (this.controller.shroomService.particleArea.timeout <= 0) {
        this.controller.shroomService.particleArea = null
      }
    }

    var particleAreaEvent = this.controller.shroomService.particleAreaEvent
    if (Core.isType(particleAreaEvent, Struct)) {
      particleAreaEvent.topLeft.sprite.render(
        particleAreaEvent.topLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        particleAreaEvent.topLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleAreaEvent.topRight.sprite.render(
        particleAreaEvent.topRight.x * GRID_SERVICE_PIXEL_WIDTH,
        particleAreaEvent.topRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleAreaEvent.bottomLeft.sprite.render(
        particleAreaEvent.bottomLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        particleAreaEvent.bottomLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      particleAreaEvent.bottomRight.sprite.render(
        particleAreaEvent.bottomRight.x * GRID_SERVICE_PIXEL_WIDTH,
        particleAreaEvent.bottomRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )

      this.controller.shroomService.particleAreaEvent.timeout--
      if (this.controller.shroomService.particleAreaEvent.timeout <= 0) {
        this.controller.shroomService.particleAreaEvent = null
      }
    }

    // Render playerBorder
    var playerBorder = this.controller.shroomService.playerBorder
    if (Core.isType(playerBorder, Struct)) {
      playerBorder.topLeft.sprite.render(
        playerBorder.topLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorder.topLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorder.topRight.sprite.render(
        playerBorder.topRight.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorder.topRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorder.bottomLeft.sprite.render(
        playerBorder.bottomLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorder.bottomLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorder.bottomRight.sprite.render(
        playerBorder.bottomRight.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorder.bottomRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )

      this.controller.shroomService.playerBorder.timeout--
      if (this.controller.shroomService.playerBorder.timeout <= 0) {
        this.controller.shroomService.playerBorder = null
      }
    }

    var playerBorderEvent = this.controller.shroomService.playerBorderEvent
    if (Core.isType(playerBorderEvent, Struct)) {
      playerBorderEvent.topLeft.sprite.render(
        playerBorderEvent.topLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorderEvent.topLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorderEvent.topRight.sprite.render(
        playerBorderEvent.topRight.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorderEvent.topRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorderEvent.bottomLeft.sprite.render(
        playerBorderEvent.bottomLeft.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorderEvent.bottomLeft.y * GRID_SERVICE_PIXEL_HEIGHT,
      )
      playerBorderEvent.bottomRight.sprite.render(
        playerBorderEvent.bottomRight.x * GRID_SERVICE_PIXEL_WIDTH,
        playerBorderEvent.bottomRight.y * GRID_SERVICE_PIXEL_HEIGHT,
      )

      this.controller.shroomService.playerBorderEvent.timeout--
      if (this.controller.shroomService.playerBorderEvent.timeout <= 0) {
        this.controller.shroomService.playerBorderEvent = null
      }
    }

    return this
  }

  ///@private
  ///@return {GridRenderer}
  renderBullets = function() {
    static renderBullet = function(bullet, index, gridService) {
      bullet.sprite
        .setAngle(bullet.angle)
        .render(
          (bullet.x - ((bullet.sprite.texture.width * bullet.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) + ((bullet.sprite.texture.offsetX * bullet.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
          (bullet.y - ((bullet.sprite.texture.height * bullet.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) + ((bullet.sprite.texture.offsetY * bullet.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT
        )

      /*
      GPU.render.rectangle(
        (bullet.x - ((bullet.mask.getWidth() * bullet.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (bullet.y - ((bullet.mask.getHeight() * bullet.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        (bullet.x + ((bullet.mask.getWidth() * bullet.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (bullet.y + ((bullet.mask.getHeight() * bullet.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        false, 
        c_blue
      )
      */
    }
    
    var gridService = this.controller.gridService
    if (!gridService.properties.renderElements
        || !gridService.properties.renderBullets) {
      return this
    }

    this.controller.bulletService.bullets.forEach(renderBullet, gridService)
    return this
  }

    ///@private
  ///@return {GridRenderer}
  renderCoins = function() {
    static renderCoin = function(coin, index, gridService) {
      coin.sprite
        .render(
          (coin.x - ((coin.sprite.texture.width * coin.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) + ((coin.sprite.texture.offsetX * coin.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
          (coin.y - ((coin.sprite.texture.height * coin.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) + ((coin.sprite.texture.offsetY * coin.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT
        )

      /*
      GPU.render.rectangle(
        (coin.x - ((coin.mask.getWidth() * coin.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (coin.y - ((coin.mask.getHeight() * coin.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        (coin.x + ((coin.mask.getWidth() * coin.sprite.scaleX) / (2.0 * GRID_SERVICE_PIXEL_WIDTH)) - gridService.view.x) * GRID_SERVICE_PIXEL_WIDTH,
        (coin.y + ((coin.mask.getHeight() * coin.sprite.scaleY) / (2.0 * GRID_SERVICE_PIXEL_HEIGHT)) - gridService.view.y) * GRID_SERVICE_PIXEL_HEIGHT,
        false, 
        c_orange
      )
      */
    }
    
    var gridService = this.controller.gridService
    if (!gridService.properties.renderElements
        || !gridService.properties.renderCoins) {
      return this
    }

    this.controller.coinService.coins.forEach(renderCoin, gridService)
    return this
  }

  ///@private
  ///@return {GridRenderer}
  renderParticles = function() {
    if (!this.controller.gridService.properties.renderParticles) {
      return this
    }

    this.controller.particleService.systems.get("main").render()
    return this
  }

  ///@private
  ///@return {GridRenderer}
  renderBackground = function() {
    if (!this.controller.gridService.properties.renderBackground) {
      return this
    }

    this.backgroundSurface.render()
    var shaderPipeline = this.controller.shaderBackgroundPipeline
    if (this.controller.gridService.properties.renderBackgroundShaders 
      && shaderPipeline.executor.tasks.size() > 0) {
      shaderPipeline
        .setWidth(this.backgroundSurface.width)
        .setHeight(this.backgroundSurface.height)
        .render(function(task, index, renderer) {
        var properties = renderer.controller.gridService.properties
        var alpha = task.state.getDefault("alpha", 1.0)
        renderer.backgroundSurface.render(0, 0, alpha)
      }, this)
    }
  }

  ///@private
  ///@param {GridRenderer} renderer
  renderForeground = function() {
    if (!this.controller.gridService.properties.renderForeground) {
      return this
    }

    var width = this.backgroundSurface.width
    var height = this.backgroundSurface.height
    this.overlayRenderer.renderForegrounds(width, height)
    return this
  }
  
  ///@private
  ///@param {GridRenderer} renderer
  renderBackgroundSurface = function(renderer) {
    var properties = renderer.controller.gridService.properties
    var width = this.backgroundSurface.width
    var height = this.backgroundSurface.height
    GPU.render.clear(properties.backgroundColor)
    if (properties.renderVideo) {
      renderer.overlayRenderer.renderVideo(width, height) 
    }

    if (properties.renderBackground) {
      renderer.overlayRenderer.renderBackgrounds(width, height)
    }
  }

  ///@private
  ///@param {GridRenderer} renderer
  renderGridSurface = function(renderer) {
    var properties = renderer.controller.gridService.properties
    if (properties.gridClearFrame) {
      GPU.render.clear(properties.gridClearColor)
    }

    var depths = renderer.controller.gridService.properties.depths
      
    var cameraDistance = 1 ///@todo extract parameter
    var xto = renderer.camera.x
    var yto = renderer.camera.y
    var zto = renderer.camera.z + renderer.camera.zoom
    var xfrom = xto + cameraDistance * dcos(renderer.camera.angle) * dcos(renderer.camera.pitch)
    var yfrom = yto - cameraDistance * dsin(renderer.camera.angle) * dcos(renderer.camera.pitch)
    var zfrom = zto - cameraDistance * dsin(renderer.camera.pitch)
    var baseX = GRID_SERVICE_PIXEL_WIDTH + GRID_SERVICE_PIXEL_WIDTH * 0.5
    var baseY = GRID_SERVICE_PIXEL_HEIGHT + GRID_SERVICE_PIXEL_HEIGHT * 0.5
    renderer.camera.viewMatrix = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1)
    renderer.camera.projectionMatrix = matrix_build_projection_perspective_fov(-60, -1 * renderer.gridSurface.width / renderer.gridSurface.height, 1, 32000) ///@todo extract parameters
    camera_set_view_mat(renderer.camera.gmCamera, renderer.camera.viewMatrix)
    camera_set_proj_mat(renderer.camera.gmCamera, renderer.camera.projectionMatrix)
    camera_apply(renderer.camera.gmCamera)

    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.channelZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderChannels()
    
    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.separatorZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderSeparators()

    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.coinZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderCoins()

    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.bulletZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderBullets()

    gpu_set_alphatestenable(true)
    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.shroomZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderShrooms()
    gpu_set_alphatestenable(false)

    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.particleZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderParticles()

    matrix_set(matrix_world, matrix_build(
      baseX, baseY, depths.playerZ, 
      0, 0, 0, 
      1, 1, 1
    ))
    renderer.renderBorders()
    renderer.renderPlayer(baseX, baseY)

    matrix_set(matrix_world, matrix_build_identity())
  }

  ///@private
  ///@param {GridRenderer} renderer
  renderShaderSurface = function(renderer) {
    var properties = renderer.controller.gridService.properties
    if (!properties.renderGridShaders) {
      return
    }

    if (properties.shaderClearFrame) {
      GPU.render.clear(properties.shaderClearColor)
    }

    var size = renderer.controller.shaderPipeline
      .setWidth(renderer.gridSurface.width)
      .setHeight(renderer.gridSurface.height)
      .render(function(task, index, renderer) {
        renderer.gridSurface.render(0, 0, task.state
          .getDefault("alpha", 1.0))
      }, renderer)
      .executor.tasks.size()

    // Render support-grid
    if (properties.renderSupportGrid 
      && size >= properties.renderSupportGridTreshold) {

      GPU.set.blendMode(BlendMode.ADD)
      renderer.gridSurface.render(0, 0, properties.renderSupportGridAlpha)
      GPU.reset.blendMode()
    }
  }

  ///@private
  ///@param {GridRenderer} renderer
  renderGameSurface = function(renderer) {
    GPU.render.clear(renderer.controller.gridService.properties.clearColor)
    renderer.renderBackground() 
    renderer.gridSurface.render()
    renderer.shaderSurface.render()
    renderer.renderForeground()
  }

  ///@private
  ///@return {GridRenderer}
  renderBKTGlitch = function(config) {
    var width = Struct.contains(config, "width") ? config.width : GuiWidth()
    var height = Struct.contains(config, "height") ? config.height : GuiHeight()
    var _x = Struct.contains(config, "x") ? config.x : 0
    var _y = Struct.contains(config, "y") ? config.y : 0
    this.gameSurface.update(width, height).render(_x, _y)
    return this
  }

  ///@private
  ///@return {GrindRenderer}
  renderPlayerHint = function(config) {
    if ((this.player2DCoords.x != null && this.player2DCoords.y != null) 
      && (this.player2DCoords.x < 0 
        || this.player2DCoords.x > this.gridSurface.width 
        || this.player2DCoords.y < 0 
        || this.player2DCoords.y > this.gridSurface.height)) {

      var configX = Core.isType(Struct.get(config, "x"), Number) ? config.x : 0.0
      var configY = Core.isType(Struct.get(config, "y"), Number) ? config.y : 0.0
      var player = this.controller.playerService.player
      var _x = clamp(this.player2DCoords.x, player.sprite.getWidth() - player.sprite.texture.offsetX, this.gridSurface.width - player.sprite.getWidth() + player.sprite.texture.offsetX)
      var _y = clamp(this.player2DCoords.y, player.sprite.getHeight() - player.sprite.texture.offsetY, this.gridSurface.height - player.sprite.getHeight() + player.sprite.texture.offsetY)
      var alpha = player.sprite.getAlpha()
      player.sprite
        .setAlpha(alpha * 0.5)
        .render(configX + _x, configY + _y)
        .setAlpha(alpha)

      var angle = Math.fetchAngle(_x, _y, this.player2DCoords.x, this.player2DCoords.y)
      this.playerHintPointer
        .setAngle(angle)
        .setAlpha(0.8)
        .render(
          configX + _x + Math.fetchCircleX(player.sprite.getWidth() / 3, angle),
          configY + _y + Math.fetchCircleY(player.sprite.getHeight() / 3, angle)
        )
      
      var length = round(Math.fetchLength(_x, _y, this.player2DCoords.x, this.player2DCoords.y))
      GPU.render.text(
        configX + _x,
        configY + _y,
        string(length),
        c_white,
        c_black,
        1.0,
        this.playerHintFont, 
        HAlign.CENTER,
        VAlign.CENTER
      )
    }

    return this
  }

  ///@return {GridRenderer}
  clear = function() {
    this.camera = new GridCamera()
    this.overlayRenderer.clear()
    return this
  }

  ///@return {GridRenderer}
  update = function() {
    this.camera.update()
    this.overlayRenderer.update()
    this.bktGlitchService.update(GuiWidth(), GuiHeight())
  }

  ///@return {GridRenderer}
  render = function(config) {
    var width = Struct.contains(config, "width") ? config.width : GuiWidth()
    var height = Struct.contains(config, "height") ? config.height : GuiHeight()
    this.backgroundSurface
      .update(width, height)
      .renderOn(this.renderBackgroundSurface, this)
    this.gridSurface
      .update(width, height)
      .renderOn(this.renderGridSurface, this)
    this.shaderSurface
      .update(width, height)
      .renderOn(renderShaderSurface, this)
    this.gameSurface
      .update(width, height)
      .renderOn(this.renderGameSurface, this)

    return this
  }

  ///@param {?Struct} [config]
  ///@return {GridRenderer}
  renderGUI = function(config = null) {
    this.bktGlitchService.renderOn(this.renderBKTGlitch, config)
    this.renderPlayerHint(config)
    return this
  }

  ///@return {GridRenderer}
  free = function() {
    this.backgroundSurface.free()
    this.gridSurface.free()
    this.gameSurface.free()
    this.shaderSurface.free()
    return this
  }
}

