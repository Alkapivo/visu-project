///@package io.alkapivo.core.asset

#macro GMFont "GMFont"

///@param {GMFont} _asset
function Font(_asset) constructor {

  ///@type {GMFont}
  asset = Assert.isType(_asset, GMFont)

  ///@type {String}
  name = Assert.isType(font_get_name(this.asset), String)
}


///@static
function _FontUtil() constructor {

  ///@param {Struct} _json
  ///@param {?Struct} [defaultJson]
  ///@return {?Font}
  parse = function(_json, defaultJson = null) {
    var font = null
    try {
      var json = JSON.clone(_json)
      font = Assert.isType(FontUtil.fetch(json.name), Font)
    } catch (exception) {
      Logger.error("FontUtil", $"'parse' fatal error: {exception.message}")
      if (Core.isType(defaultJson, Struct)) {
        Logger.warn("FontUtil", $"'parse' use defaultJson: {JSON.stringify(defaultJson)}")
        font = FontUtil.parse(defaultJson)
      }
    }
    return font
  }

  ///@param {String} name
  ///@return {?Font}
  fetch = function(name) {
    var asset = asset_get_index(name)
    if (!Core.isType(asset, GMFont)) {
      Logger.warn("FontUtil", $"Font does not exists: '{name}'")
      return null
    }
    
    return new Font(asset)
  }
}
global.__FontUtil = new _FontUtil()
#macro FontUtil global.__FontUtil