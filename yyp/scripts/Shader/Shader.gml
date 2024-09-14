///@package io.alkapivo.core.renderer.shader

#macro GMShader "GMShader"

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
  "shader_octagrams": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT",
      "iTint": "VECTOR3"
    }
  },
  "shader_70s_melt": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
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
      "iTime": "FLOAT"
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
  "shader_lighting_with_glow": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2"
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
      "iResolution": "VECTOR2"
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
   "shader_wasm": {
    "type": "GLSL_ES",
    "uniforms": {
      "iTime": "FLOAT",
      "iResolution": "VECTOR2",
      "iIterations": "FLOAT"
    }
  }
}
#macro SHADERS global.__shaders

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
  asset = Core.isType(_asset, GMShader) ? _asset : shader_wasm

  ///@type {String}
  name = Core.isType(shader_get_name(_asset), String)

  ///@type {String}
  //type = Assert.isEnum(json.type, ShaderType)

  ///@type {Map<String, ShaderUniform>}
  uniforms = Struct
    .toMap(
      Struct.getDefault(json, "uniforms", {}), 
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

  ///@param {String} name
  ///@return {?Shader}
  static fetch = function(name) {
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
      Logger.warn("ShaderUtil", String.template("{0} was not found: { \"name\": \"{1}\" }", "Shader", name))

      return null
    }

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

