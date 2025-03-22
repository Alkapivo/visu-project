///@package io.alkapivo.visu.service.grid


///@type {Number}
global.__GRID_SERVICE_PIXEL_WIDTH = 2048
#macro GRID_SERVICE_PIXEL_WIDTH global.__GRID_SERVICE_PIXEL_WIDTH


///@type {Number}
global.__GRID_SERVICE_PIXEL_HEIGHT = 2048
#macro GRID_SERVICE_PIXEL_HEIGHT global.__GRID_SERVICE_PIXEL_HEIGHT


///@type {Number}
global.__GRID_ITEM_FRUSTUM_RANGE = 8
#macro GRID_ITEM_FRUSTUM_RANGE global.__GRID_ITEM_FRUSTUM_RANGE


///@type {Number}
global.__GRID_ITEM_CHUNK_SERVICE_SIZE = 0.5
#macro GRID_ITEM_CHUNK_SERVICE_SIZE global.__GRID_ITEM_CHUNK_SERVICE_SIZE


///@param {Number} {_size}
function GridItemChunkService(_size) constructor {

  ///@type {Number}
  size = Assert.isType(_size, Number)

  ///@type {Map<String, Array<GridItem>>}
  chunks = new Map(String, Array)

  ///@param {Number} x
  ///@param {Number} y
  ///@return {String}
  getKey = function(x, y) {
    //return $"{int64(x)}_{int64(y)}"
    return string(int64(x)) + "_" + string(int64(y))
  }

  ///@param {String}
  ///@throws {AssertException}
  ///@return {Array<GridItem>}
  get = function(key) {
    //Assert.isType(key, String, "[GridItemChunkService::get(key)] argument 'key' must be a type of String")
    if (!this.chunks.contains(key)) {
      this.chunks.set(key, new Array(GridItem))
    }

    return this.chunks.get(key)
  }

  ///@param {GridItem}
  ///@throws {Exception}
  ///@return {GridItemChunkService}
  add = function(item) {
    Assert.isType(item, GridItem, "[GridItemChunkService::add(item)] argument 'item' must be a type of GridItem")
    var width = (item.mask.getWidth() * item.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH
    var height = (item.mask.getHeight() * item.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT
    var position = {
      start: {
        x: int64((((item.x) - (width / 2)) / this.size)),
        y: int64((((item.y) - (height / 2)) / this.size)),
      },
      finish: {
        x: int64((((item.x) + (width / 2)) / this.size)),
        y: int64((((item.y) + (height / 2)) / this.size)),
      },
      keys: new Array(String),
    }

    for (var row = 0; row <= position.finish.y - position.start.y; row++) {
      for (var column = 0; column <= position.finish.x - position.start.x; column++) {
        var key = this.getKey(position.start.x + column, position.start.y + row)
        var chunk = this.get(key)
        if (Optional.is(chunk.findIndex(Lambda.equal, item))) {
          var message = $"GridItem with uid '{item.uid}' was already added to chunk '{key}'"
          Logger.error("GridItemChunkService::add(item)", message)
          Core.printStackTrace()
          throw new Exception(message)
        }

        chunk.add(item)
        position.keys.add(key)
      }
    }

    item.chunkPosition = position
    return this
  }

  ///@param {GridItem} item
  ///@throws {AssertException|Exception}
  ///@return {GridItemChunkService}
  remove = function(item) {
    Assert.isType(item, GridItem, "[GridItemChunkService::remove(item)] argument 'item' must be a type of GridItem")
    item.chunkPosition.keys.forEach(function(key, iterator, acc) {
      var chunk = acc.get(key)
      var index = chunk.findIndex(Lambda.equal, acc.item)
      if (!Optional.is(index)) {
        var message = $"GridItem with uid '{acc.item.uid}' wasn't found in chunk '{key}'"
        Logger.error("GridItemChunkService::remove(item)", message)
        Core.printStackTrace()
        throw new Exception(message)
      }

      chunk.remove(index)
    }, {
      get: this.get,
      item: item,
    })

    item.chunkPosition = null
    return this
  }

  ///@param {GridItem} item
  ///@throws {AssertException|Exception}
  ///@return {GridItemChunkService}
  update = function(item) {
    //Assert.isType(item.chunkPosition, Struct, "[GridItemChunkService::update(item)] 'item.chunkPosition' must be a type of Struct")
    var position = item.chunkPosition
    var width = (item.mask.getWidth() * item.sprite.scaleX) / GRID_SERVICE_PIXEL_WIDTH
    var height = (item.mask.getHeight() * item.sprite.scaleY) / GRID_SERVICE_PIXEL_HEIGHT
    var startX = int64((((item.x) - (width / 2)) / this.size))
    var startY = int64((((item.y) - (height / 2)) / this.size))
    var finishX = int64((((item.x) + (width / 2)) / this.size))
    var finishY = int64((((item.y) + (height / 2)) / this.size))
    
    if (position.start.x != startX
      || position.start.y != startY
      || position.finish.x != finishX
      || position.finish.y != finishY) {

      ///this.remove(item) without replacing chunkPosition
      var array = item.chunkPosition.keys
      var size = array.size()
      for (var idx = 0; idx < size; idx++) {
        var key = array.get(idx)
        var chunk = this.get(key)
        var index = chunk.findIndex(Lambda.equal, item)
        if (!Optional.is(index)) {
          var message = $"GridItem with uid '{item.uid}' wasn't found in chunk '{key}'"
          Logger.error("GridItemChunkService::update(item)", message)
          Core.printStackTrace()
          throw new Exception(message)
        }
        chunk.remove(index)
      }

      ///this.add(item) without replacing chunkPosition
      position.start.x = startX
      position.start.y = startY
      position.finish.x = finishX
      position.finish.y = finishY
      position.keys.clear()
      for (var row = 0; row <= position.finish.y - position.start.y; row++) {
        for (var column = 0; column <= position.finish.x - position.start.x; column++) {
          var key = this.getKey(position.start.x + column, position.start.y + row)
          var chunk = this.get(key)
          if (Optional.is(chunk.findIndex(Lambda.equal, item))) {
            var message = $"GridItem with uid '{item.uid}' was already added to chunk '{key}'"
            Logger.error("GridItemChunkService::update(item)", message)
            Core.printStackTrace()
            throw new Exception(message)
          }
  
          chunk.add(item)
          position.keys.add(key)
        }
      }
    }

    return this
  }

  ///@return {GridItemChunkService}
  clear = function() {
    this.chunks.clear()
    return this
  }
}


///@param {?Struct} [config]
function GridService(_config = null) constructor {

  ///@type {?Struct}
  config = Core.isType(_config, Struct) ? JSON.clone(_config) : null

  ///@type {Number}
  width = Struct.getIfType(this.config, "width", Number, 2048.0)

  ///@type {Number}
  height = Struct.getIfType(this.config, "height", Number, 2048.0)

  ///@type {Number}
  pixelWidth = Struct.getIfType(this.config, "pixelWidth", Number, GRID_SERVICE_PIXEL_WIDTH)

  ///@type {Number}
  pixelHeight = Struct.getIfType(this.config, "pixelHeight", Number, GRID_SERVICE_PIXEL_HEIGHT)

  ///@type {GridView}
  view = new GridView({
    worldWidth: this.width, 
    worldHeight: this.height,
  })
  ///@description (set camera on middle bottom)
  this.view.x = (this.width - this.view.width) / 2.0
  this.view.y = this.height - this.view.height

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  ///@type {GridProperties}
  properties = new GridProperties(Struct.getIfType(this.config, "properties", Struct))

  ///@private
  ///@type {Number}
  uidPointer = toInt(Struct.getIfType(config, "uidPointer", Number, 0)) 

  ///@private
  ///@type {DebugTimer}
  moveGridItemsTimer = new DebugTimer("MoveGridItems")

  ///@private
  ///@type {DebugTimer}
  signalGridItemsCollisionTimer = new DebugTimer("GrdCollission")

  ///@private
  ///@type {DebugTimer}
  updatePlayerServiceTimer = new DebugTimer("PlayerService")

  ///@private
  ///@type {DebugTimer}
  updateShroomServiceTimer = new DebugTimer("ShroomService")

  ///@private
  ///@type {DebugTimer}
  updateBulletServiceTimer = new DebugTimer("BulletService")
  
  ///@type {Struct}
  targetLocked = {
    x: this.view.x + (this.view.width / 2.0),
    y: this.view.y + (this.view.height / 2.0),
    isLockedX: false,
    isLockedY: false,
    lockX: null,
    lockY: null,
    snapH: floor(this.view.x / (this.view.width / 2.0)) * (this.view.width / 2.0),
    snapV: floor(this.view.y / (this.view.height / 2.0)) * (this.view.height / 2.0),
    setX: function(x) {
      this.x = x
      return this
    },
    setY: function(y) {
      this.y = y
      return this
    },
    updateMovement: function(gridService) {
      var angle = DeltaTime.apply(gridService.movement.angle.update().get() / 500.0)
      var spd = DeltaTime.apply(gridService.movement.speed.update().get())
      this.setX(this.x + Math.fetchCircleX(spd, angle))
      this.setY(this.y + Math.fetchCircleY(spd, angle))

      return this
    },
    updateLock: function(gridService) {
      var view = gridService.view
      var follow = view.follow
      var horizontal = gridService.properties.borderHorizontalLength / 2.0
      var vertical = gridService.properties.borderVerticalLength / 2.0
      var player = Beans.get(BeanVisuController).playerService.player
      var isPlayer = Core.isType(player, Player) 
      if (isPlayer) {
        this.setX(clamp(player.x, follow.xMargin, view.worldWidth - follow.xMargin))
        this.setY(clamp(player.y, follow.yMargin, view.worldHeight - follow.yMargin))
      }
      
      if (this.isLockedX) {
        this.lockX = Optional.is(this.lockX) 
          ? this.lockX 
          : (floor(view.x / view.width) * view.width) + 0.5 
        var xMin = (this.lockX + (view.width / 2.0)) - horizontal + follow.xMargin
        var xMax = (this.lockX + (view.width / 2.0)) + horizontal - follow.xMargin
        var xMinOffset = xMin < 0 ? abs(xMin) : 0.0
        var xMaxOffset = xMax > view.worldWidth ? xMax - view.worldWidth : 0.0
        xMin = clamp(xMin - xMaxOffset, 0.0, view.worldWidth)
        xMax = clamp(xMax + xMinOffset, 0.0, view.worldWidth)
        this.setX(clamp(this.x, xMin, xMax))
        this.snapH = clamp(this.lockX + xMinOffset - xMaxOffset, 0.0, view.worldWidth)
      } else {
        this.lockX = null
        this.snapH = floor(view.x / (view.width / 2.0)) * (view.width / 2.0)
      }
  
      if (this.isLockedY) {
        this.lockY = Optional.is(this.lockY) 
          ? this.lockY
          : floor(view.y / view.height) * view.height
        var yMin = (this.lockY + (view.height / 2.0)) - vertical + follow.yMargin
        var yMax = (this.lockY + (view.height / 2.0)) + vertical - follow.yMargin
        var yMinOffset = yMin < 0 ? abs(yMin) : 0.0
        var yMaxOffset = yMax > view.worldHeight ? yMax - view.worldHeight : 0.0
        yMin = clamp(yMin - yMaxOffset, 0.0, view.worldHeight)
        yMax = clamp(yMax + yMinOffset, 0.0, view.worldHeight)
        this.setY(clamp(this.y, yMin, yMax))
        this.snapV = clamp(this.lockY + yMinOffset - yMaxOffset, 0.0, view.worldHeight)
      } else {
        this.lockY = null
        this.snapV = floor(view.y / (view.height / 2.0)) * (view.height / 2.0)
      }

      if (isPlayer) {
        player.x = clamp(player.x, 0.0, view.worldWidth)
        player.y = clamp(player.y, 0.0, view.worldHeight)
      }

      view.setFollowTarget(this).update()

      return this
    },
    update: function(gridService) {
      return gridService.movement.enable
        ? this.updateMovement(gridService)
        : this.updateLock(gridService)
    },
  }

  ///@type {Struct}
  movement = {
    enable: false,
    angle: new NumberTransformer({ value: 90.0, target: 1.0, factor: 0.01, increase: 0.0 }),
    speed: new NumberTransformer({ value: 0.0, target: 1.0, factor: 0.01, increase: 0.0 }),
  }
  
  ///@type {Struct}
  avgTime = {
    value: 0,
    count: 0,
    add: function(value) {
      this.value += value
      this.count += 1
      return this
    },
    reset: function() {
      this.value = 0
      this.count = 0
      return this
    },
    get: function() {
      return this.value / this.count
    }
  }

  ///@type {Struct}
  textureGroups = {
    map: new Map(String, Number),
    getIndex: function(item) {
      var value = this.map.get(item.sprite.getName())
      if (value == null) {
        value = this.map.size()
        this.map.set(item.sprite.getName(), value)
      }

      return value
    },
    compareItems: function(a, b) {
      return this.getIndex(a) - this.getIndex(b)
    },
    sortItems: function(items) {
      items.setContainer(GMArray.sort(items.getContainer(), this.compareItems))
    },
  }
  
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "transform-property": Callable.run(Struct.get(EVENT_DISPATCHERS, "transform-property")),
    "fade-sprite": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-sprite")),
    "fade-color": Callable.run(Struct.get(EVENT_DISPATCHERS, "fade-color")),
    "clear-grid": function(event) {
      this.view.x = (this.width - this.view.width) / 2.0
      this.view.y = this.height - this.view.height

      this.targetLocked.x = this.view.x + (this.view.width / 2.0)
      this.targetLocked.y = this.view.y + (this.view.height / 2.0)
      this.targetLocked.isLockedX = false
      this.targetLocked.isLockedY = false
      this.targetLocked.lockX = null
      this.targetLocked.lockY = null

      properties = new GridProperties(Struct.getIfType(this.config, "properties", Struct))
    },
  }))

  ///@private
  ///@return {String}
  generateUID = function() {
    if (this.uidPointer >= MAX_INT_64 - 1) {
      Logger.warn("GridService", $"Reached maximum available value for uidPointer ('{MAX_INT_64}'). Reset uidPointer to '0'")
      this.uidPointer = int64(0)
    }
    this.uidPointer++
    return md5_string_utf8(string(this.uidPointer))
  }

  ///@return {GridService}
  init = function() {
    var task = new Task("init-foreground")
      .setTimeout(3.0)
      .whenUpdate(function(executor) {
        var controller = Beans.get(BeanVisuController)

        var lastX = null
        var lastY = null
        var scale = 1.0 + (random(1.0) * 0.25 * choose(1.0, -1.0))
        var angle = random(7.5) * choose(1.0, -1.0)
        var lastTask = controller.visuRenderer.gridRenderer.overlayRenderer.foregrounds.getLast()
        if (Core.isType(lastTask, Task) && Core.isType(lastTask.state, Map)) {
          lastX = lastTask.state.get("x")
          lastY = lastTask.state.get("y")
        }

        controller.send(new Event("fade-sprite", {
          sprite: SpriteUtil.parse({
            name: "texture_hechan_3_abstract",
            alpha: 0.33,
            blend: "#FF00EE",
          }),
          collection: controller.visuRenderer.gridRenderer.overlayRenderer.backgrounds,
          type: WallpaperType.BACKGROUND,
          fadeInDuration: 1.0 + random(1.0),
          fadeOutDuration: 3.0 + random(3.0),
          angle: 90.0,
          speed: 3.33 + random(6.66),
          blendModeSource: BlendModeExt.SRC_ALPHA,
          blendModeTarget: BlendModeExt.ONE,
          blendEquation: BlendEquation.SUBTRACT,
          blendEquationAlpha: BlendEquation.ADD,
          executor: executor,
          tiled: true,
          replace: true,
          x: lastX,
          y: lastY,
          xScale: scale,
          yScale: scale,
        }))
        //this.fullfill()
        //return null;
        controller.send(new Event("fade-sprite", {
          sprite: SpriteUtil.parse({
            name: "texture_hechan_3_background",
            alpha: 0.9,
            blend: "#FFFFFF",
          }),
          collection: controller.visuRenderer.gridRenderer.overlayRenderer.backgrounds,
          type: WallpaperType.BACKGROUND,
          fadeInDuration: 2.0 + random(1.0),
          fadeOutDuration: 4.0 + random(1.0),
          angle: 180.0 + angle,
          speed: 1.25 + (random(1.0) * 0.5),
          blendModeSource: BlendModeExt.SRC_ALPHA,
          blendModeTarget: BlendModeExt.ONE,
          blendEquation: BlendEquation.ADD,
          blendEquationAlpha: BlendEquation.ADD,
          executor: executor,
          tiled: true,
          replace: false,
          x: lastX,
          y: lastY,
          xScale: scale,
          yScale: scale,
        }))

        controller.send(new Event("fade-sprite", {
          sprite: SpriteUtil.parse({
            name: "texture_hechan_3",
            alpha: 1.0,
            blend: "#FFFFFF",
          }),
          collection: controller.visuRenderer.gridRenderer.overlayRenderer.foregrounds,
          type: WallpaperType.FOREGROUND,
          fadeInDuration: 1.0 + random(1.0),
          fadeOutDuration: 3.0 + random(1.0),
          angle: angle,
          speed: 0.15 + (random(1.0) * 0.2),
          blendModeSource: BlendModeExt.SRC_ALPHA,
          blendModeTarget: BlendModeExt.ONE,
          blendEquation: BlendEquation.ADD,
          blendEquationAlpha: BlendEquation.ADD,
          executor: executor,
          tiled: true,
          replace: true,
          x: lastX,
          y: lastY,
          xScale: scale,
          yScale: scale,
        }))
        this.fullfill()
      })
    Beans.get(BeanVisuController).executor.add(task)
    
    return this
  }

  ///@param {Bullet} bullet
  ///@param {Number} key
  ///@param {Struct} acc
  moveBullet = function(bullet, key, acc) {
    bullet.move()
    if (bullet.producer == Player) {
      acc.chunkService.update(bullet)
    }
    
    var view = acc.view
    var length = Math.fetchLength(
      bullet.x, bullet.y,
      view.x + (view.width / 2.0), 
      view.y + (view.height / 2.0)
    )

    if (length > GRID_ITEM_FRUSTUM_RANGE) {
      bullet.signal("kill")
    }
  }

  ///@param {Shroom} shroom
  ///@param {Number} key
  ///@param {Struct} acc
  moveShroom = function(shroom, key, acc) {
    shroom.move()
    acc.chunkService.update(shroom)
    
    var view = acc.view
    var length = Math.fetchLength(
      shroom.x, shroom.y,
      view.x + (view.width / 2.0), 
      view.y + (view.height / 2.0)
    )

    if (length > GRID_ITEM_FRUSTUM_RANGE) {
      shroom.signal("kill")
    }
  }

  ///@private
  ///@return {GridService}
  moveGridItems = function() {
    var controller = Beans.get(BeanVisuController)
    var view = controller.gridService.view
    controller.bulletService.bullets.forEach(this.moveBullet, {
      view: view,
      chunkService: controller.bulletService.chunkService,
    })

    controller.shroomService.shrooms.forEach(this.moveShroom, {
      view: view,
      chunkService: controller.shroomService.chunkService,
    })

    var player = controller.playerService.player
    if (Core.isType(player, Player)) {
      player.move()
    }
    return this
  }

  ///@param {Bullet} bullet
  ///@param {Number} index
  ///@param {VisuController} controller
  bulletCollision = function(bullet, index, controller) {
    static playerBullet = function(shroom, index, bullet) {
      if (shroom.collide(bullet)) {
        shroom.signal("bulletCollision", bullet)
        shroom.signal("damage", true)
        shroom.healthPoints = clamp(shroom.healthPoints - bullet.damage, 0, 9999.9)
        bullet.signal("shroomCollision", shroom)
      }
    }
    static shroomBullet = function(player, bullet) {
      if (bullet.fadeIn >= 1.0 && player.collide(bullet)) {
        player.signal("bulletCollision", bullet)
        bullet.signal("playerCollision", player)
      }
    }
    static playerLambda = function(key, index, acc) {
      acc.chunkService.get(key).forEach(acc.playerBullet, acc.bullet)
    }

    switch (bullet.producer) {
      case Player:
        bullet.chunkPosition.keys.forEach(playerLambda, {
          chunkService: controller.shroomService.chunkService,
          playerBullet: playerBullet,
          bullet: bullet,
        })
        //controller.shroomService.shrooms.forEach(playerBullet, bullet)
        break
      case Shroom:
        shroomBullet(controller.playerService.player, bullet)
        break
      default:
        Logger.warn("GridService", "Found invalid bullet producer")
        break
    }
  }

  ///@param {Bullet} bullet
  ///@param {Number} index
  ///@param {VisuController} controller
  bulletCollisionNoPlayer = function(bullet, index, controller) { }

  ///@param {Shroom} shroom
  ///@param {Number} index
  ///@param {Player} player
  shroomCollision = function(shroom, index, player) {
    if (shroom.fadeIn >= 1.0 && shroom.collide(player)) {
      player.signal("shroomCollision", shroom)
      shroom.signal("playerCollision", player)
      shroom.signal("damage", true)
      shroom.healthPoints = clamp(shroom.healthPoints - 1.0, 0, 9999.9)
    }
  }

  ///@param {Shroom} shroom
  ///@param {Number} index
  ///@param {Player} player
  shroomCollisionGodMode = function(shroom, index, player) {
    if (shroom.collide(player)) {
      shroom.signal("playerCollision", player)
      shroom.signal("kill")
    }
  }

  ///@param {Shroom} shroom
  ///@param {Number} index
  ///@param {?Player} player
  shroomCollisionNoPlayer = function(shroom, index, player) { }

  ///@private
  ///@return {GridService}
  signalGridItemsCollision = function() {
    var controller = Beans.get(BeanVisuController)
    var player = controller.playerService.player
    var isPlayer = Core.isType(player, Player)
  
    controller.bulletService.bullets.forEach(
      isPlayer
        ? this.bulletCollision
        : this.bulletCollisionNoPlayer,
      controller
    )
     
    controller.shroomService.shrooms.forEach(
      isPlayer
        ? (player.stats.godModeCooldown > 0.0 
          ? this.shroomCollisionGodMode 
          : this.shroomCollision)
        : this.shroomCollisionNoPlayer, 
      player
    )
    
    return this
  }

  ///@private
  ///@return {GridService}
  updateGridItemsOriginal = function() {
    var controller = Beans.get(BeanVisuController)

    this.moveGridItemsTimer.start()
    this.moveGridItems()
    this.moveGridItemsTimer.finish()

    this.signalGridItemsCollisionTimer.start()
    this.signalGridItemsCollision()
    this.signalGridItemsCollisionTimer.finish()

    this.updatePlayerServiceTimer.start()
    controller.playerService.update(this)
    this.updatePlayerServiceTimer.finish()

    this.updateShroomServiceTimer.start()
    controller.shroomService.update(this)
    this.updateShroomServiceTimer.finish()

    this.updateBulletServiceTimer.start()
    controller.bulletService.update(this)
    this.updateBulletServiceTimer.finish()
    return this
  }

  ///@private
  ///@return {GridService}
  updateGridItemsAlternative = function() {
    static bulletLambda = function(bullet, index, acc) {
      acc.moveBullet(bullet, index, acc)
      acc.bulletCollision(bullet, index, acc.controller)
      acc.bulletService.updateBullet(bullet, index, acc.bulletService)
    }

    static shroomLambda = function(shroom, index, acc) {
      acc.shroomCollision(shroom, index, acc.player)
      acc.shroomService.updateShroom(shroom, index, acc.shroomService)
      if (!shroom.signals.kill) {
        acc.moveShroom(shroom, index, acc)
      }
    }

    var controller = Beans.get(BeanVisuController)
    var gridService = this
    var bulletService = controller.bulletService
    var shroomService = controller.shroomService
    var playerService = controller.playerService
    var player = playerService.player
    var isPlayer = Core.isType(player, Player)
    var view = controller.gridService.view

    if (isPlayer) {
      player.move()
    }

    this.updateBulletServiceTimer.start()
    bulletService.dispatcher.update()
    bulletService.bullets.forEach(bulletLambda, {
      controller: controller,
      moveBullet: this.moveBullet,
      view: view,
      chunkService: bulletService.chunkService,
      bulletCollision: isPlayer ? this.bulletCollision : this.bulletCollisionNoPlayer,
      gridService: gridService,
      bulletService: bulletService,
    }).runGC() 
    this.updateBulletServiceTimer.finish()

    this.updateShroomServiceTimer.start()
    if (controller.gameMode != shroomService.gameMode) {
      shroomService.gameMode = controller.gameMode
      shroomService.shrooms.forEach(shroomService.updateGameMode, shroomService.gameMode)
    }
  
    shroomService.dispatcher.update()
    shroomService.shrooms.forEach(shroomLambda, {
      moveShroom: this.moveShroom,
      view: view,
      chunkService: shroomService.chunkService,
      shroomCollision: isPlayer
        ? (player.stats.godModeCooldown > 0.0 
          ? this.shroomCollisionGodMode 
          : this.shroomCollision) 
        : this.shroomCollisionNoPlayer,
      player: player,
      shroomService: shroomService,
    }).runGC()
    this.updateShroomServiceTimer.finish()

    this.updatePlayerServiceTimer.start()
    
    playerService.update()
    this.updatePlayerServiceTimer.finish()
    return this
  }

  ///@private
  ///@return {GridService}
  updateGridItems = function() {
    return Visu.settings.getValue("visu.optimalization.iterate-entities-once")
      ? this.updateGridItemsAlternative()
      : this.updateGridItemsOriginal()
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {GridService}
  update = function() {
    this.properties.update(this)
    this.dispatcher.update()
    this.executor.update()
    this.targetLocked.update(this)
    this.updateGridItems()
    
    return this
  }

  this.executor.add(new Task("init")
    .setTimeout(3.0)
    .whenUpdate(function(executor) {
      executor.context.init()
      this.fullfill()
    }))
}
