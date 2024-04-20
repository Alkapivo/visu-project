///@package io.alkapivo.visu.service.lyrics

///@param {Controller} _controller
///@param {Struct} [config]
function LyricsRenderer(_controller, config = {}) constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@return {LyricsService}
  renderGUI = function() {
    var service = this.controller.lyricsService
    service.executor.tasks.forEach(function(task, iterator, renderer) {
      var lyrics = task.state.lyrics
      GPU.set.font(lyrics.font).align.h(lyrics.align).align.v(lyrics.align)

      var enable = renderer.controller.renderUI
      var preview = renderer.controller.editor.layout.nodes.preview
      var guiWidth = enable ? ceil(preview.width()) : GuiWidth()
      var guiHeight = enable ? ceil(preview.height()) : GuiHeight()
      var guiX = enable ? ceil(preview.x()) : 0 
      var guiY = enable ? ceil(preview.y()) : 0

      var charPointer = task.state.charPointer
      var linePointer = task.state.linePointer
      var displayLines = (lyrics.area.getHeight()) / (lyrics.fontHeight / guiHeight)
      var lineStartPointer = clamp(linePointer - displayLines, 0, lyrics.lines.size() - 1);
      var alpha = 1.0
      
      if (lyrics.fadeIn > task.state.time) {
        alpha = task.state.time / lyrics.fadeIn
      }

      if (Optional.is(lyrics.finishDelay)) {
        if (lyrics.finishDelay.time >= lyrics.finishDelay.duration - lyrics.fadeOut) {
          alpha = (lyrics.finishDelay.duration - lyrics.finishDelay.time) / lyrics.fadeOut
        }

        if (lyrics.finishDelay.finished) {
          alpha = 0.0
        }
      }

      if (Optional.is(task.timeout)) {
        if (task.timeout.time >= task.timeout.duration - lyrics.fadeOut) {
          alpha = min(alpha, (task.timeout.duration - task.timeout.time) / lyrics.fadeOut)
        }

        if (task.timeout.finished) {
          alpha = 0.0
        }
      }

      for (var index = lineStartPointer; index <= linePointer; index++) {
        if (index >= lyrics.lines.size()) {
          break
        }

        var line = lyrics.lines.get(index)
        var _x = lyrics.area.getX() // HAlign.LEFT by default
        var _y = lyrics.area.getY() + (index * (lyrics.fontHeight / guiHeight)) // VAlign.TOP by default
        var text = index == linePointer ? String.copy(line, 0, floor(charPointer)) : line
        var color = lyrics.color
        var outline = lyrics.outline

        if (lyrics.align.h == HAlign.CENTER) {
          _x = _x + ((lyrics.area.getWidth()) / 2.0)
        } else if (lyrics.align.h == HAlign.RIGHT) {
          _x = _x + (lyrics.area.getWidth())
        }
        if (lyrics.align.v == VAlign.BOTTOM) {
          _y = lyrics.area.getY() + lyrics.area.getHeight() - (index * (lyrics.fontHeight / guiHeight))
        }
        
        _x = guiX + (_x * guiWidth)
        _y = guiY + (_y * guiHeight)
        GPU.render.text(_x, _y, text, color, outline, alpha)
      }
    }, this)

    return this
  }
}