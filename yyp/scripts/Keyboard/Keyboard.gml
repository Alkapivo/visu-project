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
  ///@return {?KeyboardKey}
  getKey = function(name) {
    return Struct.getIfType(keys, name, KeyboardKey)
  }

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


///@param {?Struct} json
function PrioritizedPressedKeyUpdater(json = null) constructor {

  ///@private
  ///@type {Timer}
  treshold = new Timer(Struct.getIfType(json, "treshold", Number, 0.5))

  ///@private
  ///@type {Timer}
  cooldown = new Timer(Struct.getIfType(json, "treshold", Number, 0.1), { loop: Infinity })

  ///@private
  ///@type {Array<Struct>}
  keys = new Array(Struct, Struct.getIfType(json, "keys", GMArray, [
    {
      name: "up",
      gmKey: KeyboardKeyType.ARROW_UP,
    },
    {
      name: "down",
      gmKey: KeyboardKeyType.ARROW_DOWN,
    },
    {
      name: "left",
      gmKey: KeyboardKeyType.ARROW_LEFT,
    },
    {
      name: "right",
      gmKey: KeyboardKeyType.ARROW_RIGHT,
    }
  ])).forEach(function(key) {
    Assert.isTrue(Optional.is(Struct.getIfType(key, "name", String)))
    var gmKey = Struct.get(key, "gmKey")
    Assert.isTrue(Optional.is(KeyboardKeyType.contains(gmKey) || Core.isType(gmKey, Number) 
      ? gmKey : ord(Assert.isType(gmKey, String))))
  })

  ///@private  
  ///@type {Array<Struct>}
  buffer = new Array(Struct).enableGC()

  ///@private
  ///@type {?Struct}
  current = null

  ///@param {Keyboard}
  ///@return {PrioritizedPressedKeyUpdater}
  bindKeyboardKeys = function(keyboard) {
    this.keys.forEach(function(key, index, keyboard) {
      var keyboardKey = keyboard.getKey(key.name)
      if (Optional.is(keyboardKey)) {
        key.gmKey = keyboardKey.gmKey
      }
    }, keyboard)

    return this
  }

  ///@param {Keyboard} keyboard
  ///@return {PrioritizedPressedKeyUpdater}
  updateKeyboard = function(keyboard) {
    static checkPressed = function(key, index, buffer) {
      if (keyboard_check_pressed(key.gmKey)) {
        buffer.add(key)
      }
    }

    static checkReleased = function(key, index, buffer) {
      if (!keyboard_check(key.gmKey) 
          || keyboard_check_released(key.gmKey)) {
        buffer.addToGC(index)
      }
    }

    this.keys.forEach(checkPressed, this.buffer)
    this.buffer.forEach(checkReleased, this.buffer).runGC()
    if (this.current != this.buffer.getLast()) {
      this.current = this.buffer.getLast()
      this.cooldown.reset()
      this.treshold.reset()
    }

    if (Optional.is(this.current)
        && this.treshold.update().finished
        && this.cooldown.update().finished) {
      
      var key = keyboard.getKey(this.current.name)
      if (Optional.is(key)) {
        key.pressed = true
      }
    }
    
    return this
  }
}