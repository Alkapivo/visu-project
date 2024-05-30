///@package io.alkapivo.visu.editor.api.template



///@param {Struct} json
///@return {Struct}
function template_shroom(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "shroom_texture": {
        type: Sprite,
        value: SpriteUtil.parse(json.sprite, { name: "texture_missing" }),
      },
      "use_shroom_mask": {
        type: Boolean,
        value: Optional.is(Struct.getDefault(json, "mask", null)),
      },
      "shroom_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getDefault(json, "mask", null)),
      },
      "shroom_game-mode_bullet-hell_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.bulletHell, "features", []), { pretty: true })
      },
      "shroom_game-mode_platformer_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.platformer, "features", []), { pretty: true })
      },
      "shroom_game-mode_racing_features": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json.gameModes.racing, "features", []), { pretty: true })
      },
    }),
    components: new Array(Struct, [
      {
        name: "shroom_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Set texture" },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "shroom_texture" } },
          },
          animate: {
            label: { text: "Animate" }, 
            checkbox: { 
              store: { key: "shroom_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "shroom_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "shroom_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "shroom_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "shroom_texture" } },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "shroom_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "shroom_texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "shroom_texture" },
          },
          resolution: {
            store: { key: "shroom_texture" },
          },
        },
      },
      {
        name: "shroom_mask",
        template: VEComponents.get("vec4-field"),
        layout: VELayouts.get("vec4-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Custom collision mask",
              enable: { key: "use_shroom_mask" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "use_shroom_mask" },
            },
          },
          x: {
            label: {
              text: "X",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "use_shroom_mask" },
            },
            field: {
              store: { key: "shroom_mask" },
              enable: { key: "use_shroom_mask" },
            },
          },
        },
      },
      {
        name: "shroom_game-mode_bullet-hell",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "BulletHell" },
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
          },
        },
      },
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
    ]),
  }

  return template
}