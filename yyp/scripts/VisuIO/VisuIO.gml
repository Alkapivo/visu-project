///@package io.alkapivo.visu

#macro BeanVisuIO "VisuIO"
function VisuIO() constructor {

  ///@type {Map}
  keyboards = new Map(String, Keyboard, {
    "player": new Keyboard({
      up: Visu.settings.getValue("visu.keyboard.player.up", KeyboardKeyType.ARROW_UP),
      down: Visu.settings.getValue("visu.keyboard.player.down", KeyboardKeyType.ARROW_DOWN),
      left: Visu.settings.getValue("visu.keyboard.player.left", KeyboardKeyType.ARROW_LEFT),
      right: Visu.settings.getValue("visu.keyboard.player.right", KeyboardKeyType.ARROW_RIGHT),
      action: Visu.settings.getValue("visu.keyboard.player.action", ord("Z")),
      bomb: Visu.settings.getValue("visu.keyboard.player.bomb", ord("X")),
      focus: Visu.settings.getValue("visu.keyboard.player.focus", KeyboardKeyType.SHIFT),
    })
  })

  ///@type {Keyboard}
  keyboard = new Keyboard({ 
    fullscreen: KeyboardKeyType.F11,
    openMenu: KeyboardKeyType.ESC,
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
    var menu = controller.menu
    if (this.keyboard.keys.openMenu.pressed && !Optional.is(menu.remapKey)) {
      var state = controller.fsm.getStateName()
      
      switch (state) {
        case "idle":
          if (menu.containers.size() > 0) {
            menu.send(new Event("back"))
          } else {
            menu.send(menu.factoryOpenMainMenuEvent())
          }
          break
        case "game-over":
          break
        case "play":
          var fsmState = controller.fsm.currentState
          if (fsmState.state.get("promises-resolved") != "success") {
            break
          }

          var editor = Beans.get(BeanVisuEditorController)
          if (Optional.is(editor) && editor.renderUI) {
            break
          }
          controller.send(new Event("pause", { data: menu.factoryOpenMainMenuEvent() }))
          break
        case "paused":
          if (menu.containers.size() > 0) {
            menu.send(new Event("back") )
            if (!Optional.is(menu.back)) {
              controller.send(new Event("play"))
            }
          } else {
            menu.send(menu.factoryOpenMainMenuEvent())
          }
          break
      }
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
  updateBegin = function() {
    try {
      this.keyboard.update()
      this.mouse.update()  
      GMTFContext.updateBegin()
      
      var controller = Beans.get(BeanVisuController)
      if (!Core.isType(controller, VisuController)) {
        return this
      }

      this.fullscreenKeyboardEvent(controller)
      this.functionKeyboardEvent(controller)
      this.mouseEvent(controller)
    } catch (exception) {
      var message = $"'VisuIO::update' fatal error: {exception.message}"
      Logger.error(BeanVisuIO, message)

      var controller = Beans.get(BeanVisuController)
      if (Core.isType(controller, VisuController)) {
        controller.send(new Event("spawn-popup", { message: message }))
      }
    }

    return this
  }
}