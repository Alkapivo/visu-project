///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json 
///@return {GridItemFeature}
function BooleanFeature(json) {
  var data = Assert.isType(Struct.get(json, "data"), Struct)
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: BooleanFeature,

    ///@type {Number}
    value: Assert.isType(Struct.getDefault(data, "value", false), Boolean),

    ///@type {String}
    field: Assert.isType(data.field, String),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      Struct.set(item, this.field, this.value)
    },
  }))
}
