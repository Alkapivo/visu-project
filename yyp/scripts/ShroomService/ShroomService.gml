///@package io.alkapivo.visu.service.shroom


///@param {Number} _size
function ShroomGrid(_size) constructor {

  ///@type {Number}
  size = Assert.isType(_size, Number)

  ///@type {Map<String, Array>}
  map = new Map(String, Array)

  ///@param {Number} x
  ///@param {Number} y
  ///@return {String}
  toKey = function(x, y) {
    var key = "x" + string(int64(x)) + "y" + string(int64(y))
    return key 
    //return $"x{int64(x)}y{int64(y)}"
  }

  ///@param {String}
  ///@throws {AssertException}
  ///@return {Array}
  get = function(key) {
    Assert.isType(key, String, "Key must be type of string")
    if (!this.map.contains(key)) {
      this.map.set(key, new Array(Shroom))
    }

    return this.map.get(key)
  }

  ///@param {Shroom} shroom
  ///@throws {Exception}
  ///@return {ShroomGrid}
  add = function(shroom) {
    shroom.shroomGridKey = this.toKey(
      floor(shroom.x / this.size),
      floor(shroom.y / this.size)
    )
    
    var cell = this.get(shroom.shroomGridKey)
    var index = cell.findIndex(function(shroom, index, target) {
      return shroom == target
    }, shroom)

    if (Optional.is(index)) {
      var message = $"Shroom was already added to cell '{shroom.shroomGridKey}'"
      Logger.error("ShroomGrid", message)
      Core.printStackTrace()
      throw new Exception(message)
    }

    cell.add(shroom)
    //Logger.debug("ShroomGrid", $"Added shroom to cell '{shroom.shroomGridKey}'")
    return this
  }

  ///@param {Shroom} shroom
  ///@throws {Exception}
  ///@return {ShroomGrid}
  update = function(shroom) {
    var newKey = this.toKey(
      floor(shroom.x / this.size),
      floor(shroom.y / this.size)
    )
    
    if (newKey == shroom.shroomGridKey) {
      return this
    }

    this.remove(shroom).add(shroom)
    return this

    /*
    var oldKey = shroom.shroomGridKey
    var from = this.get(oldKey)
    var index = from.findIndex(function(shroom, index, target) {
      return shroom == target
    }, shroom)
    if (Optional.is(index)) {
      from.remove(index)
      shroom.shroomGridKey = newKey
      Logger.debug("ShroomGrid", $"Remove shroom at index {index} from cell '{oldKey}'")
    } else {
      var message = $"Shroom was not found in cell '{oldKey}'"
      Logger.error("ShroomGrid", message)
      Core.printStackTrace()
      throw new Exception(message)
    }

    var to = this.get(newKey)
    index = to.findIndex(function(shroom, index, target) {
      return shroom == target
    }, shroom)
    if (!Optional.is(index)) {
      to.add(shroom)
      Logger.debug("ShroomGrid", $"Shroom at index {index} moved from '{oldKey}' to '{newKey}'")
    } else {
      var message = $"Shroom from cell '{oldKey}' was already found in cell '{newKey}'"
      Logger.error("ShroomGrid", message)
      Core.printStackTrace()
      throw new Exception(message)
    }

    return this
    */
  }

  ///@param {Shroom} shroom
  ///@throws {Exception}
  ///@return {ShroomGrid}
  remove = function(shroom) {
    var cell = this.get(shroom.shroomGridKey)
    var index = cell.findIndex(function(shroom, index, target) {
      return shroom == target
    }, shroom)

    if (!Optional.is(index)) {
      var message = $"Shroom was already removed from cell '{shroom.shroomGridKey}'"
      Logger.error("ShroomGrid", message)
      Core.printStackTrace()
      throw new Exception(message)
    }
      
    cell.remove(index)
    //Logger.debug("ShroomGrid", $"Removed shroom at index {index} from cell '{shroom.shroomGridKey}'")
    shroom.shroomGridKey = null
    return this
  }
}

///@param {VisuController} _controller
///@param {Struct} [config]
function ShroomService(_controller, config = {}): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Array<Shroom>} 
  shrooms = new Array(Shroom)

  ///@type {ShroomGrid}
  shroomGrid = new ShroomGrid(0.3)

  ///@type {Map<String, ShroomTemplate>}
  templates = new Map(String, ShroomTemplate)

  ///@type {Stack<Number>}
  gc = new Stack(Number)

  ///@type {?Struct}
  spawner = null

  ///@type {?Struct}
  spawnerEvent = null

  ///@type {?Struct}
  particleArea = null

  ///@type {?Struct}
  particleAreaEvent = null

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

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-shroom": function(event) {
      var view = this.controller.gridService.view
      var template = new ShroomTemplate(event.data.template, this
        .getTemplate(event.data.template)
        .serialize())
      var spawnX = Assert.isType(Struct
        .getDefault(event.data, "spawnX", choose(1, -1) * random(3) * (random(100) / 100)), Number)
      var spawnY = Assert.isType(Struct
        .getDefault(event.data, "spawnY", -1 * random(2) * (random(100) / 100)), Number)
      var angle = Assert.isType(Struct
        .getDefault(event.data, "angle", 270), Number)
      var spd = Assert.isType(Struct
        .getDefault(event.data, "speed", 5), Number)

      
      var viewX = Struct.getDefault(event.data, "snapH", true)
        ? floor(view.x / view.width) * view.width
        : view.x

      var viewY = Struct.getDefault(event.data, "snapV", true)
        ? floor(view.y / view.height) * view.height
        : view.y

      Struct.set(template, "x", viewX + spawnX)
      Struct.set(template, "y", viewY + spawnY)
      Struct.set(template, "speed", spd / 1000.0)
      Struct.set(template, "angle", angle)

      var shroom = new Shroom(template)
      shroom.updateGameMode(this.controller.gameMode)

      this.shrooms.add(shroom)
      this.shroomGrid.add(shroom)
    },
    "clear-shrooms": function(event) {
      this.shrooms.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear()
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {ShroomService}
  update = function() {
    static updateGameMode = function(shroom, index, gameMode) {
      shroom.updateGameMode(gameMode)
    }

    static updateShroom = function(shroom, index, context) {
      shroom.update(context.controller)
      if (shroom.signals.kill) {
        context.gc.push(index)
        context.shroomGrid.remove(shroom)
      }
    }

    if (controller.gameMode != this.gameMode) {
      this.gameMode = this.controller.gameMode
      this.shrooms.forEach(updateGameMode, this.gameMode)
    }

    this.dispatcher.update()
    this.shrooms.forEach(updateShroom, this)
    if (this.gc.size() > 0) {
      this.shrooms.removeMany(this.gc)
    }
    return this
  }

  this.send(new Event("reset-templates"))
}
