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
        name: "texture-origin-x",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
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
            }
          },
        },
      },
      {
        name: "textture-origin-y",
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
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
            }
          },
        },
      },
      {
        name: "texture-preview",
        template: VEComponents.get("image"),
        layout: VELayouts.get("image"),
        config: { 
          image: { 
            name: json.name,
            disableTextureService: json.file == "",
          },
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
        },
      },
    ]),
  }

  return template
}
