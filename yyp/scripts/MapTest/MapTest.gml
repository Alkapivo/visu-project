///@package io.alkapivo.test.core.collection.MapTest

function MapTest(): Test() constructor {
    name = "Test Map.gml"
    cases = new Array(Struct, [
        {
            name: "Map.get",
            config: {
                entries: {
                    lorem: "ipsum",
                    black: "white"
                },
                item: {
                    key: "black",
                    value: "white"
                }
            },
            test: function(config) {
                var map = new Map(String, String, config.entries)
                var item = map.get(config.item.key)
                Assert.areEqual(item, config.item.value)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.getDefault",
            config: {
                entries: {
                    lorem: "ipsum",
                    black: "white"
                },
                notFound: {
                    key: "pink",
                    value: "orange"
                },
                found: {
                    key: "black",
                    value: "pink"
                }
            },
            test: function(config) {

                var map = new Map(String, String, config.entries)
                var item = map.getDefault(config.notFound.key, config.notFound.value)
                Assert.areEqual(item, config.notFound.value)

                item = map.getDefault(config.found.key, config.found.value)
                Assert.areEqual(item, config.entries.black)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.contains",
            config: {
                entries: {
                    lorem: "ipsum",
                    black: "white"
                },
                found: {
                    key: "black"
                },
                notFound: {
                    key: "orange"
                }
            },
            test: function(config) {

                var map = new Map(String, String, config.entries)
                var contains = map.contains(config.found.key)
                Assert.areEqual(contains, true)

                contains = map.contains(config.notFound.key)
                Assert.areEqual(contains, false)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.set",
            config: {
                entries: {
                    lorem: "ipsum",
                    black: "white"
                },
                item: {
                    key: "pink",
                    value: "orange"
                }
            },
            test: function(config) {

                var map = new Map(String, String, config.entries)
                var sizeBefore = map.size()
                map.set(config.item.key, config.item.value)
                var sizeAfter = map.size()
                Assert.areEqual(sizeBefore + 1, sizeAfter)

                var value = map.get(config.item.key)
                Assert.areEqual(value, config.item.value)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.remove",
            config: {
                entries: {
                    lorem: "ipsum",
                    black: "white"
                },
                found: "lorem",
                notFound: "pink"
            },
            test: function(config) {

                var map = new Map(String, String, config.entries)
                var sizeBefore = map.size()
                map.remove(config.found)
                var sizeAfter = map.size()
                Assert.areEqual(sizeBefore, sizeAfter + 1)

                map.remove(config.notFound)
                Assert.areEqual(sizeAfter, map.size())

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.forEach",
            config: {
                entries: {
                    lorem: 1,
                    black: 2,
                    pink: 3
                },
                sum: 6,
                callback: function(value, key, acc) {
                    acc.sum = acc.sum + value
                }
            },
            test: function(config) {

                var map = new Map(String, Number, config.entries)
                var acc = {
                    sum: 0
                }

                map.forEach(config.callback, acc)
                Assert.areEqual(acc.sum, config.sum)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.filter",
            config: {
                entries: {
                    lorem: 1,
                    black: 2,
                    pink: 3
                },
                key: "pink",
                value: 3,
                size: 1,
                callback: function(value, key) {
                    return key == "pink"
                }
            },
            test: function(config) {
                var map = new Map(String, Number, config.entries)
                var filteredMap = map.filter(config.callback)
                var size = filteredMap.size()
                Assert.areEqual(size, config.size)
                var value = filteredMap.get(config.key)
                Assert.areEqual(value, config.value)
                
                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Map.map",
            config: {
                entries: {
                    lorem: 1,
                    black: 2,
                    pink: 3
                },
                sum: 12,
                callback: function(value, key, acc) {
                    acc.sum = acc.sum + value * 2
                    return value * 2
                }
            },
            test: function(config) {
                var acc = {
                    sum: 0
                }
                var map = new Map(String, Number, config.entries)
                var mappedMap = map.map(config.callback, acc)
                Assert.areEqual(map.size(), mappedMap.size())
                Assert.areEqual(acc.sum, config.sum)
                
                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ])
}
