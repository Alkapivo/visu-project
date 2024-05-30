///@package io.alkapivo.test.core.TimerTest
function TimerTest(): Test() constructor {
    name = "Test Timer.gml"
    cases = new Array(Struct, [
        {
            name: "Timer.update",
            config: {
                duration: 1.0,
                timeout: 3.0,
                callback: function(data) { data.message = "lorem ipsum" },
                callbackData: { message: "dolor sit amen" },
                expected: "lorem ipsum"
            },
            test: function(config) {
                var timer = new Timer(config.duration, { callback: config.callback })
                var time = 0
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    timer.update(config.callbackData)
                    if (timer.finished) {
                        Assert.areEqual(true, timer.time <= timer.amount)
                    } else {
                        Assert.areEqual(true, timer.time < timer.duration)
                    }
                }

                Assert.areEqual(true, timer.finished)
                Assert.areEqual(true, timer.time < config.duration)
                Assert.areEqual(config.expected, config.callbackData.message)

                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Timer.update_loop",
            config: {
                duration: 1.0,
                timeout: 5.0,
                loop: 3,
                callback: function(acc) { acc.sum = acc.sum + 2 },
                callbackData: { sum: 10 },
                expected: 16
            },
            test: function(config) {
                var timer = new Timer(config.duration, {
                    loop: config.loop,
                    callback: config.callback
                })

                var counter = 0
                var time = 0
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    timer.update(config.callbackData)
                    if (timer.finished) {
                        Assert.areEqual(true, timer.time <= timer.amount)
                        counter++
                    } else {
                        Assert.areEqual(true, timer.time < timer.duration)
                    }
                }
                
                Assert.areEqual(config.loop, counter)
                Assert.areEqual(config.loop, timer.loopCounter)
                Assert.areEqual(true, timer.time <= timer.amount)
                Assert.areEqual(config.expected, config.callbackData.sum)
                
                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Timer.update_loop_infinity",
            config: {
                duration: 1.0,
                timeout: 5.5,
                loop: Infinity,
                expected: 5
            },
            test: function(config) {
                var timer = new Timer(config.duration, { loop: config.loop })

                var counter = 0
                var time = 0
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    if (timer.update().finished) {
                        counter++
                    }
                    Assert.areEqual(false, timer.finished)
                }

                Assert.areEqual(config.expected, counter)
                Assert.areEqual(config.expected, timer.loopCounter)
                
                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Timer.getProgress",
            config: {
                duration: 1.0,
                timeout: 5.0,
                expected: 5
            },
            test: function(config) {
                var timer = new Timer(config.duration)
                Assert.areEqual(0.0, timer.getProgress(timer))

                var time = 0
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    timer.update()
                    Assert.areEqual(true, timer.getProgress() > 0)
                    if (time > config.duration / 2) {
                        Assert.areEqual(true, timer.getProgress() > 0.5)
                    }

                    if (timer.finished) {
                        Assert.areEqual(1.0, timer.getProgress())
                    }
                }
                Assert.areEqual(true, timer.finished)
                
                return {
                    message: "passed",
                    config: config
                }
            }
        },
        {
            name: "Timer.reset",
            config: {
                duration: 1.0,
                timeout: 5.0,
            },
            test: function(config) {
                var timer = new Timer(config.duration)

                var time = 0
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    timer.update()
                    if (timer.finished) {
                        Assert.areEqual(true, timer.time <= timer.amount)
                    }
                }
                Assert.areEqual(true, timer.finished)

                timer.reset()
                Assert.areEqual(false, timer.finished)
                Assert.areEqual(0.0, timer.time)
                Assert.areEqual(0, timer.loopCounter)
                for (time = 0; time < config.timeout; time += FRAME_MS) {
                    timer.update()
                    if (timer.finished) {
                        Assert.areEqual(true, timer.time <= timer.amount)
                    }
                }
                Assert.areEqual(true, timer.finished)

                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ])
}