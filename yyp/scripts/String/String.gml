///@package io.alkapivo.core.lang.type

///@static
function _String() constructor {

	///@param {String} text
	///@return {Number}
	size = function(text) {
		return string_length(text)
	}

	///@param {String} text
	///@param {String} substr
	///@return {Number}
	count = function(text, substr) {
		return string_count(substr, text)
	}

	///@param {String} text
	///@return {String}
	toUpperCase = function(text) {
		return string_upper(text)
	}

	///@param {String} text
	///@return {String}
	toLowerCase = function(text) {
		return string_lower(text)
	}

	///@param {String} text
	///@param {Number} position
	///@return {String}
	getChar = function(text, position) {
		return position > 0 ? string_char_at(text, position) : ""
	}

  ///@param {String} text
	///@return {String}
  getFirstChar = function(text) {
		return  String.getChar(String.size() > 0 ? 1 : 0) 
	}

  ///@param {String} text
	///@return {String}
	getLastChar = function(text) {
		return String.getChar(String.size(text))
	}

	///@param {String} text
	///@param {String} pattern
	///@return {Boolean}
	contains = function(text, pattern) {
		return string_pos(pattern, text) > 0
	}

	///@param {String} text
	///@param {String} pattern
	///@param {String} replacement
	///@return {String}
	replace = function(text, pattern, replacement) {
		return string_replace(text, pattern, replacement)
	}

	///@param {String} text
	///@param {Number} total
	///@param {Number} decimal
	///@return {String}
	format = function(text, total, decimal) {
		return string_format(text, total, decimal)
	}

	///@param {String} text
	///@param {Number} position
	///@param {Number} count
	///@return {String}
	copy = function(text, position, count) {
		return string_copy(text, position, count)
	}

	///@param {String} text
	///@param {Number} position
	///@param {Number} count
	///@return {String}
	remove = function(text, position, count) {
		return string_delete(text, position, count)
	}

	///@param {String} text
	///@param {String} pattern
	///@param {String} replacement
	///@return {String}
	replaceAll = function(text, pattern, replacement) {
		return string_replace_all(text, pattern, replacement)
	}

	///@param {String} text
	///@param {String} delimiter
	///@return {Array<String>}
	split = function(text, delimiter) {
		var size = this.count(text, delimiter) + 1
		var delimiterSize = this.size(delimiter)
		var array = GMArray.create(String, size, "")
		var buffer = text
		for (var index = 0; index < size; index++) {
			var pointer = string_pos(delimiter, buffer) - 1;
			if (pointer == -1) {
				array.container[index] = buffer;
			} else {
				array.container[index] = String.copy(buffer, 1, pointer);
				buffer = String.remove(buffer, 1, pointer + delimiterSize);	
			}
		}
		return array
	}

	///@param {String} text
	///@param {String} pattern
	///@return {Boolean}
	startsWith = function(text, pattern) {
		return string_starts_with(text, pattern)
	}

	///@param {...String} value
	///@return {String}
	concat = string_concat

	///@param {String} template
	///@param {...String} parameter
	///@return {String}
	template = function(template/*, ...parameter*/) {
		var text = template
		if (argument_count > 1) {
			for (var index = 1; index < argument_count; index++) {
				var subString = "{" + string(index - 1) + "}"
				var newString = string(argument[index])
				text = string_replace_all(text, subString, newString)
			}
		}
		return text
  }

	///@param {String} text
	///@return {Boolean}
	isEmpty = function(text) {
		return String.size(text) == 0
	}

	///@param {Number} time in seconds
	///@return {String}
	formatTimestamp = function(time) {
		var seconds = String.replace(String.format(time mod 60, 2, 0), " ", "0")
		var minutes = String.replace(String.format(time div 60, 2, 0), " ", "0")
		return $"{minutes}:{seconds}"
	}

	///@param {Number} time in seconds
	///@return {String}
	formatTimestampMilisecond = function(time) {
		var miliSeconds = String.copy(String.format(time - floor(time), 0, 2), 3, 2)
		var seconds = String.replace(String.format(time mod 60, 2, 0), " ", "0")
		var minutes = String.replace(String.format(time div 60, 2, 0), " ", "0")
		return $"{minutes}:{seconds}.{miliSeconds}"
	}
 
	///@description Breake string into word wrap lines by delimiter
	///@param {String} text
	///@param {Integer} width
	///@param {String} delimiter
	///@param {Number} wordsplitSize
	///@return {String}
	wrapText = function(text, width, delimiter, wordsplitSize) {
		var currentText = text
		var spacePosition = -1
		var currentPosition = 1
		var result = ""
		while (string_length(currentText) >= currentPosition) {
			if (string_width(string_copy(currentText, 1, currentPosition)) > width) {
				if (spacePosition != -1) {
					result += string_copy(currentText, 1, spacePosition) + delimiter;
					currentText = string_copy(currentText, spacePosition + 1, string_length(currentText) - (spacePosition));
					currentPosition = 1
					spacePosition = -1
				} else if (wordsplitSize > 0) {
					result += string_copy(currentText, 1, currentPosition - 1) + delimiter;
					currentText = string_copy(currentText, currentPosition, string_length(currentText) - (currentPosition - 1));
					currentPosition = 1
					spacePosition = -1
				}
			}
			
			if (string_char_at(currentText, currentPosition) == " ") {
				spacePosition = currentPosition
			}

			currentPosition++
		}

		if (string_length(currentText) > 0) {
			result += currentText
		}
		return result
	}

	///@param {String} text
	///@return {Array<String>}
	toArray = function(text) {
		var size = String.size(text)
		var array = GMArray.create(String, size, "")
		for (var index = 0; index < size; index++) {
			array.set(index, String.getChar(text, index + 1))
		}
		return array
	}

	///@param {String} delimiter
	///@param {...String} value
	///@return {String}
	join = string_join
}
global.__String = new _String()
#macro String global.__String

///@param {String} [_text]
function StringBuilder(_text = "") constructor {

	///@param {String}
	text = Assert.isType(_text, String)

	///@return {String}
	get = function() {
		return this.text
	}

	///@param {String} text
	///@return {StringBuilder}
	set = function(text) {
		this.text = Assert.isType(text, String)
		return this
	}

	///@param {String} text
	///@param {String} [delimiter]
	///@return {StringBuilder}
	append = function(text, delimiter = "") {
		this.text = this.text != ""
			? $"{this.text}{delimiter}{text}"
			: text
		return this
	}

	///@param {String} pattern
	///@param {String} replacemenet
	///@return {StringBuilder}
	replace = function(pattern, replacement) {
		this.text = String.replace(this.text, pattern, replacement)
		return this
	}

	///@return {StringBuilder}
	clear = function() {
		this.text = ""
		return this
	}
}
