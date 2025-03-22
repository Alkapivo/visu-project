///@package io.alkapivo.visu.renderer

///@type {Number}
#macro BREATH_TIMER_FACTOR_1 10.0

///@type {Number}
#macro BREATH_TIMER_FACTOR_2 -7.5


///@param {?Struct} [config]
function GridCamera(config = null) constructor {
    
	///@type {Number}
	x = Struct.getIfType(config, "x", Number, 4096)

  ///@type {Number}
	y = Struct.getIfType(config, "y", Number, 6656)

  ///@type {Number}1
	z = Struct.getIfType(config, "z", Number, 5000)

  ///@type {Number}
	angle = Struct.getIfType(config, "angle", Number, 270.0)

  ///@type {Number}
	pitch = Struct.getIfType(config, "pitch", Number, -32.5)

  ///@type {Timer}
  breathTimer1 = new Timer(TAU, { amount: 0.0064, loop: Infinity })

  ///@type {Timer}
  breathTimer2 = new Timer(TAU, { amount: 0.0016, loop: Infinity })

  ///@type {?GMMatrix}
  viewMatrix = null

	///@type {?GMMatrix}
	projectionMatrix = null

	///@type {Boolean}
	enableMouseLook = Struct.getIfType(config, "enableMouseLook", Boolean, false)

	///@type {Boolean}
	enableKeyboardLook = Struct.getIfType(config, "enableKeyboardLook", Boolean, false)

	///@type {Number}
	moveSpeed = Struct.getIfType(config, "moveSpeed", Number, 16.0)

	///@type {?GMCamera}
	gmCamera = camera_create()

  ///@return {GMCamera}
  get = function() {
    if (!Core.isType(this.gmCamera, GMCamera)) {
      this.gmCamera = camera_create()
    }

    return this.gmCamera
  }

  ///@type {?GMMatrix}
  ///@return {GridCamera}
  setViewMatrix = function(matrix) {
    if (!Core.isType(this.gmCamera, GMCamera)) {
      this.gmCamera = camera_create()
    }

    if (Core.isType(matrix, GMMatrix)) {
      this.viewMatrix = matrix
      camera_set_view_mat(this.gmCamera, matrix)
    }
    
    return this
  }
  
  ///@type {?GMMatrix}
  ///@return {GridCamera}
  setProjectionMatrix = function(matrix) {
    if (!Core.isType(this.gmCamera, GMCamera)) {
      this.gmCamera = camera_create()
    }

    if (Core.isType(matrix, GMMatrix)) {
      this.projectionMatrix = matrix
      camera_set_proj_mat(this.gmCamera, matrix)
    }

    return this
  }

  ///@return {GridCamera}
  apply = function() {
    if (!Core.isType(this.gmCamera, GMCamera)) {
      this.gmCamera = camera_create()
    }

    camera_apply(this.gmCamera)
    return this
  }

	///@param {UILayout} layout
	///@return {Camera}
	update = function(layout) {
    var editor = Beans.get(BeanVisuEditorController)
    var enableEditor = true;//Optional.is(editor) && editor.renderUI
    var enableDebugOverlay = is_debug_overlay_open()
    if ((enableEditor || enableDebugOverlay) && this.enableMouseLook && keyboard_check(vk_alt)) {
      var _x = layout.x()
      var _y = layout.y()
      var width = layout.width()
      var height = layout.height()
      var offsetX = MouseUtil.getMouseX() - _x - (width / 2.0)
      var offsetY = MouseUtil.getMouseY() - _y - (height / 2.0)
      var factor = 24.0
			this.angle = clamp(this.angle - ((abs(offsetX) <= 1.0 ? 0.0 : offsetX) / factor), -360.0, 360.0)
			this.pitch = clamp(this.pitch - ((abs(offsetY) <= 1.0 ? 0.0 : offsetY) / factor), -89.0, 89.0)
			window_mouse_set(_x + ceil(width / 2.0), _y + ceil(height / 2.0))
		}

		if ((enableEditor || enableDebugOverlay) && this.enableKeyboardLook && keyboard_check(vk_alt)) {
			var dx = 0
			var dy = 0
			var dz = 0
			if (keyboard_check(ord("A"))) {
				dx += dsin(this.angle) * moveSpeed
				dy += dcos(this.angle) * moveSpeed
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}
	
			if (keyboard_check(ord("D"))) {
				dx -= dsin(this.angle) * moveSpeed
				dy -= dcos(this.angle) * moveSpeed
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}
	
			if (keyboard_check(ord("W"))) {
				dx -= dcos(this.angle) * moveSpeed
				dy += dsin(this.angle) * moveSpeed
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}
	
			if (keyboard_check(ord("S"))) {
				dx += dcos(this.angle) * moveSpeed
				dy -= dsin(this.angle) * moveSpeed
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}

			/* 
			if (keyboard_check(ord("Q"))) {
				this.angle += 0.1
				Logger.debug("GridCamera", $"angle: {this.angle}")
			}

			if (keyboard_check(ord("E"))) {
				this.angle -= 0.1
				Logger.debug("GridCamera", $"angle: {this.angle}")
			}
			*/
	
			if (mouse_wheel_up()) {
				dz += moveSpeed * 10
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}
	
			if (mouse_wheel_down()) {
				dz -= moveSpeed * 10
				Logger.debug("GridCamera", $"x: {this.x}, y: {this.y} z: {this.z}")
			}
			this.x += dx
			this.y += dy
			this.z += dz
		}

		return this
	}

  ///@return {GridCamera}
  free = function() {
    if (Core.isType(this.gmCamera, GMCamera)) {
      camera_destroy(this.gmCamera)
      this.gmCamera = null
    }

    return this
  }
}
