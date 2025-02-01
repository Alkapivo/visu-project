///@package io.alkapivo.visu.editor.service.brush._old.shroom

///@param {Struct} json
///@return {Struct}
function migrateShroomClearEvent(json) {
  return {
    "icon": Struct.getIfType(json, "icon", Struct, { name: "texture_baron" }),
    "en-cfg_cls-shr": Struct.getIfType(json, "shroom-clear_use-clear-all-shrooms", Boolean, false)
      || (Struct.getIfType(json, "shroom-clear_use-clear-amount", Boolean, false)
        && Struct.getIfType(json, "shroom-clear_clear-amount", Number, 0) > 0),
  }
}


///@param {?Struct} [json]
///@return {Struct}
function brush_shroom_clear(json = null) {
  return {
    name: "brush_shroom_clear",
    store: new Map(String, Struct, {
      "shroom-clear_use-clear-all-shrooms": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-clear_use-clear-all-shrooms", false),
      },
      "shroom-clear_use-clear-amount": {
        type: Boolean,
        value: Struct.getDefault(json, "shroom-clear_use-clear-amount", false),
      },
      "shroom-clear_clear-amount": {
        type: Number,
        value: Struct.getDefault(json, "shroom-clear_clear-amount", 1),
        passthrough: function(value) {
          return round(clamp(NumberUtil.parse(value, this.value), 1, 999))
        },
      }
    }),
    components: new Array(Struct, [
      {
        name: "shroom-clear_use-clear-all-shrooms",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear all shrooms",
            enable: { key: "shroom-clear_use-clear-all-shrooms" },
          },
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-clear_use-clear-all-shrooms" },
          },
        },
      },
      {
        name: "shroom-clear_use-clear-amount",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Clear amount",
            enable: { key: "shroom-clear_use-clear-amount" },
          },  
          checkbox: { 
            spriteOn: { name: "visu_texture_checkbox_on" },
            spriteOff: { name: "visu_texture_checkbox_off" },
            store: { key: "shroom-clear_use-clear-amount" },
          },
        },
      },
      {
        name: "shroom-clear_clear-amount",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: "Amount",
            enable: { key: "shroom-clear_use-clear-amount" },
          },  
          field: { 
            store: { key: "shroom-clear_clear-amount" },
            enable: { key: "shroom-clear_use-clear-amount" },
            GMTF_DECIMAL: 0,
          },
        },
      },
    ]),
  }
}