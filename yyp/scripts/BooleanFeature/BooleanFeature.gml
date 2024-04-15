///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} [json] BooleanFeature
///@return {GridItemFeature}
function BooleanFeature(json = {}) {
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: BooleanFeature,

    ///@type {Number}
    value: Assert.isType(Struct.getDefault(json, "value", false), Boolean),

    ///@type {String}
    field: Assert.isType(json.field, String),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      Struct.set(item, this.field, this.value)
    },
  }))
}
