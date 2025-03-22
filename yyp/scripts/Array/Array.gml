///@package io.alkapivo.core.collection

///@symbol
function __symbol_GC_TARGET_ENTRY() { }
#macro GC_TARGET_ENTRY __symbol_GC_TARGET_ENTRY


///@param {Type} [_type]
///@param {GMArray} [_container]
///@param {?Struct} [config]
function Array(_type = any, _container = null) constructor {

  ///@type {Type}
  type = _type
  
  ///@private
  ///@type {GMArray}
  container = _container != null ? _container : []
  ///@description Cannot use Assert.isType due to initialization order
  if (typeof(this.container) != "array") {
    throw new InvalidAssertException($"Invalid 'Array.container' type: '{typeof(this.container)}'")
  }

  ///@private
  ///@type {?Stack<Number>}
  gc = null

  ///@private
  ///@type {any}
  _acc = null

  ///@private
  ///@type {?Callable}
  _callback = null

  ///@private
  ///@param {Number} index
  ///@param {any} value
  static _forEachWrapper = function(value, index) {
    gml_pragma("forceinline")
    this._callback(value, index, this._acc)
  }

  ///@override
  ///@return {Number}
  static size = function() {
    gml_pragma("forceinline")
    return array_length(this.container)
  }

  ///@param {Number} index
  ///@return {Array}
  static remove = function(index) {
    gml_pragma("forceinline")
    array_delete(this.container, index, 1)
    return this
  }

  ///@param {Number} index
  ///@return {any}
  static get = function(index) {
    gml_pragma("forceinline")
    return this.container[index]
  }

  ///@param {Number} index
  ///@return {Array}
  static set = function(index, value) {
    gml_pragma("forceinline")
    Assert.isType(value, this.type)
    this.container[index] = value
    return this
  }
  
  ///@param {any} item
  ///@param {Number} [index]
  ///@return {Array}
  static add = function(item, index = null) {
    gml_pragma("forceinline")
    if (this.type != null && !Core.isType(item, this.type)) {
      throw new InvalidClassException()
    }
    
    var size = this.size()
    if (size < 32000) { ///@description GML array limitation
      index = index == null ? size : clamp(index, 0, 32000)
      array_insert(this.container, index, item)
    }
    return this
  }

  ///@override
  ///@return {Array}
  static clear = function() {
    gml_pragma("forceinline")
    if (Core.isType(this.gc, Stack)) {
      this.gc.clear()
    }
    
    array_delete(this.container, 0, this.size())
    return this
  }

  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  static find = function(callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size()
    for (var index = 0; index < size; index++) {
      var item = this.container[index]
      if (callback(item, index, acc)) {
        return item
      }
    }
    return null
  }

  ///@param {any} value
  ///@param {any} [acc]
  ///@return {?Number}
  static findIndex = function(callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size()
    for (var index = 0; index < size; index++) {
      var item = this.container[index]
      if (callback(item, index, acc)) {
        return index
      }
    }
    return null
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Array}
  static forEach = function(callback, acc = null) {
    gml_pragma("forceinline")
    this._callback = callback
    this._acc = acc
    array_foreach(this.getContainer(), this._forEachWrapper)
    this._callback = null
    this._acc = null
    return this
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {Array}
  static filter = function(callback, acc = null) {
    gml_pragma("forceinline")
    var filtered = new Array(this.type)
    var size = this.size()
    for (var index = 0; index < size; index++) {
      var item = this.container[index]
      if (callback(item, index, acc)) {
        filtered.add(item)
      }
    }
    return filtered
  }
  
  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@param {?Type} [type]
  ///@return {Array}
  static map = function(callback, acc = null, type = any) {
    gml_pragma("forceinline")
    var mapped = new Array(type)
    var size = this.size()
    for (var index = 0; index < size; index++) {
      var item = this.container[index]
      var result = callback(item, index, acc)
      if (result == BREAK_LOOP) {
        break
      }
      mapped.add(result)
    }
    return mapped
  }

  ///@override
  ///@param {any} searchItem
  ///@param {Callable} [comparator]
  ///@return {Boolean}
  static contains = function(searchItem, comparator = function(a, b) { return a == b }) {
    gml_pragma("forceinline")
    var size = this.size()
    var found = false
    for (var index = 0; index < size; index++) {
      var item = this.container[index]
      if (comparator(item, searchItem)) {
        found = true
        break
      }
    }
    return found
  }

  ///@param {String} [delimiter]
  ///@return {String}
  static join = function(delimiter = ", ") {
    gml_pragma("forceinline")
    var size = this.size()
    var buffer = ""
    if (size > 1) {
      for (var index = 0; index < size; index++) {
        var item = this.container[index]
        buffer = index == size - 1
          ? buffer + item
          : buffer + item + delimiter
      }
    } else {
      buffer = size > 0 ? this.container[0] : ""
    }
    return buffer
  }

  ///@return {any}
  static getFirst = function() {
    gml_pragma("forceinline")
    return this.size() > 0 ? this.get(0) : null
  }

  ///@return {any}
  static getLast = function() {
    gml_pragma("forceinline")
    var size = this.size()
    return size > 0 ? this.get(size - 1) : null
  }

  ///@return {any}
  static getRandom = function() {
    gml_pragma("forceinline")
    var size = this.size()
    if (size == 0) {
      return null
    }

    return this.get(irandom(size - 1))
  }

  ///@param {Number} indexA
  ///@param {Number} indexB
  ///@return {Array}
  static swapItems = function(indexA, indexB) {
    gml_pragma("forceinline")
    var size = this.size()
    if (indexA >= size || indexB >= size) {
      return this //todo throw OutOfBoundary?
    }

    var itemA = this.get(indexA)
    var itemB = this.get(indexB)
    this.set(indexB, itemA)
    this.set(indexA, itemB)
    return this
  }

  ///@param {Collection<Number>} keys
  ///@return {Array}
  static removeMany = function(keys) {
    static setGCTargetEntry = function(index, gcIndex, array) {
      if (array.size() > index) {
        array.container[index] = GC_TARGET_ENTRY
      }
    }

    var size = this.size()
    if (size == 0) {
      return this
    }

    keys.forEach(setGCTargetEntry, this)
    for (var index = size - 1; index >= 0; index--) {
      if (this.container[index] == GC_TARGET_ENTRY) {
        this.remove(index)
      }
    }
    
    return this
  }

  ///@param {Callable} [comparator]
  ///@return {Array}
  static sort = function(comparator) {
    static quickSort = function(arr, low, high, comparator, quickSortRef) {
      static partition = function(arr, low, high, comparator) {
        var pivot = arr[high]
        var acc = 0
        for (var index = 0; index < high; index++) {
          if (comparator(arr[index], pivot)) {
            var temp = arr[acc]
            arr[@ acc++] = arr[index]
            arr[@ index] = temp
          }
        }
        var temp = arr[acc]
        arr[@ acc] = arr[high]
        arr[@ high] = temp
        return acc
      }

      if (low < high) {
        var _partition = partition(arr, low, high, comparator)
        quickSortRef(arr, low, _partition - 1, comparator, quickSortRef)
        quickSortRef(arr, _partition + 1, high, comparator, quickSortRef)
      }
      return arr
    }

    if (this.size() <= 1) {
      return this
    }
    this.setContainer(quickSort(this.container, 0, this.size() - 1, comparator, quickSort))
    return this
  }

  ///@return {GMArray}
  static getContainer = function() {
    gml_pragma("forceinline")
    return this.container
  }

  ///@param {GMArray} container
  ///@return {Array}
  static setContainer = function(container) {
    gml_pragma("forceinline")
    Assert.isTrue((typeof(this.container) == "array"))
    this.container = container
    return this
  }

  ///@param {any} [keyType]
  ///@param {any} [valueType]
  ///@param {?Callable} [valueCallback]
  ///@param {any} [acc]
  ///@param {?Callable} [keyCallback]
  ///@return {Map}
  static toMap = function(keyType = any, valueType = any, valueCallback = null, 
    acc = null, keyCallback = null) {

    gml_pragma("forceinline")
    return GMArray.toMap(this.container, keyType, valueType, valueCallback, 
      acc, keyCallback)
  }

  ///@param {?Callable} [valueCallback]
  ///@param {any} [acc]
  ///@param {?Callable} [keyCallback]
  ///@return {Struct}
  static toStruct = function(valueCallback = null, acc = null, keyCallback = null) {
    gml_pragma("forceinline")
    return GMArray.toStruct(this.container, keyCallback, acc, valueCallback)
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@return {Array}
  static move = function(from, to) {
    gml_pragma("forceinline")
    var size = this.size()
    if (from < 0 || from >= size)
      || (to < 0 || to >= size) {
      return this
    }
    
    var value = this.get(from)
    array_delete(this.getContainer(), from, 1)
    array_insert(this.getContainer(), to, value)
    return this
  }

  ///@return {Array}
  static enableGC = function() {
    gml_pragma("forceinline")
    this.gc = !Core.isType(this.gc, Stack) ? new Stack(Number) : this.gc
    return this
  }

  ///@return {Array}
  static disableGC = function() {
    gml_pragma("forceinline")
    this.gc = null
    return this
  }

  ///@type {Number} index
  ///@return {Array}
  static addToGC = function(index) {
    static sortDesc = function(a, b) {
      return a >= b
    }

    if (!Core.isType(this.gc, Stack)) {
      this.enableGC()
    }

    var last = this.gc.peek()
    if (last == null) {
      this.gc.push(index)
    } else if (last > index) {
      this.gc.push(index)
      this.gc.container = GMArray.sort(this.gc.container, sortDesc)
    } else if (last != index) {
      this.gc.push(index)
    }
    
    return this
  }

  ///@return {Array}
  static runGC = function() {
    static removeIndex = function(index, gcIndex, array) {
      array.remove(index)
    }

    if (this.gc != null && this.gc.size() > 0) {
      this.gc.forEach(removeIndex, this)
    }

    return this
  }
}

///@static
function _GMArray() constructor {
  
  ///@private
  ///@type {any}
  _acc = null

  ///@private
  ///@type {?Callable}
  _callback = null

  ///@private
  ///@param {Number} index
  ///@param {any} value
  _forEachWrapper = function(value, index) {
    this._callback(value, index, this._acc)
  }

  ///@param {GMArray} arr
  ///@return {Number}
  static size = function(arr) {
    gml_pragma("forceinline")
    return array_length(arr)
  }

	///@param {Type} [type]
	///@param {Number} [size]
	///@param {any} [value]
	///@return {Array}
	static create = function(type = any, size = 0, value = null) {
    gml_pragma("forceinline")
		return new Array(type, this.createGMArray(size, value))
	}

  ///@param {Number} size
  ///@param {any} [value]
  ///@return {GMArray}
  static createGMArray = function(size, value = null) {
    gml_pragma("forceinline")
    return array_create(size, value)
  }

  ///@param {GMArray} arr
  ///@param {any} item
  ///@param {Number} [index]
  ///@return {GMArray}
  static add = function(arr, item, index = null) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    if (size < 32000) { ///@description GML array limitation
      index = Core.isType(index, Number)
        ? clamp(index, -31999, 31999)
        : size
      array_insert(arr, index, item)
    }
    return arr
  }

  ///@override
  ///@param {GMArray} arr
  ///@return {GMArray}
  static clear = function(arr) {
    gml_pragma("forceinline")
    array_delete(arr, 0, this.size(arr))
    return arr
  }

  ///@param {GMArray} arr
  ///@param {Number} index
  ///@return {any}
  static get = function(arr, index) {
    gml_pragma("forceinline")
    return index >= 0 && index < this.size(arr) ? arr[index] : null
  }

  ///@param {GMArray} arr
  ///@return {any}
  static getFirst = function(arr) {
    gml_pragma("forceinline")
    return this.get(arr, 0)
  }

  ///@return {any}
  static getLast = function(arr) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    return size > 0 ? this.get(arr, size - 1) : null
  }

  ///@param {GMArray} arr
  ///@return {any}
  static getRandom = function(arr) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    return size > 0 ? this.get(arr, irandom(size - 1)) : null
  }

  ///@param {GMArray} arr
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  static find = function(arr, callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    for (var index = 0; index < size; index++) {
      var item = arr[index]
      if (callback(item, index, acc)) {
        return item
      }
    }
    return null
  }

  ///@param {GMArray} arr
  ///@param {any} value
  ///@param {any} [acc]
  ///@return {?Number}
  static findIndex = function(arr, callback, acc = null) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    for (var index = 0; index < size; index++) {
      var item = arr[index]
      if (callback(item, index, acc)) {
        return index
      }
    }
    return null
  }

  ///@param {GMArray} arr
  ///@param {Number} index
  ///@return {GMArray}
  static remove = function(arr, index) {
    gml_pragma("forceinline")
    array_delete(arr, index, 1)
    return arr
  }

  ///@override
  ///@param {GMArray} arr
  ///@param {any} searchItem
  ///@param {Callable} [comparator]
  ///@return {Boolean}
  static contains = function(arr, searchItem, comparator = function(a, b) { return a == b }) {
    gml_pragma("forceinline")
    var size = this.size(arr)
    var found = false
    for (var index = 0; index < size; index++) {
      var item = arr[index]
      if (comparator(item, searchItem)) {
        found = true
        break
      }
    }
    return found
  }

  ///@param {GMArray} arr
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {GMArray}
  static forEach = function(arr, callback, acc = null) {
    gml_pragma("forceinline")
    this._callback = callback
    this._acc = acc
    array_foreach(arr, this._forEachWrapper)
    this._callback = null
    this._acc = null
    return arr
  }

  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {GMArray}
  static filter = function(arr, callback, acc = null) {
    gml_pragma("forceinline")
    var filtered = []
    var size = this.size(arr)
    for (var index = 0; index < size; index++) {
      var item = arr[index]
      if (callback(item, index, acc)) {
        this.add(filtered, item)
      }
    }
    return filtered
  }
  
  ///@override
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {GMArray}
  static map = function(arr, callback, acc = null) {
    gml_pragma("forceinline")
    var mapped = []
    var size = this.size(arr)
    for (var index = 0; index < size; index++) {
      var item = arr[index]
      var result = callback(item, index, acc)
      if (result == BREAK_LOOP) {
        break
      }
      this.add(mapped, result)
    }
    return mapped
  }

  ///@param {GMArray} arr
  ///@param {Type} [type]
  ///@param {Calllable} [callback]
  ///@param {any} [acc]
  ///@return {Array}
  static toArray = function(arr, type = any, callback = null, acc = null) {
    static passthroughCallback = function(item, index, acc) {
      return item 
    }

    return new Array(type, this.map(arr, (Core.isType(callback, Callable) 
        ? callback 
        : passthroughCallback), 
      acc))
  }

  ///@param {GMArray} arr
  ///@param {Type} [keyType]
  ///@param {Type} [valueType]
  ///@param {?Calllable} [valueCallback]
  ///@param {any} [acc]
  ///@param {?Calllable} [keyCallback]
  ///@return {Map}
  static toMap = function(arr, keyType = any, valueType = any, valueCallback = null, acc = null, keyCallback = null) {
    gml_pragma("forceinline")
    var map = new Map(keyType, valueType)
    var size = this.size(arr)
    var isValueCallback = Core.isType(valueCallback, Callable)
    if (Core.isType(keyCallback, Callable)) {
      if (isValueCallback) {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          map.set(keyCallback(value, index, acc), valueCallback(value, index, acc))
        }
      } else {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          map.set(keyCallback(value, index, acc), value)
        }
      }
    } else {
      if (isValueCallback) {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          map.set($"_{index}", valueCallback(value, index, acc))
        }
      } else {
        for (var index = 0; index < size; index++) {
          map.set($"_{index}", arr[index])
        }
      }
    }
    return map
  }

  ///@param {GMArray} arr
  ///@param {Calllable} [keyCallback]
  ///@param {any} [acc]
  ///@param {Calllable} [valueCallback]
  ///@return {Struct}
  static toStruct = function(arr, keyCallback = null, acc = null, valueCallback = null) {
    gml_pragma("forceinline")
    var struct = {}
    var size = this.size(arr)
    var isValueCallback = Core.isType(valueCallback, Callable)
    if (Core.isType(keyCallback, Callable)) {
      if (isValueCallback) {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          Struct.set(struct, keyCallback(value, index, acc), valueCallback(value, index, acc))
        }
      } else {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          Struct.set(struct, keyCallback(value, index, acc), value)
        }
      }
    } else {
      if (isValueCallback) {
        for (var index = 0; index < size; index++) {
          var value = arr[index]
          Struct.set(struct, $"_{index}", valueCallback(value, index, acc))
        }
      } else {
        for (var index = 0; index < size; index++) {
          Struct.set(struct, $"_{index}", arr[index])
        }
      }
    }
    return struct
  }

  ///@param {GMArray} arr
  ///@param {Callable|Boolean} [callback]
  ///@return {GMArray}
  static sort = function(arr, callback = true) {
    gml_pragma("forceinline")
    array_sort(arr, callback)
    return arr
  }

  ///@param {GMArray|any} value
  ///@return {any}
  static resolveRandom = function(value) {
    gml_pragma("forceinline")
    return Core.isType(value, GMArray) ? GMArray.getRandom(value) : value
  }
}
global.__GMArray = new _GMArray()
#macro GMArray global.__GMArray
