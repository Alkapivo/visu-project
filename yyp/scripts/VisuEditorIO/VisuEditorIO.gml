///@package io.alkapivo.visu.editor

#macro BeanVisuEditorIO "VisuEditorIO"
function VisuEditorIO() constructor {

  ///@type {Keyboard}
  keyboard = new Keyboard({ 
    controlLeft: KeyboardKeyType.CONTROL_LEFT,
    shiftLeft: KeyboardKeyType.SHIFT_LEFT,

    undo: "Z",

    exitModal: KeyboardKeyType.ESC,

    newProject: "N", // + ctrl
    editProject: "E", // + ctrl
    openProject: "O", // + ctrl
    saveProject: "S", // + ctrl

    previewEvent: "A", // + ctrl
    saveTemplate: "A", // + ctrl + shift
    toBrush: "B", // + ctrl

    previewBrush: "D", // + ctrl
    saveBrush: "D", // + ctrl + shift

    selectTool: "V",
    eraseTool: "E",
    brushTool: "B",
    cloneTool: "C",
    snapToGrid: "Q", // + shift
    zoomIn: KeyboardKeyType.PLUS,
    zoomOut: KeyboardKeyType.MINUS,
    numZoomIn: KeyboardKeyType.NUM_PLUS,
    numZoomOut: KeyboardKeyType.NUM_MINUS,

    controlTrack: KeyboardKeyType.SPACE,
    controlTrackBackward: 188, // + ctrl
    controlTrackForward: 190, // + ctrl
    
    renderLeftPane: KeyboardKeyType.F2,
    renderBottomPane: KeyboardKeyType.F3,
    renderRightPane: KeyboardKeyType.F4,
    renderTrackControl: KeyboardKeyType.F1,
    renderSceneConfigPreview: KeyboardKeyType.F12,
    renderUI: KeyboardKeyType.F5,
    renderEventInspector: KeyboardKeyType.F6,
    renderTemplateToolbar: KeyboardKeyType.F7,
    cameraKeyboardLook: KeyboardKeyType.F8,
    cameraMouseLook: KeyboardKeyType.F9,
  })

  ///@type {Mouse}
  mouse = new Mouse({ 
    left: MouseButtonType.LEFT,
    right: MouseButtonType.RIGHT,
    wheelUp: MouseButtonType.WHEEL_UP,
    wheelDown: MouseButtonType.WHEEL_DOWN,
  })
  
  ///@type {Boolean}
  mouseMoved = false

  ///@type {Number}
  mouseMovedCooldown = Core.getProperty("visu.editor.io.mouse-moved.cooldown", 4.0)
  
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

    if (this.keyboard.keys.controlLeft.on) {
      if (this.keyboard.keys.controlTrackBackward.pressed) {
        controller.send(new Event("rewind").setData({
          timestamp: clamp(
            controller.trackService.time - 5.0, 
            0, 
            controller.trackService.duration),
        }))
      }

      if (this.keyboard.keys.controlTrackForward.pressed) {
        controller.send(new Event("rewind").setData({
          timestamp: clamp(
            controller.trackService.time + 5.0, 
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
            { message: $"Feature 'visu.editor.open' is not available on wasm-yyc target" }))
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

    if (!this.keyboard.keys.controlLeft.on
      && !this.keyboard.keys.controlLeft.released
      && this.keyboard.keys.eraseTool.pressed) {
      editor.store.get("tool").set("tool_erase")
    }

    if (!this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.brushTool.pressed) {
      editor.store.get("tool").set("tool_brush")
    }

    if (this.keyboard.keys.cloneTool.pressed) {
      editor.store.get("tool").set("tool_clone")
    }

    if (this.keyboard.keys.zoomIn.pressed 
      || this.keyboard.keys.numZoomIn.pressed) {

      var item = editor.store.get("timeline-zoom")
      item.set(clamp(item.get() - 1, 5, 30))

      var ruler = editor.uiService.find("ve-timeline-ruler")
      if (Optional.is(ruler)) {
        ruler.finishUpdateTimer()
      }

      var events = editor.uiService.find("ve-timeline-events")
      if (Optional.is(events)) {
        events.finishUpdateTimer()
      }
    }

    if (this.keyboard.keys.zoomOut.pressed 
      || this.keyboard.keys.numZoomOut.pressed) {

      var item = editor.store.get("timeline-zoom")
      item.set(clamp(item.get() + 1, 5, 30))

      var ruler = editor.uiService.find("ve-timeline-ruler")
      if (Optional.is(ruler)) {
        ruler.finishUpdateTimer()
      }

      var events = editor.uiService.find("ve-timeline-events")
      if (Optional.is(events)) {
        events.finishUpdateTimer()
      }
    }

    if (this.keyboard.keys.shiftLeft.on
        && this.keyboard.keys.snapToGrid.pressed) {
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

    if (this.keyboard.keys.renderEventInspector.pressed) {
      editor.accordion.store.get("render-event-inspector")
        .set(!editor.accordion.store.getValue("render-event-inspector"))
    }

    if (this.keyboard.keys.renderTemplateToolbar.pressed) {
      editor.accordion.store.get("render-template-toolbar")
        .set(!editor.accordion.store.getValue("render-template-toolbar"))
    }

    if (this.keyboard.keys.renderTrackControl.pressed) {
      editor.store.get("render-trackControl")
        .set(!editor.store.getValue("render-trackControl"))
    }

    if (this.keyboard.keys.renderSceneConfigPreview.pressed) {
      editor.store.get("render-sceneConfigPreview")
        .set(!editor.store.getValue("render-sceneConfigPreview"))
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

      var exitModalKeyDispatched = false
      if (Core.isType(editor.uiService.find("visu-project-modal"), UI)) {
        editor.projectModal.send(new Event("close"))
        exitModalKeyDispatched = true
      }

      if (Core.isType(editor.uiService.find("visu-new-project-modal"), UI)) {
        editor.newProjectModal.send(new Event("close"))
        exitModalKeyDispatched = true
      }
      
      if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
        editor.exitModal.send(new Event("close"))
      } else if (!exitModalKeyDispatched) {
        controller.visuRenderer.gridRenderer.camera.enableMouseLook = false
        controller.visuRenderer.gridRenderer.camera.enableKeyboardLook = false
        editor.executor.add(new Task("disable-renderUI")
          .whenUpdate(function() {
            var editor = Beans.get(BeanVisuEditorController)
            if (!Optional.is(editor)) {
              this.fullfill()
            }
            
            editor.renderUI = false
            this.fullfill()
          })
          .setTimeout(2.0))
        /*
        editor.exitModal.send(new Event("open").setData({
          layout: new UILayout({
            name: "display",
            x: function() { return 0 },
            y: function() { return 0 },
            width: function() { return GuiWidth() },
            height: function() { return GuiHeight() },
          }),
        }))
        */
      }
    }

    if (!GMTFContext.isFocused() 
      && this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.newProject.pressed) {
        
      if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
        editor.send(new Event("spawn-popup", 
          { message: $"Feature 'visu.editor.new' is not available on wasm-yyc target" }))
        return this
      }

      if (Core.isType(editor.uiService.find("visu-project-modal"), UI)) {
        editor.projectModal.send(new Event("close"))
      }

      if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
        editor.exitModal.send(new Event("close"))
      }
      
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

    if (!GMTFContext.isFocused() 
      && this.keyboard.keys.controlLeft.on 
      && this.keyboard.keys.editProject.pressed) {

      if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
        editor.send(new Event("spawn-popup", 
          { message: $"Feature 'visu.editor.edit' is not available on wasm-yyc target" }))
        return this
      }

      if (Core.isType(editor.uiService.find("visu-new-project-modal"), UI)) {
        editor.newProjectModal.send(new Event("close"))
      }

      if (Core.isType(editor.uiService.find("visu-modal"), UI)) {
        editor.exitModal.send(new Event("close"))
      }
      
      editor.projectModal.send(new Event("open").setData({
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

        if (!Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
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
    if (GMTFContext.isFocused() 
      || !editor.renderUI 
      || !this.keyboard.keys.controlLeft.on) {
      return this
    }

    var control = editor.accordion.eventInspector.containers.get("ve-event-inspector-control")
    if (this.keyboard.keys.toBrush.pressed) {
      if (Optional.is(control)) {
        var toBrush = control.items.get("button_control-to-brush_type-button")
        if (Optional.is(toBrush)) {
          toBrush.callback()
        }
      }
    }

    if (this.keyboard.keys.shiftLeft.on) {
      if (this.keyboard.keys.saveTemplate.pressed && editor.store.getValue("render-event")) {
        editor.accordion.templateToolbar.send(new Event("save-template"))
      }
    } else {
      if (this.keyboard.keys.previewEvent.pressed) {
        var event = editor.accordion.eventInspector.store.getValue("event")
        if (Core.isType(event, VEEvent)) {
          var handler = controller.trackService.handlers.get(event.type)
          handler.run(handler.parse(event.toTemplate().event.data))
          if (Optional.is(control)) {
            var preview = control.items.get("button_control-preview_type-button")
            if (Optional.is(preview)) {
              var item = preview
              editor.executor.tasks.forEach(function(task, iterator, item) {
                if (Struct.get(task.state, "item") == item) {
                  task.fullfill()
                }
              }, item)
              
              var task = new Task($"onMouseReleasedLeft_{item.name}")
                .setTimeout(10.0)
                .setState({
                  item: item,
                  transformer: new ColorTransformer({
                    value: VETheme.color.accentLight,
                    target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                    factor: 0.016,
                  })
                })
                .whenUpdate(function(executor) {
                  if (this.state.transformer.update().finished) {
                    this.fullfill()
                  }
  
                  this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                })
  
              item.backgroundColor = ColorUtil.parse(VETheme.color.accent).toGMColor()
              editor.executor.add(task)
            }
          }
        }
      }
    }
    
    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  brushToolbarKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused() 
      || !editor.renderUI
      || !this.keyboard.keys.controlLeft.on) {
      return this
    }
    
    if (this.keyboard.keys.shiftLeft.on) {
      if (this.keyboard.keys.saveBrush.pressed 
        && editor.store.getValue("render-brush")) {
        
        editor.brushToolbar.send(new Event("save-brush"))
      }
    } else {
      if (this.keyboard.keys.previewBrush.pressed) {
        var brush = editor.brushToolbar.store.getValue("brush")
        if (Core.isType(brush, VEBrush)) {
          var handler = Beans.get(BeanVisuController).trackService.handlers.get(brush.type)
          handler.run(handler.parse(brush.toTemplate().properties))

          var control = editor.brushToolbar.containers.get("ve-brush-toolbar_control")
          if (Optional.is(control)) {
            var preview = control.items.get("button_control-preview_type-button")
            if (Optional.is(preview)) {
              var item = preview
              editor.executor.tasks.forEach(function(task, iterator, item) {
                if (Struct.get(task.state, "item") == item) {
                  task.fullfill()
                }
              }, item)
              
              var task = new Task($"onMouseReleasedLeft_{item.name}")
                .setTimeout(10.0)
                .setState({
                  item: item,
                  transformer: new ColorTransformer({
                    value: VETheme.color.accentLight,
                    target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                    factor: 0.016,
                  })
                })
                .whenUpdate(function(executor) {
                  if (this.state.transformer.update().finished) {
                    this.fullfill()
                  }
  
                  this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                })
  
              item.backgroundColor = ColorUtil.parse(VETheme.color.accent).toGMColor()
              editor.executor.add(task)
            }
          }
        }
      }
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@param {VisuEditorController} editor
  ///@return {VisuEditorIO}
  timelineKeyboardEvent = function(controller, editor) {
    if (GMTFContext.isFocused() 
      || !editor.renderUI 
      || !controller.trackService.isTrackLoaded()) {
      return this
    }

    if (this.keyboard.keys.controlLeft.on 
        && this.keyboard.keys.undo.pressed) {
      
      editor.store.get("selected-event").set(null)
      editor.store.getValue("selected-events").clear()
      
      var transactionService = editor.timeline.transactionService
      if (this.keyboard.keys.shiftLeft.on) {
        transactionService.redo()
      } else {
        transactionService.undo()
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

    if (MouseUtil.hasMoved() && this.mouseMoved == 0) {  
      this.mouseMoved = this.mouseMovedCooldown
      editor.uiService.send(generateMouseEvent("MouseHoverOver"))
    } else if (this.mouseMoved > 0) {
      this.mouseMoved = clamp(this.mouseMoved - 1, 0, this.mouseMovedCooldown)
    }

    return this
  }

  ///@return {VisuEditorIO}
  updateBegin = function() {
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
      this.timelineKeyboardEvent(controller, editor)
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