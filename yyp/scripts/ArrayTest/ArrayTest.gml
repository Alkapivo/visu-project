///@package io.alkapivo.test.core.collection.ArrayTest

///@param {Struct} [json]
///@return {Task}
function Test_Array(json = {}) {
  return new Task("Test_Array")
    .setTimeout(Struct.getDefault(json, "timeout", 3.0))
    .setPromise(new Promise())
    .setState({
      array: new Array(Struct, [
        { name: "lorem" },
        { name: "ipsum" },
        { name: "dolor" },
        { name: "sit" },
        { name: "amet" }
      ]),
      size: 5,
      remove: {
        index: 1,
        expected: new Array(String, [ "lorem", "dolor", "sit", "amet" ])
      },
      set: {
        index: 1,
        value: "ipsum",
        expected: new Array(String, [ "lorem", "ipsum", "sit", "amet" ])
      },
      get: {
        index: 2,
        expected: "sit"
      },
      add: {
        index: 2,
        value: "dolor",
        expected: new Array(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ])
      },
      find: "amet",
      findIndex: 4,
      forEach: new Array(String, [ "lorem", "ipsum", "dolor", "sit", "amet" ]),
      filter: {
        value: "ipsum",
        expected: new Array(String, [ "lorem", "dolor", "sit", "amet" ])
      },
      map: new Array(String, [ "0lorem", "1ipsum", "2dolor", "3sit", "4amet" ]),
      contains: "sit",
      join: {
        delimiter: ", ",
        expected: "lorem, ipsum, dolor, sit, amet"
      },
      getFirst: "lorem",
      getLast: "amet",
      swapItems: {
        a: 0,
        b: 4
      },
      removeMany: {
        keys: new Array(Number, [ 0, 2 ]),
        expected: new Array(String, [ "ipsum", "sit", "lorem" ])
      },
      sort: new Array(String, [ "ipsum", "lorem", "sit" ]),
      toMap: new Map(String, String, {
        "index_0": "ipsum",
        "index_1": "lorem",
        "index_2": "sit"
      }),
      toStruct: new Map(String, Number, { 
        "ipsum": 0,
        "lorem": 1,
        "sit": 2
      }),
      move: {
        from: 0,
        to: 2,
        expected: new Array(String, [ "lorem", "sit", "ipsum" ])
      },
      gc: {
        index: 1,
        expected: new Array(String, [ "lorem", "ipsum" ])
      }
    })
    .whenUpdate(function(executor) {
      var state = this.state
      var array = state.array
      Assert.isTrue(array.size() == state.size)
      Logger.test("Test_Array", $"size(): passed")

      array.remove(state.remove.index)
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.remove.expected)
      Logger.test("Test_Array", $"remove(index): passed")

      array.set(state.set.index, { name: state.set.value })
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.set.expected)
      Logger.test("Test_Array", $"set(index, value): passed")

      Assert.isTrue(array.get(state.get.index).name == state.get.expected)
      Logger.test("Test_Array", $"get(index): passed")

      array.add({ name: state.add.value }, state.add.index)
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.add.expected)
      Logger.test("Test_Array", $"add(value, index): passed")

      var findResult = array.find(function(value, index, expected) {
        return value.name == expected
      }, state.find)
      Assert.isTrue(Core.isType(findResult, Struct))
      Logger.test("Test_Array", $"find(callback, acc): passed")

      var findIndexResult = array.findIndex(function(value, index, expected) {
        return value.name == expected
      }, state.find)
      Assert.isTrue(findIndexResult == state.findIndex)
      Logger.test("Test_Array", $"findIndex(callback, acc): passed")

      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.forEach)
      Logger.test("Test_Array", $"forEach(callback, acc): passed")

      array
        .filter(function(entry, index, exclude) {
          return entry.name != exclude
        }, state.filter.value)
        .forEach(function(entry, index, expected) {
          Assert.isTrue(entry.name == expected.get(index))
        }, state.filter.expected)
      Logger.test("Test_Array", $"filter(callback, acc): passed")

      array
        .map(function(entry, index) {
          return { name: $"{index}{entry.name}"}
        })
        .forEach(function(entry, index, expected) {
          Assert.isTrue(entry.name == expected.get(index))
        }, state.map)
      Logger.test("Test_Array", $"map(callback, acc): passed")

      var contains = array.contains(state.contains, function(a, b) {
        return a.name == b
      })
      Assert.isTrue(contains)
      Logger.test("Test_Array", $"contains(searchItem, comparator): passed")

      var joined = array
        .map(function(entry) {
          return entry.name 
        }, null, String)
        .join(state.join.delimiter)
      Assert.isTrue(joined == state.join.expected)
      Logger.test("Test_Array", $"join(delimiter): passed")

      var first = array.getFirst()
      Assert.isTrue(first.name == state.getFirst)
      Logger.test("Test_Array", $"getFirst(): passed")

      var last = array.getLast()
      Assert.isTrue(last.name == state.getLast)
      Logger.test("Test_Array", $"getLast(): passed")

      var expectedSwapA = array.get(state.swapItems.b).name
      var expectedSwapB = array.get(state.swapItems.a).name
      array.swapItems(state.swapItems.a, state.swapItems.b)
      Assert.isTrue(array.get(state.swapItems.a).name == expectedSwapA)
      Assert.isTrue(array.get(state.swapItems.b).name == expectedSwapB)
      Logger.test("Test_Array", $"swapItems(a, b): passed")

      array.removeMany(state.removeMany.keys)
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.removeMany.expected)
      Logger.test("Test_Array", $"removeMany(keys): passed")

      array
        .sort(function(a, b) { 
          return ord(String.getChar(a.name, 1)) <= ord(String.getChar(b.name, 1))
        }).forEach(function(entry, index, expected) {
          Assert.isTrue(entry.name == expected.get(index))
        }, state.sort)
      Logger.test("Test_Array", $"sort(comparator): passed")

      var map = array.toMap(String, String, function(value, index, acc) {
        return value.name
      }, null, function(value, index, acc) {
        return $"index_{index}"
      })

      Assert.isTrue(map.size() == array.size())
      map.forEach(function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
      }, state.toMap)
      Logger.test("Test_Array", $"toMap(keyType, valueType, valueCallback, acc, keyCallback): passed")

      var struct = array.toStruct(function(value, index) {
        return index
      }, null, function(value, index) {
        return value.name
      })

      Assert.isTrue(Struct.size(struct) == array.size())
      Struct.forEach(struct, function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
      }, state.toStruct)
      Logger.test("Test_Array", $"toStruct(valueCallback, acc, keyCallback): passed")
      
      array.move(state.move.from, state.move.to)
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.move.expected)
      Logger.test("Test_Array", $"move(from, to): passed")

      array.enableGC()
      Assert.isTrue(Core.isType(array.gc, Stack))
      Logger.test("Test_Array", $"enableGC(): passed")

      array.disableGC()
      Assert.isTrue(!Optional.is(array.gc))
      Logger.test("Test_Array", $"disableGC(): passed")

      array.enableGC().addToGC(state.gc.index).runGC()
      array.forEach(function(entry, index, expected) {
        Assert.isTrue(entry.name == expected.get(index))
      }, state.gc.expected)
      Logger.test("Test_Array", $"addToGC(key).runGC(): passed")

      var sizeBefore = array.size()
      array.clear()
      var sizeAfter = array.size()
      Assert.isTrue(sizeBefore > 0 && sizeAfter == 0)
      Logger.test("Test_Array", "clear(): passed")

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
