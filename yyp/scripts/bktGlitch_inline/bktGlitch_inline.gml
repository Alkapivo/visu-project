//////////////////////////////////
//                              //
//   bktGlitch 1.3.2            //
//    Written by Jan Vorisek    //
//     @blokatt | blokatt.net   //
//      jan@blokatt.net         //
//       31/01/2021             //
//                              //
//     "Here we go again."      //
//							 	//
//////////////////////////////////

gml_pragma("forceinline");

function assert_bktglitch_activated(_uniform) {
	if (shader_current() != shader_bktglitch) {
		show_debug_message("ERROR: attempting to set " + _uniform + " while the shader is not active!");
	}
}

/// @function BktGlitch_init()
/// @description Initialises the shader.
function BktGlitch_init() {
	bktglitch_init();
}

/// @function BktGlitch_activate(_width, _height)
/// @description Activates the shader and sets required uniforms.
/// @param {real} _width
/// @param {real} _height
function BktGlitch_activate(_width, _height) {
	bktglitch_activate(_width, _height);
}

/// @function BktGlitch_config_preset(_preset)
/// @description
/// @param {real} _preset
function BktGlitch_config_preset(_preset) {
	bktglitch_config_preset(_preset);
}

/// @function BktGlitch_config(_lineShift, _lineSpeed, _lineResolution, _lineDrift, _lineVerticalShift, _jumbleness, _jumbleSpeed, _jumbleResolution, _jumbleShift, _noiseLevel, _channelShift, _channelDispersion, _shakiness, _intensity, _rngSeed)
/// @description
/// @param {real} _lineShift
/// @param {real} _lineSpeed
/// @param {real} _lineResolution
/// @param {real} _lineDrift
/// @param {real} _lineVerticalShift
/// @param {real} _jumbleness
/// @param {real} _jumbleSpeed
/// @param {real} _jumbleResolution
/// @param {real} _jumbleShift
/// @param {real} _noiseLevel
/// @param {real} _channelShift
/// @param {real} _channelDispersion
/// @param {real} _shakiness
/// @param {real} _intensity
/// @param {real} _rngSeed
function BktGlitch_config(_lineShift, _lineSpeed, _lineResolution, _lineDrift, _lineVerticalShift, _jumbleness, _jumbleSpeed, _jumbleResolution, _jumbleShift, _noiseLevel, _channelShift, _channelDispersion, _shakiness, _intensity, _rngSeed) {
	bktglitch_config(_lineShift, _lineSpeed, _lineResolution, _lineDrift, _lineVerticalShift, _jumbleness, _jumbleSpeed, _jumbleResolution, _jumbleShift, _noiseLevel, _channelShift, _channelDispersion, _shakiness, _intensity, _rngSeed);
}

/// @function BktGlitch_config_zero()
/// @description One-liner that sets up tweakable properties of the shader to zero. 
function BktGlitch_config_zero() {
	bktglitch_config_zero();
}

/// @function BktGlitch_set_resolution_of_gui()
/// @description Passes resolution to the shader set to the size of the GUI surface.
function BktGlitch_set_resolution_of_gui() {
	bktglitch_set_resolution_of_gui();
}

/// @function BktGlitch_set_resolution_of_application_surface()
/// @description Passes resolution to the shader set to the size of the application surface.
function BktGlitch_set_resolution_of_application_surface() {
	bktglitch_set_resolution_of_application_surface();
}

/// @function BktGlitch_set_time(_time)
/// @description Passes time variable to the shader, neeeds to change for animation.
/// @param {real} _time
function BktGlitch_set_time(_time) {
	bktglitch_set_time(_time);
}

/// @function BktGlitch_set_intensity(_intensity)
/// @description Sets overall intensity of the shader.
/// @param {real} _intensity
function BktGlitch_set_intensity(_intensity) {
	bktglitch_set_intensity(_intensity);
}

/// @function BktGlitch_set_line_shift(_intensity)
/// @description Sets base horizontal line offset.
/// @param {real} _intensity
function BktGlitch_set_line_shift(_intensity) {
	bktglitch_set_line_shift(_intensity);
}

/// @function BktGlitch_set_line_speed(_intensity)
/// @description Sets waving speed of horizontal lines.
/// @param {real} _intensity
function BktGlitch_set_line_speed(_intensity) {
	bktglitch_set_line_speed(_intensity);
}

/// @function BktGlitch_set_line_resolution(_granularity)
/// @description Sets resolution of horizontal lines.
/// @param {real} _granularity
function BktGlitch_set_line_resolution(_granularity) {
	bktglitch_set_line_resolution(_granularity);
}

/// @function BktGlitch_set_line_vertical_shift(_intensity)
/// @description Sets vertical (phase) offset of horizontal lines. 
/// @param {real} _intensity
function BktGlitch_set_line_vertical_shift(_intensity) {
	bktglitch_set_line_vertical_shift(_intensity);
}

/// @function BktGlitch_set_noise_level(_intensity)
/// @description Sets level of noise.
/// @param {real} _intensity
function BktGlitch_set_noise_level(_intensity) {
	bktglitch_set_noise_level(_intensity);
}

/// @function BktGlitch_set_jumbleness(_intensity)
/// @description Sets level of "jumbleness".
/// @param {real} _intensity
function BktGlitch_set_jumbleness(_intensity) {
	bktglitch_set_jumbleness(_intensity);
}

/// @function BktGlitch_set_jumble_speed(_speed)
/// @description Sets speed of jumble block variation.
/// @param {real} _speed
function BktGlitch_set_jumble_speed(_speed) {
	bktglitch_set_jumble_speed(_speed);
}

/// @function BktGlitch_set_jumble_resolution(_granularity)
/// @description Sets granularity of jumble blocks. 
/// @param {real} _granularity
function BktGlitch_set_jumble_resolution(_granularity) {
	bktglitch_set_jumble_resolution(_granularity);
}

/// @function BktGlitch_set_jumble_shift(_intensity)
/// @description Sets level of texture offset in jumble blocks.
/// @param {real} _intensity
function BktGlitch_set_jumble_shift(_intensity) {
	bktglitch_set_jumble_shift(_intensity);
}

/// @function BktGlitch_set_channel_shift(_intensity)
/// @description Sets level of horizontal RGB channel shift.
/// @param {real} _intensity
function BktGlitch_set_channel_shift(_intensity) {
	bktglitch_set_channel_shift(_intensity);
}

/// @function BktGlitch_set_rng_seed(_value)
/// @description Changes seed used for random calculations - adds variation to all effects.
/// @param {real} _value
function BktGlitch_set_rng_seed(_value) {
	bktglitch_set_rng_seed(_value);
}

/// @function BktGlitch_set_shakiness(_intensity)
/// @description Sets shakiness of horizontal lines.
/// @param {real} _intensity
function BktGlitch_set_shakiness(_intensity) {
	bktglitch_set_shakiness(_intensity);
}

/// @function BktGlitch_set_channel_dispersion(_intensity)
/// @description Sets level of horizontal noisy RGB channel dispersion.
/// @param {real} _intensity
function BktGlitch_set_channel_dispersion(_intensity) {
	bktglitch_set_channel_dispersion(_intensity);
}

/// @function BktGlitch_set_line_drift(_intensity)
/// @description Sets added scanline-y drift to horizontal lines.
/// @param {real} _intensity
function BktGlitch_set_line_drift(_intensity) {
	bktglitch_set_line_drift(_intensity);
}

/// @function BktGlitch_set_resolution(_width, _height)
/// @description Sets resolution of the region the shader is used on.
/// @param {real} _width Width in pixels.
/// @param {real} _height Height in pixels.
function BktGlitch_set_resolution(_width, _height) {
	bktglitch_set_resolution(_width, _height);
}

#macro BktGlitch_deactivate shader_reset
