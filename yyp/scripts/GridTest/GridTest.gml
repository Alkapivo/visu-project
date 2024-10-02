///@package io.alkapivo.test.core.collection

///@param {Struct} [json]
///@return {Task}
function Test_Grid(json = {}) {
  return new Task("Test_Grid")
    .setTimeout(Struct.getDefault(json, "timeout", 3.0))
    .setPromise(new Promise())
    .setState({ })
    .whenUpdate(function(executor) {
      this.fullfill("success")
    })
    .whenStart(function(executor) {
      Logger.test("GridTest", "Start Test_Grid")
      Beans.get(BeanTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("GridTest", $"Finished Test_Grid. Result: {data}")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("GridTest", "Test_Grid Timeout")
      this.reject("failure")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
}
