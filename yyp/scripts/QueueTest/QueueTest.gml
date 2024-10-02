///@package io.alkapivo.test.core.collection

///@param {Struct} [json]
///@return {Task}
function Test_Queue(json = {}) {
  return new Task("Test_Queue")
    .setTimeout(Struct.getDefault(json, "timeout", 3.0))
    .setPromise(new Promise())
    .setState({
      queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
      push: "consectetur",
      pop: "ipsum",
      size: 5,
      peek: "ipsum",
      tail: "consectetur",
      add: "adipiscing",
      contains: "dolor",
      get:{
        index: 1,
        expected: "ipsum"
      },
      getFirst: "ipsum",
      getLast: "adipiscing",
      remove: "dolor",
      set: "elit",
      forEach: {
        queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        expected: new Array(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ])
      },
      filter: {
        queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        exclude: "amet",
        expected: 4
      },
      map: {
        queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        expected: new Array(String, [ "0_lorem", "1_ipsum", "2_dolor", "3_sit", "4_amet" ]),
      },
      find: {
        queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        target: "dolor"
      },
      findKey: {
        queue: new Queue(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        target: "amet",
        expected: 4
      },
    })
    .whenUpdate(function(executor) {
      var state = this.state
      var queue = state.queue
      var sizeBefore = queue.size()
      queue.push(state.push)
      var sizeAfter = queue.size()
      Assert.isTrue(sizeBefore + 1 == sizeAfter)
      Assert.isTrue(queue.tail() == state.push)
      Logger.test("Test_Queue", "push(item): passed")

      sizeBefore = queue.size()
      queue.pop()
      sizeAfter = queue.size()
      Assert.isTrue(sizeBefore - 1 == sizeAfter)
      Assert.isTrue(queue.peek() == state.pop)
      Logger.test("Test_Queue", "pop(): passed")

      Assert.isTrue(queue.size() == state.size)
      Logger.test("Test_Queue", "size(): passed")

      Assert.isTrue(queue.peek() == state.peek)
      Logger.test("Test_Queue", "peek(): passed")

      Assert.isTrue(queue.tail() == state.tail)
      Logger.test("Test_Queue", "tail(): passed")

      sizeBefore = queue.size()
      queue.add(state.add)
      sizeAfter = queue.size()
      Assert.isTrue(sizeBefore + 1 == sizeAfter)
      Assert.isTrue(queue.tail() == state.add)
      Logger.test("Test_Queue", "add(item, key): passed")

      Assert.isTrue(queue.contains(state.contains))
      Logger.test("Test_Queue", "contains(searchItem, comparator): passed")

      Assert.isTrue(queue.get(state.get.index) == state.get.expected)
      Logger.test("Test_Queue", "get(key, defaultValue): passed")

      Assert.isTrue(queue.getFirst() == state.getFirst)
      Logger.test("Test_Queue", "getFirst(): passed")

      Assert.isTrue(queue.getLast() == state.getLast)
      Logger.test("Test_Queue", "getLast(): passed")

      Assert.isTrue(queue.remove(null).peek() == state.remove)
      Logger.test("Test_Queue", "remove(key): passed")

      Assert.isTrue(queue.set(null, state.set).tail() == state.set)
      Logger.test("Test_Queue", "set(key, item): passed")
      
      state.forEach.queue.forEach(function(value, index, expected) {
        Assert.isTrue(expected.get(index) == value)
      }, state.forEach.expected)
      Assert.isTrue(state.forEach.queue.size() == 0)
      Logger.test("Test_Queue", "forEach(callback, acc): passed")

      state.filter.queue = state.filter.queue
        .filter(function(value, index, exclude) {
          return value != exclude
        }, state.filter.exclude)
      
      state.filter.queue.container.forEach(function(value, index, exclude) {
          Assert.isTrue(value != exclude)
        }, state.filter.exclude)
      Assert.isTrue(state.filter.queue.size() == state.filter.expected)
      Logger.test("Test_Queue", "filter(callback, acc): passed")

      state.map.queue
        .map(function(value, index) {
          return $"{index}_{value}"
        })
        .forEach(function(value, index, expected) {
          Assert.isTrue(expected.get(index) == value)
        }, state.map.expected)
      Logger.test("Test_Queue", "map(callback, acc): passed")

      var found = state.find.queue.find(function(value, index, target) {
        return value = target
      }, state.find.target)
      Assert.isType(found, String)
      Logger.test("Test_Queue", "find(callback, acc): passed")

      var foundKey = state.findKey.queue.findKey(function(value, index, target) {
        return value = target
      }, state.findKey.target)
      Assert.isTrue(foundKey == state.findKey.expected)
      Logger.test("Test_Queue", "findKey(callback, acc): passed")

      sizeBefore = queue.size()
      queue.clear()
      sizeAfter = queue.size()
      Assert.isTrue(sizeBefore > 0 && sizeAfter == 0)
      Logger.test("Test_Queue", "clear(): passed")

      this.fullfill("success")
    })
    .whenStart(function(executor) {
      Logger.test("LanguageTest", "Start Test_Array")
      Beans.get(BeanTestRunner).installHooks()
    })
    .whenFinish(function(data) {
      Logger.test("LanguageTest", $"Finished Test_Array: {data}")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
    .whenTimeout(function() {
      Logger.test("BrushToolbarTest", "Test_Array: Timeout")
      this.reject("failure")
      Beans.get(BeanTestRunner).uninstallHooks()
    })
}