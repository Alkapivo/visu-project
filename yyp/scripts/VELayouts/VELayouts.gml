///@package io.alkapivo.visu.editor.ui

///@static
///@type {Map<String, Callable>}
global.__VELayouts = new Map(String, Callable, {

  ///@param {?Struct} [config]
  ///@return {Struct}
  "texture-field-intent": function(config = null) {
    return {
      name: "texture-field-intent",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.resolution.bottom() - this.y() },
      nodes: {
        image: {
          name: "texture-field.image",
          y: function() { return this.context.y() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 8, bottom: 0, left: 4, right: 4 },
        },
        resolution: {
          name: "texture-field.resolution",
          y: function() { return this.context.nodes.image.bottom() + this.margin.top },
          height: function() { return 24 },
        },
      },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "vertical-item": function(config = null) {
    return {
      name: "vertical-item",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.VERTICAL), UILayoutType),
      collection: true,
      height: function() { return (this.context.height() - this.margin.top - this.margin.bottom) / this.collection.getSize() },
      x: function() { return this.margin.left },
      y: function() { return this.margin.top + this.collection.getIndex() * this.height() },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "horizontal-item": function(config = null) {
    return {
      name: "horizontal-item",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.HORIZONTAL), UILayoutType),
      collection: true,
      width: function() { return (this.context.width() - this.margin.top - this.margin.bottom) / this.collection.getSize() },
      x: function() { return this.margin.right + this.collection.getIndex() * this.width() },
      y: function() { return this.margin.top },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "channel-entry": function(config = null) {
    return {
      name: "channel-entry",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.VERTICAL), UILayoutType),
      collection: true,
      x: function() { return this.margin.left },
      y: function() { return this.margin.top + this.collection.getIndex() * this.height() },
      height: function() { return 32 },
      nodes: {
        settings: {
          name: "channel-entry.settings",
          width: function() { return 34 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 0, left: 2, right: 2, bottom: 2 },
        },
        remove: {
          name: "channel-entry.remove",
          width: function() { return 32 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          x: function() { return this.context.nodes.settings.right() },
          margin: { top: 0, left: 0, right: 2, bottom: 2 },
        },
        label: {
          name: "channel-entry.label",
          width: function() { return this.context.width() 
            - this.context.nodes.settings.width()
            - this.context.nodes.settings.margin.left
            - this.context.nodes.settings.margin.right
            - this.context.nodes.remove.width()
            - this.context.nodes.remove.margin.left
            - this.context.nodes.remove.margin.right
            - this.context.nodes.mute.width()
            - this.context.nodes.mute.margin.left
            - this.context.nodes.mute.margin.right },
          height: function() { return 30 },
          x: function() { return this.context.nodes.remove.right() },
        },
        mute: {
          name: "channel-entry.mute",
          width: function() { return 32 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 0, left: 2, right: 0, bottom: 2 },
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          y: function() { return this.context.y() + this.margin.top },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "brush-entry": function(config = null) {
    return {
      name: "brush-entry",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.VERTICAL), UILayoutType),
      collection: true,
      x: function() { return this.margin.left },
      y: function() { return this.margin.top + this.collection.getIndex() * this.height() },
      height: function() { return 32 },
      nodes: {
        image: {
          name: "brush-entry.image",
          width: function() { return this.context.height() },
          height: function() { return this.context.height() },
          x: function() { return this.context.x() + this.margin.right },
          y: function() { return this.context.y() + this.margin.top },
        },
        label: {
          name: "brush-entry.label",
          width: function() { return this.context.width() 
            - this.context.nodes.image.width()
            - this.context.nodes.image.margin.left
            - this.context.nodes.image.margin.right
            - this.context.nodes.remove.width()
            - this.context.nodes.remove.margin.left
            - this.context.nodes.remove.margin.right 
            - this.context.nodes.settings.width()
            - this.context.nodes.settings.margin.left
            - this.context.nodes.settings.margin.right },
          height: function() { return 30 },
          x: function() { return this.context.x() + this.context.nodes.image.right() + 2 },
        },
        remove: {
          name: "brush-entry.remove",
          width: function() { return 34 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 0, left: 2, right: 2, bottom: 2 },
          x: function() { return this.context.x() + this.context.nodes.label.right()
            + this.margin.right },
          y: function() { return this.context.y() + this.margin.top },
        },
        settings: {
          name: "brush-entry.settings",
          width: function() { return 32 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 0, left: 0, right: 2, bottom: 2 },
          x: function() { return this.context.x() + this.context.nodes.remove.right()
            + this.margin.right - 2 },
          y: function() { return this.context.y() + this.margin.top },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "template-entry": function(config = null) {
    return {
      name: "template-entry",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.VERTICAL), UILayoutType),
      collection: true,
      x: function() { return this.margin.left },
      y: function() { return this.margin.top + this.collection.getIndex() * this.height() },
      height: function() { return 32 },
      nodes: {
        settings: {
          name: "template-entry.settings",
          width: function() { return 34 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 0, left: 2, right: 2, bottom: 2 },
        },
        remove: {
          name: "template-entry.remove",
          width: function() { return 32 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          x: function() { return this.context.nodes.settings.right() },
          margin: { top: 0, left: 0, right: 2, bottom: 2 },
        },
        label: {
          name: "template-entry.label",
          width: function() { return this.context.width() 
            - this.context.nodes.settings.width()
            - this.context.nodes.settings.margin.left
            - this.context.nodes.settings.margin.right
            - this.context.nodes.remove.width()
            - this.context.nodes.remove.margin.left
            - this.context.nodes.remove.margin.right },
          height: function() { return 30 },
          x: function() { return this.context.nodes.remove.right() },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "property": function(config = null) {
    return {
      name: "property",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 26 - this.margin.top - this.margin.bottom },
      margin: { top: 1, bottom: 1 },
      nodes: {
        checkbox: {
          name: "property.checkbox",
          width: function() { return 24 },
          margin: { left: 5, right: 2 },
        },
        label: {
          name: "property.label",
          x: function() { return this.context.nodes.checkbox.right() },
          width: function() { return this.context.width() 
            - this.context.nodes.checkbox.width()
            - this.context.nodes.checkbox.margin.right
            - this.context.nodes.input.width() 
            - this.context.nodes.input.margin.right 
            - this.context.nodes.input.margin.left },
        },
        input: {
          name: "property.input",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 42 },
          margin: { left: 0, right: 7 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "label": function(config = null) {
    return {
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      width: Struct.getIfType(config, "width", Callable),// function() { return 72 }),
      height: Struct.getIfType(config, "height", Callable),// function() { return 24 }),
      nodes: {
        label: {
          width: function() { return this.context.width() - this.margin.left - this.margin.right },
          height: function() { return this.context.height() - this.margin.top - this.margin.bottom },
          margin: Struct.get(config, "margin"),
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "checkbox": function(config = null) {
    return {
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      width: Struct.getIfType(config, "width", Callable),//, function() { return 24 }),
      height: Struct.getIfType(config, "height", Callable),//, function() { return 24 }),
      nodes: {
        checkbox: {
          x: function() {
            this.margin.left = round((this.context.width() - 24) / 2)
            this.margin.right = this.margin.left
            return this.context.x() + this.margin.left
          },
          y: function() {
            this.margin.top = round((this.context.height() - 24) / 2)
            this.margin.bottom = this.margin.top
            return this.context.y() + this.margin.top
          },
          width: function() {
            this.margin.left = round((this.context.width() - 24) / 2)
            this.margin.right = this.margin.left
            return 24
          },
          height: function() {
            this.margin.top = round((this.context.height() - 24) / 2)
            this.margin.bottom = this.margin.top
            return 24
          },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-simple": function(config = null) {
    return {
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      width: Struct.getIfType(config, "width", Callable),// function() { return 72 }),
      height: Struct.getIfType(config, "height", Callable),// function() { return 24 }),
      nodes: {
        field: {
          y: function() {
            this.margin.top = round((this.context.height() - 24) / 2)
            this.margin.bottom = this.margin.top
            return this.context.y() + this.margin.top
          },
          height: function() {
            this.margin.top = round((this.context.height() - 24) / 2)
            this.margin.bottom = this.margin.top
            return 24
          },
          width: function() { return this.context.width() - this.margin.left - this.margin.right },
          margin: Struct.get(config, "margin"),
        },
      }
    }
  },


    ///@param {?Struct} [config]
  ///@return {Struct}
  "property-bar": function(config = null) {
    return {
      name: "property-bar",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: Struct.getIfType(config, "height", Callable, function() { return 28 - this.margin.top - this.margin.bottom }),
      margin: Struct.getIfType(config, "margin", Struct, { top: 0, bottom: 4 }),
      nodes: {
        checkbox: {
          name: "property-bar.checkbox",
          width: function() { return 42 },
        },
        label: {
          name: "property-bar.label",
          x: function() { return this.context.nodes.checkbox.right() },
          width: function() { return this.context.width() 
            - this.context.nodes.checkbox.width()
            - this.context.nodes.input.width() },
        },
        input: {
          name: "property-bar.input",
          x: function() { return this.context.nodes.label.right() },
          width: function() { return 42 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "line-h": function(config = null) {
    return {
      name: "line-h",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 1 },
      margin: Struct.getIfType(config, "margin", Struct, { top: 4, bottom: 4 }),
      nodes: {
        image: {
          name: "line-h.image",
          margin: { left: 5, right: 5 },
          height: function() { return this.context.height() },
        },
      },
    }
  },

  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "line-w": function(config = null) {
    return {
      name: "line-h",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      width: function() { return 1 },
      margin: { left: 4, right: 3 },
      nodes: {
        image: {
          name: "line-h.image",
          margin: { top: 3, bottom: 3 },
          width: function() { return this.context.width() },
        },
      },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "button": function(config = null) {
    return {
      name: "button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: Struct.getIfType(config, "height", Callable, function() { return 28 - this.margin.top - this.margin.bottom }),
      margin: Struct.get(config, "margin"),
      nodes: {
        button: {
          name: "button.button",
          height: function() { return this.context.height() },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "bar-title": function(config = null) {
    return {
      name: "bar-title",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: Struct.getIfType(config, "height", Callable, function() { return 16 }),
      margin: Struct.getIfType(config, "margin", Struct, { top: 1 }),
      nodes: {
        label: {
          name: "bar-title.label",
          height: function() { return this.context.height() },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "template-add-button": function(config = null) {
    return {
      name: "template-add-button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: Struct.getIfType(config, "height", Callable, function() { return 30 - this.margin.top - this.margin.bottom }),
      margin: Struct.getIfType(config, "margin", Struct, { top: 2 }),
      nodes: {
        button: {
          name: "template-add-button.button",
          height: function() { return this.context.height() },
        },
      }
      
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "text": function(config = null) {
    return {
      name: "text",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      margin: Struct.getIfType(config, "margin", Struct),
      store: { height: 96 },
      height: function() { return this.store.height },
      nodes: { label: { name: "label"} },
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field": function(config = null) {
    return {
      name: "text-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: Struct.getIfType(config, "height", Callable, function() { return 28 }),
      margin: Struct.get(config, "margin"),
      nodes: {
        label: {
          name: "text-field.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.label.right()
            - this.margin.left - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 5 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-area": function(config = null) {
    return {
      name: "text-area",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      _height: 28,
      height: function() { return this._height },
      nodes: {
        field: {
          name: "text-area.field",
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 5 },
          setHeight: new BindIntent(function(height) {
            this.context._height = height + this.margin.top + this.margin.bottom
          }),
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-button": function(config = null) {
    return {
      name: "text-field-button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-button.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-button.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() 
            - this.context.nodes.label.right()
            - this.context.nodes.button.width()
            - this.context.nodes.button.margin.left
            - this.context.nodes.button.margin.right
            - this.margin.left - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 1 },
        },
        button: {
          name: "text-field-button.button",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return 48 },
          margin: { top: 2, bottom: 2, left: 1, right: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-button-channel": function(config = null) {
    return {
      name: "text-field-button-channel",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-button-channel.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-button-channel.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() 
            - this.context.nodes.label.right()
            - this.context.nodes.button.width()
            - this.context.nodes.button.margin.right
            - this.margin.left - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 1 },
        },
        button: {
          name: "text-field-button-channel.button",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return 48 },
          margin: { top: 1, bottom: 2, left: 1, right: 1 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-square-center-button": function(config = null) {
    return {
      name: "text-field-color",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-color.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-color.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 5 },
        },
        button: {
          name: "text-field-color.button",
          //x: function() {
          //  var _x = this.context.nodes.field.right()
          //  return _x + ((this.context.width() - this.width() - _x) / 2.0)
          //},
          //width: function() { return this.height() },
          //margin: { top: 2, bottom: 2 },
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 4, bottom: 5, right: 16, left: 12 },
        },
      }
    }
  },

///@param {?Struct} [config]
  ///@return {Struct}
  "double-checkbox": function(config = null) {
    return {
      name: "double-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      margin: Struct.getIfType(config, "margin", Struct),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "double-checkbox.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        checkbox1: {
          name: "double-checkbox.checkbox1",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 24 },
          margin: { top: 2, bottom: 2, left: 2, right: 2 },
        },
        label1: {
          name: "double-checkbox.label1",
          x: function() { return this.context.nodes.checkbox1.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0) - this.context.nodes.checkbox1.width() - this.context.nodes.checkbox1.margin.left - this.context.nodes.checkbox1.margin.right - this.margin.right - this.margin.left },
          margin: { top: 2, bottom: 2, left: 2, right: 2 },
        },
        checkbox2: {
          name: "double-checkbox.checkbox2",
          x: function() { return this.context.nodes.label1.right() },
          width: function() { return 24 },
          margin: { top: 2, bottom: 2, left: 2, right: 2 },
        },
        label2: {
          name: "double-checkbox.label2",
          x: function() { return this.context.nodes.checkbox2.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0) - this.context.nodes.checkbox1.width() - this.context.nodes.checkbox1.margin.left - this.context.nodes.checkbox1.margin.right - this.margin.right - this.margin.left },
          margin: { top: 2, bottom: 2, left: 2, right: 2 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-increase-checkbox": function(config = null) {
    return {
      name: "text-field-increase-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-increase-checkbox.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-increase-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - 10 - 10 - 7 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "text-field-increase-checkbox.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "text-field-increase-checkbox.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        checkbox: {
          name: "text-field-increase-checkbox.checkbox",
          x: function() { return this.context.nodes.decrease.right() },
          width: function() { return 28 - this.margin.top - this.margin.bottom },
          margin: { top: 2, bottom: 2 },
        },
        title: {
          name: "text-field-increase-checkbox.title",
          x: function() { return this.context.nodes.checkbox.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.checkbox.right() - this.margin.left },
          margin: { top: 2, bottom: 2, left: 4 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-increase-stick-checkbox": function(config = null) {
    return {
      name: "text-field-increase-stick-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      margin: Struct.getIfType(config, "margin", Struct),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-increase-stick-checkbox.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-increase-stick-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - 10 - 10 - 7 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "text-field-increase-stick-checkbox.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "text-field-increase-stick-checkbox.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        stick: {
          name: "text-field-increase-stick-checkbox.stick",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return 14 },
          margin: { top: 0, bottom: 0, left: 5, right: 7 },
        },
        checkbox: {
          name: "text-field-increase-stick-checkbox.checkbox",
          x: function() { return this.context.nodes.stick.right() },
          width: function() { return 24 },
          height: function() { return 24 },
          margin: { top: 2, bottom: 2 },
        },
        title: {
          name: "text-field-increase-stick-checkbox.title",
          x: function() { return this.context.nodes.checkbox.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.checkbox.right() },
          margin: { top: 1, bottom: 1, left: 0 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "__text-field-increase-stick-checkbox": function(config = null) {
    return {
      name: "text-field-increase-stick-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      margin: Struct.getIfType(config, "margin", Struct),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-increase-stick-checkbox.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-increase-stick-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - 10 - 10 - 7 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "text-field-increase-stick-checkbox.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "text-field-increase-stick-checkbox.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        slider: {
          name: "text-field-increase-stick-checkbox.stick",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return 14 },
          margin: { top: 0, bottom: 0, left: 5, right: 7 },
        },
        checkbox: {
          name: "text-field-increase-stick-checkbox.checkbox",
          x: function() { return this.context.nodes.slider.right() },
          width: function() { return 24 },
          height: function() { return 24 },
          margin: { top: 2, bottom: 2 },
        },
        title: {
          name: "text-field-increase-stick-checkbox.title",
          x: function() { return this.context.nodes.checkbox.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.checkbox.right() },
          margin: { top: 1, bottom: 1, left: 0 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-increase-slider-checkbox": function(config = null) {
    return {
      name: "text-field-increase-slider-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "text-field-increase-slider-checkbox.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "text-field-increase-slider-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - 10 - 10 - 7 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "text-field-increase-slider-checkbox.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "text-field-increase-slider-checkbox.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        slider: {
          name: "text-field-increase-slider-checkbox.slider",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return 30 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5, right: 10 },
        },
        checkbox: {
          name: "text-field-increase-slider-checkbox.checkbox",
          x: function() { return this.context.nodes.slider.right() },
          width: function() { return 24 },
          margin: { top: 2, bottom: 2 },
        },
        title: {
          name: "text-field-increase-slider-checkbox.title",
          x: function() { return this.context.nodes.checkbox.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.checkbox.right() },
          margin: { top: 2, bottom: 2, left: 2 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "texture-field": function(config = null) {
    return {
      name: "texture-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.alpha.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field.title",
          height: function() { return 28 },
        },
        texture: {
          name: "texture-field.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 28 },
          margin: { top: 4 },
        },
        preview: {
          name: "texture-field.preview",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 8, bottom: 0, left: 4, right: 4 },
        },
        resolution: {
          name: "texture-field.resolution",
          y: function() { return this.context.nodes.preview.bottom() + this.margin.top },
          height: function() { return 24 },
        },
        frame: {
          name: "texture-field.frame",
          y: function() { return this.context.nodes.resolution.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        speed: {
          name: "texture-field.speed",
          y: function() { return this.context.nodes.frame.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        alpha: {
          name: "texture-field.alpha",
          y: function() { return this.context.nodes.speed.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "texture-field-simple": function(config = null) {
    return {
      name: "texture-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.speed.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field-simple.title",
          height: function() { return 28 },
        },
        texture: {
          name: "texture-field-simple.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        preview: {
          name: "texture-field-simple.preview",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 8, bottom: 0, left: 4, right: 4 },
        },
        resolution: {
          name: "texture-field-simple.resolution",
          y: function() { return this.context.nodes.preview.bottom() + this.margin.top },
          height: function() { return 24 },
        },
        frame: {
          name: "texture-field-simple.frame",
          y: function() { return this.context.nodes.resolution.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        speed: {
          name: "texture-field-simple.speed",
          y: function() { return this.context.nodes.frame.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "texture-field-ext": function(config = null) {
    return {
      name: "texture-field-ext",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.scaleY.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field-ext.title",
          height: function() { return 28 },
        },
        texture: {
          name: "texture-field-ext.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 28 },
          margin: { top: 4 },
        },
        preview: {
          name: "texture-field-ext.preview",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 8, bottom: 0, left: 4, right: 4 },
        },
        resolution: {
          name: "texture-field-ext.resolution",
          y: function() { return this.context.nodes.preview.bottom() + this.margin.top },
          height: function() { return 24 },
        },
        alpha: {
          name: "texture-field-ext.alpha",
          y: function() { return this.context.nodes.resolution.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        frame: {
          name: "texture-field-ext.frame",
          y: function() { return this.context.nodes.alpha.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        speed: {
          name: "texture-field-ext.speed",
          y: function() { return this.context.nodes.frame.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        scaleX: {
          name: "texture-field-ext.scaleX",
          y: function() { return this.context.nodes.speed.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        scaleY: {
          name: "texture-field-ext.scaleY",
          y: function() { return this.context.nodes.scaleX.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      },
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "preview-image-mask": function(config = null) {
    return {
      name: "preview-image-mask",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.resolution.bottom() - this.y() },
      nodes: {
        preview: {
          name: "preview-image-mask.preview",
          height: function() { return 144 },
          margin: { top: 8, bottom: 0, left: 4, right: 4 },
        },
        resolution: {
          name: "texture-field-ext.resolution",
          y: function() { return this.context.nodes.preview.bottom() + this.margin.top },
          height: function() { return 24 },
        },
      },
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-slider-field": function(config = null) {
    return {
      name: "numeric-slider-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "numeric-slider-field.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "numeric-slider-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 5 },
        },
        slider: {
          name: "numeric-slider-field.slider",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, right: 15, left: 10 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-slider-increase-field": function(config = null) {
    return {
      name: "numeric-slider-increase-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      margin: Struct.get(config, "margin"),
      nodes: {
        label: {
          name: "numeric-slider-increase-field.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "numeric-slider-increase-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - 10 - 10 - 7 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "numeric-slider-increase-field.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "numeric-slider-increase-field.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        slider: {
          name: "numeric-slider-increase-field.slider",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.decrease.right()
            - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, right: 15, left: 12 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-stick-increase-field": function(config = null) {
    return {
      name: "numeric-stick-increase-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "numeric-stick-increase-field.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "numeric-stick-increase-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.label.right()
            - 10 - 10 - 8 - 45 - this.margin.left - this.margin.right },
          margin: { top: 1.0000, bottom: 1.0000, left: 5, right: 2 },
        },
        increase: {
          name: "numeric-stick-increase-field.increase",
          x: function() { return this.context.nodes.field.right() },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 0, right: 0 },
        },
        decrease: {
          name: "numeric-stick-increase-field.decrease",
          x: function() { return this.context.nodes.increase.right() + this.margin.left },
          width: function() { return 10 },
          margin: { top: 1.0000, bottom: 1.0000, left: 2, right: 5 },
        },
        slider: {
          name: "numeric-stick-increase-field.slider",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return 45 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, right: 15, left: 10 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-slider": function(config = null) {
    return {
      name: "numeric-slider",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      margin: Struct.getIfType(config, "margin", Struct),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "numeric-slider.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 4, bottom: 4, left: 5 },
        },
        slider: {
          name: "numeric-slider.slider",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width()
            - this.margin.left 
            - this.margin.right 
            - this.context.nodes.label.width() 
            - this.context.nodes.label.margin.left
            - this.context.nodes.label.margin.right },
          margin: { top: 4, bottom: 4, right: 11, left: 13 },
        },
      }
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "color-picker": function(config = null) {
    return {
      name: "color-picker",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.blue.bottom() - this.y() },
      margin: Struct.getIfType(config, "margin", Struct),
      nodes: {
        line: {
          name: "color-picker.line",
          margin: { top: 4, bottom: 1, left: 5, right: 2 },
          height: function() { return 1 },
        },
        title: {
          name: "color-picker.title",
          y: function() { return this.context.nodes.line.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        hex: {
          name: "color-picker.hex",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 28 },
          margin: Struct.getIfType(Struct.get(config, "hex"), "margin", Struct, { top: 2 }),
        },
        red: {
          name: "color-picker.red",
          y: function() { return this.context.nodes.hex.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        green: {
          name: "color-picker.green",
          y: function() { return this.context.nodes.red.bottom() },
          height: function() { return 28 },
        },
        blue: {
          name: "color-picker.blue",
          y: function() { return this.context.nodes.green.bottom() },
          height: function() { return 28 },
        },
      }
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "color-picker-alpha": function(config = null) {
    var layout = Callable.run(VELayouts.get("color-picker"), config)

    Struct.set(layout, "height", function() { return this.nodes.alpha.bottom() - this.y() })
    Struct.set(layout.nodes, "alpha", {
      name: "color-picker.alpha",
      y: function() { return this.context.nodes.blue.bottom()  },
      height: function() { return 28 },
    })

    return layout
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "spin-select": function(config = null) {
    return {
      name: "spin-select",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      y: function() { return this.context.bottom() + this.margin.top },
      margin: Struct.getIfType(config, "margin", Struct, { top: 2 }),
      height: Struct.getIfType(config, "height", Callable, function() { return 28 }),
      nodes: {
        label: {
          name: "spin-select.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        previous: {
          name: "spin-select.previous",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          y: function() { return this.context.y() + round((this.context.height() - this.height()) / 2.0) },
          width: function() { return 16 },
          height: function() { return 16 },
          margin: { top: 0, bottom: 0, right: 0, left: 5 },
        },
        preview: {
          name: "spin-select.preview",
          x: function() { return this.context.nodes.label.right()
            + (this.context.width() - this.context.nodes.label.right()) / 2.0
            - (this.width() / 2.0) },
          width: function() { return this.context.width() - this.context.nodes.label.right() },
        },
        next: {
          name: "spin-select.next",
          x: function() { return this.context.x() + this.context.width()
            - this.width() - this.margin.right },
          y: function() { return this.context.y() + round((this.context.height() - this.height()) / 2.0) },
          width: function() { return 16 },
          height: function() { return 16 },
          margin: { top: 0, bottom: 0, right: 5, left: 0 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-numeric-uniform": function(config = null) {
    return {
      name: "transform-numeric-uniform",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.increment.bottom() - this.y() },
      margin: Struct.get(config, "margin"),
      nodes: {
        title: {
          name: "transform-numeric-uniform.title",
          height: function() { return 28 },
        },
        value: {
          name: "transform-numeric-uniform.value",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          margin: { top: 2 },
          height: function() { return 28 },
        },
        target: {
          name: "transform-numeric-uniform.target",
          y: function() { return this.context.nodes.value.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        factor: {
          name: "transform-numeric-uniform.factor",
          y: function() { return this.context.nodes.target.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        increase: {
          name: "transform-numeric-uniform.increase",
          y: function() { return this.context.nodes.factor.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-vec-property-uniform": function(config = null) {
    return {
      name: "transform-vec-property-uniform",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { 
        return this.nodes.line.y() + this.nodes.line.margin.bottom - this.nodes.title.y()
      },
      margin: Struct.get(config, "margin"),
      nodes: {
        title: {
          name: "transform-vec-property-uniform.title",
          height: function() { return 28 },
        },
        value: {
          name: "transform-vec-property-uniform.value",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        target: {
          name: "transform-vec-property-uniform.target",
          y: function() { return this.context.nodes.value.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        factor: {
          name: "transform-vec-property-uniform.factor",
          y: function() { return this.context.nodes.target.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        increase: {
          name: "transform-vec-property-uniform.increase",
          y: function() { return this.context.nodes.factor.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        line: {
          name: "transform-vec-property-uniform.line",
          y: function() { return this.context.nodes.increase.bottom() + this.margin.top },
          height: function() { return 1 },
          margin: { top: 4, bottom: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "vec4": function(config = null) {
    return {
      name: "vec4-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.a.bottom() - this.y() },
      margin: Struct.get(config, "margin"),
      nodes: {
        x: {
          name: "vec4-field.x",
          height: function() { return 28 },
        },
        y: {
          name: "vec4-field.y",
          y: function() { return this.context.nodes.x.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        z: {
          name: "vec4-field.z",
          y: function() { return this.context.nodes.y.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        a: {
          name: "vec4-field.a",
          y: function() { return this.context.nodes.z.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "number-transformer-increase-checkbox": function(config = null) {
    return {
      name: "number-transformer-increase-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.increase.bottom() - this.y() },
      margin: Struct.get(config, "margin"),
      nodes: {
        //title: {
        //  name: "transform-numeric-checkbox.title",
        //  height: function() { return 42 },
        //},
        value: {
          name: "transform-numeric-checkbox.value",
          //y: function() { return this.context.nodes.double.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        target: {
          name: "transform-numeric-checkbox.target",
          y: function() { return this.context.nodes.value.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        factor: {
          name: "transform-numeric-checkbox.factor",
          y: function() { return this.context.nodes.target.bottom() + this.margin.top },
          height: function() { return 28 },
        },
        increase: {
          name: "transform-numeric-checkbox.increase",
          y: function() { return this.context.nodes.factor.bottom() + this.margin.top },
          height: function() { return 28 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "div": function(config = null) {
    return {
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 0 },
      margin: Struct.getIfType(config, "margin", Struct),
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "boolean-field": function(config = null) {
    return {
      name: "boolean-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 28 },
      nodes: {
        label: {
          name: "boolean-fieldx.label",
          width: function() { return 72 - this.margin.left - this.margin.right },
          margin: { top: 2, bottom: 2, left: 5 },
        },
        field: {
          name: "boolean-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 24 },
          margin: { top: 2, bottom: 2, left: 4, right: 2 },
        },
      }
    }
  },

})
#macro VELayouts global.__VELayouts
