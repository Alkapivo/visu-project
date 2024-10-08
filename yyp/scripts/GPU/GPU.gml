///@package io.alkapivo.core.renderer.GPU
show_debug_message("init GPU.gml")

///@type {?Texture}
global.__GPU_DEFAULT_LINE_TEXTURE = null
#macro GPU_DEFAULT_LINE_TEXTURE global.__GPU_DEFAULT_LINE_TEXTURE


///@type {?Texture}
global.__GPU_DEFAULT_LINE_TEXTURE_CORNER = null
#macro GPU_DEFAULT_LINE_TEXTURE_CORNER global.__GPU_DEFAULT_LINE_TEXTURE_CORNER


///@type {?Font}
global.__GPU_DEFAULT_FONT = null
#macro GPU_DEFAULT_FONT global.__GPU_DEFAULT_FONT

///@type {?Font}
global.__GPU_DEFAULT_FONT_BOLD = null
#macro GPU_DEFAULT_FONT_BOLD global.__GPU_DEFAULT_FONT_BOLD


///@enum
function _BlendMode(): Enum() constructor {
  ADD = bm_add
  NORMAL = bm_normal
  SUBTRACT = bm_subtract
  REVERSE_SUBTRACT = bm_reverse_subtract
  MIN = bm_min
  MAX = bm_max
}
global.__BlendMode = new _BlendMode()
#macro BlendMode global.__BlendMode


///@enum
function _BlendModeExt(): Enum() constructor {
  ZERO = bm_zero
  ONE = bm_one
  SRC_COLOUR = bm_src_colour
  INV_SRC_COLOUR = bm_inv_src_colour
  SRC_ALPHA = bm_src_alpha
  INV_SRC_ALPHA = bm_inv_src_alpha
  DEST_ALPHA = bm_dest_alpha
  INV_DEST_ALPHA = bm_inv_dest_alpha
  DEST_COLOUR = bm_dest_colour
  INV_DEST_COLOUR = bm_inv_dest_colour
  SRC_ALPHA_SAT = bm_src_alpha_sat
}
global.__BlendModeExt = new _BlendModeExt()
#macro BlendModeExt global.__BlendModeExt


///@enum
function _BlendEquation(): Enum() constructor {
  ADD = bm_eq_add
  SUBTRACT = bm_eq_subtract
  REVERSE_SUBTRACT = bm_eq_reverse_subtract
  MIN = bm_eq_min
  MAX = bm_eq_max
}
global.__BlendEquation = new _BlendEquation()
#macro BlendEquation global.__BlendEquation


///@enum
function _VAlign(): Enum() constructor {
  TOP = fa_top
  CENTER = fa_middle
  BOTTOM = fa_bottom
}
global.__VAlign = new _VAlign()
#macro VAlign global.__VAlign


///@enum
function _HAlign(): Enum() constructor {
  LEFT = fa_left
  CENTER = fa_center
  RIGHT = fa_right
}
global.__HAlign = new _HAlign()
#macro HAlign global.__HAlign


///@static
function _GPU() constructor {

  ///@type {Struct}
  render = {
    ///@param {Number} beginX
    ///@param {Number} beginY
    ///@param {Number} endX
    ///@param {Number} endY
    ///@param {Number} [thickness]
    ///@param {Number} [alpha]
    ///@param {GMColor} [blend]
    ///@param {Texture} [line]
    ///@param {Texture} [corner]
    ///@return {GPU}
    texturedLine: function(beginX, beginY, endX, endY, 
        thickness = 1.0, alpha = 1.0, blend = c_white, 
        line = GPU_DEFAULT_LINE_TEXTURE, 
        corner = GPU_DEFAULT_LINE_TEXTURE_CORNER) {

      var angle = point_direction(beginX, beginY, endX, endY)
      var length = point_distance(beginX, beginY, endX, endY)
      var scale = length / line.width
      corner.render(beginX, beginY, 0, thickness, thickness, alpha, angle, blend)
      corner.render(endX, endY, 0, thickness, thickness, alpha, angle + 180.0, blend)
      line.render(beginX, beginY, 0, scale, thickness, alpha, angle, blend)

      return GPU
    },

    ///@param {Number} beginX
    ///@param {Number} beginY
    ///@param {Number} endX
    ///@param {Number} endY
    ///@param {Number} [thickness]
    ///@param {Number} [alpha]
    ///@param {GMColor} [blend]
    ///@param {Texture} [line]
    ///@return {GPU}
    texturedLineSimple: function(beginX, beginY, endX, endY, 
        thickness = 1.0, alpha = 1.0, blend = c_white, 
        line = GPU_DEFAULT_LINE_TEXTURE) {

      var angle = point_direction(beginX, beginY, endX, endY)
      var length = point_distance(beginX, beginY, endX, endY)
      var scale = length / line.width
      line.render(beginX, beginY, 0, scale, thickness, alpha, angle, blend)
      return GPU
    },

    ///@param {Color} color
    ///@return {GPU}
    clear: function(color) {
      draw_clear_alpha(color.toGMColor(), color.alpha)
      return GPU
    },

    ///@param {Number} width
    ///@param {Number} height
    ///@param {GMColor} [color]
    ///@param {Number} [alpha]
    ///@return {GPU}
    fillColor: function(width, height, color = c_white, alpha = 1.0) {
      draw_sprite_ext(texture_white, 0.0, 0, 0, width / 32.0, height / 32.0, 0.0, color, alpha)
      return GPU
    },

    ///@param {Number} beginX
    ///@param {Number} beginY
    ///@param {Number} endX
    ///@param {Number} endY
    ///@param {Boolean} [outline]
    ///@param {?GMColor} [color1]
    ///@param {?GMColor} [color2]
    ///@param {?GMColor} [color3]
    ///@param {?GMColor} [color4]
    ///@param {?Number} [alpha]
    ///@return {GPU}
    rectangle: function(beginX, beginY, endX, endY, outline = false, color1 = null, color2 = null, color3 = null, color4 = null, alpha = null) {
      var c1 = color1 == null ? c_black : color1
      var c2 = color2 == null ? c1 : color2
      var c3 = color3 == null ? c1 : color3
      var c4 = color4 == null ? c2 : color4
      if (alpha == null) {
        draw_rectangle_color(beginX, beginY, endX, endY, c1, c2, c3, c4, outline)
      } else {
        var _alpha = draw_get_alpha()
        if (_alpha == alpha) {
          draw_rectangle_color(beginX, beginY, endX, endY, c1, c2, c3, c4, outline)
        } else {
          draw_set_alpha(alpha)
          draw_rectangle_color(beginX, beginY, endX, endY, c1, c2, c3, c4, outline)
          draw_set_alpha(_alpha)
        }
      }

      return GPU
    },

    ///@param {Number} _x
    ///@param {Number} _y
    ///@param {String} text
    ///@param {GMColor} [color]
    ///@param {?GMColor} [outline]
    ///@param {Number} [alpha]
    ///@param {Font} [font]
    ///@param {HAlign} [h]
    ///@param {VAlign} [v]
    ///@return {Struct}
    ///@return {GPU}
    text: function(_x, _y, text, color = c_white, outline = null, alpha = 1.0, font = GPU_DEFAULT_FONT, h = HAlign.LEFT, v = VAlign.TOP) {
      if (font.asset != draw_get_font()) {
        draw_set_font(font.asset)
      }

      if (h != draw_get_halign()) {
        draw_set_halign(h)
      }
  
      if (v != draw_get_valign()) {
        draw_set_valign(v)
      }

      if (outline != null) {
        draw_text_color(_x + 1, _y + 1, text, outline, outline, outline, outline, alpha)
        draw_text_color(_x - 1, _y - 1, text, outline, outline, outline, outline, alpha)
        draw_text_color(_x    , _y + 1, text, outline, outline, outline, outline, alpha)
        draw_text_color(_x + 1, _y    , text, outline, outline, outline, outline, alpha)
        draw_text_color(_x    , _y - 1, text, outline, outline, outline, outline, alpha)
        draw_text_color(_x - 1, _y    , text, outline, outline, outline, outline, alpha)
        draw_text_color(_x - 1, _y + 1, text, outline, outline, outline, outline, alpha)
        draw_text_color(_x + 1, _y - 1, text, outline, outline, outline, outline, alpha)
      }

      draw_text_color(_x, _y, text, color, color, color, color, alpha)
      return GPU
    }
  }

  ///@type {Struct}
  set = {
    ///@param {Shader}
    ///@return {GPU}
    shader: function(shader) {
      shader_set(shader.asset) 
      return GPU
    },

    ///@param {Surface}
    ///@return {GPU}
    surface: function(surface) {
      surface_set_target(surface.asset)
      return GPU
    },

    ///@param {BlendMode} mode
    ///@return {GPU}
    blendMode: function(mode) {
      gpu_set_blendmode(mode)
      return GPU
    },

    ///@param {BlendModeExt} source
    ///@param {BlendModeExt} target
    ///@return {GPU}
    blendModeExt: function(source, target) {
      gpu_set_blendmode_ext(source, target)
      return GPU
    },

    ///@param {BlendEquation} equation
    ///@return {GPU}
    blendEquation: function(equation) {
      gpu_set_blendequation(equation)
      return GPU
    },

    ///@param {Boolean} enable
    ///@return {GPU}
    blendEnable: function(enable) {
      gpu_set_blendenable(enable)
      return GPU
    },

    ///@param {GMFont} asset
    ///@return {GPU}
    font: function(asset) {
      draw_set_font(asset)
      return GPU
    },

    ///@type {Struct}
    align: {
      ///@param {Struct} align
      ///@return {GPU}
      h: function(align) {
        draw_set_halign(align.h)
        return GPU
      },

      ///@param {Struct} align
      ///@return {GPU}
      v: function(align) {
        draw_set_valign(align.v)
        return GPU
      },
    },
  }

  ///@type {Struct}
  get = {
    ///@return {?GMSurface}
    surface: function() {
      var target = surface_get_target()
      return target != -1 ? target : null
    },

    ///@return {Boolean}
    blendEnable: function() {
      return gpu_get_blendenable()
    },
  }

  ///@type {Struct}
  reset = {
    ///@return {GPU}
    shader: function() {
      if (shader_current() != -1) {
        shader_reset()
      }
      
      return GPU
    },

    ///@return {GPU}
    surface: function() {
      var target = surface_get_target()
      if (target != application_surface && target != -1) {
        surface_reset_target()
      }

      return GPU
    },

    ///@return {GPU}
    blendMode: function() {
      gpu_set_blendmode(BlendMode.NORMAL)
      return GPU
    },

    ///@return {GPU}
    blendEquation: function() {
      gpu_set_blendequation(BlendEquation.ADD)
      return GPU
    },
  }
}
global.__GPU = new _GPU()
#macro GPU global.__GPU

function initGPU() {
  GPU_DEFAULT_LINE_TEXTURE = new Texture(texture_grid_line_default)
  GPU_DEFAULT_LINE_TEXTURE_CORNER = new Texture(texture_grid_line_corner_default)
  GPU_DEFAULT_FONT = new Font(font_consolas_12_regular)
  GPU_DEFAULT_FONT_BOLD = new Font(font_consolas_12_bold)
}