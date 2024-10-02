///@package io.alkapivo.visu.ui

///@type {Map<String, Callable>}
global.__VisuStyles = new Map(String, Callable, {
  "menu-title": {
    label: {
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
      font: "font_kodeo_mono_28_bold",
      color: "#ffffff",
      enableColorWrite: false,
    },
  },
  "menu-button-entry": {
    label: {
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_kodeo_mono_18_bold",
      color: "#ffffff",
      offset: { x: 12 },
      enableColorWrite: false,
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      //backgroundColor: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
  },
  "menu-button-input-entry": {
    label: {
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_kodeo_mono_18_bold",
      color: "#ffffff",
      offset: { x: 12 },
      enableColorWrite: false,
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      //backgroundColor: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
    input: {
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_kodeo_mono_18_bold",
        color: "#ffffff",
        enableColorWrite: false,
        colorHoverOver: VETheme.color.accentShadow,
        colorHoverOut: VETheme.color.dark,
        //backgroundColor: VETheme.color.dark,
        backgroundAlpha: 0.75,
      },
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      //backgroundColor: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
  },
  "menu-spin-select-entry": {
    label: {
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_kodeo_mono_18_bold",
      color: "#ffffff",
      offset: { x: 12 },
      enableColorWrite: false,
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
    previous: {
      sprite: { name: "texture_menu_button_previous" },
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
    preview: {
      label: {
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_kodeo_mono_18_bold",
        color: "#ffffff",
        enableColorWrite: false,
      },
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
    next: {
      sprite: { name: "texture_menu_button_next"  },
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
  },
  "menu-keyboard-key-entry": {
    label: {
      align: { v: VAlign.CENTER, h: HAlign.LEFT },
      font: "font_kodeo_mono_18_bold",
      color: "#ffffff",
      offset: { x: 12 },
      enableColorWrite: false,
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    },
    preview: {
      align: { v: VAlign.CENTER, h: HAlign.CENTER },
      font: "font_kodeo_mono_18_bold",
      color: "#ffffff",
      enableColorWrite: false,
      colorHoverOver: VETheme.color.accentShadow,
      colorHoverOut: VETheme.color.dark,
      backgroundAlpha: 0.75,
    }
  },
})
#macro VisuStyles global.__VisuStyles