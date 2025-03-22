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
  onSuccess = null

  ///@private
  ///@type {?Callable}
  onFailure = null
  
  ///@return {Boolean}
  isReady = function() {
    return this.status != PromiseStatus.PENDING
  }

  ///@param {?Callable} resolve
  ///@return {Promise}
  whenSuccess = function(resolve) {
    this.onSuccess = Core.isType(resolve, Callable) ? method(this, resolve) : null
    return this
  }
  this.whenSuccess(Struct.get(config, "onSuccess"))

  ///@param {?Callable} reject
  ///@return {Promise}
  whenFailure = function(reject) {
    this.onFailure = Core.isType(reject, Callable) ? method(this, reject) : null
    return this
  }
  this.whenFailure(Struct.get(config, "onFailure"))

  ///@param {any} state
  ///@return {Promise}
  setState = function(state) {
    this.state = state
    return this
  }
  this.setState(Struct.get(config, "state"))

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
    if (!this.isReady()) {
      this.status = PromiseStatus.FULLFILLED
      if (Optional.is(this.onSuccess)) {
        var _response = this.onSuccess(data) ///@todo refactor
        this.setResponse(_response)
      }
    }

    return this
  }

  ///@param {any} [data]
  ///@return {Promise}
  reject = function(data = null) {
    if (this.status != PromiseStatus.REJECTED) {
      this.status = PromiseStatus.REJECTED
      if (Optional.is(this.onFailure)) {
        var _response = this.onFailure(data) ///@todo refactor
        this.setResponse(_response)
      }
    }

    return this
  }
}
