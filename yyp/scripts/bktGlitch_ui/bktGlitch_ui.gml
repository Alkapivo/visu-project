function __bktgtlich_ui_init() {
	enum prop {
	    lineSpeed,
	    lineShift,
	    lineResolution,
	    lineVertShift,
	    lineDrift,
	    jumbleSpeed,
	    jumbleShift,
	    jumbleResolution,
	    jumbleness,
	    dispersion,
	    channelShift,
	    noiseLevel, 
	    shakiness,
	    rngSeed,
	    intensity
	};

	function __bktgtlich_setup_property(_id, _defaultValue, _name, _setter, _min, _max) {		
		attr[_id] = _defaultValue; 
		name[_id] = _name;
		valTo[_id] = _defaultValue; 
		uniformSetter[_id] = _setter;
		limit[_id, 0] = _min; 
		limit[_id, 1] = _max; 
	}

	var config = {
			lineSpeed: {
					minValue: 0.0,
					maxValue: 0.7,
					defValue: 0.0
			},
			lineShift: {
					minValue: 0.0,
					maxValue: 0.3,
					defValue: 0.0
			},
			lineResolution: {
					minValue: 0.0,
					maxValue: 3.0,
					defValue: 0
			},
			lineVertShift: {
					minValue: 0.0,
					maxValue: 1.0,
					defValue: 0.0
			},
			lineDrift: {
					minValue: 0.0,
					maxValue: 0.5,
					defValue: 0
			},
			jumbleSpeed: {
					minValue: 0,
					maxValue: 0.8,
					defValue: 0
			},
			jumbleShift: {
					minValue: 0,
					maxValue: 2.2,
					defValue: 0
			},
			jumbleResolution: {
					minValue: 0,
					maxValue: 0.64,
					defValue: 0
			},
			jumbleness: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			dispersion: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			channelShift: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			noiseLevel: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			shakiness: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			rngSeed: {
					minValue: 0,
					maxValue: 0,
					defValue: 0
			},
			intensity: {
					minValue: 0.0,
					maxValue: 0.0,
					defValue: 0.08
			}
	}

	__bktgtlich_setup_property(prop.lineSpeed, config.lineSpeed.defValue, "lineSpeed", bktglitch_set_line_speed, config.lineSpeed.minValue, config.lineSpeed.maxValue);
	__bktgtlich_setup_property(prop.lineShift, config.lineShift.defValue, "lineShift", bktglitch_set_line_shift, config.lineShift.minValue, config.lineShift.maxValue);
	__bktgtlich_setup_property(prop.lineResolution, config.lineResolution.defValue,  "lineResolution", bktglitch_set_line_resolution, config.lineResolution.minValue, config.lineResolution.maxValue);
	__bktgtlich_setup_property(prop.lineVertShift, config.lineVertShift.defValue, "lineVertShift", bktglitch_set_line_vertical_shift, config.lineVertShift.minValue, config.lineVertShift.maxValue);
	__bktgtlich_setup_property(prop.lineDrift, config.lineDrift.defValue,  "lineDrift", bktglitch_set_line_drift, config.lineDrift.minValue, config.lineDrift.maxValue);
	__bktgtlich_setup_property(prop.jumbleSpeed, config.jumbleSpeed.defValue, "jumbleSpeed", bktglitch_set_jumble_speed, config.jumbleSpeed.minValue, config.jumbleSpeed.maxValue);
	__bktgtlich_setup_property(prop.jumbleShift, config.jumbleShift.defValue, "jumbleShift", bktglitch_set_jumble_shift, config.jumbleShift.minValue, config.jumbleShift.maxValue);
	__bktgtlich_setup_property(prop.jumbleResolution, config.jumbleResolution.defValue, "jumbleResolution", bktglitch_set_jumble_resolution, config.jumbleResolution.minValue, config.jumbleResolution.maxValue);
	__bktgtlich_setup_property(prop.jumbleness, config.jumbleness.defValue, "jumbleness", bktglitch_set_jumbleness, config.jumbleness.minValue, config.jumbleness.maxValue);
	__bktgtlich_setup_property(prop.dispersion, config.dispersion.defValue, "dispersion", bktglitch_set_channel_dispersion, config.dispersion.minValue, config.dispersion.maxValue);
	__bktgtlich_setup_property(prop.channelShift, config.channelShift.defValue, "channelShift", bktglitch_set_channel_shift, config.channelShift.minValue, config.channelShift.maxValue);
	__bktgtlich_setup_property(prop.noiseLevel, config.noiseLevel.defValue, "noiseLevel", bktglitch_set_noise_level, config.noiseLevel.minValue, config.noiseLevel.maxValue);
	__bktgtlich_setup_property(prop.shakiness, config.shakiness.defValue,  "shakiness", bktglitch_set_shakiness, config.shakiness.minValue, config.shakiness.maxValue);
	__bktgtlich_setup_property(prop.rngSeed, config.rngSeed.defValue,  "rngSeed", bktglitch_set_rng_seed, config.rngSeed.minValue, config.rngSeed.maxValue);
	__bktgtlich_setup_property(prop.intensity, config.intensity.defValue,  "intensity", bktglitch_set_intensity, config.intensity.minValue, config.intensity.maxValue);

	logoSeed = random(1);
	headerIntensity = 0;
	alarm[0] = random_range(10, 30);
	surGlitch = -1;
	global.holdingSlider = -1;
	
	function __bktgtlich_pass_uniforms_from_ui() {
		for (var i = 0; i < array_length(attr); i++){
		    script_execute(uniformSetter[i], attr[i]);
		}
	}

	function __bktGlitch_ui_draw() {
	
		function draw_slider(_caption, __x, __y, _min, _max, _id) {
			
			var _x = floor(__x);
			var _y = floor(__y);
			var _val = string_copy(string_format(attr[_id], 0, 4), 1, 6);

			var _cursorVal = attr[_id] / limit[_id, 1];
			var _cursorX = _x + _cursorVal * 150;

			draw_set_font(fntMain);

			draw_set_valign(fa_middle);
			gpu_set_blendmode(bm_add);
			draw_set_alpha(.5);
			draw_set_colour(c_purple);
			draw_set_halign(fa_right);
			draw_text(_x - 7, _y, string_hash_to_newline(_caption));
			draw_set_halign(fa_left);

			draw_set_font(fntValue);
			draw_text(_x + 158, _y, string_hash_to_newline(_val));
			draw_set_font(fntMain); 

			draw_line_width(_x - 2, _y - 2, _x + 150, _y - 2, 2);
			draw_line_width(_cursorX - 2, _y - 4 - 2, _cursorX - 2, _y + 4 - 2, 4);

			draw_set_alpha(.8);
			draw_set_colour(c_white);
			draw_set_halign(fa_right);
			draw_text(_x - 5, _y, string_hash_to_newline(_caption));

			draw_set_halign(fa_left);
			draw_set_font(fntValue);
			draw_text(_x + 160, _y, string_hash_to_newline(_val));
			draw_set_font(fntMain); 

			draw_line_width(_x, _y - 2, _x + 150, _y - 2, 2);
			draw_line_width(_cursorX, _y - 4 - 2, _cursorX, _y + 4 - 2, 4);

			if (mouse_check_button(mb_left)){
			    if (global.holdingSlider == -1){
			        if (mouse_x >= _x &&  mouse_x <= _x + 150 && mouse_y >= _y - 6 && mouse_y <= _y + 6){
			            global.holdingSlider = _id;           
			        }
			    }
    
			    if (global.holdingSlider == _id){
			        _cursorVal = (clamp(_x, mouse_x, _x + 150) - _x) / 150;
			        _cursorVal = min(1, _cursorVal);
			        valTo[_id] = limit[_id, 0] + (limit[_id, 1] - limit[_id, 0]) * _cursorVal;  
			        attr[_id] = valTo[_id];
			    }
			}

			draw_set_alpha(1);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
			gpu_set_blendmode(bm_normal);
		}

		var _h = display_get_gui_height();
		var _w = display_get_gui_width();

		draw_sprite(sprOverlay, 0, 0, _h);

		for (var i = 0; i < array_length_1d(attr); i++){
		    draw_slider(name[i], 360 + floor(i / 5) * 340, _h - 70 + 15 * (i % 5), limit[i, 0], limit[i, 1], i);
		}

		if (!mouse_check_button(mb_left)){
		    global.holdingSlider = -1;
		}

		draw_sprite(sprTop, 0, 0, 0);
		draw_set_colour(c_black);
		draw_set_alpha(.5);
		draw_line_width(0, 18 + random_range(-1, 1), _w, 40 + random_range(-1, 1), 5); 
		draw_set_alpha(1);
		draw_set_colour(c_white);

		if (! surface_exists(surGlitch)){
		    surGlitch = surface_create(_w, _h);
		}

		surface_set_target(surGlitch);
		gpu_set_blendenable(0);
		draw_clear_alpha(c_white, 0);
		var _str = "bktGlitch 1.3";
		var _str2 = "blokatt.net | @blokatt | 2017-2021";
		draw_set_halign(fa_right);
		draw_set_alpha(.5);
		draw_set_colour(c_purple);
		draw_set_font(fntMain);
		draw_set_halign(fa_left);
		var _sW = 0;
		for (var i = 1; i <= string_length(_str2); i++){
		    draw_text_transformed(20 - 5 + _sW, floor(i / 8) + 1, string_char_at(_str2, i), 1, 1, 0);
		    _sW += string_width(string_char_at(_str2, i));
		}
		draw_set_halign(fa_right);
		draw_text_transformed(_w - 5 - 190, 2,  string_hash_to_newline("Press C to get current configuration.#Press R to randomise."), 1, 1, 0);
		draw_set_font(fntTop);
		draw_text_transformed(_w - 5 - 10 + random_range(1, -1), 5,  string_hash_to_newline(_str), 1, 1, 0);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		draw_set_font(fntMain);
		draw_text_transformed(_w - 190, 2,  string_hash_to_newline("Press C to get current configuration.#Press R to randomise."), 1, 1, 0);
		draw_set_halign(fa_left);
		var _sW = 0;
		for (var i = 1; i <= string_length(_str2); i++){
		    draw_text_transformed(20 + _sW, floor(i / 8) + 1, string_char_at(_str2, i), 1, 1, 0);
		    _sW += string_width(string_char_at(_str2, i));
		}
		draw_set_halign(fa_right);
		draw_set_font(fntTop);
		draw_text_transformed(_w - 10, 5,  string_hash_to_newline(_str), 1, 1, 0);
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		gpu_set_blendenable(1);
		surface_reset_target();

		gpu_set_blendmode(bm_add);

		shader_set(shader_bktglitch);

		bktglitch_set_intensity(2.433333);
		bktglitch_set_line_shift(0.006333);
		bktglitch_set_line_speed(0.210000);
		bktglitch_set_line_resolution(1.800000);
		bktglitch_set_line_drift(0.100000);
		bktglitch_set_line_vertical_shift(0.000000);
		bktglitch_set_noise_level(0);
		bktglitch_set_jumbleness(0.200000);
		bktglitch_set_jumble_speed(4.000000);
		bktglitch_set_jumble_resolution(30.000000);
		bktglitch_set_jumble_shift(0.150000);
		bktglitch_set_channel_shift(0.004000);
		bktglitch_set_channel_dispersion(0.002500);
		bktglitch_set_shakiness(0.800000);
		bktglitch_set_rng_seed(logoSeed);
		bktglitch_set_time(current_time * .05);
		bktglitch_set_resolution(_w, _h);

		headerIntensity = max(0, headerIntensity - .1);
		bktglitch_set_intensity(headerIntensity);
		draw_surface(surGlitch, 0, 0);
		shader_reset();

		gpu_set_blendmode(bm_normal);
	}

	function __bktgtlich_ui_step(rng, factor) {
		if (rng) {
		  for (var i = 0; i < array_length(attr); i++) {
        if (i == prop.intensity) {
          continue 
        }
		    valTo[i]  = random_range(limit[i, 0], limit[i, 1]);
        attr[i] = valTo[i] 
		  }
		} else {
			for (var i = 0; i < array_length(attr); i++){
				if (i == prop.intensity) {
						continue 
					}
					attr[i] = clamp(attr[i] - factor, 0, 1000.0)
			}
		}
	}

	function __bktgtlich_ui_alarm() {
		logoSeed = random(1);
		headerIntensity = random_range(.8, 1.2);
		alarm[0] = random_range(10, 130);
	}
}


