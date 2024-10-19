///@package io.alkapivo.visu.editor.service.brush.grid

///@param {?Struct} [json]
///@return {Struct}
function brush_grid_player(json = null) {
  return {
    name: "brush_grid_player",
    store: new Map(String, Struct, {
      "grid-player_texture": {
        type: Sprite,
        value: SpriteUtil.parse(Struct.get(json, "grid-player_texture"), { 
          name: "texture_player", 
          animate: true 
        }),
      },
      "grid-player_use-mask": {
        type: Boolean,
        value: Struct.get(json, "grid-player_use-mask") == true,
      },
      "grid-player_mask": {
        type: Rectangle,
        value: new Rectangle(Struct.getDefault(json, "grid-player_mask", null)),
      },
      "grid-player_use-reset-position": {
        type: Boolean,
        value: Struct.get(json, "grid-player_use-reset-position") == true,
      },
      "grid-player_reset-position": {
        type: Boolean,
        value: Struct.get(json, "grid-player_reset-position") == true,
      },
      "grid-player_use-stats": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-stats", false),
      },
      "grid-player_stats": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json, "grid-player_stats", {
          "force": {
            "value": 0
          },
          "point": {
            "value": 0
          },
          "bomb": {
            "value": 5
          },
          "life": {
            "value": 4
          }
        }), { pretty: true }),
        serialize: function() {
          return JSON.parse(this.get())
        },
        validate: function(value) {
          Assert.isType(JSON.parse(value), Struct)
        },
      },
      "grid-player_use-bullet-hell": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-bullet-hell", true),
      },
      "grid-player_bullet-hell": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json, "grid-player_bullet-hell", {
          "x":{
            "friction":9.3,
            "acceleration":1.92,
            "speedMax":2.1
          },
          "y":{
            "friction":9.3,
            "acceleration":1.92,
            "speedMax":2.1
          },
          "guns":[
            {
              "angle": 90,
              "bullet":"bullet_default",
              "cooldown":8.0,
              "offsetX": 0.0,
              "offsetY": 0.0,
              "speed": 10.0
            }
          ]
        }), { pretty: true }),
        serialize: function() {
          return JSON.parse(this.get())
        },
        validate: function(value) {
          Assert.isType(JSON.parse(value), Struct)
        },
      },
      "grid-player_use-platformer": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-platformer", true),
      },
      "grid-player_platformer": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json, "grid-player_platformer", {
          "x":{
            "friction":9.3,
            "acceleration":1.92,
            "speedMax":2.1
          },
          "y":{
            "friction":0.0,
            "acceleration":1.92,
            "speedMax":25.0
          },
          "jump": {
            "size": 3.5
          }
        }), { pretty: true }),
        serialize: function() {
          return JSON.parse(this.get())
        },
        validate: function(value) {
          Assert.isType(JSON.parse(value), Struct)
        },
      },
      "grid-player_use-racing": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-racing", true),
      },
      "grid-player_racing": {
        type: String,
        value: JSON.stringify(Struct.getDefault(json, "grid-player_racing", {}), { pretty: true }),
        serialize: function() {
          return JSON.parse(this.get())
        },
        validate: function(value) {
          Assert.isType(JSON.parse(value), Struct)
        },
      },
      "grid-player_use-transform-player-z": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-transform-player-z", true),
      },
      "grid-player_transform-player-z": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "grid-player_transform-player-z", 
          { value: 0, target: 2100, factor: 50.0, increase: 0 }
        )),
      },
      "grid-player_use-margin": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-player_use-margin", false),
      },
      "grid-player_margin-top": {
        type: Number,
        value: Struct.getDefault(json, "grid-player_margin-top", 0.2),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3.0) 
        },
      },
      "grid-player_margin-right": {
        type: Number,
        value: Struct.getDefault(json, "grid-player_margin-right", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3.0) 
        },
      },
      "grid-player_margin-bottom": {
        type: Number,
        value: Struct.getDefault(json, "grid-player_margin-bottom", 0.2),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3.0) 
        },
      },
      "grid-player_margin-left": {
        type: Number,
        value: Struct.getDefault(json, "grid-player_margin-left", 0.5),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 3.0) 
        },
      },
    }),
    components: new Array(Struct, [
      /*
      {
        name: "grid-player_use-margin",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Margins",
            enable: { key: "grid-player_use-margin" },
            updateCustom: function() {
              this.preRender()
              if (Core.isType(this.context.updateTimer, Timer)) {
                var inspectorType = this.context.state.get("inspectorType")
                switch (inspectorType) {
                  case VEEventInspector:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.playerBorderEvent != null) {
                      shroomService.playerBorderEvent.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                  case VEBrushToolbar:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.playerBorder != null) {
                      shroomService.playerBorder.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                }
              }
            },
            preRender: function() {
              var store = null
              if (Core.isType(this.context.state.get("brush"), VEBrush)) {
                store = this.context.state.get("brush").store
              }
              
              if (Core.isType(this.context.state.get("event"), VEEvent)) {
                store = this.context.state.get("event").store
              }

              if (!Optional.is(store) || !store.getValue("grid-player_use-margin")) {
                return
              }

              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.playerBorderEvent = {
                    topLeft: shroomService.factorySpawner({ 
                      x: 0.0 - store.getValue("grid-player_margin-left"),
                      y: 0.0 - store.getValue("grid-player_margin-top"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    topRight: shroomService.factorySpawner({ 
                      x: 1.0 + store.getValue("grid-player_margin-right"),
                      y: 0.0 - store.getValue("grid-player_margin-top"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({ 
                      x: 0.0 - store.getValue("grid-player_margin-left"), 
                      y: 1.0 + store.getValue("grid-player_margin-bottom"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    bottomRight: shroomService.factorySpawner({ 
                      x: 1.0 + store.getValue("grid-player_margin-right"), 
                      y: 1.0 + store.getValue("grid-player_margin-bottom"),
                      sprite: SpriteUtil.parse({ name: "texture_bazyl" }),
                    }),
                    timeout: 5.0,
                  }
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.playerBorder = {
                    topLeft: shroomService.factorySpawner({ 
                      x: 0.0 - store.getValue("grid-player_margin-left"),
                      y: 0.0 - store.getValue("grid-player_margin-top"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    topRight: shroomService.factorySpawner({ 
                      x: 1.0 + store.getValue("grid-player_margin-right"),
                      y: 0.0 - store.getValue("grid-player_margin-top"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomLeft: shroomService.factorySpawner({ 
                      x: 0.0 - store.getValue("grid-player_margin-left"), 
                      y: 1.0 + store.getValue("grid-player_margin-bottom"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    bottomRight: shroomService.factorySpawner({ 
                      x: 1.0 + store.getValue("grid-player_margin-right"), 
                      y: 1.0 + store.getValue("grid-player_margin-bottom"),
                      sprite: SpriteUtil.parse({ name: "texture_baron" }),
                    }),
                    timeout: 5.0,
                  }
                  break
              }
            },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-margin" },
          },
        },
      },
      {
        name: "grid-player_margin-top",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Top",
            enable: { key: "grid-player_use-margin" },
          },
          field: { 
            store: { key: "grid-player_margin-top" },
            enable: { key: "grid-player_use-margin" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 3.0,
            store: { key: "grid-player_margin-top" },
            enable: { key: "grid-player_use-margin" },
          },
        },
      },
      {
        name: "grid-player_margin-right",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Right",
            enable: { key: "grid-player_use-margin" },
          },
          field: { 
            store: { key: "grid-player_margin-right" },
            enable: { key: "grid-player_use-margin" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 3.0,
            store: { key: "grid-player_margin-right" },
            enable: { key: "grid-player_use-margin" },
          },
        },
      },
      {
        name: "grid-player_margin-bottom",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Bottom",
            enable: { key: "grid-player_use-margin" },
          },
          field: { 
            store: { key: "grid-player_margin-bottom" },
            enable: { key: "grid-player_use-margin" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 3.0,
            store: { key: "grid-player_margin-bottom" },
            enable: { key: "grid-player_use-margin" },
          },
        },
      },
      {
        name: "grid-player_margin-left",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Bottom",
            enable: { key: "grid-player_use-margin" },
          },
          field: { 
            store: { key: "grid-player_margin-left" },
            enable: { key: "grid-player_use-margin" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 3.0,
            store: { key: "grid-player_margin-left" },
            enable: { key: "grid-player_use-margin" },
          },
        },
      },
      */
      {
        name: "grid-player_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { text: "Set texture" },
          },
          texture: {
            label: { text: "Texture" }, 
            field: { store: { key: "grid-player_texture" } },
          },
          animate: {
            label: { text: "Animate" }, 
            checkbox: { 
              store: { key: "grid-player_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          randomFrame: {
            label: { text: "Random frame" }, 
            checkbox: { 
              store: { key: "grid-player_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
            },
          },
          frame: {
            label: { text: "Frame" },
            field: { store: { key: "grid-player_texture" } },
          },
          speed: {
            label: { text: "Speed" },
            field: { store: { key: "grid-player_texture" } },
          },
          scaleX: {
            label: { text: "Scale X" },
            field: { store: { key: "grid-player_texture" } },
          },
          scaleY: {
            label: { text: "Scale Y" },
            field: { store: { key: "grid-player_texture" } },
          },
          alpha: {
            label: { text: "Alpha" },
            field: { store: { key: "grid-player_texture" } },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              store: { key: "grid-player_texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "grid-player_texture" },
          },
          resolution: {
            store: { key: "grid-player_texture" },
          },
        },
      },
      {
        name: "grid-player_mask",
        template: VEComponents.get("vec4-field"),
        layout: VELayouts.get("vec4-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Custom collision mask",
              enable: { key: "grid-player_use-mask" },
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-player_use-mask" },
            },
          },
          x: {
            label: {
              text: "X",
              enable: { key: "grid-player_use-mask" },
            },
            field: {
              store: { key: "grid-player_mask" },
              enable: { key: "grid-player_use-mask" },
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "grid-player_use-mask" },
            },
            field: {
              store: { key: "grid-player_mask" },
              enable: { key: "grid-player_use-mask" },
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "grid-player_use-mask" },
            },
            field: {
              store: { key: "grid-player_mask" },
              enable: { key: "grid-player_use-mask" },
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "grid-player_use-mask" },
            },
            field: {
              store: { key: "grid-player_mask" },
              enable: { key: "grid-player_use-mask" },
            },
          },
        },
      },
      {
        name: "grid-player_use-reset-position",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Reset position",
            enable: { key: "grid-player_use-reset-position" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-reset-position" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "grid-player_reset-position" },
            enable: { key: "grid-player_use-reset-position" },
          }
        },
      },
      {
        name: "grid-player_use-stats",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Use stats",
            enable: { key: "grid-player_use-stats" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-stats" },
          },
        },
      },
      {
        name: "grid-player_stats",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "grid-player_stats" },
            enable: { key: "grid-player_use-stats" },
          },
        },
      },
      {
        name: "grid-player_bullet-hell",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "BulletHell",
            enable: { key: "grid-player_use-bullet-hell" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-bullet-hell" },
          },
        },
      },
      {
        name: "grid-player_bullet-hell",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "grid-player_bullet-hell" },
            enable: { key: "grid-player_use-bullet-hell" },
          },
        },
      },
      {
        name: "grid-player_mode_platformer",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Platformer",
            enable: { key: "grid-player_use-platformer" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-platformer" },
          },
        },
      },
      {
        name: "grid-player_platformer",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "grid-player_platformer" },
            enable: { key: "grid-player_use-platformer" },
          },
        },
      },
      {
        name: "grid-player_racing",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Racing",
            enable: { key: "grid-player_use-racing" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-player_use-racing" },
          },
        },
      },
      {
        name: "grid-player_racing",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "grid-player_racing" },
            enable: { key: "grid-player_use-racing" },
          },
        },
      },
      {
        name: "grid-player_transform-player-z",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform player z",
              enable: { key: "grid-player_use-transform-player-z" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "grid-player_use-transform-player-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "grid-player_use-transform-player-z" },
            },
            field: {
              store: { key: "grid-player_transform-player-z" },
              enable: { key: "grid-player_use-transform-player-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "grid-player_use-transform-player-z" },
            },
            field: {
              store: { key: "grid-player_transform-player-z" },
              enable: { key: "grid-player_use-transform-player-z" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "grid-player_use-transform-player-z" },
            },
            field: {
              store: { key: "grid-player_transform-player-z" },
              enable: { key: "grid-player_use-transform-player-z" },
            },
          },
        },
      },
    ]),
  }
}