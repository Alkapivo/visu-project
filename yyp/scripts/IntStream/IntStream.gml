///@package io.alkapivo.core.collection

///@static
function _IntStream() constructor {
  
  ///@param {Number} from
  ///@param {Number} to
  ///@param {Callable} callback
  ///@param {Number} [acc]
  ///@return {NumberUtil}
  static forEach = function(from, to, callback, acc = null) {
    if (from - to > 0) {
      for (var index = from; index >= to; index--) {
        var result = callback(index, from - index, acc)
        if (result == BREAK_LOOP) {
          break
        }
      }
    } else {
      for (var index = from; index < to; index++) {
        var result = callback(index, index - from, acc)
        if (result == BREAK_LOOP) {
          break
        }
      }
    }
    return this
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@param {Callable} callback
  ///@param {Number} [acc]
  ///@return {Array}
  static map = function(from, to, callback, acc = null) {
    var mapped = new Array()
    if (from - to > 0) {
      for (var index = from; index >= to; index--) {
        var result = callback(index, from - index, acc)
        if (result == BREAK_LOOP) {
          break
        }
        mapped.add(result)
      }
    } else {
      for (var index = from; index < to; index++) {
        var result = callback(index, index - from, acc)
        if (result == BREAK_LOOP) {
          break
        }
        mapped.add(result)
      }
    }
    return mapped
  }

  ///@param {Number} from
  ///@param {Number} to
  ///@param {Callable} callback
  ///@param {Number} [acc]
  ///@return {Array}
  static filter = function(from, to, callback, acc = null) {
    var filtered = new Array()
    if (from - to > 0) {
      for (var index = from; index >= to; index--) {
        if (callback(index, from - index, acc)) {
          filtered.add(index)
        }
      }
    } else {
      for (var index = from; index < to; index++) {
        if (callback(index, index - from, acc)) {
          filtered.add(index)
        }
      }
    }
    return filtered
  }
}

global.__IntStream = new _IntStream()
#macro IntStream global.__IntStream
