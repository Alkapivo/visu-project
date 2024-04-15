///@package io.alkapivo.core.renderer

#macro TEXT_SEP_DEFAULT 12
#macro TEXT_W_DEFAULT 200
#macro TEXT_XSCALE_DEFAULT 1.0
#macro TEXT_YSCALE_DEFAULT 1.0
#macro TEXT_ANGLE_DEFAULT 0.0
#macro TEXT_COLOR_DEFAULT ColorUtil.WHITE
#macro TEXT_COLOR_OUTLINE_DEFAULT ColorUtil.BLACK
#macro TEXT_ALPHA_DEFAULT 1.0
#macro TEXT_FONT_DEFAULT font_basic

///@static
function _Text() constructor {

  ///@deprecated
  render = function(text, x, y, config = {}) {
    throw new Exception("Deprecated")
    
    config.font = Struct.getDefault(config, "font", TEXT_FONT_DEFAULT)
    if (config.font != draw_get_font()) {
      draw_set_font(config.font)
    }

    if (Struct.contains(config, "color")) {
      config.c1 = config.color.toGMColor()
      config.c2 = config.color.toGMColor()
      config.c3 = config.color.toGMColor()
      config.c4 = config.color.toGMColor()
    }

    if (Struct.getDefault(config, "outline", false)) {
      var alpha = Struct.getDefault(config, "alpha", 1.0)
      var textColor = Struct.getDefault(config, "textColor", { color: TEXT_COLOR_DEFAULT })
      if (Struct.contains(textColor, "color")) {
        textColor.c1 = textColor.color.toGMColor()
        textColor.c2 = textColor.color.toGMColor()
        textColor.c3 = textColor.color.toGMColor()
        textColor.c4 = textColor.color.toGMColor()
      }

      var outlineColor = Struct.getDefault(config, "outlineColor", { color: TEXT_COLOR_OUTLINE_DEFAULT })
      if (Struct.contains(outlineColor, "color")) {
        outlineColor.c1 = outlineColor.color.toGMColor()
        outlineColor.c2 = outlineColor.color.toGMColor()
        outlineColor.c3 = outlineColor.color.toGMColor()
        outlineColor.c4 = outlineColor.color.toGMColor()
      }
	
      draw_text_color(x + 1, y + 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x - 1, y - 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x,   y + 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x + 1, y  , text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x,   y - 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x - 1, y  , text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x - 1, y + 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha);  
      draw_text_color(x + 1, y - 1, text, outlineColor.c1, outlineColor.c2, outlineColor.c3, outlineColor.c4, alpha); 
      draw_text_color(x, y, text, textColor.c1, textColor.c2, textColor.c3, textColor.c4, alpha);
      return this
    }

    draw_text_ext_transformed_color(
      x, y, 
      text, 
      Struct.getDefault(config, "sep", TEXT_SEP_DEFAULT),
      Struct.getDefault(config, "w", TEXT_W_DEFAULT),
      Struct.getDefault(config, "xscale", TEXT_XSCALE_DEFAULT),
      Struct.getDefault(config, "yscale", TEXT_YSCALE_DEFAULT),
      Struct.getDefault(config, "angle", TEXT_ANGLE_DEFAULT),
      Struct.getDefault(config, "color1", TEXT_COLOR_DEFAULT),
      Struct.getDefault(config, "color2", TEXT_COLOR_DEFAULT),
      Struct.getDefault(config, "color3", TEXT_COLOR_DEFAULT),
      Struct.getDefault(config, "color4", TEXT_COLOR_DEFAULT),
      Struct.getDefault(config, "alph", TEXT_ALPHA_DEFAULT)
    )
    return this
  }
}
global.__Text = new _Text()
#macro Text global.__Text
