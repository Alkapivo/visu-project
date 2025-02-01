///@package io.alkapivo.core.service.network

///@enum
function _SocketType(): Enum() constructor {
  TCP = network_socket_tcp
  UDP = network_socket_udp
  WS = network_socket_ws
  WSS = network_socket_wss
}
global.__SocketType = new _SocketType()
#macro SocketType global.__SocketType


///@param {Struct} [config]
function Socket(config = {}) constructor {

  ///@type {String}
  host = Assert.isType(Struct.get(config, "host"), String)

  ///@type {Number}
  port = Assert.isType(Struct.get(config, "port"), Number)

  ///@type {SocketType}
  type = Assert.isEnum(Struct.get(config, "type"), SocketType)

  ///@type {any}
  socket = null

  ///@return {Boolean}
  isConnected = function() {
    return this.socket != null
  }

  ///@return {Socket}
  connect = function() {
    try {
      Logger.debug("Socket", $"Connect to {this.host}:{this.port}")
      this.socket = network_create_socket(this.type)
      network_connect_raw(this.socket, this.host, this.port)   
    } catch (exception) {
      Logger.error("Socket", exception.message)
      this.socket = null
    }

    return this
  }

  ///@param {String} message
  ///@return {Socket}
  send = function(message) {
    try {
      Core.print("Send", message)
      Assert.areEqual(this.socket != null, true, "null socket")

      var buff = buffer_create(String.size(message), buffer_fixed, 1)
      buffer_write(buff, buffer_text, message)
      network_send_raw(this.socket, buff, buffer_tell(buff))
      buffer_delete(buff)
    } catch (exception) {
      Core.print("SendException", exception.message)
    }

    return this
  }

  free = function() {
    if (this.socket == null) {
      return 
    }

    try {
      Logger.debug("Socket", $"Free socket {this.socket}")
      network_destroy(this.socket)
      this.socket = null
    } catch (exception) {
      Core.print("FreeException", exception.message)
    }
  }
}
