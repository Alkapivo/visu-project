//@package io.alkapivo.visu.editor

///@static
///@type {Struct}
global.__VETheme = {
  color: {
    primary: "#464646",
    primaryShadow: "#333333",
    dark: "#282828",
    darkShadow: "#131313",
    accent: "#436995",
    accentShadow: "#3A587B",
    text: "#D9D9D9",
    textShadow: "#9B9B9B",
    textFocus: "#FFFFFF",
    textSelected: "#B2DBE3",
    accept: "#469E59",
    acceptShadow: "#468a55",
    deny: "#A84545",
    denyShadow: "#823d3d",
    ruler: "#E64B3D",
  }
}
#macro VETheme global.__VETheme


///@static
///@type {Map<String, Struct>}
global.__VEStyles = new Map(String, Struct, {
  "visu-modal": {
    message: {
      color: VETheme.color.textFocus,
      font: "font_inter_10_regular",
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
    },
    accept: {
      backgroundColor: VETheme.color.acceptShadow,
      label: {
        color: VETheme.color.textFocus,
        font: "font_inter_10_regular",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      }
    },
    deny: {
      backgroundColor: VETheme.color.denyShadow,
      label: {
        color: VETheme.color.textFocus,
        font: "font_inter_10_regular",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      }
    },
  },
  "ve-title-bar": {
    menu: {
      backgroundColorSelected: VETheme.color.accent,
      backgroundColorOut: VETheme.color.primary,  
      backgroundColor: VETheme.color.primary,  
      label: {
        font: "font_inter_10_regular",
        color: VETheme.color.text,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      }
    },
    version: {
      font: "font_inter_10_regular",
      color: VETheme.color.text,
      outline: true,
      outlineColor: VETheme.color.darkShadow,
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
    },
    checkbox: {}
  },
  "ve-status-bar": {
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
    },
    value: {
      font: "font_inter_10_regular",
      color: VETheme.color.textFocus,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
    }
  },
  "ve-track-control": {
    slider: {},
    button: {},
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textFocus,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
    },
  },
  "bar-title": {
    align: { v: VAlign.CENTER, h: HAlign.LEFT },
    font: "font_inter_10_regular",
    color: VETheme.color.textShadow,
    margin: { left: 4 },
  },
  "bar-button": {
    backgroundColor: "#000000",
    label: {
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
    }
  },
  "category-button": {
    label: {
      backgroundColorSelected: VETheme.color.accent,
      backgroundColor: VETheme.color.dark,
      font: "font_inter_8_regular",
      color: VETheme.color.textFocus,
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
    },
  },
  "channel-entry": {
    label: {
      backgroundColor: VETheme.color.primaryShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      offset: { x: -5 },
    },
    remove: {
      backgroundColor: VETheme.color.primary,
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
      }
    },
    mute: {
      backgroundColor: VETheme.color.primaryShadow,
    },
  },
  "brush-entry": {
    image: {},
    label: {
      backgroundColor: VETheme.color.primaryShadow,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      offset: { x: 4 },
    },
    remove: {
      backgroundColor: VETheme.color.primaryShadow,
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
      }
    },
  },
  "template-entry": {
    label: {
      backgroundColor: VETheme.color.primaryShadow,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      offset: { x: 4 },
    },
    remove: {
      backgroundColor: VETheme.color.primaryShadow,
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
      }
    }
  },
  "property": {
    checkbox: {
      backgroundColor: VETheme.color.primaryShadow,
    },
    label: {
      backgroundColor: VETheme.color.primaryShadow,
      font: "font_inter_10_regular",
      color: VETheme.color.textFocus,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
    },
    input: {
      backgroundColor: VETheme.color.primaryShadow,
    },
  },
  "property-bar": {
    checkbox: {
      backgroundColor: VETheme.color.accentShadow,
    },
    label: {
      backgroundColor: VETheme.color.accentShadow,
      font: "font_inter_10_regular",
      color: VETheme.color.textFocus,
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
    },
    input: {
      backgroundColor: VETheme.color.accentShadow,
    },
  },
  "text-field": { 
    font: "font_inter_10_regular",
    colorBackgroundUnfocused: VETheme.color.primaryShadow,
    colorBackgroundFocused: VETheme.color.accentShadow,
    colorTextUnfocused: VETheme.color.textShadow,
    colorTextFocused: VETheme.color.textFocus,
    colorSelection: VETheme.color.textSelected,
    lh: 20,
    padding: { top: 0, bottom: 0, left: 4, right: 0 }
  },
  "text-field-button": { 
    font: "font_inter_10_regular",
    colorBackgroundUnfocused: VETheme.color.primaryShadow,
    colorBackgroundFocused: VETheme.color.accentShadow,
    colorTextUnfocused: VETheme.color.textShadow,
    colorTextFocused: VETheme.color.textFocus,
    colorSelection: VETheme.color.textSelected,
    lh: 20,
    padding: { top: 0, bottom: 0, left: 4, right: 0 },
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
    },
    field: {
      font: "font_inter_10_regular",
      colorBackgroundUnfocused: VETheme.color.primaryShadow,
      colorBackgroundFocused: VETheme.color.accentShadow,
      colorTextUnfocused: VETheme.color.textShadow,
      colorTextFocused: VETheme.color.textFocus,
      colorSelection: VETheme.color.textSelected,
      lh: 20,
      padding: { top: 0, bottom: 0, left: 4, right: 0 },
    },
    button: {
      label: {
        font: "font_inter_8_regular",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
      backgroundColor: VETheme.color.accentShadow,
    },
  },
  "text-field-checkbox": { 
    font: "font_inter_10_regular",
    colorBackgroundUnfocused: VETheme.color.primaryShadow,
    colorBackgroundFocused: VETheme.color.accentShadow,
    colorTextUnfocused: VETheme.color.textShadow,
    colorTextFocused: VETheme.color.textFocus,
    colorSelection: VETheme.color.textSelected,
    lh: 20,
    padding: { top: 0, bottom: 0, left: 4, right: 0 },
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
    },
    field: {
      font: "font_inter_10_regular",
      colorBackgroundUnfocused: VETheme.color.primaryShadow,
      colorBackgroundFocused: VETheme.color.accentShadow,
      colorTextUnfocused: VETheme.color.textShadow,
      colorTextFocused: VETheme.color.textFocus,
      colorSelection: VETheme.color.textSelected,
      lh: 20,
      padding: { top: 0, bottom: 0, left: 4, right: 0 },
    },
    checkbox: { }
  },
  "text-field-button-checkbox": { 
    font: "font_inter_10_regular",
    colorBackgroundUnfocused: VETheme.color.primaryShadow,
    colorBackgroundFocused: VETheme.color.accentShadow,
    colorTextUnfocused: VETheme.color.textShadow,
    colorTextFocused: VETheme.color.textFocus,
    colorSelection: VETheme.color.textSelected,
    lh: 20,
    padding: { top: 0, bottom: 0, left: 4, right: 0 },
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
    },
    field: {
      font: "font_inter_10_regular",
      colorBackgroundUnfocused: VETheme.color.primaryShadow,
      colorBackgroundFocused: VETheme.color.accentShadow,
      colorTextUnfocused: VETheme.color.textShadow,
      colorTextFocused: VETheme.color.textFocus,
      colorSelection: VETheme.color.textSelected,
      lh: 20,
      padding: { top: 0, bottom: 0, left: 4, right: 0 },
    },
    button: {
      label: {
        font: "font_inter_10_regular",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
      backgroundColor: VETheme.color.accentShadow,
    },
    checkbox: { }
  },
  "text-field_label": {
    font: "font_inter_10_regular",
    color: VETheme.color.textShadow,
    align: { v: VAlign.CENTER, h: HAlign.RIGHT },
  },
  "text-area": { 
    font: "font_consolas_10_regular",
    colorBackgroundUnfocused: VETheme.color.primaryShadow,
    colorBackgroundFocused: VETheme.color.accentShadow,
    colorTextUnfocused: VETheme.color.textShadow,
    colorTextFocused: VETheme.color.textFocus,
    colorSelection: VETheme.color.textSelected,
    lh: 20,
    padding: { top: 0, bottom: 0, left: 4, right: 0 }
  },
  "slider-horizontal": {},
  "spin-select": {
    previous: {
      sprite: { name: "texture_button_previous" }
    },
    next: {
      sprite: { name: "texture_button_next" }
    },
  },
  "spin-select-image": {
    preview: {
      image: { name: "texture_button" },
      store: {
        callback: function(value, data) { 
          var image = SpriteUtil.parse({ name: value })
          if (!Core.isType(image, Sprite)) {
            return
          }
          Struct.set(data, "image", image)
        },
      }
    },
  },
  "spin-select-label": {
    preview: {
      label: { 
        text: "",
        color: VETheme.color.textFocus,
        font: "font_inter_10_regular",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
      store: { 
        callback: function(value, data) {
          data.label.text = value
        },
      },
    },
  },
  "spin-select-label_no-store": {
    preview: {
      label: { 
        text: "",
        color: VETheme.color.textFocus,
        font: "font_inter_10_regular",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
    },
  },
  "transform-numeric-uniform": {
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
    }
  },
  "transform-vec2-uniform": {
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
    }
  },
  "transform-vec3-uniform": {
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
    }
  },
  "transform-vec4-uniform": {
    label: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
    }
  },
  "texture-field-ext": {
    resolution: {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
    }
  }
})
#macro VEStyles global.__VEStyles
