///@package io.alkapivo.test.core.collection.ArrayTest


///@param {Struct} [json]
///@return {Task}
function Test_IntStream(json = {}) {
  return new Task("Test_IntStream")
    .setTimeout(Struct.getDefault(json, "timeout", 3.0))
    .setPromise(new Promise())
    .setState({
      forEach: {
        from: 2,
        to: 5,
        expected: new Array(Number, [ 2, 3, 4, 5 ])
      },
      map: {
        from: 10,
        to: 8,
        expected: new Array(Number, [ 10, 9, 8 ])
      },
      filter: {
        from: 0,
        to: 3,
        exclude: 2,
        expected: new Array(Number, [ 0, 1, 3 ])
      }
    })
    .whenUpdate(function(executor) {
      var state = this.state

      IntStream.forEach(state.forEach.from, state.forEach.to, function(value, index, expected) {
        Assert.isTrue(expected.get(index) == value)
      }, state.forEach.expected)
      Logger.test("Test_IntStream", $"forEach(from, to, callback, acc): passed")

      IntStream
        .map(state.map.from, state.map.to, function(value) {
          return value
        })
        .forEach(function(value, index, expected) {
          Assert.isTrue(expected.get(index) == value)
        }, state.map.expected)
      Logger.test("Test_IntStream", $"map(from, to, callback, acc): passed")

      IntStream
        .filter(state.filter.from, state.filter.to, function(value, index, exclude) {
          return value != exclude
        }, state.filter.exclude)
        .forEach(function(value, index, expected) {
          Assert.isTrue(expected.get(index) == value)
        }, state.filter.expected)
      Logger.test("Test_IntStream", $"filter(from, to, callback, acc): passed")

      this.fullfill("success")
    })
    .whenStart(function(executor) {
      Logger.test("LanguageTest", "Start Test_Array")
      Beans.get(BeanVisuTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("LanguageTest", $"Finished Test_Array: {data}")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("BrushToolbarTest", "Test_Array: Timeout")
      this.reject("failure")
      Beans.get(BeanVisuTestRunner).uninstallHooks()
    })
}
