///@package io.alkapivo.core.service.dialogue-designer

function DialogueRenderer() constructor {

  ///@type {Font}
  font = Assert.isType(FontUtil.parse({ name: "font_kodeo_mono_18_regular" }), Font)

  ///@type {?Struct}
  context = null

  ///@return {DialogueRenderer}
  update = function() {
    var dialog = Beans.get(BeanDialogueDesignerService).dialog
    if (!Core.isType(dialog, DDDialogue)) {
      this.context = null
      return this
    }

    var lang = "ENG"
    if (Struct.get(this.context, "current") != dialog.current) {
      this.context = {
        text: this.parseDialogueText(dialog.current.getText(lang)),
        choices: dialog.current.getChoicesText(lang),
        current: dialog.current
      }
    }

    if (Core.isType(this.context, Struct)) {
      this.context.text.anykeyConsumed = false
    }
    return this
  }



  layout = new UILayout({
    name: "dialog",
    width: function() { return clamp(GuiWidth(), 800, 1280) },
    height: function() { return 360 },
    x: function() { return (GuiWidth() - this.width()) / 2.0 },
    y: function() { return GuiHeight() - this.height() - 96 },
    nodes: {
      avatar: {
        name: "dialog-avatar",
        width: function() { return this.context.height() },
        height: function() { return this.context.height() },
      },
      text: {
        name: "dialog-text",
        width: function() { return this.context.width() - this.context.nodes.avatar.width() },
        height: function() { return this.context.height() },
        x: function() { return this.context.nodes.avatar.right() },
      },
    }
  })

  ///@param {String} text
  ///@return {Struct}
  parseDialogueText = function(text) {
    var size = String.size(text)
    var start = 1
    var parsed = {
      pointer: 0,
      finished: false,
      anykeyConsumed: false,
      buffer: "",
      speed: 1,
      text: new Array(Struct)
    }
  
    var chars = ""
    for (var index = 1; index <= size; index++) {
      var char = String.getChar(text, index)
      if (char != "{") {
        chars = $"{chars}{char}"
        if (index == size) {
          parsed.text.add({
            type: "text",
            data: {
              pointer: 1,
              text: chars
            }
          })
          chars = ""  
        }
      } else {
        parsed.text.add({
          type: "text",
          data: {
            pointer: 1,
            text: chars
          }
        })
        chars = ""
  
        var command = ""
        for (var idx = index + 1; idx <= size; idx++) {
          var commandChar = String.getChar(text, idx)
          if (commandChar == "}") {
            start = idx + 1
            index = idx
            break
          }
          command = $"{command}{commandChar}"
        }
  
        if (String.contains(command, "=")) {
          command = String.split(command, "=")
          switch (command.get(0)) {
            case "w":
              parsed.text.add({
                type: "wait",
                data: {
                  timer: new Timer(NumberUtil.parse(command.get(1), 0))
                }
              })
              break
            case "spd":
              parsed.text.add({
                type: "speed",
                data: {
                  value: NumberUtil.parse(command.get(1), 1)
                }
              })
              break
          }
          
        } else {
          switch (command) {
            case "w":
              parsed.text.add({
                type: "wait"
              })
              break
            case "nw":
              parsed.text.add({
                type: "no-wait"
              })
              break
          }
        }
      }
    }
  
    return parsed
  }

  bazyl = SpriteUtil.parse({ name: "texture_baron" })
  bazylTheta = 0.0

  ///@param {Struct} parsed
  ///@return {DialogueRenderer}
  renderDialogue = function(parsed) {
    if (parsed.pointer >= parsed.text.size()) {
      return 
    }

    var entry = parsed.text.get(parsed.pointer)
    var displayText = ""
    if (!parsed.finished) {
      switch (entry.type) {
        case "text": 
          displayText = String.copy(entry.data.text, 1, ceil(entry.data.pointer))
          entry.data.pointer = entry.data.pointer + parsed.speed
          if (entry.data.pointer > String.size(entry.data.text)) {
            parsed.buffer = $"{parsed.buffer}{displayText}"
            displayText = ""
            if (parsed.pointer + 1 >= parsed.text.size()) {
              parsed.finished = true
            } else {
              parsed.pointer = parsed.pointer + 1
            }
          }
          break
        case "wait":
          if (Core.isType(Struct.get(Struct.get(entry, "data"), "timer"), Timer)) {
            if (entry.data.timer.update().finished) {
              if (parsed.pointer + 1 >= parsed.text.size()) {
                parsed.finished = true
              } else {
                parsed.pointer = parsed.pointer + 1
              }
            }
          }
          if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any)) {
            parsed.anykeyConsumed = true
            if (parsed.pointer + 1 >= parsed.text.size()) {
              parsed.finished = true
            } else {
              parsed.pointer = parsed.pointer + 1
            }
          }
          break
        case "no-wait":
          Beans.get(BeanDialogueDesignerService).dialog.select()
          if (parsed.pointer + 1 >= parsed.text.size()) {
            parsed.finished = true
          } else {
            parsed.pointer = parsed.pointer + 1
          }
          break
        case "speed":
          parsed.speed = entry.data.value
          if (parsed.pointer + 1 >= parsed.text.size()) {
            parsed.finished = true
          } else {
            parsed.pointer = parsed.pointer + 1
          }
          break
      }
    }
  
    var font = FontUtil.parse({ name: "font_kodeo_mono_28_regular" })
    draw_set_font(font.asset)

    this.bazylTheta += choose(0.05, 0.1, 0.1, 0.15)
    if (this.bazylTheta > pi * 2) {
      this.bazylTheta = 0
    }

    var avatar = this.layout.nodes.avatar
    if (irandom(10) >= 7) {
      this.bazyl
        .scaleToFill(avatar.width() * 0.8, avatar.height() * 0.8)
    }

    if (entry.type != "wait" && !parsed.finished) {
      this.bazyl
        .setScaleX(this.bazyl.scaleX - (cos(this.bazylTheta + choose(0, 0, 0.1, 0.15)) * choose(0.01, 0.05, 0.1, 0.15) * parsed.speed))
        .setScaleY(this.bazyl.scaleY - (sin(this.bazylTheta + choose(0, 0, 0.1, 0.15)) * choose(0.01, 0.05, 0.1, 0.15) * parsed.speed))
        .setAngle(this.bazyl.angle + cos(this.bazylTheta) * choose(0, 0.05, 0.1, 0.15) * parsed.speed)
    }
    
    this.bazyl.render(avatar.x() + sin(this.bazylTheta), avatar.y() + cos(this.bazylTheta))

    GPU.render.text(
      this.layout.nodes.text.x(),
      this.layout.nodes.text.y(),
      String.wrapText($"{parsed.buffer}{displayText}", this.layout.nodes.text.width(), "\n", 1),
      c_white,
      c_black,
      1.0,
      font, 
      HAlign.LEFT,
      VAlign.TOP
    )

    return this
  }

  ///@return {DialogueRenderer}
  render = function() {
    if (Core.isType(this.context, Struct)) {
      this.renderDialogue(this.context.text)

      var dialog = Beans.get(BeanDialogueDesignerService).dialog
      if (this.context.text.finished 
        && !this.context.text.anykeyConsumed 
        && Core.isType(dialog, DDDialogue)) {

        if (Core.isType(dialog.current, DDNode)) {
          var dispatched = false
          var choices = Struct.get(dialog.current, "choices")
          if (Core.isType(choices, Array)) {
            var size = choices.size()
            for (var index = 0; index < size; index++) {
              if (keyboard_check_pressed(ord($"{index + 1}"))) {
                dialog.select(index)
                dispatched = true
                break
              }
            }
          }
          
          if (!dispatched && keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any)) {
            dialog.select()
          }
        } 
      }

      if (this.context.text.finished && Core.isType(this.context.choices, Array)) {
        this.context.choices.forEach(function(choice, index, acc) {

          var _x = acc.layout.x() + (acc.layout.width() / 2)
          var width = GuiWidth() - _x
          var height = 48
          var margin = 12
          var _y = acc.layout.y() - ((acc.size - index) * height) - margin,
          
          var hoverColor = point_in_rectangle(acc.mouseX, acc.mouseY, _x, _y, _x + width, _y + height)
            ? c_yellow
            : c_white

          if (hoverColor == c_yellow && mouse_check_button_pressed(mb_left)) {
            Beans.get(BeanDialogueDesignerService).dialog.select(index)
          }

          GPU.render.text(
            _x, _y,
            $"{index + 1}. {choice}",
            hoverColor, c_black,
            1.0,
            acc.font, 
            HAlign.LEFT, VAlign.TOP
          )
        }, {
          font: this.font,
          layout: this.layout,
          size: this.context.choices.size(),
          mouseX: MouseUtil.getMouseX(),
          mouseY: MouseUtil.getMouseY(),
        })
      }
    }

    return this
  }
}


