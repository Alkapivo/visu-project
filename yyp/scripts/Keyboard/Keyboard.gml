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
  DELETE = vk_delete
  END = vk_end
  PLUS = 187
  MINUS = 189
  NUM_PLUS = vk_add
  NUM_MINUS = vk_subtract
  PAGE_UP = 33
  PAGE_DOWN = 34
}
global.__KeyboardKeyType = new _KeyboardKeyType()
#macro KeyboardKeyType global.__KeyboardKeyType


///@type {Struct}
global.__KeyboardSpecialKeys = {
  keys: {
    "_92": "WIN_KEY",
    "_12": "NUM 5",
    "_19": "PAUSE",
    "_20": "CAPS_LOCK",
    "_91": "WIN_KEY",
    "_93": "CONTEXT_MENU",
    "_96": "NUM 0",
    "_97": "NUM 1",
    "_98": "NUM 2",
    "_99": "NUM 3",
    "_100": "NUM 4",
    "_101": "NUM 5",
    "_102": "NUM 6",
    "_103": "NUM 7",
    "_104": "NUM 8",
    "_105": "NUM 9",
    "_106": "NUM *",
    "_107": "NUM +",
    "_109": "NUM -",
    "_110": "NUM .",
    "_111": "NUM /",
    "_144": "NUMLOCK",
    "_173": "MUTE",
    "_174": "VOLUME_DOWN",
    "_175": "VOLUME_UP",
    "_186": ";",
    "_187": "=",
    "_188": ",",
    "_189": "-",
    "_190": ".",
    "_191": "/",
    "_192": "`",
    "_219": "[",
    "_220": "\\",
    "_221": "]",
    "_222": "'",
    "_223": "`",
  },
  contains: function(keyCode) {
    return Struct.contains(this.keys, $"_{keyCode}")
  }, 
  get: function(keyCode) {
    return Struct.get(this.keys, $"_{keyCode}")
  },
}
#macro KeyboardSpecialKeys global.__KeyboardSpecialKeys


///@param {KeyboardKeyType|String} key
function KeyboardKey(key) constructor {

  ///@type {GMKeyboardKey}
  gmKey = KeyboardKeyType.contains(key) || Core.isType(key, Number) ? key : ord(Assert.isType(key, String))

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

  ///@param {String} name
  ///@param {Number|String} key
  ///@return {Keyboard}
  setKey = function(name, key) {
    Struct.set(this.keys, name, new KeyboardKey(key))
    return this
  }

  ///@return {Keyboard}
  update = function() {
    static keysUpdate = function(key) {
      key.on = keyboard_check(key.gmKey)
      key.pressed = keyboard_check_pressed(key.gmKey)
      key.released = keyboard_check_released(key.gmKey)
    }
    
    Struct.forEach(this.keys, keysUpdate)
    return this
  }
}
