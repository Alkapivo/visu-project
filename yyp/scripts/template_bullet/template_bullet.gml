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
      "bullet_use-damage": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "damage"), Number),
      },
      "bullet_damage": {
        type: Number,
        value: Core.isType(Struct.get(json, "damage"), Number) ? json.damage : 1.0,
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 999.9))
        },
      },
      "bullet_use-lifespawn": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "lifespawnMax"), Number),
      },
      "bullet_lifespawn": {
        type: Number,
        value: Core.isType(Struct.get(json, "lifespawnMax"), Number) ? json.lifespawnMax : 30.0,
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 99.9)
        },
      },
      "bullet_use-template-on-death": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "bulletTemplateOnDeath"), String),
      },
      "bullet_template-on-death": {
        type: String,
        value: Core.isType(Struct.get(json, "bulletTemplateOnDeath"), String) ? json.bulletTemplateOnDeath : "bullet-default",
        passthrough: function(value) {
          var bulletService = Beans.get(BeanVisuController).bulletService
          return bulletService.templates.contains(value) || Visu.assets().bulletTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "bullet-default")
        },
      },
      "bullet_template-amount-on-death": {
        type: Number,
        value: Core.isType(Struct.get(json, "bulletAmountOnDeath"), Number) ? json.bulletAmountOnDeath : 1,
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 1, 16))
        },
      },
      "bullet_template-spawn-angle-on-death": {
        type: Number,
        value: Core.isType(Struct.get(json, "bulletSpawnAngleOnDeath"), Number) ? json.bulletSpawnAngleOnDeath : 0.0,
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -360.0, 360.0)
        },
      },
      "bullet_template-angle-step-on-death": {
        type: Number,
        value: Core.isType(Struct.get(json, "bulletAngleStepOnDeath"), Number) ? json.sth : 0.0,
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -360.0, 360.0)
        },
      },
      "bullet_use-transform-speed": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "speedTransformer"), Struct),
      },
      "bullet_transform-speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "speedTransformer")),
      },
      "bullet_use-transform-angle": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "angleTransformer"), Struct),
      },
      "bullet_transform-angle": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "angleTransformer")),
      },
      "bullet_use-random-direction": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "randomDirection"), Boolean),
      },
      "bullet_random-direction": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "randomDirection"), Boolean) 
          ? json.randomDirection 
          : false,
      },
      "bullet_use-transform-swing-amount": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "swingAmount"), Struct),
      },
      "bullet_transform-swing-amount": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "swingAmount")),
      },
      "bullet_use-transform-swing-size": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "swingSize"), Struct),
      },
      "bullet_transform-swing-size": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.get(json, "swingSize")),
      },
    }),
    components: new Array(Struct, [
      {
        name: "bullet_use-damage",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set damage",
            enable: { key: "bullet_use-damage" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-damage" },
          },
        },
      },
      {
        name: "bullet_damage",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
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
        },
      },
      {
        name: "bullet_use-lifespawn",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Set max lifespawn",
            enable: { key: "bullet_use-lifespawn" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-lifespawn" },
          },
        },
      },
      {
        name: "bullet_lifespawn",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Damage",
            enable: { key: "bullet_use-lifespawn" },
          },  
          field: { 
            store: { key: "bullet_lifespawn" },
            enable: { key: "bullet_use-lifespawn" },
          },
        },
      },
      {
        name: "bullet_use-template-on-death",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn bullet on death",
            enable: { key: "bullet_use-template-on-death" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-template-on-death" },
          },
        },
      },
      {
        name: "bullet_template-on-death",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Template",
            enable: { key: "bullet_use-template-on-death" },
          },  
          field: { 
            store: { key: "bullet_template-on-death" },
            enable: { key: "bullet_use-template-on-death" },
          },
        },
      },
      {
        name: "bullet_template-amount-on-death",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amount",
            enable: { key: "bullet_use-template-on-death" },
          },  
          field: { 
            store: { key: "bullet_template-amount-on-death" },
            enable: { key: "bullet_use-template-on-death" },
          },
        },
      },
      {
        name: "bullet_template-spawn-angle-on-death",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Start angle",
            enable: { key: "bullet_use-template-on-death" },
          },  
          field: { 
            store: { key: "bullet_template-spawn-angle-on-death" },
            enable: { key: "bullet_use-template-on-death" },
          },
        },
      },
      {
        name: "bullet_template-angle-step-on-death",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle step",
            enable: { key: "bullet_use-template-on-death" },
          },  
          field: { 
            store: { key: "bullet_template-angle-step-on-death" },
            enable: { key: "bullet_use-template-on-death" },
          },
        },
      },
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
        name: "bullet_transform-speed",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform speed",
              enable: { key: "bullet_use-transform-speed" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-transform-speed" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_use-transform-speed" },
            },
            field: {
              store: { key: "bullet_transform-speed" },
              enable: { key: "bullet_use-transform-speed" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_use-transform-speed" },
            },
            field: {
              store: { key: "bullet_transform-speed" },
              enable: { key: "bullet_use-transform-speed" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "bullet_use-transform-speed" },
            },
            field: {
              store: { key: "bullet_transform-speed" },
              enable: { key: "bullet_use-transform-speed" },
            },
          },
        },
      },
      {
        name: "bullet_transform-angle",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform angle",
              enable: { key: "bullet_use-transform-angle" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-transform-angle" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_use-transform-angle" },
            },
            field: {
              store: { key: "bullet_transform-angle" },
              enable: { key: "bullet_use-transform-angle" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_use-transform-angle" },
            },
            field: {
              store: { key: "bullet_transform-angle" },
              enable: { key: "bullet_use-transform-angle" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "bullet_use-transform-angle" },
            },
            field: {
              store: { key: "bullet_transform-angle" },
              enable: { key: "bullet_use-transform-angle" },
            },
          },
        },
      },
      {
        name: "bullet_random-direction",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Randomize direction",
            enable: { key: "bullet_use-random-direction" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "bullet_use-random-direction" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "bullet_random-direction" },
            enable: { key: "bullet_use-random-direction" },
          },
        },
      },
      {
        name: "bullet_transform-swing-amount",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform swing amount",
              enable: { key: "bullet_use-transform-swing-amount" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-transform-swing-amount" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_use-transform-swing-amount" },
            },
            field: {
              store: { key: "bullet_transform-swing-amount" },
              enable: { key: "bullet_use-transform-swing-amount" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_use-transform-swing-amount" },
            },
            field: {
              store: { key: "bullet_transform-swing-amount" },
              enable: { key: "bullet_use-transform-swing-amount" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "bullet_use-transform-swing-amount" },
            },
            field: {
              store: { key: "bullet_transform-swing-amount" },
              enable: { key: "bullet_use-transform-swing-amount" },
            },
          },
        },
      },
      {
        name: "bullet_transform-swing-size",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform swing size",
              enable: { key: "bullet_use-transform-swing-size" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "bullet_use-transform-swing-size" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "bullet_use-transform-swing-size" },
            },
            field: {
              store: { key: "bullet_transform-swing-size" },
              enable: { key: "bullet_use-transform-swing-size" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "bullet_use-transform-swing-size" },
            },
            field: {
              store: { key: "bullet_transform-swing-size" },
              enable: { key: "bullet_use-transform-swing-size" },
            },
          },
          increment: {
            label: {
              text: "Increment",
              enable: { key: "bullet_use-transform-swing-size" },
            },
            field: {
              store: { key: "bullet_transform-swing-size" },
              enable: { key: "bullet_use-transform-swing-size" },
            },
          },
        },
      },
    ]),
  }

  return template
}