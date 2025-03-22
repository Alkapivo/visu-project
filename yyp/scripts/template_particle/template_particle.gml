///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_particle(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "particle_use-preview": {
        type: Boolean,
        value: Struct.getIfType(json, "particle_use-preview", Boolean, false),
      },
      "particle-template": {
        type: ParticleTemplate,
        value: new ParticleTemplate(json.name, json),
      },
      "particle-blend": {
        type: Boolean,
        value: Struct.getIfType(json, "blend", Boolean, false),
      },
      "particle-color-start": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "start"), ColorUtil.fromHex("#ffffff")),
      },
      "particle-color-halfway": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "halfway"), ColorUtil.fromHex("#ffffff")),
      },
      "particle-color-finish": {
        type: Color,
        value: ColorUtil.fromHex(Struct.get(Struct.get(json, "color"), "finish"), ColorUtil.fromHex("#ffffff")),
      },
      "particle-use-sprite": {
        type: Boolean,
        value: Optional.is(Struct.getIfType(json, "sprite", Struct)),
      },
      "particle-sprite": {
        type: Sprite,
        value: SpriteUtil.parse(Struct.getIfType(json, "sprite", Struct), { name: "texture_particle" }),
      },
      "particle-sprite-stretch": {
        type: Boolean,
        value: Core.isType(Struct.get(json, "sprite"), Struct)
          ? Struct.getIfType(json.sprite, "stretch", Boolean, false)
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
            text: "Emit particle preview",
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
      {
        name: "particle_blend",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Blend",
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "particle-blend" },
          },
        },
      },
      {
        name: "particle_blend-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_sprite",
        template: VEComponents.get("texture-field-simple"),
        layout: VELayouts.get("texture-field-simple"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Particle texture",
              enable: { key: "particle-use-sprite" },
              backgroundColor: VETheme.color.side,
            },  
            input: {
              backgroundColor: VETheme.color.side,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "particle-use-sprite" },
              backgroundColor: VETheme.color.side,
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
          preview: {
            image: { name: "texture_empty" },
            store: { key: "particle-sprite" },
            enable: { key: "particle-use-sprite" },
          },
          resolution: {
            store: { key: "particle-sprite" },
            enable: { key: "particle-use-sprite" },
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
            decrease: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            increase: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            checkbox: { 
              store: { key: "particle-sprite" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "particle-use-sprite" },
            },
            title: { 
              enable: { key: "particle-use-sprite" }
            },
            stick: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
          },
          speed: {
            label: {
              text: "Speed",
              enable: { key: "particle-use-sprite" },
            },
            field: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            decrease: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            increase: { 
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
            checkbox: { 
              store: { key: "particle-sprite" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "particle-use-sprite" },
            },
            title: {
              enable: { key: "particle-use-sprite" },
            },
            stick: {
              store: { key: "particle-sprite" },
              enable: { key: "particle-use-sprite" },
            },
          },
        },
      },
      {
        name: "particle_sprite-stretch",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Stretch",
            color: VETheme.color.textShadow,
            enable: { key: "particle-use-sprite" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "particle-sprite-stretch" },
            enable: { key: "particle-use-sprite" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "particle_sprite-stretch-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_shape-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Particle shape",
            enable: { 
              key: "particle-use-sprite",
              negate: true,
            },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { 
              key: "particle-use-sprite",
              callback: function(value, data) {
                Struct.set(data, "value", !value)
              },
              set: function(value) {
                var item = this.get()
                if (!Core.isType(value, Boolean)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), Boolean)) {
                  return
                }

                item.set(!value)
                //this.context.updateValue(!value)
              },  
            },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "particle_shape",
        template: VEComponents.get("spin-select-override"),
        layout: VELayouts.get("spin-select"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          previous: { 
            callback: function() {
              var template = this.store.get("particle-template").get()
              var keys = ParticleShape.keys()
              var index = keys.findIndex(Lambda.equal, template.shape)
              index = index - 1 < 0 ? keys.size() - 1 : index - 1
              template.shape = keys.get(index)
              this.store.get("particle-template").set(template)
            },
            store: { 
              key: "particle-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
            enable: { 
              key: "particle-use-sprite",
              negate: true,
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
            enable: { 
              key: "particle-use-sprite",
              negate: true,
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
            enable: { 
              key: "particle-use-sprite",
              negate: true,
            },
          },
        },
      },
      {
        name: "particle_shape-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_color-start",
        template: VEComponents.get("color-picker"),
        layout: VELayouts.get("color-picker"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          line: { disable: false },
          title: {
            label: {
              text: "Start color",
              backgroundColor: VETheme.color.side,
              color: VETheme.color.textShadow,
            }, 
            input: {
              store: { key: "particle-color-start" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: {
              backgroundColor: VETheme.color.side,
            },
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
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          //line: { disable: true },
          title: {
            label: {
              text: "Halfway color",
              backgroundColor: VETheme.color.side,
              color: VETheme.color.textShadow,
            }, 
            input: {
              store: { key: "particle-color-halfway" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: {
              backgroundColor: VETheme.color.side,
            },
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
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          //line: { disable: true },
          title: {
            label: {
              text: "Finish color",
              backgroundColor: VETheme.color.side,
              color: VETheme.color.textShadow,
            }, 
            input: {
              store: { key: "particle-color-finish" },
              backgroundColor: VETheme.color.side,
            },
            checkbox: {
              backgroundColor: VETheme.color.side,
            },
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
      {
        name: "particle-color-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: {
          type: UILayoutType.VERTICAL,
          margin: { top: 4, bottom: 3 },
        } },
      },
      {
        name: "particle_alpha",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Alpha",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_alpha-start",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.start = clamp(template.alpha.start + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.start = clamp(template.alpha.start + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
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
            snapValue: 0.01 / 1.0,
            minValue: 0.0,
            maxValue: 1.0,
          }
        },
      },
      {
        name: "particle_alpha-halfway",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
          decrease: {
            factor: -0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.halfway = clamp(template.alpha.halfway + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.halfway = clamp(template.alpha.halfway + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
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
            snapValue: 0.01 / 1.0,
          },
        },
      },
      {
        name: "particle_alpha-finish",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
          decrease: {
            factor: -0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.finish = clamp(template.alpha.finish + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.alpha.finish = clamp(template.alpha.finish + this.factor, 0.0, 1.0)
              item.set(template)
            },
            store: { key: "particle-template" },
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
            snapValue: 0.01 / 1.0,
          }
        },
      },
      {
        name: "particle-alpha-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_angle",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Angle",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_angle-wiggle",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.wiggle = clamp(template.angle.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.wiggle = clamp(template.angle.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().angle.wiggle = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().angle.wiggle
            },
          },
          checkbox: { 
            store: { 
              key: "particle-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
            render: function() {
              var template = this.store.getValue()
              if (!Optional.is(template)) {
                return this
              }

              var sprite = Struct.get(this, "sprite")
              if (!Core.isType(sprite, Sprite)) {
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
                Struct.set(this, "sprite", sprite)
              }

              sprite.scaleToFit(this.area.getWidth() * 2, this.area.getHeight() * 2)
                .setAngle(template.angle.minValue)
                .render(
                  this.context.area.getX() + this.area.getX() + 2 + sprite.texture.offsetX * sprite.getScaleX(),
                  this.context.area.getY() + this.area.getY() + 4 + sprite.texture.offsetY * sprite.getScaleY()
                )

              var alpha = sprite.getAlpha()
              sprite.setAngle(template.angle.maxValue)
                .setAlpha(alpha * 0.66)
                .render(
                  this.context.area.getX() + this.area.getX() + 2 + sprite.texture.offsetX * sprite.getScaleX(),
                  this.context.area.getY() + this.area.getY() + 4 + sprite.texture.offsetY * sprite.getScaleY()
                )
                .setAngle(template.angle.minValue)
                .setAlpha(alpha)

              return this
            },
          },
        },
      },
      {
        name: "particle_angle-increase",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Increase" },
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
          decrease: {
            factor: -0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.increase  = clamp(template.angle.increase  + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.01,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.increase = clamp(template.angle.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().angle.increase = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().angle.increase
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_angle-minValue",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.minValue = clamp(template.angle.minValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.minValue = clamp(template.angle.minValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
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
            maxValue: 360.0,
            snapValue: 1.0 / 360.0,
          }
        },
      },
      {
        name: "particle_angle-maxValue",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.maxValue = clamp(template.angle.maxValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.angle.maxValue = clamp(template.angle.maxValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
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
            snapValue: 1.0 / 360.0,
          }
        },
      },
      {
        name: "particle-angle-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_size",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Size",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_size-wiggle",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.wiggle = clamp(template.size.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.wiggle = clamp(template.size.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().size.wiggle = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().size.wiggle
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_size-increase",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.increase = clamp(template.size.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.increase = clamp(template.size.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().size.increase = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().size.increase
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_size-minValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.minValue = clamp(template.size.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.minValue = clamp(template.size.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().size.minValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().size.minValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_size-maxValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.maxValue = clamp(template.size.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.size.maxValue = clamp(template.size.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().size.maxValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().size.maxValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle-size-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_speed",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Speed",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_speed-wiggle",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.wiggle = clamp(template.speed.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.wiggle = clamp(template.speed.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().speed.wiggle = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().speed.wiggle
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_speed-increase",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Increase" },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.increase = clamp(template.speed.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.increase = clamp(template.speed.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().speed.increase = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().speed.increase
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_speed-minValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.minValue = clamp(template.speed.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.minValue = clamp(template.speed.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().speed.minValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().speed.minValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_speed-maxValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.maxValue = clamp(template.speed.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.speed.maxValue = clamp(template.speed.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().speed.maxValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().speed.maxValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle-speed-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_scale",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Scale",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_scale-x",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.scale.x = clamp(template.scale.x + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.scale.x = clamp(template.scale.x + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().scale.x = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.005,
            getValue: function(uiItem) {
              return uiItem.store.getValue().scale.x
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_scale-y",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.scale.y = clamp(template.scale.y + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.scale.y = clamp(template.scale.y + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().scale.y = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.005,
            getValue: function(uiItem) {
              return uiItem.store.getValue().scale.y
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle-scale-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_gravity",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Gravity",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_gravity-angle",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
            snapValue: 1.0 / 360.0,
          },
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.gravity.angle = clamp(template.gravity.angle + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.gravity.angle = clamp(template.gravity.angle + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
        },
      },
      {
        name: "particle_gravity-amount",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.gravity.amount = clamp(template.gravity.amount + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.gravity.amount = clamp(template.gravity.amount + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().gravity.amount = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().gravity.amount
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle-gravity-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_life",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Life",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_life-minValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.life.minValue = clamp(template.life.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.life.minValue = clamp(template.life.minValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().life.minValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.5,
            getValue: function(uiItem) {
              return uiItem.store.getValue().life.minValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_life-maxValue",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.life.maxValue = clamp(template.life.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.life.maxValue = clamp(template.life.maxValue + this.factor, 0.0, 9999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().life.maxValue = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.5,
            getValue: function(uiItem) {
              return uiItem.store.getValue().life.maxValue
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle-life-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "particle_orientation",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Orientation",
            color: VETheme.color.textShadow,
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { backgroundColor: VETheme.color.side },
        },
      },
      {
        name: "particle_orientation-relative",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { text: "Relative" },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.relative = clamp(template.orientation.relative + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.relative = clamp(template.orientation.relative + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().orientation.relative = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().orientation.relative
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_orientation-wiggle",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.wiggle = clamp(template.orientation.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.wiggle = clamp(template.orientation.wiggle + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().orientation.wiggle = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().orientation.wiggle
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_orientation-increase",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Increase" },
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
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.increase = clamp(template.orientation.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.increase = clamp(template.orientation.increase + this.factor, -999.9, 999.9)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          stick: {
            store: { 
              key: "particle-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }
                item.get().orientation.increase = parsedValue
                item.set(item.get())
              },
            },
            factor: 0.01,
            getValue: function(uiItem) {
              return uiItem.store.getValue().orientation.increase
            },
          },
          checkbox: { },
        },
      },
      {
        name: "particle_orientation-minValue",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
          },
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.minValue = clamp(template.orientation.minValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.minValue = clamp(template.orientation.minValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
        },
      },
      {
        name: "particle_orientation-maxValue",
        template: VEComponents.get("numeric-slider-increase-field"),
        layout: VELayouts.get("numeric-slider-increase-field"),
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
            snapValue: 1.0 / 360.0
          },
          decrease: {
            factor: -0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.maxValue = clamp(template.orientation.maxValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
          increase: {
            factor: 0.1,
            callback: function() {
              var item = UIUtil.getIncreaseUIStoreItem(this, ParticleTemplate)
              if (!Optional.is(item)) {
                return
              }

              var template = item.get()
              template.orientation.maxValue = clamp(template.orientation.maxValue + this.factor, 0.0, 360.0)
              item.set(template)
            },
            store: { key: "particle-template" },
          },
        },
      },
    ]),
  }
  return template
}
