///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_particle(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "particle_use-preview": {
        type: Boolean,
        value: Struct.getDefault(json, "particle_use-preview", false) == true,
      },
      "particle-template": {
        type: ParticleTemplate,
        value: new ParticleTemplate(json.name, json),
      },
      "particle-blend": {
        type: Boolean,
        value: Struct.getDefault(json, "blend", false) == true,
      },
      "particle-color-start": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "start"), "#ffffff"),
      },
      "particle-color-halfway": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "start"), "#ffffff"),
      },
      "particle-color-finish": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "start"), "#ffffff"),
      },
      "particle-use-sprite": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "sprite")),
      },
      "particle-sprite": {
        type: Sprite,
        value: SpriteUtil.parse(Struct.get(json, "sprite"), { name: "texture_particle" }),
      },
      "particle-sprite-animate": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "sprite"))
          ? Struct.getDefault(json.sprite, "animate", false) == true
          : false,
      },
      "particle-sprite-randomValue": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "sprite"))
          ? Struct.getDefault(json.sprite, "randomValue", false) == true
          : false,
      },
      "particle-sprite-stretch": {
        type: Boolean,
        value: Optional.is(Struct.get(json, "sprite"))
          ? Struct.getDefault(json.sprite, "stretch", false) == true
          : false,
      },
    }),
    components: new Array(Struct, [
      {
        name: "particle_use-preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Particle preview",
            enable: { key: "particle_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "particle_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      #region Shape
      {
        name: "particle_shape",
        template: VEComponents.get("spin-select-override"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Shape" },
          previous: { 
            callback: function() {
              var template = this.store.get("particle-template").get()
              var keys = ParticleShape.keys()
              var index = keys.findIndex(function(key, index, acc) { ///@todo move to Lambda util
                return key == acc
              }, template.shape)
              index = index - 1 < 0 ? keys.size() - 1 : index - 1
              template.shape = keys.get(index)
              this.store.get("particle-template").set(template)
            },
            store: { 
              key: "particle-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
          preview: Struct.appendRecursive({ 
            store: {
              key: "particle-template",
              callback: function(value, data) {
                if (!Core.isType(value, ParticleTemplate)) {
                  return
                }
                data.label.text = value.shape
              }
            },
          }, Struct.get(VEStyles.get("spin-select-label_no-store"), "preview"), false),
          next: { 
            callback: function() {
              var template = this.store.get("particle-template").get()
              var keys = ParticleShape.keys()
              var index = keys.findIndex(function(key, index, acc) { ///@todo move to Lambda util
                return key == acc
              }, template.shape)
              index = index + 1 >= keys.size() ? 0 : index + 1
              template.shape = keys.get(index)
              this.store.get("particle-template").set(template)
            },
            store: { 
              key: "particle-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
        },
      },
      #endregion
      #region Blend
      {
        name: "particle_blend",
        template: VEComponents.get("boolean-field"),
        layout: VELayouts.get("boolean-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Blend" },
          field: { 
            store: { key: "particle-blend" },
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
          },
        },
      },
      #endregion
      #region Sprite
      {
        name: "particle_sprite",
        template: VEComponents.get("texture-field-simple"),
        layout: VELayouts.get("texture-field-simple"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Set texture",
              enable: { key: "particle-use-sprite" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "particle-use-sprite" },
            },
          },
          texture: {
            label: {
              text: "Texture",
              enable: { key: "particle-use-sprite" },
            }, 
            field: {
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
          },
          frame: {
            label: {
              text: "Frame",
              enable: { key: "particle-use-sprite" },
            },
            field: {
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
          },
          alpha: {
            label: {
              text: "Alpha",
              enable: { key: "particle-use-sprite" },
            },
            field: {
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "particle-sprite" },
            enable: { key: "particle-use-sprite" },
          },
        },
      },
      {
        name: "particle_sprite-animate",
        template: VEComponents.get("boolean-field"),
        layout: VELayouts.get("boolean-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Animate",
            enable: { key: "particle-use-sprite" },
          },
          field: { 
            store: { key: "particle-sprite-animate" },
            enable: { key: "particle-use-sprite" },
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
          },
        },
      },
      {
        name: "particle_sprite-stretch",
        template: VEComponents.get("boolean-field"),
        layout: VELayouts.get("boolean-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Stretch",
            enable: { key: "particle-use-sprite" },
          },
          field: { 
            store: { key: "particle-sprite-stretch" },
            enable: { key: "particle-use-sprite" },
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
          },
        },
      },
      {
        name: "particle_sprite-randomValue",
        template: VEComponents.get("boolean-field"),
        layout: VELayouts.get("boolean-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Random",
            enable: { key: "particle-use-sprite" },
          },
          field: { 
            store: { key: "particle-sprite-randomValue" },
            enable: { key: "particle-use-sprite" },
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
          },
        },
      },
      #endregion
      #region Color
      {
        name: "particle_color-start",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Start color" },  
            input: { store: { key: "particle-color-start" } }
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: "particle-color-start" } },
            slider: { store: { key: "particle-color-start" } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: "particle-color-start" } },
            slider: { store: { key: "particle-color-start" } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: "particle-color-start" } },
            slider: { store: { key: "particle-color-start" } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: "particle-color-start" } },
          },
        },
      },
      {
        name: "particle_color-halfway",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Halfway color" },  
            input: { store: { key: "particle-color-halfway" } }
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: "particle-color-halfway" } },
            slider: { store: { key: "particle-color-halfway" } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: "particle-color-halfway" } },
            slider: { store: { key: "particle-color-halfway" } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: "particle-color-halfway" } },
            slider: { store: { key: "particle-color-halfway" } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: "particle-color-halfway" } },
          },
        },
      },
      {
        name: "particle_color-finish",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Finish color" },  
            input: { store: { key: "particle-color-finish" } }
          },
          red: {
            label: { text: "Red" },
            field: { store: { key: "particle-color-finish" } },
            slider: { store: { key: "particle-color-finish" } },
          },
          green: {
            label: { text: "Green", },
            field: { store: { key: "particle-color-finish" } },
            slider: { store: { key: "particle-color-finish" } },
          },
          blue: {
            label: { text: "Blue" },
            field: { store: { key: "particle-color-finish" } },
            slider: { store: { key: "particle-color-finish" } },
          },
          hex: { 
            label: { text: "Hex" },
            field: { store: { key: "particle-color-finish" } },
          },
        },
      },
      #endregion
      #region Alpha
      {
        name: "particle_alpha",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Alpha" },
        },
      },
      {
        name: "particle_alpha-start",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Start" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.start)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.start = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.start)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.start = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 1.0,
          }
        },
      },
      {
        name: "particle_alpha-halfway",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Halfway" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.halfway)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.halfway = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
          },
          slider: { 
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.halfway)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.halfway = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 1.0,
          },
        },
      },
      {
        name: "particle_alpha-finish",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Finish" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.finish)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.finish = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.alpha.finish)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.alpha.finish = clamp(parsed, 0.0, 1.0)
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 1.0,
          }
        },minValue: 0.0,
            maxValue: 1.0,
      },
      #endregion
      #region Angle
      {
        name: "particle_angle",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Angle" },
        },
      },
      {
        name: "particle_angle-wiggle",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Wiggle" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.wiggle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.wiggle = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_angle-increase",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Inc." },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.increase)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.increase = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_angle-minValue",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Min" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.minValue = parsed
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.minValue = parsed
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 360.0
          }
        },
      },
      {
        name: "particle_angle-maxValue",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.maxValue = parsed
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.angle.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.angle.maxValue = parsed
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 360.0,
          }
        },
      },
      #endregion
      #region Size
      {
        name: "particle_size",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Size" },
        },
      },
      {
        name: "particle_size-wiggle",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Wiggle" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.size.wiggle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.size.wiggle = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_size-increase",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Inc." },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.size.increase)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.size.increase = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_size-minValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Min" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.size.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.size.minValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_size-maxValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.size.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.size.maxValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      #endregion
      #region Speed
      {
        name: "particle_speed",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Speed" },
        },
      },
      {
        name: "particle_speed-wiggle",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Wiggle" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.speed.wiggle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.speed.wiggle = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_speed-increase",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Inc." },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.speed.increase)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.speed.increase = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_speed-minValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Min" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.speed.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.speed.minValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_speed-maxValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.speed.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.speed.maxValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      #endregion
      #region Scale
      {
        name: "particle_scale",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Scale" },
        },
      },
      {
        name: "particle_scale-x",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "X" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.scale.x)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.scale.x = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_scale-y",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Y" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.scale.y)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.scale.y = parsed
                item.set(template)
              },
            },
          },
        },
      },
      #endregion
      #region Gravity
      {
        name: "particle_gravity",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Gravity" },
        },
      },
      {
        name: "particle_gravity-angle",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Angle" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.gravity.angle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.gravity.angle = parsed
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.gravity.angle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.gravity.angle = parsed
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 360.0,
          }
        },
      },
      {
        name: "particle_gravity-amount",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Amount" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.gravity.amount)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.gravity.amount = parsed
                item.set(template)
              },
            },
          },
        },
      },
      #endregion
      #region Life
      {
        name: "particle_life",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Life" },
        },
      },
      {
        name: "particle_life-minValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Min" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.life.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.life.minValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_life-maxValue",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.life.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.life.maxValue = parsed
                item.set(template)
              },
            },
          },
        },
      },
      #endregion
      #region Orientation
      {
        name: "particle_orientation",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Orientation" },
        },
      },
      {
        name: "particle_orientation-relative",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Relat." },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.relative)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.relative = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_orientation-wiggle",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Wiggle" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.wiggle)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.wiggle = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_orientation-increase",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Inc." },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.increase)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.increase = parsed
                item.set(template)
              },
            },
          },
        },
      },
      {
        name: "particle_orientation-minValue",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Min" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.minValue = parsed
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.minValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.minValue = parsed
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 360.0,
          }
        },
      },
      {
        name: "particle_orientation-maxValue",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Max" },
          field: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.textField.setText(parsed)
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.maxValue = parsed
                item.set(template)
              },
            },
          },
          slider: {
            store: {
              key: "particle-template",
              callback: function(value, data) {
                var parsed = NumberUtil.parse(value.orientation.maxValue)
                if (!Core.isType(parsed, Number)) {
                  return
                }

                data.value = parsed
              },
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), ParticleTemplate)) {
                  return
                }

                var template = item.get()
                template.orientation.maxValue = parsed
                item.set(template)
              },
            },
            minValue: 0.0,
            maxValue: 360.0,
          }
        },
      },
      #endregion
    ]),
  }
  return template
}
