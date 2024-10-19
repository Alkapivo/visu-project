///@package io.alkapivo.core.collection

///@static
function _Struct() constructor {

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {Boolean}
  contains = function(struct, key) {
    return key != null && is_struct(struct) ? variable_struct_exists(struct, key) : false
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {any}
  get = function(struct, key) {
    return key != null && is_struct(struct) ? variable_struct_get(struct, key) : null
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} [defaultValue]
  ///@return {any}
  getDefault = function(struct, key, defaultValue = null) {
    return key != null && is_struct(struct) && variable_struct_exists(struct, key)
      ? variable_struct_get(struct, key)
      : defaultValue
  }

  ///@param {?Struct} struct
  ///@param {String} key
  ///@param {Type} type
  ///@param {any} [defaultValue]
  ///@return {any}
  getIfType = function(struct, key, type, defaultValue = null) {
    var value = Struct.get(struct, key)
    return Core.isType(value, type) ? value : defaultValue
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} value
  ///@return {?Struct}
  inject = function(struct, key, value) {
    return Struct.contains(struct, key)
      ? Struct.get(struct, key) 
      : Struct.get(Struct.set(struct, key, value), key)
  }

  ///@param {?Struct} struct
  ///@return {?GMArray}
  keys = function(struct) {
    return is_struct(struct) ? variable_struct_get_names(struct) : null
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} value
  ///@return {?Struct}
  set = function(struct, key, value) {
    if (key != null && is_struct(struct)) {
      variable_struct_set(struct, key, value)
    }
    return struct
  }

  ///@param {?Struct} struct
  ///@return {Number}
  size = function(struct) {
    return is_struct(struct) ? variable_struct_names_count(struct) : 0
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {?Struct}
  remove = function(struct, key)  {
    if (Struct.contains(struct, key)) {
      variable_struct_remove(struct, key)
    }
    return struct
  }
  
  ///@override
  ///@param {Struct} struct
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Struct}
  forEach = function(struct, callback, acc = null) {
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      var item = Struct.get(struct, key)
      callback(item, key, acc)
    }
    return this
  }

  ///@override
  ///@param {Struct} struct
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Struct}
  filter = function(struct, callback, acc = null) {
    var filtered = {}
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      var item = Struct.get(struct, key)
      if (callback(item, key, acc)) {
        Struct.set(filtered, key, item)
      }
    }
    return filtered
  }

  ///@override
  ///@param {Struct} struct
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Struct}
  map = function(struct, callback, acc = null) {
    var mapped = {}
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      var item = Struct.get(struct, key)
      Struct.set(mapped, key, callback(item, key, acc))
    }
    return mapped
  }

  ///@override
  ///@param {Struct} struct
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  find = function(struct, callback, acc = null) {
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      var item = Struct.get(struct, key)
      if (callback(item, key, acc)) {
        return item
      }
    }
    return null
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  findKey = function(callback, acc = null) {
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      if (callback(Struct.get(struct, key), key, acc)) {
        return key
      }
    }
    return null
  }

  ///@param {Struct} struct
  ///@param {Type} [keyType]
  ///@param {Type} [valueType]
  ///@param {?Callable} [callback]
  ///@param {any} [acc]
  ///@return {Map}
  toMap = function(struct, keyType = any, valueType = any, callback = null, acc = null) {
    var map = new Map(keyType, valueType)
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    if (!Core.isType(callback, Callable)) {
      for (var index = 0; index < size; index++) {
        var key = keys[index]
        var item = Struct.get(struct, key)
        map.set(key, item)
      }
    } else {
      for (var index = 0; index < size; index++) {
        var key = keys[index]
        var item = Struct.get(struct, key)
        map.set(key, callback(item, key, acc))
      }
    }
    return map
  }

  ///@param {Struct} struct
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Array}
  toArray = function(struct, callback, acc = null) {
    var keys = Struct.keys(struct)
    var size = GMArray.size(keys)
    var arr = GMArray.create(any, size)
    for (var index = 0; index < size; index++) {
      var key = keys[index]
      var item = Struct.get(struct, key)
      arr.set(index, callback(item, index, acc))
    }
    return arr
  }

  ///@param {?Struct} source
  ///@param {any} key
  ///@param {any} value
  ///@param {Boolean} [bind]
  ///@return {Struct}
  appendField = function(source, key, value, bind = true) {
    var struct = Core.isType(source, Struct) ? source : {}
    var _value = bind ? (Core.isType(value, BindIntent) ? value.bind(struct) : value) : value
    Struct.set(struct, key, _value)
    return struct
  }

  ///@param {?Struct} [source]
  ///@param {?Struct} [json]
  ///@param {Boolean} [bind]
  ///@return {Struct}
  append = function(source = null, json = null, bind = true) {
    static _append = function(value, key, data) {
      Struct.appendField(data.source, key, value, data.bind)
    }

    var struct = Core.isType(source, Struct) ? source : {}
    if (Core.isType(json, Struct)) {
      Struct.forEach(json, _append, { source: struct, bind: bind })
    }
    return struct
  }

  ///@param {?Struct} [source]
  ///@param {?Struct} [json]
  ///@param {Boolean} [bind]
  ///@return {Struct}
  appendRecursive = function(source = null, json = null, bind = true) {
    static append = function(value, key, data) {
      if (Core.isType(value, Struct)) {
        if (Core.hasConstructor(value)) {
          Struct.set(data.source, key, value)
        } else {
          Struct.set(data.source, key, Struct
            .appendRecursive(Struct
            .inject(data.source, key, {}), value, data.bind))
        }
      } else {
        Struct.appendField(data.source, key, value, data.bind)
      }
    }

    var struct = Core.isType(source, Struct) ? source : {}
    if (Core.isType(json, Struct)) {
      Struct.forEach(json, append, { source: struct, bind: bind })
    }
    return struct
  }

  ///@param {?Struct} source
  ///@param {any} key
  ///@param {any} value
  ///@param {Boolean} [bind]
  ///@return {Struct}
  appendUniqueField = function(source, key, value, bind = true) {
    var struct = Core.isType(source, Struct) ? source : {}
    if (!Struct.contains(struct, key)) {
      this.appendField(struct, key, value, bind)
    }
    return struct
  }

  ///@param {?Struct} [source]
  ///@param {?Struct} [json]
  ///@param {Boolean} [bind]
  ///@return {Struct}
  appendUnique = function(source = null, json = null, bind = true) {
    static append = function(value, key, data) {
      Struct.appendUniqueField(data.source, key, value, data.bind)
    }

    var struct = Core.isType(source, Struct) ? source : {}
    if (Core.isType(json, Struct)) {
      Struct.forEach(json, append, { source: struct, bind: bind })
    }
    return struct
  }

  ///@param {?Struct} [source]
  ///@param {?Struct} [json]
  ///@param {Boolean} [bind]
  ///@return {Struct}
  appendRecursiveUnique = function(source = null, json = null, bind = true) {
    static append = function(value, key, data) {
      if (Core.isType(value, Struct)) {
        if (Core.hasConstructor(value)) {
          Struct.set(data.source, key, value)
        } else {
          Struct.set(data.source, key, Struct
            .appendRecursiveUnique(Struct
            .inject(data.source, key, {}), value, data.bind))
        }
      } else {
        Struct.appendUniqueField(data.source, key, value, data.bind)
      }
    }

    var struct = Core.isType(source, Struct) ? source : {}
    if (Core.isType(json, Struct)) {
      Struct.forEach(json, append, { source: struct, bind: bind })
    }
    return struct
  }
}
global.__Struct = new _Struct()
#macro Struct global.__Struct
