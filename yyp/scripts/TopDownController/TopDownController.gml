///@package io.alkapivo.neon-baron

#macro BeanTopDownController "BeanTopDownController"
function TopDownController() constructor {

  ///@type {BaronService}
  baronService = new BaronService(this)

  ///@type {NPCService}
  npcService = new NPCService(this)

  ///@type {Boolean}
  renderEnabled = true

  ///@type {Boolean}
  renderGUIEnabled = true

  ///@param {Boolean} value
  ///@return {TopDownController}
  setRenderEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@param {Boolean} value
  ///@return {TopDownController}
  setRenderGUIEnabled = function(value) {
    this.renderEnabled = value
    return this
  }

  ///@return {TopDownController}
  update = function() {
    baronService.update()
    npcService.update()
    return this
  }

  ///@return {TopDownController}
  render = function() {
    if (!this.renderEnabled) {
      return this
    }

    this.baronService.render()
    this.npcService.render()

    return this
  }

  ///@return {TopDownController}
  renderGUI = function() {
    if (!this.renderGUIEnabled) {
      return this
    }

    return this
  }
}


///@param {Struct} json
function Baron(json): TDMC(json) constructor {
  ///@type {Number}
  x = Assert.isType(json.x, Number)

  ///@type {Number}
  y = Assert.isType(json.y, Number)
  
  ///@type {Sprite}
  sprite = SpriteUtil.parse({ name: "texture_baron_cursor" }) //Assert.isType(json.sprite, Sprite)
}


///@param {TopDownController} _controller
function BaronService(_controller) constructor {

  ///@type {TopDownController}
  controller = Assert.isType(_controller, TopDownController)

  ///@type {?Baron}
  baron = null

  ///@type {Number}
  zoom = 1

  ///@return {TopDownController}
  initView = function(width, height) {
    view_enabled = true
    view_visible[0] = true
    view_xport[0] = 0
    view_yport[0] = 0
    view_wport[0] = width
    view_hport[0] = height
    view_camera[0] = camera_create_view(0, 0, view_wport[0], view_hport[0], 0, noone, -1, -1, 0, 0)
    return this
  }

  ///@return {BaronService}
  updateView = function() {
    var _hor = keyboard_check(vk_right) - keyboard_check(vk_left)
    var _ver = keyboard_check(vk_down) - keyboard_check(vk_up)
    var _viewX = camera_get_view_x(view_camera[0])
    var _viewY = camera_get_view_y(view_camera[0])
    var _viewW = camera_get_view_width(view_camera[0])
    var _viewH = camera_get_view_height(view_camera[0])
    var _gotoX = this.baron.x + (_hor * 0) - (_viewW * 0.5)
    var _gotoY = this.baron.y + (_ver * 0) - (_viewH * 0.5)
    var _newX = lerp(_viewX, _gotoX, 0.03)
    var _newY = lerp(_viewY, _gotoY, 0.03)
    //camera_set_view_pos(view_camera[0], _newX, _newY)

    var _factor = 0.05
    var _mouseW = mouse_wheel_down() - mouse_wheel_up()
    this.zoom = clamp(this.zoom + (_mouseW * _factor), _factor, 2)
    var _lerpH = lerp(_viewH, this.zoom * GuiHeight(), _factor)
    var _newH = clamp(_lerpH, 0, room_height)
    var _newW = _newH * (GuiWidth() / GuiHeight())
    camera_set_view_size(view_camera[0], _newW, _newH)

    var _offsetX = _newX - (_newW - _viewW) * 0.2
    var _offsetY = _newY - (_newH - _viewH) * 0.2
    _newX = clamp(_offsetX, 0, room_width - _newW)
    _newY = clamp(_offsetY, 0, room_height - _newH)
    camera_set_view_pos(view_camera[0], _newX, _newY)

    return this
  }

  ///@return {BaronService}
  update = function() {
    if (!Optional.is(this.baron)) {
      return this
    }

    this.updateView()
    this.baron.update()
    return this
  }

  ///@return {BaronService}
  render = function() {
    if (!Optional.is(this.baron)) {
      return this
    }

    this.baron.sprite.render(this.baron.x, this.baron.y)
    return this
  }

  this.initView(GuiWidth(), GuiHeight())
}


///@param {Struct} json
function NPC(json) constructor {

  ///@type {Number}
  x = Assert.isType(json.x, Number)

  ///@type {Number}
  y = Assert.isType(json.y, Number)

  ///@type {Sprite}
  sprite = SpriteUtil.parse({ name: "texture_bazyl_cursor" })//Assert.isType(json.sprite, Sprite)

  ///@type {?String}
  dialog = Core.isType(Struct.get(json, "dialog"), String) ? json.dialog : null
}


///@param {TopDownController} _controller
function NPCService(_controller) constructor {

  ///@type {TopDownController}
  controller = Assert.isType(_controller, TopDownController)

  npcs = new Map(String, NPC)

  ///@return {NPCService}
  update = function() {
    return this
  }

  ///@return {NPCService}
  render = function() {
    this.npcs.forEach(function(npc) {
      npc.sprite.render(npc.x, npc.y)
    })
    return this
  }
}

function NeonBaronState(json) constructor {

  ///@type {BaronState}
  baron = new BaronState(json.baron)

  ///@type {?Struct}
  worlds = Core.isType(Struct.get(json, "worlds"), Struct)
    ? Struct.map(json.worlds, function(world) {
      return new WorldState(world)
    })
    : null

  ///@return {Struct}
  serialize = function() {
    return {
      baron: this.baron.serialize(),
      worlds: Optional.is(this.worlds) ? this.worlds.serialize() : null
    }
  }
}

///@param {Struct} json
function BaronState(json) constructor {
  
  ///@type {String}
  world = Assert.isType(json.world, String)

  ///@type {String}
  level = Assert.isType(json.level, String)

  ///@type {Number}
  x = Assert.isType(json.x, Number)

  ///@type {Number}
  y = Assert.isType(json.y, Number)

  ///@return {Struct}
  serialize = function() {
    return {
      world: this.world,
      level: this.level,
      x: this.x,
      y: this.y,
    }
  }
}

///@param {Struct} json
function WorldState(json) constructor {

  ///@type {Struct}
  levels = Struct.map(json.levels, function(level) {
    return new LevelState(level)
  })

  ///@return {Struct}
  serialize = function() {
    return {
      levels: Struct.map(this.levels, function(level) {
        return level.serialize()
      })
    }
  }
}

///@param {Struct} json
function LevelState(json) constructor {

  ///@param {Struct}
  const = Assert.isType(Struct.getDefault(json, "const", {}), Struct)

  ///@param {?Struct}
  dynamic = Core.isType(json, "dynamic", Struct) ? json.dynamic : null

  ///@return {Struct}
  serialize = function() {
    return {
      const: JSON.clone(this.const),
      dynamic: Optional.is(this.dynamic) ? JSON.clone(this.dynamic) : null,
    }
  }
}