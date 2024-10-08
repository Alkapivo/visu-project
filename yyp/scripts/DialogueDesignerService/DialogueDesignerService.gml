///@package io.alkapivo.core.service.dialogue-designer

#macro BeanDialogueDesignerService "DialogueDesignerService"
///@param {Struct} [config]
function DialogueDesignerService(config = {}) constructor {

  ///@type {Map<String, String>}
  templates = new Map(String, String)
  //templates.set("menu", FileUtil.readFileSync("dialogue/menu.json").getData()) ///@mockup

  ///@type {?DDDialogue}
  dialog = null

  ///@type {Map<String, Callable>}
  handlers = Core.isType(Struct.get(config, "handlers"), Map)
    ? config.handlers
    : new Map(String, Callable)

  ///@param {String} name
  ///@return {DialogueDesignerService}
  open = function(name) {
    Core.print($"open dialog {name}")
    var template = templates.get(name)
    if (Core.isType(template, String)) {
      this.dialog = new DDDialogue(JSON.parse(template))
    }
    return this
  }

  ///@return {DialogueDesignerService}
  close = function() {
    Core.print($"close dialog")
    this.dialog = null
    return this
  }

  ///@return {DialogueDesignerService}
  update = function() {
    if (Core.isType(this.dialog, DDDialogue)) {
      this.dialog.update(this.handlers)
    }
    
    return this
  }
}