///@package io.alkapivo.visu.editor.ui

///@static
///@type {Map<String, Callable>}
global.__VELayouts = new Map(String, Callable, {

  "image": function(config = null) {
    return { 
      name: "image",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.VERTICAL), UILayoutType),
      height: function() { return this.width() * 0.5 },
      nodes: { 
        image: { 
          name: "image.image",
          width: function() { return this.context.width() 
            - this.margin.left 
            - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top 
            - this.margin.bottom },
          margin: { top: 5, bottom: 5 },
        },
        resolution: {
          name: "imate.resolution",
          y: function() { return this.context.nodes.image.bottom() + this.margin.top },
          height: function() { return 32 },
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
      height: function() { return (this.context.height() - this.margin.top - this.margin.bottom) / this.collection.getSize()  },
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
        remove: {
          name: "channel-entry.remove",
          width: function() { return this.context.height() - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 4, left: 4, right: 4, bottom: 4 },
        },
        label: {
          name: "channel-entry.label",
          width: function() { return this.context.width() 
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
          margin: { top: 0, left: 0, right: 0, bottom: 0 },
          x: function() { return this.context.nodes.label.right() },
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
            - this.context.nodes.remove.margin.right },
          height: function() { return 30 },
          x: function() { return this.context.x() + this.context.nodes.image.right() },
        },
        remove: {
          name: "brush-entry.remove",
          width: function() { return 32 - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 4, left: 4, right: 4, bottom: 4 },
          x: function() { return this.context.x() + this.context.nodes.label.right()
            + this.margin.right },
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
        remove: {
          name: "template-entry.remove",
          width: function() { return this.context.height() - this.margin.left - this.margin.right },
          height: function() { return 32 - this.margin.top - this.margin.bottom },
          margin: { top: 4, left: 4, right: 4, bottom: 4 },
        },
        label: {
          name: "template-entry.label",
          width: function() { return this.context.width() 
            - this.context.nodes.remove.width()
            - this.context.nodes.remove.margin.left
            - this.context.nodes.remove.margin.right  },
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
      height: function() { return 42 - this.margin.top - this.margin.bottom },
      margin: { top: 5, bottom: 5 },
      nodes: {
        checkbox: {
          name: "property.checkbox",
          width: function() { return 32 },
        },
        label: {
          name: "property.label",
          x: function() { return this.context.nodes.checkbox.right() },
          width: function() { return this.context.width() 
            - this.context.nodes.checkbox.width()
            - this.context.nodes.input.width() },
        },
        input: {
          name: "property.input",
          x: function() { return this.context.nodes.label.right() },
          width: function() { return 56 },
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
      height: function() { return 32 - this.margin.top - this.margin.bottom },
      margin: { top: 0, bottom: 5 },
      nodes: {
        checkbox: {
          name: "property-bar.checkbox",
          width: function() { return 56 },
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
          width: function() { return 56 },
        },
      }
    }
  },

  "button": function(config = null) {
    return {
      name: "button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 32 },
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
  "text-field": function(config = null) {
    return {
      name: "text-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      _height: 32,
      height: function() { return this._height },
      nodes: {
        label: {
          name: "text-field.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "text-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() - this.context.nodes.label.right()
            - this.margin.left - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
          setHeight: new BindIntent(function(height) {
            this.context._height = height + this.margin.top + this.margin.bottom
          }),
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
      _height: 32,
      height: function() { return this._height },
      nodes: {
        field: {
          name: "text-area.field",
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
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
      height: function() { return 32 },
      nodes: {
        label: {
          name: "text-field-button.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "text-field-button.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() 
            - this.context.nodes.label.right()
            - this.context.nodes.button.width()
            - this.context.nodes.button.margin.right
            - this.margin.left - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        },
        button: {
          name: "text-field-button.button",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return 32 },
          margin: { top: 5, bottom: 5, right: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-checkbox": function(config = null) {
    return {
      name: "text-field-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 40 },
      nodes: {
        checkbox: {
          name: "text-field-checkbox.checkbox",
          width: function() { return 56 },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        label: {
          name: "text-field-checkbox.label",
          x: function() { return this.context.nodes.checkbox.right() 
            + this.margin.left },
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "text-field-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() 
            - this.context.nodes.checkbox.width()
            - this.context.nodes.checkbox.margin.left
            - this.context.nodes.checkbox.margin.right
            - this.context.nodes.label.width()
            - this.context.nodes.label.margin.left
            - this.context.nodes.label.margin.right
            - this.margin.left 
            - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "text-field-button-checkbox": function(config = null) {
    return {
      name: "text-field-button-checkbox",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 32 },
      nodes: {
        checkbox: {
          name: "text-field-button-checkbox.checkbox",
          width: function() { return 56 },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        label: {
          name: "text-field-button-checkbox.label",
          x: function() { return this.context.nodes.checkbox.right() 
            + this.margin.left },
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "text-field-button-checkbox.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return this.context.width() 
            - this.context.nodes.checkbox.width()
            - this.context.nodes.checkbox.margin.left
            - this.context.nodes.checkbox.margin.right
            - this.context.nodes.label.width()
            - this.context.nodes.label.margin.left
            - this.context.nodes.label.margin.right
            - this.context.nodes.button.width()
            - this.context.nodes.button.margin.left
            - this.context.nodes.button.margin.right
            - this.margin.left 
            - this.margin.right },
          height: function() { return this.context.height() 
            - this.margin.top - this.margin.bottom },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        },
        button: {
          name: "text-field-button.button",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return 56 },
          margin: { top: 5, bottom: 5, right: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "boolean-field": function(config = null) {
    return {
      name: "boolean-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 32 },
      nodes: {
        label: {
          name: "boolean-field.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          y: function() { return this.context.y() + this.margin.top + this.margin.bottom },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "boolean-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 56 },
          height: function() { return this.context.height() },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "texture-field": function(config = null) {
    return {
      name: "texture-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.preview.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field.title",
          height: function() { return 42 },
        },
        texture: {
          name: "texture-field.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        frame: {
          name: "texture-field.frame",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        alpha: {
          name: "texture-field.alpha",
          y: function() { return this.context.nodes.frame.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        preview: {
          name: "texture-field.preview",
          y: function() { return this.context.nodes.alpha.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 10, bottom: 10, left: 10, right: 10 },
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
      height: function() { return this.nodes.preview.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field.title",
          height: function() { return 42 },
        },
        texture: {
          name: "texture-field.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        preview: {
          name: "texture-field.preview",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 10, bottom: 10, left: 10, right: 10 },
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
      height: function() { return this.nodes.preview.bottom() - this.y() },
      nodes: {
        title: {
          name: "texture-field-ext.title",
          height: function() { return 42 },
        },
        texture: {
          name: "texture-field-ext.texture",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        frame: {
          name: "texture-field-ext.frame",
          y: function() { return this.context.nodes.texture.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        speed: {
          name: "texture-field-ext.speed",
          y: function() { return this.context.nodes.frame.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        scaleX: {
          name: "texture-field-ext.scaleX",
          y: function() { return this.context.nodes.speed.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        scaleY: {
          name: "texture-field-ext.scaleY",
          y: function() { return this.context.nodes.scaleX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        alpha: {
          name: "texture-field-ext.alpha",
          y: function() { return this.context.nodes.scaleY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        animate: {
          name: "texture-field-ext.animate",
          y: function() { return this.context.nodes.alpha.bottom() + this.margin.top },
          height: function() { return 42 },
        },
        randomFrame: {
          name: "texture-field-ext.randomFrame",
          y: function() { return this.context.nodes.animate.bottom() + this.margin.top },
          height: function() { return 42 },
        },
        preview: {
          name: "texture-field-ext.preview",
          y: function() { return this.context.nodes.resolution.bottom() + this.margin.top },
          height: function() { return 144 },
          margin: { top: 10, bottom: 10, left: 10, right: 10 },
        },
        resolution: {
          name: "texture-field-ext.resolution",
          y: function() { return this.context.nodes.randomFrame.bottom() + this.margin.top },
          height: function() { return 32 },
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
      height: function() { return 32 },
      nodes: {
        label: {
          name: "numeric-slider-field.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "numeric-slider-field.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        },
        slider: {
          name: "numeric-slider-field.slider",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, right: 15, left: 10 },
        }
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-slider-field-button": function(config = null) {
    return {
      name: "numeric-slider-field-button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 32 },
      nodes: {
        label: {
          name: "numeric-slider-field-button.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        field: {
          name: "numeric-slider-field-button.field",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, right: 5, left: 5 },
        },
        decrease: {
          name: "numeric-slider-field-button.decrease",
          x: function() { return this.context.nodes.field.right() + this.margin.left },
          width: function() { return 14 },
          margin: { top: 5, bottom: 5, right: 0, left: 5 },
        },
        slider: {
          name: "numeric-slider-field-button.slider",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return ((this.context.width() - this.context.nodes.label.right()) / 2.0)
            - this.margin.left 
            - this.margin.right 
            - this.context.nodes.decrease.margin.left
            - this.context.nodes.decrease.margin.right
            - this.context.nodes.decrease.width() 
            - this.context.nodes.increase.margin.left
            - this.context.nodes.increase.margin.right
            - this.context.nodes.increase.width() },
          margin: { top: 5, bottom: 5, right: 13, left: 10 },
        },
        increase: {
          name: "numeric-slider-field-button.increase",
          x: function() { return this.context.width() - this.margin.right - this.width() },
          width: function() { return 14 },
          margin: { top: 5, bottom: 5, right: 14, left: 0 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "numeric-slider-button": function(config = null) {
    return {
      name: "numeric-slider-button",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 32 },
      nodes: {
        label: {
          name: "numeric-slider-button.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { top: 5, bottom: 5, left: 5 },
        },
        decrease: {
          name: "numeric-slider-button.decrease",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 14 },
          margin: { top: 5, bottom: 5, right: 0, left: 5 },
        },
        slider: {
          name: "numeric-slider-button.slider",
          x: function() { return this.context.nodes.decrease.right() + this.margin.left },
          width: function() { return this.context.width()
            - this.margin.left 
            - this.margin.right 
            - this.context.nodes.decrease.right() 
            - this.context.nodes.increase.margin.left
            - this.context.nodes.increase.margin.right
            - this.context.nodes.increase.width() },
          margin: { top: 5, bottom: 5, right: 13, left: 10 },
        },
        increase: {
          name: "numeric-slider-button.increase",
          x: function() { return this.context.width() - this.margin.right - this.width() },
          width: function() { return 14 },
          margin: { top: 5, bottom: 5, right: 14, left: 0 },
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
      height: function() { return this.nodes.hex.bottom() - this.y() },
      nodes: {
        title: {
          name: "color-picker.title",
          height: function() { return 42 },
        },
        red: {
          name: "color-picker.red",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        green: {
          name: "color-picker.green",
          y: function() { return this.context.nodes.red.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        blue: {
          name: "color-picker.blue",
          y: function() { return this.context.nodes.green.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        hex: {
          name: "color-picker.hex",
          y: function() { return this.context.nodes.blue.bottom() + this.margin.top },
          height: function() { return 32 },
        }
      }
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "color-picker-alpha": function(config = null) {
    var layout = Callable.run(VELayouts.get("color-picker"), config)

    Struct.set(layout.nodes, "alpha", {
      name: "color-picker.alpha",
      y: function() { return this.context.nodes.blue.bottom() + this.margin.top },
      height: function() { return 32 },
    })

    Struct.set(layout.nodes, "hex", {
      name: "color-picker.hex",
      y: function() { return this.context.nodes.alpha.bottom() + this.margin.top },
      height: function() { return 32 },
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
      height: function() { return 32 },
      margin: { top: 5, bottom: 5 },
      nodes: {
        label: {
          name: "spin-select.label",
          width: function() { return 70 - this.margin.left - this.margin.right },
          margin: { right: 5, left: 5 },
        },
        previous: {
          name: "spin-select.previous",
          x: function() { return this.context.nodes.label.right() + this.margin.left },
          width: function() { return 32 - this.margin.left - this.margin.right },
          margin: { top: 8, bottom: 8, right: 8, left: 8 },
        },
        preview: {
          name: "spin-select.preview",
          x: function() { return this.context.nodes.label.right()
            + (this.context.width() - this.context.nodes.label.right()) / 2.0
            - (this.width() / 2.0) },
          width: function() { return 32 },
        },
        next: {
          name: "spin-select.next",
          x: function() { return this.context.x() + this.context.width()
            - this.width() - this.margin.right },
          width: function() { return 32 - this.margin.left - this.margin.right },
          margin: { top: 8, bottom: 8, right: 8, left: 8 },
        },
      }
    }
  },
  
  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-numeric-property": function(config = null) {
    var textField = VELayouts.get("text-field")
    return {
      name: "transform-numeric-property",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.increment.bottom() - this.y() },
      nodes: {
        title: {
          name: "transform-numeric-property.title",
          height: function() { return 42 },
        },
        target: {
          name: "transform-numeric-property.target",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factor: {
          name: "transform-numeric-property.factor",
          y: function() { return this.context.nodes.target.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        increment: {
          name: "transform-numeric-property.increment",
          y: function() { return this.context.nodes.factor.bottom() + this.margin.top },
          height: function() { return 32 },
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
      nodes: {
        title: {
          name: "transform-numeric-uniform.title",
          height: function() { return 42 },
        },
        value: {
          name: "transform-numeric-uniform.value",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        target: {
          name: "transform-numeric-uniform.target",
          y: function() { return this.context.nodes.value.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factor: {
          name: "transform-numeric-uniform.factor",
          y: function() { return this.context.nodes.target.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        increase: {
          name: "transform-numeric-uniform.increase",
          y: function() { return this.context.nodes.factor.bottom() + this.margin.top },
          height: function() { return 32 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-vec2-uniform": function(config = null) {
    return {
      name: "transform-vec2-uniform",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { 
        var fieldHeight = this.nodes.title.valueX.height()
         + this.nodes.title.valueX().margin.top
         + this.nodes.title.valueX().margin.bottom
        return this.nodes.title.height()
          + this.nodes.title.margin.top
          + this.nodes.title.margin.bottom
          + (fieldHeight * 8)
      },
      nodes: {
        title: {
          name: "transform-vec2-uniform.title",
          height: function() { return 42 },
        },
        valueX: {
          name: "transform-vec2-uniform.valueX",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetX: {
          name: "transform-vec2-uniform.targetX",
          y: function() { return this.context.nodes.valueX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorX: {
          name: "transform-vec2-uniform.factorX",
          y: function() { return this.context.nodes.targetX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementX: {
          name: "transform-vec2-uniform.incrementX",
          y: function() { return this.context.nodes.factorX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueY: {
          name: "transform-vec2-uniform.valueY",
          y: function() { return this.context.nodes.incrementX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetY: {
          name: "transform-vec2-uniform.targetY",
          y: function() { return this.context.nodes.valueY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorY: {
          name: "transform-vec2-uniform.factorY",
          y: function() { return this.context.nodes.targetY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementY: {
          name: "transform-vec2-uniform.incrementY",
          y: function() { return this.context.nodes.factorY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-vec3-uniform": function(config = null) {
    return {
      name: "transform-vec3-uniform",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { 
        var fieldHeight = this.nodes.title.valueX.height()
         + this.nodes.title.valueX().margin.top
         + this.nodes.title.valueX().margin.bottom
        return this.nodes.title.height()
          + this.nodes.title.margin.top
          + this.nodes.title.margin.bottom
          + (fieldHeight * 12)
      },
      nodes: {
        title: {
          name: "transform-vec3-uniform.title",
          height: function() { return 42 },
        },
        valueX: {
          name: "transform-vec3-uniform.valueX",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetX: {
          name: "transform-vec3-uniform.targetX",
          y: function() { return this.context.nodes.valueX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorX: {
          name: "transform-vec3-uniform.factorX",
          y: function() { return this.context.nodes.targetX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementX: {
          name: "transform-vec3-uniform.incrementX",
          y: function() { return this.context.nodes.factorX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueY: {
          name: "transform-vec3-uniform.valueY",
          y: function() { return this.context.nodes.incrementX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetY: {
          name: "transform-vec3-uniform.targetY",
          y: function() { return this.context.nodes.valueY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorY: {
          name: "transform-vec3-uniform.factorY",
          y: function() { return this.context.nodes.targetY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementY: {
          name: "transform-vec3-uniform.incrementY",
          y: function() { return this.context.nodes.factorY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueZ: {
          name: "transform-vec3-uniform.valueZ",
          y: function() { return this.context.nodes.incrementY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetZ: {
          name: "transform-vec3-uniform.targetZ",
          y: function() { return this.context.nodes.valueZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorZ: {
          name: "transform-vec3-uniform.factorZ",
          y: function() { return this.context.nodes.targetZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementZ: {
          name: "transform-vec3-uniform.incrementZ",
          y: function() { return this.context.nodes.factorZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "transform-vec4-uniform": function(config = null) {
    return {
      name: "transform-vec4-uniform",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { 
        var fieldHeight = this.nodes.title.valueX.height()
         + this.nodes.title.valueX().margin.top
         + this.nodes.title.valueX().margin.bottom
        return this.nodes.title.height()
          + this.nodes.title.margin.top
          + this.nodes.title.margin.bottom
          + (fieldHeight * 16)
      },
      nodes: {
        title: {
          name: "transform-vec4-uniform.title",
          height: function() { return 42 },
        },
        valueX: {
          name: "transform-vec4-uniform.valueX",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetX: {
          name: "transform-vec4-uniform.targetX",
          y: function() { return this.context.nodes.valueX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorX: {
          name: "transform-vec4-uniform.factorX",
          y: function() { return this.context.nodes.targetX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementX: {
          name: "transform-vec4-uniform.incrementX",
          y: function() { return this.context.nodes.factorX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueY: {
          name: "transform-vec4-uniform.valueY",
          y: function() { return this.context.nodes.incrementX.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetY: {
          name: "transform-vec4-uniform.targetY",
          y: function() { return this.context.nodes.valueY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorY: {
          name: "transform-vec4-uniform.factorY",
          y: function() { return this.context.nodes.targetY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementY: {
          name: "transform-vec4-uniform.incrementY",
          y: function() { return this.context.nodes.factorY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueZ: {
          name: "transform-vec4-uniform.valueZ",
          y: function() { return this.context.nodes.incrementY.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetZ: {
          name: "transform-vec4-uniform.targetZ",
          y: function() { return this.context.nodes.valueZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorZ: {
          name: "transform-vec4-uniform.factorZ",
          y: function() { return this.context.nodes.targetZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementZ: {
          name: "transform-vec4-uniform.incrementZ",
          y: function() { return this.context.nodes.factorZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        valueA: {
          name: "transform-vec4-uniform.valueA",
          y: function() { return this.context.nodes.incrementZ.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        targetA: {
          name: "transform-vec4-uniform.targetA",
          y: function() { return this.context.nodes.valueA.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        factorA: {
          name: "transform-vec4-uniform.factorA",
          y: function() { return this.context.nodes.targetA.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        incrementA: {
          name: "transform-vec4-uniform.incrementA",
          y: function() { return this.context.nodes.factorA.bottom() + this.margin.top },
          height: function() { return 32 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "uniform-vec2-field": function(config = null) {
    return {
      name: "uniform-vec2-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return 84 },
      nodes: {
        label: {
          name: "uniform-vec2-field.label",
          x: function() { return this.context.x() + this.margin.left },
          y: function() { return this.context.y() + this.margin.top },
          width: function() { return this.context.width() 
            - this.margin.left - this.margin.right },
          height: function() { return 20 
            - this.margin.top - this.margin.bottom },
          margin: { bottom: 2, left: 5, right: 5 },
        },
        vec2x: {
          name: "uniform-vec2-field.vec2x",
          x: function() { return this.context.x() + this.margin.left },
          y: function() { return this.context.nodes.label.bottom() 
            + this.margin.top },
          width: function() { return this.context.width() 
            - this.margin.left - this.margin.right },
          height: function() { return 32 
            - this.margin.top - this.margin.bottom },
          margin: { bottom: 5, left: 5, right: 5 },
        },
        vec2y: {
          name: "uniform-vec2-field.vec2y",
          x: function() { return this.context.x() + this.margin.left },
          y: function() { return this.context.nodes.vec2x.bottom() 
            + this.margin.top },
          width: function() { return this.context.width() 
            - this.margin.left - this.margin.right },
          height: function() { return 32 
            - this.margin.top - this.margin.bottom },
          margin: { bottom: 5, left: 5, right: 5 },
        },
      }
    }
  },

  ///@param {?Struct} [config]
  ///@return {Struct}
  "vec4-field": function(config = null) {
    var textField = VELayouts.get("text-field")
    return {
      name: "vec4-field",
      type: Assert.isEnum(Struct.getDefault(config, "type", UILayoutType.NONE), UILayoutType),
      height: function() { return this.nodes.a.bottom() - this.y() },
      nodes: {
        title: {
          name: "vec4-field.title",
          height: function() { return 42 },
        },
        x: {
          name: "vec4-field.x",
          y: function() { return this.context.nodes.title.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        y: {
          name: "vec4-field.y",
          y: function() { return this.context.nodes.x.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        z: {
          name: "vec4-field.z",
          y: function() { return this.context.nodes.y.bottom() + this.margin.top },
          height: function() { return 32 },
        },
        a: {
          name: "vec4-field.a",
          y: function() { return this.context.nodes.z.bottom() + this.margin.top },
          height: function() { return 32 },
        },
      }
    }
  },
})
#macro VELayouts global.__VELayouts
