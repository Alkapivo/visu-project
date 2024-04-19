///@package io.alkapivo.visu.editor.service.brush

///@param {Struct} json
function VEBrushTemplate(json) constructor {
  
  ///@type {String}
  name = Assert.isType(json.name, String)
  
  ///@type {VEBrushType}
  type = Assert.isEnum(json.type, VEBrushType)
  
  ///@type {String}
  color = Struct.contains(json, "color")
    ? ColorUtil.fromHex(json.color, ColorUtil.WHITE).toHex()
    : "#ffffff"
  
  ///@type {String}
  texture = Struct.contains(json, "texture")
    ? Assert.isType(json.texture, String)
    : BRUSH_TEXTURES[0]
  Assert.isTrue(GMArray.contains(BRUSH_TEXTURES, this.texture))
  
  ///@type {?Struct}
  properties = Struct.contains(json, "properties")
    ? Assert.isType(json.properties, Struct)
    : null

  ///@return {Struct}
  static toStruct = function() {
    var struct = {
      name: this.name,
      type: this.type,
      texture: this.texture,
      color: this.color,
    }

    if (Optional.is(this.properties)) {
      Struct.set(struct, "properties", this.properties)
    }

    return struct
  }
}
