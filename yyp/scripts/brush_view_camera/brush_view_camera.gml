///@package io.alkapivo.visu.editor.service.brush.view

///@param {?Struct} [json]
///@return {Struct}
function brush_view_camera(json = null) {
  return {
    name: "brush_view_camera",
    store: new Map(String, Struct, {
      "view-config_use-lock-target-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-lock-target-x", false),
      },
      "view-config_lock-target-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_lock-target-x", false),
      },
      "view-config_use-lock-target-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-lock-target-y", false),
      },
      "view-config_lock-target-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_lock-target-y", false),
      },
      "view-config_use-follow-properties": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-follow-properties", false),
      },
      "view-config_follow-margin-x": {
        type: Number,
        value: Struct.getDefault(json, "view-config_follow-margin-x", 0.35),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-config_follow-margin-y": {
        type: Number,
        value: Struct.getDefault(json, "view-config_follow-margin-y", 0.40),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 0.0, 1.0)
        },
      },
      "view-config_follow-smooth": {
        type: Number,
        value: Struct.getDefault(json, "view-config_follow-smooth", 32),
        passthrough: function(value) {
          return clamp(NumberUtil.parse(value, this.value), 1.0, 256.0)
        },
      },
      "view-config_use-transform-x": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-x", false),
      },
      "view-config_transform-x": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-x",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-y": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-y", false),
      },
      "view-config_transform-y": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-y",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-z": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-z", false),
      },
      "view-config_transform-z": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-z",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-zoom": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-zoom", false),
      },
      "view-config_transform-zoom": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-zoom",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-angle": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-angle", false),
      },
      "view-config_transform-angle": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-angle",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-transform-pitch": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-transform-pitch", false),
      },
      "view-config_transform-pitch": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_transform-pitch",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_use-movement": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_use-movement", false),
      },
      "view-config_movement-enable": {
        type: Boolean,
        value: Struct.getDefault(json, "view-config_movement-enable", false),
      },
      "view-config_movement-angle": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_movement-angle",
          { value: 90, target: 1, factor: 0.01, increase: 0 }
        )),
      },
      "view-config_movement-speed": {
        type: NumberTransformer,
        value: new NumberTransformer(Struct.getDefault(json, 
          "view-config_movement-speed",
          { value: 0, target: 1, factor: 0.01, increase: 0 }
        )),
      },
    }),
    components: new Array(Struct, [
      {
        name: "view-config_use-movement",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Move camera",
            enable: { key: "view-config_use-movement" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-movement" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_movement-enable" },
            enable: { key: "view-config_use-movement" },
          },
        },
      },
      {
        name: "view-config_movement-angle",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Angle",
              enable: { key: "view-config_use-movement" },
            },
            input: {
              store: { 
                key: "view-config_movement-angle",
                callback: function(value, data) { 
                  var sprite = Struct.get(data, "sprite")
                  if (!Core.isType(sprite, Sprite)) {
                    sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                    Struct.set(data, "sprite", sprite)
                  }
                  sprite.setAngle(value.target)
                },
                set: function(value) { return },
              },
              enable: { key: "view-config_use-movement" },
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
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-angle" },
              enable: { key: "view-config_use-movement" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-angle" },
              enable: { key: "view-config_use-movement" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-angle" },
              enable: { key: "view-config_use-movement" },
            },
          },
        },
      },
      {
        name: "view-config_movement-speed",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Speed",
              enable: { key: "view-config_use-movement" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-speed" },
              enable: { key: "view-config_use-movement" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-speed" },
              enable: { key: "view-config_use-movement" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-movement" },
            },
            field: {
              store: { key: "view-config_movement-speed" },
              enable: { key: "view-config_use-movement" },
            },
          },
        },
      },
      {
        name: "view-config_use-lock-target-x",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lock target X",
            enable: { key: "view-config_use-lock-target-x" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-lock-target-x" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_lock-target-x" },
            enable: { key: "view-config_use-lock-target-x" },
          },
        },
      },
      {
        name: "view-config_use-lock-target-y",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Lock target Y",
            enable: { key: "view-config_use-lock-target-y" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-lock-target-y" },
          },
          input: { 
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "view-config_lock-target-y" },
            enable: { key: "view-config_use-lock-target-y" },
          },
        },
      },
      {
        name: "view-config_use-follow-properties",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Follow properties",
            enable: { key: "view-config_use-follow-properties" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "view-config_use-follow-properties" },
          },
        },
      },
      {
        name: "view-config_follow-margin-x",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "X margin",
            enable: { key: "view-config_use-follow-properties" },
          },
          field: { store: { key: "view-config_follow-margin-x" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-config_follow-margin-x" },
            enable: { key: "view-config_use-follow-properties" },
          },
        }
      },
      {
        name: "view-config_follow-margin-y",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Y margin",
            enable: { key: "view-config_use-follow-properties" },
          },
          field: { store: { key: "view-config_follow-margin-y" }},
          slider: {
            minValue: 0.0,
            maxValue: 1.0,
            store: { key: "view-config_follow-margin-y" },
            enable: { key: "view-config_use-follow-properties" },
          },
        }
      },
      {
        name: "view-config_follow-smooth",
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL},
          label: { 
            text: "Smooth",
            enable: { key: "view-config_use-follow-properties" },
          },
          field: { store: { key: "view-config_follow-smooth" }},
          slider: {
            minValue: 1.0,
            maxValue: 256.0,
            store: { key: "view-config_follow-smooth" },
            enable: { key: "view-config_use-follow-properties" },
          },
        }
      },
      {
        name: "view-config_transform-x",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera x",
              enable: { key: "view-config_use-transform-x" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-x" },
            },
          },
          target: {
            label: { 
              text: "Target",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
          factor: {
            label: { 
              text: "Factor",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
          increment: {
            label: { 
              text: "Increase",
              enable: { key: "view-config_use-transform-x" },
            },
            field: { 
              store: { key: "view-config_transform-x" },
              enable: { key: "view-config_use-transform-x" },
            },
          },
        },
      },
      {
        name: "view-config_transform-y",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: {
              text: "Transform camera y",
              enable: { key: "view-config_use-transform-y" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-y" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-transform-y" },
            },
            field: {
              store: { key: "view-config_transform-y" },
              enable: { key: "view-config_use-transform-y" },
            },
          },
        },
      },
      {
        name: "view-config_transform-z",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera z",
              enable: { key: "view-config_use-transform-z" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-z" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-transform-z" },
            },
            field: {
              store: { key: "view-config_transform-z" },
              enable: { key: "view-config_use-transform-z" },
            },
          },
        },
      },
      {
        name: "view-config_transform-zoom",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera zoom",
              enable: { key: "view-config_use-transform-zoom" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-zoom" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-transform-zoom" },
            },
            field: {
              store: { key: "view-config_transform-zoom" },
              enable: { key: "view-config_use-transform-zoom" },
            },
          },
        },
      },
      {
        name: "view-config_transform-angle",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera angle",
              enable: { key: "view-config_use-transform-angle" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-angle" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-transform-angle" },
            },
            field: {
              store: { key: "view-config_transform-angle" },
              enable: { key: "view-config_use-transform-angle" },
            },
          },
        },
      },
      {
        name: "view-config_transform-pitch",
        template: VEComponents.get("transform-numeric-property"),
        layout: VELayouts.get("transform-numeric-property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          title: {
            label: { 
              text: "Transform camera pitch",
              enable: { key: "view-config_use-transform-pitch" },
            },  
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "view-config_use-transform-pitch" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
          increment: {
            label: {
              text: "Increase",
              enable: { key: "view-config_use-transform-pitch" },
            },
            field: {
              store: { key: "view-config_transform-pitch" },
              enable: { key: "view-config_use-transform-pitch" },
            },
          },
        },
      },
    ]),
  }
}