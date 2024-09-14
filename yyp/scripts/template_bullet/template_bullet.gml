///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_bullet(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "bullet_texture": {
        type: Sprite,
        value: SpriteUtil.parse(json.sprite, { name: "texture_bullet" }),
      },
      "use_bullet_mask": {
        type: Boolean,
        value: Struct.getDefault(json, "mask", false) == true,
      },
      "bullet_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getDefault(json, "mask", null)),
      },
      "bullet_game-mode_bullet-hell_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.bulletHell, "features", []), { pretty: true })
      },
      "bullet_game-mode_platformer_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.platformer, "features", []), { pretty: true })
      },
      "bullet_game-mode_racing_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.racing, "features", []), { pretty: true })
      },
    }),
    components: new Array(Struct, [
      {
        name: "bullet-texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Set texture" },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "bullet_texture" } },
          },
          animate: {
            label: { text: "Animate" }, 
            checkbox: { 
              store: { key: "bullet_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          randomFrame: {
            label: { text: "Random frame" }, 
            checkbox: { 
              store: { key: "bullet_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "bullet_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "bullet_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "bullet_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "bullet_texture" } },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "bullet_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "bullet_texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "bullet_texture" },
          },
          resolution: {
            store: { key: "bullet_texture" },
          },
        },
      },
      {
        name: "bullet_mask",
        template: VEComponents.get("vec4-field"),
        layout: VELayouts.get("vec4-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Mask",
              enable: { key: "use_bullet_mask" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "use_bullet_mask" },
            },
          },
          x: {
            label: {
              text: "X",
              enable: { key: "use_bullet_mask" },
            },
            field: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "use_bullet_mask" },
            },
            field: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "use_bullet_mask" },
            },
            field: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "use_bullet_mask" },
            },
            field: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
            },
          },
        },
      },
      {
        name: "bullet_game-mode_bullet-hell",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "BulletHell" },
        },
      },
      {
        name: "bullet_game-mode_bullet-hell_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "bullet_game-mode_bullet-hell_features" },
          },
        },
      },
      {
        name: "bullet_game-mode_platformer",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Platformer" },
        },
      },
      {
        name: "bullet_game-mode_platformer_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "bullet_game-mode_platformer_features" },
          },
        },
      },
      {
        name: "bullet_game-mode_racing",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Racing" },
        },
      },
      {
        name: "bullet_game-mode_racing_features",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "bullet_game-mode_racing_features" },
          },
        },
      },
    ]),
  }

  return template
}