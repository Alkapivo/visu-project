///@package io.alkapivo.visu.service.grid

///@interface
///@param {Struct} [json]
function GridItemGameMode(json = {}) constructor {

  ///@type {Array<GridItemFeature>}
  features = new Array(GridItemFeature)

  ///@private
  ///@type {?Callable}
  _update = Struct.contains(json, "update")
    ? method(this, Assert.isType(json.update, Callable))
    : null

  ///@param {GridItem} item
  ///@param {VisuController} controller
  ///@return {GridItemGameMode}
  static updateFeatures = function(item, controller) {
    var features = item.gameMode.features
    var size = features.size()
    for (var index = 0; index < size; index++) {
      var feature = features.get(index)
      if (feature.updateTimer() && feature.checkConditions(item, controller)) {
        feature.update(item, controller)
      }
    }
    return this
  }

  ///@param {GridItem} item
  ///@param {VisuController} controller
  ///@return {GridItemGameMode}
  static update = function(item, controller) {
    if (Optional.is(this._update)) {
      this._update(item, controller)
    }
    this.updateFeatures(item, controller)
    return this
  }

  ///@param {GridItem} item
  ///@param {VisuController} controller
  ///@return {GridItemGameMode}
  onStart = Core.isType(Struct.get(json, "onStart"), Callable)
    ? method(this, json.onStart)
    : function(item, controller) { return this }

  if (Struct.contains(json, "features")) {
    GMArray.forEach(json.features, function(json, index, features) {
      var featureName = Struct.get(json, "feature")
      var feature = Callable.get(featureName)
      if (!Optional.is(feature)) {
        Logger.warn("GridItem", $"Found unsupported feature '{featureName}'")
        return
      }

      features.add(feature(json))
    }, this.features)
  }

  Struct.appendUnique(this, json, true)
}


///@param {Struct} json
///@return {GridItemGameMode}
function GridItemRacingGameMode(json) {
  new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: GameMode.RACING,
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function GridItemBulletHellGameMode(json) {
  new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: GameMode.BULLETHELL,
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function GridItemPlatformerGameMode(json) {
  new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: GameMode.PLATFORMER,
  }))
}