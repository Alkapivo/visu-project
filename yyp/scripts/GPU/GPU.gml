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


///@param {any} [config]
function BlendConfig(config = null) constructor {

  ///@type {BlendModeExt}
  source = Struct.getIfEnum(config, "source", BlendModeExt, BlendModeExt.SRC_ALPHA)

  ///@type {BlendModeExt}
  target = Struct.getIfEnum(config, "target", BlendModeExt, BlendModeExt.INV_SRC_ALPHA)

  ///@type {BlendEquation}
  equation = Struct.getIfEnum(config, "equation", BlendEquation, BlendEquation.ADD)

  ///@type {?BlendEquation}
  equationAlpha = Struct.getIfEnum(config, "equationAlpha", BlendEquation)

  ///@private
  ///@type {?BlendModeExt}
  previousSource = null
  
  ///@private
  ///@type {?BlendModeExt}
  previousTarget = null
  
  ///@private 
  ///@type {?BlendEquation}
  previousEquation = null

  ///@private 
  ///@type {?BlendEquation}
  previousEquationAlpha = null

  ///@type {BlendModeExt}
  ///@return {BlendConfig}
  setSource = function(source) {
    this.source = BlendModeExt.contains(source) ? source : this.source
    return this
  }

  ///@param {BlendModeExt}
  ///@return {BlendConfig}
  setTarget = function(target) {
    this.target = BlendModeExt.contains(target) ? target : this.target
    return this
  }

  ///@param {BlendEquation}
  ///@return {BlendConfig}
  setEquation = function(equation) {
    this.equation = BlendEquation.contains(equation) ? equation : this.equation
    return this
  }

  ///@param {BlendEquation}
  ///@return {BlendConfig}
  setEquationAlpha = function(equation) {
    this.equationAlpha = equation
    return this
  }

  ///@return {BlendConfig}
  set = function() {
    this.previousSource = GPU.get.blendModeExt.source()
    this.previousTarget = GPU.get.blendModeExt.target()
    this.previousEquation = GPU.get.blendModeExt.equation()
    this.previousEquationAlpha = GPU.get.blendModeExt.equationAlpha()

    if (this.previousSource != this.source
        || this.previousTarget != this.target) {
      GPU.set.blendModeExt(this.source, this.target)
    }

    if (this.previousEquation != this.equation) {
      GPU.set.blendEquation(this.equation)
    }

    if (Optional.is(this.equationAlpha)
        && this.previousEquationAlpha != this.equationAlpha) {
      GPU.set.blendEquationAlpha(this.equationAlpha)
    }

    return this
  }

  ///@return {BlendConfig}
  reset = function() {
    if (!Optional.is(this.previousSource)
        || !Optional.is(this.previousTarget)
        || !Optional.is(this.previousEquation)) {
      Logger.warn("BlendConfig::reset", "Method must be called after 'BlendConfig::set'")
      return this
    }

    if (this.previousSource != this.source
      || this.previousTarget != this.target) {
      GPU.set.blendModeExt(this.previousSource, this.previousTarget)
    }

    if (this.previousEquation != this.equation) {
      GPU.set.blendEquation(this.previousEquation)
    }

    if (Optional.is(this.previousEquationAlpha)
        && this.previousEquationAlpha != this.equationAlpha) {
      GPU.set.blendEquationAlpha(this.previousEquationAlpha)
    }

    this.previousSource = null
    this.previousTarget = null
    this.previousEquation = null
    this.previousEquationAlpha = null
    return this
  }

  ///@param {Callable} callback
  ///@param {any} [callbackData]
  ///@return {BlendConfig}
  run = function(callback, callbackData = null) {
    callback(callbackData)
    return this
  }

  ///@param {Callable} callback
  ///@param {any} [callbackData]
  ///@return {BlendConfig}
  renderOn = function(callback, callbackData = null) {
    return this.set().run(callback, callbackData).reset()
  }
}


///@enum
function _BlendModeExt(): Enum() constructor {
  ZERO = bm_zero
  ONE = bm_one
  SRC_COLOUR = bm_src_colour
  SRC_ALPHA = bm_src_alpha
  SRC_ALPHA_SAT = bm_src_alpha_sat
  INV_SRC_COLOUR = bm_inv_src_colour
  INV_SRC_ALPHA = bm_inv_src_alpha
  DEST_ALPHA = bm_dest_alpha
  DEST_COLOUR = bm_dest_colour
  INV_DEST_ALPHA = bm_inv_dest_alpha
  INV_DEST_COLOUR = bm_inv_dest_colour
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

    ///@param {Color|GMColor} color
    ///@param {?Number} [alpha]
    ///@return {GPU}
    clear: function(color, alpha = null) {
      if (Core.isType(color, GMColor)) {
        draw_clear_alpha(color, Optional.is(alpha) ? alpha : 1.0)  
      } else {
        draw_clear_alpha(color.toGMColor(), Optional.is(alpha) ? alpha : color.alpha)
      }
      
      return GPU
    },

    ///@param {Number} width
    ///@param {Number} height
    ///@param {GMColor} [color]
    ///@param {Number} [alpha]
    ///@return {GPU}
    fillColor: function(width, height, color = c_white, alpha = 1.0) {
      if (width == 0 || height == 0) {
        return GPU
      }

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
    ///@param {any} text
    ///@param {Number} [scale]
    ///@param {Number} [angle]
    ///@param {Number} [alpha]
    ///@param {GMColor} [color]
    ///@param {Font} [font]
    ///@param {HAlign} [h]
    ///@param {VAlign} [v]
    ///@param {?GMColor} [outline]
    ///@param {Number} [outlineAlphaFactor]
    ///@return {GPU}
    text: function(x, y, text, scale = 1.0, angle = 0.0, alpha = 1.0, color = c_white, font = GPU_DEFAULT_FONT, h = HAlign.LEFT, v = VAlign.TOP, outline = null, outlineAlphaFactor = 1.0) {
      if (text == "" || alpha <= 0.0 || !Core.isType(text, String) ) {
        return GPU
      }

      if (font.asset != GPU.get.font()) {
        GPU.set.font(font.asset)
      }    
  
      if (h != GPU.get.align.h()) {
        GPU.set.align.h(h)
      }

      if (v != GPU.get.align.v()) {
        GPU.set.align.v(v)
      }

      if (outline != null) {
        var outlineAlpha = alpha / max(outlineAlphaFactor, 1.0)
        draw_text_transformed_colour(x + 1, y + 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x - 1, y - 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x    , y + 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x + 1, y    , text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x    , y - 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x - 1, y    , text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x - 1, y + 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
        draw_text_transformed_colour(x + 1, y - 1, text, scale, scale, angle, outline, outline, outline, outline, outlineAlpha)
      }

      draw_text_transformed_colour(x, y, text, scale, scale, angle, color, color, color, color, alpha)
      return GPU
    }
  }

  ///@type {Struct}
  set = {

    ///@param {Number}
    ///@return {GPU}
    alpha: function(alpha) {
      draw_set_alpha(alpha)
      return GPU
    },

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
    ///@param {?BlendEquation} [equationAlpha]
    ///@return {GPU}
    blendEquation: function(equation, equationAlpha = null) {
      if (Optional.is(equationAlpha)) {
        gpu_set_blendequation_sepalpha(equation, equationAlpha)
      } else {
        gpu_set_blendequation(equation)
      }
      return GPU
    },

    ///@param {BlendEquation} equation
    ///@return {GPU}
    blendEquationAlpha: function(equation) {
      gpu_set_blendequation_sepalpha(GPU.get.blendModeExt.equation(), equation)
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
      ///@param {HAlign} align
      ///@return {GPU}
      h: function(align) {
        draw_set_halign(align)
        return GPU
      },

      ///@param {VAlign} align
      ///@return {GPU}
      v: function(align) {
        draw_set_valign(align)
        return GPU
      },
    },

    ///@param {Boolean} [red]
    ///@param {Boolean} [green]
    ///@param {Boolean} [blue]
    ///@param {Boolean} [alpha]
    ///@return {GPU}
    colorWrite: function(red = true, green = true, blue = true, alpha = true) {
      gpu_set_colorwriteenable(red, green, blue, alpha)
      return GPU
    },
  }

  ///@type {Struct}
  get = {

    ///@return {Number}
    alpha: draw_get_alpha,

    ///@type {Struct}
    align: {
      ///@return {HAlign}
      h: draw_get_halign,

      ///@return {VAlign}
      v: draw_get_valign,
    },

    ///@return {?GMSurface}
    surface: function() {
      var target = surface_get_target()
      return target != -1 ? target : null
    },

    ///@return {Boolean}
    blendEnable: gpu_get_blendenable,

    blendModeExt: {
      ///@return {BlendModeExt}
      source: function() {
        return gpu_get_blendmode_ext()[0]
      },

      ///@return {BlendModeExt}
      target: function() {
        return gpu_get_blendmode_ext()[1]
      },

      ///@return {BlendEquation}
      equation: function() {
        return gpu_get_blendequation()
      },

      ///@return {BlendEquation}
      equationAlpha: function() {
        return gpu_get_blendequation_sepalpha()[1]
      },
    },

    ///@return {GMArray<Boolean>}
    colorWrite: gpu_get_colorwriteenable,

    ///@return {GMFont}
    font: draw_get_font,
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