
///@package io.alkapivo.core.service.input

#macro GMMouseButton "GMMouseButton"

///@enum
function _MouseButtonType(): Enum() constructor {
  ANY = mb_any
  LEFT = mb_left
  MIDDLE = mb_middle
  NONE = mb_none
  RIGHT = mb_right
  WHEEL_UP = mouse_wheel_up
  WHEEL_DOWN = mouse_wheel_down
}
global.__MouseButtonType = new _MouseButtonType()
#macro MouseButtonType global.__MouseButtonType


///@param {MouseButtonType} type
function MouseButton(_type) constructor {

  ///@type {GMMouseButton}
  type = Assert.isEnum(_type, MouseButtonType)

  ///@type {Boolean}
  on = false

  ///@type {Boolean}
  pressed = false

  ///@type {Boolean}
  released = false

  ///@type {Boolean}
  drag = false

  ///@type {Boolean}
  dragging = false

  ///@type {Boolean}
  drop = false

  ///@type {Number}
  dragTreshold = 3

  ///@type {?Vector2}
  lastPressedPosition = null
}


///@type {Struct}
function Mouse(json) constructor {
  
  ///@type {Struct}
  buttons = Struct.map(json, function(type, name) {
    return new MouseButton(type)
  })

  ///@return {Mouse}
  update = function() {
    static buttonUpdate = function(button) {
      if (button.type == MouseButtonType.WHEEL_UP 
        || button.type == MouseButtonType.WHEEL_DOWN) {
        
        if (button.type()) {
          button.pressed = button.on ? false : true
          button.on = true
          button.release = false
          button.drop = false
          button.drag = false
          button.dragging = false
        } else {
          button.released = button.on ? true : false
          button.on = false
          button.pressed = false
          button.drop = false
          button.drag = false
          button.dragging = false
        }
      } else {
        button.on = mouse_check_button(button.type)
        button.pressed = mouse_check_button_pressed(button.type)
        button.released = mouse_check_button_released(button.type)
        var clipboard = MouseUtil.getClipboard()

        if (button.dragging && !button.on && !button.released && !button.pressed) {
          button.released = true
          button.drop = true
        }

        if (button.drop) {
          button.drop = false

          if (Core.isType(clipboard, Promise)) {
            clipboard.fullfill()
          }

          if (Core.isType(Struct.get(clipboard, "drop"), Callable)) {
            clipboard.drop()
          }
          MouseUtil.clearClipboard()
        }

        if (button.pressed) {
          button.lastPressedPosition = new Vector2(MouseUtil.getMouseX(), MouseUtil.getMouseY())
          button.drop = false
          button.drag = false
          button.dragging = false
        }

        if (button.released) {
          button.lastPressedPosition = null
          button.drop = button.dragging == true
          button.drag = false
          button.dragging = false
          if (button.drop) {
            button.released = false
          }
        }

        if (button.on && !button.pressed && button.drag == true 
          && button.dragging == false) {
          
          button.drop = false
          button.drag = false
          button.dragging = true

          if (Core.isType(Struct.get(clipboard, "drag"), Callable)) {
            clipboard.drag()
          }
        }

        var vec2 = button.lastPressedPosition 
        if (button.on && !button.pressed && button.drag == false 
          && button.dragging == false && Core.isType(vec2, Vector2) 
          && Math.fetchLength(vec2.x, vec2.y, MouseUtil.getMouseX(), MouseUtil.getMouseY()) > button.dragTreshold) {
          
          button.drop = false
          button.drag = true
          button.dragging = false
        }
      }
    }

    Struct.forEach(this.buttons, buttonUpdate)
    return this
  }
}


///@static
function _MouseUtil() constructor {

  ///@type {any}
  clipboard = null

  ///@type {?Sprite}
  sprite = null

  ///@param {any} item
  ///@return {MouseUtil}
  setClipboard = function(item) {
    this.clipboard = item
    var mouseSprite = Struct.get(item, "sprite")
    if (Core.isType(mouseSprite, Sprite)) {
      this.sprite = new Sprite(mouseSprite.texture, mouseSprite)
    }
    return this
  }

  ///@return {any}
  getClipboard = function() {
    return this.clipboard
  }

  ///@return {MouseUtil}
  clearClipboard = function() {
    this.clipboard = null
    this.sprite = null
    return this
  }

  renderSprite = function() {
    if (Core.isType(this.sprite, Sprite)) {
      this.sprite.alpha = clamp(this.sprite.alpha - 0.04, 0.5, 1.0)
      this.sprite.render(MouseUtil.getMouseX(), MouseUtil.getMouseY())
    }
  }

  ///@return {Number}
  getMouseX = function() {
    return device_mouse_x_to_gui(0)//window_mouse_get_x()
  }

  ///@return {Number}
  getMouseY = function() {
    return device_mouse_y_to_gui(0)//window_mouse_get_y()
  }

  ///@return {Number}
  getMouseDeltaX = function() {
    return window_mouse_get_delta_x()
  }

  ///@return {Number}
  getMouseDeltaY = function() {
    return window_mouse_get_delta_y()
  }

  ///@return {Boolean}
  hasMoved = function() {
    return this.getMouseDeltaX() != 0 || this.getMouseDeltaY() != 0
  }
}
global.__MouseUtil = new _MouseUtil()
#macro MouseUtil global.__MouseUtil
