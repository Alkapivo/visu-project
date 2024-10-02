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


    if (!Beans.exists(BeanDialogueDesignerService)) {
      Beans.add(BeanDialogueDesignerService , new Bean(DialogueDesignerService,
        GMObjectUtil.factoryGMObject(
          GMServiceInstance, 
          layerId, 0, 0, 
          new DialogueDesignerService({
            handlers: new Map(String, Callable, {
              "QUIT": function(data) {
                Beans.get(BeanDialogueDesignerService).close()
              },
              "LOAD_VISU_TRACK": function(data) {
                Beans.get(BeanVisuController).send(new Event("load", {
                  manifest: FileUtil.get(data.path),
                  autoplay: true,
                }))
              },
              "GAME_END": function(data) {
                game_end()
              },
            }),
          })
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