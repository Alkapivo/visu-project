///@description dereference __context
  
  if (this.__free != null) {
		this.__free()	
	}
  
  if (this.__bean != null) {
    Beans.remove(this.__bean) 
  }

  try {
    if (Core.isType(this.__context, Struct)) {
      delete this.__context
    }
  } catch (exception) {
    Logger.error("GMInstance", $"dereference __context fatal error: {exception.message}")
  }
  
 