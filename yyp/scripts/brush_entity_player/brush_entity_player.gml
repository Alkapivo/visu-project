///@package io.alkapivo.visu.editor.service.brush.entity

///@param {?Struct} [json]
///@return {Struct}
function brush_entity_player(json = null) {
  return {
    name: "brush_entity_player",
    store: new Map(String, Struct, {
      "en-pl_texture": {
        type: Sprite,
        value: Struct.get(json, "en-pl_texture"),
      },
      "en-pl_use-mask": {
        type: Boolean,
        value: Struct.get(json, "en-pl_use-mask"),
      },
      "en-pl_mask": {
        type: Rectangle,
        value: Struct.get(json, "en-pl_mask"),
      },
      "en-pl_reset-pos": {
        type: Boolean,
        value: Struct.get(json, "en-pl_reset-pos"),
      },
      "en-pl_use-stats": {
        type: Boolean,
        value: Struct.get(json, "en-pl_use-stats"),
      },
      "en-pl_stats": {
        type: String,
        value: JSON.stringify(Struct.get(json, "en-pl_stats"), { pretty: true }),
        serialize: UIUtil.serialize.getStringStruct(),
        validate: UIUtil.validate.getStringStruct(),
      },
      "en-pl_use-bullethell": {
        type: Boolean,
        value: Struct.get(json, "en-pl_use-bullethell"),
      },
      "en-pl_bullethell": {
        type: String,
        value: JSON.stringify(Struct.get(json, "en-pl_bullethell"), { pretty: true }),
        serialize: UIUtil.serialize.getStringStruct(),
        validate: UIUtil.validate.getStringStruct(),
      },
      "en-pl_use-platformer": {
        type: Boolean,
        value: Struct.get(json, "en-pl_use-platformer"),
      },
      "en-pl_platformer": {
        type: String,
        value: JSON.stringify(Struct.get(json, "en-pl_platformer"), { pretty: true }),
        serialize: UIUtil.serialize.getStringStruct(),
        validate: UIUtil.validate.getStringStruct(),
      },
      "en-pl_use-racing": {
        type: Boolean,
        value: Struct.get(json, "en-pl_use-racing"),
      },
      "en-pl_racing": {
        type: String,
        value: JSON.stringify(Struct.get(json, "en-pl_racing"), { pretty: true }),
        serialize: UIUtil.serialize.getStringStruct(),
        validate: UIUtil.validate.getStringStruct(),
      },
    }),
    components: new Array(Struct, [
      {
        name: "en-pl_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Player texture",
              backgroundColor: VETheme.color.accentShadow,
            },
            input: { backgroundColor: VETheme.color.accentShadow },
            checkbox: { backgroundColor: VETheme.color.accentShadow },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "en-pl_texture" } },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "en-pl_texture" },
          },
          resolution: {
            store: { key: "en-pl_texture" },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "en-pl_texture" } },
            decrease: { store: { key: "en-pl_texture" } },
            increase: { store: { key: "en-pl_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              snapValue: 0.01 / 1.0,
              store: { key: "en-pl_texture" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "en-pl_texture" } },
            decrease: { store: { key: "en-pl_texture" } },
            increase: { store: { key: "en-pl_texture" } },
            checkbox: { 
              store: { key: "en-pl_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Rng" }, 
            stick: { store: { key: "en-pl_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "en-pl_texture" } },
            decrease: { store: { key: "en-pl_texture" } },
            increase: { store: { key: "en-pl_texture" } },
            checkbox: { 
              store: { key: "en-pl_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            stick: { store: { key: "en-pl_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "en-pl_texture" } },
            decrease: { store: { key: "en-pl_texture" } },
            increase: { store: { key: "en-pl_texture" } },
            stick: { store: { key: "en-pl_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "en-pl_texture" } },
            decrease: { store: { key: "en-pl_texture" } },
            increase: { store: { key: "en-pl_texture" } },
            stick: { store: { key: "en-pl_texture" } },
          },
        },
      },
      {
        name: "en-pl-texture-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-pl_mask-property",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Collision mask",
            enable: { key: "en-pl_use-mask" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_use-mask" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "en-pl_preview_mask",
        template: VEComponents.get("preview-image-mask"),
        layout: VELayouts.get("preview-image-mask"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          preview: {
            enable: { key: "en-pl_use-mask" },
            image: { name: "texture_empty" },
            store: { key: "en-pl_texture" },
            mask: "en-pl_mask",
          },
          resolution: {
            enable: { key: "en-pl_use-mask" },
            store: { key: "en-pl_texture" },
          },
        },
      },
      {
        name: "en-pl_mask",
        template: VEComponents.get("vec4-stick-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          x: {
            label: {
              text: "X",
              enable: { key: "en-pl_use-mask" },
            },
            field: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 0.1,
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "en-pl_use-mask" },
            },
            field: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 0.1,
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "en-pl_use-mask" },
            },
            field: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 0.1,
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "en-pl_use-mask" },
            },
            field: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-pl_mask" },
              enable: { key: "en-pl_use-mask" },
              factor: 0.1,
            },
          },
        },
      },
      {
        name: "en-pl_mask-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-pl_reset-pos",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Reset spawn position",
            enable: { key: "en-pl_reset-pos" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_reset-pos" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "en-pl_reset-pos-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-pl_use-stats",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Player stats",
            enable: { key: "en-pl_use-stats" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_use-stats" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "en-pl_stats",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "en-pl_stats" },
            enable: { key: "en-pl_use-stats" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
      {
        name: "en-pl_stats-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-pl_bullethell",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Player config",
            enable: { key: "en-pl_use-bullethell" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_use-bullethell" },
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "en-pl_bullethell",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "en-pl_bullethell" },
            enable: { key: "en-pl_use-bullethell" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
      /* 
      {
        name: "grid-player_mode_platformer",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Platformer",
            enable: { key: "en-pl_use-platformer" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_use-platformer" },
          },
        },
      },
      {
        name: "en-pl_platformer",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "en-pl_platformer" },
            enable: { key: "en-pl_use-platformer" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
      {
        name: "en-pl_racing",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Racing",
            enable: { key: "en-pl_use-racing" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-pl_use-racing" },
          },
        },
      },
      {
        name: "en-pl_racing",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "en-pl_racing" },
            enable: { key: "en-pl_use-racing" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
      */
    ]),
  }
}