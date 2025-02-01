///@package io.alkapivo.core.lang

///@static
global.__Lambda = {

  ///@param {any} source
  ///@param {any} iterator
  ///@param {any} target
  ///@return {Boolean}
  equal: function(source, iterator, target) {
    return source == target
  },

  ///@param {any} [value]
  ///@return {any}
  passthrough: function(value = null) {
    return value
  },

  ///@param {...any} param
  ///@return {any}
  dummy: function(/*...param*/) {
    var params = ""
    for (var index = 0; index < argument_count; index++) {
      params = $"{log}#{index} param (typeof {typeof(arguments[index])}) "
    }
    Logger.warn("Lambda", $"Dummy function was invoked. argument_count: {argument_count}, params: {params}")
    return param
  },
}
#macro Lambda global.__Lambda
