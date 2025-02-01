///@package io.alkapivo.visu.editor.service.brush.entity

///@param {?Struct} [json]
///@return {Struct}
function brush_entity_config(json = null) {
  return {
    name: "brush_entity_config",
    store: new Map(String, Struct, {
      "en-cfg_use-render-shr": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-render-shr"),
      },
      "en-cfg_render-shr": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_render-shr"),
      },
      "en-cfg_use-render-player": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-render-player"),
      },
      "en-cfg_render-player": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_render-player"),
      },
      "en-cfg_use-render-coin": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-render-coin"),
      },
      "en-cfg_render-coin": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_render-coin"),
      },
      "en-cfg_use-render-bullet": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-render-bullet"),
      },
      "en-cfg_render-bullet": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_render-bullet"),
      },
      "en-cfg_cls-shr": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_cls-shr"),
      },
      "en-cfg_cls-player": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_cls-player"),
      },
      "en-cfg_cls-coin": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_cls-coin"),
      },
      "en-cfg_cls-bullet": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_cls-bullet"),
      },
      "en-cfg_use-z-shr": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-z-shr"),
      },
      "en-cfg_z-shr": {
        type: NumberTransformer,
        value: Struct.get(json, "en-cfg_z-shr"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99999.9),
      },
      "en-cfg_change-z-shr": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_change-z-shr"),
      },
      "en-cfg_use-z-player": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-z-player"),
      },
      "en-cfg_z-player": {
        type: NumberTransformer,
        value: Struct.get(json, "en-cfg_z-player"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99999.9),
      },
      "en-cfg_change-z-player": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_change-z-player"),
      },
      "en-cfg_use-z-coin": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-z-coin"),
      },
      "en-cfg_z-coin": {
        type: NumberTransformer,
        value: Struct.get(json, "en-cfg_z-coin", Struct),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99999.9),
      },
      "en-cfg_change-z-coin": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_change-z-coin"),
      },
      "en-cfg_use-z-bullet": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-z-bullet"),
      },
      "en-cfg_z-bullet": {
        type: NumberTransformer,
        value: Struct.get(json, "en-cfg_z-bullet"),
        passthrough: UIUtil.passthrough.getClampedNumberTransformer(),
        data: new Vector2(0.0, 99999.9),
      },
      "en-cfg_change-z-bullet": {
        type: Boolean,
        value: Struct.get(json, "en-cfg_use-render-shr"),
      },
    }),
    components: new Array(Struct, [
      {
        name: "en-cfg_render",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Render",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "en-cfg_render-shr",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Shrooms",
            enable: { key: "en-cfg_use-render-shr" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_use-render-shr" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "en-cfg_render-shr" },
            enable: { key: "en-cfg_use-render-shr" },
          },
        },
      },
      {
        name: "en-cfg_render-player",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Player",
            enable: { key: "en-cfg_use-render-player" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_use-render-player" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "en-cfg_render-player" },
            enable: { key: "en-cfg_use-render-player" },
          },
        },
      },{
        name: "en-cfg_render-coin",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Coins",
            enable: { key: "en-cfg_use-render-coin" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_use-render-coin" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "en-cfg_render-coin" },
            enable: { key: "en-cfg_use-render-coin" },
          },
        },
      },
      {
        name: "en-cfg_render-bullet",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Bullets",
            enable: { key: "en-cfg_use-render-bullet" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_use-render-bullet" },
          },
          input: {
            spriteOn: { name: "visu_texture_checkbox_switch_on" },
            spriteOff: { name: "visu_texture_checkbox_switch_off" },
            store: { key: "en-cfg_render-bullet" },
            enable: { key: "en-cfg_use-render-bullet" },
          },
        },
      },
      {
        name: "en-cfg_cls-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-cfg_cls",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "en-cfg_cls-shr",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Shrooms",
            enable: { key: "en-cfg_cls-shr" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_cls-shr" },
          },
        },
      },
      {
        name: "en-cfg_cls-player",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Player",
            enable: { key: "en-cfg_cls-player" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_cls-player" },
          },
        },
      },
      {
        name: "en-cfg_cls-coin",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Coins",
            enable: { key: "en-cfg_cls-coin" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_cls-coin" },
          },
        },
      },
      {
        name: "en-cfg_cls-bullet",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Bullets",
            enable: { key: "en-cfg_cls-bullet" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "en-cfg_cls-bullet" },
          },
        },
      },
      {
        name: "en-cfg_z-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-cfg_z",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Position Z",
            backgroundColor: VETheme.color.accentShadow,
          },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
          input: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "en-cfg_z-shr",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: {
            type: UILayoutType.VERTICAL,
            margin: { top: 4 },
          },
          value: {
            label: {
              text: "Shroom Z",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "en-cfg_use-z-shr" },
            },
            field: {
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_use-z-shr" },
            },
            decrease: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_use-z-shr" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_use-z-shr" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_use-z-shr" },
            },
            title: { 
              text: "Override",
              enable: { key: "en-cfg_use-z-shr" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "en-cfg_change-z-shr" },
            },
            field: {
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
            },
            decrease: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_change-z-shr" },
            },
            title: { 
              text: "Change",
              enable: { key: "en-cfg_change-z-shr" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "en-cfg_change-z-shr" },
            },
            field: {
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
            },
            decrease: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "en-cfg_change-z-shr" },
            },
            field: {
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
            },
            decrease: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-shr" },
              enable: { key: "en-cfg_change-z-shr" },
              factor: 1.0,
            },
          },
        },
      },
      {
        name: "en-cfg_z-player-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-cfg_z-player",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Player Z",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "en-cfg_use-z-player" },
            },
            field: {
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_use-z-player" },
            },
            decrease: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_use-z-player" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_use-z-player" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_use-z-player" },
            },
            title: { 
              text: "Override",
              enable: { key: "en-cfg_use-z-player" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "en-cfg_change-z-player" },
            },
            field: {
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
            },
            decrease: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_change-z-player" },
            },
            title: { 
              text: "Change",
              enable: { key: "en-cfg_change-z-player" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "en-cfg_change-z-player" },
            },
            field: {
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
            },
            decrease: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "en-cfg_change-z-player" },
            },
            field: {
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
            },
            decrease: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-player" },
              enable: { key: "en-cfg_change-z-player" },
              factor: 1.0,
            },
          },
        },
      },
      {
        name: "en-cfg_z-coin-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-cfg_z-coin",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Coin Z",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "en-cfg_use-z-coin" },
            },
            field: {
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_use-z-coin" },
            },
            decrease: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_use-z-coin" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_use-z-coin" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_use-z-coin" },
            },
            title: { 
              text: "Override",
              enable: { key: "en-cfg_use-z-coin" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "en-cfg_change-z-coin" },
            },
            field: {
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
            },
            decrease: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_change-z-coin" },
            },
            title: { 
              text: "Change",
              enable: { key: "en-cfg_change-z-coin" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "en-cfg_change-z-coin" },
            },
            field: {
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
            },
            decrease: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "en-cfg_change-z-coin" },
            },
            field: {
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
            },
            decrease: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-coin" },
              enable: { key: "en-cfg_change-z-coin" },
              factor: 1.0,
            },
          },
        },
      },
      {
        name: "en-cfg_z-bullet-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "en-cfg_z-bullet",
        template: VEComponents.get("number-transformer-increase-checkbox"),
        layout: VELayouts.get("number-transformer-increase-checkbox"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          value: {
            label: {
              text: "Bullet Z",
              font: "font_inter_10_bold",
              color: VETheme.color.textShadow,
              //enable: { key: "en-cfg_use-z-bullet" },
            },
            field: {
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_use-z-bullet" },
            },
            decrease: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_use-z-bullet" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_use-z-bullet" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_use-z-bullet" },
            },
            title: { 
              text: "Override",
              enable: { key: "en-cfg_use-z-bullet" },
            },
          },
          target: {
            label: {
              text: "Target",
              enable: { key: "en-cfg_change-z-bullet" },
            },
            field: {
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
            },
            decrease: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: 1.0,
            },
            checkbox: { 
              spriteOn: { name: "visu_texture_checkbox_on" },
              spriteOff: { name: "visu_texture_checkbox_off" },
              store: { key: "en-cfg_change-z-bullet" },
            },
            title: { 
              text: "Change",
              enable: { key: "en-cfg_change-z-bullet" },
            },
          },
          factor: {
            label: {
              text: "Factor",
              enable: { key: "en-cfg_change-z-bullet" },
            },
            field: {
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
            },
            decrease: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: 1.0,
            },
          },
          increase: {
            label: {
              text: "Increase",
              enable: { key: "en-cfg_change-z-bullet" },
            },
            field: {
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
            },
            decrease: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: -1.0,
            },
            increase: { 
              store: { key: "en-cfg_z-bullet" },
              enable: { key: "en-cfg_change-z-bullet" },
              factor: 1.0,
            },
          },
        },
      },
    ]),
  }
}