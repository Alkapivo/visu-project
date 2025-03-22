///@package io.alkapivo.visu.ui

///@type {Number}
#macro VISU_MENU_ENTRY_HEIGHT 68

///@type {Map<String, Callable>}
global.__VisuLayouts = new Map(String, Callable, {

  ///@param {?Struct} [config]
  ///@return {Struct}
  "menu-title": function(config = null) {
    return {
      name: "visu-menu.title",
      nodes: {
        label: {
          name: "visu-menu.title.label",
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "menu-button-entry": function(config = null) {
    return {
      name: "visu-menu.content.entry",
      type: Core.isEnum(Struct.get(config, "type"), UILayoutType)
        ? config.type
        : UILayoutType.VERTICAL,
      collection: true,
      x: function() { return 0 },
      y: function() { return this.collection.getIndex() * this.height() },
      width: function() { return this.context.width() },
      height: function() { return VISU_MENU_ENTRY_HEIGHT },
      nodes: {
        label: {
          name: "visu-menu.content.entry.label",
          width: function() { return this.context.width() },
          height: function() { return this.context.height() },
          x: function() { return this.context.x() },
          y: function() { return this.context.y() },
        }
      }
    }
  },

  "menu-button-input-entry": function(config = null) {
    return {
      name: "menu-button-input-entry",
      type: Core.isEnum(Struct.get(config, "type"), UILayoutType)
        ? config.type
        : UILayoutType.VERTICAL,
      collection: true,
      x: function() { return 0 },
      y: function() { return this.collection.getIndex() * this.height() },
      width: function() { return this.context.width() },
      height: function() { return VISU_MENU_ENTRY_HEIGHT },
      nodes: {
        label: {
          name: "menu-button-input-entry.label",
          width: function() { return this.context.width() * 0.66 },
          height: function() { return this.context.height() },
          x: function() { return this.context.x() },
          y: function() { return this.context.y() },
        },
        input: {
          name: "menu-button-input-entry.input",
          width: function() { return this.context.width() * 0.33 },
          height: function() { return this.context.height() },
          x: function() { return this.context.nodes.label.right() },
          y: function() { return this.context.y() },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "menu-spin-select-entry": function(config = null) {
    return {
      name: "menu-spin-select-entry",
      type: Core.isEnum(Struct.get(config, "type"), UILayoutType)
        ? config.type
        : UILayoutType.VERTICAL,
      collection: true,
      x: function() { return 0 },
      y: function() { return this.collection.getIndex() * this.height() },
      width: function() { return this.context.width() },
      height: function() { return VISU_MENU_ENTRY_HEIGHT },
      nodes: {
        label: {
          name: "menu-spin-select.label",
          x: function() { return this.context.x() },
          y: function() { return this.context.y() },
          width: function() { return this.context.width() * 0.66 },
        },
        previous: {
          name: "menu-spin-select.previous",
          x: function() { return this.context.nodes.label.right() },
          y: function() { return this.context.y() },
          width: function() { return VISU_MENU_ENTRY_HEIGHT * 0.5 },
        },
        preview: {
          name: "menu-spin-select.preview",
          x: function() { return this.context.nodes.previous.right() },
          y: function() { return this.context.y() },
          width: function() { return (this.context.width() * 0.33)
            - this.context.nodes.previous.width()
            - this.context.nodes.next.width() },
        },
        next: {
          name: "menu-spin-spin-select.next",
          x: function() { return this.context.nodes.preview.right() },
          y: function() { return this.context.y() },
          width: function() { return VISU_MENU_ENTRY_HEIGHT * 0.5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "menu-keyboard-key-entry": function(config = null) {
    return {
      name: "menu-keyboard-key-entry",
      type: Core.isEnum(Struct.get(config, "type"), UILayoutType)
        ? config.type
        : UILayoutType.VERTICAL,
      collection: true,
      x: function() { return 0 },
      y: function() { return this.collection.getIndex() * this.height() },
      width: function() { return this.context.width() },
      height: function() { return VISU_MENU_ENTRY_HEIGHT },
      nodes: {
        label: {
          name: "menu-keyboard-key-entry.label",
          x: function() { return this.context.x() },
          y: function() { return this.context.y() },
          width: function() { return this.context.width() / 2.0 },
        },
        preview: {
          name: "menu-keyboard-key-entry.preview",
          x: function() { return this.context.x() + this.width() },
          y: function() { return this.context.y() },
          width: function() { return this.context.width() / 2.0 },
        },
      }
    }
  },
})
#macro VisuLayouts global.__VisuLayouts