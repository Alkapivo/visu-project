///@package io.alkapivo.core.collection

///@static
function _Struct() constructor {

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {Boolean}
  static contains = function(struct, key) {
    gml_pragma("forceinline")
    return key != null && is_struct(struct) ? variable_struct_exists(struct, key) : false
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {Boolean}
  static containsType = function(struct, key, type) {
    gml_pragma("forceinline")
    return key != null && is_struct(struct) 
      ? (Struct.getIfType(struct, key, type) != null) :
      false
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {any}
  static get = function(struct, key) {
    gml_pragma("forceinline")
    return key != null && is_struct(struct) ? struct[$ key] : null
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} [defaultValue]
  ///@return {any}
  static getDefault = function(struct, key, defaultValue = null) {
    gml_pragma("forceinline")
    return key != null && is_struct(struct) && variable_struct_exists(struct, key)
      ? struct[$ key]
      : defaultValue
  }

  ///@param {?Struct} struct
  ///@param {String} key
  ///@param {Type} type
  ///@param {any} [defaultValue]
  ///@return {any}
  static getIfType = function(struct, key, type, defaultValue = null) {
    gml_pragma("forceinline")
    var value = Struct.get(struct, key)
    return Core.isType(value, type) ? value : defaultValue
  }

  ///@param {?Struct} struct
  ///@param {String} key
  ///@param {Type} type
  ///@param {any} [defaultValue]
  ///@return {any}
  static getIfEnum = function(struct, key, type, defaultValue = null) {
    gml_pragma("forceinline")
    var value = Struct.get(struct, key)
    return Core.isEnum(value, type) ? value : defaultValue
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} value
  ///@return {?Struct}
  static inject = function(struct, key, value) {
    gml_pragma("forceinline")
    return Struct.contains(struct, key)
      ? Struct.get(struct, key) 
      : Struct.get(Struct.set(struct, key, value), key)
  }

  ///@param {?Struct} struct
  ///@return {?GMArray}
  static keys = function(struct) {
    gml_pragma("forceinline")
    return is_struct(struct) ? variable_struct_get_names(struct) : null
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@param {any} value
  ///@return {?Struct}
  static set = function(struct, key, value) {
    gml_pragma("forceinline")
    if (key != null && is_struct(struct)) {
      variable_struct_set(struct, key, value)
    }

    return struct
  }

  ///@param {?Struct} struct
  ///@return {Number}
  static size = function(struct) {
    gml_pragma("forceinline")
    return is_struct(struct) ? variable_struct_names_count(struct) : 0
  }

  ///@param {?Struct} struct
  ///@param {any} key
  ///@return {?Struct}
  static remove = function(struct, key) {
    gml_pragma("forceinline")
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
  static forEach = function(struct, callback, acc = null) {
    gml_pragma("forceinline")
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
  static filter = function(struct, callback, acc = null) {
    gml_pragma("forceinline")
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
  static map = function(struct, callback, acc = null) {
    gml_pragma("forceinline")
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
  static find = function(struct, callback, acc = null) {
    gml_pragma("forceinline")
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
  static findKey = function(callback, acc = null) {
    gml_pragma("forceinline")
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
  static toMap = function(struct, keyType = any, valueType = any, callback = null, acc = null) {
    gml_pragma("forceinline")
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
  static toArray = function(struct, callback, acc = null) {
    gml_pragma("forceinline")
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
  static appendField = function(source, key, value, bind = true) {
    var struct = Core.isType(source, Struct) ? source : {}
    var _value = bind ? (Core.isType(value, BindIntent) ? value.bind(struct) : value) : value
    Struct.set(struct, key, _value)
    return struct
  }

  ///@param {?Struct} [source]
  ///@param {?Struct} [json]
  ///@param {Boolean} [bind]
  ///@return {Struct}
  static append = function(source = null, json = null, bind = true) {
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
  static appendRecursive = function(source = null, json = null, bind = true) {
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
  static appendUniqueField = function(source, key, value, bind = true) {
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
  static appendUnique = function(source = null, json = null, bind = true) {
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
  static appendRecursiveUnique = function(source = null, json = null, bind = true) {
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

  serialize = function(struct) {
    static serializeField = function(value) {
      return Optional.is(Struct.getIfType(value, "serialize", Callable))
        ? value.serialize() 
        : value
    }

    return Struct.map(struct, serializeField)
  }

  ///@type {Struct}
  static parse = {
    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Boolean} defaultValue
    ///@return {Boolean}
    boolean: function(struct, key, defaultValue = null) {
      return Struct.getIfType(struct, key, Boolean, defaultValue == true)
    },
  
    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?String} defaultValue
    ///@return {Color}
    color: function(struct, key, defaultValue = null) {
      return ColorUtil.parse(Struct.get(struct, key), defaultValue)
    },
  
    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Number} defaultValue
    ///@param {?Number} clampFrom
    ///@param {?Number} clampTo
    ///@return {Number}
    number: function(struct, key, defaultValue = null, clampFrom = null, clampTo = null) {
      var value = Struct.getIfType(struct, key, Number)
      if (!Optional.is(value)) {
        value = Core.isType(defaultValue, Number) ? defaultValue : 0.0
      }
  
      return (Core.isType(clampFrom, Number) && Core.isType(clampTo, Number))
        ? clamp(value, clampFrom, clampTo)
        : value
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Number} defaultValue
    ///@param {?Number} clampFrom
    ///@param {?Number} clampTo
    ///@return {Number}
    integer: function(struct, key, defaultValue = null, clampFrom = null, clampTo = null) {
      var value = Struct.getIfType(struct, key, Number)
      if (!Optional.is(value)) {
        value = Core.isType(defaultValue, Number) ? defaultValue : 0.0
      }
  
      return toInt((Core.isType(clampFrom, Number) && Core.isType(clampTo, Number))
        ? clamp(value, clampFrom, clampTo)
        : value)
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?String} defaultValue
    ///@return {String}
    text: function(struct, key, defaultValue = null) {
      return Struct.getIfType(struct, key, String, (Core
        .isType(defaultValue, String) ? defaultValue : ""))
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Number} defaultValue
    ///@return {Number}
    normalizedNumber: function(struct, key, defaultValue = null) {
      return Struct.parse.number(struct, key, defaultValue, 0.0, 1.0)
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Struct} defaultValue
    ///@return {Rectangle}
    rectangle: function(struct, key, defaultValue = null) {
      var _struct = Struct.get(struct, key)
      var data = {
        x: Struct.getIfType(_struct, "x", Number, Struct.getIfType(defaultValue, "x", Number, 0.0)),
        y: Struct.getIfType(_struct, "y", Number, Struct.getIfType(defaultValue, "y", Number, 0.0)),
        width: Struct.getIfType(_struct, "width", Number, Struct.getIfType(defaultValue, "width", Number, 0.0)),
        height: Struct.getIfType(_struct, "height", Number, Struct.getIfType(defaultValue, "height", Number, 0.0)),
      }

      if (Optional.is(Struct.getIfType(defaultValue, "clampX", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampX, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampX, "to", Number))) {
        data.x = clamp(data.x, defaultValue.clampX.from, defaultValue.clampX.to)
      }
      
      if (Optional.is(Struct.getIfType(defaultValue, "clampY", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampY, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampY, "to", Number))) {
        data.y = clamp(data.y, defaultValue.clampY.from, defaultValue.clampY.to)
      }
  
      if (Optional.is(Struct.getIfType(defaultValue, "clampWidth", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampWidth, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampWidth, "to", Number))) {
        data.width = clamp(data.width, defaultValue.clampWidth.from, defaultValue.clampWidth.to)
      }
  
      if (Optional.is(Struct.getIfType(defaultValue, "clampHeight", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampHeight, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampHeight, "to", Number))) {
        data.height = clamp(data.height, defaultValue.clampHeight.from, defaultValue.clampHeight.to)
      }

      return new Rectangle(data)
    },
  
    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Struct} defaultValue
    ///@return {NumberTransformer}
    numberTransformer: function(struct, key, defaultValue = null) {
      var _struct = Struct.get(struct, key)
      var data = {
        value: Struct.getIfType(_struct, "value", Number, Struct.getIfType(defaultValue, "value", Number, 0.0)),
        target: Struct.getIfType(_struct, "target", Number, Struct.getIfType(defaultValue, "target", Number, 0.0)),
        factor: Struct.getIfType(_struct, "factor", Number, Struct.getIfType(defaultValue, "factor", Number, 0.0)),
        increase: Struct.getIfType(_struct, "increase", Number, Struct.getIfType(defaultValue, "increase", Number, 0.0)),
      }

      if (Optional.is(Struct.getIfType(defaultValue, "clampValue", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampValue, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampValue, "to", Number))) {
        data.value = clamp(data.value, defaultValue.clampValue.from, defaultValue.clampValue.to)
      }
      
      if (Optional.is(Struct.getIfType(defaultValue, "clampTarget", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampTarget, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampTarget, "to", Number))) {
        data.target = clamp(data.target, defaultValue.clampTarget.from, defaultValue.clampTarget.to)
      }
  
      if (Optional.is(Struct.getIfType(defaultValue, "clampFactor", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampFactor, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampFactor, "to", Number))) {
        data.target = clamp(data.target, defaultValue.clampFactor.from, defaultValue.clampIncrease.to)
      }
  
      if (Optional.is(Struct.getIfType(defaultValue, "clampIncrease", Struct))
          && Optional.is(Struct.getIfType(defaultValue.clampIncrease, "from", Number))
          && Optional.is(Struct.getIfType(defaultValue.clampIncrease, "to", Number))) {
        data.increase = clamp(data.increase, defaultValue.clampIncrease.from, defaultValue.clampIncrease.to)
      }
  
      return new NumberTransformer(data)
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Struct} defaultValue
    ///@return {NumberTransformer}
    normalizedNumberTransformer: function(struct, key, defaultValue = null) {
      var _defaultValue = Core.isType(defaultValue, Struct) ? defaultValue : { }
      Struct.set(_defaultValue, "clampValue", { from: 0.0, to: 1.0 })
      Struct.set(_defaultValue, "clampTarget", { from: 0.0, to: 1.0 })
      return Struct.parse.numberTransformer(struct, key, _defaultValue)
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {Array} array
    ///@param {any} defaultValue
    ///@return {any}
    arrayValue: function(struct, key, array, defaultValue = null) {
      if (!Core.isType(array, Array)) {
        Logger.warn("Struct.parse.arrayValue()", "array argument must be of type Array")
        return defaultValue
      }
  
      var value = Struct.get(struct, key)
      return array.contains(value) ? value : defaultValue
    },
  
    ///@param {Struct} struct
    ///@param {String} key
    ///@param {GMArray} gmArray
    ///@param {any} defaultValue
    ///@return {any}
    gmArrayValue: function(struct, key, gmArray, defaultValue = null) {
      if (!Core.isType(gmArray, GMArray)) {
        Logger.warn("Struct.parse.gmArrayValue()", "gmArray argument must be of type GMArray")
        return defaultValue
      }
  
      var value = Struct.get(struct, key)
      return GMArray.contains(gmArray, value) ? value : defaultValue
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Struct} defaultValue
    ///@return {Struct}
    stringStruct: function(struct, key, defaultValue = null) {
      var value = JSON.parse(Struct.get(struct, key))
      return Optional.is(value)
        ? value
        : (Core.isType(defaultValue, Struct) ? defaultValue : { })
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {?Struct} defaultValue
    ///@return {Sprite}
    sprite: function(struct, key, defaultValue = null) {
      var _defaultValue = Optional.is(Struct.getIfType(defaultValue, "name", String))
        ? defaultValue
        : { name: "texture_missing" }

      var sprite = SpriteUtil.parse(Struct.get(struct, key), _defaultValue)
      return Core.isType(sprite, Sprite) 
        ? sprite
        : new Sprite(new Texture(texture_missing))
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {Enum} type
    ///@param {any} [defaultValue]
    ///@return {any}
    enumerable: function(struct, key, type, defaultValue = null) {
      var enumKey = Struct.get(struct, key)
      return type.containsKey(enumKey) ? type.get(enumKey) : defaultValue
    },

    ///@param {Struct} struct
    ///@param {String} key
    ///@param {Enum} type
    ///@param {any} [defaultValue]
    ///@return {any}
    enumerableKey: function(struct, key, type, defaultValue = null) {
      var enumKey = Struct.get(struct, key)
      return type.containsKey(enumKey) ? enumKey : type.getKey(defaultValue)
    },
  }
}
global.__Struct = new _Struct()
#macro Struct global.__Struct
