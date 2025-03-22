///@package io.alkapivo.core.util.store

///@param {String} _name
///@param {Struct} json
function StoreItem(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Type}
  type = json.type

  ///@type {any}
  value = null

  ///@type {any}
  data = Struct.get(json, "data")

  ///@type {Array<StoreItemSubscriber>}
  subscribers = new Array(StoreItemSubscriber)

  ///@return {any}
  get = method(this, Assert.isType(Struct.getDefault(json, "get", function() {
    return this.value
  }), Callable))

  ///@param {any} value
  ///@return {StoreItem}
  set = method(this, Assert.isType(Struct.getDefault(json, "set", function(value) {
    var _value = Assert.isType(this.passthrough(value), this.type, $"Store item name: {this.name}")
    this.validate(_value)
    this.value = _value
    this.subscribers.forEach(function(subscriber, index, value) {
      subscriber.callback(value, subscriber.data)
    }, _value)
    
    return this
  }), Callable))

  ///@param {any} value
  ///@return {any} value
  ///@throws {Exception}
  passthrough = method(this, Assert.isType(Struct.getDefault(json, "passthrough", function(value) {
    return value
  }), Callable))

  ///@return {any}
  factoryDefault = method(this, Assert.isType(Struct.getDefault(json, "factoryDefault", function() {
    return null
  }), Callable))

  ///@return {any}
  serialize = method(this, Assert.isType(Struct.getDefault(json, "serialize", function() { 
    var item = this.get()
    return Struct.contains(item, "serialize") && Core.isType(item.serialize, Callable)
      ? item.serialize()
      : item
  }), Callable))

  ///@param {any} value
  ///@return {StoreItem}
  parse = method(this, Assert.isType(Struct.getDefault(json, "parse", function(value) { 
    return this.set(value)
  }), Callable))

  ///@param {any} value
  ///@throws {Exception}
  validate = method(this, Assert.isType(Struct.getDefault(json, "validate", function(value) { 
    return // dummy
  }), Callable))

  ///@description Apply default value
  this.set(Struct.contains(json, "value") ? json.value : this.factoryDefault())

  ///@private
  ///@param {StoreItemSubscriber} subscriber
  ///@param {Number} index
  ///@param {String} name
  ///@return {Boolean}
  static findSubscriberByName = function(subscriber, index, name) {
    gml_pragma("forceinline")
    return subscriber.name == name
  }

  ///@param {Struct} config
  ///@return {StoreItem}
  ///@throws {Exception}
  static addSubscriber = function(config) {
    gml_pragma("forceinline")
    var subscriber = new StoreItemSubscriber(config)
    if (this.containsSubscriber(subscriber.name)) {
      if (Struct.get(config, "overrideSubscriber")) {
        Logger.debug("StoreItem", $"Overrride subscriber '{subscriber.name}'")
        this.removeSubscriber(subscriber.name)
      } else {
        throw new Exception($"Subscriber '{subscriber.name}' for store item '{this.name}' already exists")
      }
    }
    this.subscribers.add(subscriber)

    ///@description Notify all subscribers
    this.set(this.get())
    return this
  }

  ///@param {String} name
  ///@return {?StoreItemSubscriber}
  static getSubscriber = function(name) {
    gml_pragma("forceinline")
    return this.subscribers.find(this.findSubscriberByName, name)
  }

  ///@param {String} name
  ///@return {?StoreItemSubscriber}
  static removeSubscriber = function(name) {
    gml_pragma("forceinline")
    var index = this.subscribers.findIndex(this.findSubscriberByName, name)
    if (Core.isType(index, Number)) {
      subscribers.remove(index)
      //Logger.debug("Store", $"Remove subscriber: \{ \"key\": \"{this.name}\", \"subscriber\": \"{name}\" \}")
    }
    return this
  }

  ///@param {String} name
  ///@return {Boolean}
  static containsSubscriber = function(name) {
    gml_pragma("forceinline")
    return Core.isType(this.subscribers
      .find(this.findSubscriberByName, name), StoreItemSubscriber)
  }
}