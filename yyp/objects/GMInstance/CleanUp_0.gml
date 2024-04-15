///@description dereference __context

  try {
    if (Core.isType(this.__context, Struct)) {
      delete this.__context
    }
  } catch (exception) {
    Logger.error("GMInstance", $"dereference __context fatal error: {exception.message}")
  }
  
 