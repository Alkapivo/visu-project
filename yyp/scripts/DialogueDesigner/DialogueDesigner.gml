///@package io.alkapivo.core.service.dialogue-designer

///@enum
function _DDNodeType(): Enum() constructor {
  START = "start"
  MESSAGE = "show_message"
  EXECUTE = "execute"
}
global.__DDNodeType = new _DDNodeType()
#macro DDNodeType global.__DDNodeType


///@enum
function _DDActionType(): Enum() constructor {
  QUIT = "QUIT"
  LOAD_VISU_TRACK = "LOAD_VISU_TRACK"
}
global.__DDActionType = new _DDActionType()
#macro DDActionType global.__DDActionType


///@param {Array} array
function DDDialogue(array) constructor {

  ///@type {Struct}
  var json = Assert.isType(array.get(0), Struct)

  ///@type {DDNode}
  nodes = new Array(DDNode, GMArray.map(json.nodes, function(node) {
    switch (node.node_type) {
      case DDNodeType.START: return new DDNode(node)
      case DDNodeType.MESSAGE: return new DDMessage(node)
      case DDNodeType.EXECUTE: return new DDExecute(node)
      default: throw new Exception($"Unsupported type {node.node_type}")
    }
  }))

  ///@param {String} name
  ///@return {?DDNode}
  get = function(name) {
    return this.nodes.find(function(node, index, name) {
      return node.name == name
    }, name)
  }

  ///@type {DDNode}
  current = Assert.isType(this.get(this.nodes.find(function(node) {
    return node.type == DDNodeType.START
  }).next), DDNode)

  ///@return {DDDialogue}
  print = function() {
    Core.print("current", this.current.name, "text", this.current.getText("ENG"))
    return this
  }

  ///@param {?Number} [index]
  ///@return {DDDialogue}
  select = function(index = null) {
    if (Core.isType(index, Number)) {
      if (this.current.type == DDNodeType.MESSAGE
          && index < this.current.choices.size()) {
        var choice = this.current.choices.get(index)
        var node = this.get(choice.next)
        if (Core.isType(node, DDNode)) {
          this.current = node
        } else {
          Logger.error(BeanDialogueService, $"node does not exists. index: {index}, next: {this.current.next}")
        }
      }
    } else {
      if (this.current.type == DDNodeType.MESSAGE) {
        var node = this.get(this.current.next)
        if (Core.isType(node, DDNode)) {
          this.current = node
        } else {
          Logger.error(BeanDialogueService, $"node does not exists. index: {index}, next: {this.current.next}")
        }
      }
    }

    return this
  }
  
  ///@return {DDDialogue}
  update = function() {
    switch (this.current.type) {
      case DDNodeType.START:
        var node = this.get(this.current.next)
        if (Core.isType(node, DDNode)) {
          this.current = node
        }
        break
      case DDNodeType.MESSAGE:
        break
      case DDNodeType.EXECUTE:
        this.current.action.run()
        var node = this.get(this.current.next)
        if (Core.isType(node, DDNode)) {
          this.current = node
        }
        break
    }  
    
    return this
  }
}


///@param {Struct} json
function DDNode(json) constructor {

  ///@type {String}
  name = Assert.isType(json.node_name, String)

  ///@type {DDNodeType}
  type = Assert.isEnum(json.node_type, DDNodeType)

  ///@type {?String}
  next = Core.isType(Struct.get(json, "next"), String)
    ? json.next
    : null

  ///@type {String}
  title = Core.isType(Struct.get(json, "title"), String)
    ? json.title
    : ""

  ///@param {String} lang
  ///@return {String}
  getText = function(lang) {
    var map = Struct.get(this, "text")
    if (!Core.isType(map, Map)) {
      return ""
    }

    var text = map.get(lang)
    return Core.isType(text, String) ? text : ""
  }

  ///@param {String} lang
  ///@return {?Array<String>}
  getChoicesText = function(lang) {
    var choices = Struct.get(this, "choices")
    if (!Core.isType(choices, Array)) {
      return null
    }

    return choices.map(function(choice, index, lang) {
      return choice.getText(lang)
    }, lang, String)
  }
}


///@param {Struct} json
function DDExecute(json): DDNode(json) constructor {

  ///@type {DDAction}
  action = Assert.isType(
    new DDAction(JSON.parse(json.text)), 
    DDAction
  )
}


///@param {Struct} json
function DDMessage(json): DDNode(json) constructor {

  ///@type {Map<String, String>}
  text = new Map(String, String)
  if (Core.isType(Struct.get(json ,"text"), Struct)) {
    Struct.forEach(json.text, function(label, lang, text) {
      text.set(lang, label)
    }, this.text)
  }

  ///@type {Array<DDChoice>}
  choices = new Array(DDChoice)
  if (Core.isType(Struct.get(json, "choices"), GMArray)) {
    GMArray.forEach(json.choices, function(choice, index, choices) {
      choices.add(new DDChoice(choice))
    }, this.choices)
  }
}


///@param {Struct} json
function DDChoice(json) constructor {

  ///@type {?String}
  condition = json.is_condition ? Assert.isType(json.condition) : null

  ///@type {String}
  next = Assert.isType(json.next, String)

  ///@type {Map<String, String>}
  text = new Map(String, String)
  if (Core.isType(Struct.get(json, "text"), Struct)) {
    Struct.forEach(json.text, function(label, lang, text) {
      text.set(lang, label)
    }, this.text)
  }

  ///@param {String} lang
  ///@return {String}
  getText = function(lang) {
    var text = this.text.get(lang)
    return Core.isType(text, String) ? text : ""
  }
}


///@param {Struct} json
function DDAction(json) constructor {

  ///@type {DDActionType}
  action = Assert.isEnum(json.action, DDActionType)

  ///@type {?Struct}
  data = Core.isType(Struct.get(json, "data"), Struct) 
    ? json.data 
    : null

  ///@return {DDAction}
  run = function() {
    switch (this.action) {
      case DDActionType.QUIT:
        Beans.get(BeanDialogueService).close()
        break
      case DDActionType.LOAD_VISU_TRACK:
        Beans.get(BeanVisuController).send(new Event("load", {
          manifest: FileUtil.get(this.data.path),
          autoplay: true,
        }))
        break
      default: throw new Exception($"Invalid DDActionType {this.action}")
    }
    return this
  }
}