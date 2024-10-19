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
                        manifest: event.data.path,
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
        },
        {
          name: "main-menu_menu-button-entry_settings",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Settings",
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
      ])
    })

    if (Beans.get(BeanVisuController).trackService.isTrackLoaded()
      && Beans.get(BeanVisuController).fsm.getStateName() != "game-over") {
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
      }, 0)
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
          },
        }
      })
    }

    return event
  }

  ///@param {?Struct} [_config]
  ///@return {Event}
  factoryConfirmationDialog = function(_config = null) {
    var config = Struct.appendUnique(
      _config,
      {
        accept: function() { return new Event("game-end") },
        acceptLabel: "Yes",
        decline: this.factoryOpenMainMenuEvent, 
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
          name: "confirmation-dialog_menu-button-decline",
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
          name: "settings_menu-button-input-entry_god-mode",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "God mode",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.god-mode")
                Visu.settings.setValue("visu.god-mode", !value)
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
                Visu.settings.setValue("visu.god-mode", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.god-mode") ? "Enabled" : "Disabled"
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            }
          }
        },
        {
          name: "settings_menu-button-input-entry_editor",
          template: VisuComponents.get("menu-button-input-entry"),
          layout: VisuLayouts.get("menu-button-input-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Editor",
              callback: function() {
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
                
                if (Optional.is(Beans.get(BeanVisuEditorIO))) {
                  Beans.kill(BeanVisuEditorIO)
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorIO()))
                }

                if (Optional.is(Beans.get(BeanVisuEditorController))) {
                  Beans.kill(BeanVisuEditorController)
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorController()))

                  var editor = Beans.get(BeanVisuEditorController)
                  if (Optional.is(editor)) {
                    editor.send(new Event("open"))
                  }
                }
              },
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "" },
              updateCustom: function() {
                this.label.text = Optional.is(Beans.get(BeanVisuEditorController)) ? "Enabled" : "Disabled"
              },
              callback: function() {
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
                
                if (Optional.is(Beans.get(BeanVisuEditorIO))) {
                  Beans.kill(BeanVisuEditorIO)
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorIO, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorIO()))
                }

                if (Optional.is(Beans.get(BeanVisuEditorController))) {
                  Beans.kill(BeanVisuEditorController)
                } else {
                  Beans.add(Beans.factory(BeanVisuEditorController, GMServiceInstance, 
                    Beans.get(BeanVisuController).layerId, new VisuEditorController()))

                  var editor = Beans.get(BeanVisuEditorController)
                  if (Optional.is(editor)) {
                    editor.send(new Event("open"))
                  }
                }
              },
            }
          }
        },
        {
          name: "settings_menu-button-entry_restart",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: "Restart",
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
                Visu.settings.setValue("visu.graphics.auto-resize", !value)
              }),
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            input: {
              label: { text: "Enabled" },
              callback: function() {
                var value = Visu.settings.getValue("visu.graphics.auto-resize")
                Visu.settings.setValue("visu.graphics.auto-resize", !value)
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.auto-resize") ? "Enabled" : "Disabled"
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
              text: "Main shaders",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.graphics.main-shaders")
                Visu.settings.setValue("visu.graphics.main-shaders", !value)
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
                Visu.settings.setValue("visu.graphics.main-shaders", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.main-shaders") ? "Enabled" : "Disabled"
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
                Visu.settings.setValue("visu.graphics.bkg-shaders", !value)
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
                Visu.settings.setValue("visu.graphics.bkg-shaders", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.bkg-shaders") ? "Enabled" : "Disabled"
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
            label: { text: "Shaders limit" },
            previous: { 
              callback: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit") - 1), 1, 32)
                Visu.settings.setValue("visu.graphics.shaders-limit", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit")), 1, 32)
                if (value == 1) {
                  this.sprite.setAlpha(0.0)
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
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit") + 1), 1, 32)
                Visu.settings.setValue("visu.graphics.shaders-limit", value).save()
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                var value = clamp(int64(Visu.settings.getValue("visu.graphics.shaders-limit")), 1, 32)
                if (value == 32) {
                  this.sprite.setAlpha(0.0)
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
                  this.sprite.setAlpha(0.0)
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
                this.label.text = string(int64(value))

                var editor = Beans.get(BeanVisuEditorController)
                if (Optional.is(editor)) {
                  editor.store.get("shader-quality").set(Visu.settings.getValue("visu.graphics.shader-quality"))
                }
                
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
                  this.sprite.setAlpha(0.0)
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
                Visu.settings.setValue("visu.graphics.bkt-glitch", !value)
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
                Visu.settings.setValue("visu.graphics.bkt-glitch", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.bkt-glitch") ? "Enabled" : "Disabled"
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
                Visu.settings.setValue("visu.graphics.particle", !value)
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
                Visu.settings.setValue("visu.graphics.particle", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.graphics.particle") ? "Enabled" : "Disabled"
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
                  this.sprite.setAlpha(0.0)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: string(int64(round(Visu.settings.getValue("visu.audio.ost-volume") * 10)))
              },
              updateCustom: function() {
                var value = round(Visu.settings.getValue("visu.audio.ost-volume") * 10)
                this.label.text = string(int64(value))
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
                  this.sprite.setAlpha(0.0)
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
                  this.sprite.setAlpha(0.0)
                } else {
                  this.sprite.setAlpha(1.0)
                }
              }
            },
            preview: {
              label: {
                text: string(int64(round(Visu.settings.getValue("visu.audio.sfx-volume") * 10)))
              },
              updateCustom: function() {
                var value = round(Visu.settings.getValue("visu.audio.sfx-volume") * 10)
                this.label.text = string(int64(value))
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
                  this.sprite.setAlpha(0.0)
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
                Visu.settings.setValue("visu.interface.render-hud", !value)
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
                Visu.settings.setValue("visu.interface.render-hud", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.interface.render-hud") ? "Enabled" : "Disabled"
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
              text: "Show player marker",
              callback: new BindIntent(function() {
                var value = Visu.settings.getValue("visu.interface.player-hint")
                Visu.settings.setValue("visu.interface.player-hint", !value)
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
                Visu.settings.setValue("visu.interface.player-hint", !value)
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
              updateCustom: function() {
                this.label.text = Visu.settings.getValue("visu.interface.player-hint") ? "Enabled" : "Disabled"
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
                var value = clamp(Visu.settings.getValue("visu.interface.scale") - 0.05, 0.5, 4.0)
                Visu.settings.setValue("visu.interface.scale", value).save()
                Beans.get(BeanVisuController).displayService.state = "required"
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
            },
            preview: {
              label: {
                text: string(Visu.settings.getValue("visu.interface.scale"))
              },
              updateCustom: function() {
                var value = Visu.settings.getValue("visu.interface.scale")
                Beans.get(BeanVisuController).displayService.scale = value
                this.label.text = string(value)
              },
            },
            next: { 
              callback: function() {
                var value = clamp(Visu.settings.getValue("visu.interface.scale") + 0.05, 0.5, 4.0)
                Visu.settings.setValue("visu.interface.scale", value).save()
                Beans.get(BeanVisuController).displayService.state = "required"
                Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              },
            },
          },
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
              }),
              callbackData: config.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
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
        x: function() { return this.context.x() + (this.context.width() - this.width()) / 2.0 },
        y: function() { return this.context.y() },
        width: function() { return max(this.context.width() * 0.4, 540) },
        height: function() { return this.context.height() },
        nodes: {
          "visu-menu.title": {
            name: "visu-menu.title",
            x: function() { return this.context.x() },
            y: function() { return this.context.y() },
            width: function() { return this.context.width() },
            height: function() { return min(this.context.height() * 0.21, 200) },
          },
          "visu-menu.content": {
            name: "visu-menu.content",
            x: function() { return this.context.x() },
            y: function() { return Struct.get(this.context.nodes, "visu-menu.title").bottom() },
            width: function() { return this.context.width() },
            height: function() { return this.context.height() 
              - Struct.get(this.context.nodes, "visu-menu.title").height()
              - Struct.get(this.context.nodes, "visu-menu.footer").height() },
          },
          "visu-menu.footer": {
            name: "visu-menu.footer",
            x: function() { return this.context.x() },
            y: function() { return Struct.get(this.context.nodes, "visu-menu.content").bottom() },
            width: function() { return this.context.width() },
            height: function() { return min(this.context.height() * 0.14, 100) },
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
    var factoryTitle = function(name, controller, layout, title) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        state: new Map(String, any, {
          "background-alpha": 0.33,
          "background-color": ColorUtil.fromHex(VETheme.color.header).toGMColor(),
          "title": title,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.1,
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
          var alpha = this.state.getDefault("background-alpha", 1.0)
          if (color != null) {
            draw_clear_alpha(color, uiAlpha * alpha)
          }
          
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.surfaceTick.delta
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

    var factoryContent = function(name, controller, layout, content) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        selectedIndex: 0,
        previousIndex: 0,
        state: new Map(String, any, {
          "background-alpha": 0.33,
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
          "content": content,
          "isKeyboardEvent": true,
          "remapKey": null,
          "remapKeyRestored": 2,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.1,
          "breath": new Timer(2 * pi, { loop: Infinity, amount: FRAME_MS * 8 }),
        }),
        scrollbarY: { align: HAlign.RIGHT },
        updateArea: Callable
          .run(UIUtil.updateAreaTemplates
          .get("scrollableY")),
        updateVerticalSelectedIndex: new BindIntent(Callable
          .run(UIUtil.templates
          .get("updateVerticalSelectedIndex"))),
        updateCustom: function() {
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

          var keyboard = Beans.get(BeanVisuIO).keyboards.get("player").update()
          if (keyboard_check_released(vk_up) || keyboard.keys.up.released) {
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

          if (keyboard_check_released(vk_down) || keyboard.keys.down.released) {
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

          if (keyboard_check_released(vk_left) || keyboard.keys.left.released) {
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

          if (keyboard_check_released(vk_right) || keyboard.keys.right.released) {
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
          
          if (keyboard_check_released(vk_enter) 
            || keyboard_check_released(vk_space) 
            || keyboard.keys.action.released) {
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
                  //Core.print("do nth")
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
          var color = this.state.get("background-color")
          var alpha = this.state.get("background-alpha")
          //GPU.render.clear(Core.isType(color, GMColor) 
          //  ? ColorUtil.fromGMColor(color) 
          //  : ColorUtil.BLACK_TRANSPARENT)
          draw_clear_alpha(
            (Core.isType(color, GMColor) ? color : c_black),
            (Core.isType(alpha, Number) ? alpha * this.state.get("uiAlpha") : 0.0)
          )
    
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          DeltaTime.deltaTime = delta
        },
        render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DeltaTime.apply(this.state.get("uiAlphaFactor")), 0.0, 1.0)
          this.state.set("uiAlpha", uiAlpha)

          this.updateVerticalSelectedIndex(VISU_MENU_ENTRY_HEIGHT)
          if (!Optional.is(this.surface)) {
            this.surface = new Surface()
          }
  
          this.surface.update(this.area.getWidth(), this.area.getHeight())
          if (!this.surfaceTick.get() && !this.surface.updated) {
            this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
            if (this.enableScrollbarY) {
              this.scrollbarY.render(this)
            }
            return
          }
  
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
                text: $"github.com/Alkapivo\n\nv.{GM_build_date} {date_datetime_string(GM_build_date)}",
                font: "font_kodeo_mono_12_bold",
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

      this.containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, Beans.get(BeanVisuController).uiService)
    },
    "close": function(event) {
      if (Struct.getDefault(event.data, "fade", false)) {
        this.containers.forEach(function (container) {
          Struct.set(container, "updateCustom", method(container, function() {
            this.state.set("uiAlphaFactor", -0.05)
            var blur = Beans.get(BeanVisuController).visuRenderer.blur
            blur.value = Math.transformNumber(blur.value, 0.0, 0.5)
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
