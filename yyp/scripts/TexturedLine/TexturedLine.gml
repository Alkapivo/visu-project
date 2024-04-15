///@package io.alkapivo.core.renderer

///@param {?Struct} [json]
function TexturedLine(json = null) constructor {

  ///@type {Number}
  thickness = Assert.isType(Struct.getDefault(json, "thickness", 1.0), Number)

  ///@type {Number}
  alpha = Assert.isType(Struct.getDefault(json, "alpha", 1.0), Number)

  ///@type {GMColor}
  blend = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(json, "blend", "#ffffff")).toGMColor(), GMColor)

  ///@type {Sprite}
  line = Assert.isType(SpriteUtil.parse(Struct
    .getDefault(json, "line", { name: "texture_grid_line_default" })), Sprite)

  ///@type {Sprite}
  cornerFrom = Assert.isType(SpriteUtil.parse(Struct
    .getDefault(json, "cornerFrom", { name: "texture_grid_line_corner_default" })), Sprite)

  ///@type {Sprite}
  cornerTo = Assert.isType(SpriteUtil.parse(Struct
    .getDefault(json, "cornerTo", { name: "texture_grid_line_corner_default" })), Sprite)

  ///@param {Number} fromX
  ///@param {Number} fromY
  ///@param {Number} toX
  ///@param {Number} toY
  ///@return {TexturedLine}
  render = function(fromX, fromY, toX, toY) {
    var angle = Math.fetchAngle(fromX, fromY, toX, toY)
    var scale = Math.fetchLength(fromX, fromY, toX, toY) / this.line.texture.width
    this.cornerFrom
      .setScaleX(this.thickness).setScaleY(this.thickness)
      .setAlpha(this.alpha).setAngle(angle).setBlend(this.blend)
      .render(fromX, fromY)
    this.cornerTo
      .setScaleX(this.thickness).setScaleY(this.thickness)
      .setAlpha(this.alpha).setAngle(angle + 180.0).setBlend(this.blend)
      .render(toX, toY)
    this.line
      .setScaleX(scale).setScaleY(this.thickness)
      .setAlpha(this.alpha).setAngle(angle).setBlend(this.blend)
      .render(fromX, fromY)
    return this
  }
}
