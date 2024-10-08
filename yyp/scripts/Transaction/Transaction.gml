///@package io.alkapivo.core.service.transaction

///@param {Struct} config
function Transaction(config) constructor {

  ///@param {String}
  name = Assert.isType(config.name, String)

  ///@type {any}
  data = Struct.getDefault(config, "data", null)

  ///@return {Transaction}
  apply = method(this, Assert.isType(config.apply, Callable))

  ///@return {Transaction}
  rollback = method(this, Assert.isType(config.rollback, Callable))

  Struct.appendUnique(this, config)
}