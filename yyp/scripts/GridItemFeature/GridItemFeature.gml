///@package io.alkapivo.visu.service.grid

///@interface
///@param {Struct} json
function GridItemFeature(json = {}) constructor {

  ///@type {Callable}
  type = json.type

  ///@type {?Timer}
  timer = Core.isType(Struct.get(json, "timer"), Number) ? new Timer(json.timer, { loop: Infinity }) : null

  ///@type {?Array<GridItemCondition>}
  conditions = Struct.contains(json, "conditions")
    ? new Array(GridItemCondition, GMArray.map(json.conditions, function(condition) {
      return new GridItemCondition(condition)
    }))
    : null

  ///@return {Boolean}
  checkConditions = function(gridItem, controller) {
    if (!Optional.is(this.conditions)) {
      return true
    }

    var size = this.conditions.size()
    for (var index = 0; index < size; index++) {
      var condition = this.conditions.get(index)
      if (!condition.check(gridItem, controller)) {
        return false
      }
    }
    return true
  }

  ///@return {Boolean}
  updateTimer = function() {
    return this.timer == null ? true : this.timer.update().finished
  }

  ///@param {GridItem} gridItem
  ///@param {VisuController} controller
  update = method(this, Assert.isType(Struct
    .getDefault(json, "update", function() { }), Callable))

  Struct.appendUnique(this, json)
}
