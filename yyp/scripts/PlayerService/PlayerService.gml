///@package io.alkapivo.visu.service.player

///@param {Controller} _controller
///@param {Struct} [config]
function PlayerService(_controller, config = {}): Service() constructor {

  ///@type {Controller}
  controller = Assert.isType(_controller, Struct)

  ///@type {?Player}
  player = null

  ///@type {?GameMode}
  gameMode = null

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-player": function(event) {
      var template = new PlayerTemplate({
        name: "player_default",
        sprite: Struct.getDefault(event.data, "sprite", {
          name: "texture_player",
          animate: true,
        }),
        mask: Struct.get(event.data, "mask"),
        keyboard: {
          up: KeyboardKeyType.ARROW_UP,
          down: KeyboardKeyType.ARROW_DOWN,
          left: KeyboardKeyType.ARROW_LEFT,
          right: KeyboardKeyType.ARROW_RIGHT,
          action: "Z",
          bomb: "X",
          focus: KeyboardKeyType.SHIFT,
        },
        gameModes: {
          racing: JSON.clone(Struct.getDefault(event.data, "racing", {})),
          bulletHell: JSON.clone(Struct.getDefault(event.data, "bulletHell", {})),
          platformer: JSON.clone(Struct.getDefault(event.data, "platformer", {})),
        },
      })

      var view = this.controller.gridService.view
      var _x = view.x + (view.width / 2.0)
      var _y = view.y + (view.height / 0.5)

      if (Core.isType(this.player, Player)) {
        if (Struct.get(event.data, "reset-position") != true) {
          _x = this.player.x
          _y = this.player.y
        }

        Struct.set(template, "stats", this.player.stats)
      }

      Struct.set(template, "x", _x)
      Struct.set(template, "y", _y)

      this.set(new Player(template))
      this.player.updateGameMode(this.controller.gameMode)
    },
    "clear-player": function(event) {
      this.remove()
    },
  }))

  ///@param {Player}
  ///@return {PlayerService}
  set = function(player) {
    if (!Core.isType(player, Player)) {
      return this
    }
    this.remove().player = player
    return this
  }

  ///@return {PlayerService}
  remove = function() {
    this.player = null
    return this
  }

  ///@param {Event} event
  ///@return {Promise}
  send = function(event) {
    if (!Core.isType(event.promise, Promise)) {
      event.promise = new Promise()
    }
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {PlayerService}
  update = function() {
    this.dispatcher.update()
    if (Core.isType(this.player, Player)) {
      if (this.controller.gameMode != this.gameMode) {
        this.gameMode = this.controller.gameMode
        this.player.speed = 0
        this.player.angle = 90
        this.player.sprite.setAngle(this.player.angle)
        this.player.updateGameMode(this.gameMode)
      }
      
      this.player.update(this.controller)
    }
    return this
  }
}
