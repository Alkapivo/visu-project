///@package io.alkapivo.core.service

///@interface
///param {?Struct} [config]
function Service(config = null) constructor {

  ///@return {Service}
  update = Struct.contains(config, "update")
    ? method(this, Assert.isType(config.update, Callable))
    : function() { return this }

  ///@return {Service}
  free = Struct.contains(config, "free")
    ? method(this, Assert.isType(config.free, Callable))
    : function() { return this }
}

