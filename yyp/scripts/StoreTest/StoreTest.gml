///@package io.alkapivo.core.util.store

function StoreTest(): Test() constructor {

  static factoryDefaultStore = function() {
    return new Store({
      "bazyl": {
        type: String,
        value: "BAZYL",
      },
      "baron": {
        type: Number,
        value: 1
      }
    })
  }
  

  name = "Test Store.gml"
  cases = new Array(Struct, [
    {
      name: "findStoreItemByName",
      config: {
        store: factoryDefaultStore(),
      },
      test: function(state) {

      }
    },
    {
      name: "get",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "getValue",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "add",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "contains",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "remove",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "stringify",
      config: {},
      test: function(config) {

      }
    },
    {
      name: "parse",
      config: {},
      test: function(config) {

      }
    }
  ])
}