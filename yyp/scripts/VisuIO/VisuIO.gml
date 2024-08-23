///@package io.alkapivo.visu

#macro BeanVisuIO "VisuIO"
function VisuIO() constructor {

  ///@type {Keyboard}
  keyboard = new Keyboard(
    { 
      controlTrack: KeyboardKeyType.SPACE,
      renderLeftPane: KeyboardKeyType.F1,
      renderBottomPane: KeyboardKeyType.F2,
      renderRightPane: KeyboardKeyType.F3,
      renderTrackControl: KeyboardKeyType.F4,
      renderUI: KeyboardKeyType.F5,
      cameraKeyboardLook: KeyboardKeyType.F6,
      cameraMouseLook: KeyboardKeyType.F7,
      fullscreen: KeyboardKeyType.F11,
      exitModal: KeyboardKeyType.ESC,
      newProject: "N",
      openProject: "O",
      saveProject: "S",
      saveTemplate: "T",
      saveBrush: "U",
      selectTool: "S",
      eraseTool: "E",
      brushTool: "B",
      cloneTool: "C",
      previewBrush: "P",
      previewEvent: "I",
      snapToGrid: "G",
      zoomIn: KeyboardKeyType.PLUS,
      zoomOut: KeyboardKeyType.MINUS,
      numZoomIn: KeyboardKeyType.NUM_PLUS,
      numZoomOut: KeyboardKeyType.NUM_MINUS,
      controlLeft: KeyboardKeyType.CONTROL_LEFT,
    }
  )

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

    var editor = Beans.get(BeanVisuEditor)
    if (!Core.isType(editor, VisuEditor)) {
      return this
    }

    if (this.keyboard.keys.selectTool.pressed) {
      editor.store.get("tool").set("tool_select")
    }

    if (this.keyboard.keys.eraseTool.pressed) {
      editor.store.get("tool").set("tool_erase")
    }

    if (this.keyboard.keys.brushTool.pressed) {
      editor.store.get("tool").set("tool_brush")
    }

    if (this.keyboard.keys.cloneTool.pressed) {
      editor.store.get("tool").set("tool_clone")
    }

    if (this.keyboard.keys.zoomIn.pressed 
      || this.keyboard.keys.numZoomIn.pressed) {

      var item = editor.store.get("timeline-zoom")
      item.set(clamp(item.get() - 1, 5, 20))
    }

    if (this.keyboard.keys.zoomOut.pressed 
      || this.keyboard.keys.numZoomOut.pressed) {

      var item = editor.store.get("timeline-zoom")
      item.set(clamp(item.get() + 1, 5, 20))
    }

    if (this.keyboard.keys.snapToGrid.pressed) {
      var item = editor.store.get("snap")
      item.set(!item.get())
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
    if (this.keyboard.keys.renderUI.pressed) {
      controller.renderUI = !controller.renderUI
    }

    if (this.keyboard.keys.cameraKeyboardLook.pressed) {
      controller.gridRenderer.camera.enableKeyboardLook = !controller.gridRenderer.camera.enableKeyboardLook
    }

    if (this.keyboard.keys.cameraMouseLook.pressed) {
      controller.gridRenderer.camera.enableMouseLook = !controller.gridRenderer.camera.enableMouseLook
    }

    var editor = Beans.get(BeanVisuEditor)
    if (!Core.isType(editor, VisuEditor)) {
      return this
    }
    
    if (this.keyboard.keys.renderTrackControl.pressed) {
      editor.store.get("render-trackControl")
        .set(!editor.store.getValue("render-trackControl"))
    }

    if (this.keyboard.keys.renderLeftPane.pressed) {
      editor.store.get("render-event")
        .set(!editor.store.getValue("render-event"))
    }

    if (this.keyboard.keys.renderBottomPane.pressed) {
      editor.store.get("render-timeline")
        .set(!editor.store.getValue("render-timeline"))
    }

    if (this.keyboard.keys.renderRightPane.pressed) {
      editor.store.get("render-brush")
        .set(!editor.store.getValue("render-brush"))
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  modalKeyboardEvent = function(controller) {
    var editor = Beans.get(BeanVisuEditor)
    if (!Core.isType(editor, VisuEditor)) {
      return this
    }

    if (!GMTFContext.isFocused() 
      && this.keyboard.keys.exitModal.pressed) {

      if (Core.isType(controller.uiService.find("visu-new-project-modal"), UI)) {
        editor.newProjectModal.send(new Event("close"))
      } else if (Core.isType(controller.uiService.find("visu-modal"), UI)) {
        editor.exitModal.send(new Event("close"))
      } else {
        editor.exitModal.send(new Event("open").setData({
          layout: new UILayout({
            name: "display",
            x: function() { return 0 },
            y: function() { return 0 },
            width: function() { return GuiWidth() },
            height: function() { return GuiHeight() },
          }),
        }))
        controller.gridRenderer.camera.enableMouseLook = false
        controller.gridRenderer.camera.enableKeyboardLook = false
      }
    }

    if (!GMTFContext.isFocused() 
      && this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.newProject.pressed) {
      
      editor.newProjectModal.send(new Event("open").setData({
        layout: new UILayout({
          name: "display",
          x: function() { return 0 },
          y: function() { return 0 },
          width: function() { return GuiWidth() },
          height: function() { return GuiHeight() },
        }),
      }))
    }

    return this
  }
  
  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  titleBarKeyboardEvent = function(controller) {
    if (GMTFContext.isFocused()) {
      return
    }

    if (this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.openProject.pressed) {
      try {
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

    if (this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.saveProject.pressed) {
      try {
        var path = FileUtil.getPathToSaveWithDialog({ 
          description: "Visu track file",
          filename: "manifest", 
          extension: "visu",
        })

        if (!Core.isType(path, String) || String.isEmpty(path)) {
          return
        }

        global.__VisuTrack.saveProject(path)

        controller.send(new Event("spawn-popup", 
          { message: $"Project '{controller.trackService.track.name}' saved successfully at: '{path}'" }))
      } catch (exception) {
        var message = $"Cannot save the project: {exception.message}"
        controller.send(new Event("spawn-popup", { message: message }))
        Logger.error("VETitleBar", message)
      }
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  templateToolbarKeyboardEvent = function(controller) {
    if (GMTFContext.isFocused()) {
      return this
    }
    
    var editor = Beans.get(BeanVisuEditor)
    if (!Core.isType(editor, VisuEditor)) {
      return this
    }

    if (this.keyboard.keys.saveTemplate.pressed 
      && editor.store.getValue("render-event")) {
      
      editor.accordion.templateToolbar.send(new Event("save-template"))
    }

    if (this.keyboard.keys.previewEvent.pressed) {
      var event = editor.accordion.eventInspector.store.getValue("event")
      if (Core.isType(event, VEEvent)) {
        var handler = controller.trackService.handlers.get(event.type)
        handler(event.toTemplate().event.data)
      }
    }
    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  brushToolbarKeyboardEvent = function(controller) {
    if (GMTFContext.isFocused()) {
      return this
    }

    var editor = Beans.get(BeanVisuEditor)
    if (!Core.isType(editor, VisuEditor)) {
      return this
    }
    
    if (this.keyboard.keys.saveBrush.pressed 
      && editor.store.getValue("render-brush")) {
      
      editor.brushToolbar.send(new Event("save-brush"))
    }

    if (!this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.previewBrush.pressed) {
      var brush = editor.brushToolbar.store.getValue("brush")
      if (Core.isType(brush, VEBrush)) {
        var handler = controller.trackService.handlers.get(brush.type)
        handler(brush.toTemplate().properties)
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

    if (!controller.renderUI) {
      return this
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
      this.titleBarKeyboardEvent(controller)
      this.modalKeyboardEvent(controller)
      this.templateToolbarKeyboardEvent(controller)
      this.brushToolbarKeyboardEvent(controller)
      this.mouseEvent(controller)
    } catch (exception) {
      var message = $"'updateIO' fatal error: {exception.message}"
      Logger.error(BeanVisuIO, message)
      this.send(new Event("spawn-popup", { message: message }))
    }

    return this
  }
}