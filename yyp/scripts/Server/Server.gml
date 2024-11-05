///@package io.alkapivo.core.service.network

#macro NetworkSocketID "NetworkSocketID"

///@param {Struct} [config]
function Server(config = {}) constructor {

  ///@type {SocketType}
  type = Assert.isEnum(Struct.get(config, "type"), SocketType)

  ///@type {Number}
  port = Assert.isType(Struct.get(config, "port"), Number)

  ///@type {String}
  maxClients = Assert.isType(Struct.get(config, "maxClients"), Number)

  ///@type {?NetworkSocketID}
  socketId = null

  ///@return {Server}
  run = function() {
    try {
      var socketId = network_create_server_raw(this.type, this.port, this.maxClients)
      this.socketId = Assert.isType(socketId, NetworkSocketID)
      Logger.info("Server", $"network_create_server_raw executed successfully, socketId: {this.socketId}")
    } catch (exception) {
      Logger.error("Server", exception.message)
      this.socketId = null
    }

    return this
  }

  ///@return {Boolean}
  isRunning = function() {
    var result = Core.isType(this.socketId, NetworkSocketID)
    if (!result && this.socketId != null) {
      this.socketId = null
    }

    return result
  }

  ///@return {Server}
  free = function() {
    if (Core.isType(this.socketId, NetworkSocketID)) {
      network_destroy(this.socketId)
      Logger.info("Server", $"network_destroy executed successfully, socketId: {this.socketId}")
    }

    this.socketId = null
    return this
  }
}