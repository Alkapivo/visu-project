///@package io.alkapivo.visu.editor.service.brush._old.shroom

///@type {Number}
#macro SHROOM_SPAWN_CHANNEL_AMOUNT 50

///@type {Number}
#macro SHROOM_SPAWN_CHANNEL_SIZE 8

///@type {Number}
#macro SHROOM_SPAWN_ROW_AMOUNT 50

///@type {Number}
#macro SHROOM_SPAWN_ROW_SIZE 8


///@param {Struct} json
///@return {Struct}
function migrateShroomSpawnEvent(json) {

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_channel", Number))) {
    var spawnX = (clamp(Struct.getDefault(json, "shroom-spawn_spawn-x", 0.0), -3.5, 4.5) - 0.5)
    var channel = (spawnX / (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT))
    Struct.set(json, "shroom-spawn_channel", channel)
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_channel-snap", Boolean))) {
    Struct.set(json, "shroom-spawn_channel-snap", Struct.getIfType(json, "shroom-spawn_use-snap-h", Boolean, true))
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_use-channel-rng", Boolean))) {
    Struct.set(json, "shroom-spawn_use-channel-rng", !Struct.getIfType(json, "shroom-spawn_use-spawn-x", Boolean, true))
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_channel-rng", Number))) {
    if (Struct.get(json, "shroom-spawn_use-channel-rng")) {
      var spawnX = (clamp(Struct.getDefault(json, "shroom-spawn_spawn-x-random-from", 0.0), -3.5, 4.5) - 0.5)
      var channel = (spawnX / (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT))
      var channelSignFix = (Struct.getIfType(json, "shroom-spawn_spawn-x-random-size", Number, 0.0) / 2.0) / (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)
      Struct.set(json, "shroom-spawn_channel", channel + channelSignFix)
      var channelRng = clamp((Struct.getIfType(json, "shroom-spawn_spawn-x-random-size", Number, 0.0) / (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT)), 0.0, SHROOM_SPAWN_CHANNEL_AMOUNT)
      Struct.set(json, "shroom-spawn_channel-rng", channelRng)
    } else {
      Struct.set(json, "shroom-spawn_channel-rng", 0.0)
    }
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_row", Number))) {
    var spawnY = (clamp(Struct.getDefault(json, "shroom-spawn_spawn-y", 0.0), -4.5, 3.5) + 0.5)
    var row = (spawnY / (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT))
    Struct.set(json, "shroom-spawn_row", row)
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_row-snap", Boolean))) {
    Struct.set(json, "shroom-spawn_row-snap", Struct.getIfType(json, "shroom-spawn_use-snap-v", Boolean, true))
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_use-row-rng", Boolean))) {
    Struct.set(json, "shroom-spawn_use-row-rng", !Struct.getIfType(json, "shroom-spawn_use-spawn-y", Boolean, true))
  }

  if (!Optional.is(Struct.getIfType(json, "shroom-spawn_row-rng", Number))) {
    if (Struct.get(json, "shroom-spawn_use-row-rng")) {
      var spawnY = (clamp(Struct.getDefault(json, "shroom-spawn_spawn-y-random-from", 0.0), -4.5, 3.5) + 0.5)
      var row = (spawnY / (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT))
      var rowSignFix = (Struct.getIfType(json, "shroom-spawn_spawn-y-random-size", Number, 0.0) / 2.0) / (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)
      Struct.set(json, "shroom-spawn_row", row)

      var rowRng = clamp((Struct.getIfType(json, "shroom-spawn_spawn-y-random-size", Number, 0.0) / (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT)), 0.0, SHROOM_SPAWN_ROW_AMOUNT)
      Struct.set(json, "shroom-spawn_row-rng", rowRng)
    } else {
      Struct.set(json, "shroom-spawn_row-rng", 0.0)
    }
  }

  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "en-shr_preview": Struct.getIfType(json, "shroom-spawn_use-preview", Boolean, false),
    "en-shr_template": Struct.getIfType(json, "shroom-spawn_template", String, "shroom-default"),
    "en-shr_spd": Struct.getIfType(json, "shroom-spawn_speed", Number, 10.0),
    "en-shr_use-spd-rng": Struct.getIfType(json, "shroom-spawn_use-speed-rng", Boolean, false),
    "en-shr_spd-rng": Struct.getIfType(json, "shroom-spawn_speed-rng", Number, 0.0),
    "en-shr_dir": Struct.getIfType(json, "shroom-spawn_angle", Number, 270.0),
    "en-shr_use-dir-rng": Struct.getIfType(json, "shroom-spawn_use-angle-rng", Boolean, false),
    "en-shr_dir-rng": Struct.getIfType(json, "shroom-spawn_angle-rng", Number, 0.0),
    "en-shr_x": Struct.getIfType(json, "shroom-spawn_channel", Number, 0.0),
    "en-shr_snap-x": Struct.getIfType(json, "shroom-spawn_channel-snap", Boolean, true),
    "en-shr_use-rng-x": Struct.getIfType(json, "shroom-spawn_use-channel-rng", Boolean, false),
    "en-shr_rng-x": Struct.getIfType(json, "shroom-spawn_channel-rng", Number, 0.0),
    "en-shr_y": Struct.getIfType(json, "shroom-spawn_row", Number, 0.0),
    "en-shr_snap-y": Struct.getIfType(json, "shroom-spawn_row-snap", Boolean, true),
    "en-shr_use-rng-y": Struct.getIfType(json, "shroom-spawn_use-row-rng", Boolean, false),
    "en-shr_rng-y": Struct.getIfType(json, "shroom-spawn_row-rng", Number, 0.0),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_shroom_spawn(json = null) {

  return {
    name: "brush_shroom_spawn",
    store: new Map(String, Struct, {
      "shroom-spawn_use-preview": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_use-preview", Boolean, true),
      },
      "shroom-spawn_template": {
        type: String,
        value: Struct.getIfType(json, "shroom-spawn_template", String, "shroom-default"),
        passthrough: function(value) {
          var shroomService = Beans.get(BeanVisuController).shroomService
          return shroomService.templates.contains(value) || Visu.assets().shroomTemplates.contains(value)
            ? value
            : (Core.isType(this.value, String) ? this.value : "shroom-default")
        },
      },
      "shroom-spawn_speed": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_speed", Number, 10.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 99.9) 
        },
      },
      "shroom-spawn_use-speed-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_use-speed-rng", Boolean, false),
      },
      "shroom-spawn_speed-rng": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_speed-rng", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 99.9) 
        },
      },
      "shroom-spawn_angle": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_angle", Number, 270.0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, 360.0) 
        },
      },
      "shroom-spawn_use-angle-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_use-angle-rng", Boolean, false),
      },
      "shroom-spawn_angle-rng": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_angle-rng", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 360.0) 
        },
      },
      "shroom-spawn_channel": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_channel", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0), SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0)
        },
      },
      "shroom-spawn_channel-snap": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_channel-snap", Boolean, true),
      },
      "shroom-spawn_use-channel-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_use-channel-rng", Boolean, false),
      },
      "shroom-spawn_channel-rng": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_channel-rng", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, SHROOM_SPAWN_CHANNEL_AMOUNT)
        },
      },
      "shroom-spawn_row": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_row", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2.0), SHROOM_SPAWN_ROW_AMOUNT / 2.0)
        },
      },
      "shroom-spawn_row-snap": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_row-snap", Boolean, true),
      },
      "shroom-spawn_use-row-rng": {
        type: Boolean,
        value: Struct.getIfType(json, "shroom-spawn_use-row-rng", Boolean, false),
      },
      "shroom-spawn_row-rng": {
        type: Number,
        value: Struct.getIfType(json, "shroom-spawn_row-rng", Number, 0),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0, SHROOM_SPAWN_ROW_AMOUNT)
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
            text: "Render spawn position",
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

              var view = Beans.get(BeanVisuController).gridService.view
  
              if (!Struct.contains(this, "spawnerXTimer")) {
                Struct.set(this, "spawnerXTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var _x = store.getValue("shroom-spawn_channel") * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) + 0.5
              if (store.getValue("shroom-spawn_use-channel-rng")) {
                _x += sin(this.spawnerXTimer.update().time) * (store.getValue("shroom-spawn_channel-rng") * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) / 2.0)
              }

              if (store.getValue("shroom-spawn_channel-snap")) {
                _x = _x - (view.x - floor(view.x / view.width) * view.width)
              }

              if (!Struct.contains(this, "spawnerYTimer")) {
                Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var _y = store.getValue("shroom-spawn_row") * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) - 0.5
              if (store.getValue("shroom-spawn_use-row-rng")) {
                _y += sin(this.spawnerYTimer.update().time) * (store.getValue("shroom-spawn_row-rng") * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) / 2.0)
              }

              if (store.getValue("shroom-spawn_row-snap")) {
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
        name: "shroom-spawn_speed-rng",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Rng",
            enable: { key: "shroom-spawn_use-speed-rng" },
          },  
          field: { 
            store: { key: "shroom-spawn_speed-rng" },
            enable: { key: "shroom-spawn_use-speed-rng" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-speed-rng" },
          },
          title: { 
            text: "Enable",
            enable: { key: "shroom-spawn_use-speed-rng" },
          },
        },
      },
      {
        name: "shroom-spawn_angle",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Angle" },  
          field: { store: { key: "shroom-spawn_angle" } },
          checkbox: { 
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
          },
          title: { text: "" },
        },
      },
      {
        name: "shroom-spawn_angle-rng",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Rng",
            enable: { key: "shroom-spawn_use-angle-rng" },
          },  
          field: { 
            store: { key: "shroom-spawn_angle-rng" },
            enable: { key: "shroom-spawn_use-angle-rng" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-angle-rng" },
          },
          title: { 
            text: "Enable",
            enable: { key: "shroom-spawn_use-angle-rng" },
          },
        },
      },
      {
        name: "shroom-spawn_angle-slider",  
        template: VEComponents.get("numeric-slider-button"),
        layout: VELayouts.get("numeric-slider-button"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          decrease: {
            factor: -1.0,
            minValue: 0.0,
            maxValue: 360.0,
            store: { key: "shroom-spawn_angle" },
            label: { 
              text: "-",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
          slider: {
            minValue: 0.0,
            maxValue: 360.0,
            snapValue: 1.0 / 360.0,
            store: { key: "shroom-spawn_angle" },
          },
          increase: {
            factor: 1.0,
            minValue: 0.0,
            maxValue: 360.0,
            store: { key: "shroom-spawn_angle" },
            label: { 
              text: "+",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
        },
      },
      {
        name: "shroom-spawn_channel",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "X" },  
          field: { store: { key: "shroom-spawn_channel" } },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_channel-snap" },
          },
          title: { 
            text: "Snap",
            enable: { key: "shroom-spawn_channel-snap" },
          },
        },
      },
      {
        name: "shroom-spawn_channel-rng",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Rng",
            enable: { key: "shroom-spawn_use-channel-rng" },
          },  
          field: { 
            store: { key: "shroom-spawn_channel-rng" },
            enable: { key: "shroom-spawn_use-channel-rng" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-channel-rng" },
          },
          title: { 
            text: "Enable",
            enable: { key: "shroom-spawn_use-channel-rng" },
          },
        },
      },
      {
        name: "shroom-spawn_channel-slider",  
        template: VEComponents.get("numeric-slider-button"),
        layout: VELayouts.get("numeric-slider-button"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          decrease: {
            factor: -1.0,
            minValue: -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2),
            maxValue: SHROOM_SPAWN_CHANNEL_AMOUNT / 2,
            store: { key: "shroom-spawn_channel" },
            label: { 
              text: "-",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
          slider: {
            minValue: -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
            maxValue: SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0,
            snapValue: 1.0 / SHROOM_SPAWN_CHANNEL_AMOUNT,
            store: { key: "shroom-spawn_channel" },
          },
          increase: {
            factor: 1.0,
            minValue: -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2),
            maxValue: SHROOM_SPAWN_CHANNEL_AMOUNT / 2,
            store: { key: "shroom-spawn_channel" },
            label: { 
              text: "+",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
        },
      },
      {
        name: "shroom-spawn_row",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Y" },  
          field: { store: { key: "shroom-spawn_row" } },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_row-snap" },
          },
          title: { 
            text: "Snap",
            enable: { key: "shroom-spawn_row-snap" },
          },
        },
      },
      {
        name: "shroom-spawn_row-rng",
        template: VEComponents.get("text-field-checkbox"),
        layout: VELayouts.get("text-field-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Rng",
            enable: { key: "shroom-spawn_use-row-rng" },
          },  
          field: { 
            store: { key: "shroom-spawn_row-rng" },
            enable: { key: "shroom-spawn_use-row-rng" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-spawn_use-row-rng" },
          },
          title: { 
            text: "Enable",
            enable: { key: "shroom-spawn_use-row-rng" },
          },
        },
      },
      {
        name: "shroom-spawn_row-slider",  
        template: VEComponents.get("numeric-slider-button"),
        layout: VELayouts.get("numeric-slider-button"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "" },
          decrease: {
            factor: -1.0,
            minValue: -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2),
            maxValue: SHROOM_SPAWN_ROW_AMOUNT / 2,
            store: { key: "shroom-spawn_row" },
            label: { 
              text: "-",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
          slider: {
            minValue: -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2.0),
            maxValue: SHROOM_SPAWN_ROW_AMOUNT / 2.0,
            snapValue: 1.0 / SHROOM_SPAWN_ROW_AMOUNT,
            store: { key: "shroom-spawn_row" },
          },
          increase: {
            factor: 1.0,
            minValue: -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2),
            maxValue: SHROOM_SPAWN_ROW_AMOUNT / 2,
            store: { key: "shroom-spawn_row" },
            label: { 
              text: "+",
              font: "font_inter_10_bold",
            },
            backgroundColor: VETheme.color.primary,
            backgroundColorSelected: VETheme.color.primaryLight,
            backgroundColorOut: VETheme.color.primary,
            onMouseHoverOver: function(event) {
              if (Struct.get(this.enable, "value") == false) {
                this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
                return
              }
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorSelected).toGMColor()
            },
            onMouseHoverOut: function(event) {
              this.backgroundColor = ColorUtil.fromHex(this.backgroundColorOut).toGMColor()
            },
            callback: function() {
              this.store.set(clamp(this.store.getValue() + this.factor, this.minValue, this.maxValue))
            },
          },
        },
      },
    ]),
  }
}