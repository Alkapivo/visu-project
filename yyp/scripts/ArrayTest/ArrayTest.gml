///@package io.alkapivo.test.core.collection.ArrayTest

function ArrayTest(): Test() constructor {
    name = "Test Array.gml"
    cases = new Array(Struct, [
        { 
            name: "Array.get",
            config: {
                arr: new Array(any, [ 1, 2, 3, 4, 5 ]),
            },
            test: function(config) {
                var size = config.arr.size()
                var index = Math.randomIntegerFromRange(0, size - 1)
                var value = config.arr.get(index)
                Assert.areEqual(index + 1, value)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Array.add",
            config: {
                arr: new Array(any, [ "a", "b", "c" ]),
                item: "d"
            },
            test: function(config) {
                var sizeBefore = config.arr.size()
                config.arr.add(config.item)
                var sizeAfter = config.arr.size()
                var addedItem = config.arr.get(sizeAfter - 1)
                Assert.areEqual(sizeAfter, sizeBefore + 1)
                Assert.areEqual(addedItem, config.item)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.size",
            config: {
                arr: new Array(any, [ "a", "b" ]),
                size: 2
            },
            test: function(config) {
                var size = config.arr.size()
                Assert.areEqual(size, config.size)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.remove",
            config: {
                arr: new Array(any, [ "lorem", "ipsum", "sit", "dolor" ]),
                removeIndex: 2
            },
            test: function(config) {
                var sizeBefore = config.arr.size()
                var lastElement = config.arr.get(sizeBefore - 1)
                config.arr.remove(config.removeIndex)
                var sizeAfter = config.arr.size()
                Assert.areEqual(sizeAfter, sizeBefore - 1)
                Assert.areEqual(lastElement, config.arr.get(sizeAfter - 1))

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.forEach",
            config: {
                arr: new Array(any, [ 1, 2, 3, 4, 5, 6 ]),
                sum: 21,
                callback: function(item, index, acc) {
                    acc.sum = acc.sum + item
                }
            },
            test: function(config) {
                acc = {
                    sum: 0
                }
                config.arr.forEach(config.callback, acc)
                Assert.areEqual(acc.sum, config.sum)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.filter",
            config: {
                arr: new Array(any, [ 10, 50, 20, 40, 30 ]),
                expected: new Array(any, [ 50, 40 ]),
                callback: function(item) {
                    return item > 30
                }
            },
            test: function(config) {
                var filtered = config.arr.filter(config.callback)
                var size = filtered.size()
                Assert.areEqual(size, config.expected.size())
                filtered.forEach(function(item, index, config) {
                    Assert.areEqual(item, config.expected.get(index))
                }, config)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.map",
            config: {
                arr: new Array(any, [ 100, 200, 300 ]),
                expected: new Array(any, [ 101, 201, 301 ]),
                callback: function(item) {
                    return item + 1
                }
            },
            test: function(config) {
                var mapped = config.arr.map(config.callback)
                var size = mapped.size()
                Assert.areEqual(size, config.expected.size())
                mapped.forEach(function(item, index, config) {
                    Assert.areEqual(item, config.expected.get(index))
                }, config)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Array.contains",
            config: {
                arr: new Array(any, [ "banana", "cirno", 420, 69 ]),
                searchedItem: "cirno",
                notFoundItem: "remilia",
            },
            test: function(config) {
                var contains = config.arr.contains(config.searchedItem)
                Assert.areEqual(true, contains)
                var notContains = config.arr.contains(config.notFoundItem)
                Assert.areEqual(false, notContains)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Array.sort_ascending",
            config: {
                arr: new Array(Struct, [
                    {
                        key: "a",
                        value: 30
                    },
                    {
                        key: "b",
                        value: 10
                    },
                    {
                        key: "c",
                        value: 20
                    },
                ]),
                comparator: function(a, b) { return a.value < b.value },
                result: "bca",
            },
            test: function(config) {
                var arr = config.arr.sort(config.comparator)
                var result = arr.map(function(item) {
                    return item.key
                }).join("")
                Assert.areEqual(config.result, result)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Array.sort_descending",
            config: {
                arr: new Array(Struct, [
                    {
                        key: "a",
                        value: 30
                    },
                    {
                        key: "b",
                        value: 10
                    },
                    {
                        key: "c",
                        value: 20
                    },
                ]),
                comparator: function(a, b) { return a.value > b.value },
                result: "acb",
            },
            test: function(config) {
                var arr = config.arr.sort(config.comparator)
                var result = arr.map(function(item) {
                    return item.key
                }).join("")
                Assert.areEqual(config.result, result)

                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ])
}
