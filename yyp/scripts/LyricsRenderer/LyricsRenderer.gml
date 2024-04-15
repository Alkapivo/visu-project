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

      var charPointer = task.state.charPointer
      var linePointer = task.state.linePointer
      var displayLines = (lyrics.area.getHeight()) / (lyrics.fontHeight / GuiHeight())
      var lineStartPointer = clamp(linePointer - displayLines, 0, lyrics.lines.size() - 1);
      for (var index = lineStartPointer; index <= linePointer; index++) {
        if (index >= lyrics.lines.size()) {
          break
        }

        var line = lyrics.lines.get(index)
        var _x = lyrics.area.getX() // HAlign.LEFT by default
        var _y = lyrics.area.getY() + ((index - lineStartPointer) * (lyrics.fontHeight / GuiHeight())) // VAlign.TOP by default
        var text = index == linePointer ? String.copy(line, 0, floor(charPointer)) : line
        var color = lyrics.color
        var outline = lyrics.outline
        var alpha = 1.0

        if (lyrics.align.h == HAlign.CENTER) {
          _x = _x + ((lyrics.area.getWidth()) / 2.0)
        } else if (lyrics.align.h == HAlign.RIGHT) {
          _x = _x + (lyrics.area.getWidth())
        }
        if (lyrics.align.v == VAlign.BOTTOM) {
          _y = (lyrics.area.getY()) 
            + (lyrics.area.getHeight()) 
            - ((index - lineStartPointer) * lyrics.fontHeight)
        }
        
        _x = _x * GRID_SERVICE_PIXEL_WIDTH
        _y = _y * GRID_SERVICE_PIXEL_HEIGHT
        GPU.render.text(_x, _y, text, color, outline, alpha)
      }
    }, this)

    return this
  }
}