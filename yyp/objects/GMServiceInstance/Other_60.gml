///@description __context.onTextureLoadedEvent()

	if (this.__onTextureLoadedEvent != null) {
    var json = {
      file: async_load[? "filename"],
      asset: async_load[? "id"],
      status: async_load[? "status"],
      httpStatus: async_load[? "http_status"],
    }
    //Logger.debug("onTextureLoadedEvent", JSON.stringify(json, { pretty: true }))
		this.__onTextureLoadedEvent(new Event("texture-loaded", json))
	}
