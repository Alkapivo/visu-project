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
    return $"x{x}y{y}"
  }

  ///@param {Number} x
  ///@param {Number} y
  ///@param {GridItem} item
  ///@return {ShroomGrid}
  add = function(x, y, item) {
    var cell = this.get(x, y)
    var index = cell.findIndex(function(item, index, target) {
      return item == target
    }, item)
    if (!Optional.is(index)) {
      cell.add(item)
      //Core.print($"Added shroom to cell x{x}y{y}")
    } else {
      Logger.error("ShroomGrid", $"Shroom was already added in this cell x{x}y{y}. This should not happened")
    }

    return this
  }

  ///@param {Number} x
  ///@param {Number} y
  ///@return {Array}
  get = function(x, y) {
    var key = this.toKey(x, y)
    if (!this.map.contains(key)) {
      this.map.set(key, new Array(GridItem))
    }
    return this.map.get(key)
  }

  ///@param {Number} fromX
  ///@param {Number} fromY
  ///@param {Number} toX
  ///@param {Number} toY
  ///@param {GridItem} item
  ///@return {ShroomGrid}
  move = function(fromX, fromY, toX, toY, item) {
    var from = this.get(fromX, fromY)
    var index = from.findIndex(function(item, index, target) {
      return item == target
    }, item)
    if (Optional.is(index)) {
      from.remove(index)
    } else {
      //Core.print($"Shroom was not found in this cell x{fromX}y{fromY}. This should not happened")
    }

    var to = this.get(toX, toY)
    index = to.findIndex(function(item, index, target) {
      return item == target
    }, item)
    if (!Optional.is(index)) {
      to.add(item)
      //Core.print($"Shroom moved from x{fromX}y{fromY} to x{toX}y{toY}")
    } else {
      Logger.error("ShroomGrid", $"Shroom from x{fromX}y{fromY} was already found in cell x{toX}y{toY}. This should not happened")
    }
    return this
  }

  ///@param {Number} x
  ///@param {Number} y
  ///@param {GridItem} item
  ///@return {ShroomGrid}
  remove = function(x, y, item) {
    var cell = this.get(x, y)
    var index = cell.findIndex(function(item, index, target) {
      return item == target
    }, item)
    if (Optional.is(index)) {
      cell.remove(index)
      //Core.print($"Removed shroom from x{x}y{y}")
    } else {
      Logger.error("ShroomGrid", $"Shroom was already removed from this cell x{x}y{y}. This should not happened")
    }

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
  shroomGrid = new ShroomGrid(0.2)

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

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-shroom": function(event) {
      var view = this.controller.gridService.view
      var template = new ShroomTemplate(event.data.template, this.templates
        .get(event.data.template)
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

      this.shroomGrid.add(floor(shroom.x / this.shroomGrid.size), floor(shroom.y / this.shroomGrid.size), shroom)
    },
    "clear-shrooms": function(event) {
      this.shrooms.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear().set("shroom-default", new ShroomTemplate("shroom-default", {
        "gameModes":{
          "racing":{ "features": [] },
          "bulletHell":{
            "features":[
              {
                "feature":"KillFeature",
                "conditions":[
                  {
                    "type":"player-collision"
                  }
                ]
              },
              {
                "feature":"KillFeature",
                "conditions":[
                  {
                    "type":"bullet-collision"
                  }
                ]
              }
            ]
          },
          "platformer": { "features": [] }
        },
        "sprite": { "name": "texture_baron" },
      }))
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
        context.shroomGrid.remove(floor(shroom.x / context.shroomGrid.size), floor(shroom.y / context.shroomGrid.size), shroom)
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
