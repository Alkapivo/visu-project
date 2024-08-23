///@package io.alkapivo.test.core.collection

///@param {Struct} [json]
///@return {Task}
function Test_Stack(json = {}) {
    return new Task("Test_Stack")
      .setTimeout(Struct.getDefault(json, "timeout", 3.0))
      .setPromise(new Promise())
      .setState({
        stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
        push: "consectetur",
        pop: "amet",
        size: 5,
        peek: "amet",
        add: "adipiscing",
        contains: "dolor",
        get: "adipiscing",
        getFirst: "adipiscing",
        getLast: "lorem",
        remove: "amet",
        set: "elit",
        forEach: {
          stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
          expected: new Array(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ])
        },
        filter: {
          stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
          exclude: "amet",
          expected: 4
        },
        map: {
          stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
          expected: new Array(String, [ "4_amet", "3_sit", "2_dolor", "1_ipsum", "0_lorem" ]),
        },
        find: {
          stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
          target: "dolor"
        },
        findKey: {
          stack: new Stack(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
          target: "amet",
          expected: 4
        },
      })
      .whenUpdate(function(executor) {
        var state = this.state
        var stack = state.stack
        var sizeBefore = stack.size()
        stack.push(state.push)
        var sizeAfter = stack.size()
        Assert.isTrue(sizeBefore + 1 == sizeAfter)
        Assert.isTrue(stack.peek() == state.push)
        Logger.test("Test_Stack", "push(item): passed")
  
        sizeBefore = stack.size()
        stack.pop()
        sizeAfter = stack.size()
        Assert.isTrue(sizeBefore - 1 == sizeAfter)
        Assert.isTrue(stack.peek() == state.pop)
        Logger.test("Test_Stack", "pop(): passed")
  
        Assert.isTrue(stack.size() == state.size)
        Logger.test("Test_Stack", "size(): passed")
  
        Assert.isTrue(stack.peek() == state.peek)
        Logger.test("Test_Stack", "peek(): passed")
  
        sizeBefore = stack.size()
        stack.add(state.add)
        sizeAfter = stack.size()
        Assert.isTrue(sizeBefore + 1 == sizeAfter)
        Assert.isTrue(stack.peek() == state.add)
        Logger.test("Test_Stack", "add(item, key): passed")
  
        Assert.isTrue(stack.contains(state.contains))
        Logger.test("Test_Stack", "contains(searchItem, comparator): passed")
  
        Assert.isTrue(stack.get(null) == state.get)
        Logger.test("Test_Stack", "get(key, defaultValue): passed")
  
        Assert.isTrue(stack.getFirst() == state.getFirst)
        Logger.test("Test_Stack", "getFirst(): passed")
  
        Assert.isTrue(stack.getLast() == state.getLast)
        Logger.test("Test_Stack", "getLast(): passed")
  
        Assert.isTrue(stack.remove(null).peek() == state.remove)
        Logger.test("Test_Stack", "remove(key): passed")
  
        Assert.isTrue(stack.set(null, state.set).peek() == state.set)
        Logger.test("Test_Stack", "set(key, item): passed")
        
        state.forEach.stack.forEach(function(value, index, expected) {
          Assert.isTrue(expected.get(index) == value)
        }, state.forEach.expected)
        Assert.isTrue(state.forEach.stack.size() == 0)
        Logger.test("Test_Stack", "forEach(callback, acc): passed")
  
        state.filter.stack = state.filter.stack
          .filter(function(value, index, exclude) {
            return value != exclude
          }, state.filter.exclude)
        
        state.filter.stack.container.forEach(function(value, index, exclude) {
            Assert.isTrue(value != exclude)
          }, state.filter.exclude)
        Assert.isTrue(state.filter.stack.size() == state.filter.expected)
        Logger.test("Test_Stack", "filter(callback, acc): passed")
  
        state.map.stack
          .map(function(value, index) {
            return $"{index}_{value}"
          })
          .forEach(function(value, index, expected) {
            Assert.isTrue(expected.get(index) == value)
          }, state.map.expected)
        Logger.test("Test_Stack", "map(callback, acc): passed")
  
        var found = state.find.stack.find(function(value, index, target) {
          return value = target
        }, state.find.target)
        Assert.isType(found, String)
        Logger.test("Test_Stack", "find(callback, acc): passed")
  
        var foundKey = state.findKey.stack.findKey(function(value, index, target) {
          return value = target
        }, state.findKey.target)
        Assert.isTrue(foundKey == state.findKey.expected)
        Logger.test("Test_Stack", "findKey(callback, acc): passed")
  
        sizeBefore = stack.size()
        stack.clear()
        sizeAfter = stack.size()
        Assert.isTrue(sizeBefore > 0 && sizeAfter == 0)
        Logger.test("Test_Stack", "clear(): passed")
  
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
  
  
  Logger.test("Test_Map", "contains(key): passed")
  
  