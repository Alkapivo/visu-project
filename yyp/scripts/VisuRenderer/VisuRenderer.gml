///@package io.alkapivo.visu.renderer

function VisuRenderer() constructor {

  ///@type {GridRenderer}
  gridRenderer = new GridRenderer()

  ///@type {LyricsRenderer}
  lyricsRenderer = new LyricsRenderer()

  ///@type {VisuHUDRenderer}
  hudRenderer = new VisuHUDRenderer()

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
  ///@type {DebugOSTimer}
  renderTimer = new DebugOSTimer("Render")
  
  ///@private
  ///@type {DebugOSTimer}
  renderGUITimer = new DebugOSTimer("RenderGUI")

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
    if (loaderState != "idle" && loaderState != "loaded") {
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
        + $"Sum: {timeSum}" + "\n"
      GPU.render.text(32, 32, text, c_lime, c_black, 1.0, GPU_DEFAULT_FONT_BOLD)  
    }

    var gridCamera = this.gridRenderer.camera
    var gridCameraMessage = ""
    if (gridCamera.enableMouseLook) {
      gridCameraMessage = gridCameraMessage 
        + $"pitch: {gridCamera.pitch}\n"
        + $"angle: {gridCamera.angle}\n"
        + $"zoom: {gridCamera.zoom}\n"
    }

    if (gridCamera.enableKeyboardLook) {
      gridCameraMessage = gridCameraMessage 
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
    var editor = Beans.get(BeanVisuEditorController)
    var _layout = editor == null ? this.layout : editor.layout.nodes.preview

    this.renderGUITimer.start()
    this.gridRenderer.renderGUI(_layout)
    this.lyricsRenderer.renderGUI(_layout)
    this.hudRenderer.renderGUI(_layout)
    this.renderSpinner(_layout)
    this.renderUI()
    this.renderGUITimer.finish()
    this.renderDebugGUI()

    var controller = Beans.get(BeanVisuController)
    if (!this.initTimer.finished) {
      GPU.render.clear(ColorUtil.BLACK)
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