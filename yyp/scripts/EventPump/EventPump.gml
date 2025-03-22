///@package io.alkapivo.core.util.event

///@enum
function _EventPumpFreeStrategyType(): Enum() constructor {
  NONE = "NONE"
  EXECUTE = "EXECUTE"
  REJECT = "REJECT"
}
global.__EventPumpFreeStrategyType = new _EventPumpFreeStrategyType()
#macro EventPumpFreeStrategyType global.__EventPumpFreeStrategyType


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
  context = Assert.isType(_context, Struct, "EventPump context must type of Struct")

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
  timer = Struct.getIfType(config, "timer", Timer, null)

  ///@private
  ///@type {Number}
  limit = Struct.getIfType(config, "limit", Number, Infinity)

  ///@private
  ///@type {Boolean}
  enableLogger = Struct.getIfType(config, "enableLogger", Boolean, false)

  ///@private
  ///@type {String}
  loggerPrefix = Struct.getIfType(config, "loggerPrefix", String, "EventPump")

  ///@private
  ///@type {Boolean}
  catchException = Struct.getIfType(config, "catchException", Boolean, false)

  ///@private
  ///@type {?Callable}
  exceptionCallback = Struct.getIfType(config, "exceptionCallback", Callable)

  ///@private
  ///@type {EventPumpFreeStrategyType}
  freeStrategy = Struct.getIfEnum(config, "freeStrategy", EventPumpFreeStrategyType, EventPumpFreeStrategyType.NONE)

  ///@param {Event} event
  ///@return {?Promise}
  static send = function(event) {
    if (this.enableLogger) {
      Logger.info(this.loggerPrefix, $"Send event: '{event.name}'")
    }

    this.container.push(event)
    return event.promise
  }

  ///@param {Event} event
  ///@throws {Exception}
  ///@return {EventPump}
  static execute = function(event) {
    static resolveEvent = function(event, pump) {
      if (pump.enableLogger) {
        Logger.info(pump.loggerPrefix, $"Dispatch event: '{event.name}'")
      }

      var handler = Assert.isType(pump.dispatchers.get(event.name), Callable, 
        $"Dispatcher not found for event: '{event.name}'")
      var response = handler(event)
      if (Core.isType(event.promise, Promise)) {
        event.promise.fullfill(response)
      }
    }

    if (this.catchException) {
      try {
        resolveEvent(event, this)
      } catch (exception) {
        Logger.error(this.loggerPrefix, 
          $"EventPump::execute fatal error: {exception.message}")
        Core.printStackTrace()
        
        if (Optional.is(event.promise)) {
          try {
            event.promise.reject(exception.message)
          } catch (ex) {
            Logger.error(this.loggerPrefix, 
              $"EventPump::execute fatal error while rejecting event promise: {ex.message}")
            Core.printStackTrace()
          }
        }
  
        if (Optional.is(this.exceptionCallback)) {
          try {
            this.exceptionCallback(event)
          } catch (ex) {
            Logger.error(this.loggerPrefix, 
              $"EventPump::execute fatal error while running exceptionCallback: {ex.message}")
            Core.printStackTrace()
          }
        }
      }
    } else {
      resolveEvent(event, this)
    }

    return this
  }

  ///@return {EventPump}
  static update = function() {
    if (this.timer != null && !this.timer.update().finished) {
      return this
    }

    var size = this.limit == Infinity 
      ? this.container.size() 
      : min(this.limit, this.container.size())

    repeat (size) {
      this.execute(this.container.pop())
    }

    return this
  }

  ///@return {EventPump}
  static free = function() {
    static freeExecute = function(event, iterator, eventPump) {
      try {
        eventPump.execute(event)
      } catch (exception) {
        Logger.error(eventPump.loggerPrefix, $"eventPump.free(freeStrategy=EXECUTE) fatal error: {exception.message}")
        Core.printStackTrace()
      }
    }

    static freeReject = function(event, iterator, eventPump) {
      try {
        if (Optional.is(event.promise)) {
          promise.reject()
        }
      } catch (exception) {
        Logger.error(eventPump.loggerPrefix, $"eventPump.free(freeStrategy=REJECT) fatal error: {exception.message}")
        Core.printStackTrace()
      }
    }

    switch (this.freeStrategy) {
      case EventPumpFreeStrategyType.EXECUTE:
        this.container.forEach(freeExecute, this)
        break
      case EventPumpFreeStrategyType.REJECT:
        this.container.forEach(freeReject, this)
        break
    }

    this.container.clear()
    return this
  }
}