///@package io.alkapivo.visu

#macro BeanVisuIO "VisuIO"
function VisuIO() constructor {

  ///@type {Keyboard}
  keyboard = new Keyboard({ 
    controlTrack: KeyboardKeyType.SPACE,
    cameraKeyboardLook: KeyboardKeyType.F6,
    cameraMouseLook: KeyboardKeyType.F7,
    fullscreen: KeyboardKeyType.F11,
    controlLeft: KeyboardKeyType.CONTROL_LEFT,
    openProject: "O",
  })

  ///@type {Mouse}
  mouse = new Mouse({ 
    left: MouseButtonType.LEFT,
    right: MouseButtonType.RIGHT,
    wheelUp: MouseButtonType.WHEEL_UP,
    wheelDown: MouseButtonType.WHEEL_DOWN,
  })

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  controlTrackKeyboardEvent = function(controller) {
    if (GMTFContext.isFocused()) {
      return
    }

    if (this.keyboard.keys.controlTrack.pressed) {
      switch (controller.fsm.getStateName()) {
        case "play": controller.send(new Event("pause")) break
        case "pause": controller.send(new Event("play")) break
      }
    }

    if (this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.openProject.pressed) {
      try {
        if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
          controller.send(new Event("spawn-popup", 
            { message: $"Feature 'visu.open' is not available on wasm-yyc target" }))
          return
        }

        var manifest = FileUtil.getPathToOpenWithDialog({ 
          description: "Visu track file",
          filename: "manifest", 
          extension: "visu"
        })

        if (!FileUtil.fileExists(manifest)) {
          return
        }

        controller.send(new Event("load", {
          manifest: FileUtil.get(manifest),
          autoplay: false
        }))
      } catch (exception) {
        controller.send(new Event("spawn-popup", 
          { message: $"Cannot load the project: {exception.message}" }))
      }
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  fullscreenKeyboardEvent = function(controller) {
    if (this.keyboard.keys.fullscreen.pressed) {
      var fullscreen = controller.displayService.getFullscreen()
      Logger.debug("VisuIO", String.join("Set fullscreen to ", fullscreen ? "'false'" : "'true'", "."))
      controller.displayService.setFullscreen(!fullscreen)
    }
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  functionKeyboardEvent = function(controller) {
    if (this.keyboard.keys.cameraKeyboardLook.pressed) {
      controller.visuRenderer.gridRenderer.camera.enableKeyboardLook = !controller.visuRenderer.gridRenderer.camera.enableKeyboardLook
    }

    if (this.keyboard.keys.cameraMouseLook.pressed) {
      controller.visuRenderer.gridRenderer.camera.enableMouseLook = !controller.visuRenderer.gridRenderer.camera.enableMouseLook
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  mouseEvent = function(controller) {
    static generateMouseEvent = function(name) {
      return new Event(name, { 
        x: MouseUtil.getMouseX(), 
        y: MouseUtil.getMouseY(),
      })
    }

    if (this.mouse.buttons.left.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedLeft"))
    }

    if (this.mouse.buttons.left.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedLeft"))
      controller.displayService.setCursor(Cursor.DEFAULT)
    }

    if (this.mouse.buttons.left.drag) {
      controller.uiService.send(generateMouseEvent("MouseDragLeft"))
    }

    if (this.mouse.buttons.left.drop) {
      controller.uiService.send(generateMouseEvent("MouseDropLeft"))
    }

    if (this.mouse.buttons.right.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedRight"))
    }

    if (this.mouse.buttons.right.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedRight"))
    }
    
    if (this.mouse.buttons.wheelUp.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelUp"))
    }
    
    if (this.mouse.buttons.wheelDown.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelDown"))
    }

    if (MouseUtil.hasMoved()) {  
      controller.uiService.send(generateMouseEvent("MouseHoverOver"))
    }

    return this
  }

  ///@return {VisuIO}
  update = function() {
    try {
      this.keyboard.update()
      this.mouse.update()  
      GMTFContext.update()
      
      var controller = Beans.get(BeanVisuController)
      if (!Core.isType(controller, VisuController)) {
        return this
      }

      this.controlTrackKeyboardEvent(controller)
      this.fullscreenKeyboardEvent(controller)
      this.functionKeyboardEvent(controller)
      this.mouseEvent(controller)
    } catch (exception) {
      var message = $"'VisuIO.update' fatal error: {exception.message}"
      Logger.error(BeanVisuIO, message)

      var controller = Beans.get(BeanVisuController)
      if (Core.isType(controller, VisuController)) {
        controller.send(new Event("spawn-popup", { message: message }))
      }
    }

    return this
  }
}