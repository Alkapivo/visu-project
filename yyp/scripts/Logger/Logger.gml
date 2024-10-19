///@package io.alkapivo.core.util
show_debug_message("init Logger.gml")

///@static
function _Logger() constructor {

  ///@private
  ///@param {String} context
  ///@param {String} type
  ///@param {String} message
  ///@return {Logger}
  log = function(context, type, message) {
    var date = string(current_year) + "-"
      + string(string_replace(string_format(current_month, 2, 0), " ", "0")) + "-"
      + string(string_replace(string_format(current_day, 2, 0), " ", "0")) + " "
      + string(string_replace(string_format(current_hour, 2, 0), " ", "0")) + ":"
      + string(string_replace(string_format(current_minute, 2, 0), " ", "0")) + ":"
      + string(string_replace(string_format(current_second, 2, 0), " ", "0"));
    
    Core.print($"{date} {type} [{context}] {message}")
    return this
  }

  ///@param {String} context
  ///@param {String} message
  ///@return {Logger}
  info = function(context, message) {
    return this.log(context, "INFO  ", message)
  }

  ///@param {String} context
  ///@param {String} message
  ///@return {Logger}
  warn = function(context, message) {
    return this.log(context, "WARN  ", message)
  }

  ///@param {String} context
  ///@param {String} message
  ///@return {Logger}
  error = function(context, message) {
    return this.log(context, "ERROR ", message)
  }

  ///@param {String} context
  ///@param {String} message
  ///@return {Logger}
  debug = function(context, message) {
    return this.log(context, "DEBUG ", message)
  }

  ///@param {String} context
  ///@param {String} message
  ///@return {Logger}
  test = function(context, message) {
    return this.log(context, "TEST  ", message)
  }
}
global.__Logger = new _Logger()
#macro Logger global.__Logger
