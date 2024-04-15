///@package io.alkapivo.test.core.EventPumpTest

function EventPumpTest(): Test() constructor {
    name = "Test EventPump.gml"
    cases = [
        {
            name: "EventPump.send",
            config: {
                events: [
                    new Event("notify"),
                    new Event("count", "Current size: {0}")
                ],
                dispatchers: new Map(any, any, {
                    notify: function(event) {
                        
                    },
                    count: function(event) {

                    }
                })
            },
            test: function(config) {

                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ]
}