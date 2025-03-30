///@package io.alkapivo.visu.editor.service.brush.entity

///@param {Struct} json
///@return {Struct}
function brush_entity_shroom(json) {
  return {
    name: "brush_entity_shroom",
    store: new Map(String, Struct, {
      "en-shr_preview": {
        type: Boolean,
        value: Struct.get(json, "en-shr_preview"),
      },
      "en-shr_template": {
        type: String,
        value: Struct.get(json, "en-shr_template"),
        passthrough: UIUtil.passthrough.getCallbackValue(),
        data: {
          callback: Beans.get(BeanVisuController).shroomTemplateExists,
          defaultValue: "shroom-default",
        },
      },
      "en-shr_use-lifespan": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-lifespan")
      },
      "en-shr_lifespan": {
        type: Number,
        value: Struct.get(json, "en-shr_lifespan"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 999.9),
      },
      "en-shr_use-hp": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-hp"),
      },
      "en-shr_hp": {
        type: Number,
        value: Struct.get(json, "en-shr_hp"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 9999999.9),
      },
      "en-shr_spd": {
        type: Number,
        value: Struct.get(json, "en-shr_spd"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
      "en-shr_use-spd-rng": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-spd-rng"),
      },
      "en-shr_spd-rng": {
        type: Number,
        value: Struct.get(json, "en-shr_spd-rng"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 99.9),
      },
      "en-shr_dir": {
        type: Number,
        value: Struct.get(json, "en-shr_dir"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 360.0),
      },
      "en-shr_use-dir-rng": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-dir-rng"),
      },
      "en-shr_dir-rng": {
        type: Number,
        value: Struct.get(json, "en-shr_dir-rng"),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(0.0, 360.0),
      },
      "en-shr_x": {
        type: Number,
        value: Struct.get(json, "en-shr_x", Number, 0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(
          -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0), 
          SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0
        ),
      },
      "en-shr_snap-x": {
        type: Boolean,
        value: Struct.get(json, "en-shr_snap-x"),
      },
      "en-shr_use-rng-x": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-rng-x"),
      },
      "en-shr_rng-x": {
        type: Number,
        value: Struct.get(json, "en-shr_rng-x", Number, 0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(
          0.0, 
          SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0
        ),
      },
      "en-shr_y": {
        type: Number,
        value: Struct.get(json, "en-shr_y", Number, 0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(
          -1.0 * (SHROOM_SPAWN_ROW_AMOUNT / 2.0), 
          SHROOM_SPAWN_ROW_AMOUNT / 2.0
        ),
      },
      "en-shr_snap-y": {
        type: Boolean,
        value: Struct.get(json, "en-shr_snap-y"),
      },
      "en-shr_use-rng-y": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-rng-y"),
      },
      "en-shr_rng-y": {
        type: Number,
        value: Struct.get(json, "en-shr_rng-y", Number, 0),
        passthrough: UIUtil.passthrough.getClampedStringNumber(),
        data: new Vector2(
          0.0, 
          SHROOM_SPAWN_ROW_AMOUNT / 2.0
        ),
      },
      "en-shr_use-texture": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-texture"),
      },
      "en-shr_texture": {
        type: Sprite,
        value: Struct.get(json, "en-shr_texture"),
      },
      "en-shr_use-mask": {
        type: Boolean,
        value: Struct.get(json, "en-shr_use-mask"),
      },
      "en-shr_mask": {
        type: Rectangle,
        value: Struct.get(json, "en-shr_mask"),
      },
    }),
    components: new Array(Struct, [
      {
        name: "en-shr_template",  
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2, bottom: 2 },
          },
          label: { text: "Template" },
          field: { store: { key: "en-shr_template" } },
        },
      },
      {
        name: "en-shr_lifespan",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lifespan",
            enable: { key: "en-shr_use-lifespan" },
          },  
          field: { 
            store: { key: "en-shr_lifespan" },
            enable: { key: "en-shr_use-lifespan" },
          },
          decrease: {
            store: { key: "en-shr_lifespan" },
            enable: { key: "en-shr_use-lifespan" },
            factor: -0.1,
          },
          increase: {
            store: { key: "en-shr_lifespan" },
            enable: { key: "en-shr_use-lifespan" },
            factor: 0.1,
          },
          stick: {
            store: { key: "en-shr_lifespan" },
            enable: { key: "en-shr_use-lifespan" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "en-shr_use-lifespan" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
          title: {
            text: "Override",
            enable: { key: "en-shr_use-lifespan" },
          }
        },
      },
      {
        name: "en-shr_hp",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Health",
            enable: { key: "en-shr_use-hp" },
          },  
          field: { 
            store: { key: "en-shr_hp" },
            enable: { key: "en-shr_use-hp" },
          },
          decrease: {
            store: { key: "en-shr_hp" },
            enable: { key: "en-shr_use-hp" },
            factor: -0.1,
          },
          increase: {
            store: { key: "en-shr_hp" },
            enable: { key: "en-shr_use-hp" },
            factor: 0.1,
          },
          stick: {
            store: { key: "en-shr_hp" },
            enable: { key: "en-shr_use-hp" },
            factor: 0.01,
          },
          checkbox: {
            store: { key: "en-shr_use-hp" },
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
          },
          title: {
            text: "Override",
            enable: { key: "en-shr_use-hp" },
          }
        },
      },
      {
        name: "en-shr-template-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_preview",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render spawn position",
            enable: { key: "en-shr_preview" },
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

              if (!Optional.is(store) || !store.getValue("en-shr_preview")) {
                return
              }

              var controller = Beans.get(BeanVisuController)
              var locked = controller.gridService.targetLocked
              var view = controller.gridService.view
  
              if (!Struct.contains(this, "spawnerXTimer")) {
                Struct.set(this, "spawnerXTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var _x = store.getValue("en-shr_x") * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) + 0.5
              if (store.getValue("en-shr_use-rng-x")) {
                _x += sin(this.spawnerXTimer.update().time) * (store.getValue("en-shr_rng-x") * (SHROOM_SPAWN_CHANNEL_SIZE / SHROOM_SPAWN_CHANNEL_AMOUNT) / 2.0)
              }

              if (store.getValue("en-shr_snap-x")) {
                _x = _x - (view.x - locked.snapH)
              }

              if (!Struct.contains(this, "spawnerYTimer")) {
                Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var _y = store.getValue("en-shr_y") * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) - 0.5
              if (store.getValue("en-shr_use-rng-y")) {
                _y += sin(this.spawnerYTimer.update().time) * (store.getValue("en-shr_rng-y") * (SHROOM_SPAWN_ROW_SIZE / SHROOM_SPAWN_ROW_AMOUNT) / 2.0)
              }

              if (store.getValue("en-shr_snap-y")) {
                _y = _y - (view.y - locked.snapV)
              }

              if (!Struct.contains(this, "spawnerAngleTimer")) {
                Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var angle = store.getValue("en-shr_dir")
              if (store.getValue("en-shr_use-dir-rng")) {
                angle += sin(this.spawnerAngleTimer.update().time) * (store.getValue("en-shr_dir-rng") / 2.0)
              }

              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.spawnerEvent = shroomService.factorySpawner({ 
                    x: _x, 
                    y: _y, 
                    sprite: SpriteUtil.parse({ 
                      name: "texture_visu_shroom_spawner", 
                      blend: "#43abfa",
                      angle: angle,
                    })
                  })
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  shroomService.spawner = shroomService.factorySpawner({ 
                    x: _x, 
                    y: _y, 
                    sprite: SpriteUtil.parse({
                      name: "texture_visu_shroom_spawner",
                      blend: "#f757ef",
                      angle: angle,
                    })
                  })
                  break
              }
            },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_preview" },
            backgroundColor: VETheme.color.accentShadow,
          },
          input: {
            backgroundColor: VETheme.color.accentShadow,
          }
        },
      },
      {
        name: "en-shr_x-slider",  
        template: VEComponents.get("numeric-slider"),
        layout: VELayouts.get("numeric-slider"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            margin: { top: 2 },
          },
          label: { 
            text: "X",
            color: VETheme.color.textShadow,
            font: "font_inter_10_bold",
            offset: { y: 14 },
          },
          slider: {
            minValue: -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
            maxValue: SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0,
            snapValue: 1.0 / SHROOM_SPAWN_CHANNEL_AMOUNT,
            store: { key: "en-shr_x" },
          },
        },
      },
      {
        name: "en-shr_x",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-stick-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { text: "" },
          field: { store: { key: "en-shr_x" } },
          decrease: {
            store: { key: "en-shr_x" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_x" },
            factor: 0.25,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_snap-x" },
          },
          title: { 
            text: "Snap",
            enable: { key: "en-shr_snap-x" },
          },
        },
      },
      {
        name: "en-shr_rng-x",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2, bottom: 4 },
          },
          label: { 
            text: "Random",
            enable: { key: "en-shr_use-rng-x" },
          },  
          field: { 
            store: { key: "en-shr_rng-x" },
            enable: { key: "en-shr_use-rng-x" },
          },
          decrease: {
            store: { key: "en-shr_rng-x" },
            enable: { key: "en-shr_use-rng-x" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_rng-x" },
            enable: { key: "en-shr_use-rng-x" },
            factor: 0.25,
          },
          stick: {
            factor: 0.001,
            store: { key: "en-shr_rng-x" },
            enable: { key: "en-shr_use-rng-x" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_use-rng-x" },
          },
          title: { 
            text: "Enable",
            enable: { key: "en-shr_use-rng-x" },
          },
        },
      },
      {
        name: "en-shr-rng-x-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_y-slider",  
        template: VEComponents.get("numeric-slider"),
        layout: VELayouts.get("numeric-slider"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { 
            text: "Y",
            color: VETheme.color.textShadow,
            font: "font_inter_10_bold",
            offset: { y: 14 },
          },
          slider: {
            minValue: -1.0 * (SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0),
            maxValue: SHROOM_SPAWN_CHANNEL_AMOUNT / 2.0,
            snapValue: 1.0 / SHROOM_SPAWN_CHANNEL_AMOUNT,
            store: { key: "en-shr_y" },
          },
        },
      },
      {
        name: "en-shr_y",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-stick-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { text: "" },
          field: { store: { key: "en-shr_y" } },
          decrease: {
            store: { key: "en-shr_y" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_y" },
            factor: 0.25,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_snap-y" },
          },
          title: { 
            text: "Snap",
            enable: { key: "en-shr_snap-y" },
          },
        },
      },
      {
        name: "en-shr_rng-y",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2, bottom: 4 },
          },
          label: { 
            text: "Random",
            enable: { key: "en-shr_use-rng-y" },
          },  
          field: { 
            store: { key: "en-shr_rng-y" },
            enable: { key: "en-shr_use-rng-y" },
          },
          decrease: {
            store: { key: "en-shr_rng-y" },
            enable: { key: "en-shr_use-rng-y" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_rng-y" },
            enable: { key: "en-shr_use-rng-y" },
            factor: 0.25,
          },
          stick: {
            factor: 0.001,
            store: { key: "en-shr_rng-y" },
            enable: { key: "en-shr_use-rng-y" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_use-rng-y" },
          },
          title: { 
            text: "Enable",
            enable: { key: "en-shr_use-rng-y" },
          },
        },
      },
      {
        name: "en-shr-rng-y-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_spd-slider",  
        template: VEComponents.get("numeric-slider"),
        layout: VELayouts.get("numeric-slider"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { 
            text: "Speed",
            font: "font_inter_10_bold",
            offset: { y: 14 },
          },
          slider: {
            mminValue: 0.0,
            maxValue: 99.9,
            snapValue: 1.0 / 99.9,
            store: { key: "en-shr_spd" },
          },
        },
      },
      {
        name: "en-shr_spd",  
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-stick-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: {
            text: "",
            font: "font_inter_10_bold",
          },
          field: { store: { key: "en-shr_spd" } },
          decrease: { 
            store: { key: "en-shr_spd" },
            factor: -0.1,
          },
          increase: { 
            store: { key: "en-shr_spd" },
            factor: 0.1,
          },
          checkbox: { },
        },
      },
      {
        name: "en-shr_spd-rng",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2, bottom: 4 },
          },
          label: { 
            text: "Random",
            enable: { key: "en-shr_use-spd-rng" },
          },  
          field: { 
            store: { key: "en-shr_spd-rng" },
            enable: { key: "en-shr_use-spd-rng" },
          },
          decrease: {
            store: { key: "en-shr_spd-rng" },
            enable: { key: "en-shr_use-spd-rng" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_spd-rng" },
            enable: { key: "en-shr_use-spd-rng" },
            factor: 0.25,
          },
          stick: {
            factor: 0.001,
            store: { key: "en-shr_spd-rng" },
            enable: { key: "en-shr_use-spd-rng" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_use-spd-rng" },
          },
          title: { 
            text: "Enable",
            enable: { key: "en-shr_use-spd-rng" },
          },
        },
      },
      {
        name: "en-spd-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_dir-slider",  
        template: VEComponents.get("numeric-slider"),
        layout: VELayouts.get("numeric-slider"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: {
            text: "Angle",
            font: "font_inter_10_bold",
            offset: { y: 14 },
          },
          slider: {
            minValue: 0.0,
            maxValue: 360.0,
            snapValue: 1.0 / 360.0,
            store: { key: "en-shr_dir" },
          },
        },
      },
      {
        name: "en-shr_dir",
        template: VEComponents.get("text-field-increase-checkbox"),
        layout: VELayouts.get("text-field-increase-stick-checkbox"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: {
            text: "",
            font: "font_inter_10_bold",
          },
          field: { store: { key: "en-shr_dir" } },
          decrease: {
            store: { key: "en-shr_dir" },
            factor: -0.1,
          },
          increase: {
            store: { key: "en-shr_dir" },
            factor: 0.1,
          },
          checkbox: { 
            store: { 
              key: "en-shr_dir",
              callback: function(value, data) { 
                var sprite = Struct.get(data, "sprite")
                if (!Core.isType(sprite, Sprite)) {
                  sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
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
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
                Struct.set(this, "sprite", sprite)
              }

              if (!Struct.contains(this, "spawnerAngleTimer")) {
                Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
                  loop: Infinity,
                  amount: FRAME_MS * 4,
                  shuffle: true
                }))
              }

              var angle = sprite.getAngle()
              if (this.store != null && this.store.getStore().getValue("en-shr_use-dir-rng")) {
                sprite.setAngle(angle + sin(this.spawnerAngleTimer.update().time) * (this.store.getStore().getValue("en-shr_dir-rng") / 2.0))
              }
              
              sprite
                .scaleToFit(this.area.getWidth() * 2, this.area.getHeight() * 2)              
                .render(
                  24 + this.context.area.getX() + this.area.getX() + sprite.texture.offsetX * sprite.getScaleX(),
                  this.context.area.getY() + this.area.getY() + sprite.texture.offsetY * sprite.getScaleY() - 4
                )
                .setAngle(angle)
              
              return this
            },
          },
          title: { text: "" },
        },
      },
      {
        name: "en-shr_dir-rng",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: { 
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2, bottom: 4 },
          },
          label: { 
            text: "Random",
            enable: { key: "en-shr_use-dir-rng" },
          },  
          field: { 
            store: { key: "en-shr_dir-rng" },
            enable: { key: "en-shr_use-dir-rng" },
          },
          decrease: {
            store: { key: "en-shr_dir-rng" },
            enable: { key: "en-shr_use-dir-rng" },
            factor: -0.25,
          },
          increase: {
            store: { key: "en-shr_dir-rng" },
            enable: { key: "en-shr_use-dir-rng" },
            factor: 0.25,
          },
          stick: {
            store: { key: "en-shr_dir-rng" },
            enable: { key: "en-shr_use-dir-rng" },
            factor: 0.001,
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_use-dir-rng" },
          },
          title: { 
            text: "E.",
            enable: { key: "en-shr_use-dir-rng" },
          },
        },
      },
      /*
      {
        name: "en-shr-dir-rng-y-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_texture",
        template: VEComponents.get("texture-field-ext"),
        layout: VELayouts.get("texture-field-ext"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Override texture",
              backgroundColor: VETheme.color.accentShadow,
              enable: { key: "en-shr_use-texture" },
            },
            input: { backgroundColor: VETheme.color.accentShadow },
            checkbox: { 
              backgroundColor: VETheme.color.accentShadow,
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-shr_use-texture" },
            },
          },
          texture: {
            label: { 
              text: "Texture",
              enable: { key: "en-shr_use-texture" },
            }, 
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
          preview: {
            image: { name: "texture_empty" },
            store: { key: "en-shr_texture" },
            enable: { key: "en-shr_use-texture" },
          },
          resolution: {
            store: { key: "en-shr_texture" },
            enable: { key: "en-shr_use-texture" },
          },
          alpha: {
            label: { 
              text: "Alpha",
              enable: { key: "en-shr_use-texture" },
            },
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            decrease: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            increase: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            slider: { 
              minValue: 0.0,
              maxValue: 1.0,
              snapValue: 0.01 / 1.0,
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
          frame: {
            label: { 
              text: "Frame",
              enable: { key: "en-shr_use-texture" },
            },
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            decrease: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            increase: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            checkbox: { 
              store: { key: "en-shr_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "en-shr_use-texture" },
            },
            title: { 
              text: "Rng",
              enable: { key: "en-shr_use-texture" },
            }, 
            stick: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
          speed: {
            label: { 
              text: "Speed",
              enable: { key: "en-shr_use-texture" },
            },
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            decrease: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            increase: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            checkbox: { 
              store: { key: "en-shr_texture" },
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              enable: { key: "en-shr_use-texture" },
            },
            stick: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
          scaleX: {
            label: { 
              text: "Scale X",
              enable: { key: "en-shr_use-texture" },
            },
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            decrease: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            increase: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            stick: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
          scaleY: {
            label: { 
              text: "Scale Y",
              enable: { key: "en-shr_use-texture" },
            },
            field: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            decrease: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            increase: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
            stick: { 
              store: { key: "en-shr_texture" },
              enable: { key: "en-shr_use-texture" },
            },
          },
        },
      },
      {
        name: "en-shr_texture-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-shr_mask-title",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Override collision mask",
            enable: { key: "en-shr_use-mask" },
            backgroundColor: VETheme.color.side,
          },
          input: { backgroundColor: VETheme.color.side },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-shr_use-mask" },
            backgroundColor: VETheme.color.side,
          },
        },
      },
      {
        name: "en-shr_mask-preview",
        template: VEComponents.get("preview-image-mask"),
        layout: VELayouts.get("preview-image-mask"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          preview: {
            enable: { key: "en-shr_use-mask" },
            image: { name: "texture_empty" },
            store: { key: "en-shr_texture" },
            mask: "en-shr_mask",
          },
          resolution: {
            enable: { key: "en-shr_use-mask" },
            store: { key: "en-shr_texture" },
          },
        },
      },
      {
        name: "en-shr_mask",
        template: VEComponents.get("vec4-stick-increase"),
        layout: VELayouts.get("vec4"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          x: {
            label: {
              text: "X",
              enable: { key: "en-shr_use-mask" },
            },
            field: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 0.1,
            },
          },
          y: {
            label: {
              text: "Y",
              enable: { key: "en-shr_use-mask" },
            },
            field: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 0.1,
            },
          },
          z: {
            label: {
              text: "Width",
              enable: { key: "en-shr_use-mask" },
            },
            field: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 0.1,
            },
          },
          a: {
            label: {
              text: "Height",
              enable: { key: "en-shr_use-mask" },
            },
            field: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              GMTF_DECIMAL: 0,
            },
            decrease: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: -1.0,
            },
            increase: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 1.0,
            },
            slider: {
              store: { key: "en-shr_mask" },
              enable: { key: "en-shr_use-mask" },
              factor: 0.1,
            },
          },
        },
      },
      */
    ]),
  }
}