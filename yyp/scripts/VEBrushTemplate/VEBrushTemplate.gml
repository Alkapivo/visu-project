///@package io.alkapivo.visu.editor.service.brush

///@param {Struct} json
function VEBrushTemplate(json) constructor {
  
  ///@type {String}
  name = Assert.isType(json.name, String)
  
  ///@type {VEBrushType}
  type = Assert.isEnum(json.type, VEBrushType)
  
  ///@type {String}
  color = Core.isType(Struct.get(json, "color"), String)
    ? ColorUtil.fromHex(json.color, ColorUtil.WHITE).toHex()
    : "#ffffff"
  
  ///@type {String}
  texture = Core.isType(Struct.get(json, "texture"), String)
    ? json.texture
    : BRUSH_TEXTURES[0]
  Assert.isTrue(GMArray.contains(BRUSH_TEXTURES, this.texture))

  ///@type {?Struct}
  properties = Core.isType(Struct.get(json, "properties"), Struct) 
    ? json.properties
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
