///@package io.alkapivo.visu.editor.service.brush.grid

///@param {?Struct} [json]
///@return {Struct}
function brush_grid_coin(json = null) {
  return {
    name: "brush_grid_coin",
    store: new Map(String, Struct, {
      "grid-coin_use-preview": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-coin_use-preview", true),
      },
      "grid-coin_template": {
        type: String,
        value: Struct.getDefault(json, "grid-coin_template", "coin-default"),
        passthrough: function(value) {
          var coinService = Beans.get(BeanVisuController).coinService
          return coinService.templates.contains(value) || Visu.assets().coinTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "coin-default")
        },
      },
      "grid-coin_use-spawn-x": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-coin_use-spawn-x", true),
      },
      "grid-coin_spawn-x": {
        type: Number,
        value: Struct.getDefault(json, "grid-coin_spawn-x", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -3.5, 4.5) 
        },
      },
      "grid-coin_channels-spawn-x": {
        type: Number,
        value: Struct.getDefault(json, "grid-coin_channels-spawn-x", 0),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 50))
        },
      },
      "grid-coin_use-spawn-y": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-coin_use-spawn-y", true),
      },
      "grid-coin_spawn-y": {
        type: Number,
        value: Struct.getDefault(json, "grid-coin_spawn-y", 0.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -2.5, 1.5) 
        },
      },
      "grid-coin_channels-spawn-y": {
        type: Number,
        value: Struct.getDefault(json, "grid-coin_channels-spawn-y", 0),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 0, 50))
        },
      },
      "grid-coin_use-snap-h": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-coin_use-snap-h", true),
      },
      "grid-coin_use-snap-v": {
        type: Boolean,
        value: Struct.getDefault(json, "grid-coin_use-snap-v", true),
      },
    }),
    components: new Array(Struct, [
      {
        name: "grid-coin_use-preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawner preview",
            enable: { key: "grid-coin_use-preview" },
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

              if (!Optional.is(store) || !store.getValue("grid-coin_use-preview")) {
                return
              }

              if (!Struct.contains(this, "spawnerXTimer")) {
                Struct.set(this, "spawnerXTimer", new Timer(pi * 2, { loop: Infinity, amount: FRAME_MS * 4 }))
              }

              var view = Beans.get(BeanVisuController).gridService.view

              var _x = store.getValue("grid-coin_spawn-x")
              if (!store.getValue("grid-coin_use-spawn-x")) {
                _x = (sin(this.spawnerXTimer.update().time) * 2.0) + 0.5
              }

              if (store.getValue("grid-coin_use-snap-h")) {
                _x = _x - (view.x - floor(view.x / view.width) * view.width)
              }

              if (!Struct.contains(this, "spawnerYTimer")) {
                Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { loop: Infinity, amount: FRAME_MS * 4 }))
              }

              var _y = store.getValue("grid-coin_spawn-y")
              if (!store.getValue("grid-coin_use-spawn-y")) {
                _y = (sin(this.spawnerYTimer.update().time) * 2.0) - 0.5
              }

              if (store.getValue("grid-coin_use-snap-v")) {
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
            store: { key: "grid-coin_use-preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      {
        name: "grid-coin_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Template" },
          field: { store: { key: "grid-coin_template" } },
        },
      },
      {
        name: "grid-coin_use-spawn-x",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn x",
            enable: { key: "grid-coin_use-spawn-x" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-coin_use-spawn-x"}
          },
        },
      },
      {
        name: "grid-coin_spawn-x",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "X",
            enable: { key: "grid-coin_use-spawn-x" },
          },
          field: { 
            store: { key: "grid-coin_spawn-x" },
            enable: { key: "grid-coin_use-spawn-x" },
          },
          slider:{
            minValue: -3.5,
            maxValue: 4.5,
            store: { key: "grid-coin_spawn-x" },
            enable: { key: "grid-coin_use-spawn-x" },
            customKey: "grid-coin_channels-spawn-x",
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
        },
      },
      {
        name: "grid-coin_channels-spawn-x",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Channels",
            enable: { key: "grid-coin_use-spawn-x" },
          },
          field: { 
            store: { key: "grid-coin_channels-spawn-x" },
            enable: { key: "grid-coin_use-spawn-x" },
          },
          slider:{
            minValue: 0,
            maxValue: 50,
            store: { key: "grid-coin_channels-spawn-x" },
            enable: { key: "grid-coin_use-spawn-x" },
          },
        },
      },
      {
        name: "grid-coin_use-spawn-y",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Spawn y",
            enable: { key: "grid-coin_use-spawn-y" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "grid-coin_use-spawn-y"}
          },
        },
      },
      {
        name: "grid-coin_spawn-y",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Y",
            enable: { key: "grid-coin_use-spawn-y" },
          },
          field: { 
            store: { key: "grid-coin_spawn-y" },
            enable: { key: "grid-coin_use-spawn-y" },
          },
          slider: { 
            minValue: -2.5,
            maxValue: 1.5,
            store: { key: "grid-coin_spawn-y" },
            enable: { key: "grid-coin_use-spawn-y" },
            customKey: "grid-coin_channels-spawn-y",
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
        },
      },
      {
        name: "grid-coin_channels-spawn-y",  
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Channels",
            enable: { key: "grid-coin_use-spawn-y" },
          },
          field: { 
            store: { key: "grid-coin_channels-spawn-y" },
            enable: { key: "grid-coin_use-spawn-y" },
          },
          slider:{
            minValue: 0,
            maxValue: 50,
            store: { key: "grid-coin_channels-spawn-y" },
            enable: { key: "grid-coin_use-spawn-y" },
          },
        },
      },
      {
        name: "grid-coin_use-snap-h",
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
            store: { key: "grid-coin_use-snap-h" },
          },
        },
      },
      {
        name: "grid-coin_use-snap-v",
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
            store: { key: "grid-coin_use-snap-v" },
          },
        },
      },
    ]),
  }
}