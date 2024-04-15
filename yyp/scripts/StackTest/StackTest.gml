///@package io.alkapivo.test.core.collection.StackTest

function StackTest(): Test() constructor {
    name = "Test Stack.gml"
    cases = new Array(Struct, [
        {
           name: "Stack.push",
            config: {
                items: new Array(String, [ "1", "2", "3" ]),
                item: "4"
            },
            test: function(config) {
				var stack = new Stack(String, config.items)
                var sizeBefore = stack.size()
				stack = stack.push(config.item)
                var sizeAfter = stack.size()
                var addedItem = stack.peek()
                Assert.areEqual(sizeAfter, sizeBefore + 1)
                Assert.areEqual(addedItem, config.item)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
		{
           name: "Stack.pop",
            config: {
                items: new Array(Number, [ 3, 2, 1, 0 ]),
                item: 0
            },
            test: function(config) {
				var stack = new Stack(Number, config.items)
                var sizeBefore = stack.size()
				var item = stack.pop()
                var sizeAfter = stack.size()
                Assert.areEqual(sizeAfter + 1, sizeBefore)
                Assert.areEqual(item, config.item)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
		{
           name: "Stack.peek",
            config: {
                items: new Array(Number, [ 100, 2000, 3000 ]),
                item: 3000
            },
            test: function(config) {
				var stack = new Stack(Number, config.items)
				var item = stack.peek()
                Assert.areEqual(item,config.item)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
		{
           name: "Stack.size",
            config: {
                items: new Array(Number, [ 1, 2, 3, 4, 5 ]),
                size: 5
            },
            test: function(config) {
				var stack = new Stack(Number, config.items)
				var size = stack.size()
                Assert.areEqual(size, config.size)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        { 
            name: "Stack.forEach",
            config: {
                items: new Array(Number, [ 1, 2, 3, 4, 5, 6 ]),
                sum: 21,
                callback: function(item, index, acc) {
                    acc.sum = acc.sum + item
                }
            },
            test: function(config) {
                acc = {
                    sum: 0
                }
                
                var stack = new Stack(Number, config.items)
                stack.forEach(config.callback, acc)
                var size = stack.size()
                Assert.areEqual(size, 0)
                Assert.areEqual(acc.sum, config.sum)

                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ])
}
