///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_coin(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "coin_category": {
        type: String,
        value: Struct.getDefault(json, "category", CoinCategory.POINT),
        validate: function(value) {
          Assert.isTrue(this.data.contains(value))
        },
        data: CoinCategory.keys().map(function(key) {
          return CoinCategory.get(key)
        })
      },
      "coin_sprite": {
        type: Sprite,
        value: SpriteUtil.parse(Struct.get(json, "sprite"), { name: "texture_coin" }),
      },
      "coin_use-mask": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "mask")),
      },
      "coin_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getDefault(json, "mask", null)),
      },
      "coin_use-amount": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "amount")),
      },
      "coin_amount": {
        type: Number,
        value: Core.isType(Struct.get(json, "amount"), Number) ? json.amount : 1,
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 10))
        },
      },
      "coin_use-speed": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "speed")),
      },
      "coin_speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "speed",
          { value: -3.0, target: 1, factor: 0.1, increase: 0 },
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "coin_category",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Category" },
          previous: { store: { key: "coin_category" } },
          preview: Struct.appendRecursive({ 
            store: { key: "coin_category" },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "coin_category" } },
        },
      },
      {
        name: "coin_sprite",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Set texture" },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "coin_sprite" } },
          },
          animate: {
            label: { text: "Animate" }, 
            checkbox: { 
              store: { key: "coin_sprite" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "coin_sprite" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "coin_sprite" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "coin_sprite" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "coin_sprite" } },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "coin_sprite" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "coin_sprite" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "coin_sprite" },
          },
          resolution: {
            store: { key: "coin_sprite" },
          },
        },
      },
      {
        name: "coin_mask",
        template: VEComponents.get("vec4-field"),
        layout: VELayouts.get("vec4-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Mask",
              enable: { key: "coin_use-mask" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "coin_use-mask" },
            },
          },
          x: {
            label: {
              text: "X",
              enable: { key: "coin_use-mask" },
            },
            field: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "coin_use-mask" },
            },
            field: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "coin_use-mask" },
            },
            field: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "coin_use-mask" },
            },
            field: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
            },
          },
        },
      },
      {
        name: "coin_use-amount",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Use amount",
            enable: { key: "coin_use-amount" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "coin_use-amount" },
          },
        },
      },
      {
        name: "coin_amount",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amount",
            enable: { key: "coin_use-amount" },
          },  
          field: { 
            store: { key: "coin_amount" },
            enable: { key: "coin_use-amount" },
          },
        },
      },
      {
        name: "coin_speed",
        template: VEComponents.get("transform-numeric-uniform"),
        layout: VELayouts.get("transform-numeric-uniform"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          title: { 
            label: { 
              text: "Speed",
              enable: { key: "coin_use-speed" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "coin_use-speed" },
            },
          },
          value: {
            label: { 
              text: "Begin",
              enable: { key: "coin_use-speed" },
            },
            field: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "coin_use-speed" },
            },
            field: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "coin_use-speed" },
            },
            field: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
            },
          },
          increase: {
            label: { 
              text: "Increase",
              enable: { key: "coin_use-speed" },
            },
            field: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
            },
          },
        },
      },
    ]),
  }

  return template
}