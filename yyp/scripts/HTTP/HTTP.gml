///@package io.alkapivo.core.service.network

///@enum
function _HTTPRequestType(): Enum() constructor {
    GET = "GET"
    POST = "POST"
}
global.__HTTPRequestType = new _HTTPRequestType()
#macro HTTPRequestType global.__HTTPRequestType


function HTTPRequest() constructor { }


function HTTPResponse() constructor { }
