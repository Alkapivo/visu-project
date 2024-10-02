///@package io.alkapivo.test.core.collection

///@param {Struct} [json]
///@return {Task}
function Test_Map(json = {}) {
  return new Task("Test_Map")
    .setTimeout(Struct.getDefault(json, "timeout", 3.0))
    .setPromise(new Promise())
    .setState({
      collection: new Map(String, String, {
        lorem: "ipsum",
        dolor: "sit",
        amet: "consectetur",
      }),
      get: {
        key: "lorem",
        expected: "ipsum",
      },
      getDefault: {
        found: {
          key: "dolor",
          expected: "sit"
        },
        notFound: {
          key: "adipiscing",
          expected: "elit"
        }
      },
      contains: {
        found: "amet",
        notFound: "adipiscing"
      },
      set: {
        key: "adipiscing",
        value: "elit"
      },
      add: {
        key: "sed",
        value: "do"
      },
      size: 5,
      remove: "adipiscing",
      keys: new Map(String, String, {
        lorem: "ipsum",
        dolor: "sit", 
        amet: "consectetur",
        sed: "do"
      }),
      inject: {
        found: {
          key: "lorem",
          value: "baron",
          expected: "ipsum"
        },
        notFound: {
          key: "eiusmod",
          value: "tempor"
        }
      },
      forEach: new Map(String, String, {
        lorem: "ipsum",
        dolor: "sit", 
        amet: "consectetur",
        sed: "do",
        eiusmod: "tempor"
      }),
      filter: {
        exclude: "eiusmod",
        expected: new Map(String, String, {
          lorem: "ipsum",
          dolor: "sit", 
          amet: "consectetur",
          sed: "do"
        }),
      },
      map: new Map(String, String, {
        lorem: "ipsum",
        dolor: "sit", 
        amet: "consectetur",
        sed: "do",
        eiusmod: "tempor"
      }),
      find: "sit",
      findKey: {
        value: "ipsum",
        expected: "lorem"
      },
      toStruct: new Map(String, String, {
        lorem: "_ipsum",
        dolor: "_sit",
        amet: "_consectetur",
        sed: "_do",
        eiusmod: "_tempor"
      }),
      toArray: new Map(String, any, {
        "lorem_ipsum": null,
        "dolor_sit": null,
        "amet_consectetur": null,
        "sed_do": null,
        "eiusmod_tempor": null
      }),
      merge: {
        a: new Map(String, String, {
          "a": "A"
        }),
        b: new Map(String, String, {
          "b": "B"
        }),
        c: new Map(String, String, {
          "c": "C"
        }),
        expected: new Map(String, String, {
          "a": "A",
          "b": "B",
          "c": "C"
        })
      }
    })
    .whenUpdate(function(executor) {
      var state = this.state

      var map = state.collection
      Assert.isTrue(map.get(state.get.key) == state.get.expected)
      Logger.test("Test_Map", "get(key): passed")

      Assert.isTrue(map.getFirst() == map.get(map.keys().getFirst()))
      Logger.test("Test_Map", "getFirst(): passed")

      Assert.isTrue(map.getLast() == map.get(map.keys().getLast()))
      Logger.test("Test_Map", "getLast(): passed")

      Assert.isTrue(map.getDefault(state.getDefault.found.key, state.getDefault.found.expected) == state.getDefault.found.expected)
      Assert.isTrue(map.getDefault(state.getDefault.notFound.key, state.getDefault.notFound.expected) == state.getDefault.notFound.expected)
      Logger.test("Test_Map", "getDefault(key, defaultValue): passed")

      Assert.isTrue(map.contains(state.contains.found))
      Assert.isTrue(!map.contains(state.contains.notFound))
      Logger.test("Test_Map", "contains(key): passed")

      var sizeBefore = map.size()
      map.set(state.set.key, state.set.value)
      var sizeAfter = map.size()
      Assert.isTrue(map.get(state.set.key) == state.set.value)
      Assert.isTrue(sizeBefore + 1 == sizeAfter)
      Logger.test("Test_Map", "set(key, value): passed")

      sizeBefore = map.size()
      map.add(state.add.value, state.add.key)
      sizeAfter = map.size()
      Assert.isTrue(map.get(state.add.key) == state.add.value)
      Assert.isTrue(sizeBefore + 1 == sizeAfter)
      Logger.test("Test_Map", "add(value, key): passed")

      Assert.isTrue(state.size == map.size())
      Logger.test("Test_Map", "size(): passed")

      sizeBefore = map.size()
      map.remove("adipiscing")
      sizeAfter = map.size()
      Assert.isTrue(!map.contains(state.remove))
      Assert.isTrue(sizeBefore - 1 == sizeAfter)
      Logger.test("Test_Map", "remove(key): passed")

      map.keys().forEach(function(key, index, keys) {
        Assert.isTrue(keys.contains(key))
      }, state.keys)
      Logger.test("Test_Map", "keys(): passed")

      sizeBefore = map.size()
      map.inject(state.inject.found.key, state.inject.found.value)
      sizeAfter = map.size()
      Assert.isTrue(sizeBefore == sizeAfter)
      Assert.isTrue(map.get(state.inject.found.key) == state.inject.found.expected)      
      sizeBefore = map.size()
      map.inject(state.inject.notFound.key, state.inject.notFound.value)
      sizeAfter = map.size()
      Assert.isTrue(sizeBefore + 1 == sizeAfter)
      Assert.isTrue(map.get(state.inject.notFound.key) == state.inject.notFound.value)
      Logger.test("Test_Map", "inject(key, value): passed")
      
      map.forEach(function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
      }, state.forEach)
      Logger.test("Test_Map", "forEach(callback, acc): passed")

      var filtered = map
        .filter(function(value, key, exclude) {
          return key != exclude
        }, state.filter.exclude)
        .forEach(function(value, key, expected) {
          return value == expected.get(key)
        }, state.filter.expected)
      Assert.isTrue(filtered.size() + 1 == map.size())
      Logger.test("Test_Map", "filter(callback, acc): passed")

      map.map(function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
        return value
      }, state.map)
      Assert.isTrue(map.size() == state.map.size())
      Logger.test("Test_Map", "map(callback, acc): passed")

      var found = map.find(function(value, key, expected) {
        return value == expected
      }, state.find)
      Assert.isTrue(found == state.find)
      Logger.test("Test_Map", "find(callback, acc): passed")

      var foundKey = map.findKey(function(value, key, expected) {
        return value == expected
      }, state.findKey.value)
      Assert.isTrue(foundKey == state.findKey.expected)
      Logger.test("Test_Map", "findKey(callback, acc): passed")

      var key = map.generateKey()
      Assert.isTrue(Core.isType(key, String))
      Assert.isTrue(!map.contains(key))
      Logger.test("Test_Map", "generateKey(seed): passed")

      var struct = map.toStruct(function(value) {
        return $"_{value}"
      })
      Struct.forEach(struct, function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
      }, state.toStruct)
      Assert.isTrue(state.toStruct.size() == Struct.size(struct))
      Logger.test("Test_Map", "toStruct(callback, acc): passed")

      var array = map.toArray(function(value, key) {
        return $"{key}_{value}"
      })
      Assert.isTrue(array.size() == map.size())
      array.forEach(function(key, index, expected) {
        Assert.isTrue(expected.contains(key))
      }, state.toArray)
      Logger.test("Test_Map", "toArray(callback, acc, keyType): passed")

      state.merge.a.merge(state.merge.b, state.merge.c)
      Assert.isTrue(state.merge.a.size() == state.merge.expected.size())
      state.merge.a.forEach(function(value, key, expected) {
        Assert.isTrue(expected.get(key) == value)
      }, state.merge.expected)
      Logger.test("Test_Map", "merge(...map): passed")


      sizeBefore = map.size()
      map.clear()
      sizeAfter = map.size()
      Assert.isTrue(sizeBefore > 0 && sizeAfter == 0)
      Logger.test("Test_Map", "clear(): passed")

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
