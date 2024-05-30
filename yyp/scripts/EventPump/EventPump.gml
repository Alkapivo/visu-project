///@package io.alkapivo.core.util.event

///@param {String} _message
function EventPumpNotFoundException(_message): Exception(_message) constructor { }


///@static
function _EventPumpUtil() constructor {
  
  ///@return {Callable}
  static send = function() {
    
    ///@param {Event} event
    ///@return {?Promise}
    return function(event) {
      return this.dispatcher.send(event)
    }
  }
}
global.__EventPumpUtil = new _EventPumpUtil()
#macro EventPumpUtil global.__EventPumpUtil


///@param {Struct} _context
///@param {Map<String, Callable>} _dispatchers
///@param {Struct} [config]
function EventPump(_context, _dispatchers, config = {}) constructor {

  ///@type {Struct}
  context = Assert.isType(_context, Struct, "context")

  ///@private 
  ///@type {Queue<Event>}
  container = new Queue(Event)

  ///@private
  ///@type {Map<String, Callable>}
  dispatchers = Assert.isType(_dispatchers, Map).map(function(callable, key, context) {
    return method(context, callable)
  }, this.context)

  ///@private
  ///@type {?Timer}
  timer = Struct.contains(config, "timer") 
    ? Assert.isType(Struct.get(config, "timer"), Timer) 
    : null

  ///@private
  ///@type {Number}
  limit = Assert.isType(Struct.getDefault(config, "limit", Infinity), Number)

  ///@private
  ///@type {Boolean}
  enableLogger = Assert.isType(Struct
    .getDefault(config, "enableLogger", false), Boolean)

  ///@private
  ///@type {Boolean}
  catchException = Assert.isType(Struct
    .getDefault(config, "catchException", false), Boolean)

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    if (this.enableLogger) {
      Logger.debug("EventPump", $"Send event: '{event.name}'")
    }
    this.container.push(event)
    return event.promise
  }

  ///@param {Event|Number} entry
  ///@return {EventPump}
  execute = function(entry) {
    static resolveEvent = function(context, event) {
      if (context.enableLogger) {
        Logger.debug("EventPump", $"Dispatch event: '{event.name}'")
      }

      var handler = context.dispatchers.get(event.name)
      if (!Core.isType(handler, Callable)) {
        throw new EventPumpNotFoundException($"Dispatcher not found: '{event.name}'")
      }

      var response = handler(event)
      if (Core.isType(event.promise, Promise)) {
        event.promise.fullfill(response)
      }
    }

    var event = Core.isType(entry, Number) ? this.container.pop() : entry
    if (this.catchException) {
      var isException = false
      var exceptionMessage = ""
      try {
        resolveEvent(this, event)
      } catch (exception) {
        Logger.error("EventPump", $"'execute-dispatcher' fatal error: {exception.message}")
        Core.printStackTrace()
        isException = true
        exceptionMessage = exception.message
      }

      if (isException && Core.isType(Struct.get(event, "promise"), Promise)) {
        try {
          event.promise.reject(exceptionMessage)
        } catch (ex) {
          Logger.error("EventPump", $"'dispatcher-promise-reject' fatal error: {ex.message}")
        }
      }
    } else {
      resolveEvent(this, event)
    }

    return this
  }

  ///@return {EventPump}
  update = function() {
    if (this.timer != null && !this.timer.update().finished) {
      return this
    }

    if (this.limit == Infinity) {
      this.container.forEach(this.execute)
    } else {
      var to = min(this.limit, this.container.size())
      IntStream.forEach(0, to, this.execute, this)
    }
    return this
  }
}