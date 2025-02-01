///@package io.alkapivo.util

///@param {Struct} config
function JSONModelType(config) constructor {
  
  ///@type {String}
  template = Assert.isType(Struct.get(config, "template"), String)

  ///@param {String} model
  ///@return {Boolean}
  is = method(this, Assert.isType(Struct.getDefault(config, "is", 
    function(model) {
      return model == String.template(this.template, this.getTypeFullName(model))
        && this.getType(model) != null
    }), Callable))

  ///@param {String} model
  ///@return {?Type}
  getType = method(this, Assert.isType(Struct.getDefault(config, "getType", 
    function(model) {
      return Core.getConstructor(this.getTypeName(model))
    }), Callable))

  ///@param {String} model
  ///@return {String}
  getTypeName = method(this, Assert.isType(Struct.getDefault(config, "getTypeName", 
    function(model) {
      return String.split(this.getTypeFullName(model), ".").getLast()
    }), Callable))

  ///@param {String} model
  ///@return {String}
  getTypeFullName = method(this, Assert.isType(Struct.getDefault(config, "getTypeFullName", 
    function(model) {
      return model
    }), Callable))

  ///@param {any} data
  ///@return {any}
  getData = method(this, Assert.isType(Struct.get(config, "getData"), Callable))

  ///@param {Callable} callback
  ///@param {any} [acc]
  next = method(this, Assert.isType(Struct.get(config, "next"), Callable))
}

///@param {Struct} json
function JSONModelParser(json) constructor {

  ///@private
  ///@param {String} model
  findModelType = function(model) {
    types = new Map(String, JSONModelType, {
      "Struct": new JSONModelType({
        template: "{0}",
        getData: function(data) {
          return Core.isType(data, Struct) ? data : null
        },
        next: function(callback, acc = null) {
          if (this.parsed) {
            return
          }
          //callback(new this.prototype(this.data), 0, acc)
          callback(this.prototype, this.data, 0, acc)
          this.parsed = true
        },
      }),
      "Collection": new JSONModelType({ 
        template: "Collection<{0}>",
        getTypeFullName: function(model) {
          return new StringBuilder(model)
            .replace("Collection", "")
            .replace("<", "")
            .replace(">", "")
            .get()
        },
        getData: function(data) {
          if (Core.isType(data, Struct)) {
            return new Map(any, any, data)
          } 
          
          if (Core.isType(data, GMArray)) {
            return new Array(any, data)
          }

          throw new Exception("Unsupported data type")
        },
        next: function(callback, acc = null) {
          static nextMap = function(context, callback, acc) {
            if (context.parsed) {
              return context
            }

            var keys = context.data.keys()
            var size = keys.size()
            if (size == 0) {
              context.parsed = true
              return context
            }

            if (context.pointer == null) {
              context.pointer = 0
            }

            var key = keys.get(context.pointer)
            var json = context.data.get(key)
            callback(context.prototype, json, key, acc)
            if (context.pointer == size - 1) {
              context.parsed = true
            } else {
              context.pointer++
            }

            return context
          }

          static nextArray = function(context, callback, acc) {
            if (context.parsed) {
              return context
            }

            var size = context.data.size()
            if (size == 0) {
              context.parsed = true
              return context
            }

            if (context.pointer == null) {
              context.pointer = 0
            }

            var index = context.pointer
            var json = context.data.get(index)
            callback(context.prototype, json, index, acc)
            if (context.pointer == size - 1) {
              context.parsed = true
            } else {
              context.pointer++
            }

            return context
          }

          if (Core.isType(this.data, Map)) {
            return nextMap(this, callback, acc)
          }
          
          if (Core.isType(this.data, Array)) {
            return nextArray(this, callback, acc)
          }
          
          throw new Exception("Unsupported data type")
        }
      })
    })

    static findType = function(type, name, model) {
      return type.is(model)
    }

    return types.filter(findType, model).getFirst()
  }

  ///@type {String}
  model = Assert.isType(Struct.get(json, "model"), String)
  
  ///@private
  ///@type {JSONModelType}
  modelType = Assert.isType(this.findModelType(this.model), JSONModelType)

  ///@type {Type}
  prototype = Assert.isType(this.modelType.getType(this.model), NonNull)

  ///@type {NonNull}
  data = Assert.isType(this.modelType.getData(Struct.get(json, "data")), NonNull)

  ///@type {Boolean}
  parsed = false

  ///@private
  ///@type {?String|Number}
  pointer = null

  ///@param {any} [context]
  next = method(this, Assert.isType(Struct.get(this.modelType, "next"), Callable))

  ///@param {Callable} callback(item, idx, acc)
  ///@param {any} [acc]
  ///@return {JSONModelParser}
  parse = function(callback, acc = null) {
    if (this.parsed) {
      return this
    }
    this.next(callback, acc)
    return this
  }
}

function _JSON() constructor {

  ///@param {String} text
  ///@return {?Struct|?Array|?String|?Number|?Boolean}
  parse = function(text) {
    var result = null
    try {
      result = json_parse(text)
      if (Core.isType(result, GMArray)) {
        result = new Array(any, result)
      }
    } catch (exception) {
      Logger.error("JSON.parse()", exception.message)
    }
    
    return result
  }

  ///@param {any} object
  ///@param {?Struct} [config]
  ///@return {?String}
  stringify = function(object, config = null) {
    var result = null
    try {
      result = json_stringify(object, Struct.getDefault(config, "pretty", false))
    } catch (exception) {
      Logger.error("JSON", exception.message)
    }
    return result
  }

  ///@param {Struct} object
  ///@param {?Struct} [config]
  ///@return {?Struct|?GMArray|?String|?Number|?Boolean}
  clone = function(object, config = null) {
    return this.parse(this.stringify(object, config))
  }

  ///@param {String} json
  ///@param {Struct} config
  ///@return {Task}
  parserTask = function(json, config) {
    return new Task("parse-json-model")
      .setPromise(new Promise())
      .setState(new Map(String, any, {
        parser: new JSONModelParser(JSON.parse(json)),
        callback: Assert.isType(Struct.get(config, "callback"), Callable),
        acc: Struct.get(config, "acc"),
        steps: Assert.isType(Struct.getDefault(config, "steps", 1000), Number),
      }))
      .whenUpdate(function() {
        var parser = this.state.get("parser")
        var callback = this.state.get("callback")
        var acc = this.state.get("acc")
        var steps = this.state.get("steps")
        for (var step = 0; step < steps; step++) {
          if (parser.parse(callback, acc).parsed) {
            break
          }
        }

        if (parser.parsed) {
          this.fullfill()
        }
      })
  }
}
global.__JSON = new _JSON()
#macro JSON global.__JSON


