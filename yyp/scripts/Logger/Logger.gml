///@package io.alkapivo.core.lang.Logger

global.__Log = function(context, type, message) {
    var date = string(current_year) + "-"
		+ string(string_replace(string_format(current_month, 2, 0), " ", "0")) + "-"
		+ string(string_replace(string_format(current_day, 2, 0), " ", "0")) + " "
		+ string(string_replace(string_format(current_hour, 2, 0), " ", "0")) + ":"
		+ string(string_replace(string_format(current_minute, 2, 0), " ", "0")) + ":"
		+ string(string_replace(string_format(current_second, 2, 0), " ", "0"));
        
    var log = 
        string(date) + " " + 
        string(type) + "[" + 
        string(context) + "] " + 
        string(message);

    Core.print(log)
}
global.__Logger = {
    info: function(context, message) {
        global.__Log(context, "INFO  ", message)
    },
    warn: function(context, message) {
        global.__Log(context, "WARN  ", message)
    },
    error: function(context, message) {
        global.__Log(context, "ERROR ", message)
    },
    debug: function(context, message) {
        global.__Log(context, "DEBUG ", message)
    }
}
#macro Logger global.__Logger
///@package io.alkapivo.core.Logger

