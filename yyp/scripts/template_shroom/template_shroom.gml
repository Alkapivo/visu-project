///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_shroom(json) {
  return {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "shroom_use-lifespawn": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "lifespawnMax"), Number),
      },
      "shroom_lifespawn": {
        type: Number,
        value: Struct.getIfType(json, "lifespawnMax", Number, 15.0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
      "shroom_use-health-points": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "healthPoints"), Number),
      },
      "shroom_health-points": {
        type: Number,
        value: Struct.getIfType(json, "healthPoints", Number, 1.0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999.9),
      },
      "shroom_texture": {
        type: Sprite,
        value: SpriteUtil.parse(json.sprite, { name: "texture_missing" }),
      },
      "use_shroom_mask": {
        type: Boolean,
        value: Optional.is(Struct.getIfType(json, "mask", Struct)),
      },
      "shroom_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getIfType(json, "mask", Struct)),
      },
      "shroom_game-mode_bullet-hell_features": {
        type: String,
        value: JSON.stringify(Struct
          .getIfType(json.gameModes.bulletHell, "features", GMArray, []), { 
            pretty: true 
          })
      },
      "shroom_game-mode_platformer_features": {
        type: String,
        value: JSON.stringify(Struct
          .getIfType(json.gameModes.platformer, "features", GMArray, []), { 
            pretty: true 
          })
      },
      "shroom_game-mode_racing_features": {
        type: String,
        value: JSON.stringify(Struct
          .getIfType(json.gameModes.racing, "features", GMArray, []), { 
            pretty: true 
          })
      },
    }),
    components: new Array(Struct, [
      {
        name: "shroom_lifespawn",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lifespawn",
            enable: { key: "shroom_use-lifespawn" },
          },  
          field: { 
            store: { key: "shroom_lifespawn" },
            enable: { key: "shroom_use-lifespawn" },
          },
          decrease: {
            store: { key: "shroom_lifespawn" },
            enable: { key: "shroom_use-lifespawn" },
            factor: -0.25,
          },
          increase: {
            store: { key: "shroom_lifespawn" },
            enable: { key: "shroom_use-lifespawn" },
            factor: 0.25,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom_use-lifespawn" },
          },
          title: { 
            text: "Override",
            enable: { key: "shroom_use-lifespawn" },
          },
        },
      },
      {
        name: "shroom_health-points",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Health",
            enable: { key: "shroom_use-health-points" },
          },  
          field: { 
            store: { key: "shroom_health-points" },
            enable: { key: "shroom_use-health-points" },
          },
          decrease: {
            store: { key: "shroom_health-points" },
            enable: { key: "shroom_use-health-points" },
            factor: -0.25,
          },
          increase: {
            store: { key: "shroom_health-points" },
            enable: { key: "shroom_use-health-points" },
            factor: 0.25,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom_use-health-points" },
          },
          title: { 
            text: "Override",
            enable: { key: "shroom_use-health-points" },
          },
        },
      },
      {
        name: "shroom_health-points-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "shroom_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Shroom texture",
              backgroundColor: VETheme.color.accentShadow,
            },
            input: { backgroundColor: VETheme.color.accentShadow },
            checkbox: { backgroundColor: VETheme.color.accentShadow },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "shroom_texture" } },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "shroom_texture" },
          },
          resolution: {
            store: { key: "shroom_texture" },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "shroom_texture" } },
            decrease: { store: { key: "shroom_texture" } },
            increase: { store: { key: "shroom_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              snapValue: 0.01 / 1.0,
              store: { key: "shroom_texture" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "shroom_texture" } },
            decrease: { store: { key: "shroom_texture" } },
            increase: { store: { key: "shroom_texture" } },
            checkbox: { 
              store: { key: "shroom_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Rng" }, 
            stick: { store: { key: "shroom_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "shroom_texture" } },
            decrease: { store: { key: "shroom_texture" } },
            increase: { store: { key: "shroom_texture" } },
            checkbox: { 
              store: { key: "shroom_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Animate" }, 
            stick: { store: { key: "shroom_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "shroom_texture" } },
            decrease: { store: { key: "shroom_texture" } },
            increase: { store: { key: "shroom_texture" } },
            stick: { store: { key: "shroom_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "shroom_texture" } },
            decrease: { store: { key: "shroom_texture" } },
            increase: { store: { key: "shroom_texture" } },
            stick: { store: { key: "shroom_texture" } },
          },
        },
      },
      {
        name: "shroom_texture-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "shroom_mask-property",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Collision mask",
            enable: { key: "use_shroom_mask" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "use_shroom_mask" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "shroom_preview_mask",
        template: VEComponents.get("preview-image-mask"),
        layout: VELayouts.get("preview-image-mask"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          preview: {
            enable: { key: "use_shroom_mask" },
            image: { name: "texture_empty" },
            store: { key: "shroom_texture" },
            mask: "shroom_mask",
          },
          resolution: {
            enable: { key: "use_shroom_mask" },
            store: { key: "shroom_texture" },
          },
        },
      },
      {
        name: "shroom_mask",
        template: VEComponents.get("vec4-stick-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          x: {
            label: {
              text: "X",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
            },
            stick: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
              treshold: 1024,
            },
            checkbox: { },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
            },
            stick: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
              treshold: 1024,
            },
            checkbox: { },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
            },
            stick: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
              treshold: 1024,
            },
            checkbox: { },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
            },
            stick: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
              factor: 1.0,
              treshold: 1024,
            },
            checkbox: { },
          },
        },
      },
      {
        name: "shroom_mask-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "shroom_game-mode_bullet-hell",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Shroom features",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "shroom_game-mode_bullet-hell_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "shroom_game-mode_bullet-hell_features" },
            updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          },
        },
      },
      /*
      {
        name: "shroom_game-mode_platformer",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Platformer" },
        },
      },
      {
        name: "shroom_game-mode_platformer_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "shroom_game-mode_platformer_features" },
          },
        },
      },
      {
        name: "shroom_game-mode_racing",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Racing" },
        },
      },
      {
        name: "shroom_game-mode_racing_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "shroom_game-mode_racing_features" },
          },
        },
      },
      */
    ]),
  }
}