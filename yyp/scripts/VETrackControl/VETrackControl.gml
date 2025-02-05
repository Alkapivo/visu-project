///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
function VETrackControl(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)
  
  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "track-control",
        fetchNodeX: new BindIntent(function(index, amount, width, margin) {
          var halfX = this.context.width() / 2
          var halfWidth = ((width * amount) + (margin * (amount + 2))) / 2
          return halfX - halfWidth + (width * index) + (margin * (index + 2))
        }),
        nodes: {
          timeline: {
            name: "track-control.timeline",
            margin: { left: 0, right: 32 },
            x: function() { return this.margin.left },
            y: function() { return 0 },
            width: function() { return this.context.width() 
              - this.margin.left
              - this.margin.right },
            height: function() { 
              return 28
            },
          },
          timestamp: {
            name: "track-control.timestamp",
            width: function() { return 64 },
            height: function() { return 20 },
            margin: { top: 8, right: 8 },
            x: function() { return this.margin.right },
            y: function() { return this.context.nodes.timeline.bottom()
              + this.margin.top },
          },
          backward: {
            name: "track-control.backward",
            width: function() { return 32 },
            height: function() { return 32 },
            margin: { top: 0 },
            x: function() { return this.context.fetchNodeX(0, 4, this.width(), 4) },
            y: function() { return this.context.nodes.timeline.bottom()
              + this.margin.top },
          },
          play: {
            name: "track-control.play",
            width: function() { return 32 },
            height: function() { return 32 },
            margin: { top: 0 },
            x: function() { return this.context.fetchNodeX(1, 4, this.width(), 4) },
            y: function() { return this.context.nodes.timeline.bottom()
              + this.margin.top },
          },
          pause: {
            name: "track-control.pause",
            width: function() { return 32 },
            height: function() { return 32 },
            margin: { top: 0 },
            x: function() { return this.context.fetchNodeX(2, 4, this.width(), 4) },
            y: function() { return this.context.nodes.timeline.bottom()
              + this.margin.top },
          },
          forward: {
            name: "track-control.forward",
            width: function() { return 32 },
            height: function() { return 32 },
            margin: { top: 0 },
            x: function() { return this.context.fetchNodeX(3, 4, this.width(), 4) },
            y: function() { return this.context.nodes.timeline.bottom()
              + this.margin.top },
          },
          clearShaderBkg: {
            name: "track-control.clearShaderBkg",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 8, right: 0 },
            x: function() { return this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearShaderGrid: {
            name: "track-control.clearShaderGrid",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearShaderBkg.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearShaderCombined: {
            name: "track-control.clearShaderCombined",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearShaderGrid.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearBkg: {
            name: "track-control.clearBkg",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearShaderCombined.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearFrg: {
            name: "track-control.clearFrg",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearBkg.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearShroom: {
            name: "track-control.clearShroom",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearFrg.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearBullet: {
            name: "track-control.clearBullet",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.clearShroom.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          clearParticle: {
            name: "track-control.clearParticle",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 1 },
            x: function() { return this.context.nodes.clearBullet.right() 
              + this.margin.left },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
          redo: {
            name: "track-control.redo",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 0, right: 0 },
            x: function() { return this.context.nodes.zoom.left() 
              - this.margin.right
              - this.width() },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height()
            },
          },
          undo: {
            name: "track-control.undo",
            width: function() { return 20 },
            height: function() { return 20 },
            margin: { top: 1, bottom: 1, left: 1, right: 1 },
            x: function() { return this.context.nodes.redo.left() 
              - this.margin.right
              - this.width() },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height()
            },
          },
          zoom: {
            name: "track-control.zoom",
            width: function() { return 84 },
            height: function() { return 24 },
            margin: { top: 1, bottom: 1, left: 15, right: 15 },
            x: function() { return this.context.width() 
              - this.margin.right
              - this.width() },
            y: function() { return this.context.height()
              - this.margin.bottom 
              - this.height() },
          },
        }
      }, 
      parent
    )
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Map<String, UI>}
  factoryContainers = function(parent) {
    static factorySlider = function(json) {
      return Struct.appendRecursiveUnique(
        {
          type: UISliderHorizontal,
          layout: json.layout,
          value: 0.0,
          minValue: 0.0,
          maxValue: 1.0,
          getClipboard: Beans.get(BeanVisuEditorIO).mouse.getClipboard,
          setClipboard: Beans.get(BeanVisuEditorIO).mouse.setClipboard,
          pointer: {
            name: "texture_slider_pointer_track_control",
            scaleX: 0.125,
            scaleY: 0.125,
          },
          progress: { 
            thickness: 1.75, 
            alpha: 1.0,
            blend: VETheme.color.accentLight,
            line: { name: "texture_grid_line_bold" },
            cornerFrom: { name: "texture_empty" },
            cornerTo: { name: "texture_empty" },
          },
          background: {
            thickness: 0.0, 
            blend: VETheme.color.sideDark,
            alpha: 0.0,
          },
          preRender: function() {
            var background = Struct.get(this, "_background")
            if (!Core.isType(background, TexturedLine)) {
              background = new TexturedLine({
                thickness: 1.5, 
                blend: VETheme.color.side,
                alpha: 0.5,
                line: { name: "texture_grid_line_default" },
                cornerFrom: { name: "texture_empty" },
                cornerTo: { name: "texture_empty" },
              })
              Struct.set(this, "_background", background)
            }

            var fromX = this.context.area.getX() + this.area.getX()
            var fromY = this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2)
            var widthMax = this.area.getWidth() + (this.pointer.getWidth() * this.pointer.scaleX())
            var width = ((this.value - this.minValue) / abs(this.minValue - this.maxValue)) * widthMax
            background.render(fromX, fromY, fromX + widthMax, fromY)
          },
          state: new Map(String, any),
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: function() {
            var controller = Beans.get(BeanVisuController)
            var trackService = controller.trackService
            var mousePromise = Beans.get(BeanVisuEditorIO).mouse.getClipboard()
            var context = Struct.get(Struct.get(mousePromise, "state"), "context")
            var ruler = Beans.get(BeanVisuEditorController).timeline.containers.get("ve-timeline-ruler")
            if (context == this) {
              this.updatePosition(MouseUtil.getMouseX() - this.context.area.getX())
              return
            } else if (context != null && context == ruler) {
              var mouseXTime = ruler.state.get("mouseXTime")
              if (Core.isType(mouseXTime, Number)) {
                this.value = clamp(
                  mouseXTime / trackService.duration, 
                  this.minValue, 
                  this.maxValue
                )
                return
              }
            }

            if (this.state.contains("promise")) {
              var promise = this.state.get("promise")
              if (Struct.get(promise, "status") == PromiseStatus.PENDING) {
                return
              }
              this.state.remove("promise")
            }
            
            if (controller.fsm.getStateName() == "rewind") {
              return
            }

            this.value = clamp(
              trackService.time / trackService.duration, 
              this.minValue, 
              this.maxValue
            )
          },
          updatePosition: function(mouseX) {
            var width = this.area.getWidth() - (this.area.getX() * 2)
            this.value = clamp(mouseX / width, this.minValue, this.maxValue)

            var controller = Beans.get(BeanVisuController)
            var editor = Beans.get(BeanVisuEditorController)
            var ruler = editor.uiService.find("ve-timeline-ruler")
            if (Optional.is(ruler)) {
              ruler.state.set("time", this.value * controller.trackService.duration)
              ruler.finishUpdateTimer()
            }

            var events = editor.uiService.find("ve-timeline-events")
            if (Optional.is(events)) {
              events.state.set("time", this.value * controller.trackService.duration)
              events.finishUpdateTimer()
            }
          },
          onMousePressedLeft: function(event) {
            this.updatePosition(event.data.x)
          },
          onMouseReleasedLeft: function(event) {
            this.updatePosition(event.data.x)
            this.sendEvent()
          },
          onMouseDragLeft: function(event) {
            var context = this
            var mouse = Beans.get(BeanVisuEditorIO).mouse
            var name = Struct.get(mouse.getClipboard(), "name")
            if (name == "resize_accordion"
                || name == "resize_brush_toolbar"
                || name == "resize_brush_inspector"
                || name == "resize_template_inspector"
                || name == "resize_timeline"
                || name == "resize_horizontal"
                || name == "resize_event_title"
                || !Beans.get(BeanVisuController).trackService.isTrackLoaded()) {
              return
            }

            Beans.get(BeanVisuEditorIO).mouse.setClipboard(new Promise()
              .setState({
                context: context,
                callback: context.sendEvent,
              })
              .whenSuccess(function() {
                Callable.run(Struct.get(this.state, "callback"))
              })
            )
          },
          sendEvent: new BindIntent(function() {
            var controller = Beans.get(BeanVisuController)
            var timestamp = this.value * (controller.trackService.duration - (FRAME_MS * 4))
            var promise = controller
              .send(new Event("rewind")
              .setData({ timestamp: timestamp })
              .setPromise(new Promise()))
            this.state.set("promise", promise)
            return promise
          }),
        },
        VEStyles.get("ve-track-control").slider,
        false
      )
    }

    static factoryButton = function(json) {
      var button = Struct.appendRecursiveUnique(
        {
          type: UIButton,
          layout: json.layout,
          sprite: json.sprite,
          callback: json.callback,
          label: {
            text: "",
            align: { v: VAlign.TOP, h: HAlign.CENTER },
            color: VETheme.color.textShadow,
            useScale: false,
            outline: true,
            outlineColor: VETheme.color.sideDark,
            font: "font_inter_8_bold",
          },
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          updateCustom: Struct.contains(json, "updateCustom") 
             ? json.updateCustom
             : function() {},
          onMouseHoverOver: function(event) {
            this.sprite.setBlend(ColorUtil.fromHex(VETheme.color.buttonHover).toGMColor())
          },
          onMouseHoverOut: function(event) {
            this.sprite.setBlend(ColorUtil.fromHex(VETheme.color.textShadow).toGMColor())
          },
        },
        VEStyles.get("ve-track-control").button,
        false
      )

      if (Optional.is(Struct.getIfType(json, "postRender", Callable))) {
        Struct.set(button, "postRender", json.postRender)
      }

      return button
    }

    static factoryLabel = function(json) {
      var struct = {
        type: UIText,
        layout: json.layout,
        text: json.text,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      }

      if (Struct.contains(json, "updateCustom")) {
        Struct.set(struct, "updateCustom", json.updateCustom)
      }

      if (Struct.contains(json, "align")) {
        Struct.set(struct, "align", json.align)
      }
      
      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("ve-track-control").label,
        false
      )
    }

    static factoryClearButton = function(json) {
      return Struct.appendRecursive({
        type: UIButton,
        label: { 
          text: "",
          align: { v: VAlign.BOTTOM, h: HAlign.CENTER },
          color: VETheme.color.textShadow,
          outline: true,
          outlineColor: VETheme.color.sideDark,
          font: "font_inter_8_bold"
        },
        description: "",
        layout: json.layout,
        hAlign: HAlign.CENTER,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
        backgroundAlpha: 0.75,
        backgroundColor: VETheme.color.primaryShadow,
        backgroundColorSelected: VETheme.color.accentShadow,
        backgroundColorOut: VETheme.color.primaryShadow,
        onMouseHoverOver: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
        },
        onMouseHoverOut: function(event) {
          this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
        },
        render: function() {
          if (Optional.is(this.preRender)) {
            this.preRender()
          }
          this.renderBackgroundColor()
    
          if (this.sprite != null) {
            var alpha = this.sprite.getAlpha()
            this.sprite
              .setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
              .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
              .render(
                this.context.area.getX() + this.area.getX(),
                this.context.area.getY() + this.area.getY())
              .setAlpha(alpha)
          }
    
          if (this.label != null) {
            this.label.render(
              // todo VALIGN HALIGN
              this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
              this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2),
              this.area.getWidth() - 4.0,
              this.area.getHeight()
            )
          }

          if (this.isHoverOver) {
            var text = this.label.text
            this.label.text = this.description
            var alignH = this.label.align.h
            this.label.align.h = this.hAlign
            this.label.render(
              // todo VALIGN HALIGN
              this.context.area.getX() + this.area.getX(),
              this.context.area.getY() + this.area.getY() - (24 - this.area.getHeight())
            )
            this.label.align.h = alignH
            this.label.text = text
          }

          return this
        },
      }, json, false)
    }
    
    var controller = this
    var layout = this.factoryLayout(parent)
    return new Map(String, UI, {
      "ve-track-control": new UI({
        name: "ve-track-control",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
          "background-color2": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          "background-alpha": 0.7,
          "store": Beans.get(BeanVisuEditorController).store,
        }),
        controller: controller,
        layout: layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        spinner: SpriteUtil.parse({ name: "texture_spinner", scaleX: 0.25, scaleY: 0.25 }),
        spinnerFactor: 0,
        render: function() {
          var color = this.state.get("background-color")
          var color2 = this.state.get("background-color2")
          if (Core.isType(color, GMColor)) {
            GPU.render.rectangle(
              this.area.x, this.area.y + 16, 
              this.area.x + this.area.getWidth(), this.area.y + this.area.getHeight(), 
              false,
              color, color, color2, color2, 
              this.state.get("background-alpha")
            )
          }

          this.items.forEach(this.renderItem, this.area)

          if (Beans.get(BeanVisuController).fsm.getStateName() == "rewind") {
            this.spinnerFactor = lerp(this.spinnerFactor, 100.0, 0.1)
            this.spinner
              .setAlpha(this.spinnerFactor / 100.0)
              .render(
                (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
                (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
                  - (this.spinnerFactor / 2)
            )
          } else if (this.spinnerFactor > 0) {
            this.spinnerFactor = lerp(this.spinnerFactor, 0.0, 0.1)
            this.spinner
              .setAlpha(this.spinnerFactor / 100.0)
              .render(
              (GuiWidth() / 2) - ((this.spinner.getWidth() * this.spinner.getScaleX()) / 2),
              (GuiHeight() / 2) - ((this.spinner.getHeight() * this.spinner.getScaleY()) / 2)
                - (this.spinnerFactor / 2)
            )
          }
        },
        items: {
          "slider_ve-track-control_timeline": factorySlider({
            layout: layout.nodes.timeline,
          }),
          "button_ve-track-control_backward": factoryButton({
            layout: layout.nodes.backward,
            sprite: { 
              name: "texture_ve_trackcontrol_button_rewind_left",
              blend: VETheme.color.textShadow,
            },
            callback: function() {
              Logger.debug("VETrackControl", $"Button pressed: {this.name}")
              var controller = Beans.get(BeanVisuController)
              controller.send(new Event("rewind").setData({
                timestamp: clamp(
                  controller.trackService.time - 5.0, 
                  0, 
                  controller.trackService.duration),
              }))
            },
            postRender: function() {
              if (!this.isHoverOver) {
                return
              }
              
              var text = this.label.text
              this.label.text = "Rewind 5sec\n(CTRL + <)"
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 1)
              )
              this.label.text = text
            },
          }),
          "button_ve-track-control_play": factoryButton({
            layout: layout.nodes.play,
            sprite: {
              name: "texture_ve_trackcontrol_button_play",
              blend: VETheme.color.textShadow,
            },
            callback: function() {
              Beans.get(BeanVisuController).send(new Event("play"))
            },
            postRender: function() {
              if (!this.isHoverOver) {
                return
              }
              
              var text = this.label.text
              this.label.text = "Play\n(SPACE)"
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 1)
              )
              this.label.text = text
            },
          }),
          "button_ve-track-control_pause": factoryButton({
            layout: layout.nodes.pause,
            sprite: {
              name: "texture_ve_trackcontrol_button_pause",
              blend: VETheme.color.textShadow,
            },
            callback: function() {
              Beans.get(BeanVisuController).send(new Event("pause"))
            },
            postRender: function() {
              if (!this.isHoverOver) {
                return
              }
              
              var text = this.label.text
              this.label.text = "Pause\n(SPACE)"
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 1)
              )
              this.label.text = text
            },
          }),
          "button_ve-track-control_forward": factoryButton({
            layout: layout.nodes.forward,
            sprite: {
              name: "texture_ve_trackcontrol_button_rewind_right",
              blend: VETheme.color.textShadow,
            },
            callback: function() {
              Logger.debug("VETrackControl", $"Button pressed: {this.name}")
              var controller = Beans.get(BeanVisuController)
              controller.send(new Event("rewind").setData({
                timestamp: clamp(
                  controller.trackService.time + 5.0, 
                  0, 
                  controller.trackService.duration),
              }))
            },
            postRender: function() {
              if (!this.isHoverOver) {
                return
              }
              
              var text = this.label.text
              this.label.text = "Forward 5sec\n(CTRL + >)"
              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 1) + 1
              )
              this.label.text = text
            },
          }),
          "text_ve-track-control_timestamp": factoryLabel({
            layout: layout.nodes.timestamp,
            text: "",
            align: { v: VAlign.CENTER, h: HAlign.LEFT },
            updateCustom: function() {
              var trackService = Beans.get(BeanVisuController).trackService
              var value = Struct.get(this.context.items
                .get("slider_ve-track-control_timeline"), "value")
              if (!trackService.isTrackLoaded()
                  || !Core.isType(value, Number) 
                  || Math.isNaN(value) 
                  || Math.isNaN(trackService.duration)) {

                this.label.text = ""
                return
              }
              
              this.label.text = String
                .formatTimestampMilisecond(NumberUtil
                .parse(trackService.duration * value, 0.0))
            },
          }),
          "button-ve-track-control_clear-shader-bkg": factoryClearButton({
            label: { text: "ShB" },
            description: "Clear shaders BKG",
            hAlign: HAlign.LEFT,
            layout: layout.nodes.clearShaderBkg,
            callback: function() { 
              Beans.get(BeanVisuController).shaderBackgroundPipeline.send(new Event("clear-shaders"))
            },
          }),          
          "button-ve-track-control_clear-shader-grid": factoryClearButton({
            label: { text: "ShG" },
            description: "Clear shaders GRID",
            hAlign: HAlign.LEFT,
            layout: layout.nodes.clearShaderGrid,
            callback: function() { 
              Beans.get(BeanVisuController).shaderPipeline.send(new Event("clear-shaders"))
            },
          }),          
          "button-ve-track-control_clear-shader-combined": factoryClearButton({
            label: { text: "ShC" },
            description: "Clear shaders COMBINED",
            hAlign: HAlign.LEFT,
            layout: layout.nodes.clearShaderCombined,
            callback: function() { 
              Beans.get(BeanVisuController).shaderCombinedPipeline.send(new Event("clear-shaders"))
            },
          }),
          "button-ve-track-control_clear-bkg": factoryClearButton({
            label: { text: "BKG" },
            description: "Clear layers BKG",
            layout: layout.nodes.clearBkg,
            callback: function() { 
              Beans.get(BeanVisuController).visuRenderer.gridRenderer.overlayRenderer.backgrounds.clear()
            },
          }),
          "button-ve-track-control_clear-frg": factoryClearButton({
            label: { text: "FRG" },
            description: "Clear layers FRG",
            layout: layout.nodes.clearFrg,
            callback: function() { 
              Beans.get(BeanVisuController).visuRenderer.gridRenderer.overlayRenderer.foregrounds.clear()
            },
          }),
          "button-ve-track-control_clear-shroom": factoryClearButton({
            label: { text: "SHR" },
            description: "Clear shrooms",
            layout: layout.nodes.clearShroom,
            callback: function() { 
              Beans.get(BeanVisuController).shroomService.send(new Event("clear-shrooms"))
            },
          }),
          "button-ve-track-control_clear-bullet": factoryClearButton({
            label: { text: "BLT" },
            description: "Clear bullets",
            layout: layout.nodes.clearBullet,
            callback: function() { 
              Beans.get(BeanVisuController).bulletService.send(new Event("clear-bullets"))
            },
          }),
          "button-ve-track-control_clear-particle": factoryClearButton({
            label: { text: "PRT" },
            description: "Clear particles",
            layout: layout.nodes.clearParticle,
            callback: function() { 
              Beans.get(BeanVisuController).particleService.send(new Event("clear-particles"))
            },
          }),
          "button-ve-track-control_redo": Struct.appendRecursiveUnique(
            {
              type: UIButton,
              label: { 
                text: "",
                color: VETheme.color.textShadow,
                align: { v: VAlign.BOTTOM, h: HAlign.CENTER },
                useScale: false,
                outline: true,
                outlineColor: VETheme.color.sideDark,
                font: "font_inter_8_bold",
              },
              sprite: {
                name: "texture_ve_trackcontrol_button_redo",
                alpha: 0.75,
              },
              layout: layout.nodes.redo,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
              callback: function() { 
                if (Struct.get(this.enable, "value") == false) {
                  return
                }

                var editor = Beans.get(BeanVisuEditorController)
                editor.store.get("selected-event").set(null)
                editor.store.getValue("selected-events").clear()
                editor.timeline.transactionService.redo()
              },
              backgroundMargin: { top: 1, bottom: 1, left: 0, right: 1 },
              backgroundColor: VETheme.color.primaryShadow,
              backgroundColorSelected: VETheme.color.accentShadow,
              backgroundColorOut: VETheme.color.primaryShadow,
              onMouseHoverOver: function(event) {
                if (Struct.get(this.enable, "value") == false) {
                  this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                  return
                }

                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
              },
              onMouseHoverOut: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
              },
              description: "Redo (CTRL + SHIFT + Z)",
              render: function() {
                if (!Core.isType(this.enable, Struct)) {
                  this.enable = { value: false }
                }
                Struct.set(this.enable, "value", Beans.get(BeanVisuEditorController).timeline.transactionService.reverted.size() > 0)
                backgroundAlpha = this.enable.value ? 1.0 : 0.5

                if (Optional.is(this.preRender)) {
                  this.preRender()
                }
                this.renderBackgroundColor()
          
                if (this.sprite != null) {
                  var alpha = this.sprite.getAlpha()
                  this.sprite
                    .setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
                    .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
                    .render(
                      this.context.area.getX() + this.area.getX(),
                      this.context.area.getY() + this.area.getY())
                    .setAlpha(alpha)
                }
          
                if (this.label != null) {
                  this.label.alpha = this.backgroundAlpha
                  this.label.render(
                    // todo VALIGN HALIGN
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                    this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2),
                    this.area.getWidth(), 
                    this.area.getHeight()
                  )
                }
    
                if (this.isHoverOver && this.enable.value) {
                  var text = this.label.text
                  this.label.text = this.description
                  this.label.render(
                    // todo VALIGN HALIGN
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                    this.context.area.getY() + this.area.getY() - 4.0// + (this.area.getHeight() / 2)
                  )
                  this.label.text = text
                }
                return this
              },
            },
            null,//VEStyles.get("ve-track-control").button,
            false
          ),
          "button-ve-track-control_undo": Struct.appendRecursiveUnique(
            {
              type: UIButton,
              label: { 
                text: "",
                color: VETheme.color.textShadow,
                align: { v: VAlign.BOTTOM, h: HAlign.CENTER },
                useScale: false,
                outline: true,
                outlineColor: VETheme.color.sideDark,
                font: "font_inter_8_bold",
              },
              sprite: {
                name: "texture_ve_trackcontrol_button_undo",
                alpha: 0.75,
              },
              layout: layout.nodes.undo,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
              callback: function() { 
                if (Struct.get(this.enable, "value") == false) {
                  return
                }

                var editor = Beans.get(BeanVisuEditorController)
                editor.store.get("selected-event").set(null)
                editor.store.getValue("selected-events").clear()
                editor.timeline.transactionService.undo()
              },
              backgroundMargin: { top: 1, bottom: 1, left: 0, right: 1 },
              backgroundColor: VETheme.color.primaryShadow,
              backgroundColorSelected: VETheme.color.accentShadow,
              backgroundColorOut: VETheme.color.primaryShadow,
              onMouseHoverOver: function(event) {
                if (Struct.get(this.enable, "value") == false) {
                  this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                  return
                }

                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
              },
              onMouseHoverOut: function(event) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
              },
              description: "Undo (CTRL + Z)",
              render: function() {
                if (!Core.isType(this.enable, Struct)) {
                  this.enable = { value: false }
                }
                Struct.set(this.enable, "value", Beans.get(BeanVisuEditorController).timeline.transactionService.applied.size() > 0)
                backgroundAlpha = this.enable.value ? 1.0 : 0.5

                if (Optional.is(this.preRender)) {
                  this.preRender()
                }
                this.renderBackgroundColor()
          
                if (this.sprite != null) {
                  var alpha = this.sprite.getAlpha()
                  this.sprite
                    .setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
                    .scaleToFillStretched(this.area.getWidth(), this.area.getHeight())
                    .render(
                      this.context.area.getX() + this.area.getX(),
                      this.context.area.getY() + this.area.getY())
                    .setAlpha(alpha)
                }
          
                if (this.label != null) {
                  this.label.alpha = this.backgroundAlpha
                  this.label.render(
                    // todo VALIGN HALIGN
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                    this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2),
                    this.area.getWidth(), 
                    this.area.getHeight()
                  )
                }
    
                if (this.isHoverOver && this.enable.value) {
                  var text = this.label.text
                  this.label.text = this.description
                  this.label.render(
                    // todo VALIGN HALIGN
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                    this.context.area.getY() + this.area.getY() - 4.0 // + (this.area.getHeight() / 2)
                  )
                  this.label.text = text
                }
                return this
              },
            },
            null,//VEStyles.get("ve-track-control").button,
            false
          ),
          "slider-ve-track-control_zoom": Struct.appendRecursive({ 
            type: UISliderHorizontal,
            layout: layout.nodes.zoom,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            getClipboard: Beans.get(BeanVisuEditorIO).mouse.getClipboard,
            setClipboard: Beans.get(BeanVisuEditorIO).mouse.setClipboard,
            minValue: 5.0,
            maxValue: 20.0,
            //snapValue: 1.0 / 15.0,
            store: { key: "timeline-zoom" },
            onMouseHoverOver: function(event) { },
            onMouseHoverOut: function(event) { },
            updatePosition: function(mouseX) {
              var controller = Beans.get(BeanVisuController)
              var editor = Beans.get(BeanVisuEditorController)
              var ruler = editor.uiService.find("ve-timeline-ruler")
              if (Optional.is(ruler)) {
                ruler.finishUpdateTimer()
              }
  
              var events = editor.uiService.find("ve-timeline-events")
              if (Optional.is(events)) {
                events.finishUpdateTimer()
              }
            },
            postRender: function() {
              if (!this.isHoverOver) {
                return
              }

              var label = Struct.get(this, "label")
              if (!Optional.is(label)) {
                label = new UILabel({
                  text: "Zoom In/Out\n( + / - )",
                  color: VETheme.color.textShadow,
                  align: { v: VAlign.BOTTOM, h: HAlign.CENTER },
                  useScale: false,
                  outline: true,
                  outlineColor: VETheme.color.sideDark,
                  font: "font_inter_8_bold",
                })

                Struct.set(this, "label", label)
              }

              this.label.render(
                // todo VALIGN HALIGN
                this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2),
                this.context.area.getY() + this.area.getY()// + (this.area.getHeight() / 2)
              )
            }
          }, VEStyles.get("slider-horizontal"), false),
        },
      })
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.containers = this.factoryContainers(event.data.layout)
      containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService)
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function(container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETrackControl}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VETrackControl dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}