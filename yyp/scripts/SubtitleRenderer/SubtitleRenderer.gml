///@package io.alkapivo.visu.service.subtitle

function SubtitleRenderer() constructor {

  ///@type {UILayout} canvas
  ///@return {SubtitleRenderer}
  renderGUI = function(canvas) {
    var subtitleService = Beans.get(BeanVisuController).subtitleService
    subtitleService.executor.tasks.forEach(function(task, iterator, canvas) {
      var subtitle = task.state.subtitle
      GPU.set.font(subtitle.font.asset)
        .set.align.h(subtitle.align)
        .set.align.v(subtitle.align)

      var guiWidth = canvas.width()
      var guiHeight = canvas.height()
      var guiX = canvas.x()
      var guiY = canvas.y()
      var charPointer = task.state.charPointer
      var linePointer = task.state.linePointer
      var displayLines = (subtitle.area.getHeight()) / (subtitle.fontHeight / guiHeight)
      var lineStartPointer = clamp(linePointer - displayLines, 0, subtitle.lines.size() - 1);
      var alpha = 1.0
      
      if (subtitle.fadeIn > task.state.time) {
        alpha = task.state.time / subtitle.fadeIn
      }

      if (Optional.is(subtitle.finishDelay)) {
        if (subtitle.finishDelay.time >= subtitle.finishDelay.duration - subtitle.fadeOut) {
          alpha = (subtitle.finishDelay.duration - subtitle.finishDelay.time) / subtitle.fadeOut
        }

        if (subtitle.finishDelay.finished) {
          alpha = 0.0
        }
      }

      if (Optional.is(task.timeout)) {
        if (task.timeout.time >= task.timeout.duration - subtitle.fadeOut) {
          alpha = min(alpha, (task.timeout.duration - task.timeout.time) / subtitle.fadeOut)
        }

        if (task.timeout.finished) {
          alpha = 0.0
        }
      }

      for (var index = lineStartPointer; index <= linePointer; index++) {
        if (index >= subtitle.lines.size()) {
          break
        }

        var line = subtitle.lines.get(index)
        var _x = subtitle.area.getX() // HAlign.LEFT by default
        var _y = subtitle.area.getY() + ((index - lineStartPointer)
          * (subtitle.fontHeight / guiHeight)) // VAlign.TOP by default
        var text = index == linePointer ? String.copy(line, 0, floor(charPointer)) : line
        var color = subtitle.color
        var outline = subtitle.outline

        if (subtitle.align.h == HAlign.CENTER) {
          _x = _x + ((subtitle.area.getWidth()) / 2.0)
        } else if (subtitle.align.h == HAlign.RIGHT) {
          _x = _x + (subtitle.area.getWidth())
        }

        if (subtitle.align.v == VAlign.BOTTOM) {
          _y = subtitle.area.getY() + subtitle.area.getHeight()  - ((index - lineStartPointer)
            * (subtitle.fontHeight / guiHeight))
        }
        
        GPU.render.text(
          guiX + (_x * guiWidth),
          guiY + (_y * guiHeight),
          text,
          1.0,
          0.0,
          alpha,
          color,
          subtitle.font,
          subtitle.align.h,
          subtitle.align.v,
          outline,
          (1.0 - alpha) * 8.0
        )
      }
    }, canvas)

    return this
  }
}