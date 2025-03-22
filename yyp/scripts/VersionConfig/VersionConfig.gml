///@package io.alkapivo.core.util

///@param {?Struct} [config]
function VersionConfig(config = null) constructor {

  ///@type {Map<String, Struct>}
  current = new Map(String, Struct, Struct.getIfType(config, "current", Struct))
}