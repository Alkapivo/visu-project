///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_bullet(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "bullet_use-lifespawn": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "lifespawnMax"), Number),
      },
      "bullet_lifespawn": {
        type: Number,
        value: Core.isType(Struct.get(json, "lifespawnMax"), Number) ? json.lifespawnMax : 15.0,
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 99.9)
        },
      },
      "bullet_use-damage": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "damage"), Number),
      },
      "bullet_damage": {
        type: Number,
        value: Struct.getIfType(json, "damage", Number, 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 999.9)
        },
      },
      "bullet_texture": {
        type: Sprite,
        value: SpriteUtil.parse(json.sprite, { name: "texture_bullet" }),
      },
      "use_bullet_mask": {
        type: Boolean,
        value: Optional.is(Struct.getIfType(json, "mask", Struct)),
      },
      "bullet_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getIfType(json, "mask", Struct)),
      },
      "bullet_use-wiggle": {
        type: Boolean,
        value: Struct.getIfType(json, "wiggle", Boolean, false),
      },
      "bullet_wiggle-time": {
        type: Number,
        value: Struct.getIfType(json, "wiggleTime", Number, 8.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 99.9)
        },
      },
      "bullet_use-wiggle-time-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "wiggleTimeRng", Boolean, false),
      },
      "bullet_wiggle-frequency": {
        type: Number,
        value: Struct.getIfType(json, "wiggleFrequency", Number, 8.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -99.9, 99.9)
        },
      },
      "bullet_use-wiggle-dir-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "wiggleDirRng", Boolean, false),
      },
      "bullet_wiggle-amplitude": {
        type: Number,
        value: Struct.getIfType(json, "wiggleAmplitude", Number, 5.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -99.9, 99.9)
        },
      },
      "bullet_use-angle-offset": {
        type: Boolean,
        value: Struct.getIfType(json, "useAngleOffset", Boolean, false),
      },
      "bullet_angle-offset": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, "angleOffset", {
          value: 0.0,
          target: 0.0,
          factor: 0.1,
          increase: 0.0
        })),
        passthrough: function(value) {
          if (!Core.isType(value, NumberTransformer)) {
            return this.value
          }

          value.value = clamp(value.value, -360.0, 360.0)
          value.target = clamp(value.target, -360.0, 360.0)
          return value
        },
      },
      "bullet_change-angle-offset": {
        type: Boolean,
        value: Struct.getIfType(json, "changeAngleOffset", Boolean, false),
      },
      "bullet_use-angle-offset-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "angleOffsetRng", Boolean, false),
      },
      "bullet_use-speed-offset": {
        type: Boolean,
        value: Struct.getIfType(json, "bullet_use-speed-offset", Boolean, false),
      },
      "bullet_speed-offset": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getIfType(json, "speedOffset", Struct, { 
          value: 0.0, 
          target: 0.0,
          factor: 0.0,
          increase: 0.0,
        })),
      },
      "bullet_change-speed-offset": {
        type: Boolean,
        value: Struct.getIfType(json, "bullet_change-speed-offset", Boolean, false),
      },
      "bullet_use-on-death": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "onDeath"), String),
      },
      "bullet_on-death": {
        type: String,
        value: Struct.getIfType(json, "onDeath", String, "bullet-default"),
        passthrough: function(value) {
          var bulletService = Beans.get(BeanVisuController).bulletService
          return bulletService.templates.contains(value) || Visu.assets().bulletTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "bullet-default")
        },
      },
      "bullet_on-death-amount": {
        type: Number,
        value: Struct.getIfType(json, "onDeathAmount", Number, 1),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 16))
        },
      },
      "bullet_on-death-angle": {
        type: Number,
        value: Struct.getIfType(json, "onDeathAngle", Number, 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -360.0, 360.0)
        },
      },
      "bullet_on-death-angle-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "onDeathAngleRng", Boolean, false),
      },
      "bullet_on-death-angle-step": {
        type: Number,
        value: Struct.getIfType(json, "onDeathAngleStep", Number, 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -360.0, 360.0)
        },
      },
      "bullet_on-death-rng-step": {
        type: Number,
        value: Struct.getIfType(json, "onDeathRngStep", Number, 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 360.0)
        },
      },
      "bullet_on-death-speed": {
        type: Number,
        value: Struct.getIfType(json, "onDeathSpeed", Number, 0.0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(-99.9, 99.9),
      },
      "bullet_on-death-speed-merge": {
        type: Boolean,
        value: Struct.getIfType(json, "onDeathSpeedMerge", Boolean, true),
      },
      "bullet_on-death-rng-speed": {
        type: Number,
        value: Struct.getIfType(json, "onDeathRngSpeed", Number, 0.0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
    }),
    components: new Array(Struct, [
      {
        name: "bullet_lifespawn",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lifespawn",
            enable: { key: "bullet_use-lifespawn" },
          },  
          field: { 
            store: { key: "bullet_lifespawn" },
            enable: { key: "bullet_use-lifespawn" },
          },
          decrease: {
            store: { key: "bullet_lifespawn" },
            enable: { key: "bullet_use-lifespawn" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_lifespawn" },
            enable: { key: "bullet_use-lifespawn" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_lifespawn" },
            enable: { key: "bullet_use-lifespawn" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "bullet_use-lifespawn" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
          title: {
            text: "Override",
            enable: { key: "bullet_use-lifespawn" },
          }
        },
      },
      {
        name: "bullet_damage",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Damage",
            enable: { key: "bullet_use-damage" },
          },  
          field: { 
            store: { key: "bullet_damage" },
            enable: { key: "bullet_use-damage" },
          },
          decrease: {
            store: { key: "bullet_damage" },
            enable: { key: "bullet_use-damage" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_damage" },
            enable: { key: "bullet_use-damage" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_damage" },
            enable: { key: "bullet_use-damage" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "bullet_use-damage" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
          title: {
            text: "Override",
            enable: { key: "bullet_use-damage" },
          }
        },
      },
      {
        name: "bullet_damage-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Bullet texture",
              backgroundColor: VETheme.color.accentShadow,
            },
            input: { backgroundColor: VETheme.color.accentShadow },
            checkbox: { backgroundColor: VETheme.color.accentShadow },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "bullet_texture" } },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "bullet_texture" },
          },
          resolution: {
            store: { key: "bullet_texture" },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "bullet_texture" } },
            decrease: { store: { key: "bullet_texture" } },
            increase: { store: { key: "bullet_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              snapValue: 0.01 / 1.0,
              store: { key: "bullet_texture" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "bullet_texture" } },
            decrease: { store: { key: "bullet_texture" } },
            increase: { store: { key: "bullet_texture" } },
            checkbox: { 
              store: { key: "bullet_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Rng" }, 
            stick: { store: { key: "bullet_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "bullet_texture" } },
            decrease: { store: { key: "bullet_texture" } },
            increase: { store: { key: "bullet_texture" } },
            checkbox: { 
              store: { key: "bullet_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
            title: { text: "Animate" }, 
            stick: { store: { key: "bullet_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "bullet_texture" } },
            decrease: { store: { key: "bullet_texture" } },
            increase: { store: { key: "bullet_texture" } },
            stick: { store: { key: "bullet_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "bullet_texture" } },
            decrease: { store: { key: "bullet_texture" } },
            increase: { store: { key: "bullet_texture" } },
            stick: { store: { key: "bullet_texture" } },
          },
        },
      },
      {
        name: "bullet_texture-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_mask-property",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Collision mask",
            enable: { key: "use_bullet_mask" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "use_bullet_mask" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "bullet_preview_mask",
        template: VEComponents.get("preview-image-mask"),
        layout: VELayouts.get("preview-image-mask"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          preview: {
            enable: { key: "use_bullet_mask" },
            image: { name: "texture_empty" },
            store: { key: "bullet_texture" },
            mask: "bullet_mask",
          },
          resolution: {
            enable: { key: "use_bullet_mask" },
            store: { key: "bullet_texture" },
          },
        },
      },
      {
        name: "bullet_mask",
        template: VEComponents.get("vec4-stick-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          x: {
            label: {
              text: "X",
              enable: { key: "use_bullet_mask" },
            },
            field: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 0.1,
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
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "bullet_mask" },
              enable: { key: "use_bullet_mask" },
              factor: 0.1,
            },
          },
        },
      },
      {
        name: "bullet_mask-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_movement-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Bullet movement",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            backgroundColor: VETheme.color.accentShadow,
          },
        },
      },
      {
        name: "bullet_speed-offset",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          value: {
            label: {
              text: "Speed",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "bullet_use-speed-offset" },
            },
            field: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_use-speed-offset" },
            },
            decrease: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_use-speed-offset" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_use-speed-offset" },
              factor: 1.0,        
            },
            stick: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_use-speed-offset" },
              factor: 0.001,        
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-speed-offset" },
            },
            title: { 
              text: "Override",
              enable: { key: "bullet_use-speed-offset" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_change-speed-offset" },
            },
            field: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
            },
            decrease: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: -1.0,
            },
            increase: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 1.0,
            },
            stick: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 0.001,        
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_change-speed-offset" },
            },
            title: { 
              text: "Change",
              enable: { key: "bullet_change-speed-offset" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_change-speed-offset" },
            },
            field: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
            },
            decrease: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: -0.01,
            },
            increase: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 0.01,
            },
            stick: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 0.001,        
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "bullet_change-speed-offset" },
            },
            field: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
            },
            decrease: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: -0.001,
            },
            increase: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 0.001,      
            },
            stick: {
              store: { key: "bullet_speed-offset" },
              enable: { key: "bullet_change-speed-offset" },
              factor: 0.0001,        
            },
          },
        },
      },
      {
        name: "bullet_speed-offset-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_angle-offset",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Angle",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "bullet_use-angle-offset" },
            },
            field: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_use-angle-offset" },
            },
            decrease: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_use-angle-offset" },
              factor: -0.25,
            },
            increase: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_use-angle-offset" },
              factor: 0.25,        
            },
            stick: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_use-angle-offset" },
              factor: 0.001,        
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-angle-offset" },
            },
            title: { 
              text: "Override",
              enable: { key: "bullet_use-angle-offset" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_change-angle-offset" },
            },
            field: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
            },
            decrease: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: -0.25,
            },
            increase: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: 0.25,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_change-angle-offset" },
            },
            title: { 
              text: "Change",
              enable: { key: "bullet_change-angle-offset" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_change-angle-offset" },
            },
            field: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
            },
            decrease: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: -0.01,
            },
            increase: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: 0.01,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-angle-offset-rng" },
            },
            title: {
              text: "Rand. dir.",
              enable: { key: "bullet_use-angle-offset-rng" },
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "bullet_change-angle-offset" },
            },
            field: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
            },
            decrease: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: -0.001,
            },
            increase: {
              store: { key: "bullet_angle-offset" },
              enable: { key: "bullet_change-angle-offset" },
              factor: 0.001,      
            },
          },
        },
      },
      {
        name: "bullet_angle-offset-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_angle-wiggle-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Wiggle",
            enable: { key: "bullet_use-wiggle" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-wiggle" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "bullet_wiggle-time",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Theta",
            enable: { key: "bullet_use-wiggle" },
          },  
          field: { 
            store: { key: "bullet_wiggle-time" },
            enable: { key: "bullet_use-wiggle" },
          },
          decrease: {
            store: { key: "bullet_wiggle-time" },
            enable: { key: "bullet_use-wiggle" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_wiggle-time" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_wiggle-time" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "bullet_use-wiggle-time-rng" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            enable: { key: "bullet_use-wiggle" },
          },
          title: {
            text: "Randomize",
            enable: { key: "bullet_use-wiggle" },
          }
        },
      },
      {
        name: "bullet_wiggle-frequency",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Frequency",
            enable: { key: "bullet_use-wiggle" },
          },  
          field: { 
            store: { key: "bullet_wiggle-frequency" },
            enable: { key: "bullet_use-wiggle" },
          },
          decrease: {
            store: { key: "bullet_wiggle-frequency" },
            enable: { key: "bullet_use-wiggle" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_wiggle-frequency" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_wiggle-frequency" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "bullet_use-wiggle-dir-rng" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            enable: { key: "bullet_use-wiggle" },
          },
          title: {
            text: "Rand. dir.",
            enable: { key: "bullet_use-wiggle" },
          },
        },
      },
      {
        name: "bullet_wiggle-amplitude",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amplitude",
            enable: { key: "bullet_use-wiggle" },
          },  
          field: { 
            store: { key: "bullet_wiggle-amplitude" },
            enable: { key: "bullet_use-wiggle" },
          },
          decrease: {
            store: { key: "bullet_wiggle-amplitude" },
            enable: { key: "bullet_use-wiggle" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_wiggle-amplitude" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_wiggle-amplitude" },
            enable: { key: "bullet_use-wiggle" },
            factor: 0.01,
          },
          checkbox: { },
        },
      },
      {
        name: "bullet_wiggle-amplitude-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_use-on-death",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn bullet on death",
            backgroundColor: VETheme.color.accentShadow,
            enable: { key: "bullet_use-on-death" },
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { 
            backgroundColor: VETheme.color.accentShadow,
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-on-death" },
          },
        },
      },
      {
        name: "bullet_on-death",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4, bottom: 2 },
          },
          label: { 
            text: "Bullet",
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death" },
            enable: { key: "bullet_use-on-death" },
          },
        },
      },
      {
        name: "bullet_on-death-amount",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amount",
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death-amount" },
            enable: { key: "bullet_use-on-death" },
            GMTF_DECIMAL: 0,
          },
          decrease: {
            store: { key: "bullet_on-death-amount" },
            enable: { key: "bullet_use-on-death" },
            factor: -1.0,
          },
          increase: {
            store: { key: "bullet_on-death-amount" },
            enable: { key: "bullet_use-on-death" },
            factor: 1.0,
          },
          stick: {
            store: { key: "bullet_on-death-amount" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.2,
          },
          checkbox: {
            store: { key: "bullet_on-death-angle-rng" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            enable: { key: "bullet_use-on-death" },
          },
          title: {
            text: "Rand. dir.",
            enable: { key: "bullet_use-on-death" },
          },
        },
      },
      {
        name: "bullet_on-detah-amount-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_on-death-angle",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle",
            font: "font_inter_10_bold",
            color: VETheme.color.textShadow,
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death-angle" },
            enable: { key: "bullet_use-on-death" },
          },
          decrease: {
            store: { key: "bullet_on-death-angle" },
            enable: { key: "bullet_use-on-death" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_on-death-angle" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_on-death-angle" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.66,
          },
          checkbox: { },
        },
      },
      {
        name: "bullet_on-death-angle-step",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle step",
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death-angle-step" },
            enable: { key: "bullet_use-on-death" },
          },
          decrease: {
            store: { key: "bullet_on-death-angle-step" },
            enable: { key: "bullet_use-on-death" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_on-death-angle-step" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_on-death-angle-step" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.1,
          },
          checkbox: { },
          title: {
            store: { key: "bullet_on-death-angle" },
            enable: { key: "bullet_use-on-death" },
            render: function() {
              if (Optional.is(this.preRender)) {
                this.preRender()
              }
              this.renderBackgroundColor()

              var store = this.store.getStore()
              var amount = store.getValue("bullet_on-death-amount")
              var angle = store.getValue("bullet_on-death-angle")
              var step = store.getValue("bullet_on-death-angle-step")

              var sprite = Struct.get(this, "sprite")
              if (!Core.isType(sprite, Sprite)) {
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
                Struct.set(this, "sprite", sprite)
              }

              var alpha = sprite.getAlpha()
              sprite.setAlpha(alpha * (Struct.get(this.enable, "value") == false ? 0.5 : 1.0))
                .scaleToFit(this.area.getHeight() * 2, this.area.getHeight() * 2)
              var _x = this.context.area.getX() + this.area.getX() + this.margin.left + this.margin.right + 2.0,
              var _y = this.context.area.getY() + this.area.getY() - this.margin.top
              for (var index = 0; index < amount; index++) {
                sprite
                  .setAngle(angle - (index * step))
                  .render(_x, _y)
              }

              sprite.setAlpha(alpha)
              return this
            },
          },
        },
      },
      {
        name: "bullet_on-detah-angle-step-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "bullet_on-death-speed",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Speed",
            font: "font_inter_10_bold",
            color: VETheme.color.textShadow,
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death-speed" },
            enable: { key: "bullet_use-on-death" },
          },
          decrease: {
            store: { key: "bullet_on-death-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_on-death-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_on-death-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "bullet_on-death-speed-merge" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            enable: { key: "bullet_use-on-death" },
          },
          title: {
            text: "Merge",
            enable: { key: "bullet_use-on-death" },
          }
        },
      },
      {
        name: "bullet_on-death-rng-speed",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Rng speed",
            enable: { key: "bullet_use-on-death" },
          },  
          field: { 
            store: { key: "bullet_on-death-rng-speed" },
            enable: { key: "bullet_use-on-death" },
          },
          decrease: {
            store: { key: "bullet_on-death-rng-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: -0.1,
          },
          increase: {
            store: { key: "bullet_on-death-rng-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.1,
          },
          stick: {
            store: { key: "bullet_on-death-rng-speed" },
            enable: { key: "bullet_use-on-death" },
            factor: 0.01,
          },
          checkbox: { },
        }
      },
    ]),
  }

  return template
}
