///@package io.alkapivo.neon-baron

function _NeonBaron() constructor {
  
  ///@param {String} [layerName]
  ///@param {Number} [layerDefaultDepth]
  ///@return {NeonBaron}
  static run = function(layerName = "instance_main", layerDefaultDepth = 100) {

    initGPU()
    initBeans()

    var layerId = layer_get_id(layerName)
    if (layerId == -1) {
      layerId = layer_create(Assert.isType(layerDefaultDepth, Number), layerName)
    }

    if (!Beans.exists(BeanDeltaTimeService)) {
      Beans.add(BeanDeltaTimeService, new Bean(DeltaTimeService,
        GMObjectUtil.factoryGMObject(
          GMServiceInstance, 
          layerId, 0, 0, 
          new DeltaTimeService()
        )
      ))
    }


    if (!Beans.exists(BeanDialogueService)) {
      Beans.add(BeanDialogueService, new Bean(DialogueService,
        GMObjectUtil.factoryGMObject(
          GMServiceInstance, 
          layerId, 0, 0, 
          new DialogueService()
        )
      ))
    }

    Beans.add(BeanGameController, new Bean(GameController,
      GMObjectUtil.factoryGMObject(
        GMControllerInstance, 
        layerId, 0, 0, 
        new GameController(layerName)
      )
    ))

    Beans.add(BeanTopDownController, new Bean(TopDownController,
      GMObjectUtil.factoryGMObject(
        GMControllerInstance, 
        layerId, 0, 0, 
        new TopDownController(layerName)
      )
    ))

    return this
  }
}
global.__NeonBaron = new _NeonBaron()
#macro NeonBaron global.__NeonBaron