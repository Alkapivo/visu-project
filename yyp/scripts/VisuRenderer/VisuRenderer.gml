///@package io.alkapivo.visu.renderer

function VisuRenderer() constructor {

  ///@type {GridRenderer}
  gridRenderer = new GridRenderer()

  ///@type {SubtitleRenderer}
  subtitleRenderer = new SubtitleRenderer()

  ///@type {VisuHUDRenderer}
  hudRenderer = new VisuHUDRenderer()

  ///@type {DialogueRenderer}
  dialogueRenderer = new DialogueRenderer()

  ///@private
  ///@type {UILayout}
  layout = new UILayout({
    name: "visu-game-layout",
    x: function() { return 0 },
    y: function() { return 0 },
    width: GuiWidth,
    height: GuiHeight,
  })

  ///@private
  ///@type {DebugTimer}
  renderTimer = new DebugTimer("Render")
  
  ///@private
  ///@type {DebugTimer}
  renderGUITimer = new DebugTimer("RenderGUI")

  ///@private
  ///@type {Sprite}
  spinner = Assert.isType(SpriteUtil
    .parse({ 
      name: "texture_spinner", 
      scaleX: 0.25, 
      scaleY: 0.25,
    }), Sprite)

  ///@private
  ///@type {Number}
  spinnerFactor = 0

  ///@private
  ///@type {Timer}
  initTimer = new Timer(0.35)

  ///@private
  ///@type {NumberTransformer}
  blur = new NumberTransformer({
    value: 0.0,
    target: 32.0,
    factor: 0.5,
    increase: 0.005,
  })

  ///@private
  ///@type {Font}
  font = new Font(font_kodeo_mono_18_bold)

  ///@private
  ///@type {Boolean}
  renderEditorMode = Core.getProperty("visu.editor.renderEditorMode", false)

  ///@private
  ///@return {VisuRenderer}
  init = function() {
    return this
  }

  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderSpinner = function(layout) {
    var controller = Beans.get(BeanVisuController)
    var loaderState = controller.loader.fsm.getStateName()
    if (loaderState != "idle" && loaderState != "cooldown" && loaderState != "loaded") {
      var color = c_black
      this.spinnerFactor = lerp(this.spinnerFactor, 100.0, 0.1)

      GPU.render.rectangle(
        0, 0, 
        GuiWidth(), GuiHeight(), 
        false, 
        color, color, color, color, 
        (this.spinnerFactor / 100) * 0.5
      )

      this.spinner
        .setAlpha(this.spinnerFactor / 100.0)
        .render(
          (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
          (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
            - (this.spinnerFactor / 2)
      )
    } else if (this.spinnerFactor > 0) {
      var color = c_black
      this.spinnerFactor = lerp(this.spinnerFactor, 0.0, 0.1)

      GPU.render.rectangle(
        0, 0, 
        GuiWidth(), GuiHeight(), 
        false, 
        color, color, color, color, 
        (this.spinnerFactor / 100) * 0.5
      )

      this.spinner
        .setAlpha(this.spinnerFactor / 100.0)
        .render(
        (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
        (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
          - (this.spinnerFactor / 2)
      )
    }

    return this
  }

  ///@private
  ///@return {VisuRenderer}
  renderDebugGUI = function() {
    /*
    var editor = Beans.get(BeanVisuEditorController)
    if (Optional.is(editor)) {
      editor.uiService.containers.forEach(function(container, index) {
        GPU.render.text(60, 60 + (24 * index), $"#{index}: {container.name}", c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD)  
      })
    }
    */
    
    if (is_debug_overlay_open()) {
      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var shrooms = controller.shroomService.shrooms.size()
      var bullets = controller.bulletService.bullets.size()
  
      var timeSum = gridService.moveGridItemsTimer.getValue()
        + gridService.signalGridItemsCollisionTimer.getValue()
        + gridService.updatePlayerServiceTimer.getValue()
        + gridService.updateShroomServiceTimer.getValue()
        + gridService.updateBulletServiceTimer.getValue()
        + this.renderTimer.getValue()
        + this.renderGUITimer.getValue()
      gridService.avgTime.add(timeSum)        
  
      var text = $"shrooms: {shrooms}" + "\n"
        + $"bullets: {bullets}" + "\n"
        + $"fps: {fps}, fps-real: {fps_real}" + "\n\n"
        + gridService.moveGridItemsTimer.getMessage() + "\n"
        + gridService.signalGridItemsCollisionTimer.getMessage() + "\n"
        + gridService.updatePlayerServiceTimer.getMessage() + "\n"
        + gridService.updateShroomServiceTimer.getMessage() + "\n"
        + gridService.updateBulletServiceTimer.getMessage() + "\n"
        + this.renderTimer.getMessage() + "\n"
        + this.renderGUITimer.getMessage() + "\n"
        + $"Sum: {timeSum}ms" + "\n"
        + $"Avg: {gridService.avgTime.get()}ms" + "\n"
      GPU.render.text(32, 32, text, c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD)  
    }

    var gridCamera = this.gridRenderer.camera
    var gridCameraMessage = ""
    if (gridCamera.enableKeyboardLook || gridCamera.enableMouseLook) {
      gridCameraMessage = gridCameraMessage 
        + $"pitch: {gridCamera.pitch}\n"
        + $"angle: {gridCamera.angle}\n"
        + $"zoom: {gridCamera.zoom}\n"
        + $"x: {gridCamera.x}\n"
        + $"y: {gridCamera.y}\n"
        + $"z: {gridCamera.z}\n"
    }
    
    if (gridCameraMessage != "") {
      GPU.render.text(32, GuiHeight() - 32, gridCameraMessage, c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD, HAlign.LEFT, VAlign.BOTTOM)  
    }

    return this
  }

  ///@private
  ///@return {VisuRenderer}
  renderUI = function() {
    var editor = Beans.get(BeanVisuEditorController)
    if (Core.isType(editor, VisuEditorController) && editor.renderUI) {
      editor.uiService.render()
    }

    Beans.get(BeanVisuController).uiService.render()

    return this
  }

  ///@return {VisuRenderer}
  update = function() {
    if (!this.initTimer.finished) {
      this.initTimer.update()
    }

    var editor = Beans.get(BeanVisuEditorController)
    var _layout = editor == null ? this.layout : editor.layout.nodes.preview

    this.gridRenderer.update(_layout)
    this.hudRenderer.update(_layout)
    this.dialogueRenderer.update()
    return this
  }
  
  ///@return {VisuRenderer}
  render = function() {
    var editor = Beans.get(BeanVisuEditorController)
    var _layout = editor == null ? this.layout : editor.layout.nodes.preview
    
    this.renderTimer.start()
    this.gridRenderer.render(_layout)
    this.renderTimer.finish()
    return this
  }

  ///@return {VisuRenderer}
  renderGUI = function() {
    var controller = Beans.get(BeanVisuController)
    var editor = Beans.get(BeanVisuEditorController)
    var _layout = editor == null ? this.layout : editor.layout.nodes.preview

    this.renderGUITimer.start()
    if (controller.menu.containers.size() == 0) {
      this.blur.reset()
      this.gridRenderer.renderGUI(_layout)
      this.subtitleRenderer.renderGUI(_layout)  
      if (Visu.settings.getValue("visu.interface.render-hud")) {
        this.hudRenderer.renderGUI(_layout)
      }

      if (this.renderEditorMode && editor != null && !editor.renderUI) {
        var _x = _layout.x()
        var _y = _layout.y()
        var _width = _layout.width()
        var _height = _layout.height()
        var xStart = _width * (1.0 - 0.061)
        var yStart = _height * (1.0 - 0.08)
        var text = "EDITOR MODE [F5]"
        GPU.render.text(_x + xStart, _y + yStart, text, c_white, c_lime, 0.6, this.font, HAlign.RIGHT, VAlign.BOTTOM, 8.0) 
      }
      this.dialogueRenderer.render()
    } else {
      if (!Optional.is(controller.track)) {
        controller.gridService.properties.update(controller.gridService)
      }
      
      if (shader_is_compiled(shader_gaussian_blur)) {
        var uniformSize = shader_get_uniform(shader_gaussian_blur, "size")
        shader_set(shader_gaussian_blur)
        shader_set_uniform_f(uniformSize, _layout.width(), _layout.height(), this.blur.update().value)
        this.gridRenderer.renderGameplay(_layout)
        shader_reset()
      } else {
        this.gridRenderer.renderGUI(_layout)
      }
    }
    this.renderUI()
    this.renderSpinner(_layout)
    this.renderGUITimer.finish()
    this.renderDebugGUI()

    if (!this.initTimer.finished) {
      GPU.render.clear(c_black, 1.0)
    }

    return this
  }

  ///@return {VisuRenderer}
  free = function() {
    this.gridRenderer.free()
    return this
  }

  this.init()
}