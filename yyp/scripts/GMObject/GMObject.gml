///@package io.alkapivo.core.lang

///@type
#macro GMObject "GMObject"

///@static
function _GMObjectUtil() constructor {

  ///@private
  ///@type {Map<String, Struct>}
  bindings = new Map(String, Struct, {
    updateBegin: {
      gmObject: "__updateBegin",
      factoryWrapper: function() {
        return function() {
          this.__context.updateBegin()
        }
      }
    },
    update: {
      gmObject: "__update",
      factoryWrapper: function() {
        return function() {
          this.__context.update()
        }
      }
    },
    render: {
      gmObject: "__render",
      factoryWrapper: function() {
        return function() {
          this.__context.render()
        }
      }
    },
    renderGUI: {
      gmObject: "__renderGUI",
      factoryWrapper: function() {
        return function() {
          this.__context.renderGUI()
        }
      }
    },
    free: {
      gmObject: "__free",
      factoryWrapper: function() {
        return function() {
          this.__context.free()
        }
      }
    },
    onNetworkEvent: {
      gmObject: "__onNetworkEvent",
      factoryWrapper: function() {
        return function() {
          this.__context.onNetworkEvent()
        }
      }
    },
    onTextureLoadedEvent: {
      gmObject: "__onTextureLoadedEvent",
      factoryWrapper: function() {
        return function(event) {
          this.__context.onTextureLoadedEvent(event)
        }
      }
    },
    onSceneEnter: {
      gmObject: "__onSceneEnter",
      factoryWrapper: function() {
        return function() {
          this.__context.onSceneEnter()
        }
      }
    },
    onSceneLeave: {
      gmObject: "__onSceneLeave",
      factoryWrapper: function() {
        return function() {
          this.__context.onSceneLeave()
        }
      }
    },
    gmAlarm0: {
      gmObject: "__gmAlarm0",
      factoryWrapper: function() {
        return function() {
          this.__context.gmAlarm0()
        }
      }
    },
  })

  ///@param {GMObject} gmObject
  ///@param {String} key
  ///@return {Boolean}
  static contains = function(gmObject, key) {
    return Core.isType(gmObject, GMObject)
      ? variable_instance_exists(gmObject, key)
      : false
  }

  ///@param {GMObject} gmObject
  ///@param {String} key
  ///@param {any} [defaultValue]
  ///@return {any}
  static get = function(gmObject, key, defaultValue = null) {
    if (!Core.isType(gmObject, GMObject)) {
      return null
    }

    return GMObjectUtil.contains(gmObject, key)
      ? variable_instance_get(gmObject, key)
      : defaultValue
  }

  ///@param {GMObject} gmObject
  ///@param {String} key
  ///@param {any} value
  ///@return {GMObjectUtil}
  static set = function(gmObject, key, value) {
    if (!Core.isType(gmObject, GMObject)) {
      return
    }

    variable_instance_set(gmObject, key, value)
    return GMObjectUtil
  }

  ///@param {GMObject} gmObject
  ///@param {String} key
  ///@param {any} defaultValue
  ///@return {any}
  static inject = function(gmObject, key, defaultValue) {
    if (!Core.isType(gmObject, GMObject)) {
      return defaultValue
    }

    if (!GMObjectUtil.contains(gmObject, key)) {
      GMObjectUtil.set(gmObject, key, defaultValue)
    }

    return GMObjectUtil.get(gmObject, key)
  }

  ///@param {AssetClass} type
  ///@param {AssetLayer} layerId
  ///@param {Number} [x]
  ///@param {Number} [y]
  ///@param {Struct} [context]
  ///@return {GMObject} gmObject
  static factoryGMObject = function(type, layerId, x = 0.0, y = 0.0, context = null) {
    var gmObject = instance_create_layer(x, y, layerId, type)
    if (Core.isType(context, Struct)) {
      GMObjectUtil.bind(gmObject, context)
    }

    return gmObject
  }

  ///@param {GMObject} gmObject
  ///@return {GMObjectUtil}
  static free = function(gmObject) {
    if (!Core.isType(gmObject, GMObject)) {
      return
    }

    instance_destroy(gmObject)
  }

  ///@param {GMObject} gmObject
  ///@param {Struct} context
  ///@throws {AlreadyBindedException}
  ///@return {GMObjectUtil}
  static bind = function(gmObject, context) {
    static bindWrapper = function(binding, key, acc) {
      if (GMObjectUtil.contains(acc.gmObject, binding.gmObject) 
        && Struct.contains(acc.context, key)) {
        var wrapper = method(acc.gmObject, binding.factoryWrapper())
        GMObjectUtil.set(acc.gmObject, binding.gmObject, wrapper)
      }
    }

    if (Struct.contains(context, "__gmObject")) {
      throw new AlreadyBindedException("GMObject is already binded in context")
    }

    if (GMObjectUtil.get(gmObject, "__context")) {
      throw new AlreadyBindedException("Context is already binded in GMObject")
    }

    Struct.set(context, "__gmObject", gmObject)
    GMObjectUtil.set(gmObject, "__context", context)
    GMObjectUtil.bindings.forEach(bindWrapper, { 
      context: context, 
      gmObject: gmObject 
    })

    return GMObjectUtil
  }

  ///@param {GMObject} gmObject
  ///@return {GMObjectUtil}
  static unbind = function(gmObject) {
    static unbindWrapper = function(binding, key, acc) {
      if (GMObjectUtil.contains(acc.gmObject, binding.gmObject)) {
        GMObjectUtil.set(acc.gmObject, binding.gmObject, null)
      }
    }

    Struct.set(GMObjectUtil.get(gmObject, "__context"), "__gmObject", null)
    GMObjectUtil.set(gmObject, "__context", null)
    GMObjectUtil.bindings.forEach(unbindWrapper, { gmObject: gmObject })

    return GMObjectUtil
  }

  ///@param {GMObjectType} gmObjectType
  ///@throws {Exception}
  ///@return {String}
  static getTypeName = function(gmObjectType) {
    return Assert.isType(object_get_name(gmObjectType), String)
  }
}
global.__GMObjectUtil = new _GMObjectUtil()
#macro GMObjectUtil global.__GMObjectUtil
