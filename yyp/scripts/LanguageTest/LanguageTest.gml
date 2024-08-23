///@package io.alkapivo.test.utils

///@param {Struct} [json]
///@return {Task}
function Test_Language(json = {}) {
  return new Task("Test_Language")
    .setTimeout(Struct.getDefault(json, "timeout", 1.0))
    .setPromise(new Promise())
    .setState({
      cooldown: new Timer(Struct.getDefault(json, "cooldown", 0.5)),
      code: Struct.getDefault(json, "code", LanguageType.en_US),
      key: Struct.getDefault(json, "key", "test.language"),
      param1: Struct.getDefault(json, "param1", "lorem"),
      param2: Struct.getDefault(json, "param2", "ipsum"),
      expected: Struct.getDefault(json, "expected", "Test language with params: lorem, ipsum"),
      stage: "cooldownBefore",
      stages: {
        cooldownBefore: function(task) {
          if (task.state.cooldown.update().finished) {
            Beans.get(BeanVisuTestRunner).exceptions.clear()
            task.state.stage = "init"
            task.state.cooldown.reset()
          }
        },
        init: function(task) {
          initLanguage(task.state.code)
          Assert.isTrue(Core.isType(Language.pack, LanguagePack))
          task.state.stage = "get"
          Logger.test("Test_Language", $"initLanguage(\"{task.state.code}\") passed")
        },
        get: function(task) {
          var label = Language.get(task.state.key, task.state.param1, task.state.param2)
          Assert.isTrue(label == task.state.expected)
          task.state.stage = "getCode"
          Logger.test("Test_Language", $"Language.get(\"{task.state.key}\") passed")
        },
        getCode: function(task) {
          var code = Language.getCode()
          Assert.isTrue(code == task.state.code)
          task.state.stage = "cooldownAfter"
          Logger.test("Test_Language", $"Language.getCode(\"{task.state.code}\") passed")
        },
        cooldownAfter: function(task) {
          if (task.state.cooldown.update().finished) {
            Assert.isTrue(Beans.get(BeanVisuTestRunner).exceptions.size() == 0, "No exceptions can be thrown")
            task.fullfill("success")
          }
        }
      },
    })
    .whenUpdate(function(executor) {
      var stage = Struct.get(this.state.stages, this.state.stage)
      stage(this)
    })
    .whenStart(function(executor) {
      Logger.test("LanguageTest", "Start Test_Language")
      Beans.get(BeanVisuTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("LanguageTest", $"Finished Test_Language: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("BrushToolbarTest", "Test_Language: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
}
