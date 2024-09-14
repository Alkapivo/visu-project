///@package io.alkapivo.visu.editor.renderer

function VisuEditorRenderer() constructor {
  
  ///@private
  ///@return {VisuEditorRenderer}
  renderLayout = function() {
    static renderLayoutNode = function(layout, color) {
      var beginX = layout.x()
      var beginY = layout.y()
      var endX = beginX + layout.width()
      var endY = beginY + layout.height()
      GPU.render.rectangle(beginX, beginY, endX, endY, false, color, color, color, color, 0.5)
    }

    var editor = Beans.get(BeanVisuEditorController)
    if (!Core.isType(editor, VisuEditorController)) {
      return this
    }

    renderLayoutNode(editor.layout, c_red)
    renderLayoutNode(Struct.get(editor.layout.nodes, "title-bar"), c_blue)
    renderLayoutNode(Struct.get(editor.layout.nodes, "accordion"), c_yellow)
    renderLayoutNode(Struct.get(editor.layout.nodes, "preview"), c_fuchsia)
    renderLayoutNode(Struct.get(editor.layout.nodes, "track-control"), c_lime)
    renderLayoutNode(Struct.get(editor.layout.nodes, "brush-toolbar"), c_orange)
    renderLayoutNode(Struct.get(editor.layout.nodes, "timeline"), c_green)
    renderLayoutNode(Struct.get(editor.layout.nodes, "status-bar"), c_grey)

    return this
  }
}