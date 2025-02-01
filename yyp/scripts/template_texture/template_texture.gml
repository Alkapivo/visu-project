///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_texture(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "texture-template": {
        type: TextureTemplate,
        value: new TextureTemplate(json.name, json),
      },
    }),
    components: new Array(Struct, [
      {
        name: "texture-preview",
        template: VEComponents.get("texture-field-intent"),
        layout: VELayouts.get("texture-field-intent"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          image: { 
            name: json.name,
            disableTextureService: json.file == "",
          },
          origin: "texture-template",
          store: { key: "texture-template" },
          resolution: { 
            store: { 
              key: "texture-template",
              callback: function(value, data) { 
                if (!Core.isType(value, TextureTemplate)) {
                  return
                }
                
                data.label.text = $"width: {sprite_get_width(value.asset)} height: {sprite_get_height(value.asset)}"
              },
            },
          },
          onMouseOnLeft: function(event) {
            var _x = event.data.x - this.context.area.getX() - this.area.getX() - this.context.offset.x
            var _y = event.data.y - this.context.area.getY() - this.area.getY() - this.context.offset.y
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            var scaleX = this.image.getScaleX()
            var scaleY = this.image.getScaleY()
            this.image.scaleToFit(areaWidth, areaHeight)

            var width = this.image.getWidth() * this.image.getScaleX()
            var height = this.image.getHeight() * this.image.getScaleY()
            this.image.setScaleX(scaleX).setScaleY(scaleY)

            var marginH = (areaWidth - width) / 2.0
            var marginV = (areaHeight - height) / 2.0

            var originX = round(this.image.getWidth() * ((clamp(_x, marginH, areaWidth - marginH) - marginH) / width))
            var originY = round(this.image.getHeight() * ((clamp(_y, marginV, areaHeight - marginV) - marginV) / height))

            var textureIntent = this.store.getValue()
            if (textureIntent.originX != originX
               || textureIntent.originY != originY) {
              textureIntent.originX = originX
              textureIntent.originY = originY
              this.store.get().set(textureIntent)
            }

            return this
          },
          preRender: function() {
            if (!mouse_check_button(mb_left)) {
              return this
            }

            Beans.get(BeanVisuEditorController).uiService.send(new Event("MouseOnLeft", { 
              x: MouseUtil.getMouseX(), 
              y: MouseUtil.getMouseY(),
            }))
           
            return this
          }
        },
      },
      {
        name: "texture-preview-line-h",
        template: VEComponents.get("line-h"),
        layout: VELayouts.get("line-h"),
        config: { layout: { type: UILayoutType.VERTICAL } },
      },
      {
        name: "texture-origin-x",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: {
          layout: { 
            type: UILayoutType.VERTICAL,
            //margin: { top: 2 },
          },
          label: { text: "Origin X" },
          field: { 
            store: { 
              key: "texture-template",
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), TextureTemplate)) {
                  return
                }

                var intent = item.get()
                intent.originX = parsed
                item.set(intent)
              },
              callback: function(value, data) { 
                if (!Core.isType(value, TextureTemplate)) {
                  return
                }
                
                data.textField.setText(value.originX)
              },
            },
            GMTF_DECIMAL: 0,
          },
          decrease: {
            factor: -1.0,
            callback: function() {
              var factor = Struct.get(this, "factor")
              if (!Core.isType(factor, Number) || !Core.isType(this.store, UIStore)) {
                return
              }

              var item = this.store.get()
              if (!Core.isType(item, StoreItem)) {
                return 
              }

              var intent = item.get()
              if (!Core.isType(item.get(), TextureTemplate)) {
                return
              }

              intent.originX += factor
              item.set(intent)
            },
            store: {
              key: "texture-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var factor = Struct.get(this, "factor")
              if (!Core.isType(factor, Number) || !Core.isType(this.store, UIStore)) {
                return
              }

              var item = this.store.get()
              if (!Core.isType(item, StoreItem)) {
                return 
              }

              var intent = item.get()
              if (!Core.isType(item.get(), TextureTemplate)) {
                return
              }

              intent.originX += factor
              item.set(intent)
            },
            store: {
              key: "texture-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
          stick: {
            factor: 1,
            store: { 
              key: "texture-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }

                var intent = item.get()
                if (!Core.isType(item.get(), TextureTemplate)) {
                  return
                }

                intent.originX = parsedValue
                item.set(intent)
              },
            },
            updateValue: function(mouseX, mouseY) {
              this.factor = sprite_get_width(this.store.getValue().asset) / GuiWidth()
              var isUIStore = Core.isType(this.store, UIStore)
              this.base = !Core.isType(this.base, Number) 
                ? (isUIStore ? this.store.getValue().originX : this.value)
                : this.base 

              var distanceX = mouseX - (this.area.getX() + (this.area.getWidth() / 2))
              var distanceY = (this.area.getY() + this.context.offset.y) - mouseY
              var distance = abs(distanceX) > abs(distanceY) ? distanceX : distanceY
              this.value = this.base + (distance * this.factor)
              if (isUIStore && this.value != this.store.getValue().originX) {
                this.store.set(this.value)
              }
            },
          },
          checkbox: { },
        },
      },
      {
        name: "texture-origin-y",
        template: VEComponents.get("numeric-input"),
        layout: VELayouts.get("div"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { text: "Origin Y" },
          field: { 
            store: { 
              key: "texture-template",
              set: function(value) { 
                var parsed = NumberUtil.parse(value)
                var item = this.get()
                if (!Core.isType(parsed, Number)
                  || !Core.isType(item, StoreItem) 
                  || !Core.isType(item.get(), TextureTemplate)) {
                  return
                }

                var intent = item.get()
                intent.originY = parsed
                item.set(intent)
              },
              callback: function(value, data) { 
                if (!Core.isType(value, TextureTemplate)) {
                  return
                }
                
                data.textField.setText(value.originY)
              },
            },
            GMTF_DECIMAL: 0,
          },
          decrease: {
            factor: -1.0,
            callback: function() {
              var factor = Struct.get(this, "factor")
              if (!Core.isType(factor, Number) || !Core.isType(this.store, UIStore)) {
                return
              }

              var item = this.store.get()
              if (!Core.isType(item, StoreItem)) {
                return 
              }

              var intent = item.get()
              if (!Core.isType(item.get(), TextureTemplate)) {
                return
              }

              intent.originY += factor
              item.set(intent)
            },
            store: {
              key: "texture-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
          increase: {
            factor: 1.0,
            callback: function() {
              var factor = Struct.get(this, "factor")
              if (!Core.isType(factor, Number) || !Core.isType(this.store, UIStore)) {
                return
              }

              var item = this.store.get()
              if (!Core.isType(item, StoreItem)) {
                return 
              }

              var intent = item.get()
              if (!Core.isType(item.get(), TextureTemplate)) {
                return
              }

              intent.originY += factor
              item.set(intent)
            },
            store: {
              key: "texture-template",
              callback: function(value, data) { },
              set: function(value) { },
            },
          },
          stick: {
            factor: 1,
            store: { 
              key: "texture-template",
              set: function(value) {
                var item = this.get()
                if (item == null) {
                  return 
                }

                var parsedValue = NumberUtil.parse(value, null)
                if (parsedValue == null) {
                  return
                }

                var intent = item.get()
                if (!Core.isType(item.get(), TextureTemplate)) {
                  return
                }

                intent.originY = parsedValue
                item.set(intent)
              },
            },
            updateValue: function(mouseX, mouseY) {
              this.factor = sprite_get_height(this.store.getValue().asset) / GuiHeight()
              var isUIStore = Core.isType(this.store, UIStore)
              this.base = !Core.isType(this.base, Number) 
                ? (isUIStore ? this.store.getValue().originY : this.value)
                : this.base 

              var distanceX = mouseX - (this.area.getX() + (this.area.getWidth() / 2))
              var distanceY = (this.area.getY() + this.context.offset.y) - mouseY
              var distance = abs(distanceX) > abs(distanceY) ? distanceX : distanceY
              this.value = this.base + (distance * this.factor)
              if (isUIStore && this.value != this.store.getValue().originY) {
                this.store.set(this.value)
              }
            },
          },
          checkbox: { },
        },
      },
    ]),
  }

  return template
}
