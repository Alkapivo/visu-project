///@package com.pixelatedpope.tdmc

#macro MODE_KEYBOARD 0
#macro MODE_DPAD 1
#macro MODE_ANALOG 2
#macro DISP_W display_get_width()
#macro DISP_H display_get_height()
#macro WIN_W window_get_width()
#macro WIN_H window_get_height()
#macro VIEW view_camera[0]
#macro VIEW_X camera_get_view_x(VIEW)
#macro VIEW_Y camera_get_view_y(VIEW)
#macro VIEW_W camera_get_view_width(VIEW)
#macro VIEW_H camera_get_view_height(VIEW)
#macro VIEW_R (VIEW_X + VIEW_W)
#macro VIEW_B (VIEW_Y + VIEW_H)
#macro VIEW_CENTER_X (VIEW_X + VIEW_W/2)
#macro VIEW_CENTER_Y (VIEW_Y + VIEW_H/2)
#macro GUI_W display_get_gui_width()
#macro GUI_H display_get_gui_height()
#macro NO_DIRECTION (-1)
#macro EAST 0
#macro NORTH_EAST 45
#macro NORTH 90
#macro NORTH_WEST 135
#macro WEST 180
#macro SOUTH_WEST 225
#macro SOUTH 270
#macro SOUTH_EAST 315


///@param {Struct} json
function TDMC(json) constructor {

  ///@type {?GMObject}
  gmObject = null

  ///@type {ControlModeType}
  controlMode = MODE_KEYBOARD ///@todo replace with Enum()

  ///@type {Number}
  maxSpeed = Assert.isType(Struct.getDefault(json, "maxSpeed", 1), Number)

  ///@type {Number}
  x = Assert.isType(Struct.getDefault(json, "x", 0), Number)

  ///@type {Number}
  y = Assert.isType(Struct.getDefault(json, "y", 0), Number)

  ///@type {Sprite}
  sprite = SpriteUtil.parse({ name: "texture_baron_cursor" })

  ///@type {Number}
  analogDeadzone = .25;

  ///@return {Struct}
  readDpad = function() {
    var _h =  gamepad_button_check(0, gp_padr) - gamepad_button_check(0, gp_padl)
    var _v = gamepad_button_check(0, gp_padd) - gamepad_button_check(0, gp_padu)
    var _dist = point_distance(0, 0, _h, _v)
    return { h: _h, v: _v, dist: _dist, pressed: _dist > 0 }
  }

  ///@return {Struct}
  readAnalog = function() {
    // Check analog stick
    var _h = gamepad_axis_value(0, gp_axislh)
    var _v = gamepad_axis_value(0, gp_axislv)
    var _dist = point_distance(0, 0, _h, _v)
    return { h: _h, v: _v, dist: _dist, pressed: _dist > analogDeadzone }
  }

  ///@return {Struct}
  readArrows = function() {
    var _h = keyboard_check(vk_right) - keyboard_check(vk_left)
    var _v = keyboard_check(vk_down) - keyboard_check(vk_up)
    var _dist = point_distance(0, 0, _h, _v)
    return { h: _h, v: _v, dist: _dist, pressed: _dist > 0 }
  }

  ///@return {Struct}
  readInput = function() {
    var _input = { factor: 0, h: 0, v: 0 }
    var _dpad = this.readDpad()
    var _analog = this.readAnalog()
    var _arrow = this.readArrows()

    if (_arrow.pressed) {
      this.controlMode = MODE_KEYBOARD
      _input.factor = 1
      _input.h = _arrow.h
      _input.v = _arrow.v
    }
    
    if (_dpad.pressed) {
      this.controlMode = MODE_DPAD
      _input.factor = 1
      _input.h = _dpad.h
      _input.v = _dpad.v
    }
    
    if (_analog.pressed) {
      this.controlMode = MODE_ANALOG
      _input.factor = min(_analog.dist, 1)
      _input.h = _analog.h
      _input.v = _analog.v
    }
    
    _input.dir = point_distance(0, 0, _input.h, _input.v) > 0 
      ? point_direction(0, 0, _input.h, _input.v) 
      : NO_DIRECTION ///@todo replace with Enum()
                
    return _input
  }

  ///@return {TDMC}
  update = function() {
    if (!Core.isType(this.gmObject, GMObject)) {
      return this
    }

    with (this.gmObject) {
      x = baron.x
      y = baron.y
      sprite_index = baron.sprite.texture.asset
      image_index = baron.sprite.frame
      
      var input = baron.readInput()
      move.spdDir(baron.maxSpeed * input.factor, input.dir)
      baron.x = x
      baron.y = y
      
      // Camera
      var _x = clamp(x - VIEW_W / 2, 0, room_width - VIEW_W)
      var _y = clamp(y - VIEW_H / 2, 0, room_height - VIEW_H)
      _x = lerp(VIEW_X, _x, 0.1)
      _y = lerp(VIEW_Y, _y, 0.1)
      camera_set_view_pos_subpixel(VIEW, _x, _y)
    }

    return this
  }

  ///@return {TDMC}
  render = function() {
    this.sprite.render(this.x, this.y)
    return this
  }
}


///@param {GMObjcet} context
///@param {Callable} [_placeMeeting]
///@param {Number} [_cornerSlip]
///@param {Number} [_slipSpd]
///@param {Number} [_catchupFactor]
function use_tdmc(
  _placeMeeting = function(_x, _y) {
    return tile_meeting(_x, _y, "tileset_collision")
  }, 
  _cornerSlip = 16, 
  _slipSpd = 0.5, 
  _catchupFactor = 0.5) {
    
  return {
    drawX: id.x, 
    drawY: id.y,
    againstWall: { hori: 0, vert: 0 },
    
    __iXSpdLeft: 0,
    __iYSpdLeft: 0,
    __iCornerSlip: _cornerSlip,
    __iCornerSlipSpeedFactor: _slipSpd,
    __iOwner: id,
    __iIgnoreCollision: false,
    __iSpriteCatchupFactor: _catchupFactor,
    __iPlaceMeeting: _placeMeeting,
    
    ///@param {Number} _dir
    ///@return {Number}
    __iCornerSlipVert: function(_dir) {
    	for(var _i = 1; _i <= __iCornerSlip; _i++) {
    		if (!__iPlaceMeeting(this.__iOwner.x + _dir, this.__iOwner.y - _i)) {
          return -1
        }

        if (!__iPlaceMeeting(this.__iOwner.x + _dir, this.__iOwner.y + _i)) {
          return 1
        }
      }
    	return 0
    },

    ///@param {Number} _dir
    ///@return {Number}
    __iCornerSlipHori: function(_dir) {
    	for (var _i = 1; _i <= this.__iCornerSlip; _i++) {
    		if (!__iPlaceMeeting(this.__iOwner.x - _i, this.__iOwner.y + _dir)) {
          return -1
        }

        if (!__iPlaceMeeting(this.__iOwner.x + _i, this.__iOwner.y + _dir)) {
          return 1
        }
      }
    	return 0
    },
    
    ///@param {Number} _start
    ///@param {Number} _target
    ///@param {Number} _step
    ///@return {Number}
    __iApproach: function(_start, _target, _step) {
      return _start < _target
        ? min(_start + _step, _target)
        : max(_start - _step, _target)
    },
    
    ///@return {Struct}
    __iUpdateDrawPos: function() {
      this.drawX = lerp(this.drawX, this.__iOwner.x, this.__iSpriteCatchupFactor)
      this.drawY = lerp(this.drawY, this.__iOwner.y, this.__iSpriteCatchupFactor)
      return this
    },
    
    ///@return {Struct}
    __iGtfo: function() {
      var _precision = 1 // Feel free to adjust this to be higher. 1 is a bit extreme
      if (!__iPlaceMeeting(this.__iOwner.x, this.__iOwner.y)) {
        return
      }

      var _curRad = _precision
      var _startX = this.__iOwner.x
      var _startY = this.__iOwner.y
      while (true) {
        for (var _x = -_curRad; _x <= _curRad; _x += _precision) {
          for (var _y = -_curRad; _y <= _curRad; _y += _precision) {
            if (_x > _curRad && _y > _curRad 
              && _x < _curRad && _y < _curRad) {
              continue
            }

            this.__iOwner.x = _startX + _x
            this.__iOwner.y = _startY + _y
            if (!__iPlaceMeeting(this.__iOwner.x, this.__iOwner.y)) {
              Logger.error("tdmc", $"Got the F out after {_curRad / _precision} iterations")
              return this
            }
          }
        }
        _curRad += _precision
      }

      return this
    },
    
    ///@param {Number} _spd
    ///@param {Number} _dir
    ///@return {Struct}
    spdDir: function(_spd, _dir) {
      this.xSpdYSpd(
        lengthdir_x(_spd, _dir), 
        lengthdir_y(_spd, _dir)
      )
      return this
    },
    
    ///@param {Number} _xSpd
    ///@param {Number} _ySpd
    ///@return {Struct}
    xSpdYSpd: function(_xSpd, _ySpd) {
      this.__iGtfo()
      this.againstWall.hori = 0
      this.againstWall.vert = 0
      this.__iXSpdLeft += _xSpd
      this.__iYSpdLeft += _ySpd
      var _againstVert = 0
      var _againstHori = 0
      var _timeout = ceil(abs(this.__iXSpdLeft) + abs(this.__iYSpdLeft)) * 10;
      var _timeoutTimer = 0;
	    while (abs(this.__iXSpdLeft) >= 1 || abs(this.__iYSpdLeft) >= 1) {
    		
        // Hori
        if (abs(__iXSpdLeft) >= 1) {
          var _dir = sign(this.__iXSpdLeft)
          this.__iXSpdLeft = __iApproach(this.__iXSpdLeft, 0, 1)
          if (this.__iIgnoreCollision 
            || !__iPlaceMeeting(this.__iOwner.x + _dir, this.__iOwner.y)) {
              this.__iOwner.x += _dir
            _againstHori = 0
          } else {
            _againstHori = _dir;
            if (!__iPlaceMeeting(this.__iOwner.x + _dir, this.__iOwner.y - 1)) {
              this.__iYSpdLeft -= 1
            } else if (!__iPlaceMeeting(this.__iOwner.x + _dir, this.__iOwner.y + 1)) {
    					this.__iYSpdLeft += 1
            } else {
              this.againstWall.hori = _dir
            }
          }
        } 
        
    		// Vert
        if (abs(this.__iYSpdLeft) >= 1) {
          var _dir = sign(this.__iYSpdLeft)
          this.__iYSpdLeft = __iApproach(this.__iYSpdLeft, 0, 1)
          if (this.__iIgnoreCollision 
            || !__iPlaceMeeting(this.__iOwner.x, this.__iOwner.y + _dir)) {
            this.__iOwner.y += _dir
            _againstVert = 0
          } else {
            _againstVert = _dir
            if (!__iPlaceMeeting(this.__iOwner.x - 1, this.__iOwner.y + _dir)) {
              this.__iXSpdLeft -= 1
            } else if (!__iPlaceMeeting(this.__iOwner.x + 1, this.__iOwner.y + _dir)) {
              this.__iXSpdLeft += 1
            } else {
              this.againstWall.vert = _dir
            }
          }
        } 
        
        _timeoutTimer++
        if (_timeoutTimer > _timeout) {
          this.__iXSpdLeft = 0
          this.__iYSpdLeft = 0
          break
        }
    	}
      
      // Go around Corners
      if (this.againstWall.hori != 0 && this.againstWall.vert == 0) {
          this.__iYSpdLeft += __iCornerSlipVert(this.againstWall.hori) 
            * this.__iCornerSlipSpeedFactor
      }
      
      if (this.againstWall.vert != 0 && this.againstWall.hori == 0) {
        this.__iXSpdLeft += __iCornerSlipHori(this.againstWall.vert) 
          * this.__iCornerSlipSpeedFactor
      }
      
      if(_againstVert != 0 || _againstHori != 0) {
        this.againstWall.hori = _againstHori
        this.againstWall.vert = _againstVert
      }
      __iUpdateDrawPos()

      return this
    }
  }
}


///@param {Number} start
///@param {Number} finish
///@param {Number} shift
function approach(start, finish, shift) {
  return start < finish
    ? min(start + shift, finish)
    : max(start - shift, finish)
}


///@param {GMCamera} _cam
///@param {Number} _x
///@param {Number} _y
function camera_set_view_pos_subpixel(_cam, _x, _y) {
	var	_sw = surface_get_width(application_surface)
	var _vw = camera_get_view_width(_cam)
	var _ratio = _vw / _sw
  
	camera_set_view_pos(_cam, 
    round(_x / _ratio) * _ratio, 
    round(_y / _ratio) * _ratio
  )
}


///@param {Number} _val
///@param {Number} _inc
///@return {Number}
function round_n(_val, _inc) {
	return round(_val / _inc) * _inc
}


///@param {Number} _xPos
///@param {Number} _yPos
///@param {GMLayer} _layer
///@throws {Exception}
///@return {Boolean}
function tile_meeting(_xPos, _yPos, _layer) {
  var _tm = layer_tilemap_get_id(_layer)
 
  ///@todo use Beans
  if (!instance_exists(TDMCScanner)) {
    instance_create_depth(0, 0, 0, TDMCScanner)
  }

  if (_tm == -1 || layer_get_element_type(_tm) != layerelementtype_tilemap) {
    throw new Exception("Checking collision for non existent layer / tilemap")
  }
 
  ///@todo use structs
  var _x1 = tilemap_get_cell_x_at_pixel(_tm, bbox_left + (_xPos - x), y)
  var _y1 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_top + (_yPos - y))
  var _x2 = tilemap_get_cell_x_at_pixel(_tm, bbox_right + (_xPos - x), y)
  var _y2 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_bottom + (_yPos - y))
 
  for (var _x = _x1; _x <= _x2; _x++) {
    for (var _y = _y1; _y <= _y2; _y++) {
      var _tile = tilemap_get(_tm, _x, _y)
      if (!_tile) {
        continue
      }
      
      ///@todo use Beans
      TDMCScanner.x = _x * tilemap_get_tile_width(_tm)
      TDMCScanner.y = _y * tilemap_get_tile_height(_tm)
      TDMCScanner.image_index = _tile;
 
      if (place_meeting(_xPos, _yPos, TDMCScanner)) {
        return true
      }
    }
  }
 
  return false
}