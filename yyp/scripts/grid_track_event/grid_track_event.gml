///@package io.alkapivo.visu.service.track


///@enum
function _GridMode(): Enum() constructor {
  SINGLE = "SINGLE"
  DUAL = "DUAL"
}
global.__GridMode = new _GridMode()
#macro GridMode global.__GridMode


///@static
///@type {Struct}
global.__grid_track_event = {
  "brush_grid_area": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "gr-area_use-h": Struct.parse.boolean(data, "gr-area_use-h"),
        "gr-area_h": Struct.parse.numberTransformer(data, "gr-area_h", {
          clampValue: { from: 0.0, to: 100.0 },
          clampTarget: { from: 0.0, to: 100.0 },
        }),
        "gr-area_change-h": Struct.parse.boolean(data, "gr-area_change-h"),
        "gr-area_use-h-col": Struct.parse.boolean(data, "gr-area_use-h-col"),
        "gr-area_h-col": Struct.parse.color(data, "gr-area_h-col"),
        "gr-area_h-col-spd": Struct.parse.number(data, "gr-area_h-col-spd", 1.0, 0.0, 999.9),
        "gr-area_use-h-alpha": Struct.parse.boolean(data, "gr-area_use-h-alpha"),
        "gr-area_h-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-area_h-alpha"),
        "gr-area_change-h-alpha": Struct.parse.boolean(data, "gr-area_change-h-alpha"),
        "gr-area_use-h-size": Struct.parse.boolean(data, "gr-area_use-h-size"),
        "gr-area_h-size": Struct.parse.numberTransformer(data, "gr-area_h-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-area_change-h-size": Struct.parse.boolean(data, "gr-area_change-h-size"),
        "gr-area_use-v": Struct.parse.boolean(data, "gr-area_use-v"),
        "gr-area_v": Struct.parse.numberTransformer(data, "gr-area_v", {
          clampValue: { from: 0.0, to: 10.0 },
          clampTarget: { from: 0.0, to: 10.0 },
        }),
        "gr-area_change-v": Struct.parse.boolean(data, "gr-area_change-v"),
        "gr-area_use-v-col": Struct.parse.boolean(data, "gr-area_use-v-col"),
        "gr-area_v-col": Struct.parse.color(data, "gr-area_v-col"),
        "gr-area_v-col-spd": Struct.parse.number(data, "gr-area_v-col-spd", 1.0, 0.0, 999.9),
        "gr-area_use-v-alpha": Struct.parse.boolean(data, "gr-area_use-v-alpha"),
        "gr-area_v-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-area_v-alpha"),
        "gr-area_change-v-alpha": Struct.parse.boolean(data, "gr-area_change-v-alpha"),
        "gr-area_use-v-size": Struct.parse.boolean(data, "gr-area_use-v-size"),
        "gr-area_v-size": Struct.parse.numberTransformer(data, "gr-area_v-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-area_change-v-size": Struct.parse.boolean(data, "gr-area_change-v-size"),
      }
    },
    run: function(data) {
      var gridService = Beans.get(BeanVisuController).gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor

      ///@description feature TODO grid.area.h
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-h",
        "gr-area_h",
        "gr-area_change-h",
        "borderHorizontalLength",
        properties, pump, executor)

      ///@description feature TODO grid.area.h.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-area_use-h-col",
        "gr-area_h-col",
        "gr-area_h-col-spd",
        "borderVerticalColor",
        properties, pump, executor)

      ///@description feature TODO grid.area.h.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-h-alpha",
        "gr-area_h-alpha",
        "gr-area_change-h-alpha",
        "borderVerticalAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.area.h.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-h-size",
        "gr-area_h-size",
        "gr-area_change-h-size",
        "borderVerticalThickness",
        properties, pump, executor)

      ///@description feature TODO grid.area.v
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-v",
        "gr-area_v",
        "gr-area_change-v",
        "borderVerticalLength",
        properties, pump, executor)

      ///@description feature TODO grid.area.v.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-area_use-v-col",
        "gr-area_v-col",
        "gr-area_v-col-spd",
        "borderHorizontalColor",
        properties, pump, executor)

      ///@description feature TODO grid.area.v.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-v-alpha",
        "gr-area_v-alpha",
        "gr-area_change-v-alpha",
        "borderHorizontalAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.area.v.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-area_use-v-size",
        "gr-area_v-size",
        "gr-area_change-v-size",
        "borderHorizontalThickness",
        properties, pump, executor)
    },
  },
  "brush_grid_column": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "gr-c_use-mode": Struct.parse.boolean(data, "gr-c_use-mode"),
        "gr-c_mode": Struct.parse.enumerableKey(data, "gr-c_mode", GridMode, GridMode.DUAL),
        "gr-c_use-amount": Struct.parse.boolean(data, "gr-c_use-amount"),
        "gr-c_amount": Struct.parse.numberTransformer(data, "gr-c_amount", {
          clampValue: { from: 0.0, to: 999.9 },
          clampTarget: { from: 0.0, to: 999.9 },
        }),
        "gr-c_change-amount": Struct.parse.boolean(data, "gr-c_change-amount"),
        "gr-c_use-main-col": Struct.parse.boolean(data, "gr-c_use-main-col"),
        "gr-c_main-col": Struct.parse.color(data, "gr-c_main-col"),
        "gr-c_main-col-spd": Struct.parse.number(data, "gr-c_main-col-spd", 1.0, 0.0, 999.9),
        "gr-c_use-main-alpha": Struct.parse.boolean(data, "gr-c_use-main-alpha"),
        "gr-c_main-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-c_main-alpha"),
        "gr-c_change-main-alpha": Struct.parse.boolean(data, "gr-c_change-main-alpha"),
        "gr-c_use-main-size": Struct.parse.boolean(data, "gr-c_use-main-size"),
        "gr-c_main-size": Struct.parse.numberTransformer(data, "gr-c_main-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-c_change-main-size": Struct.parse.boolean(data, "gr-c_change-main-size"),
        "gr-c_use-side-col": Struct.parse.boolean(data, "gr-c_use-side-col"),
        "gr-c_side-col": Struct.parse.color(data, "gr-c_side-col"),
        "gr-c_side-col-spd": Struct.parse.number(data, "gr-c_side-col-spd", 1.0, 0.0, 999.9),
        "gr-c_use-side-alpha": Struct.parse.boolean(data, "gr-c_use-side-alpha"),
        "gr-c_side-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-c_side-alpha"),
        "gr-c_change-side-alpha": Struct.parse.boolean(data, "gr-c_change-side-alpha"),
        "gr-c_use-side-size": Struct.parse.boolean(data, "gr-c_use-side-size"),
        "gr-c_side-size": Struct.parse.numberTransformer(data, "gr-c_side-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-c_change-side-size": Struct.parse.boolean(data, "gr-c_change-side-size"),
      }
    },
    run: function(data) {
      var gridService = Beans.get(BeanVisuController).gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor

      ///@description feature TODO grid.column.mode
      Visu.resolvePropertyTrackEvent(data,
        "gr-c_use-mode",
        "gr-c_mode",
        "channelsMode",
        properties)
      
      ///@description feature TODO grid.column.amount
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-c_use-amount",
        "gr-c_amount",
        "gr-c_change-amount",
        "channels",
        properties, pump, executor)

      ///@description feature TODO grid.column.main.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-c_use-main-col",
        "gr-c_main-col",
        "gr-c_main-col-spd",
        "channelsPrimaryColor",
        properties, pump, executor)

      ///@description feature TODO grid.column.main.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-c_use-main-alpha",
        "gr-c_main-alpha",
        "gr-c_change-main-alpha",
        "channelsPrimaryAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.column.main.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-c_use-main-size",
        "gr-c_main-size",
        "gr-c_change-main-size",
        "channelsPrimaryThickness",
        properties, pump, executor)

      ///@description feature TODO grid.column.side.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-c_use-side-col",
        "gr-c_side-col",
        "gr-c_side-col-spd",
        "channelsSecondaryColor",
        properties, pump, executor)

      ///@description feature TODO grid.column.side.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-c_use-side-alpha",
        "gr-c_side-alpha",
        "gr-c_change-side-alpha",
        "channelsSecondaryAlpha",
        properties, pump, executor)
      
      ///@description feature TODO grid.column.side.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-c_use-side-size",
        "gr-c_side-size",
        "gr-c_change-side-size",
        "channelsSecondaryThickness",
        properties, pump, executor)
    },
  },
  "brush_grid_row": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "gr-r_use-mode": Struct.parse.boolean(data, "gr-r_use-mode"),
        "gr-r_mode": Struct.parse.enumerableKey(data, "gr-r_mode", GridMode, GridMode.DUAL),
        "gr-r_use-amount": Struct.parse.boolean(data, "gr-r_use-amount"),
        "gr-r_amount": Struct.parse.numberTransformer(data, "gr-r_amount", {
          clampValue: { from: 0.0, to: 999.9 },
          clampTarget: { from: 0.0, to: 999.9 },
        }),
        "gr-r_change-amount": Struct.parse.boolean(data, "gr-r_change-amount"),
        "gr-r_use-main-col": Struct.parse.boolean(data, "gr-r_use-main-col"),
        "gr-r_main-col": Struct.parse.color(data, "gr-r_main-col"),
        "gr-r_main-col-spd": Struct.parse.number(data, "gr-r_main-col-spd", 1.0, 0.0, 999.9),
        "gr-r_use-main-alpha": Struct.parse.boolean(data, "gr-r_use-main-alpha"),
        "gr-r_main-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-r_main-alpha"),
        "gr-r_change-main-alpha": Struct.parse.boolean(data, "gr-r_change-main-alpha"),
        "gr-r_use-main-size": Struct.parse.boolean(data, "gr-r_use-main-size"),
        "gr-r_main-size": Struct.parse.numberTransformer(data, "gr-r_main-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-r_change-main-size": Struct.parse.boolean(data, "gr-r_change-main-size"),
        "gr-r_use-side-col": Struct.parse.boolean(data, "gr-r_use-side-col"),
        "gr-r_side-col": Struct.parse.color(data, "gr-r_side-col"),
        "gr-r_side-col-spd": Struct.parse.number(data, "gr-r_side-col-spd", 1.0, 0.0, 999.9),
        "gr-r_use-side-alpha": Struct.parse.boolean(data, "gr-r_use-side-alpha"),
        "gr-r_side-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-r_side-alpha"),
        "gr-r_change-side-alpha": Struct.parse.boolean(data, "gr-r_change-side-alpha"),
        "gr-r_use-side-size": Struct.parse.boolean(data, "gr-r_use-side-size"),
        "gr-r_side-size": Struct.parse.numberTransformer(data, "gr-r_side-size", {
          clampValue: { from: 0.0, to: 9999.9 },
          clampTarget: { from: 0.0, to: 9999.9 },
        }),
        "gr-r_change-side-size": Struct.parse.boolean(data, "gr-r_change-side-size"),
      }
    },
    run: function(data, channel) {
      var gridService = Beans.get(BeanVisuController).gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor

      ///@description feature TODO grid.row.mode
      Visu.resolvePropertyTrackEvent(data,
        "gr-r_use-mode",
        "gr-r_mode",
        "separatorsMode",
        properties)
      
      ///@description feature TODO grid.row.amount
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-r_use-amount",
        "gr-r_amount",
        "gr-r_change-amount",
        "separators",
        properties, pump, executor)

      ///@description feature TODO grid.row.main.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-r_use-main-col",
        "gr-r_main-col",
        "gr-r_main-col-spd",
        "separatorsPrimaryColor",
        properties, pump, executor)

      ///@description feature TODO grid.row.main.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-r_use-main-alpha",
        "gr-r_main-alpha",
        "gr-r_change-main-alpha",
        "separatorsPrimaryAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.row.main.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-r_use-main-size",
        "gr-r_main-size",
        "gr-r_change-main-size",
        "separatorsPrimaryThickness",
        properties, pump, executor)

      ///@description feature TODO grid.row.side.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-r_use-side-col",
        "gr-r_side-col",
        "gr-r_side-col-spd",
        "separatorsSecondaryColor",
        properties, pump, executor)

      ///@description feature TODO grid.row.side.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-r_use-side-alpha",
        "gr-r_side-alpha",
        "gr-r_change-side-alpha",
        "separatorsSecondaryAlpha",
        properties, pump, executor)
      
      ///@description feature TODO grid.row.side.size
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-r_use-side-size",
        "gr-r_side-size",
        "gr-r_change-side-size",
        "separatorsSecondaryThickness",
        properties, pump, executor)
    },
  },
  "brush_grid_config": {
    parse: function(data) {
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "gr-cfg_use-render": Struct.parse.boolean(data, "gr-cfg_use-render"),
        "gr-cfg_render": Struct.parse.boolean(data, "gr-cfg_render"),
        "gr-cfg_use-spd": Struct.parse.boolean(data, "gr-cfg_use-spd"),
        "gr-cfg_spd": Struct.parse.numberTransformer(data, "gr-cfg_spd", {
          clampValue: { from: 0.0, to: 999.9 },
          clampTarget: { from: 0.0, to: 999.9 },
        }),
        "gr-cfg_change-spd": Struct.parse.boolean(data, "gr-cfg_change-spd"),
        "gr-cfg_use-z": Struct.parse.boolean(data, "gr-cfg_use-z"),
        "gr-cfg_z": Struct.parse.numberTransformer(data, "gr-cfg_z", {
          clampValue: { from: 0.0, to: 99999.9 },
          clampTarget: { from: 0.0, to: 99999.9 },
        }),
        "gr-cfg_change-z": Struct.parse.boolean(data, "gr-cfg_change-z"),
        "gr-cfg_use-cls-frame": Struct.parse.boolean(data, "gr-cfg_use-cls-frame"),
        "gr-cfg_cls-frame": Struct.parse.boolean(data, "gr-cfg_cls-frame"),
        "gr-cfg_use-cls-frame-col": Struct.parse.boolean(data, "gr-cfg_use-cls-frame-col"),
        "gr-cfg_cls-frame-col": Struct.parse.color(data, "gr-cfg_cls-frame-col"),
        "gr-cfg_cls-frame-col-spd": Struct.parse.number(data, "gr-cfg_cls-frame-col-spd", 1.0, 0.0, 999.9),
        "gr-cfg_use-cls-frame-alpha": Struct.parse.boolean(data, "gr-cfg_use-cls-frame-alpha"),
        "gr-cfg_cls-frame-alpha":  Struct.parse.normalizedNumberTransformer(data, "gr-cfg_cls-frame-alpha"),
        "gr-cfg_change-cls-frame-alpha": Struct.parse.boolean(data, "gr-cfg_change-cls-frame-alpha"),
        "gr-cfg_use-render-focus-grid": Struct.parse.boolean(data, "gr-cfg_use-render-focus-grid"),
        "gr-cfg_render-focus-grid": Struct.parse.boolean(data, "gr-cfg_render-focus-grid"),
        "gr-cfg_use-focus-grid-alpha": Struct.parse.boolean(data, "gr-cfg_use-focus-grid-alpha"),
        "gr-cfg_focus-grid-alpha": Struct.parse.normalizedNumberTransformer(data, "gr-cfg_focus-grid-alpha"),
        "gr-cfg_change-focus-grid-alpha": Struct.parse.boolean(data, "gr-cfg_change-focus-grid-alpha"),
        "gr-cfg_use-focus-grid-treshold": Struct.parse.boolean(data, "gr-cfg_use-focus-grid-treshold"),
        "gr-cfg_focus-grid-treshold": Struct.parse.numberTransformer(data, "gr-cfg_focus-grid-treshold", {
          clampValue: { from: 0.0, to: DEFAULT_SHADER_PIPELINE_LIMIT },
          clampTarget: { from: 0.0, to: DEFAULT_SHADER_PIPELINE_LIMIT },
        }),
        "gr-cfg_change-focus-grid-treshold": Struct.parse.boolean(data, "gr-cfg_change-focus-grid-treshold"),
        "gr-cfg_grid-use-blend": Struct.parse.boolean(data, "gr-cfg_grid-use-blend"),
        "gr-cfg_grid-blend-src": Struct.parse.enumerableKey(data, "gr-cfg_grid-blend-src", BlendModeExt, BlendModeExt.SRC_ALPHA),
        "gr-cfg_grid-blend-dest": Struct.parse.enumerableKey(data, "gr-cfg_grid-blend-dest", BlendModeExt, BlendModeExt.INV_SRC_ALPHA),
        "gr-cfg_grid-blend-eq": Struct.parse.enumerableKey(data, "gr-cfg_grid-blend-eq", BlendEquation, BlendEquation.ADD),
        "gr-cfg_grid-blend-eq-alpha": Struct.parse.enumerableKey(data, "gr-cfg_grid-blend-eq-alpha", BlendEquation, BlendEquation.ADD),
        "gr-cfg_focus-grid-use-blend": Struct.parse.boolean(data, "gr-cfg_focus-grid-use-blend"),
        "gr-cfg_focus-grid-blend-src": Struct.parse.enumerableKey(data, "gr-cfg_focus-grid-blend-src", BlendModeExt, BlendModeExt.SRC_ALPHA),
        "gr-cfg_focus-grid-blend-dest": Struct.parse.enumerableKey(data, "gr-cfg_focus-grid-blend-dest", BlendModeExt, BlendModeExt.INV_SRC_ALPHA),
        "gr-cfg_focus-grid-blend-eq": Struct.parse.enumerableKey(data, "gr-cfg_focus-grid-blend-eq", BlendEquation, BlendEquation.ADD),
        "gr-cfg_focus-grid-blend-eq-alpha": Struct.parse.enumerableKey(data, "gr-cfg_focus-grid-blend-eq-alpha", BlendEquation, BlendEquation.ADD),
        "gr-cfg_focus-grid-use-blend-col": Struct.parse.boolean(data, "gr-cfg_focus-grid-use-blend-col"),
        "gr-cfg_focus-grid-blend-col": Struct.parse.color(data, "gr-cfg_focus-grid-blend-col", "#ffffff"),
        "gr-cfg_focus-grid-blend-col-spd": Struct.parse.number(data, "gr-cfg_focus-grid-blend-col-spd", 1.0, 0.0, 999.9),
      }
    },
    run: function(data) {
      var gridService = Beans.get(BeanVisuController).gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor

      ///@description feature TODO grid.render
      Visu.resolveBooleanTrackEvent(data,
        "gr-cfg_use-render",
        "gr-cfg_render",
        "renderGrid",
        properties)

      ///@description feature TODO grid.speed
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-cfg_use-spd",
        "gr-cfg_spd",
        "gr-cfg_change-spd",
        "speed",
        properties, pump, executor)

      ///@description feature TODO grid.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-cfg_use-z",
        "gr-cfg_z",
        "gr-cfg_change-z",
        "gridZ",
        properties.depths, pump, executor)

      ///@description feature TODO grid.frame.clear
      Visu.resolveBooleanTrackEvent(data,
        "gr-cfg_use-cls-frame",
        "gr-cfg_cls-frame",
        "gridClearFrame",
        properties)

      ///@description feature TODO grid.frame.color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-cfg_use-cls-frame-col",
        "gr-cfg_cls-frame-col",
        "gr-cfg_cls-frame-col-spd",
        "gridClearColor",
        properties, pump, executor)

      ///@description feature TODO grid.frame.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-cfg_use-cls-frame-alpha",
        "gr-cfg_cls-frame-alpha",
        "gr-cfg_change-cls-frame-alpha",
        "gridClearFrameAlpha",
        properties, pump, executor)

      ///@description feature TODO grid.blend
      Visu.resolveBlendConfigTrackEvent(data,
        "gr-cfg_grid-use-blend",
        "gr-cfg_grid-blend-src",
        "gr-cfg_grid-blend-dest",
        "gr-cfg_grid-blend-eq",
        properties.gridBlendConfig,
        "gr-cfg_grid-blend-eq-alpha")

      ///@description feature TODO focus-grid.render
      Visu.resolveBooleanTrackEvent(data,
        "gr-cfg_use-render-focus-grid",
        "gr-cfg_render-focus-grid",
        "renderSupportGrid",
        properties)

      ///@description feature TODO focus-grid.treshold
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-cfg_use-focus-grid-treshold",
        "gr-cfg_focus-grid-treshold",
        "gr-cfg_change-focus-grid-treshold",
        "supportGridTreshold",
        properties, pump, executor)

      
      ///@description feature TODO focus-grid.blend-color
      Visu.resolveColorTransformerTrackEvent(data, 
        "gr-cfg_focus-grid-use-blend-col",
        "gr-cfg_focus-grid-blend-col",
        "gr-cfg_focus-grid-blend-col-spd",
        "supportGridBlendColor",
        properties, pump, executor)
      
      ///@description feature TODO focus-grid.alpha
      Visu.resolveNumberTransformerTrackEvent(data, 
        "gr-cfg_use-focus-grid-alpha",
        "gr-cfg_focus-grid-alpha",
        "gr-cfg_change-focus-grid-alpha",
        "supportGridAlpha",
        properties, pump, executor)

      ///@description feature TODO focus-grid.blend
      Visu.resolveBlendConfigTrackEvent(data,
        "gr-cfg_focus-grid-use-blend",
        "gr-cfg_focus-grid-blend-src",
        "gr-cfg_focus-grid-blend-dest",
        "gr-cfg_focus-grid-blend-eq",
        properties.supportGridBlendConfig,
        "gr-cfg_focus-grid-blend-eq-alpha")
    },
  },
}
#macro grid_track_event global.__grid_track_event
