///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_subtitle(json = null) {
  var template = {
    name: Assert.isType(json.name, String),
    store: new Map(String, Struct, {
      "lines": {
        type: String,
        value: Struct.getDefault(json, "lines", new Array(String)).join("\n"),
      },
    }),
    components: new Array(Struct, [
      {
        name: "subtitle_lines",
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: "Text",
            backgroundColor: VETheme.color.accentShadow,
          },
          input: { backgroundColor: VETheme.color.accentShadow },
          checkbox: { backgroundColor: VETheme.color.accentShadow },
        },
      },
      {
        name: "subtitle_lines_text-area",
        template: VEComponents.get("text-area"),
        layout: VELayouts.get("text-area"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          field: { 
            v_grow: true,
            w_min: 570,
            store: { key: "lines" },
          },
        },
      },
    ]),
  }

  return template
}
