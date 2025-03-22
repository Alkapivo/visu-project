///@package io.alkapivo.visu.service.shroom

///@param {VisuController} _controller
///@param {Struct} [config]
function ShroomService(_controller, config = {}): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Array<Shroom>} 
  shrooms = new Array(Shroom).enableGC()

  ///@type {GridItemChunkService}
  chunkService = new GridItemChunkService(GRID_ITEM_CHUNK_SERVICE_SIZE)

  ///@type {Map<String, ShroomTemplate>}
  templates = new Map(String, ShroomTemplate)

  ///@type {?Struct}
  spawner = null

  ///@type {?Struct}
  spawnerEvent = null

  ///@type {?Struct}
  particleArea = null

  ///@type {?Struct}
  particleAreaEvent = null

  ///@type {?Struct}
  subtitlesArea = null

  ///@type {?Struct}
  subtitlesAreaEvent = null

  ///@type {?Struct}
  playerBorder = null

  ///@type {?Struct}
  playerBorderEvent = null

  ///@type {?GameMode}
  gameMode = null

  ///@param {?Struct} [json]
  ///@return {Struct}
  factorySpawner = function(json = null) {
    return Struct.appendUnique(
      json, 
      {
        sprite: SpriteUtil.parse({ name: "texture_baron" }),
        x: 0.5,
        y: 0,
        timeout: 5.0,
      }
    )
  }

  ///@param {String} name
  ///@return {?ShroomTemplate}
  getTemplate = function(name) {
    var template = this.templates.get(name)
    return template == null
      ? Visu.assets().shroomTemplates.get(name)
      : template
  }

  ///@param {Boolean}
  optimalizationSortEntitiesByTxGroup = false

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-shroom": function(event) {
      var view = this.controller.gridService.view
      var locked = this.controller.gridService.targetLocked
      var template = new ShroomTemplate(event.data.template, this
        .getTemplate(event.data.template)
        .serialize())
      
      /*
      var spawnX = Assert.isType(Struct
        .getDefault(event.data, "spawnX", choose(1, -1) * random(3) * (random(100) / 100)), Number)
      var spawnY = Assert.isType(Struct
        .getDefault(event.data, "spawnY", -1 * random(2) * (random(100) / 100)), Number)
      var angle = Assert.isType(Struct
        .getDefault(event.data, "angle", 270), Number
      var spd = Assert.isType(Struct
        .getDefault(event.data, "speed", 5), Number)
      var viewX = Struct.getDefault(event.data, "snapH", true)
        ? floor(view.x / (view.width / 2.0)) * (view.width / 2.0)
        : view.x
      var viewY = Struct.getDefault(event.data, "snapV", true)
        ? floor(view.y / (view.height / 2.0)) * (view.height / 2.0)
        : view.y
      */

      var spawnX = event.data.spawnX
      var spawnY = event.data.spawnY
      var angle = event.data.angle
      var spd = event.data.speed
      var viewX = event.data.snapH ? locked.snapH : view.x
      var viewY = event.data.snapV ? locked.snapV : view.y

      Struct.set(template, "x", viewX + spawnX)
      Struct.set(template, "y", viewY + spawnY)
      Struct.set(template, "speed", spd / 1000.0)
      Struct.set(template, "angle", angle)
      Struct.set(template, "uid", this.controller.gridService.generateUID())
      
      var shroom = new Shroom(template)
      shroom.updateGameMode(this.controller.gameMode)

      this.shrooms.add(shroom)
      this.chunkService.add(shroom)

      if (this.optimalizationSortEntitiesByTxGroup) {
        this.controller.gridService.textureGroups.sortItems(this.shrooms)
      }
    },
    "clear-shrooms": function(event) {
      this.shrooms.clear()
      this.chunkService.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear()
      this.dispatcher.container.clear()
    },
  }))

  static spawnShroom = function(name, spawnX, spawnY, angle, spd, snapH, snapV) {
    var view = this.controller.gridService.view
    var locked = this.controller.gridService.targetLocked
    var viewX = snapH ? locked.snapH : view.x
    var viewY = snapV ? locked.snapV : view.y
    var template = this.getTemplate(name).serializeSpawn(viewX + spawnX, viewY + spawnY, spd / 1000.0, angle, this.controller.gridService.generateUID())
    
    var shroom = new Shroom(template)
    shroom.updateGameMode(this.controller.gameMode)

    this.shrooms.add(shroom)
    this.chunkService.add(shroom)

    if (this.optimalizationSortEntitiesByTxGroup) {
      this.controller.gridService.textureGroups.sortItems(this.shrooms)
    }
  }

  ///@param {Event} event
  ///@return {?Promise}
  static send = function(event) {
    gml_pragma("forceinline")
    return this.dispatcher.send(event)
  }

  static updateGameMode = function(shroom, index, gameMode) {
    gml_pragma("forceinline")
    shroom.updateGameMode(gameMode)
  }

  static updateShroom = function(shroom, index, context) {
    gml_pragma("forceinline")
    shroom.update(context.controller)
    if (shroom.signals.kill) {
      context.shrooms.addToGC(index)
      context.chunkService.remove(shroom)
    }
  }

  ///@return {ShroomService}
  update = function() {
    this.optimalizationSortEntitiesByTxGroup = Visu.settings.getValue("visu.optimalization.sort-entities-by-txgroup")
    if (controller.gameMode != this.gameMode) {
      this.gameMode = this.controller.gameMode
      this.shrooms.forEach(this.updateGameMode, this.gameMode)
    }

    this.dispatcher.update()
    this.shrooms.forEach(this.updateShroom, this).runGC()
    return this
  }

  this.send(new Event("reset-templates"))
}
