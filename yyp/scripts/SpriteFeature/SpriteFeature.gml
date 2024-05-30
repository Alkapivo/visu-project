///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function SpriteFeature(json) {
  var data = Assert.isType(Struct.get(json, "data"), Struct)
  var sprite = Core.isType(Struct.get(data, "sprite"), Struct) 
    ? Assert.isType(SpriteUtil.parse(data.sprite), Sprite) 
    : null
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: SpriteFeature,

    ///@type {?Sprite}
    sprite: sprite,

    ///@type {?Rectangle}
    mask: Core.isType(Struct.get(data, "mask"), Struct)
      ? new Rectangle(data.mask)
      : null,

    ///@type {?Struct}
    scaleX: Core.isType(Struct.get(data, "scaleX"), Struct)
      ? {
        add: Core.isType(Struct.get(data.scaleX, "add"), Struct)
          ? new NumberTransformer({
            value: 0.0,
            factor: Struct.getDefault(data.scaleX.add, "factor", 1.0),
            target: Struct.getDefault(data.scaleX.add, "target", 1.0),
            increase: Struct.getDefault(data.scaleX.add, "increase", 0.0),
          })
          : null,
        transform: Core.isType(Struct.get(data.scaleX, "transform"), Struct)
          ? new NumberTransformer(data.scaleX.transform)
          : null,
        initialized: false,
      }
      : null,

    ///@type {?Struct}
    scaleY: Core.isType(Struct.get(data, "scaleY"), Struct)
      ? {
        add: Core.isType(Struct.get(data.scaleY, "add"), Struct)
          ? new NumberTransformer({
            value: 0.0,
            factor: Struct.getDefault(data.scaleY.add, "factor", 1.0),
            target: Struct.getDefault(data.scaleY.add, "target", 1.0),
            increase: Struct.getDefault(data.scaleY.add, "increase", 0.0),
          })
          : null,
        transform: Core.isType(Struct.get(data.scaleY, "transform"), Struct)
          ? new NumberTransformer(data.scaleY.transform)
          : null,
        initialized: false,
      }
      : null,

      
    ///@type {?Struct}
    angle: Core.isType(Struct.get(data, "angle"), Struct)
      ? {
        add: Core.isType(Struct.get(data.angle, "add"), Struct)
          ? new NumberTransformer({
            value: 0.0,
            factor: Struct.getDefault(data.angle.add, "factor", 1.0),
            target: Struct.getDefault(data.angle.add, "target", 1.0),
            increase: Struct.getDefault(data.angle.add, "increase", 0.0),
          })
          : null,
        transform: Core.isType(Struct.get(data.angle, "transform"), Struct)
          ? new NumberTransformer(data.angle.transform)
          : null,
        initialized: false,
      }
      : null,

    ///@type {?Struct}
    alpha: Core.isType(Struct.get(data, "alpha"), Struct)
      ? {
        add: Core.isType(Struct.get(data.alpha, "add"), Struct)
          ? new NumberTransformer({
            value: 0.0,
            factor: Struct.getDefault(data.alpha.add, "factor", 1.0),
            target: Struct.getDefault(data.alpha.add, "target", 1.0),
            increase: Struct.getDefault(data.alpha.add, "increase", 0.0),
          })
          : null,
        transform: Core.isType(Struct.get(data.alpha, "transform"), Struct)
          ? new NumberTransformer(data.alpha.transform)
          : null,
        initialized: false,
      }
      : null,

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      if (this.sprite != null) {
        item.setSprite(this.sprite)
      }

      if (this.mask != null) {
        item.setMask(this.mask)
      }

      if (this.scaleX != null) {
        if (this.scaleX.transform != null) {
          if (!this.scaleX.initialized) {
            this.scaleX.transform.value = item.sprite.scaleX
            this.scaleX.transform.startValue = item.sprite.scaleX
            this.scaleX.initialized = true
          }
          item.sprite.setScaleX(this.scaleX.transform.update().value)
        }
      
        if (this.scaleX.add != null) {
          item.sprite.setScaleX(item.sprite.scaleX + this.scaleX.add.update().value)
        }
      }

      if (this.scaleY != null) {
        if (this.scaleY.transform != null) {
          if (!this.scaleY.initialized) {
            this.scaleY.transform.value = item.sprite.scaleY
            this.scaleY.transform.startValue = item.sprite.scaleY 
            this.scaleY.initialized = true
          }
          item.sprite.setScaleY(this.scaleY.transform.update().value)
        }
      
        if (this.scaleY.add != null) {
          item.sprite.setScaleY(item.sprite.scaleY + this.scaleY.add.update().value)
        }
      }

      if (this.angle != null) {
        if (this.angle.transform != null) {
          if (!this.angle.initialized) {
            this.angle.transform.value = item.sprite.angle
            this.angle.transform.startValue = item.sprite.angle
            this.angle.initialized = true
          }
          item.sprite.setAngle(this.angle.transform.update().value)
        }
  
        if (this.angle.add != null) {
          item.sprite.setAngle(item.sprite.angle + this.angle.add.update().value)
        }
      }

      if (this.alpha != null) {
        if (this.alpha.transform != null) {
          if (!this.alpha.initialized) {
            this.alpha.transform.value = item.sprite.alpha
            this.alpha.transform.startValue = item.sprite.alpha
            this.alpha.initialized = true
          }
          item.sprite.setAlpha(this.alpha.transform.update().value)
        }
      
        if (this.alpha.add != null) {
          item.sprite.setAlpha(item.sprite.alpha + this.alpha.add.update().value)
        }
      }
    },
  }))
}