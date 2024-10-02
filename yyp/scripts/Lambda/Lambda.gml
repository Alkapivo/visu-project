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
}
#macro Lambda global.__Lambda
