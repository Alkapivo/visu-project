///@package io.alkapivo.visu.service.grid

///@interface
///@param {Struct} json
function GridItemFeature(json) constructor {

  ///@type {Callable}
  type = Assert.isType(json.type, Callable)

  ///@type {?Timer}
  timer = Core.isType(Struct.get(json, "timer"), Number) 
    ? new Timer(json.timer, { loop: Infinity }) 
    : null

  ///@type {?Array<GridItemCondition>}
  conditions = Struct.contains(json, "conditions")
    ? new Array(GridItemCondition, GMArray.map(json.conditions, function(condition) {
      return new GridItemCondition(condition)
    }))
    : null

  ///@return {Boolean}
  static checkConditions = function(gridItem, controller) {
    if (this.conditions == null) {
      return true
    }

    var size = this.conditions.size()
    for (var index = 0; index < size; index++) { 
      if (!this.conditions.get(index).check(gridItem, controller)) {
        return false
      }
    }
    return true
  }

  ///@return {Boolean}
  static updateTimer = function() {
    return this.timer == null ? true : this.timer.update().finished
  }

  ///@param {GridItem} gridItem
  ///@param {VisuController} controller
  update = method(this, Core.isType(Struct.get(json, "update"), Callable) 
    ? json.update
    : function() {})

  Struct.appendUnique(this, json)
}
