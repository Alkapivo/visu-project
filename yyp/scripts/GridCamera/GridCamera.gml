///@package io.alkapivo.visu.renderer

///@param {?Struct} [config]
function GridCamera(config = null) constructor {
    
	///@type {Number}
	x = Struct.getIfType(config, "x", Number, 4096)

  ///@type {Number}
	y = Struct.getIfType(config, "y", Number, 5356)

  ///@type {Number}
	z = Struct.getIfType(config, "z", Number, 5000)

  ///@type {Number}
	angle = Struct.getIfType(config, "angle", Number, 270.0)

    ///@type {Number}
	pitch = Struct.getIfType(config, "pitch", Number, 70.0)

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
	gmCamera = null

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
    } else {
      this.viewMatrix = null
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
    } else {
      this.projectionMatrix = null
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
		if (this.enableMouseLook) {
      var width = layout.width()
      var height = layout.height()
      var _x = layout.x()
      var _y = layout.y()

			this.angle -= ceil(MouseUtil.getMouseX() - _x - width / 2.0) / 10.0
			this.pitch -= ceil(MouseUtil.getMouseY() - _y - height / 2.0) / 10.0
			this.pitch = clamp(this.pitch, -85, 85)
			window_mouse_set(_x + width / 2.0, _y + height / 2.0)
		}

		if (this.enableKeyboardLook) {
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
