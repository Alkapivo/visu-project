///@package io.alkapivo.core.renderer.shader

#macro GMShader "GMShader"

///@enum
function _FancyBlendModes(): Enum() constructor {
  NORMAL = 0
  ADD = 1
  SUB = 2
  DARKEN = 3
  LIGHTEN = 4
  MULTIPLY = 5
  LINEAR_BURN = 6
  SCREEN = 7
  DIFFERENCE = 8
  EXCLUSION = 9
  COLOR_BURN = 10
  COLOR_DODGE = 11
  OVERLAY = 12
  SOFT_LIGHT = 13
  LINEAR_DODGE = 14
  HARD_LIGHT = 15
  VIVID_LIGHT = 16
  LINEAR_LIGHT = 17
  PIN_LIGHT = 18
  HUE = 19
  SATURATION = 20
  LUMINOSITY = 21
  COLOR = 22
  DARKER_COLOR = 23
  LIGHTER_COLOR = 24
  AVERAGE = 25
  REFLECT = 26
  GLOW = 27
  HARD_MIX = 28
  NEGATION = 29
  PHOENIX = 30
  SUBSTRACT = 31
}
global.__FancyBlendModes = new _FancyBlendModes()
#macro FancyBlendModes global.__FancyBlendModes


///@todo load from file
///@static
///@type {Struct}
global.__shaders = {
  "shader_nog_betere_2": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iColor": "VECTOR3",
      "iMix": "FLOAT"
    }
  },
  "shader_art": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT"
    }
  },
  "shader_art_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT"
    }
  },
  "shader_octagrams": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iTint": "VECTOR3",
      "iWidth": "FLOAT",
      "iHeight": "FLOAT",
      "iDepth": "FLOAT",
      "iFactor": "FLOAT"
    }
  },
  "shader_70s_melt": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iFactor": "FLOAT",
      "iTint": "VECTOR3",
      "iMix": "FLOAT",
    }
  },
  "shader_warp": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
    }
  },
  "shader_phantom_star": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR2",
      "iTime": "FLOAT",
      "iIterations": "FLOAT",
      "sizeA": "FLOAT",
      "sizeB": "FLOAT",
      "iTint": "VECTOR3"
    }
  },
  "shader_abberation": {
    "type": "GLSL_ES"
  },
  "shader_crt": {
    "type": "GLSL_ES",
    "uniforms": {
      "uni_crt_sizes": "VECTOR4",
      "uni_radial_distortion_amount": "FLOAT",
      "uni_use_radial_distortion": "FLOAT",
      "uni_use_border": "FLOAT",
      "uni_use_RGB_separation": "FLOAT",
      "uni_use_scanlines": "FLOAT",
      "uni_use_noise": "FLOAT",
      "uni_border_corner_size": "FLOAT",
      "uni_border_corner_smoothness": "FLOAT",
      "uni_brightness": "FLOAT",

      "uni_noise_strength": "FLOAT",
      "uni_timer": "FLOAT"
    }
  },
  "shader_emboss": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION"
    }
  },
  "shader_hue": {
    "type": "GLSL_ES",
    "uniforms": {
      "colorShift": "FLOAT"
    }
  },
  "shader_led": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "ledSize": "FLOAT",
      "brightness": "FLOAT"
    }
  },
  "shader_magnify": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "position": "VECTOR2",
      "radius": "FLOAT",
      "minZoom": "FLOAT",
      "maxZoom": "FLOAT"
    }
  },
  "shader_mosaic": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "amount": "FLOAT"
    }
  },
  "shader_posterization": {
    "type": "GLSL_ES",
    "uniforms": {
      "gamma": "FLOAT",
      "colorNumber": "FLOAT"
    }
  },
  "shader_revert": {
    "type": "GLSL_ES"
  },
  "shader_ripple": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
	    "position": "VECTOR2",
	    "amount": "FLOAT",
	    "distortion": "FLOAT",
	    "speed": "FLOAT",
	    "time": "FLOAT"
    }
  },
  "shader_scanlines": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "color": "COLOR"
    }
  },
  "shader_shock_wave": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "position": "VECTOR2",
      "amplitude": "FLOAT",
      "refraction": "FLOAT",
      "width": "FLOAT",
      "time": "FLOAT"
    }
  },
  "shader_sketch": {
    "type": "GLSL_ES",
    "uniforms": {
      "resolution": "RESOLUTION",
      "intensity": "FLOAT"
    }
  },
  "shader_thermal": {
    "type": "GLSL_ES"
  },
  "shader_wave": {
    "type": "GLSL_ES",
    "uniforms": {
      "amount": "FLOAT",
      "distortion": "FLOAT",
      "speed": "FLOAT",
      "time": "FLOAT"
    }
  },
  "shader_cineshader_lava": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iTreshold": "FLOAT",
      "iSize": "VECTOR3"
    }
  },
  "shader_broken_time_portal": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iTreshold": "FLOAT",
      "iSize": "FLOAT",
      "iTint": "VECTOR3"
    }
  },
  "shader_base_warp_fbm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iSize": "FLOAT"
    }
  },
  "shader_dive_to_cloud": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR2",
      "iTime": "FLOAT"
    }
  },
  "shader_cubular": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iTint": "VECTOR3",
      "size": "FLOAT",
      "amount": "FLOAT"
    }
  },
  "shader_sincos_3d": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iMouse": "VECTOR4",
      "lineThickness": "FLOAT",
      "pointRadius": "FLOAT"
    }
  },
  "shader_sincos_3d_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iResolution": "VECTOR3",
      "iTime": "FLOAT",
      "iMouse": "VECTOR4",
      "lineThickness": "FLOAT",
      "pointRadius": "FLOAT"
    }
  },
  "shader_lighting_with_glow": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iFactor": "FLOAT"
    }
  },
  "shader_discoteq_2": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
    }
  },
  "shader_ui_noise_halo": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
    }
  },
  "shader_colors_embody": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iSize": "FLOAT",
      "iDistance": "FLOAT"
    }
  },
  "shader_grid_space": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
    }
  },
  "shader_002_blue": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "FLOAT",
      "iPhase": "FLOAT",
      "iTreshold": "FLOAT",
      "iDistance": "FLOAT",
      "iTint": "VECTOR3"
    }
  },
  "shader_002_blue_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "FLOAT",
      "iPhase": "FLOAT",
      "iTreshold": "FLOAT",
      "iDistance": "FLOAT",
      "iTint": "VECTOR3"
    }
  },
  "shader_monster": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iTint": "VECTOR3",
      "iSize": "FLOAT"
    }
  },
  "shader_clouds_2d": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
    }
  },
  "shader_flame": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iPosition": "VECTOR3",
      "iIterations": "FLOAT"
    }
  },
  "shader_flame_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iPosition": "VECTOR3",
      "iIterations": "FLOAT"
    }
  },
  "shader_whirlpool": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "FLOAT",
      "iFactor": "FLOAT"
    }
  },
  "shader_whirlpool_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "FLOAT",
      "iFactor": "FLOAT"
    }
  },
  "shader_warp_speed_2": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "VECTOR2",
      "iFactor": "FLOAT",
      "iSeed": "VECTOR3"
    }
  },
  "shader_warp_speed_2_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iSize": "VECTOR2",
      "iFactor": "FLOAT",
      "iSeed": "VECTOR3"
    }
  },
  "shader_star_nest": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iAngle": "FLOAT",
      "iZoom": "FLOAT",
      "iTile": "FLOAT",
      "iSpeed": "FLOAT",
      "iBrightness": "FLOAT",
      "iDarkmatter": "FLOAT",
      "iDistfading": "FLOAT",
      "iSaturation": "FLOAT",
      "iBlend": "VECTOR3",
    }
  },
}
#macro SHADERS global.__shaders


///@static
///@type {Struct}
global.__shadersWASM = {
  "shader_002_blue": "shader_002_blue_wasm",
  "shader_art": "shader_art_wasm",
  "shader_flame": "shader_flame_wasm",
  "shader_sincos_3d": "shader_sincos_3d_wasm",
  "shader_warp_speed_2": "shader_warp_speed_2_wasm",
  "shader_whirlpool": "shader_whirlpool_wasm",
}
#macro SHADERS_WASM global.__shadersWASM


///@enum
function _ShaderType(): Enum() constructor {
  GLSL = "GLSL"
  GLSL_ES = "GLSL_ES"
  HLSL_11 = "HLSL_11"
}
global.__ShaderType = new _ShaderType()
#macro ShaderType global.__ShaderType


///@param {GMShader} _asset
///@param {Struct} json
function Shader(_asset, json) constructor {

  ///@type {GMShader} 
  asset = Core.getRuntimeType() == RuntimeType.GXGAMES 
    ? _asset 
    : Assert.isType(_asset, GMShader)

  ///@type {String}
  name = Assert.isType(Core.getRuntimeType() == RuntimeType.GXGAMES 
    ? Struct.get(json, "name") 
    : shader_get_name(_asset), String) 

  ///@type {String}
  //type = Assert.isEnum(json.type, ShaderType)

  ///@type {Map<String, ShaderUniform>}
  uniforms = Struct
    .toMap(
      Struct.getIfType(json, "uniforms", Struct, { }), 
      String, 
      ShaderUniform,
      function(type, name, asset) {
        var prototype = ShaderUniformType.get(type)
        return Assert.isType(new prototype(asset, name, type), ShaderUniform)
      },
      this.asset
    )
}


///@static
function _ShaderUtil() constructor {

  ///@param {String} _name
  ///@return {?Shader}
  static fetch = function(_name) {
    var name = Core.getRuntimeType() == RuntimeType.GXGAMES
      ? (Struct.contains(SHADERS_WASM, _name) ? Struct.get(SHADERS_WASM, _name) : _name)
      : _name
    var asset = asset_get_index(name)
    if (asset == -1) {
      Logger.warn("ShaderUtil", String.template("{0} does not exist: { \"name\": \"{1}\" }", GMShader, name))
      return null
    }

    if (!shader_is_compiled(asset)) {
      Logger.warn("ShaderUtil", String.template("{0} is not compiled: { \"name\": \"{1}\" }", "Shader", name))
      return null
    }

    var config = Struct.get(SHADERS, name)
    if (!Core.isType(config, Struct)) {
      Logger.warn("ShaderUtil", String.template("{0} was not found in SHADERS: { \"name\": \"{1}\" }", "Shader", name))
      config = {}
    }
    Struct.set(config, "name", name)

    try {
      return new Shader(asset, config)
    } catch (exception) {
      Logger.warn("ShaderUtil", exception.message)
    }
    
    return null
  }
}
global.__ShaderUtil = new _ShaderUtil()
#macro ShaderUtil global.__ShaderUtil

