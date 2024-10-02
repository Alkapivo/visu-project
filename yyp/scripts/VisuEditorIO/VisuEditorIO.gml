///@package io.alkapivo.visu.editor

#macro BeanVisuEditorIO "VisuEditorIO"
function VisuEditorIO() constructor {

  ///@type {Keyboard}
  keyboard = new Keyboard({ 
    renderLeftPane: KeyboardKeyType.F1,
    renderBottomPane: KeyboardKeyType.F2,
    renderRightPane: KeyboardKeyType.F3,
    renderTrackControl: KeyboardKeyType.F4,
    renderUI: KeyboardKeyType.F5,
    cameraKeyboardLook: KeyboardKeyType.F6,
    cameraMouseLook: KeyboardKeyType.F7,
    exitModal: KeyboardKeyType.ESC,
    controlTrack: KeyboardKeyType.SPACE,
    controlTrackBackward: KeyboardKeyType.ARROW_LEFT,
    controlTrackForward: KeyboardKeyType.ARROW_RIGHT,
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  controlTrackKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused()) {
      return this
    }
    
    if (!Core.getProperty("visu.editor.controlTrack.alwaysEnabled", false) 
      && !editor.renderUI) {
      return this
    }

    if (this.keyboard.keys.controlTrack.pressed) {
      switch (controller.fsm.getStateName()) {
        case "play": controller.send(new Event("pause")) break
        case "paused": controller.send(new Event("play")) break
      }
    }

    if (!editor.renderUI) {
      return this
    }

    if (this.keyboard.keys.controlLeft.on) {
      if (this.keyboard.keys.controlTrackBackward.pressed) {
        controller.send(new Event("rewind").setData({
          timestamp: clamp(
            controller.trackService.time - 10.0, 
            0, 
            controller.trackService.duration),
        }))
      }

      if (this.keyboard.keys.controlTrackForward.pressed) {
        controller.send(new Event("rewind").setData({
          timestamp: clamp(
            controller.trackService.time + 10.0, 
            0, 
            controller.trackService.duration),
        }))
      }
    }

    if (this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.openProject.pressed) {
      try {
        if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
          controller.send(new Event("spawn-popup", 
            { message: $"Feature 'visu.open' is not available on wasm-yyc target" }))
          return this
        }

        var manifest = FileUtil.getPathToOpenWithDialog({ 
          description: "Visu track file",
          filename: "manifest", 
          extension: "visu"
        })

        if (!FileUtil.fileExists(manifest)) {
          return this
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  functionKeyboardEvent = function(controller, editor) {
    if (this.keyboard.keys.renderUI.pressed) {
      var loaderState = controller.loader.fsm.getStateName()
      if (loaderState == "idle" || loaderState == "loaded") {
        editor.renderUI = !editor.renderUI
      }
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

    if (this.keyboard.keys.cameraKeyboardLook.pressed) {
      var camera = controller.visuRenderer.gridRenderer.camera
      camera.enableKeyboardLook = !camera.enableKeyboardLook
    }

    if (this.keyboard.keys.cameraMouseLook.pressed) {
      var camera = controller.visuRenderer.gridRenderer.camera
      camera.enableMouseLook = !camera.enableMouseLook
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  modalKeyboardEvent = function(controller, editor) {
    if (!editor.renderUI) {
      return this
    }

    if (!GMTFContext.isFocused() 
      && this.keyboard.keys.exitModal.pressed) {

      if (Core.isType(editor.uiService.find("visu-new-project-modal"), UI)) {
        editor.newProjectModal.send(new Event("close"))
      } else if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
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
        controller.visuRenderer.gridRenderer.camera.enableMouseLook = false
        controller.visuRenderer.gridRenderer.camera.enableKeyboardLook = false
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  titleBarKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused() || !editor.renderUI) {
      return this
    }

    if (this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.saveProject.pressed) {
      try {
        if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
          editor.send(new Event("spawn-popup", 
            { message: $"Feature 'visu.editor.save' is not available on wasm-yyc target" }))
          return this
        }

        var path = FileUtil.getPathToSaveWithDialog({ 
          description: "Visu track file",
          filename: "manifest", 
          extension: "visu",
        })

        if (!Core.isType(path, String) || String.isEmpty(path)) {
          return this
        }

        controller.track.saveProject(path)
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  templateToolbarKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused() || !editor.renderUI) {
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  brushToolbarKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused() || !editor.renderUI) {
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
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  mouseEvent = function(controller, editor) {
    static generateMouseEvent = function(name) {
      return new Event(name, { 
        x: MouseUtil.getMouseX(), 
        y: MouseUtil.getMouseY(),
      })
    }

    if (!editor.renderUI) {
      return this
    }

    if (this.mouse.buttons.left.pressed) {
      editor.uiService.send(generateMouseEvent("MousePressedLeft"))
    }

    if (this.mouse.buttons.left.released) {
      editor.uiService.send(generateMouseEvent("MouseReleasedLeft"))
      controller.displayService.setCursor(Cursor.DEFAULT)
    }

    if (this.mouse.buttons.left.drag) {
      editor.uiService.send(generateMouseEvent("MouseDragLeft"))
    }

    if (this.mouse.buttons.left.drop) {
      editor.uiService.send(generateMouseEvent("MouseDropLeft"))
    }

    if (this.mouse.buttons.right.pressed) {
      editor.uiService.send(generateMouseEvent("MousePressedRight"))
    }

    if (this.mouse.buttons.right.released) {
      editor.uiService.send(generateMouseEvent("MouseReleasedRight"))
    }
    
    if (this.mouse.buttons.wheelUp.on) {  
      editor.uiService.send(generateMouseEvent("MouseWheelUp"))
    }
    
    if (this.mouse.buttons.wheelDown.on) {  
      editor.uiService.send(generateMouseEvent("MouseWheelDown"))
    }

    if (MouseUtil.hasMoved()) {  
      editor.uiService.send(generateMouseEvent("MouseHoverOver"))
    }

    return this
  }

  ///@return {VisuEditorIO}
  update = function() {
    try {
      this.keyboard.update()
      this.mouse.update()
      
      var controller = Beans.get(BeanVisuController)
      if (!Core.isType(controller, VisuController) 
        || controller.menu.containers.size() > 0) {
        return this
      }

      var editor = Beans.get(BeanVisuEditorController)
      if (!Core.isType(editor, VisuEditorController)) {
        return this
      }

      this.controlTrackKeyboardEvent(controller, editor)
      this.functionKeyboardEvent(controller, editor)
      this.titleBarKeyboardEvent(controller, editor)
      this.modalKeyboardEvent(controller, editor)
      this.templateToolbarKeyboardEvent(controller, editor)
      this.brushToolbarKeyboardEvent(controller, editor)
      this.mouseEvent(controller, editor)
    } catch (exception) {
      var message = $"'VisuEditorIO::update' fatal error: {exception.message}"
      Logger.error(BeanVisuEditorIO, message)
      
      var controller = Beans.get(BeanVisuController)
      if (Core.isType(controller, VisuController)) {
        controller.send(new Event("spawn-popup", { message: message }))
      }
    }

    return this
  }
}