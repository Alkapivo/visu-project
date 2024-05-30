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

  ///@override
  ///@type {Boolean}
  overrideValue = Struct.get(json, "overrideValue") == true

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
  ///@type {Number}
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

    this.factor = this.factor + DeltaTime.apply(this.increase)
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
    
    this.x.value = this.value.x
    this.y.value = this.value.y
    this.value.x = this.x.update().get()
    this.value.y = this.y.update().get()

    if (this.value.x == this.x.target 
      && this.value.y == this.y.target) {
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

    this.x.value = this.value.x
    this.y.value = this.value.y
    this.z.value = this.value.z
    this.value.x = this.x.update().get()
    this.value.y = this.y.update().get()
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

    this.x.value = this.value.x
    this.y.value = this.value.y
    this.z.value = this.value.z
    this.a.value = this.value.a
    this.value.x = this.x.update().get()
    this.value.y = this.y.update().get()
    this.value.z = this.z.update().get()
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

  ///@override
  ///@type {Vector2}
  value = new Vector2(GuiWidth(), GuiHeight())

  ///@override
  ///@return {Vector2}
  update = function() {
    if (this.overrideValue) {
      return this
    }
    
    this.value.x = GuiWidth()
    this.value.y = GuiHeight() 
    return this
  }

  ///@override
  ///@type {Boolean}
  overrideValue = Struct.getDefault(json, "overrideValue", true)
}
