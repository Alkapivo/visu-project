///@package com.alkapivo.visu.service.grid.GridView

///@param {Struct} [config]
function GridView(config = {}) constructor {

  ///@type {Number}
  x = Assert.isType(Struct.getDefault(config, "x", 0.0), Number)

  ///@type {Number}
  y = Assert.isType(Struct.getDefault(config, "y", 0.0), Number)

  ///@type {Number}
  width = Assert.isType(Struct.getDefault(config, "width", 1), Number)

  ///@type {Number}
  height = Assert.isType(Struct.getDefault(config, "height", 1), Number)

  ///@type {Number}
  worldWidth = Assert.isType(Struct.getDefault(config, "worldWidth", 2.0) , Number)

  ///@type {Number}
  worldHeight = Assert.isType(Struct.getDefault(config, "worldHeight", 2.0) , Number)

  ///@type {Struct}
  follow = {
    target: null,
    xMargin: Assert.isType(Struct.getDefault(config, "follow.xMargin", 0.35), Number),
    yMargin: Assert.isType(Struct.getDefault(config, "follow.yMargin", 0.40), Number),
    smooth: Assert.isType(Struct.getDefault(config, "follow.smooth", 32), Number),
  }

  ///@type {Number}
  derivativeX = 0.0

  ///@type {Number}
  derivativeY = 0.0

  ///@param {GridItem} target
  ///@return {GridView}
  static setFollowTarget = function(target) {
    this.follow.target = target
    return this
  }
  
  ///@return {GridView}
  static update = function() {
    if (Core.isType(this.follow.target, Struct)) {
      var targetX = this.follow.target.x
      var _derivativeX = 0.0
      if (targetX >= this.x + this.width - this.follow.xMargin) {
        _derivativeX = ((targetX - 1.0 / 2.0) - this.x) / this.follow.smooth
        this.x += _derivativeX
      }
      if (targetX <= this.x + this.follow.xMargin) {
        _derivativeX = ((targetX - 1.0 / 2.0) - this.x) / this.follow.smooth
        this.x += _derivativeX
      }
      if (targetX >= this.worldWidth - this.width || targetX <= 0) {
        _derivativeX = 0.0
      }
      this.derivativeX = _derivativeX
      this.follow.target.x = clamp(targetX, 0, this.worldWidth)
      
      var _derivativeY = 0.0
      var targetY = this.follow.target.y
      if (targetY >= this.y + this.height - this.follow.yMargin) {
        _derivativeY = ((targetY - 1.0 / 2.0) - this.y) / this.follow.smooth
        this.y += _derivativeY
      }
      if (targetY <= this.y + this.follow.yMargin) {
        _derivativeY = ((targetY - 1.0 / 2.0) - this.y) / this.follow.smooth
        this.y += _derivativeY
      }
      if (targetY >= this.worldHeight - this.height || targetY <= 0) {
        _derivativeY = 0.0
      }
      this.derivativeY = _derivativeY
      this.follow.target.y = clamp(targetY, 0, this.worldHeight)
    }

    this.x = clamp(this.x, 0.0, this.worldWidth - this.width) //this.x = clamp(this.x, -1 * this.width, this.worldWidth) 
    this.y = clamp(this.y, 0.0, this.worldHeight - this.height)
    return this
  }
}
