///@package io.alkapivo.core.util

///@interface
///@param {Struct} [json]
function Transformer(json = null) constructor {

  ///@type {any}
  value = Struct.get(json, "value")

  ///@type {any}
  startValue = this.value

  ///@type {Boolean}
  finished = false

  ///@return {any}
  get = function() {
    return this.value
  }

  ///@param {any} value
  ///@return {Transformer}
  set = function(value) {
    this.value = value 
    return this
  }

  ///@return {Transformer}
  update = function() { return this }

  ///@return {Transformer}
  reset = function() {
    this.finished = false 
    this.value = this.startValue
    return this
  }
}


///@param {Struct} [json]
function ColorTransformer(json = { value: "#ffffff" }): Transformer(json) constructor {

  ///@override
  ///@type {Color}
  this.value = ColorUtil.fromHex(Struct.get(json, "value"))

  ///@override
  ///@type {Color}
  this.startValue = ColorUtil.fromHex(Struct.get(json, "value"))

  ///@type {Color}
  target = ColorUtil.fromHex(Struct.get(json, "target"))

  ///@type {Number}
  factor = Struct.getDefault(json, "factor", 1)

  ///@override
  ///@return {ColorTransformer}
  update = function() {
    if (this.finished) {
      return this
    }

    this.value.red = Math.transformNumber(this.value.red, this.target.red, this.factor)
    this.value.green = Math.transformNumber(this.value.green, this.target.green, this.factor)
    this.value.blue = Math.transformNumber(this.value.blue, this.target.blue, this.factor)
    this.value.alpha = Math.transformNumber(this.value.alpha, this.target.alpha, this.factor)
    if (ColorUtil.areEqual(this.value, this.target)) {
      this.finished = true
    }
    return this
  }
}


///@param {Struct} [json]
function NumberTransformer(json = null): Transformer(json) constructor {

  ///@override
  ///@type {Number}
  value = Assert.isType(Struct.getDefault(json, "value", 0), Number)

  ///@override
  ///@type {Color}
  startValue = this.value

  ///@type {Number}
  target = Assert.isType(Struct.getDefault(json, "target", this.value), Number)

  ///@type {Number}
  factor = Assert.isType(Struct.getDefault(json, "factor", 1), Number)

  ///@type {Number}
  increase = Assert.isType(Struct.getDefault(json, "increase", 0), Number)
  
  ///@override
  ///@return {NumberTransformer}
  update = function() {
    if (this.finished) {
      return this
    }

    this.factor = (this.value < this.target ? 1 : -1) 
      * this.factor + DeltaTime.apply(this.increase)
    this.value = Math.transformNumber(this.value, this.target, this.factor)
    if (this.value == this.target) {
      this.finished = true
    }
    return this
  }
}


///@param {Struct} [json]
function Vector2Transformer(json = {}): Transformer(json) constructor {

  ///@type {NumberTransformer}
  x = new NumberTransformer(Struct.get(json, "x"))

  ///@type {NumberTransformer}
  y = new NumberTransformer(Struct.get(json, "y"))

  ///@override
  ///@type {Vector2}
  value = new Vector2(this.x.value, this.y.value)

  ///@override
  ///@type {Vector2}
  startValue = new Vector2(this.x.value, this.y.value)

  ///@override
  ///@return {Vector2Transformer}
  update = function() {
    if (this.finished) {
      return this
    }

    this.x.factor = (this.value.x < this.x.target ? 1 : -1) 
      * this.x.factor + DeltaTime.apply(this.x.increase)
    this.value.x = this.x.update().get()

    this.y.factor = (this.value.y < this.y.target ? 1 : -1) 
      * this.y.factor + DeltaTime.apply(this.y.increase)
    this.value.y = this.y.update().get()

    if (this.value.x == this.x.target && this.value.y == this.y.target) {
      this.finished = true
    }
    return this
  }

  ///@override
  ///@return {Vector2Transformer}
  reset = function() {
    this.finished = false 
    this.x.reset()
    this.y.reset()
    return this
  }
}


///@param {Struct} [json]
function Vector3Transformer(json = {}): Transformer(json) constructor {

  ///@type {NumberTransformer}
  x = new NumberTransformer(Struct.get(json, "x"))

  ///@type {NumberTransformer}
  y = new NumberTransformer(Struct.get(json, "y"))

  ///@type {NumberTransformer}
  z = new NumberTransformer(Struct.get(json, "z"))

  ///@override
  ///@type {Vector3}
  value = new Vector3(this.x.value, this.y.value, this.z.value)

  ///@override
  ///@return {Vector3Transformer}
  update = function() {
    if (this.finished) {
      return this
    }

    this.x.factor = (this.value.x < this.x.target ? 1 : -1) 
      * this.x.factor + DeltaTime.apply(this.x.increase)
    this.value.x = this.x.update().get()

    this.y.factor = (this.value.y < this.y.target ? 1 : -1) 
      * this.y.factor + DeltaTime.apply(this.y.increase)
    this.value.y = this.y.update().get()

    this.z.factor = (this.value.z < this.z.target ? 1 : -1) 
      * this.z.factor + DeltaTime.apply(this.z.increase)
    this.value.z = this.z.update().get()

    if (this.value.x == this.x.target 
      && this.value.y == this.y.target
      && this.value.z == this.z.target) {

      this.finished = true
    }
    return this
  }

  ///@override
  ///@return {Vector3Transformer}
  reset = function() {
    this.finished = false 
    this.x.reset()
    this.y.reset()
    this.z.reset()
    return this
  }
}


///@param {Struct} [json]
function Vector4Transformer(json = {}): Transformer(json) constructor {

  ///@type {NumberTransformer}
  x = new NumberTransformer(Struct.get(json, "x"))

  ///@type {NumberTransformer}
  y = new NumberTransformer(Struct.get(json, "y"))

  ///@type {NumberTransformer}
  z = new NumberTransformer(Struct.get(json, "z"))

  ///@type {NumberTransformer}
  a = new NumberTransformer(Struct.get(json, "a"))

  ///@override
  ///@type {Vector4}
  value = new Vector4(this.x.value, this.y.value, this.z.value, this.a.value)

  ///@override
  ///@return {Vector4Transformer}
  update = function() {
    if (this.finished) {
      return this
    }

    this.x.factor = (this.value.x < this.x.target ? 1 : -1) 
      * this.x.factor + DeltaTime.apply(this.x.increase)
    this.value.x = this.x.update().get()

    this.y.factor = (this.value.y < this.y.target ? 1 : -1) 
      * this.y.factor + DeltaTime.apply(this.y.increase)
    this.value.y = this.y.update().get()

    this.z.factor = (this.value.z < this.z.target ? 1 : -1) 
      * this.z.factor + DeltaTime.apply(this.z.increase)
    this.value.z = this.z.update().get()

    this.a.factor = (this.value.a < this.a.target ? 1 : -1) 
      * this.a.factor + DeltaTime.apply(this.a.increase)
    this.value.a = this.a.update().get()

    if (this.value.x == this.x.target 
      && this.value.y == this.y.target
      && this.value.z == this.z.target
      && this.value.a == this.a.target) {

      this.finished = true
    }
    return this
  }

  ///@override
  ///@return {Vector4Transformer}
  reset = function() {
    this.finished = false 
    this.x.reset()
    this.y.reset()
    this.z.reset()
    this.a.reset()
    return this
  }
}


///@param {Struct} [json]
function ResolutionTransformer(json = {}): Transformer(json) constructor {

  ///@type {NumberTransformer}
  scale = new NumberTransformer(Struct.getDefault(json, "scale", { value: 1 }))

  ///@override
  ///@type {Vector2}
  value = new Vector2(GuiWidth() / this.scale.value, GuiHeight() / this.scale.value)

  ///@override
  ///@return {Vector2}
  update = function() {
    this.scale.factor = (this.scale.value < this.scale.target ? 1 : -1) 
      * this.scale.factor + DeltaTime.apply(this.scale.increase)
    this.scale.value = this.scale.update().get()

    this.value.x = GuiWidth() / this.scale.value
    this.value.y = GuiHeight() / this.scale.value
    return this
  }
}
