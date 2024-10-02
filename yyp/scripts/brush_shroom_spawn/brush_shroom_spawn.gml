///@package io.alkapivo.visu.editor.service.brush.shroom

///@param {?Struct} [json]
///@return {Struct}
function brush_shroom_spawn(json = null) {
  return {
    name: "brush_shroom_spawn",
    store: new Map(String, Struct, {
      "shroom-spawn_use-preview": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-preview", true),
      },
      "shroom-spawn_template": {
        type: String,
        value: Struct.getDefault(json, "shroom-spawn_template", "shroom-default"),
        passthrough: function(value) {
          var shroomService = Beans.get(BeanVisuController).shroomService
          return shroomService.templates.contains(value) || Visu.assets().shroomTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "shroom-default")
        },
      },
      "shroom-spawn_speed": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_speed", 3.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.01, 99.0) 
        },
      },
      "shroom-spawn_use-spawn-x": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-spawn-x", true),
      },
      "shroom-spawn_spawn-x": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-x", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -3.5, 4.5) 
        },
      },
      "shroom-spawn_channels-spawn-x": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_channels-spawn-x", 0),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 50))
        },
      },
      "shroom-spawn_spawn-x-random-from": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-x-random-from", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -3.5, 4.5) 
        },
      },
      "shroom-spawn_spawn-x-random-size": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-x-random-size", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 8.0) 
        },
      },
      "shroom-spawn_use-spawn-y": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-spawn-y", true),
      },
      "shroom-spawn_spawn-y": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-y", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -2.5, 1.5) 
        },
      },
      "shroom-spawn_channels-spawn-y": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_channels-spawn-y", 0),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 50))
        },
      },
      "shroom-spawn_spawn-y-random-from": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-y-random-from", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -4.5, 3.5) 
        },
      },
      "shroom-spawn_spawn-y-random-size": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_spawn-y-random-size", 1.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 8.0) 
        },
      },
      "shroom-spawn_use-snap-h": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-snap-h", true),
      },
      "shroom-spawn_use-snap-v": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-snap-v", true),
      },
      "shroom-spawn_use-angle": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-spawn_use-angle", true),
      },
      "shroom-spawn_angle": {
        type: Number,
        value: Struct.getDefault(json, "shroom-spawn_angle", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 360.0) 
        },
      },
    }),
    components: new Array(Struct, [
      {
        name: "shroom-spawn_use-preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawner preview",
            enable: { key: "shroom-spawn_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
            updateCustom: function() {
              this.preRender()
              if (Core.isType(this.context.updateTimer, Timer)) {
                var inspectorType = this.context.state.get("inspectorType")
                switch (inspectorType) {
                  case VEEventInspector:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.spawnerEvent != null) {
                      shroomService.spawnerEvent.timeout = ceil(this.context.updateTimer.duration * 60)
                    }
                    break
                  case VEBrushToolbar:
                    var shroomService = Beans.get(BeanVisuController).shroomService
                    if (shroomService.spawner != null) {
                      shroomService.spawner.timeout = ceil(this.context.updateTimer.duration * 60)
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

              if (!Optional.is(store) || !store.getValue("shroom-spawn_use-preview")) {
                return
              }

              if (!Struct.contains(this, "spawnerXTimer")) {
                Struct.set(this, "spawnerXTimer", new Timer(pi * 2, { loop: Infinity, amount: FRAME_MS * 4 }))
              }

              var view = Beans.get(BeanVisuController).gridService.view

              var _x = store.getValue("shroom-spawn_spawn-x")
              if (!store.getValue("shroom-spawn_use-spawn-x")) {
                _x = store.getValue("shroom-spawn_spawn-x-random-from") 
                  + ((sin(this.spawnerXTimer.update().time) * 0.5 + 0.5) 
                  * store.getValue("shroom-spawn_spawn-x-random-size"))
              }

              if (store.getValue("shroom-spawn_use-snap-h")) {
                _x = _x - (view.x - floor(view.x / view.width) * view.width)
              }

              if (!Struct.contains(this, "spawnerYTimer")) {
                Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { loop: Infinity, amount: FRAME_MS * 4 }))
              }

              var _y = store.getValue("shroom-spawn_spawn-y")
              if (!store.getValue("shroom-spawn_use-spawn-y")) {
                _y = store.getValue("shroom-spawn_spawn-y-random-from") 
                  + ((sin(this.spawnerYTimer.update().time) * 0.5 + 0.5) 
                  * store.getValue("shroom-spawn_spawn-y-random-size"))
              }

              if (store.getValue("shroom-spawn_use-snap-v")) {
                _y = _y - (view.y - floor(view.y / view.height) * view.height)
              }

              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.spawnerEvent = shroomService.factorySpawner({ 
                    x: _x, 
                    y: _y, 
                    sprite: SpriteUtil.parse({ name: "texture_bazyl" })
                  })
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.spawner = shroomService.factorySpawner({ 
                    x: _x, 
                    y: _y, 
                    sprite: SpriteUtil.parse({ name: "texture_baron" })
                  })
                  break
              }
            },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      {
        name: "shroom-spawn_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "shroom-spawn_template" } },
        },
      },
      {
        name: "shroom-spawn_speed",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Speed" },
          field: { store: { key: "shroom-spawn_speed" } },
        },
      },
      {
        name: "shroom-spawn_use-spawn-x",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn x",
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-spawn-x"}
          },
        },
      },
      {
        name: "shroom-spawn_spawn-x-field",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "X",
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-x",  
        template: VEComponents.get("numeric-slider-button"),
        layout: VELayouts.get("numeric-slider-button"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "",
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
          decrease: {
            store: { key: "shroom-spawn_spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
            label: { text: "-" },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.accent,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Optional.is(this.enable) && !this.enable.value) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() { 
              var channels = clamp(this.store.getStore().get("shroom-spawn_channels-spawn-x").get(), 1, 50)
              var spawnY = this.store.getStore().get("shroom-spawn_spawn-x").get()
              this.store.set(clamp(spawnY - (8.0 / channels), -3.5, 4.5))
            },
          },
          slider:{
            minValue: -3.5,
            maxValue: 4.5,
            store: { key: "shroom-spawn_spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
            customKey: "shroom-spawn_channels-spawn-x",
            updateValue: function(mouseX) {
              var position = clamp((this.context.area.getX() + mouseX - this.context.area.getX() - this.area.getX()) / this.area.getWidth(), 0.0, 1.0)
              var snap = this.store.getStore().get(this.customKey).get()
              if (snap > 0) {
                var snapWidth = 1.0 / snap
                position = (floor(position / snapWidth) * snapWidth) + (snapWidth / 2)
              }
              var length = abs(this.minValue - this.maxValue) * position
              this.value = clamp(this.minValue + length, this.minValue, this.maxValue)
              if (Core.isType(this.store, UIStore)) {
                this.store.set(this.value)
              }
        
              this.updatePosition(mouseX)
            },
          },
          increase: {
            store: { key: "shroom-spawn_spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
            label: { text: "+" },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.accent,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Optional.is(this.enable) && !this.enable.value) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() { 
              var channels = clamp(this.store.getStore().get("shroom-spawn_channels-spawn-x").get(), 1, 50)
              var spawnY = this.store.getStore().get("shroom-spawn_spawn-x").get()
              this.store.set(clamp(spawnY + (8.0 / channels), -3.5, 4.5))
            },
          },
        },
      },
      {
        name: "shroom-spawn_channels-spawn-x",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Channels",
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
          field: { 
            store: { key: "shroom-spawn_channels-spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
          slider:{
            minValue: 0,
            maxValue: 50,
            store: { key: "shroom-spawn_channels-spawn-x" },
            enable: { key: "shroom-spawn_use-spawn-x" },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-x-random-from",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "rng X from",
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-x-random-from" },
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
          slider: {
            minValue: -3.5,
            maxValue: 4.5,
            store: { key: "shroom-spawn_spawn-x-random-from" },
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-x-random-size",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "rng X size",
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-x-random-size" },
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
          slider: {
            minValue: 0.0,
            maxValue: 8.0,
            store: { key: "shroom-spawn_spawn-x-random-size" },
            enable: { key: "shroom-spawn_use-spawn-x", negate: true },
          },
        },
      },
      {
        name: "shroom-spawn_use-spawn-y",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn y",
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-spawn-y"}
          },
        },
      },
      {
        name: "shroom-spawn_spawn-y-field",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Y",
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-y",  
        template: VEComponents.get("numeric-slider-button"),
        layout: VELayouts.get("numeric-slider-button"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "",
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
          decrease: {
            store: { key: "shroom-spawn_spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
            label: { text: "-" },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.accent,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Optional.is(this.enable) && !this.enable.value) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() { 
              var channels = clamp(this.store.getStore().get("shroom-spawn_channels-spawn-y").get(), 1, 50)
              var spawnY = this.store.getStore().get("shroom-spawn_spawn-y").get()
              this.store.set(clamp(spawnY - (8.0 / channels), -3.5, 4.5))
            },
          },
          slider: { 
            minValue: -2.5,
            maxValue: 1.5,
            store: { key: "shroom-spawn_spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
            customKey: "shroom-spawn_channels-spawn-y",
            updateValue: function(mouseX) {
              var position = clamp((this.context.area.getX() + mouseX - this.context.area.getX() - this.area.getX()) / this.area.getWidth(), 0.0, 1.0)
              var snap = this.store.getStore().get(this.customKey).get()
              if (snap > 0) {
                var snapWidth = 1.0 / snap
                position = (floor(position / snapWidth) * snapWidth) + (snapWidth / 2)
              }
              var length = abs(this.minValue - this.maxValue) * position
              this.value = clamp(this.minValue + length, this.minValue, this.maxValue)
              if (Core.isType(this.store, UIStore)) {
                this.store.set(this.value)
              }
        
              this.updatePosition(mouseX)
            },
          },
          increase: {
            store: { key: "shroom-spawn_spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
            label: { text: "+" },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.accent,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Optional.is(this.enable) && !this.enable.value) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() { 
              var channels = clamp(this.store.getStore().get("shroom-spawn_channels-spawn-y").get(), 1, 50)
              var spawnY = this.store.getStore().get("shroom-spawn_spawn-y").get()
              this.store.set(clamp(spawnY + (8.0 / channels), -3.5, 4.5))
            },
          },
        },
      },
      {
        name: "shroom-spawn_channels-spawn-y",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Channels",
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
          field: { 
            store: { key: "shroom-spawn_channels-spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
          slider:{
            minValue: 0,
            maxValue: 50,
            store: { key: "shroom-spawn_channels-spawn-y" },
            enable: { key: "shroom-spawn_use-spawn-y" },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-y-random-from",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "rng Y from",
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-y-random-from" },
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
          slider: {
            minValue: -3.5,
            maxValue: 4.5,
            store: { key: "shroom-spawn_spawn-y-random-from" },
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
        },
      },
      {
        name: "shroom-spawn_spawn-y-random-size",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "rng Y size",
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
          field: { 
            store: { key: "shroom-spawn_spawn-y-random-size" },
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
          slider: {
            minValue: 0.0,
            maxValue: 8.0,
            store: { key: "shroom-spawn_spawn-y-random-size" },
            enable: { key: "shroom-spawn_use-spawn-y", negate: true },
          },
        },
      },
      {
        name: "shroom-spawn_use-snap-h",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Snap horizontal",
            enable: { key: "particle_use-preview" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-snap-h" },
          },
        },
      },
      {
        name: "shroom-spawn_use-snap-v",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Snap vertical",
            enable: { key: "particle_use-preview" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-snap-v" },
          },
        },
      },
      {
        name: "shroom-spawn_use-angle",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle",
            enable: { key: "shroom-spawn_use-angle" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-angle" },
          },
          input: {
            store: { 
              key: "shroom-spawn_angle",
              callback: function(value, data) { 
                var sprite = Struct.get(data, "sprite")
                if (!Core.isType(sprite, Sprite)) {
                  sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                  Struct.set(data, "sprite", sprite)
                }
                sprite.setAngle(value)
              },
              set: function(value) { return },
            },
            enable: { key: "shroom-spawn_use-angle" },
            render: function() {
              if (this.backgroundColor != null) {
                var _x = this.context.area.getX() + this.area.getX()
                var _y = this.context.area.getY() + this.area.getY()
                var color = this.backgroundColor
                draw_rectangle_color(
                  _x, _y, 
                  _x + this.area.getWidth(), _y + this.area.getHeight(),
                  color, color, color, color,
                  false
                )
              }

              var sprite = Struct.get(this, "sprite")
              if (!Core.isType(sprite, Sprite)) {
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                Struct.set(this, "sprite", sprite)
              }
              sprite.scaleToFit(this.area.getWidth(), this.area.getHeight())
                .render(
                  this.context.area.getX() + this.area.getX() + sprite.texture.offsetX * sprite.getScaleX(),
                  this.context.area.getY() + this.area.getY() + sprite.texture.offsetY * sprite.getScaleY()
                )
              
              return this
            },
          }
        },
      },
      {
        name: "shroom-spawn_angle",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Angle",
            enable: { key: "shroom-spawn_use-angle" },
          },
          field: { 
            store: { key: "shroom-spawn_angle" },
            enable: { key: "shroom-spawn_use-angle" },
          },
          slider: { 
            minValue: 0.0,
            maxValue: 360.0,
            store: { key: "shroom-spawn_angle" },
            enable: { key: "shroom-spawn_use-angle" },
          },
        },
      },
    ]),
  }
}