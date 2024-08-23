///@package io.alkapivo.core.service.dialogue-designer

#macro BeanDialogueService "DialogueService"
function DialogueService() constructor {

  ///@type {Map<String, String>}
  templates = new Map(String, String)
  templates.set("dd_test", FileUtil.readFileSync("_dd_test.json").getData())

  ///@type {DDDialogue}
  dialog = null

  ///@param {String} name
  ///@return {DialogueService}
  open = function(name) {
    Core.print($"open dialog {name}")
    var template = templates.get(name)
    if (Core.isType(template, String)) {
      this.dialog = new DDDialogue(JSON.parse(template))
    }
    return this
  }

  ///@return {DialogueService}
  close = function() {
    Core.print($"close dialog")
    this.dialog = null
    return this
  }

  ///@return {DialogueService}
  update = function() {
    if (Core.isType(this.dialog, DDDialogue)) {
      this.dialog.update()
    }
    
    return this
  }
}