///@package io.alkapivo.visu.editor.ui

///@static
///@type {Struct}
global.__VETheme = {
  ///@param {String} name
  ///@return {String}
  getColor: function(name) {
    return Struct.getIfType(VETheme.color, name, String, "#000000")
  },
  colors: {
    layoutBkg: "sideDark",
    componentBkg: "sideShadow",
    button: "primary",
    buttonHover: "primaryLight",
    buttonText: "textShadow",
    bar: "sideDark",
    barButton: "sideDark",
    barButtonHover: "sideShadow",
    barText: "textShadow",
    propertyBkg: "primary",
    propertyText: "text",
    titleBkg: "accentShadow",
    titleText: "textFocus",
    snackbarBkg: "primary",
    snackbarText: "text",
    slider: "primary",
    sliderHover: "primaryLight",
    stick: "primary",
    stickHover: "primaryLight",
    modalButton: "primary",
    modalButtonHover: "primary",
    modalButtonText: "text",
    applyButton: "primary",
    applyButtonHover: "primary",
    applyButtonText: "text",
    discardButton: "primary",
    discardButtonHover: "primary",
    discardButtonText: "text",
    divider: "sideLight",
    spinSelectButton: "primary",
    spinSelectButtonHover: "primary",
    spinSelectText: "text",
    entryBkg: "primaryShadow",
    entryHover: "primary",
    entryText: "text",
    buttonToggle: "primary",
    buttonToggleSelected: "primaryAccent",
    buttonToggleHover: "primaryLight",
    buttonToggleText: "text",
    controlButton: "primary",
    controlButtonHover: "primary",
    controlButtonText: "primary",
    toolbarBkg: "primary",
    toolbarButton: "primary",
    toolbarButtonHover: "primary",
    toolbarButtonText: "primary",
    fieldLabel: "textShadow",
    field: "primary",
    fieldFocused: "accent",
    fieldTextSelected: "textSelected",
    fieldInvalid: "deny",
    resizeBar: "primary",
    scrollbar: "primary",
    increaseButton: "primary",
    increaseButtonHover: "primaryLight",
    increaseButtonText: "text",
    decreaseButton: "primary",
    decreaseButtonHover: "primaryLight",
    decreaseButtonText: "text",
    tableRowBkg: "primary",
    tableRowBkgStripped: "primary",
    tableBkg: "primary",
    tableColumnDivider: "primary",
    tableColumnAccentDivider: "primary",
    tableRowDivider: "primary",
  },
  color: {
    accentLight: "#7742b8",
    accent: "#5f398e",
    accentShadow: "#462f63",
    accentDark: "#231832",
    primaryLight: "#455f82",
    primary: "#3B3B53",
    primaryShadow: "#2B2B35",
    primaryDark: "#222227",
    sideLight: "#212129",
    side: "#1B1B20",
    sideShadow: "#141418",
    sideDark: "#0D0D0F",
    button: "#3B3B53",
    buttonHover: "#3c4e66",
    text: "#D9D9D9",
    textShadow: "#878787",
    textFocus: "#ededed",
    textSelected: "#7742b8",
    accept: "#3d9e87",
    acceptShadow: "#368b77",
    deny: "#9e3d54",
    denyShadow: "#6d3c54",
    ruler: "#E64B3D",
    header: "#963271",
    stick: "#5f398e",
    stickHover: "#7742b8",
    stickBackground: "#0D0D0F",
  },
}
#macro VETheme global.__VETheme


///@return {Map<String, Struct>}
function generateVEStyles() {
  return new Map(String, Struct, {
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
    "label": { 
      label: {
        font: "font_inter_10_regular",
        offset: { y: 1 },
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      },
    },
    "ve-title-bar": {
      menu: {
        backgroundColorSelected: VETheme.color.primaryLight,
        backgroundColorOut: VETheme.color.sideDark,
        backgroundColor: VETheme.color.sideDark,
        label: {
          font: "font_inter_10_bold",
          color: VETheme.color.textShadow,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        }
      },
      version: {
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
        outline: true,
        outlineColor: VETheme.color.primaryDark,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
      checkbox: {
        backgroundColorSelected: VETheme.color.primaryLight,
        backgroundColorOut: VETheme.color.sideDark,
        backgroundColor: VETheme.color.sideDark,
      }
    },
    "ve-status-bar": {
      label: {
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.RIGHT },
      },
      value: {
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      },
    },
    "ve-track-control": {
      slider: {},
      button: {},
      label: {
        font: "font_inter_10_bold",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      },
    },
    "bar-title": {
      backgroundColor: VETheme.color.sideDark,
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_inter_8_bold",
      color: VETheme.color.textShadow,
      offset: { x: 4 },
    },
    "bar-button": {
      backgroundColor: VETheme.color.sideDark,
      colorHoverOver: VETheme.color.primaryShadow,
      colorHoverOut: VETheme.color.sideDark,
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
      }
    },
    "text": {
      label: {
        align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
        font: "font_consolas_10_bold",
        color: VETheme.color.textFocus,
        outline: true,
        outlineColor: VETheme.color.accent,
      },
    },
    "checkbox": {
      spriteOn: { name: "visu_texture_checkbox_on" },
      spriteOff: { name: "visu_texture_checkbox_off" },
    },
    "category-button": {
      backgroundColorSelected: VETheme.color.accentShadow,
      backgroundColor: VETheme.color.primaryDark,
      backgroundColorHover: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
      backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
      backgroundColorOff: ColorUtil.fromHex(VETheme.color.primaryShadow).toGMColor(),
      colorHoverOver: VETheme.color.primaryShadow,
      colorHoverOut: VETheme.color.primaryDark,
      label: {
        font: "font_inter_8_regular",
        color: VETheme.color.text,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
    },
    "type-button": {
      backgroundColorSelected: VETheme.color.accentShadow,
      backgroundColor: VETheme.color.primaryDark,
      backgroundColorHover: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
      backgroundColorOn: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
      backgroundColorOff: ColorUtil.fromHex(VETheme.color.primaryShadow).toGMColor(),
      colorHoverOver: VETheme.color.primaryShadow,
      colorHoverOut: VETheme.color.primaryDark,
      label: {
        font: "font_inter_8_regular",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
    },
    "template-add-button": {
      backgroundColor: VETheme.color.primaryDark,
      backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
      colorHoverOver: VETheme.color.primaryShadow,
      colorHoverOut: VETheme.color.primaryDark,
      label: {
        font: "font_inter_10_bold",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
    },
    "collection-button": {
      backgroundColor: VETheme.color.primaryDark,
      backgroundMargin: { top: 1, bottom: 1, left: 1, right: 1 },
      colorHoverOver: VETheme.color.primaryShadow,
      colorHoverOut: VETheme.color.primaryDark,
      label: {
        font: "font_inter_10_bold",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
    },
    "channel-entry": {
      label: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut:VETheme.color.primaryDark,
        align: { v: VAlign.CENTER, h: HAlign.RIGHT },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        offset: { x: -5 },
      },
      settings: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primary,
        colorHoverOut:VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          blend: VETheme.color.textShadow,
        },
      },
      remove: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.deny,
        colorHoverOut:VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          blend: VETheme.color.textShadow,
        },
      },
      mute: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primary,
        colorHoverOut:VETheme.color.primaryDark,
      },
    },
    "brush-entry": {
      image: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut: VETheme.color.primaryDark,
      },
      label: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut: VETheme.color.primaryDark,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        offset: { x: 4 },
      },
      remove: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.deny,
        colorHoverOut: VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          blend: VETheme.color.textShadow,
        },
      },
      settings: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primary,
        colorHoverOut: VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          blend: VETheme.color.textShadow,
        },
      },
    },
    "template-entry": {
      settings: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primary,
        colorHoverOut: VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          name: "texture_ve_icon_settings",
          blend: VETheme.color.textShadow,
        },
      },
      remove: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.deny,
        colorHoverOut: VETheme.color.primaryDark,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          name: "texture_ve_icon_trash",
          blend: VETheme.color.textShadow,
        },
      },
      label: {
        backgroundColor: VETheme.color.primaryDark,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut: VETheme.color.primaryDark,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        offset: { x: 4 },
      },
    },
    "template-entry-lock": {
      settings: {
        backgroundColor: VETheme.color.side,
        colorHoverOver: VETheme.color.primary,
        colorHoverOut: VETheme.color.side,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          name: "texture_ve_icon_settings",
          blend: VETheme.color.textShadow,
        },
      },
      remove: {
        backgroundColor: VETheme.color.side,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut: VETheme.color.side,
        label: {
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
          font: "font_inter_10_regular",
          color: VETheme.color.textShadow,
        },
        sprite: {
          name: "texture_ve_icon_lock",
          blend: VETheme.color.textShadow,
        },
      },
      label: {
        backgroundColor: VETheme.color.side,
        colorHoverOver: VETheme.color.primaryShadow,
        colorHoverOut: VETheme.color.side,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        offset: { x: 4 },
      },
    },
    "line-h": {
      image: {
        backgroundColor: VETheme.color.primaryShadow,
        backgroundAlpha: 1.0,
      },
    },
    "line-w": {
      image: {
        backgroundColor: VETheme.color.primaryShadow,
        backgroundAlpha: 1.0,
      },
    },
    "property": {
      checkbox: {
        backgroundColor: VETheme.color.primaryShadow,
        margin: { top: 1, bottom: 1, left: 1, right: 1 },
      },
      label: {
        backgroundColor: VETheme.color.primaryShadow,
        offset: { x: 8, y: 0 },
        font: "font_inter_10_bold",
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
        offset: { x: 4 },
        font: "font_inter_10_bold",
        color: VETheme.color.textFocus,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      },
      input: {
        backgroundColor: VETheme.color.accentShadow,
      },
    },
    "text-field": {
      field: {
        font: "font_inter_10_regular",
        colorBackgroundUnfocused: VETheme.color.primaryDark,
        colorBackgroundFocused: VETheme.color.primaryShadow,
        colorOutlineUnfocused: VETheme.color.primaryShadow,
        colorOutlineFocused: VETheme.color.primary,
        colorTextUnfocused: VETheme.color.textShadow,
        colorTextFocused: VETheme.color.textFocus,
        colorSelection: VETheme.color.textSelected,
        lh: 20.0000,
        padding: { top: 2, bottom: 0, left: 4, right: 4 },
      },
    },
    "text-field-simple": { 
      field: {
        font: "font_inter_10_regular",
        colorBackgroundUnfocused: VETheme.color.side,
        colorBackgroundFocused: VETheme.color.primaryShadow,
        colorOutlineUnfocused: VETheme.color.primaryShadow,
        colorOutlineFocused: VETheme.color.primary,
        colorTextUnfocused: VETheme.color.textShadow,
        colorTextFocused: VETheme.color.textFocus,
        colorSelection: VETheme.color.textSelected,
        lh: 20.0000,
        padding: { top: 2, bottom: 0, left: 4, right: 4 },
      },
    },
    "text-field-button": { 
      label: {
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.RIGHT },
      },
      field: {
        font: "font_inter_10_regular",
        colorBackgroundUnfocused: VETheme.color.primaryDark,
        colorBackgroundFocused: VETheme.color.primaryShadow,
        colorOutlineUnfocused: VETheme.color.primaryShadow,
        colorOutlineFocused: VETheme.color.primary,
        colorTextUnfocused: VETheme.color.textShadow,
        colorTextFocused: VETheme.color.textFocus,
        colorSelection: VETheme.color.textSelected,
        lh: 20.0000,
        padding: { top: 2, bottom: 0, left: 4, right: 4 },
      },
      button: {
        backgroundColor: VETheme.color.button,
        colorHoverOver: VETheme.color.buttonHover,
        colorHoverOut: VETheme.color.button,
        label: {
          font: "font_inter_8_regular",
          color: VETheme.color.textFocus,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        },
      },
    },
    "text-field-checkbox": { 
      title: {
        font: "font_inter_8_regular",
        color: VETheme.color.text,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      },
    },
    "text-field_label": {
      font: "font_inter_10_regular",
      color: VETheme.color.textShadow,
      align: { v: VAlign.CENTER, h: HAlign.RIGHT },
    },
    "text-area": { 
      field: {
        font: "font_consolas_10_regular",
        colorBackgroundUnfocused: VETheme.color.primaryDark,
        colorBackgroundFocused: VETheme.color.primaryShadow,
        colorOutlineUnfocused: VETheme.color.primaryShadow,
        colorOutlineFocused: VETheme.color.primary,
        colorOutlineUnfocused: VETheme.color.primaryShadow,
        colorOutlineFocused: VETheme.color.primary,
        colorTextUnfocused: VETheme.color.textShadow,
        colorTextFocused: VETheme.color.textFocus,
        colorSelection: VETheme.color.textSelected,
        lh: 20.0000,
        padding: { top: 2, bottom: 0, left: 4, right: 4 },
      }
    },
    "slider-horizontal": {
      pointer: {
        name: "texture_slider_pointer_simple",
        scaleX: 0.125,
        scaleY: 0.125,
        blend: VETheme.color.accent,
      },
      progress: {
        thickness: 0.9,
        blend: VETheme.color.primary,
        line: { name: "texture_grid_line_bold" },
      },
      background: {
        thickness: 1.1,
        blend: VETheme.color.sideShadow,
        line: { name: "texture_grid_line_bold" },
      },
    },
    "slider-horizontal-2": {
      pointer: {
        name: "texture_slider_pointer_simple",
        scaleX: 0.125,
        scaleY: 0.125,
        alpha: 0.9,
        blend: VETheme.color.accentLight,
      },
      progress: {
        thickness: 1.0,
        alpha: 1.0,
        blend: VETheme.color.accent,
        line: { name: "texture_grid_line_bold" },
      },
      background: {
        thickness: 0.75,
        alpha: 0.75,
        blend: VETheme.color.primary,
        line: { name: "texture_grid_line_bold" },
      },
    },
    "spin-select": {
      previous: {
        label: {
          font: "font_inter_10_bold",
          color: VETheme.color.textFocus,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        },
      },
      next: {
        label: {
          font: "font_inter_10_bold",        
          color: VETheme.color.textFocus,
          align: { v: VAlign.CENTER, h: HAlign.CENTER },
        },
      },
    },
    "spin-select-image": {
      preview: {
        image: { name: "texture_empty" },
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
          outline: true,
          outlineColor: VETheme.color.sideDark,
          font: "font_inter_8_bold",
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
    "transform-vec-uniform": {
      label: {
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
      }
    },
    "texture-field-ext": {
      resolution: {
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      }
    },
    "preview-image-mask": {
      resolution: {
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
      }
    },
    "double-checkbox": {
      label: {
        offset: { x: 0 },
        font: "font_inter_10_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.RIGHT },
      },
      checkbox1: { },
      label1: {
        offset: { x: 0 },
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      },
      checkbox2: { },
      label2: {
        offset: { x: 0 },
        font: "font_inter_8_regular",
        color: VETheme.color.textShadow,
        align: { v: VAlign.CENTER, h: HAlign.LEFT },
      }
    },
  })
}

///@static
///@type {Map<String, Struct>}
global.__VEStyles = generateVEStyles()
#macro VEStyles global.__VEStyles
