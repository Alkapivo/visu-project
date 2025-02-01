///@package io.alkapivo.core.service.ui

///@param {Struct} config
///@param {?UIItem} [_context]
function UIStore(config, _context = null) constructor {

  ///@type {?UIItem}
  context = _context != null ? Assert.isType(_context, UIItem) : null

  ///@type {String}
  key = Assert.isType(Struct.get(config, "key"), String)

  ///@return {?StoreItem}
  get = method(this, Assert.isType(Struct.getDefault(config, "get", function() {
    var store = this.getStore()
    if (!Core.isType(store, Store)) {
      return null
    }

    var item = store.get(this.key)
    return Core.isType(item, StoreItem) ? item : null
  }), Callable))

  ///@return {any}
  getValue = method(this, Assert.isType(Struct.getDefault(config, "getValue", function() {
    var item = this.get()
    return Core.isType(item, StoreItem) ? item.get() : null
  }), Callable))

  ///@return {?Store}
  getStore = method(this, Assert.isType(Struct.getDefault(config, "getStore", function() {
    if (this.context == null) {
      return null
    }

    var store = this.context.context.state.get("store")
    return Core.isType(store, Store) ? store : null
  }), Callable))

  ///@param {any} value
  set = method(this, Assert.isType(Struct.getDefault(config, "set", function(value) {
    var item = this.get()
    if (item == null) {
      return 
    }
    item.set(value)
  }), Callable))

  ///@param {any} value
  ///@param {any} data
  callback = method(this, Assert.isType(Struct.getDefault(config, "callback", function(value, data) { 
    Struct.set(data, "value", value) 
  }), Callable))

  subscribe = method(this, Assert.isType(Struct.getDefault(config, "subscribe", function() {
    var context = this.context
    var callback = this.callback
    var item = this.get()
    if (!Core.isType(context, UIItem) 
      || !Core.isType(callback, Callable) 
      || !Core.isType(item, StoreItem) 
      || item.containsSubscriber(context.name)) {
      return
    }
    
    item.addSubscriber({
      name: context.name,
      callback: callback,
      data: context,
    })  
  }), Callable))

  unsubscribe = method(this, Assert.isType(Struct.getDefault(config, "unsubscribe", function() {
    var item = this.get()
    if (!Core.isType(this.context, UIItem) 
      || !Core.isType(this.callback, Callable) 
      || !Core.isType(item, StoreItem) 
      || !item.containsSubscriber(context.name)) {
      return
    }
    
    item.removeSubscriber(context.name)
  }), Callable))
}