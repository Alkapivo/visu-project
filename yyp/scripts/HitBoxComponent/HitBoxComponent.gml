///@package io.alkapivo.visu.

///@param {Struct} json
function HitBoxComponent(json) constructor {

  ///@private
  ///@param {Struct} json
  ///@throws {Exception}
  ///@return {Number|Rectangle}
  static parseData = function(json) {
    switch (json.shape) {
      case "circle": return Assert.isType(json.data, Number)
      case "rectangle": return new Rectangle(json.data)
      default: throw new Exception("Found unsupported shape")
    }
  }

  ///@type {String}
  shape = Assert.isType(json.shape, String)

  ///@type {Number|Rectangle}
  data = this.parseData(json)
}
