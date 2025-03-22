///@package io.alkapivo.visu.service.subtitle

///@param {?Struct} [config]
function SubtitleService(config = null) constructor {

  ///@type {Map<String, SubtitleTemplate>}
  templates = new Map(String, SubtitleTemplate)

  ///@param {String} name
  ///@return {?SubtitleTemplate}
  getTemplate = function(name) {
    var template = this.templates.get(name)
    return template == null
      ? Visu.assets().subtitleTemplates.get(name)
      : template
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "add": function(event) {
      var lines = new Array(String)
      var template = Core.isType(event.data.template, SubtitleTemplate)
        ? event.data.template
        : Assert.isType(this.getTemplate(event.data.template), SubtitleTemplate)

      GPU.set.font(event.data.font.asset)
      template.lines.forEach(function(line, index, acc) {
        var text = String.wrapText(line, acc.width, "%NEW_LINE%")
        if (String.contains(text, "%NEW_LINE%")) {
          String.split(text, "%NEW_LINE%")
            .forEach(function(line, index, lines) {
              lines.add(line)
            }, acc.lines)
        } else {
          acc.lines.add(text)
        }
      }, {
        width: event.data.area.getWidth() * GuiWidth(),
        lines: lines
      })

      var subtitle = new Subtitle({
        template: template.name,
        lines: lines,
        font: event.data.font,
        fontHeight: event.data.fontHeight,
        charSpeed: event.data.charSpeed,
        color: event.data.color,
        align: event.data.align,
        area: event.data.area,
        outline: Struct.getDefault(event.data, "outline", null),
        lineDelay: Struct.getDefault(event.data, "lineDelay", null),
        finishDelay: Struct.getDefault(event.data, "finishDelay", null),
        angleTransformer: Struct.getDefault(event.data, "angleTransformer", null),
        speedTransformer: Struct.getDefault(event.data, "speedTransformer", null),
        fadeIn: Struct.getDefault(event.data, "fadeIn", 1.0),
        fadeOut: Struct.getDefault(event.data, "fadeOut", 1.0),
      })

      var task = new Task("subtitle-task")
        .setState({
          subtitle: subtitle,
          charPointer: 0,
          linePointer: 0,
          time: 0.0,
        })
        .setTimeout(event.data.timeout)
        .whenUpdate(function() { 
          var state = this.state
          state.time = state.time + DeltaTime.apply(FRAME_MS)
          
          var angleTransformer = state.subtitle.angleTransformer
          var speedTransformer = state.subtitle.speedTransformer
          if (Optional.is(angleTransformer) 
            && Optional.is(speedTransformer)) {
            
            angleTransformer.update()
            speedTransformer.update()
            var _x = Math.fetchCircleX(DeltaTime.apply(speedTransformer.get()) / 1000.0, angleTransformer.get())
            var _y = Math.fetchCircleY(DeltaTime.apply(speedTransformer.get()) / 1000.0, angleTransformer.get())
            var area = state.subtitle.area
            area.setX(area.getX() + _x)
            area.setY(area.getY() + _y)
          }

          if (state.linePointer == state.subtitle.lines.size()) {
            if (Optional.is(state.subtitle.finishDelay)) {
              if (state.subtitle.finishDelay.update().finished) {
                this.fullfill()
              }
            } else {
              this.fullfill()
            }
            return
          }

          if (Optional.is(state.subtitle.lineDelay) 
            && state.linePointer != 0
            && !state.subtitle.lineDelay.finished
            && !state.subtitle.lineDelay.update().finished) {
            
            return
          }

          var line = state.subtitle.lines.get(state.linePointer)
          state.charPointer = state.charPointer + DeltaTime.apply(this.state.subtitle.charSpeed)
          if (state.charPointer >= String.size(line)) {
            state.charPointer = 0
            state.linePointer = state.linePointer + 1
            if (Optional.is(state.subtitle.lineDelay)) {
              state.subtitle.lineDelay.reset()
            }
            
            return
          }
        })
      
      this.executor.add(task)
    },
    "clear-subtitle": function(event) {
      this.executor.tasks.forEach(TaskUtil.fullfill).clear()
    },
    "reset-templates": function(event) {
      this.templates.clear()
      this.dispatcher.container.clear()
    },
  }))

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)
  
  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {SubtitleService}
  update = function() {
    this.dispatcher.update()
    this.executor.update()
    return this
  }

  this.send(new Event("reset-templates"))
}
