///@package com.alkapivo.visu.component.grid.renderer.GridCamera

///@param {Struct} [config]
function GridCamera(config = {}) constructor {
    
	///@type {Number}
	x = Assert.isType(Struct.getDefault(config, "x", 4096), Number)

  ///@type {Number}
	y = Assert.isType(Struct.getDefault(config, "y", 5356), Number)

  ///@type {Number}
	z = Assert.isType(Struct.getDefault(config, "z", 0), Number)

  ///@type {Number}
	zoom = Assert.isType(Struct.getDefault(config, "zoom", 5000), Number)

  ///@type {Number}
	angle = Assert.isType(Struct.getDefault(config, "angle", 270), Number)

    ///@type {Number}
	pitch = Assert.isType(Struct.getDefault(config, "pitch", -70), Number)

  ///@type {?Matrix}
  viewMatrix = null

	///@type {?Matrix}
	projectionMatrix = null

	///@type {Boolean}
	enableMouseLook = Struct.getDefault(config, "enableMouseLook", false)

	///@type {Boolean}
	enableKeyboardLook = Struct.getDefault(config, "enableKeyboardLook", false)

	///@type {Number}
	moveSpeed = Assert.isType(Struct.getDefault(config, "moveSpeed", 16), Number)

	///@type {GMCamera}
	gmCamera = camera_create()

	executor = new TaskExecutor(this)

	///@param {UILayout} layout
	///@return {Camera}
	update = function(layout) {
		this.executor.update()
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
}
