///@package io.alkapivo.visu.ui

///@enum
function _VisuMenuEntryEventType(): Enum() constructor {
  OPEN_NODE = "open-node"
  LOAD_TRACK = "load-track"
}
global.__VisuMenuEntryEventType = new _VisuMenuEntryEventType()
#macro VisuMenuEntryEventType global.__VisuMenuEntryEventType


///@param {String} name
///@param {String} text
///@return {Struct}
function factoryPlayerKeyboardKeyEntryConfig(name, text) {
  return {
    layout: { type: UILayoutType.VERTICAL },
    label: { 
      key: name,
      text: text,
      cooldown: new Timer(FRAME_MS * 10),
      updateCustom: function() {
        if (!this.cooldown.finished) {
          this.cooldown.update()
        }

        var lastKey = keyboard_lastkey
        if (lastKey == vk_nokey || this.context.state.get("remapKey") != this.key) {          
          return
        }

        this.context.state.set("remapKey", null)
        keyboard_lastkey = vk_nokey
        this.cooldown.reset()
        Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
        if (lastKey == KeyboardKeyType.ESC || lastKey == KeyboardKeyType.ENTER) {
          return
        }

        var keyboard = Beans.get(BeanVisuIO).keyboards.get("player")
        keyboard.setKey(this.key, lastKey)
        Logger.debug("VisuMenu", $"Remap key {this.key} to {lastKey}")

        Visu.settings.setValue("visu.keyboard.player.up", Struct.get(keyboard.keys, "up").gmKey)
        Visu.settings.setValue("visu.keyboard.player.down", Struct.get(keyboard.keys, "down").gmKey)
        Visu.settings.setValue("visu.keyboard.player.left", Struct.get(keyboard.keys, "left").gmKey)
        Visu.settings.setValue("visu.keyboard.player.right", Struct.get(keyboard.keys, "right").gmKey)
        Visu.settings.setValue("visu.keyboard.player.action", Struct.get(keyboard.keys, "action").gmKey)
        Visu.settings.setValue("visu.keyboard.player.bomb", Struct.get(keyboard.keys, "bomb").gmKey)
        Visu.settings.setValue("visu.keyboard.player.focus", Struct.get(keyboard.keys, "focus").gmKey)
        Visu.settings.save()
      },
      callback: new BindIntent(function() {
        if (!this.cooldown.finished || this.context.state.get("remapKey") == this.key) {
          return
        }

        this.context.state.set("remapKey", this.key)
        keyboard_lastkey = vk_nokey
      }),
      onMouseReleasedLeft: function() {
        this.callback()
      },
    },
    preview: {
      key: name,
      text: "",
      updateCustom: function() {
        var keyCode = Struct.get(Beans.get(BeanVisuIO).keyboards.get("player").keys, this.key).gmKey
        if (KeyboardKeyType.contains(keyCode)) {
          this.label.text = KeyboardKeyType.findKey(keyCode)
        } else if (KeyboardSpecialKeys.contains(keyCode)) {
          this.label.text = KeyboardSpecialKeys.get(keyCode)
        } else {
          this.label.text = chr(keyCode)
        }
        
        if (this.context.state.get("remapKey") == this.key) {
          this.label.alpha = (random(100) / 100) * 0.6
        } else {
          this.label.alpha = 1.0
        }
      },
      callback: new BindIntent(function() {
        if (this.context.state.get("remapKey") == this.key) {
          return
        }

        this.context.state.set("remapKey", this.key)
        keyboard_lastkey = vk_nokey
      }),
      onMouseReleasedLeft: function() {
        this.callback()
      },
    },
  }
}


///@param {Struct} json
function VisuMenuNode(json) constructor {

  ///@type {String}
  title = Assert.isType(json.title, String)

  ///@type {?String}
  back = Core.isType(json.back, String) ? json.back : null

  ///@type {Array<VisuMenuEntry>}
  entries = new Array(VisuMenuEntry, Core.isType(Struct.get(json, "entries"), GMArray) 
    ? GMArray.map(json.entries, function(json) { return new VisuMenuEntry(json) }) 
    : [])
}


///@param {Struct} json
function VisuMenuEntry(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {VisuMenuEntryEvent}
  event = new VisuMenuEntryEvent(json.event)
}


///@param {Struct} json
function VisuMenuEntryEvent(json) constructor {

  ///@type {String}
  type = Assert.isEnum(json.type, VisuMenuEntryEventType)

  ///@type {?Struct}
  data = Core.isType(Struct.get(json, "data"), Struct) ? json.data : null
}


///@param {?Struct} [_config]
function VisuMenu(_config = null) constructor {

  ///@return {Map<String, VisuMenuNode>}
  static parseNodes = function() {
    var nodes = new Map(String, VisuMenuNode)
    try {
      var manifest = FileUtil
        .readFileSync(FileUtil.get(Core.getRuntimeType() != RuntimeType.GXGAMES
          ? $"{working_directory}track/manifest.json"
          : $"{working_directory}track/manifest-wasm.json"))
        .getData()
      var parserTask = JSON.parserTask(manifest, {
        callback: function(prototype, json, key, acc) {
          acc.add(new prototype(json), key)
        },
        acc: nodes,
      })

      var index = 0
      var MAX_INDEX = 9999
      while (true) {
        if (parserTask.update().status != TaskStatus.RUNNING) {
          break
        }
        Assert.isTrue(index++ <= MAX_INDEX, $"Exceed MAX_INDEX={MAX_INDEX}")
      }
    } catch (exception) {
      Logger.error(BeanVisuController, $"Exception throwed while parsing track/manifest.json: {exception.message}")
      Core.printStackTrace()
    }

    return nodes
  }

  ///@type {?Struct}
  config = Optional.is(_config) ? Assert.isType(_config, Struct) : null

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {?Callable}
  back = null

  ///@type {any}
  backData = null

  ///@type {?String}
  remapKey = null

  ///@type {Map<String, VisuMenuNode>}
  nodes = this.parseNodes()

  ///@param {String} nodeName
  ///@return {Event}
  factoryOpenVisuMenuNode = function(nodeName) {
    var node = this.nodes.get(nodeName)
    if (!Core.isType(node, VisuMenuNode)) {
      return this.factoryOpenMainMenuEvent()
    }

    var back = Core.isType(this.nodes.get(node.back), VisuMenuNode)
      ? this.factoryOpenVisuMenuNode
      : this.factoryOpenMainMenuEvent
    var backData = back == this.factoryOpenVisuMenuNode ? node.back : null,
    var event = new Event("open").setData({
      back: back,
      backData: backData,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: $"{nodeName}_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: node.title
          },
        },
      },
      content: new Array(Struct, node.entries
        .map(function(entry, index, nodeName) {
          return {
            name: $"{nodeName}_menu-button-entry_{index}",
            template: VisuComponents.get("menu-button-entry"),
            layout: VisuLayouts.get("menu-button-entry"),
            config: {
              layout: { type: UILayoutType.VERTICAL },
              label: { 
                text: entry.name,
                callback: new BindIntent(function() {
                  var controller = Beans.get(BeanVisuController)
                  var menu = controller.menu
                  var event = this.callbackData
                  switch (event.type) {
                    case VisuMenuEntryEventType.OPEN_NODE:
                      menu.send(Core.isType(menu.nodes.get(event.data.node), VisuMenuNode)
                        ? menu.factoryOpenVisuMenuNode(event.data.node)
                        : menu.factoryOpenMainMenuEvent())
                      controller.sfxService.play("menu-select-entry")
                      break
                    case VisuMenuEntryEventType.LOAD_TRACK:
                      controller.send(new Event("load", {
                        manifest: $"{working_directory}{event.data.path}",
                        autoplay: true,
                      }))
                      controller.sfxService.play("menu-select-entry")
                      break
                    default:
                      throw new Exception("VisuMenuEntryEventType does not support '{this.event.type}'")
                  }
                }),
                callbackData: entry.event,
                onMouseReleasedLeft: function() {
                  this.callback()
                },
              },
            }
          }
        }, nodeName, Struct)
        .add(
          {
            name: $"{nodeName}_menu-button-entry_back",
            template: VisuComponents.get("menu-button-entry"),
            layout: VisuLayouts.get("menu-button-entry"),
            config: {
              layout: { type: UILayoutType.VERTICAL },
              label: { 
                text: "Back",
                callback: new BindIntent(function() {
                  var controller = Beans.get(BeanVisuController)
                  var menu = controller.menu
                  menu.send(Core.isType(menu.nodes.get(this.callbackData), VisuMenuNode)
                    ? menu.factoryOpenVisuMenuNode(this.callbackData)
                    : menu.factoryOpenMainMenuEvent())
                  controller.sfxService.play("menu-select-entry")
                }),
                callbackData: node.back,
                onMouseReleasedLeft: function() {
                  this.callback()
                },
                colorHoverOut: VETheme.color.deny,
              },
            }
          }
        ).getContainer()
      ),
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenMainMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenMainMenuEvent,
        quit: this.factoryConfirmationDialog,
        titleLabel: "VISU Project",
        disableResume: false,
        isTrackLoaded: Beans.get(BeanVisuController).trackService.isTrackLoaded(),
        isGameOver: Beans.get(BeanVisuController).fsm.getStateName() == "game-over",
      }
    )

    var event = new Event("open").setData({
      back: null,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "main-menu_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: config.titleLabel,
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "main-menu_menu-button-entry_settings",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Options",
              callback: new BindIntent(function() {
                var menu = Beans.get(BeanVisuController).menu
                menu.send(menu.factoryOpenSettingsMenuEvent(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "main-menu_menu-button-entry_credits",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Credits",
              callback: new BindIntent(function() {
                var menu = Beans.get(BeanVisuController).menu
                menu.send(menu.factoryOpenCreditsMenuEvent(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
      ])
    })

    var menuState = config.isGameOver
      ? "game-over"
      : (config.isTrackLoaded ? "in-game" : "main-menu")
    
    var counter = 0
    switch (menuState) {
      case "in-game":
        if (!config.disableResume) {
          event.data.content.add({
            name: "main-menu_menu-button-entry_resume",
            template: VisuComponents.get("menu-button-entry"),
            layout: VisuLayouts.get("menu-button-entry"),
            config: {
              layout: { type: UILayoutType.VERTICAL },
              label: { 
                text: "Resume",
                callback: new BindIntent(function() {
                  Beans.get(BeanVisuController).fsm.dispatcher.send(new Event("transition", { name: "play" }))
                  Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                }),
                callbackData: config,
                onMouseReleasedLeft: function() {
                  this.callback()
                },
              },
            }
          }, counter)
          counter++
        }

        event.data.content.add({
          name: "main-menu_menu-button-entry_retry",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Retry",
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                Assert.isType(controller.track, VisuTrack, "VisuController.track must be type of VisuTrack")
                controller.send(new Event("load", {
                  manifest: $"{controller.track.path}manifest.visu",
                  autoplay: true,
                }))
                controller.sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
  
        event.data.content.add({
          name: "main-menu_menu-button-entry_restart",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Main menu",
              callback: new BindIntent(function() {
                Scene.open("scene_visu")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
        break
      case "main-menu":
        event.data.content.add({
          name: "main-menu_menu-button-entry_play",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Play",
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                var menu = controller.menu
                menu.send(menu.factoryOpenVisuMenuNode("root.artists"))
                controller.sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
        break
      case "game-over":
        event.data.content.add({
          name: "main-menu_menu-button-entry_retry",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Retry",
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                Assert.isType(controller.track, VisuTrack, "VisuController.track must be type of VisuTrack")
                controller.send(new Event("load", {
                  manifest: $"{controller.track.path}manifest.visu",
                  autoplay: true,
                }))
                controller.sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
  
        event.data.content.add({
          name: "main-menu_menu-button-entry_restart",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Main menu",
              callback: new BindIntent(function() {
                Scene.open("scene_visu")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
        break
    }

    if (Core.getRuntimeType() != RuntimeType.GXGAMES) {
      event.data.content.add({
        name: "main-menu_menu-button-entry_quit",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Quit",
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              Beans.get(BeanVisuController).menu.send(Callable
                .run(this.callbackData.quit, { back: this.callbackData.back }))
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            colorHoverOut: VETheme.color.deny,
          },
        }
      })
    }

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryConfirmationDialog = function(_config = null) {
    var context = this
    var config = Struct.appendUnique(
      _config,
      {
        accept: function() { return new Event("game-end") },
        acceptLabel: "Yes",
        decline: context.factoryOpenMainMenuEvent, 
        declineLabel: "No",
        message: "Are you sure?"
      }
    )

    var event = new Event("open").setData({
      accept: config.accept,
      decline: config.decline,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "confirmation-dialog_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: config.message,
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "confirmation-dialog_menu-button-entry_accept",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: config.acceptLabel,
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.accept,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "confirmation-dialog_menu-button-entry_decline",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: config.declineLabel,
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.decline,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenSettingsMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        graphics: this.factoryOpenGraphicsSettingsMenuEvent,
        audio: this.factoryOpenAudioSettingsMenuEvent,
        interface: this.factoryOpenInterfaceSettingsMenuEvent,
        controls: this.factoryOpenControlsMenuEvent,
        developer: this.factoryOpenDeveloperMenuEvent,
        back: this.factoryOpenMainMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "settings_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Settings",
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "settings_menu-button-entry_graphics",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Graphics",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.graphics,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "settings_menu-button-entry_audio",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Audio",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.audio,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "settings_menu-button-entry_interface",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Interface",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.interface,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "settings_menu-button-entry_controls",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Controls",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.controls,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "settings_menu-button-entry_developer",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Developer",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.developer,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "settings_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

    ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenCreditsMenuEvent = function(_config = null) {
    static  factoryCreditsEntry = function(index, text) {
      return {
        name: $"credits_menu-button-entry_{index}",
        template: VisuComponents.get("menu-label-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { text: text },
        }
      }
    }

    static factoryCreditsTitle = function(index, text) {
      return {
        name: $"credits_menu-button-entry_{index}",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { text: text },
        }
      }
    }

    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenMainMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "credits_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Credits",
          },
        },
      },
      content: new Array(Struct, [
        factoryCreditsTitle("ijwgRtbT", "Game design"),
        factoryCreditsEntry("TywGRhb1", "\n@Alkapivo\n@Baron"),
        factoryCreditsTitle("nrmgjhgj", "Level design"),
        factoryCreditsEntry("gKgVhDsT", "\n@Alkapivo\n@Baron"),
        factoryCreditsTitle("YU9WJfKr", "Music"),
        factoryCreditsEntry("I94zzBo7", "\nJust To Create Something\n@kedy_selma"),
        factoryCreditsEntry("Y6yNV8JN", "\nPassion\n@kedy_selma"),
        factoryCreditsEntry("yfMcRQPG", "\nQW1waGV0YW1pbmU\n@nfract"),
        factoryCreditsEntry("fyQD5OCd", "\nDestination Unknown\n@Schnoopy"),
        factoryCreditsEntry("TdMvcdS6", "\nPsychosis\n@Sewerslvt"),
        factoryCreditsEntry("Zvsi4gtq", "\nPurple Hearts In Her Eyes\n@Sewerslvt"),
        factoryCreditsEntry("4Ht9Ewl1", "\ndigitalshadow\n@zoogies"),
        factoryCreditsTitle("qQwqRmsT", "Programming"),
        factoryCreditsEntry("Bimj4rUU", "\nvisu-project\n@Alkapivo (github.com/Alkapivo/visu-project)"),
        factoryCreditsEntry("4MnGw7O7", "\nvisu-gml\n@Alkapivo (github.com/Alkapivo/visu-gml)"),
        factoryCreditsEntry("Ubngnmgi", "\ncore-gml\n@Alkapivo (github.com/Alkapivo/core-gml)"),
        factoryCreditsEntry("YnO6tbvb", "\nmh-cz.gmtf-gml\n@maras_cz, @Alkapivo (github.com/Alkapivo/mh-cz.gmtf-gml)"),
        factoryCreditsEntry("nHAfeBGD", "\nfyi.odditica.bktGlitch-gml\n@blokatt, @Alkapivo (github.com/Alkapivo/fyi.odditica.bktGlitch-gml)"),
        factoryCreditsEntry("OO9EyOWN", "\ncom.pixelatedpope.tdmc-gml\n@Pixelated_Pope, @Alkapivo (github.com/Alkapivo/com.pixelatedpope.tdmc-gml"),
        factoryCreditsEntry("7ixDm727", "\ngm-cli\n@Alkapivo (github.com/Alkapivo/gm-cli)"),
        factoryCreditsTitle("tu8URzmo", "Shaders"),
        factoryCreditsEntry("aooLlGEu", "\nShader NOG BETERE 2\n@svtetering (shadertoy.com/view/NtlSzX)"),
        factoryCreditsEntry("upVVCWbu", "\nShader HUE\n@KeeVee_Games (musnik.itch.io/hue-shader)"),
        factoryCreditsEntry("samNRF8w", "\nShader 002 BLUE\n@haquxx (shadertoy.com/view/WldSRn)"),
        factoryCreditsEntry("jVnyiDrA", "\nShader 70S MELT\n@tomorrowevening (shadertoy.com/view/XsX3zl)"),
        factoryCreditsEntry("LYOYldBk", "\nShader ART\n@kishimisu (shadertoy.com/view/mtyGWy)"),
        factoryCreditsEntry("lyEVE3tF", "\nShader BASE WARP FBM\n@trinketMage (shadertoy.com/view/tdG3Rd)"),
        factoryCreditsEntry("3ifsKUds", "\nShader BROKEN TIME PORTAL\n@iekdosha (shadertoy.com/view/XXcGWr)"),
        factoryCreditsEntry("7K0W1mre", "\nShader CINESHADER LAVA\n@edankwan (shadertoy.com/view/3sySRK)"),
        factoryCreditsEntry("aaaSDR6q", "\nShader CLOUDS 2D\n@murieron (shadertoy.com/view/WdXBW4)"),
        factoryCreditsEntry("5RDIFbcJ", "\nShader COLORS EMBODY\n@Peace (shadertoy.com/view/lffyWf)"),
        factoryCreditsEntry("ehqFeJ3X", "\nShader CUBULAR\n@ProfessorPixels (shadertoy.com/view/M3tGWr)"),
        factoryCreditsEntry("2glz4V6F", "\nShader DISCOTEQ 2\n@supah (shadertoy.com/view/DtXfDr)"),
        factoryCreditsEntry("o9fJZ0fn", "\nShader DIVE TO CLOUD\n@lise (shadertoy.com/view/ll3SWl)"),
        factoryCreditsEntry("hVL0jFKT", "\nShader FLAME\n@anatole_duprat (shadertoy.com/view/MdX3zr)"),
        factoryCreditsEntry("AIWL1gM4", "\nShader GRID SPACE\n@Peace (shadertoy.com/view/lffyWf)"),
        factoryCreditsEntry("0jyLdQ6w", "\nShader LIGHTING WITH GLOW\n@Peace (shadertoy.com/view/MclyWl)"),
        factoryCreditsEntry("rmwl74YR", "\nShader MONSTER\n@butadiene (shadertoy.com/view/WtKSzt)"),
        factoryCreditsEntry("ogXsppv1", "\nShader OCTAGRAMS\n@whisky_shusuky (shadertoy.com/view/tlVGDt)"),
        factoryCreditsEntry("zGNI2nXl", "\nShader PHANTOM STAR\n@kasari39 (shadertoy.com/view/ttKGDt)"),
        factoryCreditsEntry("YrA0aotr", "\nShader SINCOS 3D\n@ChunderFPV (shadertoy.com/view/XfXGz4)"),
        factoryCreditsEntry("WaV9TrLR", "\nShader STAR NEST\n@Kali (shadertoy.com/view/XlfGRj)"),
        factoryCreditsEntry("sP4kWe3m", "\nShader UI NOISE HALO\n@magician0809 (shadertoy.com/view/3tBGRm)"),
        factoryCreditsEntry("zTzYxKu5", "\nShader WARP\n@iq (shadertoy.com/view/lsl3RH)"),
        factoryCreditsEntry("CHnh0XGa", "\nShader WARP SPEED 2\n@Dave_Hoskins (shadertoy.com/view/4tjSDt)"),
        factoryCreditsEntry("GHNnOTK1", "\nShader WHIRLPOOL\n@nayk (shadertoy.com/view/lcscDj)"),
        factoryCreditsEntry("Ihb80AdW", "\nShader ABBERATION\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("OlklAeQ1", "\nShader CRT\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("ZT7Suy4K", "\nShader EMBOSS\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("aVEfOzcV", "\nShader LED\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("FwKDGXOK", "\nShader MAGNIFY\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("zfF2QBQb", "\nShader MOSAIC\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("5VHqgJRb", "\nShader POSTERIZATION\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("xHGSKCnB", "\nShader REVERT\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("SqtaHVR2", "\nShader RIPPLE\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("CLd7vpDl", "\nShader SCANLINES\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("pt2ZUbes", "\nShader SHOCK_WAVE\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("nQJhn2mH", "\nShader SKETCH\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("wRA1P0cI", "\nShader THERMAL\n@xygthop3 (github.com/xygthop3/Free-Shaders)"),
        factoryCreditsEntry("TYwCSS3l", "\nShader WAVE\n@xygthop3 (github.com/xygthop3/Free-Shaders)" ),
        {
          name: "credits_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenGraphicsSettingsMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenSettingsMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "graphics_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Graphics",
          },
        },
      },
      content: new Array(Struct, [
        /*
        {
          name: "graphics_menu-button-input-entry_auto-resize",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Auto-resize",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.auto-resize")
                Visu.settings.setValue("visu.graphics.auto-resize", !value).save()
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.auto-resize")
                Visu.settings.setValue("visu.graphics.auto-resize", !value).save()
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.auto-resize") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-spin-select-entry_resolution",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "Resolution" },
            previous: { 
              callback: function() { },
            },
            preview: {
              label: {
                text: ""
              },
              updateCustom: function() { this.label.text = $"{GuiWidth()}x{GuiHeight()}" },
            },
            next: { 
              callback: function() { },
            },
          },
        },
        */
        {
          name: "graphics_menu-button-input-entry_fullscreen",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Fullscreen",
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                var fullscreen = controller.displayService.getFullscreen()
                controller.displayService.setFullscreen(!fullscreen)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "" },
              callback: function() {
                var controller = Beans.get(BeanVisuController)
                var fullscreen = controller.displayService.getFullscreen()
                controller.displayService.setFullscreen(!fullscreen)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Beans.get(BeanVisuController).displayService.getFullscreen() ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-button-input-entry_bkg-shaders",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Background shaders",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.bkg-shaders")
                Visu.settings.setValue("visu.graphics.bkg-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.bkg-shaders")
                Visu.settings.setValue("visu.graphics.bkg-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.bkg-shaders") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-button-input-entry_main-shaders",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Grid shaders",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.main-shaders")
                Visu.settings.setValue("visu.graphics.main-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.main-shaders")
                Visu.settings.setValue("visu.graphics.main-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.main-shaders") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-button-input-entry_combined-shaders",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Combined shaders",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.combined-shaders")
                Visu.settings.setValue("visu.graphics.combined-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.combined-shaders")
                Visu.settings.setValue("visu.graphics.combined-shaders", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.combined-shaders") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-spin-select-entry_shaders-limit",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "Max simultaneous shaders" },
            previous: { 
              callback: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit") - 1), 1, DEFAULT_SHADER_PIPELINE_LIMIT)
                Visu.settings.setValue("visu.graphics.shaders-limit", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
              var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit")), 1, DEFAULT_SHADER_PIPELINE_LIMIT)
                if (value == 1) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: string(int64(Visu.settings.getValue("visu.graphics.shaders-limit")))
              },
              updateCustom: function() { 
                var value = Visu.settings.getValue("visu.graphics.shaders-limit")
                this.label.text = string(int64(value))
              },
            },
            next: { 
              callback: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit") + 1), 1, DEFAULT_SHADER_PIPELINE_LIMIT)
                Visu.settings.setValue("visu.graphics.shaders-limit", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit")), 1, DEFAULT_SHADER_PIPELINE_LIMIT)
                if (value == DEFAULT_SHADER_PIPELINE_LIMIT) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
          },
        },
        {
          name: "graphics_menu-spin-select-entry_shader-quality",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "Shaders quality" },
            previous: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.graphics.shader-quality") - 0.1, 0.1, 1.0)
                Visu.settings.setValue("visu.graphics.shader-quality", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.graphics.shader-quality"), 0.1, 1.0)
                if (value == 0.1) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: string(int64(round(Visu.settings.getValue("visu.graphics.shader-quality") * 10)))
              },
              updateCustom: function() {
                var value = round(Visu.settings.getValue("visu.graphics.shader-quality") * 10)
                this.label.text = $"{string(int64(value * 10))}%"
              },
            },
            next: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.graphics.shader-quality") + 0.1, 0.1, 1.0)
                Visu.settings.setValue("visu.graphics.shader-quality", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.graphics.shader-quality"), 0.1, 1.0)
                if (value == 1.0) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
          },
        },
        {
          name: "graphics_menu-button-input-entry_bkt-glitch",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "BKT Glitch",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.bkt-glitch")
                Visu.settings.setValue("visu.graphics.bkt-glitch", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.bkt-glitch")
                Visu.settings.setValue("visu.graphics.bkt-glitch", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.bkt-glitch") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-button-input-entry_particle",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Particle",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.particle")
                Visu.settings.setValue("visu.graphics.particle", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.particle")
                Visu.settings.setValue("visu.graphics.particle", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.particle") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "graphics_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenAudioSettingsMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenSettingsMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "audio_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Audio",
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "audio_menu-spin-select-entry_ost-volume",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "OST volume" },
            previous: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.ost-volume") - 0.1, 0.0, 1.0)
                Visu.settings.setValue("visu.audio.ost-volume", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.ost-volume"), 0.0, 1.0)
                if (value == 0.0) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: "N/A"
              },
              updateCustom: function() {
                var value = round(Visu.settings.getValue("visu.audio.ost-volume") * 10)
                this.label.text = $"{string(int64(value * 10))}%"
              },
            },
            next: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.ost-volume") + 0.1, 0.0, 1.0)
                Visu.settings.setValue("visu.audio.ost-volume", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.ost-volume"), 0.0, 1.0)
                if (value == 1.0) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
          },
        },
        {
          name: "audio_menu-spin-select-entry_sfx-volume",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "SFX volume" },
            previous: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.sfx-volume") - 0.1, 0.0, 1.0)
                Visu.settings.setValue("visu.audio.sfx-volume", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.sfx-volume"), 0.0, 1.0)
                if (value == 0.0) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: "N/A"
              },
              updateCustom: function() {
                var value = round(Visu.settings.getValue("visu.audio.sfx-volume") * 10)
                this.label.text = $"{string(int64(value * 10))}%"
              },
            },
            next: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.sfx-volume") + 0.1, 0.0, 1.0)
                Visu.settings.setValue("visu.audio.sfx-volume", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(Visu.settings.getValue("visu.audio.sfx-volume"), 0.0, 1.0)
                if (value == 1.0) {
                  this.sprite.setAlpha(0.15)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
          },
        },
        {
          name: "audio_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenInterfaceSettingsMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenSettingsMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "interface_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Interface",
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "interface_menu-button-input-entry_render-hud",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Render HUD",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.interface.render-hud")
                Visu.settings.setValue("visu.interface.render-hud", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.interface.render-hud")
                Visu.settings.setValue("visu.interface.render-hud", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.interface.render-hud") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        /*
        {
          name: "interface_menu-spin-select-entry_hud-posituion",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "HUD position" },
            previous: { 
              callback: function() {

              },
            },
            preview: {
              label: {
                text: "Bottom left"
              },
              updateCustom: function() {

              },
            },
            next: { 
              callback: function() {

              },
            },
          },
        },
        */
        {
          name: "interface_menu-button-input-entry_player-hint",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Off-screen player hints",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.interface.player-hint")
                Visu.settings.setValue("visu.interface.player-hint", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.interface.player-hint")
                Visu.settings.setValue("visu.interface.player-hint", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.interface.player-hint") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "interface_menu-spin-select-entry_scale-gui",
          template: VisuComponents.get("menu-spin-select-entry"),
          layout: VisuLayouts.get("menu-spin-select-entry"),
          config: { 
            layout: { type: UILayoutType.VERTICAL },
            label: { text: "GUI scale" },
            previous: { 
              callback: function() {
                var scaleIntent = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
                var value = clamp(scaleIntent - 0.05, 0.5, 4.0)
                Struct.set(this.context, "scaleIntent", value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
            },
            preview: {
              label: {
                text: "N/A"
              },
              updateCustom: function() {
                var scaleIntent = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
                Struct.set(this.context, "scaleIntent", scaleIntent)
                this.label.text = $"{string(floor(scaleIntent * 100))}%"
              },
            },
            next: { 
              callback: function() {
                var scaleIntent = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
                var value = clamp(scaleIntent + 0.05, 0.5, 4.0)
                Struct.set(this.context, "scaleIntent", value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
            },
          },
        },
        {
          name: "interface_menu-button-entry_apply",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Apply GUI Scale",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")

                var scaleIntent = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
                Visu.settings.setValue("visu.interface.scale", scaleIntent).save()
                Beans.get(BeanVisuController).displayService.scale = scaleIntent
                Beans.get(BeanVisuController).displayService.state = "required"
                Beans.get(BeanVisuController).displayService.timer.reset().finish()

                Beans.get(BeanVisuController).visuRenderer.fadeTimer.reset().time = -0.33
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "interface_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
                Struct.set(this.context, "scaleIntent", Visu.settings.getValue("visu.interface.scale"))
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenControlsMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenSettingsMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "controls_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Controls",
          },
        },
      },
      content: new Array(Struct, [
        {
          name: $"settings_menu-keyboard-key-entry_up",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("up", "Up"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_down",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("down", "Down"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_left",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("left", "Left"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_right",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("right", "Right"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_action",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("action", "Shoot"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_bomb",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("bomb", "Use bomb"),
        },
        {
          name: $"settings_menu-keyboard-key-entry_focus",
          template: VisuComponents.get("menu-keyboard-key-entry"),
          layout: VisuLayouts.get("menu-keyboard-key-entry"),
          config: factoryPlayerKeyboardKeyEntryConfig("focus", "Focus mode"),
        },
        {
          name: "settings_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryOpenDeveloperMenuEvent = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        back: this.factoryOpenSettingsMenuEvent, 
      }
    )

    var event = new Event("open").setData({
      back: config.back,
      layout: Beans.get(BeanVisuController).visuRenderer.layout,
      title: {
        name: "controls_title",
        template: VisuComponents.get("menu-title"),
        layout: VisuLayouts.get("menu-title"),
        config: {
          label: { 
            text: "Developer",
          },
        },
      },
      content: new Array(Struct, [
        {
          name: "developer_menu-button-input-entry_debug",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Debug mode",
              callback: new BindIntent(function() {
                var value = !is_debug_overlay_open()
                Visu.settings.setValue("visu.debug", value).save()
                Core.debugOverlay(value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = !is_debug_overlay_open()
                Visu.settings.setValue("visu.debug", value).save()
                Core.debugOverlay(value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = is_debug_overlay_open() ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_debug-render-entities-mask",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Render debug masks",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.debug.render-entities-mask")
                Visu.settings.setValue("visu.debug.render-entities-mask", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.debug.render-entities-mask")
                Visu.settings.setValue("visu.debug.render-entities-mask", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.debug.render-entities-mask") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_debug-render-debug-chunks",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Render debug chunks",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.debug.render-debug-chunks")
                Visu.settings.setValue("visu.debug.render-debug-chunks", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.debug.render-debug-chunks")
                Visu.settings.setValue("visu.debug.render-debug-chunks", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.debug.render-debug-chunks") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_debug-render-surfaces",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Render debug surfaces",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.debug.render-surfaces")
                Visu.settings.setValue("visu.debug.render-surfaces", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.debug.render-surfaces")
                Visu.settings.setValue("visu.debug.render-surfaces", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.debug.render-surfaces") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_god-mode",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "God mode",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.god-mode")
                Visu.settings.setValue("visu.god-mode", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.god-mode")
                Visu.settings.setValue("visu.god-mode", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.god-mode") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_editor",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Editor",
              callback: function() {
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
                var value = false
                
                if (Optional.is(Beans.get(BeanVisuEditorIO))) {
                  Beans.kill(BeanVisuEditorIO)
                  value = false
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorIO()))
                  value = true
                }

                if (Optional.is(Beans.get(BeanVisuEditorController))) {
                  Beans.kill(BeanVisuEditorController)
                  value = false
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorController()))
                  value = true
                  var editor = Beans.get(BeanVisuEditorController)
                  if (Optional.is(editor)) {
                    editor.send(new Event("open"))
                  }
                }

                Visu.settings.setValue("visu.editor.enable", value).save()
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "" },
              updateCustom: function() {
                this.label.text = Optional.is(Beans.get(BeanVisuEditorController)) ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              callback: function() {
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
                var value = false

                if (Optional.is(Beans.get(BeanVisuEditorIO))) {
                  Beans.kill(BeanVisuEditorIO)
                  value = false
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorIO()))
                  value = true
                }

                if (Optional.is(Beans.get(BeanVisuEditorController))) {
                  Beans.kill(BeanVisuEditorController)
                  value = false
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorController()))
                  value = true
                  var editor = Beans.get(BeanVisuEditorController)
                  if (Optional.is(editor)) {
                    editor.send(new Event("open"))
                  }
                }

                Visu.settings.setValue("visu.editor.enable", value).save()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_ws",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "WebSocket",
              callback: new BindIntent(function() {
                var value = false
                var controller = Beans.get(BeanVisuController)
                if (controller.server.isRunning()) {
                  value = false
                  controller.server.free()
                } else {
                  value = true
                  controller.server.run()
                }

                Visu.settings.setValue("visu.server.enable", value).save()
                controller.sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = false
                var controller = Beans.get(BeanVisuController)
                if (controller.server.isRunning()) {
                  value = false
                  controller.server.free()
                } else {
                  value = true
                  controller.server.run()
                }

                Visu.settings.setValue("visu.server.enable", value).save()
                controller.sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Beans.get(BeanVisuController).server.isRunning() ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_optimalization-iterate-entities-once",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Iterate entities once",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.optimalization.iterate-entities-once")
                Visu.settings.setValue("visu.optimalization.iterate-entities-once", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.optimalization.iterate-entities-once")
                Visu.settings.setValue("visu.optimalization.iterate-entities-once", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.optimalization.iterate-entities-once") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-input-entry_optimalization-sort-entities-by-txgroup",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Sort entities by txgroup",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.optimalization.sort-entities-by-txgroup")
                Visu.settings.setValue("visu.optimalization.sort-entities-by-txgroup", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.optimalization.sort-entities-by-txgroup")
                Visu.settings.setValue("visu.optimalization.sort-entities-by-txgroup", !value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.optimalization.sort-entities-by-txgroup") ? "Enabled" : "Disabled"
                this.label.alpha = this.label.text == "Enabled" ? 1.0 : 0.3
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "developer_menu-button-entry_restart",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Restart game",
              callback: new BindIntent(function() {
                Scene.open("scene_visu")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        },
        {
          name: "developer_menu-button-entry_back",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Back",
              callback: new BindIntent(function() {
                Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
                Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VETheme.color.deny,
            },
          }
        }
      ])
    })

    return event
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "visu-menu",
        //x: function() { return this.context.x() + (this.context.width() - this.width()) / 2.0 },
        x: function() { return this.context.x() },
        y: function() { return this.context.y() },
        width: function() { return this.context.width() },
        height: function() { return this.context.height() },
        nodes: {
          "visu-menu.title": {
            name: "visu-menu.title",
            x: function() { return this.context.x() },
            y: function() { return this.context.y() },
            width: function() { return this.context.width() },
            height: function() { return min(this.context.height() * 0.16, 100) },
          },
          "visu-menu.content": {
            name: "visu-menu.content",
            x: function() { return this.context.x() + ((this.context.width() - this.width()) / 2.0) },
            y: function() { return Struct.get(this.context.nodes, "visu-menu.title").bottom() 
              + this.margin.top 
              + ((this._height(this.context, this.margin) - this.height()) / 2.0)
            },
            width: function() { return max(this.context.width() * 0.4, 540) },
            viewHeight: 0.0,
            height: function() {
              this.viewHeight = clamp(this.viewHeight, 0.0, this._height(this.context, this.margin))
              return this.viewHeight
            },
            _height: function(context, margin) { 
              return context.height() 
                - Struct.get(context.nodes, "visu-menu.title").height()
                - Struct.get(context.nodes, "visu-menu.footer").height()
                - margin.top
                - margin.bottom
            },
            //margin: { top: 24, bottom: 24 },
            margin: { top: 0, bottom: 0 },
          },
          "visu-menu.footer": {
            name: "visu-menu.footer",
            x: function() { return this.context.x() },
            y: function() { return this.context.y() + this.context.height() - this.height() },
            width: function() { return this.context.width() },
            height: function() { return min(this.context.height() * 0.16, 100) },
          },
        }
      },
      parent
    )
  }

  ///@private
  ///@param {Struct} title
  ///@param {Array<Struct>} content
  ///@param {?UIlayout} [parent]
  ///@return {Map<String, UI>}
  factoryContainers = function(title, content, parent = null) {
    static factoryTitle = function(name, controller, layout, title) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        state: new Map(String, any, {
          "background-alpha": 0.5,
          "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          "title": title,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.05,
        }),
        updateArea: Callable
          .run(UIUtil.updateAreaTemplates
          .get("applyLayout")),
        renderDefault: new BindIntent(Callable
          .run(UIUtil.renderTemplates
          .get("renderDefault"))),
        render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DeltaTime.apply(this.state.get("uiAlphaFactor")), 0.0, 1.0)
          this.state.set("uiAlpha", uiAlpha)
          if (this.surface == null) {
            this.surface = new Surface(this.area.getWidth(), this.area.getHeight())
          }

          this.surface.update(this.area.getWidth(), this.area.getHeight())
          //if (!this.surfaceTick.get() && !this.surface.updated) {
          //  this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          //  return
          //}
          
          GPU.set.surface(this.surface)
          var color = this.state.get("background-color")
          if (Core.isType(color, GMColor)) {
            GPU.render.clear(color, uiAlpha * this.state.getIfType("background-alpha", Number, 1.0))
          }
          
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          DeltaTime.deltaTime = delta
  
          GPU.reset.surface()
          this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          //this.renderDefault()
        },
        onInit: function() {
          this.items.clear()
          this.addUIComponents(new Array(UIComponent, [ 
            new UIComponent(this.state.get("title"))
          ]),
          new UILayout({
            area: this.area,
            width: function() { return this.area.getWidth() },
            height: function() { return this.area.getHeight() },
          }))
        },
      })
    }

    static factoryContent = function(name, controller, layout, content) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        selectedIndex: 0,
        previousIndex: 0,
        state: new Map(String, any, {
          "background-alpha": 0.33,
          "background-color": ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
          "content": content,
          "isKeyboardEvent": true,
          "initPress": false,
          "remapKey": null,
          "remapKeyRestored": 2,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.05,
          "breath": new Timer(2 * pi, { loop: Infinity, amount: FRAME_MS * 8 }),
          "keyboard": new Keyboard({
            up: KeyboardKeyType.ARROW_UP,
            down: KeyboardKeyType.ARROW_DOWN,
            left: KeyboardKeyType.ARROW_LEFT,
            right: KeyboardKeyType.ARROW_RIGHT,
            space: KeyboardKeyType.SPACE,
            enter: KeyboardKeyType.ENTER,
          }),
          "keyUpdater": new PrioritizedPressedKeyUpdater(),
          "playerKeyUpdater": new PrioritizedPressedKeyUpdater(),
        }),
        scrollbarY: { align: HAlign.RIGHT },
        updateArea: Callable
          .run(UIUtil.updateAreaTemplates
          .get("scrollableY")),
        updateVerticalSelectedIndex: new BindIntent(Callable
          .run(UIUtil.templates
          .get("updateVerticalSelectedIndex"))),
        updateCustom: function() {
          this.layout.viewHeight = this.fetchViewHeight()
          this.controller.remapKey = this.state.get("remapKey")
          if (Optional.is(this.controller.remapKey)) {
            this.state.set("remapKeyRestored", 2)
            return
          } 

          var remapKeyRestored = this.state.get("remapKeyRestored")
          if (remapKeyRestored > 0) {
            this.state.set("remapKeyRestored", remapKeyRestored - 1)
            return
          }

          if (this.state.get("initPress")) {
            this.state.set("initPress", false)
            var pointer = Struct.inject(this, "selectedIndex", 0)
            pointer = Core.isType(pointer, Number) ? clamp(pointer, 0, this.collection.size() - 1) : 0
            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          var keyboard = this.state.get("keyboard")
          var playerKeyboard = Beans.get(BeanVisuIO).keyboards.get("player")
          //this.state.get("keyUpdater")
          //  .updateKeyboard(keyboard.update())
          keyboard.update()
          this.state.get("playerKeyUpdater")
            .bindKeyboardKeys(playerKeyboard)
            .updateKeyboard(playerKeyboard.update())
          if (playerKeyboard.keys.up.pressed || keyboard.keys.up.pressed) {
            var pointer = Struct.inject(this, "selectedIndex", 0)
            if (!Core.isType(pointer, Number)) {
              pointer = 0
            } else {
              pointer = clamp(
                (pointer == 0 ? this.collection.size() - 1 : pointer - 1), 
                0, 
                (this.collection.size() -1 >= 0 ? this.collection.size() - 1 : 0)
              )
            }

            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          if (playerKeyboard.keys.down.pressed || keyboard.keys.down.pressed) {
            var pointer = Struct.inject(this, "selectedIndex", 0)
            if (!Core.isType(pointer, Number)) {
              pointer = 0
            } else {
              pointer = clamp(
                (pointer == this.collection.size() - 1 ? 0 : pointer + 1), 
                0, 
                (this.collection.size() - 1 >= 0 ? this.collection.size() - 1 : 0)
              )
            }
            
            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          if (playerKeyboard.keys.left.pressed || keyboard.keys.left.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              }

              switch (type) {
                case "menu-button-entry":
                  break
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  var previous = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "previous")
                  
                  if (Optional.is(previous)) {
                    previous.callback()
                  }
                  break
              }
            }
          }

          if (playerKeyboard.keys.right.pressed || keyboard.keys.right.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              }

              switch (type) {
                case "menu-button-entry":
                  break
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  var next = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "next")
                  
                  if (Optional.is(next)) {
                    next.callback()
                  }
                  break
              }
            }
          }
          
          if (playerKeyboard.keys.action.pressed
            || keyboard.keys.space.pressed
            || keyboard.keys.enter.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              } else if (String.contains(component.name, "menu-keyboard-key-entry")) {
                type = "menu-keyboard-key-entry"
              }

              switch (type) {
                case "menu-button-entry":
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  break
                case "menu-keyboard-key-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
              }
            }
          }

          var component = this.collection.findByIndex(Struct.get(this, "selectedIndex"))
          if (Optional.is(component)) {
            if (this.selectedIndex != this.previousIndex) {
              Beans.get(BeanVisuController).sfxService.play("menu-move-cursor")
            }
            this.previousIndex = this.selectedIndex

            this.state.get("breath").update()
            component.items.forEach(function(item, index, context) {
              // horizontal offset
              var itemX = item.area.getX();
              var itemWidth = item.area.getWidth()
              var offsetX = abs(context.offset.x)
              var areaWidth = context.area.getWidth()
              var itemRight = itemX + itemWidth
              if (itemX < offsetX || itemRight > offsetX + areaWidth) {
                var newX = (itemX < offsetX) ? itemX : itemRight - areaWidth
                context.offset.x = -1 * clamp(newX, 0.0, abs(context.offsetMax.x))
              }

              // vertical offset
              var itemY = item.area.getY();
              var itemHeight = item.area.getHeight()
              var offsetY = abs(context.offset.y)
              var areaHeight = context.area.getHeight()
              var itemBottom = itemY + itemHeight
              if (itemY < offsetY || itemBottom > offsetY + areaHeight) {
                var newY = (itemY < offsetY) ? itemY : itemBottom - areaHeight
                context.offset.y = -1 * clamp(newY, 0.0, abs(context.offsetMax.y))
              }

              item.backgroundAlpha = ((cos(this.state.get("breath").time) + 2.0) / 3.0) + 0.3
            }, this)
          }

          this.collection.components.forEach(function(component, iterator, pointer) {
            if (component.index != pointer) {
              component.items.forEach(function(item) {
                item.backgroundAlpha = 0.75
              })
            }
          }, Struct.get(this, "selectedIndex"))
        },
        renderItem: Callable
          .run(UIUtil.renderTemplates
          .get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable
          .run(UIUtil.renderTemplates
          .get("renderDefaultScrollableBlend"))),
        renderDefault: function() {
          this.updateVerticalSelectedIndex(VISU_MENU_ENTRY_HEIGHT)
          this.renderDefaultScrollable()
        },
        renderSurface: function() {
          var color = this.state.getIfType("background-color", GMColor, c_white)
          var alpha = this.state.getIfType("background-alpha", Number, 0.0)
          GPU.render.clear(color, alpha * this.state.get("uiAlpha"))
          
          var areaX = this.area.x
          var areaY = this.area.y
          //var delta = DeltaTime.deltaTime
          //DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          //DeltaTime.deltaTime = delta
        },
        render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DeltaTime.apply(this.state.get("uiAlphaFactor")), 0.0, 1.0)
          this.state.set("uiAlpha", uiAlpha)

          this.updateVerticalSelectedIndex(VISU_MENU_ENTRY_HEIGHT)
          if (!Optional.is(this.surface)) {
            this.surface = new Surface()
          }
  
          this.surface.update(this.area.getWidth(), this.area.getHeight())
          //if (!this.surfaceTick.get() && !this.surface.updated) {
          //  this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          //  if (this.enableScrollbarY) {
          //    this.scrollbarY.render(this)
          //  }
          //  return
          //}
  
          this.surface.renderOn(this.renderSurface)
          this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          if (this.enableScrollbarY) {
            this.scrollbarY.render(this)
          }
        },
        onMousePressedLeft: Callable
          .run(UIUtil.mouseEventTemplates
          .get("onMouseScrollbarY")),
        onMouseWheelUp: Callable
          .run(UIUtil.mouseEventTemplates
          .get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable
          .run(UIUtil.mouseEventTemplates
          .get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          this.collection = new UICollection(this, { layout: this.layout })
          this.state.get("content").forEach(function(template, index, context) {
            context.collection.add(new UIComponent(template))
          }, this)

          if (this.state.get("content").size() > 0) {
            Struct.set(this, "selectedIndex", 0)
            this.state.set("isKeyboardEvent", true)
            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, Struct.inject(this, "selectedIndex", 0))
          }

          this.state.set("initPress", true)
          this.scrollbarY.render = method(this.scrollbarY, function() { })
        },
      })
    }

    this.layout = this.factoryLayout(parent)
    this.containers
      .clear()
      .set(
        "container_visu-menu.title", 
        factoryTitle(
          "container_visu-menu.title",
          this,
          Struct.get(this.layout.nodes, "visu-menu.title"),
          title
        ))
      .set(
        "container_visu-menu.content", 
        factoryContent(
          "container_visu-menu.content",
          this,
          Struct.get(this.layout.nodes, "visu-menu.content"),
          content
        ))
      .set(
        "container_visu-menu.footer", 
        factoryTitle(
          "container_visu-menu.footer",
          this,
          Struct.get(this.layout.nodes, "visu-menu.footer"),
          {
            name: "visu-menu.footer",
            template: VisuComponents.get("menu-title"),
            layout: VisuLayouts.get("menu-title"),
            config: {
              label: { 
                //text: $"github.com/Alkapivo | v.{GM_build_date} | {date_datetime_string(GM_build_date)}",
                text: $"v{Visu.version()} | Baron's Keep 2025 (c)\n\ngithub.com/Alkapivo/visu-project\n",
                updateCustom: function() {
                  var serverVersion = Visu.serverVersion()
                  if (!Optional.is(serverVersion)) {
                    return this
                  }

                  var version = Visu.version()
                  this.label.text = version == serverVersion 
                    ? $"v{version} | Baron's Keep 2025 (c)\n\ngithub.com/Alkapivo/visu-project\n"
                    : $"v{version} (NEW VERSION AVAILABLE: v{serverVersion}) | Baron's Keep 2025 (c)\n\ngithub.com/Alkapivo/visu-project\n"

                },
                font: "font_kodeo_mono_12_bold",
                onMouseReleasedLeft: function() {
                  url_open("https://github.com/Alkapivo/visu-project")
                }
              },
            },
          }
        ))

    return this.containers
  }
  
  ///@private
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      var editor = Beans.get(BeanVisuEditorController)
      if (Optional.is(editor) && editor.renderUI) {
        return
      }
      
      this.dispatcher.execute(new Event("close"))
      this.containers = this.factoryContainers(
        event.data.title, 
        event.data.content, 
        event.data.layout
      )
      this.back = Core.isType(Struct.get(event.data, "back"), Callable) 
        ? event.data.back 
        : null
      this.backData = Struct.getDefault(event.data, "backData", null)

      var blur = Beans.get(BeanVisuController).visuRenderer.blur
      blur.reset()
      blur.value = 0
      blur.target = 24
      
      this.containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, Beans.get(BeanVisuController).uiService)
    },
    "close": function(event) {
      if (Struct.getDefault(event.data, "fade", false)) {
        var blur = Beans.get(BeanVisuController).visuRenderer.blur
        blur.reset()
        blur.value = 24
        blur.target = 0
        this.containers.forEach(function (container) {
          Struct.set(container, "updateCustom", method(container, function() {
            this.state.set("uiAlphaFactor", -0.05)
            var blur = Beans.get(BeanVisuController).visuRenderer.blur
            //var blurFactor = Beans.get(BeanVisuController).trackService.isTrackLoaded() ? 0.16 : 0.5
            //blur.value = Math.transformNumber(blur.value, 0.0, DeltaTime.apply(blurFactor))
            if (blur.value == 0.0) {
              this.controller.send(new Event("close"))
            }
          }))
          Struct.set(container, "onMousePressedLeft", method(container, function(event) { }))
          Struct.set(container, "onMouseWheelUp", method(container, function(event) { }))
          Struct.set(container, "onMouseWheelDown", method(container, function(event) { }))
        })
        return
      }

      this.back = null
      this.backData = null
      this.containers.forEach(function (container, key, uiService) {
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuController).uiService).clear()
    },
    "back": function(event) {
      if (Optional.is(this.back)) {
        this.dispatcher.execute(this.back(this.backData))
        return
      }
      this.dispatcher.execute(new Event("close", { fade: true }))
    },
    "game-end": function(event) {
      game_end()
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETrackControl}
  update = function() { 
    this.dispatcher.update()
    return this
  }
}
