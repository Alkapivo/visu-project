///@package com.janvorisek.bktglitch

///@static
///@type {Struct}
global.__BKTGlitchFields = {
  "lineSpeed": {
    field: prop.lineSpeed,
    setter: bktglitch_set_line_speed
  },
  "lineShift": {
    field: prop.lineShift,
    setter: bktglitch_set_line_shift
  },
  "lineResolution": {
    field: prop.lineResolution,
    setter: bktglitch_set_line_resolution
  },
  "lineVertShift": {
    field: prop.lineVertShift,
    setter: bktglitch_set_line_vertical_shift
  },
  "lineDrift": {
    field: prop.lineDrift,
    setter: bktglitch_set_line_drift
  },
  "jumbleSpeed": {
    field: prop.jumbleSpeed,
    setter: bktglitch_set_jumble_speed
  },
  "jumbleShift": {
    field: prop.jumbleShift,
    setter: bktglitch_set_jumble_shift
  },
  "jumbleResolution": {
    field: prop.jumbleResolution,
    setter: bktglitch_set_jumble_resolution
  },
  "jumbleness": {
    field: prop.jumbleness,
    setter: bktglitch_set_jumbleness
  },
  "dispersion": {
    field: prop.dispersion,
    setter: bktglitch_set_channel_dispersion
  },
  "channelShift": {
    field: prop.channelShift,
    setter: bktglitch_set_channel_shift
  },
  "noiseLevel": {
    field: prop.noiseLevel,
    setter: bktglitch_set_noise_level
  },
  "shakiness": {
    field: prop.shakiness,
    setter: bktglitch_set_shakiness
  },
  "rngSeed": {
    field: prop.rngSeed,
    setter: bktglitch_set_rng_seed
  },
  "intensity": {
    field: prop.intensity,
    setter: bktglitch_set_intensity
  },
}
#macro BKTGlitchFields global.__BKTGlitchFields


function BKTGlitchService() constructor {

  bktglitch_init()
  __bktgtlich_ui_init()

  ///@type {Number}
  width = GuiWidth()
  
  ///@type {Number}
  height = GuiHeight()

  ///@type {Boolean}
  rng = false

  ///@type {Number}
  factor = 0.1

  ///@type {Map<String, Struct>}
  configs = new Map(String, Struct, {
    "easy": {
      lineSpeed: { minValue: 0.0, maxValue: 0.07, defValue: 0.0 },
      lineShift: { minValue: 0.0, maxValue: 0.03, defValue: 0.0 },
      lineResolution: { minValue: 0.0, maxValue: 3.0, defValue: 0 },
      lineVertShift: { minValue: 0.0, maxValue: 1.0, defValue: 0.0 },
      lineDrift: { minValue: 0.0, maxValue: 0.1, defValue: 0 },
      jumbleSpeed: { minValue: 0, maxValue: 0.1, defValue: 0 },
      jumbleShift: { minValue: 0, maxValue: 0.2, defValue: 0 },
      jumbleResolution: { minValue: 0, maxValue: 0.16, defValue: 0 },
      jumbleness: { minValue: 0, maxValue: 0, defValue: 0 },
      dispersion: { minValue: 0, maxValue: 0, defValue: 0 },
      channelShift: { minValue: 0, maxValue: 0, defValue: 0 },
      noiseLevel: { minValue: 0, maxValue: 0, defValue: 0 },
      shakiness: { minValue: 0, maxValue: 0, defValue: 0 },
      rngSeed: { minValue: 0, maxValue: 0, defValue: 0 },
      intensity: { minValue: 0.0, maxValue: 0.1, defValue: 0.08 },
    },
    "medium": {
      lineSpeed: { minValue: 0.0, maxValue: 0.7, defValue: 0.0 },
      lineShift: { minValue: 0.0, maxValue: 0.3, defValue: 0.0 },
      lineResolution: { minValue: 0.0, maxValue: 3.0, defValue: 0 },
      lineVertShift: { minValue: 0.0, maxValue: 1.0, defValue: 0.0 },
      lineDrift: { minValue: 0.0, maxValue: 0.5, defValue: 0 },
      jumbleSpeed: { minValue: 0, maxValue: 0.8, defValue: 0 },
      jumbleShift: { minValue: 0, maxValue: 2.2, defValue: 0 },
      jumbleResolution: { minValue: 0, maxValue: 0.64, defValue: 0 },
      jumbleness: { minValue: 0, maxValue: 0, defValue: 0 },
      dispersion: { minValue: 0, maxValue: 0, defValue: 0 },
      channelShift: { minValue: 0, maxValue: 0, defValue: 0 },
      noiseLevel: { minValue: 0, maxValue: 0, defValue: 0 },
      shakiness: { minValue: 0, maxValue: 0, defValue: 0 },
      rngSeed: { minValue: 0, maxValue: 0, defValue: 0 },
      intensity: { minValue: 0.0, maxValue: 0.0, defValue: 0.08 },
    },
  })

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn": function(event) {
      this.factor = Struct.getIfType(event.data, "factor", Number, this.factor)
      this.rng = Struct.getIfType(event.data, "rng", Boolean, this.rng)
    },
    "load-config": function(event) {
      var keys = Struct.keys(event.data)
      var size = GMArray.size(keys)
      for (var index = 0; index < size; index++) {
        var key = keys[index]
        var property = Struct.get(event.data, key)
        var item = Struct.get(BKTGlitchFields, key)
        __bktgtlich_setup_property(item.field, property.defValue, name, item.setter, property.minValue, property.maxValue)
      }
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@param {Number} width
  ///@param {Number} height
  ///@return {BKTGlitch}
  update = function(width, height) {
    this.dispatcher.update()
    this.width = width
    this.height = height
    __bktgtlich_ui_step(this.rng, this.factor)
    this.rng = false

    //if (keyboard_check_pressed(vk_enter)) {
    //  this.send(new Event("spawn").setData({ factor: 0.001 }))
    //}
    return this
  }

  ///@param {Callable} callback
  ///@param {any} data
  ///@return {BKTGlitch}
  renderOn = function(callback, data) {
    bktglitch_activate(this.width, this.height)
		__bktgtlich_pass_uniforms_from_ui()
    callback(data)
    bktglitch_deactivate()
    return this
  }
}