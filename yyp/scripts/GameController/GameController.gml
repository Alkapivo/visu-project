///@package io.alkapivo.neon-baron

function NeonBaronWorld() constructor {
  
  ///@type {Map<String, LDTKWorld>}
  worlds = new Map(String, LDTKWorld)

  ///@type {?Struct}
  current = {
    world: null,
    level: null,
    layers: new Array(String)
  }

  ///@type {?NeonBaronState}
  state = null
}

#macro BeanGameController "GameController"
function GameController() constructor {

  ///@type {?NeonBaronWorld}
  world = new NeonBaronWorld()

  ///@type {FSM}
  fsm = new FSM(this, {
    initialState: { name: "init" },
    states: {
      "init": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            SceneContext.setIntent(new NeonBaronState({
              "baron": {
                "world": "world/test-world.ldtk",
                "level": "level_0",
                "x": 100,
                "y": 100
              }
            }))


            var state = SceneContext.getIntent()
            if (Optional.is(state)) {
              SceneContext.setIntent(null)
            }
            
            if (Core.isType(state, NeonBaronState)) {
              var promise = Beans.get(BeanGameController).send(new Event("init-world", state))
              fsmState.state.set("promise", promise)
            }
          },
        },
        update: function(fsm) {
          var promise = fsm.currentState.state.get("promise")
          if (Core.isType(promise, Promise) && promise.isReady() && promise.status == PromiseStatus.FULLFILLED) {
            fsm.dispatcher.send(new Event("transition", { name: "topdown" }))
          }
        },
        transitions: {
          "topdown": null,
          "quit": null,
        }
      },
      "load-world": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "load-level": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "save": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "topdown": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "dialog": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "load-visu": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "visu": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "pause-topdown": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "pause-visu": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
      "quit": {
        actions: {
          onStart: function(fsm, fsmState, data) {

          },
        },
        update: function(fsm) {

        },
        transitions: {
          "quit": null
        }
      },
    }
  })

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "init-world": function(event) {
      var task = new Task("init-world")
        .setPromise(event.promise)
        .setState({
          neonBaronState: event.data,
          promise: null,
          stage: "init",
          stages: {
            "init": function(task) {
              var gameController = Beans.get(BeanGameController)
              if (Core.isType(gameController.world, NeonBaronWorld)) {
                gameController.world.current.layers.forEach(function(layerName) {
                  layer_destroy(layerName)
                })
              }
              gameController.world = new NeonBaronWorld()
              gameController.world.state = task.state.neonBaronState
              
              var topDownController = Beans.get(BeanTopDownController)
              topDownController.baronService.baron = null
              topDownController.npcService.npcs.clear()
      
              task.state.promise = Beans.get(BeanFileService).send(
                new Event("fetch-file")
                  .setData({ path: $"{working_directory}{gameController.world.state.baron.world}"})
                  .setPromise(new Promise()
                    .whenSuccess(function(result) {
                      return new LDTKWorld(JSON.parse(result.data))
                    }))
              )
              task.state.stage = "promise"
            },
            "promise": function(task) {
              if (!task.state.promise.isReady()) {
                return
              }
      
              var gameController = Beans.get(BeanGameController)
              gameController.world.worlds.set(
                gameController.world.state.baron.world, 
                Assert.isType(task.state.promise.response, LDTKWorld)
              )
              task.state.stage = "generate"
            },
            "generate": function(task) {
              var gameController = Beans.get(BeanGameController)
              var world = gameController.world
              var worldState = Struct.get(gameController.world.state.worlds, gameController.world.state.baron.world)
              var levelState = Struct.get(Struct.get(worldState, "layers"), gameController.world.state.baron.level)
              world.current.layers = world.worlds
                .get(gameController.world.state.baron.world)
                .setEntities(new Map(String, Callable, {
                  ///@param {GMLayer} layerId
                  ///@param {LDTKEntity} entity
                  "entity_npc": function(layerId, entity) {
                    Beans.get(BeanTopDownController).npcService.npcs
                      .set(entity.uid, new NPC(entity))
                  },
                }))
                .generate(gameController.world.state.baron.level, -1000, levelState)
              world.current.world = gameController.world.state.baron.world
              world.current.level = gameController.world.state.baron.level
              
              var level = world.worlds
                .get(world.current.world).levels
                .find(function(level, index, name) {
                  return level.name == name
                }, world.current.level)
              room_width = level.width
              room_height = level.height

              var baron = new Baron({
                x: gameController.world.state.baron.x,
                y: gameController.world.state.baron.y,
                maxSpeed: 3,
              })
              baron.gmObject = GMObjectUtil.factoryGMObject(TDMCCollider, layer_get_id("instance_main"), 0, 0)
              GMObjectUtil.set(baron.gmObject, "baron", baron)
              GMObjectUtil.set(baron.gmObject, "move", null)
              with (baron.gmObject) {
                move = use_tdmc()
              }
              Beans.get(BeanTopDownController).baronService.baron = baron
              task.fullfill("success")
            }
          }
        })
        .whenUpdate(function(executor) {
          var handler = Struct.get(this.state.stages, this.state.stage)
          handler(this, executor)
        })

      this.executor.add(task)
      event.promise = null
    }
  }), {
    enableLogger: true,
    catchException: false,
  })

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, {
    enableLogger: true,
    catchException: false,
  })

  ///@private
  ///@type {Array<Struct>}
  services = new Array(Struct, GMArray.map([
    "fsm",
    "dispatcher",
    "executor",
  ], function(name, index, controller) {
    Logger.debug(BeanGameController, $"Load service '{name}'")
    return {
      name: name,
      struct: Assert.isType(Struct.get(controller, name), Struct),
    }
  }, this))

  ///@private
  ///@param {Struct} service
  ///@param {Number} iterator
  ///@param {VisuController} controller
  updateService = function(service, iterator, controller) {
    try {
      service.struct.update()
    } catch (exception) {
      var message = $"'update-service-{service.name}' fatal error: {exception.message}"
      Logger.error(BeanGameController, message)
      Core.printStackTrace()
      fsm.dispatcher.send(new Event("transition", { name: "quit" }))
    }
  }

  ///@param {Event}
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {GameController}
  update = function() {
    this.services.forEach(this.updateService, this)

    return this
  }

  ///@return {GameController}
  render = function() {
    
    return this
  }

  ///@return {GameController}
  renderGUI = function() {
    draw_surface(application_surface, 0, 0)
    surface_set_target(application_surface)
    draw_clear(c_black)
    surface_reset_target()
    return this
  }
}