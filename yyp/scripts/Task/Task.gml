///@package io.alkapivo.core.util.task

///@enum
function _TaskStatus(): Enum() constructor {
  IDLE = "idle"
  RUNNING = "running"
  FULLFILLED = "fullfilled"
  REJECTED = "rejected"
}
global.__TaskStatus = new _TaskStatus()
#macro TaskStatus global.__TaskStatus


///@param {String} _name
///@param {Struct} [config]
function Task(_name, config = {}) constructor {

  ///@type {String}
  name = Assert.isType(_name, String, "Task.name must be type of String")

  ///@type {TaskStatus}
  status = Assert.isEnum(TaskStatus.IDLE, TaskStatus, "Task.status must be type of TaskStatus")

  ///@type {any}
  state = null

  ///@private
  ///@type {?Timer}
  timeout = null

  ///@private
  ///@type {?Callable}
  onTimeout = null

  ///@private
  ///@type {?Timer}
  tick = null

  ///@private
  ///@type {?Callable}
  onUpdate = null

  ///@private
  ///@type {?Callable}
  onStart = null

  ///@private
  ///@type {?Callable}
  onFinish = null

  ///@type {?Promise}
  promise = null

  ///@param {?Callable} onStart
  ///@return {Task}
  static whenStart = function(onStart) {
    this.onStart = Core.isType(onStart, Callable) ? method(this, onStart) : null
    return this
  }
  this.whenStart(Struct.get(config, "onStart"))
  
  ///@param {?Callable} onFinish
  ///@return {Task}
  static whenFinish = function(onFinish) {
    this.onFinish = Core.isType(onFinish, Callable) ? method(this, onFinish) : null
    return this
  }
  this.whenFinish(Struct.get(config, "onFinish"))

  ///@param {?Callable} onUpdate
  ///@return {Task}
  static whenUpdate = function(onUpdate) {
    this.onUpdate = Core.isType(onUpdate, Callable) ? method(this, onUpdate) : null
    return this
  }
  this.whenUpdate(Struct.get(config, "onUpdate"))

  ///@param {?Callable} onTimeout
  ///@return {Task}
  static whenTimeout = function(onTimeout) {
    this.onTimeout = Core.isType(onTimeout, Callable) ? method(this, onTimeout) : null
    return this
  }
  this.whenTimeout(Struct.get(config, "whenTimeout"))

  ///@param {?Number} timeout
  ///@return {Task}
  static setTimeout = function(timeout) {
    this.timeout = Core.isType(timeout, Number) ? new Timer(timeout) : null
    return this
  }
  this.setTimeout(Struct.get(config, "timeout"))

  ///@param {?Number} tick
  ///@return {Task}
  static setTick = function(tick) {
    this.tick = Core.isType(tick, Number) 
      ? new Timer(tick, { time: tick, loop: Infinity })
      : null
    return this
  }
  this.setTick(Struct.get(config, "tick"))

  ///@param {any} state
  ///@return {Task}
  static setState = function(state) {
    this.state = state
    return this
  }
  this.setState(Struct.get(config, "state"))

  ///@param {?Promise} promise
  ///@return {Task}
  static setPromise = function(promise) {
    this.promise = promise != null ? Assert.isType(promise, Promise) : null
    return this
  }
  this.setPromise(Struct.get(config, "promise"))

  ///@param {any} [data]
  ///@return {Task}
  static fullfill = function(data = null) {
    this.status = TaskStatus.FULLFILLED
    if (Optional.is(this.promise)) {
      this.promise.fullfill(data)
    }

    return this
  }

  ///@param {any} [data]
  ///@return {Task}
  static reject = function(data = null) {
    this.status = TaskStatus.REJECTED
    if (Optional.is(this.promise)) {
      this.promise.reject(data)
    }
    
    return this
  }

  ///@param {TaskExecutor} executor
  ///@return {Task}
  ///@throws {Exception}
  static update = function(executor = null) {
    if (this.status == TaskStatus.FULLFILLED) {
      return this
    }

    if (Optional.is(this.timeout) && this.timeout.update().finished) {
      this.reject()
      if (Optional.is(this.onTimeout)) {
        this.onTimeout(executor)
      } else {
        throw new Exception($"Task timed out: '{this.name}'")
      }
    }

    if (Optional.is(this.tick) && !this.tick.update().finished) {
      return this
    }

    if (Optional.is(this.onUpdate)) {
      this.onUpdate(executor)
    }

    return this
  }
}
