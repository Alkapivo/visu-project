///@package io.alkapivo.core.service.texture
show_debug_message("init Texture.gml")

#macro GMTexture "GMTexture"

///@param {GMTexture} _asset
///@param {?Struct} [config]
function Texture(_asset, config = null) constructor {

  ///@final
  ///@type {GMTexture}
  asset = Assert.isType(_asset, GMTexture)

  ///@final
  ///@type {String}
  name = Assert.isType(Struct.contains(config, "name")
    ? config.name
    : sprite_get_name(this.asset), String)

  ///@final
  ///@type {Number}
  width = Assert.isType(sprite_get_width(this.asset), Number)

  ///@final
  ///@type {Number}
  height = Assert.isType(sprite_get_height(this.asset), Number)
  
  ///@final
  ///@type {Number}
  frames = Assert.isType(sprite_get_number(this.asset), Number)

  ///@type {Number}
  speed = Assert.isType(Struct.getDefault(config, "speed",
    sprite_get_speed(this.asset)), Number)

  ///@type {Number}
  offsetX = sprite_get_xoffset(this.asset)

  ///@type {Number}
  offsetY = sprite_get_yoffset(this.asset)

  ///@param {Number} x
  ///@param {Number} y
  ///@param {Number} [frame]
  ///@param {Number} [scaleX]
  ///@param {Number} [scaleY]
  ///@param {Number} [alpha]
  ///@param {Number} [angle]
  ///@param {Color} [blend]
  ///@return {Texture}
  static render = function(x, y, frame = 0, scaleX = 1, scaleY = 1, alpha = 1, angle = 0, blend = c_white) {
    draw_sprite_ext(
      this.asset, frame, 
      x, y, 
      scaleX, scaleY, 
      angle, blend, alpha
    )
    return this
  }
}


///@param {String} _name
///@param {Struct} json
function TextureTemplate(_name, json) constructor {
  
  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {GMTexture}
  asset = Assert.isType(json.asset, GMTexture)

  ///@type {String}
  file = Assert.isType(json.file, String)

  ///@type {Number}
  frames = Assert.isType(Struct.getDefault(json, "frames", 1), Number)

  ///@type {Number}
  originX = Assert.isType(Struct.getDefault(json, "originX", sprite_get_xoffset(this.asset)), Number)

  ///@type {Number}
  originY = Assert.isType(Struct.getDefault(json, "originY", sprite_get_yoffset(this.asset)), Number)

  ///@type {Boolean}
  prefetch = Assert.isType(Struct.getDefault(json, "prefetch", true), Boolean)
  
  sprite_set_offset(this.asset, this.originX, this.originY)
  ///@return {Struct}
  serialize = function() {
    var template = this
    var acc = {
      template: template,
      json: {},
    }
    
    GMArray.forEach(Struct.keys(this), function(field, index, acc) {
      if (field == "asset" || field == "serialize") {
        return
      }
      
      var value = Struct.get(acc.template, field)
      if (Optional.is(value)) {
        value = field == "file" 
          ? (value == "" ? value : FileUtil.getFilenameFromPath(value)) 
          : value
        Struct.set(acc.json, field, value)
      }
    }, acc)
     
    return acc.json
  }
}


///@param {Struct} json
function TextureIntent(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {String}
  file = Assert.isType(json.file, String)

  ///@type {Number}
  frames = Assert.isType(Struct.getDefault(json, "frames", 1), Number)

  ///@type {Number}
  originX = Assert.isType(Struct.getDefault(json, "originX", 0), Number)

  ///@type {Number}
  originY = Assert.isType(Struct.getDefault(json, "originY", 0), Number)

  ///@type {Boolean}
  prefetch = Assert.isType(Struct.getDefault(json, "prefetch", true), Boolean)
}

///@static
function _TextureUtil() constructor {

  ///@param {?String} name
  ///@return {Boolean}
  exists = function(name) {
    var textureService = Beans.get(BeanTextureService)
    if (Optional.is(textureService) 
      && Optional.is(textureService.templates.get(name))) {
      return true
    }

    return Core.isType(name, String) 
      && Core.isType(asset_get_index(name), GMTexture)
  }

  ///@param {String} name
  ///@param {?Struct} [config]
  ///@return {?Texture}
  parse = function(name, config = null) {
    if (!Core.isType(name, String)) {
      Logger.warn("TextureUtil", $"parse method invoked with non string name")
      return null
    }

    var textureService = Beans.get(BeanTextureService)
    if (Optional.is(textureService) && !Struct.getDefault(config, "disableTextureService", false)) {
      var template = textureService.getTemplate(name)
      if (Optional.is(template)) {
        return new Texture(template.asset, 
          Optional.is(config) ? config : template)
      }
    }

    var asset = asset_get_index(name)
    if (Core.isType(asset, GMTexture)) {
      return new Texture(asset, config)
    }
    
    Logger.warn("TextureUtil", $"Texture does not exists: '{name}'")
    return null
  }
}
global.__TextureUtil = new _TextureUtil()
#macro TextureUtil global.__TextureUtil
