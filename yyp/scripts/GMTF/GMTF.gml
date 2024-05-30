///@description https://github.com/mh-cz/Gamemaker-Multiline-Text-Field/tree/main

#macro GMTF_DECIMAL 6

///@enum
function _GMTF(): Enum() constructor { 
	DEFAULT = 0
	TO_LOWER = 1
	TO_UPPER = 2
	CHR_END = 28
	CHR_ENTER = 29
	CHR_NL = 30
}
global.__GMTF = new _GMTF()
#macro GMTF global.__GMTF


///@static
///@type {Struct}
global.GMTF_DATA = { 
	active: null, 
	jumped: false,
	switch_tick: 0,
	active_drawn: false,
	timer: null,
	update: function() {
		if (!Optional.is(global.GMTF_DATA.timer)) {
			global.GMTF_DATA.timer = new Timer(3.0, { loop: Infinity })
		}
		
		if (global.GMTF_DATA.active != null 
			&& global.GMTF_DATA.active.uiItem != null) {

			var uiTextField = global.GMTF_DATA.active.uiItem

			if (mouse_check_button_pressed(mb_left)) {
				global.GMTF_DATA.active.unfocus()
			}

			// scroll offset to item
			if (!global.GMTF_DATA.jumped) {
				if (Core.isType(uiTextField.context, UI) 
					&& Core.isType(uiTextField.context.area, Rectangle)) {
					var itemX = uiTextField.area.getX()
					var itemWidth = uiTextField.area.getWidth()
					var offsetX = abs(uiTextField.context.offset.x)
					var areaWidth = uiTextField.context.area.getWidth()
					if ((itemX < offsetX && itemX + itemWidth < offsetX) 
						|| (itemX > offsetX + areaWidth && itemX + itemWidth > offsetX + areaWidth)) {
							uiTextField.context.offset.x = -1 * itemX
					}
	
					
					var itemY = uiTextField.area.getY()
					var itemHeight = uiTextField.area.getHeight()
					var offsetY = abs(uiTextField.context.offset.y)
					var areaHeight = uiTextField.context.area.getHeight()
					if ((itemY < offsetY && itemY + itemHeight < offsetY) 
						|| (itemY > offsetY + areaHeight && itemY + itemHeight > offsetY + areaHeight)) {
							uiTextField.context.offset.y = -1 * itemY
					}
				}
				global.GMTF_DATA.jumped = true
			}

			if (Optional.is(uiTextField.context.surface)) {
        uiTextField.textField.update(
					uiTextField.context.area.getX(), 
					uiTextField.context.area.getY()
				)
      } else {
        uiTextField.textField.update(0, 0)
      }

			uiTextField.textField
				.updateFocused(
					uiTextField.area.getX(),
        	uiTextField.area.getY()
				)
		}

		if (global.GMTF_DATA.active != null && !global.GMTF_DATA.active_drawn) {
			if (global.GMTF_DATA.timer.update().finished) {
				Logger.debug("GMTF", "reset GMTF_DATA")
				global.GMTF_DATA.active = null
			}
    } else {
			global.GMTF_DATA.timer.reset()
		}

    global.GMTF_DATA.active_drawn = false
		return this
	},
}


///@param {?Struct} [style_struct]
function gmtf(style_struct = null) constructor {
	
	chr_end = chr(GMTF.CHR_END)
	chr_enter = chr(GMTF.CHR_ENTER)
	chr_nl = chr(GMTF.CHR_NL)
	
	style = {
		w: 256, 
		w_min: 0,
		h: 110, 
		lh: 24, 
		text: "", 
		font: -1, 
		padding: { top: 4, bottom: 4, left: 4, right: 4 },
		c_bkg_unfocused: { c: c_gray, a: 1 }, 
		c_bkg_focused: { c: c_ltgray, a: 1 },
		c_text_unfocused: { c: c_black, a: 1 },
		c_text_focused: { c: c_black, a: 1 },
		c_selection: { c: c_blue, a: 0.275 },
		char_limit: infinity,
		letter_case: GMTF.DEFAULT,
		min_chw: 0,
		stoppers: " .,()[]{}<>?|:\\+-*/=" + chr_enter,
		v_grow: false,
	}

	l_lines = ds_list_create() ///@todo memory leak?
	l_chars = ds_list_create() ///@todo memory leak?
	l_lines[| 0] = [ 0, 0, 0, "" ]
	l_chars[| 0] = [ chr_end, 0 ]
	
	mx = 0
	my = 0
	atx = 0
	aty = 0
	tf_lnum = 1
	
	pad_atx = 0
	pad_aty = 0
	pad_w = 0
	pad_h = 0
	
	cursor1 = { pos: 0, line: l_lines[| 0], cx: 0, cy: 0, cxs: 0 }
	cursor2 = { pos: 0, line: l_lines[| 0], cx: 0, cy: 0, cxs: 0 }
	
	has_focus = false
	gamespd = 60
	cursor_tick = 1
	cursor_visible = true
	spam_tick = 0
	spam_time = infinity
	spam_now = false
	clear = false
	click_tick = 0
	double_clicked = false
	last_click_pos = 0
	enabled = true
	
	next_tf = undefined
	previous_tf = undefined
	switch_to = undefined
  
  surface = { x: 0, y: 0 }
	uiItem = null

	///@param {?gmtf} textField
	///@return {gmtf}
	set_next = function(textField) {
		this.next_tf = textField != null ?Assert.isType(textField, gmtf) : null
		return this
	}
	setNext = this.set_next
	
	///@param {?gmtf} textField
	///@return {gmtf}
	set_previous = function(textField) {
		this.previous_tf = textField != null ? Assert.isType(textField, gmtf) : null
		return this
	}
	setPrevious = this.set_previous
	
	///@return {gmtf}
	focus = function() {
		if (Core.isType(global.GMTF_DATA.active, gmtf)) {
			global.GMTF_DATA.active.unfocus()
		}

		global.GMTF_DATA.active = this
		global.GMTF_DATA.jumped = false

		if (Optional.is(this.uiItem) 
			&& Optional.is(this.uiItem.context) 
			&& Optional.is(this.uiItem.context.updateTimer)) {
			
			this.uiItem.context.updateTimer.time = this.uiItem.context.updateTimer.duration
		}
		return this
	}
	
	///@return {gmtf}
	unfocus = function() {
		if (Optional.is(this.uiItem) 
			&& Optional.is(this.uiItem.context) 
			&& Optional.is(this.uiItem.context.updateTimer)) {
			
			this.uiItem.context.updateTimer.time = this.uiItem.context.updateTimer.duration
		}
		
		global.GMTF_DATA.active = undefined
		return this
	}
	
  ///@return {Boolean}
  isFocused = function() {
    return global.GMTF_DATA.active == this
  }
  
	///@return {gmtf}
	update_style = function(style_struct = undefined, 
			update_lines = false, update_chars = false) {
		
		var keys = []
		if (style_struct != undefined) {
			keys = variable_struct_get_names(style_struct)
			var len = array_length(keys)
			for (var i = 0; i < len; i++) {
				var key = keys[i]
        if (key == "font") {
          var font = FontUtil.fetch(style_struct[$ key])
          style_struct[$ key] = font == null ? -1 : font.asset
        }
        
				style[$ key] = style_struct[$ key];
				switch(key) {
					case "w":
					case "h":
					case "lh":
					case "font":
					case "char_limit":
					case "padding":
					case "text":
						update_lines = true
						break
					case "min_chw":
					case "letter_case":
						update_chars = true
						break
				}
			}
		}
		
		pad_atx = atx + style.padding.left
		pad_aty = aty + style.padding.top
		pad_w = style.w - style.padding.right - style.padding.left
		pad_h = style.h - style.padding.top - style.padding.bottom
		
		var prevfont = draw_get_font()
		draw_set_font(style.font)
		
		if (update_chars) {
			var s = ds_list_size(l_chars)
			for (var i = 0; i < s; i++) {
				var ch = l_chars[| i][0]
				if (ch != chr_enter && ch != chr_end && ch != chr_nl) {
					if (style.letter_case == GMTF.TO_LOWER) {
						ch = string_lower(ch)
					} else if (style.letter_case == GMTF.TO_UPPER) {
						ch = string_upper(ch)
					}

					l_chars[| i][0] = ch
					l_chars[| i][1] = max(string_width(ch), style.min_chw)
				}
			}
		}
		
		if (update_lines || update_chars) {
			if (array_contains(keys, "text")) {
				this.set_text(style.text)
			} else {
				while (!this.fit_lines()) {
					ds_list_delete(l_chars, --cursor1.pos)
					if (l_chars[| cursor1.pos - 1][0] == chr_nl) {
						ds_list_delete(l_chars, --cursor1.pos)
					}
				}
				this.update_cursor(cursor1, true)
				this.update_cursor(cursor2, true)
			}
		}
		
		draw_set_font(prevfont)

		return this
	}
	
	///@return {gmtf}
	copy_cursor_info = function(from, to) {
		to.pos = from.pos
		to.line = [
			from.line[0], 
			from.line[1], 
			from.line[2], 
			from.line[3]
		]
		to.rel_pos = from.rel_pos
		to.cx = from.cx
		to.cy = from.cy
		to.cxs = from.cxs
		return this
	}
	
	///@param {Struct} cposfrom1
	///@param {Struct} cposfrom2
	///@return {Boolean}
	fit_lines = function(cposfrom1 = cursor1.pos, cposfrom2 = cursor2.pos) {
		var li = 0
		var wid = 0
		var off = 0
		var pos = 0
		var char = 0
		var ch = ""
		var chw = 0
		var fit_ok = true
		
		ds_list_clear(l_lines)
		var line = [ li, pos, pos, "" ]
		l_lines[| li] = line
		for (var i = 0; i < ds_list_size(l_chars); i++) {
			char = l_chars[| i]
			ch = char[0]
			chw = char[1]
			wid += chw
			var nl = wid >= pad_w
			var enter = ch == chr_enter
			if (nl) {
				ds_list_insert(l_chars, i++, [ chr_nl, 0 ])
				line[2] = pos++
				if (pos > cposfrom1 && pos <= cursor1.pos) {
					cursor1.pos++
				}

				if (pos > cposfrom2 && pos <= cursor2.pos) {
					cursor2.pos++
				}

				//line[3] += chr_nl;
			} else if (ch == chr_nl) {
				ds_list_delete(l_chars, i--)
				line[2]++
				continue
			}

			if (enter) {
				line[2] = pos++;
				//line[3] += ch;
			}

			if (nl || enter) {
				fit_ok = (++li < tf_lnum)
				l_lines[| li] = [ li, pos, pos, "" ]
				line = l_lines[| li]
				wid = chw
			}

			if (!enter) {
				line[2] = pos++
				if (ch != chr_end) {
					line[3] += ch
				}
			}
		}
		
		if (ch != chr_end) {
			ds_list_add(l_chars, [ chr_end, 0 ])
		} 
		
		return fit_ok
	}

	///@param {String} _txt
	insert = function(_txt) {
		var txt = string_replace_all(_txt, chr(9), "");
		if (style.letter_case == GMTF.TO_LOWER) {
			txt = string_lower(txt)
		} else if (style.letter_case == GMTF.TO_UPPER) {
			txt = string_upper(txt)
		} 
		
		var prevfont = draw_get_font()
		draw_set_font(style.font)
		tf_lnum = max(1, pad_h div style.lh)
		if (cursor1.pos != cursor2.pos) {
			this.del()
		}
		
		var len = string_length(txt)
		var cposfrom = cursor1.pos
		var ch = ""
		var chw = 0
		
		for (var i = 0; i < len; i++) {
			ch = string_char_at(txt, i + 1)
			chw = ((ch == chr_enter || ch == chr_end || ch == chr_nl)
				? 0 
				: max(string_width(ch), style.min_chw))
			ds_list_insert(l_chars, cursor1.pos++, [ ch, chw ])
		}
		
		while (!this.fit_lines(cposfrom) 
			|| ds_list_size(l_chars) > style.char_limit) {
			
			if (this.style.v_grow) {
				this.style.h = this.style.lh 
					* ds_list_size(this.l_lines) 
					+ this.style.padding.top 
					+ this.style.padding.bottom
				this.update_style()
				cposfrom = cursor1.pos
				break
			}

			ds_list_delete(l_chars, --cursor1.pos)
			if (l_chars[| cursor1.pos-1][0] == chr_nl) {
				ds_list_delete(l_chars, --cursor1.pos)
			} 

			cposfrom = cursor1.pos
		}
		
		this.update_cursor(cursor1, true, cursor2)
		draw_set_font(prevfont)
	}
	
	shorten_list = function(list, to) {
		var temp_list = ds_list_create() ///@todo memory leak?
		for (var i = 0; i < to; i++) {
			temp_list[| i] = ds_list_find_value(list, i)
		}

		ds_list_clear(list)
		ds_list_copy(list, temp_list)
	}
	
	update_cursor = function(curs, save_cx = false, copy_to = undefined) {
		curs.pos = clamp(curs.pos, 0, ds_list_size(l_chars) - 1)
		curs.info = this.get_line(curs.pos) // [line, rel_pos]
		curs.line = curs.info[0]
		curs.rel_pos = curs.info[1]
		curs.cx = this.get_range_width(curs.line[1], curs.line[1] + curs.rel_pos)
		curs.cy = curs.line[0] * style.lh
		
		if (save_cx) {
			curs.cxs = curs.cx
		}

		if (copy_to != undefined) {
			copy_cursor_info(curs, copy_to)
		} 
		
		cursor_tick = 0
		cursor_visible = true
	}
	
	get_range_width = function(from, to) {
		var wid = 0
		for (var i = from; i < to; i++) {
			wid += l_chars[| i][1]
		}
		return wid
	}
	
	get_nearest_rel_pos_by_x = function(curs, target_x, line) {
		var closest = infinity
		var pos = -1
		var wid = 0
		for (var i = line[1]; i < line[2]; i++) {
			if (abs(target_x - wid) < closest) {
				closest = abs(target_x - wid)
				pos++
			} else {
				break
			}

			wid += l_chars[| i][1]
		}

		return pos + (abs(target_x - wid) < closest ? 1 : 0)
	}
	
	get_line = function(pos) {
		var s = ds_list_size(l_lines)
		for (var i = 0; i < s; i++) {
			var line = l_lines[| i]
			var from = line[1]
			var to = line[2]
			if (clamp(pos, from, to) == pos) {
				return [ line, pos - from ]
			}
		}
		return [ l_lines[| 0], 0 ]
	}
	
	cursor_to_mouse = function(curs, mousex = mx, mousey = my) {
		var iterator = clamp((mousey - pad_aty) div style.lh, 0, ds_list_size(l_lines) - 1)
		var line = l_lines[| iterator]
		curs.pos = line[1] + this.get_nearest_rel_pos_by_x(curs, max(0, mousex - pad_atx), line)
		last_right = curs.pos == line[1] ? -1 : 1
		update_cursor(curs, true)
	}
	
	move_cursor = function(curs, r = 0, d = 0, ctrl = false) {
		if (r != 0) {
			if (!ctrl) {
				curs.pos = clamp(curs.pos + r, 0, ds_list_size(l_chars))
			} else {
				var prevpos = curs.pos
				this.expand_selection(r, style.stoppers, curs)
				if (curs.pos == prevpos) {
					curs.pos = clamp(curs.pos + r, 0, ds_list_size(l_chars))
				}
			}
			this.update_cursor(curs, true)
		}
		
		if (d != 0) {
			var nextl = curs.line[0] + d
			if (nextl == clamp(nextl, 0, ds_list_size(l_lines) - 1)) {
				var line = l_lines[| nextl]
				curs.pos = line[1] + this.get_nearest_rel_pos_by_x(curs, curs.cxs, line)
				this.update_cursor(curs)
			}
		}
		
		if (!keyboard_check(vk_shift)) {
			copy_cursor_info(cursor1, cursor2)
		}
	}
	
	expand_selection = function(right, stoppers = style.stoppers, curs = undefined) {
		if (curs == undefined) {
			if (right) {
				var s = ds_list_size(l_chars) - 1
				while (cursor1.pos++ < s) {
					if (string_pos(l_chars[| cursor1.pos][0], style.stoppers)) {
						break
					} 
				}
			} else {
				while (cursor2.pos-- > 0) {
					if (string_pos(l_chars[| cursor2.pos][0], style.stoppers)) {
						break
					}
				}
			}
		} else if (right) {
			var s = ds_list_size(l_chars) - 1;
			while (curs.pos++ < s) {
				if (string_pos(l_chars[| curs.pos][0], style.stoppers)) {
					break
				}
			}
		} else {
			while (curs.pos-- > 0) {
				if (string_pos(l_chars[| curs.pos][0], style.stoppers)) {
					break
				}
			}
		}
	}
	
	selection_draw = function() {
		draw_set_color(style.c_selection.c)
		draw_set_alpha(style.c_selection.a)
		if (cursor1.line[0] == cursor2.line[0]) {
			draw_rectangle(
				pad_atx + cursor1.cx, 
				pad_aty + cursor1.cy, 
				pad_atx + cursor2.cx, 
				pad_aty + cursor2.cy + style.lh - 1, 
				false
			)
		} else {
			var upper = cursor1.pos < cursor2.pos ? cursor1 : cursor2
			var lower = cursor1.pos < cursor2.pos ? cursor2 : cursor1
			draw_rectangle(
				pad_atx + upper.cx,
				pad_aty + upper.cy,
				pad_atx + get_range_width(upper.line[1], upper.line[2]),
				pad_aty + upper.cy + style.lh - 1,
				false
			)
			draw_rectangle(
				pad_atx,
				pad_aty + lower.cy,
				pad_atx + get_range_width(lower.line[1], lower.pos),
				pad_aty + lower.cy + style.lh - 1,
				false
			)

			for (var i = upper.line[0] + 1; i < lower.line[0]; i++) {
				var line = l_lines[| i]
				draw_rectangle(
					pad_atx,
					pad_aty + i * style.lh,
					pad_atx + get_range_width(line[1], line[2]),
					pad_aty + i * style.lh + style.lh - 1,
					false
				)
			}
		}

		draw_set_alpha(1.0)
	}

	del = function(backspace = true, ctrl = false) {
		var len = max(1, abs(cursor1.pos - cursor2.pos))
		if (backspace || cursor1.pos != cursor2.pos) {
			if (cursor1.pos < cursor2.pos) {
				repeat (len) {
					ds_list_delete(l_chars, --cursor2.pos)
				}
				cursor1.pos = cursor2.pos
			} else {
				repeat (len) {
					ds_list_delete(l_chars, --cursor1.pos)
				}
			}
		} else {
			repeat (len) {
				if (cursor1.pos + 1 < ds_list_size(l_chars)) {
					ds_list_delete(l_chars, cursor1.pos)
				} 
			}
		}
		
		if (ctrl) {
			this.expand_selection(!backspace)
			this.del()
		}
		
		this.fit_lines()
		this.update_cursor(cursor1, true, cursor2)
	}
	
  ///@params {any} text
  ///@return {gmtf}
	set_text = function(txt) {
    try {
      ds_list_clear(l_chars)
  		l_chars[| 0] = [ chr_end, 0 ]
  		cursor1.pos = 0
  		cursor2.pos = 0
      if (Core.isType(txt, Number)) {
        var parsed = string_format(txt, 1, GMTF_DECIMAL) 
        var length = string_length(parsed)
        var trim = length
        for (var index = 0; index < GMTF_DECIMAL; index++) {
          trim = length - index
          var char = string_char_at(parsed, trim)
          if (char != "0") {
            break
          }
        }
        parsed = string_copy(parsed, 1, trim)
        this.insert(parsed, true, true)
      } else {
				this.insert(String.replaceAll(txt, "\n", chr_enter));
      }
    } catch (exception) {
      Logger.error("GMTF", $"setText exception: {exception.message}")
    }

    return this
	}
  
  setText = this.set_text
	
	get_text = function(keep_enters = false) {
		var pos = 0
		var to = ds_list_size(l_chars)
		var str = @""
		while (pos < to - 1) {
			str += l_chars[| pos++][0]
		}
		
		str = string_replace_all(str, chr_end, "")
		if (!keep_enters) {
			str = string_replace_all(str, chr_enter, "\n")
		}
		str = string_replace_all(str, chr_nl, "")

		return str
	}
  
  getText = this.get_text
	
	copy = function(keep_enters = true) {
		var pos = min(cursor1.pos, cursor2.pos)
		var to = max(cursor1.pos, cursor2.pos)
		var str = keep_enters ? @"" : ""
		while (pos < to) {
			str += l_chars[| pos++][0]
		}
				
		str = string_replace_all(str, chr_end, "")
		str = string_replace_all(str, chr_enter, "\n")
		str = string_replace_all(str, chr_nl, "")
		clipboard_set_text(str)
	}
	
	paste = function() {
		if (clipboard_has_text()) {
			var text = clipboard_get_text()
			text = String.replaceAll(text, "\r", "")
			text = String.replaceAll(text, "\n", chr_enter)
			this.insert(text)
		}
	}
	
	cut = function() {
		this.copy()
		this.del()
	}

	///@param {gmtf} textField
	///@return {?gmtf}
	findEnabledPrevious = function(textField) {
		if (!Optional.is(textField.previous_tf)) {
			return null
		}

		if (!textField.previous_tf.enabled) {
			return textField.previous_tf.findEnabledPrevious(textField.previous_tf)
		} else {
			return textField.previous_tf
		}
	}

	///@param {gmtf} textField
	///@return {?gmtf}
	findEnabledNext = function(textField) {
		if (!Optional.is(textField.next_tf)) {
			return null
		}

		if (!textField.next_tf.enabled) {
			return textField.next_tf.findEnabledNext(textField.next_tf)
		} else {
			return textField.next_tf
		}
	}
  
	///@params {Number} x
  ///@params {Number} y
  ///@return {gmtf}
	updateFocused = function(x, y) {
		atx = x
		aty = y
		pad_atx = atx + style.padding.left
		pad_aty = aty + style.padding.top
		pad_w = style.w - style.padding.right - style.padding.left
		pad_h = style.h - style.padding.top - style.padding.bottom
		gamespd = game_get_speed(gamespeed_fps)
		mx = device_mouse_x_to_gui(0) - surface.x
		my = device_mouse_y_to_gui(0) - surface.y
		global.GMTF_DATA.switch_tick = max(0, --global.GMTF_DATA.switch_tick)
			
		if (!clear) {
			clear = true
			keyboard_string = ""
			cursor_tick = 0
			cursor_visible = true
		}
		
		double_clicked = false
		click_tick = max(0, --click_tick)
		if (mouse_check_button_released(mb_left)) {
			if (click_tick > 0 && last_click_pos == cursor1.pos) {
				double_clicked = true
				click_tick = 0
			} else {
				click_tick = gamespd * 0.5
				last_click_pos = cursor1.pos
			}
		}
		
		if (++cursor_tick >= gamespd * 0.5) {
			cursor_tick = 0
			cursor_visible = !cursor_visible
		}
		
		spam_now = false
		if (keyboard_check_pressed(vk_anykey)) {
			spam_time = gamespd * 0.5
			spam_tick = 0
		} else if (keyboard_check(vk_anykey)) {
			if (++spam_tick > spam_time) {
				spam_tick = 0
				spam_time = gamespd * 0.03
				spam_now = true
			}
		}
		
		if (double_clicked) {
			this.expand_selection(true)
			this.expand_selection(false)
			this.update_cursor(cursor1, true)
			this.update_cursor(cursor2)
		}
	
		if (keyboard_check_released(vk_anykey)
			&& !keyboard_check(vk_anykey)) {
			keyboard_string = ""
		}
	
		if (keyboard_check_pressed(vk_anykey) || spam_now) {
			switch (keyboard_key) {
				case vk_left:
					this.move_cursor(cursor1, -1, 0, keyboard_check(vk_control))
					break
				case vk_right:
					this.move_cursor(cursor1, 1, 0, keyboard_check(vk_control))
					break
				case vk_up:
					this.move_cursor(cursor1, 0, -1)
					break
				case vk_down:
					this.move_cursor(cursor1, 0, 1)
					break
				case vk_enter:
					keyboard_string += chr_enter;
					break
				case vk_tab:
					keyboard_string = "";
					if (global.GMTF_DATA.switch_tick == 0) {
						if (keyboard_check(vk_shift)) {
							var previousTextField = this.findEnabledPrevious(this)
							if (Optional.is(previousTextField)) {
								previousTextField.focus()
								global.GMTF_DATA.switch_tick = 2
							}
						} else {
							var nextTextField = this.findEnabledNext(this)
							if (Optional.is(nextTextField)) {
								nextTextField.focus()
								global.GMTF_DATA.switch_tick = 2
							}
						}
					}
					break
				case vk_backspace:
					this.del(true, keyboard_check(vk_control))
					break
				case vk_delete:
					this.del(false, keyboard_check(vk_control))
					break
			}
		}
	
		if (keyboard_check(vk_anykey)) {
			if (keyboard_check_pressed(vk_home)) {
				///@todo multiline support
				this.cursor1.pos = 0
				this.cursor2.pos = 0
				this.update_cursor(this.cursor1)
				this.update_cursor(this.cursor2)
			}

			if (keyboard_check_pressed(vk_end)) {
				///@todo multiline support
				this.cursor1.pos = String.size(this.cursor1.line[3])
				this.cursor2.pos = String.size(this.cursor2.line[3])
				this.update_cursor(this.cursor1)
				this.update_cursor(this.cursor2)
			}

			if (keyboard_check(vk_control)) {
				if (keyboard_check_pressed(ord("C")) 
					&& cursor1.pos != cursor2.pos) {
					keyboard_string = ""
					this.copy()


				} else if (keyboard_check_pressed(ord("V")) 
					|| (keyboard_check(ord("V")) && spam_now)) {
					
					keyboard_string = ""
					this.paste()
				} else if (keyboard_check_pressed(ord("X")) 
					&& cursor1.pos != cursor2.pos) {
					
					keyboard_string = ""
					this.cut()
				} else if (keyboard_check_pressed(ord("A"))) {
					keyboard_string = ""
					cursor2.pos = 0
					cursor1.pos = ds_list_size(l_chars)
					this.update_cursor(cursor1, true)
					this.update_cursor(cursor2)
				} else if (keyboard_check_pressed(vk_backspace)) {
					keyboard_string = ""
				}
			}
		
			if (string_length(keyboard_string) != 0) {
				this.insert(keyboard_string)
				keyboard_string = ""
			}
		}

		return this
	}

  ///@return {gmtf}
	onMousePressed = function() {
		if mouse_check_button_pressed(mb_left) {
			if point_in_rectangle(mx, my, atx, aty, atx + style.w, aty + style.h) {
				this.focus()
			} else if (has_focus) {
				this.unfocus()
			}

			this.cursor_to_mouse(cursor2)
			this.copy_cursor_info(cursor2, cursor1)
		} else if (mouse_check_button(mb_left)) {
			this.cursor_to_mouse(cursor1)
		}

		return this
	}

  ///@params {Number} x
  ///@params {Number} y
  ///@return {gmtf}
  update = function(x, y) {
     this.surface.x = x
     this.surface.y = y
     return this
  }

	///@params {Number} x
  ///@params {Number} y
  ///@return {gmtf}
	draw = function(x, y) {
		atx = x
		aty = y
		pad_atx = atx + style.padding.left
		pad_aty = aty + style.padding.top
		pad_w = style.w - style.padding.right - style.padding.left
		pad_h = style.h - style.padding.top - style.padding.bottom
		gamespd = game_get_speed(gamespeed_fps)
		mx = device_mouse_x_to_gui(0) - surface.x
		my = device_mouse_y_to_gui(0) - surface.y
		has_focus = global.GMTF_DATA.active == this
		if (!has_focus) {
			clear = false
		}

		this.onMousePressed()
		this.render(x, y)

		return this
	}

	///@param {Number} x
	///@param {Number} y
	render = function(x, y) {
		if (global.GMTF_DATA.active == this) {
			global.GMTF_DATA.active_drawn = true
		}

		var prevFont = draw_get_font()
		var prevColor = draw_get_color()
		var prevAlpha = draw_get_alpha()
		draw_set_font(style.font)
		draw_set_color(has_focus ? style.c_bkg_focused.c : style.c_bkg_unfocused.c)
		draw_set_alpha(has_focus ? style.c_bkg_focused.a : style.c_bkg_unfocused.a)
		draw_rectangle(atx, aty, atx + style.w, aty + style.h, false)
		
		if (has_focus && cursor1.pos != cursor2.pos) {
			this.selection_draw()
		}
		
		draw_set_color(has_focus ? style.c_text_focused.c : style.c_text_unfocused.c)
		draw_set_alpha(has_focus ? style.c_text_focused.a : style.c_text_unfocused.a)

		draw_set_valign(2)
		var s = null
		if (style.min_chw == 0) {
			draw_set_halign(0)
			s = ds_list_size(l_lines)
			for (var i = 0; i < s; i++) {
				draw_text(pad_atx, pad_aty + i * style.lh + style.lh, l_lines[| i][3])
			}
		} else {
			draw_set_halign(1)
			var wid = 0
			s = ds_list_size(l_lines)
			for (var i = 0; i < s; i++) {
				var line = l_lines[| i]
				for (var pos = line[1]; pos < line[2]; pos++) {
					var char = l_chars[| pos]
					var chw = char[1]
					draw_text(pad_atx + wid + (chw div 2), pad_aty + i * style.lh + style.lh, char[0])
					wid += chw
				}
				wid = 0
			}
		}
		draw_set_valign(0)
		draw_set_halign(0)
		
		if (has_focus && cursor_visible) {
			draw_line(
				pad_atx + cursor1.cx, 
				pad_aty + cursor1.cy, 
				pad_atx + cursor1.cx,
				pad_aty + cursor1.cy + style.lh
			)
		}
		
		draw_set_font(prevFont)
		draw_set_color(prevColor)
		draw_set_alpha(prevAlpha)

		return this
	}

	this.update_style(style_struct)
}
