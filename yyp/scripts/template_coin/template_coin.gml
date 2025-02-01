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
        value: Struct.getIfType(json, "useSpeed", Boolean, false),
      },
      "coin_speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, "speed", {
          value: -3.0,
          target: 1.0,
          factor: 0.1,
          increase: 0.0
        })),
        passthrough: function(value) {
          if (!Core.isType(value, NumberTransformer)) {
            return this.value
          }

          value.value = clamp(value.value, -99.9, 99.9)
          value.target = clamp(value.target, -99.9, 99.9)
          return value
        },
      },
      "coin_change-speed": {
        type: Boolean,
        value: Struct.getIfType(json, "changeSpeed", Boolean, false),
      },
    }),
    components: new Array(Struct, [
      {
        name: "coin_category-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Coin type",
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "coin_category",
        template: VEComponents.get("spin-select"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          previous: { store: { key: "coin_category" } },
          preview: Struct.appendRecursive({ 
            store: { key: "coin_category" },
            preRender: function() { 
              Struct.set(this, "_text", this.label.text)
              this.label.text = String.toUpperCase(this.label.text)
            },
            postRender: function() { 
              this.label.text = this._text
            },
          }, Struct.get(VEStyles.get("spin-select-label"), "preview"), false),
          next: { store: { key: "coin_category" } },
        },
      },
      {
        name: "coin_category-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "coin_amount",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amount",
            //font: "font_inter_10_bold",
            //color: VETheme.color.textShadow,
            enable: { key: "coin_use-amount" },
          },  
          field: { 
            store: { key: "coin_amount" },
            enable: { key: "coin_use-amount" },
            GMTF_DECIMAL: 0,
          },
          decrease: {
            store: { key: "coin_amount" },
            enable: { key: "coin_use-amount" },
            factor: -1.0,
          },
          increase: {
            store: { key: "coin_amount" },
            enable: { key: "coin_use-amount" },
            factor: 1.0,
          },
          stick: {
            store: { key: "coin_amount" },
            enable: { key: "coin_use-amount" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "coin_use-amount" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
          title: {
            text: "Override",
            enable: { key: "coin_use-amount" },
          },
        },
      },
      {
        name: "coin_amount-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "coin_speed",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Speed",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "coin_use-speed" },
            },
            field: {
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
            },
            decrease: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_use-speed" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "coin_use-speed" },
            },
            title: { 
              text: "Override",
              enable: { key: "coin_use-speed" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "coin_change-speed" },
            },
            field: {
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
            },
            decrease: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "coin_change-speed" },
            },
            title: { 
              text: "Change",
              enable: { key: "coin_change-speed" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "coin_change-speed" },
            },
            field: {
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
            },
            decrease: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "coin_change-speed" },
            },
            field: {
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
            },
            decrease: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "coin_speed" },
              enable: { key: "coin_change-speed" },
              factor: 1.0,
            },
          },
        },
      },
      {
        name: "coin_speed-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "coin_sprite",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Coin texture",
              backgroundColor: VETheme.color.accentShadow,
            },
            input: { backgroundColor: VETheme.color.accentShadow },
            checkbox: { backgroundColor: VETheme.color.accentShadow },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "coin_sprite" } },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "coin_sprite" },
          },
          resolution: {
            store: { key: "coin_sprite" },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "coin_sprite" } },
            decrease: { store: { key: "coin_sprite" } },
            increase: { store: { key: "coin_sprite" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              snapValue: 0.01 / 1.0,
              store: { key: "coin_sprite" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "coin_sprite" } },
            decrease: { store: { key: "coin_sprite" } },
            increase: { store: { key: "coin_sprite" } },
            checkbox: { 
              store: { key: "coin_sprite" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Rng" }, 
            stick: { store: { key: "coin_sprite" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "coin_sprite" } },
            decrease: { store: { key: "coin_sprite" } },
            increase: { store: { key: "coin_sprite" } },
            checkbox: { 
              store: { key: "coin_sprite" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Animate" }, 
            stick: { store: { key: "coin_sprite" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "coin_sprite" } },
            decrease: { store: { key: "coin_sprite" } },
            increase: { store: { key: "coin_sprite" } },
            stick: { store: { key: "coin_sprite" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "coin_sprite" } },
            decrease: { store: { key: "coin_sprite" } },
            increase: { store: { key: "coin_sprite" } },
            stick: { store: { key: "coin_sprite" } },
          },
        },
      },
      {
        name: "coin_sprite-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "coin_mask-property",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Collision mask",
            enable: { key: "coin_use-mask" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "coin_use-mask" },
            backgroundColor: VETheme.color.side
          },
        },
      },
      {
        name: "coin_preview_mask",
        template: VEComponents.get("preview-image-mask"),
        layout: VELayouts.get("preview-image-mask"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          preview: {
            enable: { key: "coin_use-mask" },
            image: { name: "texture_empty" },
            store: { key: "coin_sprite" },
            mask: "coin_mask",
          },
          resolution: {
            enable: { key: "coin_use-mask" },
            store: { key: "coin_sprite" },
          },
        },
      },
      {
        name: "coin_mask",
        template: VEComponents.get("vec4-stick-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          x: {
            label: {
              text: "X",
              enable: { key: "coin_use-mask" },
            },
            field: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "coin_mask" },
              enable: { key: "coin_use-mask" },
              factor: 0.1,
            },
          },
        },
      },
    ]),
  }

  return template
}