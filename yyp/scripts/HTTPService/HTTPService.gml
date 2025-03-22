///@package io.alkapivo.core.service.network

///@type {Number}
#macro HTTP_SERVICE_GET_TIMEOUT 60

///@type {String}
#macro BeanHTTPService "HTTPService"

///@param {?Struct} [config]
function HTTPService(config = null) constructor {

  ///@type {EventPump}
  eventPump = new EventPump(this, new Map(String, Callable, {
    "get": function(event) {
      var url = Assert.isType(Struct.get(event.data, "url"), String, "'url' must be passed to HTTPServer event 'get'")
      var requestId = http_get(url)
      var task = new Task("get-request")
        .setPromise(event.promise)
        .setTimeout(Struct.getIfType(event.data, "timeout", Number, HTTP_SERVICE_GET_TIMEOUT))
        .setState({
          requestId: requestId,
        })
      this.executor.add(task)
      event.setPromise(null)
    },
  }), {
    enableLogger: Struct.getIfType(Struct.get(config, "eventPump"), "enableLogger", Boolean, false),
    loggerPrefix: Struct.getIfType(Struct.get(config, "eventPump"), "loggerPrefix", String, BeanHTTPService),
    catchException: Struct.getIfType(Struct.get(config, "eventPump"), "catchException", Boolean, false),
    exceptionCallback: Struct.getIfType(Struct.get(config, "eventPump"), "exceptionCallback", Callable),
    freeStrategy: Struct.getIfEnum(Struct.get(config, "eventPump"), "freeStrategy", EventPumpFreeStrategyType.NONE),
  })

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, {
    enableLogger: Struct.getIfType(Struct.get(config, "executor"), "enableLogger", Boolean, false),
    loggerPrefix: Struct.getIfType(Struct.get(config, "executor"), "loggerPrefix", String, BeanHTTPService),
    catchException: Struct.getIfType(Struct.get(config, "executor"), "catchException", Boolean, false),
    exceptionCallback: Struct.getIfType(Struct.get(config, "executor"), "exceptionCallback", Callable),
    freeStrategy: Struct.getIfEnum(Struct.get(config, "executor"), "freeStrategy", TaskExecutorFreeStrategyType.NONE),
  })

  ///@param {?Struct} [config]
  ///@return {Event}
  factoryGetEvent = function(config = null) {
    static onSuccess = function(result) {
      Core.print("Success, result:", result)
      return result
    }

    static onFailure = function(status) {
      Core.print("Failure, status:", status)
      return status
    }

    var event = new Event("get", {
      url: Struct.get(config, "url"),
      timeout: Struct.get(config, "timeout"),
    }, new Promise({
      state: Struct.get(config, "state"),
      onSuccess: Struct.getIfType(config, "onSuccess", Callable, onSuccess),
      onFailure: Struct.getIfType(config, "onFailure", Callable, onFailure),
    }))

    return event
  }

  ///@param {Event}
  ///@return {?Promise}
  send = function(event) {
    return this.eventPump.send(event)
  }

  ///@return {HTTPService}
  onHTTPEvent = function() {
    static filterByRequestId = function(task, iterator, requestId) {
      return task.state.requestId == requestId
    }

    var requestId = async_load[? "id"]
    if (!Optional.is(requestId)) {
      return this
    }

    var task = this.executor.tasks.find(filterByRequestId, requestId)
    if (!Optional.is(task)) {
      return this
    }

    var status = async_load[? "status"]
    switch (status) {
      case 0:
        TaskUtil.fullfill(task, null, async_load[? "result"])
        break
      default:
        TaskUtil.reject(task, null, status)
        break
    }

    return this
  }

  ///@return {HTTPService}
  update = function() {
    this.eventPump.update()
    this.executor.update()
    return this
  }

  ///@return {HTTPService}
  free = function() {
    this.eventPump.free()
    this.executor.free()
    return this
  }
}