///@package io.alkapivo.core.util

///@enum
function _PromiseStatus(): Enum() constructor {
  PENDING = "pending"
  FULLFILLED = "fullfilled"
  REJECTED = "rejected"
}
global.__PromiseStatus = new _PromiseStatus()
#macro PromiseStatus global.__PromiseStatus


///@type {?Struct} [config]
function Promise(config = null) constructor {

  ///@type {PromiseStatus}
  status = PromiseStatus.PENDING

  ///@type {any}
  state = null

  ///@type {any}
  response = null

  ///@private
  ///@type {?Callable}
  onSuccess = Core.isType(Struct.get(config, "onSuccess"), Callable)
    ? method(this, config.onSuccess)
    : function(data) { return data }
  
  ///@private
  ///@type {?Callable}
  onFailure = Core.isType(Struct.get(config, "onFailure"), Callable)
    ? method(this, config.onFailure)
    : function(data) { return data }
  

  ///@return {Boolean}
  isReady = function() {
    return this.status != PromiseStatus.PENDING
  }

  ///@param {?Callable} resolve
  ///@return {Promise}
  whenSuccess = function(resolve) {
    this.onSuccess = Core.isType(resolve, Callable)
      ? method(this, resolve)
      : null

    return this
  }

  ///@param {?Callable} reject
  ///@return {Promise}
  whenFailure = function(reject) {
    this.onFailure = Core.isType(reject, Callable)
      ? method(this, reject)
      : null

    return this
  }

  ///@param {any} state
  ///@return {Promise}
  setState = function(state) {
    this.state = state
    return this
  }

  ///@param {PromiseStatus} status
  ///@return {Promise}
  setStatus = function(status) {
    if (PromiseStatus.contains(status)) {
      this.status = status
    }
    return this
  }

  ///@param {any} response
  ///@return {Promise}
  setResponse = function(response) {
    this.response = response
    return this
  }

  ///@param {any} [data]
  ///@return {Promise}
  fullfill = function(data = null) {
    return this.status == PromiseStatus.PENDING
      ? this.setStatus(PromiseStatus.FULLFILLED)
          .setResponse(Callable.run(this.onSuccess, data))
      : this
  }

  ///@param {any} [data]
  ///@return {Promise}
  reject = function(data = null) {
    return this.setStatus(PromiseStatus.REJECTED)
      .setResponse(Callable.run(this.onFailure, data))
  }
}
