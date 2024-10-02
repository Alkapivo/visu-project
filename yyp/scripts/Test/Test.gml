///@package io.alkapivo.core.test

///@param {Struct} json
function Test(json) constructor {

  ///@type {String}
  handler = Assert.isType(json.handler, String)

  ///@type {String}
  description = Core.isType(Struct.get(json, "description"), String)
    ? json.description
    : ""
  
  ///@type {any}
  data = Struct.get(json, "data")

  ///@return {Struct}
  serialize = function() {
    var json = {
      handler: this.handler,
      description: this.description
    }

    if (Optional.is(this.data)) {
      Struct.set(json, "data", this.data)
    }
    
    return json
  }
}