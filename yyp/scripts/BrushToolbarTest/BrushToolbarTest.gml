///@package io.alkapivo.visu

///@param {Struct} [json]
///@return {Task}
function TestEvent_BrushToolbar_save(json = {}) {
  return new Task("TestEvent_BrushToolbar_save")
    .setTimeout(Struct.getDefault(json, "timeout", 50.0))
    .setPromise(new Promise())
    .setState({
      cooldown: new Timer(Struct.getDefault(json, "cooldown", 0.8)),
      stage: "cooldownBefore",
      stages: {
        cooldownBefore: function(task) {
          if (task.state.cooldown.update().finished) {
            task.state.stage = "setup"
            task.state.cooldown.reset()
          }
        },
        setup: function(task) {
          Beans.get(BeanVisuTestRunner).exceptions.clear()
          var editor = Beans.get(BeanVisuEditorController)
          var acc = {
            currentCategory: null,
            types: new Stack(Struct)
          }

          editor.brushToolbar.categories.forEach(function(types, category, acc) {
            acc.currentCategory = category
            types.forEach(function(type, index, acc) {
              acc.types.push({
                category: acc.currentCategory,
                type: type
              })
            }, acc)
          }, acc)

          Struct.set(task.state, "types", acc.types)
          task.state.stage = "selectType"
        },
        selectType: function(task) {
          var editor = Beans.get(BeanVisuEditorController)
          var entry = task.state.types.pop()
          if (Core.isType(entry, Struct)) {
            Logger.test("TestEvent_BrushToolbar_save", $"Select brush from category '{entry.category}' of type '{entry.type}'")
            editor.brushToolbar.store.get("category").set(entry.category)
            editor.brushToolbar.store.get("type").set(entry.type)
            task.state.stage = "selectTemplate" 
          } else {
            task.state.stage = "verify" 
          }
        },
        selectTemplate: function(task) {
          var editor = Beans.get(BeanVisuEditorController)
          if (task.state.cooldown.update().finished) {
            task.state.stage = "saveBrush"
            task.state.cooldown.reset()

            var brushView = editor.brushToolbar.containers.get("ve-brush-toolbar_brush-view")
            var component = brushView.collection.findByIndex(irandom(brushView.collection.size() - 1))
            var label = component.items.find(function(item) {
              return item.type == UIText
            })

            var brushService = Beans.get(BeanVisuEditorController).brushService
            var templates = brushService.templates.get(editor.brushToolbar.store.getValue("type"))
            var template = templates.find(function(template, index, acc) {
              return template.name == acc
            }, label.text)
            editor.brushToolbar.store.get("template").set(template)
          }
        },
        saveBrush: function(task) {
          var editor = Beans.get(BeanVisuEditorController)
          if (task.state.cooldown.update().finished) {
            task.state.stage = "cooldownAfter"
            task.state.cooldown.reset()

            var brush = editor.brushToolbar.containers
              .get("ve-brush-toolbar_inspector-view").state
              .get("brush")

            var template = brush.toTemplate()
            var brushService = Beans.get(BeanVisuEditorController).brushService
            brushService.saveTemplate(template)

            var handler = Beans.get(BeanVisuController).trackService.handlers.get(brush.type)
            handler(brush.toTemplate().properties)
          }
        },
        cooldownAfter: function(task) {
          if (task.state.cooldown.update().finished) {
            task.state.stage = "selectType"
            task.state.cooldown.reset()
          }
        },
        verify: function(task) {
          if (task.state.cooldown.update().finished) {
            Assert.isTrue(Beans.get(BeanVisuTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
            task.fullfill("success")
          }
        },
      },
    })
    .whenUpdate(function(executor) {
      var stage = Struct.get(this.state.stages, this.state.stage)
      stage(this)
    })
    .whenStart(function(executor) {
      Logger.test("BrushToolbarTest", "Start TestEvent_BrushToolbar_save")
      Beans.get(BeanVisuTestRunner).installHooks()
      Beans.get(BeanVisuEditorController).store.get("render-brush").set(true)
    })
    .whenFinish(function(data) {
      Logger.test("BrushToolbarTest", $"TestEvent_BrushToolbar_save: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
      Beans.get(BeanVisuEditorController).store.get("render-brush").set(false)
    })
    .whenTimeout(function() {
      Logger.test("BrushToolbarTest", "TestEvent_BrushToolbar_save: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
      Beans.get(BeanVisuEditorController).store.get("render-brush").set(false)
    })
}
