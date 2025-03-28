///@package io.alkapivo.visu.editor.service.brush.

///@static
///@type {Map<String, Callable>}
global.__ve_shader_configs = new Map(String, Struct, {
  "shader_art_wasm": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
  },
  "shader_octagrams": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
    "iWidth": { __type: "FLOAT" },
    "iHeight": { __type: "FLOAT" },
    "iDepth": { __type: "FLOAT" },
    "iFactor": { __type: "FLOAT" },
  },
  "shader_70s_melt": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iFactor": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
    "iMix": { __type: "FLOAT" },
  },
  "shader_warp": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
  },
  "shader_phantom_star": {
    "iResolution": { __type: "VECTOR2" },
    "iTime": { __type: "FLOAT" },
    "iIterations": { __type: "FLOAT" },
    "sizeA": { __type: "FLOAT" },
    "sizeB": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
  },
  "shader_abberation": {
    "type": "GLSL_ES"
  },
  "shader_crt": {
    "uni_crt_sizes": { __type: "VECTOR4" },
    "uni_radial_distortion_amount": { __type: "FLOAT" },
    "uni_use_radial_distortion": { __type: "FLOAT" },
    "uni_use_border": { __type: "FLOAT" },
    "uni_use_RGB_separation": { __type: "FLOAT" },
    "uni_use_scanlines": { __type: "FLOAT" },
    "uni_use_noise": { __type: "FLOAT" },
    "uni_border_corner_size": { __type: "FLOAT" },
    "uni_border_corner_smoothness": { __type: "FLOAT" },
    "uni_brightness": { __type: "FLOAT" },
    "uni_noise_strength": { __type: "FLOAT" },
    "uni_timer": { __type: "FLOAT" },
  },
  "shader_emboss": {
    "resolution": { __type: "RESOLUTION" },
  },
  "shader_hue": {
    "colorShift": {
      value: {
        increase: { factor: 0.1, },
        decrease: { factor: -0.1, },
      },
      target: {
        increase: { factor: 0.1, },
        decrease: { factor: -0.1, },
      },
      factor: {
        increase: { factor: 0.01, },
        decrease: { factor: -0.01, },
      },
      increase: {
        increase: { factor: 0.0001, },
        decrease: { factor: -0.0001, },
      },
    }
  },
  "shader_led": {
    "resolution": "RESOLUTION",
      "ledSize": { __type: "FLOAT" },
    "brightness": { __type: "FLOAT" },
  },
  "shader_magnify": {
    "resolution": "RESOLUTION",
      "position": { __type: "VECTOR2" },
    "radius": { __type: "FLOAT" },
    "minZoom": { __type: "FLOAT" },
    "maxZoom": { __type: "FLOAT" },
  },
  "shader_mosaic": {
    "resolution": "RESOLUTION",
      "amount": { __type: "FLOAT" },
  },
  "shader_posterization": {
    "gamma": { __type: "FLOAT" },
    "colorNumber": { __type: "FLOAT" },
  },
  "shader_revert": {
    "type": "GLSL_ES"
  },
  "shader_ripple": {
    "resolution": "RESOLUTION",
      "position": { __type: "VECTOR2" },
    "amount": { __type: "FLOAT" },
    "distortion": { __type: "FLOAT" },
    "speed": { __type: "FLOAT" },
    "time": { __type: "FLOAT" },
  },
  "shader_scanlines": {
    "resolution": "RESOLUTION",
      "color": { __type: "COLOR" },
  },
  "shader_shock_wave": {
    "resolution": "RESOLUTION",
      "position": { __type: "VECTOR2" },
    "amplitude": { __type: "FLOAT" },
    "refraction": { __type: "FLOAT" },
    "width": { __type: "FLOAT" },
    "time": { __type: "FLOAT" },
  },
  "shader_sketch": {
    "resolution": "RESOLUTION",
      "intensity": { __type: "FLOAT" },
  },
  "shader_thermal": {
    "type": "GLSL_ES"
  },
  "shader_wave": {
    "amount": { __type: "FLOAT" },
    "distortion": { __type: "FLOAT" },
    "speed": { __type: "FLOAT" },
    "time": { __type: "FLOAT" },
  },
  "shader_cineshader_lava": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iTreshold": { __type: "FLOAT" },
    "iSize": { __type: "VECTOR3" },
  },
  "shader_broken_time_portal": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iTreshold": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
  },
  "shader_base_warp_fbm": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
  },
  "shader_dive_to_cloud": {
    "iResolution": { __type: "VECTOR2" },
    "iTime": { __type: "FLOAT" },
  },
  "shader_cubular": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
    "size": { __type: "FLOAT" },
    "amount": { __type: "FLOAT" },
  },
  "shader_sincos_3d": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iMouse": { __type: "VECTOR4" },
    "lineThickness": { __type: "FLOAT" },
    "pointRadius": { __type: "FLOAT" },
  },
  "shader_sincos_3d_wasm": {
    "iResolution": { __type: "VECTOR3" },
    "iTime": { __type: "FLOAT" },
    "iMouse": { __type: "VECTOR4" },
    "lineThickness": { __type: "FLOAT" },
    "pointRadius": { __type: "FLOAT" },
  },
  "shader_lighting_with_glow": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iFactor": { __type: "FLOAT" },
  },
  "shader_discoteq_2": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
  },
  "shader_ui_noise_halo": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
  },
  "shader_colors_embody": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iSize": { __type: "FLOAT" },
    "iDistance": { __type: "FLOAT" },
  },
  "shader_grid_space": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
  },
  "shader_002_blue": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
    "iPhase": { __type: "FLOAT" },
    "iTreshold": { __type: "FLOAT" },
    "iDistance": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
  },
  "shader_002_blue_wasm": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
    "iPhase": { __type: "FLOAT" },
    "iTreshold": { __type: "FLOAT" },
    "iDistance": { __type: "FLOAT" },
    "iTint": { __type: "VECTOR3" },
  },
  "shader_monster": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iTint": { __type: "VECTOR3" },
    "iSize": { __type: "FLOAT" },
  },
  "shader_clouds_2d": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
  },
  "shader_flame": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iPosition": { __type: "VECTOR3" },
    "iIterations": { __type: "FLOAT" },
  },
  "shader_flame_wasm": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iPosition": { __type: "VECTOR3" },
    "iIterations": { __type: "FLOAT" },
  },
  "shader_whirlpool": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
    "iFactor": { __type: "FLOAT" },
  },
  "shader_whirlpool_wasm": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "FLOAT" },
    "iFactor": { __type: "FLOAT" },
  },
  "shader_warp_speed_2": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "VECTOR2" },
    "iFactor": { __type: "FLOAT" },
    "iSeed": { __type: "VECTOR3" },
  },
  "shader_warp_speed_2_wasm": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iIterations": { __type: "FLOAT" },
    "iSize": { __type: "VECTOR2" },
    "iFactor": { __type: "FLOAT" },
    "iSeed": { __type: "VECTOR3" },
  },
  "shader_star_nest": {
    "iTime": { __type: "FLOAT" },
    "iResolution": { __type: "VECTOR2" },
    "iAngle": { __type: "FLOAT" },
    "iZoom": { __type: "FLOAT" },
    "iTile": { __type: "FLOAT" },
    "iSpeed": { __type: "FLOAT" },
    "iBrightness": { __type: "FLOAT" },
    "iDarkmatter": { __type: "FLOAT" },
    "iDistfading": { __type: "FLOAT" },
    "iSaturation": { __type: "FLOAT" },
    "iBlend": { __type: "VECTOR3" },
  },
})
#macro VE_SHADER_CONFIGS global.__ve_shader_configs


///@static
///@type {Map<String, Callable>}
global.__ShaderUniformTemplates = new Map(String, Callable)
  .set(ShaderUniformType.findKey(ShaderUniformType.COLOR), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: Color,
          value: ColorUtil.fromHex("#ffffff"),
        },
      },
      components: new Array(Struct, [
        {
          name: $"shader-uniform_{uniform.name}",
          template: VEComponents.get("color-picker"),
          layout: VELayouts.get("color-picker"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            title: { 
              label: { text: $"[COLOR]  {uniform.name}" },
              input: { store: { key: uniform.name } },
            },
            hex: { 
              label: { text: "Hex" },
              field: { store: { key: uniform.name } },
            },
            red: {
              label: { text: "Red" },
              field: { store: { key: uniform.name } },
              slider: { store: { key: uniform.name } },
            },
            green: {
              label: { text: "Green" },
              field: { store: { key: uniform.name } },
              slider: { store: { key: uniform.name } },
            },
            blue: {
              label: { text: "Blue" },
              field: { store: { key: uniform.name } },
              slider: { store: { key: uniform.name } },
            },
          }
        }
      ]),
    }
  })
  .set(ShaderUniformType.findKey(ShaderUniformType.FLOAT), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: NumberTransformer,
          value: new NumberTransformer(Struct.getIfType(json, uniform.name, Struct, {
            value: 0.0,
            target: 0.0,
            factor: 0.0,
            increase: 0.0
          })),
        },
      },
      components: new Array(Struct, [
        {
          name: $"shader-uniform_{uniform.name}",
          template: VEComponents.get("transform-numeric-uniform"),
          layout: VELayouts.get("transform-numeric-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            title: { label: { text: $"[FLOAT]  {uniform.name}" } },
            label: { text: uniform.name },
            value: {
              label: { text: "Value" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, config, false),
        }
      ]),
    }
  })
  .set(ShaderUniformType.findKey(ShaderUniformType.VECTOR2), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: Vector2Transformer,
          value: new Vector2Transformer(Struct.getIfType(json, uniform.name, Struct, { 
            x: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            }, 
            y: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            },
          })),
        },
      },
      components: new Array(Struct, [
        {
          name: $"shader-uniform_{uniform.name}-x",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            label: { text: uniform.name },
            title: { label: { text: $"[VEC2]  {uniform.name}" } },
            vectorProperty: "x",
            value: {
              label: {
                text: "X",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: { 
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: { 
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: { 
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: { 
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec2x"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-y",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "y",
            value: {
              label:{
                text: "Y",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec2y"), false),
        },
      ]),
    }
  })
  .set(ShaderUniformType.findKey(ShaderUniformType.VECTOR3), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: Vector3Transformer,
          value: new Vector3Transformer(Struct.getIfType(json, uniform.name, Struct, { 
            x: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            }, 
            y: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            },
            z: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            },
          })),
        },
      },
      components: new Array(Struct, [
        {
          name: $"shader-uniform_{uniform.name}-x",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "x",
            label: { text: uniform.name },
            title: { label: { text: $"[VEC3]  {uniform.name}" } },
            value: {
              label: {
                text: "X",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec3x"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-y",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "y",
            value: {
              label: {
                text: "Y",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec3y"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-z",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "z",
            value: {
              label: {
                text: "Z",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec3z"), false),
        }
      ]),
    }
  })
  .set(ShaderUniformType.findKey(ShaderUniformType.VECTOR4), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: Vector4Transformer,
          value: new Vector4Transformer(Struct.getIfType(json, uniform.name, Struct, { 
            x: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            }, 
            y: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            },
            z: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            }, 
            a: {
              value: 0.0,
              target: 0.0,
              factor: 0.0,
              increase: 0.0,
            },
          })),
        },
      },
      components: new Array(Struct, [
        {
          name: $"shader-uniform_{uniform.name}-x",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            label: { text: uniform.name },
            vectorProperty: "x",
            title: { label: { text: $"[VEC4]  {uniform.name}" } 
            },
            value: {
              label: {
                text: "X",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec4x"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-y",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "y",
            value: {
              label: {
                text: "Y",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec4y"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-z",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "z",
            value: {
              label: {
                text: "Z",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            }
          }, Struct.get(config, "vec4z"), false),
        },
        {
          name: $"shader-uniform_{uniform.name}-a",
          template: VEComponents.get("transform-vec-property-uniform"),
          layout: VELayouts.get("transform-vec-property-uniform"),
          config: Struct.appendRecursive({
            layout: { type: UILayoutType.VERTICAL },
            vectorProperty: "a",
            value: {
              label: {
                text: "A",
                font: "font_inter_10_bold",
              },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            target: {
              label: { text: "Target" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.01,
              },
            },
            factor: {
              label: { text: "Factor" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.001,
              },
            },
            increase: {
              label: { text: "Increase" },
              field: { store: { key: uniform.name } },
              increase: { store: { key: uniform.name } },
              decrease: { store: { key: uniform.name } },
              slider: {
                store: { key: uniform.name },
                factor: 0.0001,
              },
            },
          }, Struct.get(config, "vec4a"), false),
        }
      ]),
    }
  })
  .set(ShaderUniformType.findKey(ShaderUniformType.RESOLUTION), function(uniform, json, config = null) {
    return {
      store: {
        key: uniform.name,
        item: {
          type: ResolutionTransformer,
          value: new ResolutionTransformer(),
        },
      },
    }
  })
#macro ShaderUniformTemplates global.__ShaderUniformTemplates


///@param {Struct} json
///@return {Struct}
function template_shader(json) {
  var shader = Assert.isType(ShaderUtil.fetch(json.shader), Shader)
  var template = {
    name: Assert.isType(json.name, String),
    shader: Assert.isType(shader.name, String),
    store: new Map(String, Struct),
    components: new Array(Struct),
    json: json,
  }

  var inherit = Struct.getDefault(json, "inherit", null)
  if (Core.isType(inherit, String)) {
    Struct.set(template, "inherit", inherit)
  }

  GMArray.forEach(GMArray.sort(shader.uniforms.keys().getContainer()), function(key, index, acc) {
    var uniform = acc.uniforms.get(key)
    var template = acc.template
    var type = ShaderUniformType.findKey(Callable.get(Core.getTypeName(uniform)))
    var properties = Struct.getDefault(template.json, "properties", {})
    var config = Struct.get(VE_SHADER_CONFIGS.get(template.shader), key)
    var property = Callable.run(ShaderUniformTemplates.get(type), uniform, properties, config)
    if (!Optional.is(property)) {
      Logger.warn("VEShader", $"Found unsupported property '{key}' in template '{template.name}' of shader '{template.shader}")
      return
    }

    if (Optional.is(Struct.get(property, "store"))) {
      template.store.add(property.store.item, property.store.key)
    }
    
    if (Optional.is(Struct.get(property, "components"))) {
      property.components.forEach(function(component, index, components) {
        components.add(component)
      }, template.components)
      if (type != ShaderUniformType.findKey(ShaderUniformType.RESOLUTION)) {
        template.components.add({
          name: $"{template.name}_{key}-line-h",
          template: VEComponents.get("line-h"),
          layout: VELayouts.get("line-h"),
          config: { layout: { type: UILayoutType.VERTICAL } },
        })
      }
    }
  }, {
    uniforms: shader.uniforms,
    template: template,
  })

  Struct.remove(template, "json") ///@todo investigate
  
  return template
}
