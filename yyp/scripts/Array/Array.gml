///@package io.alkapivo.core.collection

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
  _forEachWrapper = function(value, index) {
    this._callback(value, index, this._acc)
  }

  ///@override
  ///@return {Number}
  static size = function() {
    return array_length(this.container)
  }

  ///@param {Number} index
  ///@return {Array}
  static remove = function(index) {
    array_delete(this.container, index, 1)
    return this
  }

  ///@param {Number} index
  ///@return {any}
  static get = function(index) {
    return this.container[index]
  }

  ///@param {Number} index
  ///@return {Array}
  static set = function(index, value) {
    Assert.isType(value, this.type)
    this.container[index] = value
    return this
  }
  
  ///@param {any} item
  ///@param {Number} [index]
  ///@return {Array}
  static add = function(item, index = null) {
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

  ///@param {String} delimiter
  ///@return {String}
  static join = function(delimiter) {
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
    return this.size() > 0 ? this.get(0) : null
  }

  ///@return {any}
  static getLast = function() {
    var size = this.size()
    return size > 0 ? this.get(size - 1) : null
  }

  ///@param {Number} indexA
  ///@param {Number} indexB
  ///@return {Array}
  static swapItems = function(indexA, indexB) {
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

  ///@param {Collection} keys
  ///@return {Array}
  static removeMany = function(keys) {
    static setToNull = function(index, gcIndex, array) {
      array.set(index, null)
    }

    var size = this.size()
    if (size == 0) {
      return this
    }

    var type = this.type
    this.type = any
    keys.forEach(setToNull, this)
    for (var index = size - 1; index >= 0; index--) {
      if (this.get(index) == null) {
        this.remove(index)
      }
    }
    this.type = type
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
    return this.container
  }

  ///@param {GMArray} container
  ///@return {Array}
  static setContainer = function(container) {
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

    return GMArray.toMap(this.container, keyType, valueType, valueCallback, 
      acc, keyCallback)
  }

  ///@param {?Callable} [valueCallback]
  ///@param {any} [acc]
  ///@param {?Callable} [keyCallback]
  ///@return {Struct}
  static toStruct = function(valueCallback = null, acc = null, keyCallback = null) {
    return GMArray.toStruct(this.container, keyCallback, acc, valueCallback)
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@return {Array}
  static move = function(from, to) {
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
    this.gc = !Core.isType(this.gc, Stack) ? new Stack(Number) : this.gc
    return this
  }

  ///@return {Array}
  static disableGC = function() {
    this.gc = null
    return this
  }

  ///@type {Number} key
  ///@return {Array}
  static addToGC = function(key) {
    if (!Core.isType(this.gc, Stack)) {
      this.enableGC()
    }
    this.gc.push(key)
    return this
  }

  ///@return {Array}
  static runGC = function() {
    if (!Core.isType(this.gc, Stack) || this.gc.size() == 0) {
      return this
    }

    this.removeMany(this.gc)
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
    return array_length(arr)
  }

	///@param {Type} [type]
	///@param {Number} [size]
	///@param {any} [value]
	///@return {Array}
	static create = function(type = any, size = 0, value = null) {
		return new Array(type, this.createGMArray(size, value))
	}

  ///@param {Number} size
  ///@param {any} [value]
  ///@return {GMArray}
  static createGMArray = function(size, value = null) {
    return array_create(size, value)
  }

  ///@param {GMArray} arr
  ///@param {any} item
  ///@param {Number} [index]
  ///@return {GMArray}
  static add = function(arr, item, index = null) {
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
    array_delete(arr, 0, this.size(arr))
    return arr
  }

  ///@param {GMArray} arr
  ///@param {Callable} callback
  ///@param {any} [acc]
  ///@return {any}
  static find = function(arr, callback, acc = null) {
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
    array_delete(arr, index, 1)
    return arr
  }

  ///@override
  ///@param {GMArray} arr
  ///@param {any} searchItem
  ///@param {Callable} [comparator]
  ///@return {Boolean}
  static contains = function(arr, searchItem, comparator = function(a, b) { return a == b }) {
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
    array_sort(arr, callback)
    return arr
  }
}
global.__GMArray = new _GMArray()
#macro GMArray global.__GMArray
