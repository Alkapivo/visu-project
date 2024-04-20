///@package io.alkapivo.core.service.input

#macro GMKeyboardKey "GMKeyboardKey"

///@enum
function _KeyboardKeyType(): Enum() constructor {
  ARROW_UP = vk_up
  ARROW_DOWN = vk_down
  ARROW_LEFT = vk_left
  ARROW_RIGHT = vk_right
  ESC = vk_escape
  ENTER = vk_enter
  SPACE = vk_space
  CONTROL = vk_control
  CONTROL_LEFT = vk_lcontrol
  CONTROL_RIGHT = vk_rcontrol
  SHIFT = vk_shift
  SHIFT_LEFT = vk_lshift
  SHIFT_RIGHT = vk_rshift
  ALT = vk_alt
  ALT_LEFT = vk_lalt
  ALT_RIGHT = vk_ralt
  TAB = vk_tab
  F1 = vk_f1
  F2 = vk_f2
  F3 = vk_f3
  F4 = vk_f4
  F5 = vk_f5
  F6 = vk_f6
  F7 = vk_f7
  F8 = vk_f8
  F9 = vk_f9
  F10 = vk_f10
  F11 = vk_f11
  F12 = vk_f12
  BACKSPACE = vk_backspace
  HOME = vk_home
  INSERT = vk_insert
  END = vk_end
  PLUS = 187
  MINUS = 189
  NUM_PLUS = vk_add
  NUM_MINUS = vk_subtract
}
global.__KeyboardKeyType = new _KeyboardKeyType()
#macro KeyboardKeyType global.__KeyboardKeyType


///@param {KeyboardKeyType|String} key
function KeyboardKey(key) constructor {

  ///@type {GMKeyboardKey}
  gmKey = KeyboardKeyType.contains(key) ? key : ord(Assert.isType(key, String))

  ///@type {Boolean}
  on = false

  ///@type {Boolean}
  pressed = false

  ///@type {Boolean}
  released = false
}


///@param {Struct} json
function Keyboard(json) constructor {
  
  ///@type {Struct}
  keys = Struct.map(json, function(key) {
    return new KeyboardKey(key)
  })

  ///@return {Keyboard}
  update = method(this, function() {
    static keysUpdate = function(key) {
      key.on = keyboard_check(key.gmKey)
      key.pressed = keyboard_check_pressed(key.gmKey)
      key.released = keyboard_check_released(key.gmKey)
    }
    
    Struct.forEach(this.keys, keysUpdate)
    return this
  })
}
