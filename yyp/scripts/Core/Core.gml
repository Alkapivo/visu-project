///@package io.alkapivo.core
show_debug_message("init Core.gml")

#macro this self
#macro null undefined
#macro any "any"
#macro GAME_FPS 60
#macro FRAME_MS 1 / GAME_FPS
#macro ERROR_VALUE -1
#macro GuiWidth display_get_gui_width
#macro GuiHeight display_get_gui_height
#macro super event_inherited
#macro BREAK_LOOP "__BREAK_LOOP__"
#macro Prototype "Prototype"
#macro Matrix "Matrix"
#macro NonNull "NonNull"
#macro GMCamera "GMCamera"
#macro GMTileset "GMTileset"
#macro GMScene "GMScene"

///@static
function _Core() constructor {

  ///@private
  ///@final
  ///@type {Struct}
  typeofMap = {
    "array": "GMArray",
    "bool": Boolean,
    "int32": Number,
    "int64": Number,
    "method": "Callable",
    "null": any,
    "number": Number,
    "ptr": Number,
    "ref": Number,
    "string": "String",
    "struct": "Struct",
    "undefined": any,
    "unknown": any,
  }

  ///@type {?Map<String, any>}
  properties = null

  ///@type {?Map<String, any>}
  typeParsers = null

  ///@param {any} object
  ///@param {any} type
  ///@return {Boolean}
  static isType = function(object, type) {
    try {
      var result = typeof(object)
      switch (type) {
        case any: return true
        case Boolean: return result == "bool" || result == "number"
        case Callable: return (result == "method" || result == "ref" || result == "number") 
          && is_callable(object)
        case Collection: return result == "struct" && (is_instanceof(object, Collection) 
          || is_instanceof(object, Array) 
          || is_instanceof(object, Map) 
          || is_instanceof(object, Stack) 
          || is_instanceof(object, Queue))
        case GMArray: return result == "array"
        case GMBuffer: return result == "ref" && buffer_exists(object)
        case GMCamera: return result == "number"
        case GMColor: return result == "number"
        case GMFont: return result == "ref" && font_exists(object)
        case GMKeyboardKey: return typeof(object) == "number"
        case GMMouseButton: return MouseButtonType.contains(object)
        case GMObject: return result == "ref"
        case GMShader: return result == "ref" && shader_is_compiled(object)
        case GMShaderUniform: return (result == "number" || result == "ref") && object != -1
        case GMScene: return result == "ref" && asset_get_type(object) == asset_room
        case GMSound: return (result == "number" || result == "ref") && audio_exists(object)
        case GMSurface: return result == "ref" && surface_exists(object)
        case GMVideoSurface: return result == "ref" && surface_exists(object)
        case GMTileset: return result == "ref"
        case GMTexture: return (result == "ref" || result == "number") && sprite_exists(object)
        ///@todo bug, ref will be returned only when gamemaker is initalizing
        case NonNull: return object != null
        case Number: return result == "number"
        case Prototype: return result == "number" && is_callable(object)
        case String: return result == "string"
        case Struct: return result == "struct"
        default: 
          if (typeof(type) == "struct" && is_instanceof(type, OptionalType)) {
            return object != null ? Core.isType(object, type.type) : true
          }
          return is_instanceof(object, type)
      }
    } catch (exception) {
      Logger.error("Core.isType", $"'{type}' Fatal error: {exception.message}")
    }
    return false
  }

  ///@param {any} object
  ///@param {Enum} enumerable
  ///@param {?String} [message]
  ///@return {Boolean}
  static isEnum = function(object, enumerable) {
    try {
      return enumerable.contains(object)
    } catch (exception) { }
    return false
  }

  ///@param {any} object
  ///@param {Enum} enumerable
  ///@param {?String} [message]
  ///@return {Boolean}
  static isEnumKey = function(object, enumerable) {
    try {
      return enumerable.containsKey(object)
    } catch (exception) { }
    return false  
  }

  ///@param {any} object
  ///@return {?String}
  static getTypeName = function(object) {
    var type = null
    try {
      type = Core.hasConstructor(object) 
        ? instanceof(object) 
        : StructgetDefault(typeofMap, typeof(object), null)
    } catch (exception) { }
    return type
  }

  ///@param {?Prototype} prototype
  ///@return {?String}
  static getPrototypeName = function(prototype) {
    return Core.isType(prototype, Prototype)
      ? script_get_name(prototype)
      : null
  }

  ///@param {String} name
  ///@return {?Callable}
  static getConstructor = function(name) {
    if (!Core.isType(name, String)) {
      return null
    }
    
    var prototype = asset_get_index(name)
    if (!Core.isType(prototype, Callable)) {
      return null
    }

    return prototype
    /*
    var type = null
    try {
      type = Assert.isType(asset_get_index(name), Callable)
    } catch (exception) { }
    return type
    */
  }

  ///@param {any} object
  ///@return {Boolean}
  static hasConstructor = function(object) {
    var type = typeof(object) != "struct" ? null : instanceof(object)
    return type != null && type != "struct"
  }

  ///@param {...any} message
  ///@return {Core}
  static print = function(/*...message*/) {
    var buffer = ""
    try {
      for (var index = 0; index < argument_count; index++) {
        buffer += (index == 0 ? "" : " ") + string(argument[index])
      }
    } catch (exception) {
      buffer = $"'print' fatal error: {exception.message}"
    }
    show_debug_message(buffer)
    return Core
  }

  ///@return {Core}
  static printStackTrace = function() {
    var stackTrace = debug_get_callstack();
    for (var index = 0; index < GMArray.size(stackTrace); index++) {
      var line = string(stackTrace[index]);
      if (line != "0") {
        line = "\tat " + line;
        Core.print(line)
      }
    }
    return Core
  }

  ///@param {String} [_path]
  ///@return {Core}
  static loadProperties = function(_path = $"{working_directory}core-properties.json") {
    if (!Core.isType(Core.properties, Map)) {
      Logger.debug("Core", "Create properties")
      Core.properties = new Map(String, any)
    }
    
    try {
      var path = FileUtil.get(_path)
      Logger.debug("Core", $"Start loading properties from '{path}'")

      var file = FileUtil.readFileSync(path)
      var properties = Assert.isType(JSON.parse(file.getData()), Struct)
      Struct.forEach(properties, function(property, key) {
        Logger.debug("Core", $"Load property '{key}'")
        if (Core.isType(property, GMArray)) {
          Core.properties.set(key, new Array(any, property)) 
        } else {
          Core.properties.set(key, property) 
        }
      })

    } catch (exception) {
      Logger.error("Core", $"Unable to load properties from file. {exception.message}")
    }

    return Core
  }

  ///@param {String} key
  ///@param {any} [defaultValue]
  ///@return {any}
  static getProperty = function(key, defaultValue = null) {
    return Core.properties.getDefault(key, defaultValue)
  }

  ///@param {String} key
  ///@param {any} value
  ///@return {Core}
  static setProperty = function(key, value) {
    Core.properties.set(key, value)
    return this
  }

  ///@param {Boolean} value
  ///@return {Core}
  static debugOverlay = function(value) {
    show_debug_overlay(value)
    return this
  }

  ///@return {RuntimeType}
  static getRuntimeType = function() {
    switch (os_type) {
      case os_windows: return RuntimeType.WINDOWS
      case os_gxgames: return RuntimeType.GXGAMES
      case os_linux: return RuntimeType.LINUX
      case os_macosx: return RuntimeType.MACOSX
      case os_ios: return RuntimeType.IOS
      case os_tvos: return RuntimeType.TVOS
      case os_android: return RuntimeType.ANDROID
      case os_ps4: return RuntimeType.PS4
      case os_ps5: return RuntimeType.PS5
      case os_gdk: return RuntimeType.GDK
      case os_switch: return RuntimeType.SWITCH
      case os_unknown: return RuntimeType.UNKNOWN
      default: return RuntimeType.UNKNOWN
    }
  }

  ///@param {Type} type
  ///@return {Callable}
  static fetchTypeParser = function(type) {
    ///@param {any} value
    ///@return {any}
    static passthrough = function(value) { 
      return value
    }

    if (!Core.isType(Core.typeParsers, Map)) {
      Logger.debug("Core", "Create typeParsers map")
      Core.typeParsers = new Map()
    }

    var parser = Core.typeParsers.get(type)
    return Core.isType(parser, Callable) ? parser : passthrough
  }
}
global.__Core = new _Core()
#macro Core global.__Core


///@enum
function _RuntimeType(): Enum() constructor {
  WINDOWS = "Windows"
  GXGAMES = "GXGames"
  LINUX = "Linux"
  MACOSX = "macOS"
  IOS = "iOS"
  TVOS = "tvOS"
  ANDROID = "Android"
  PS4 = "PS4"
  PS5 = "PS5"
  GDK = "GDK"
  SWITCH = "Switch"
  UNKNOWN = "unknown"
}
global.__RuntimeType = new _RuntimeType()
#macro RuntimeType global.__RuntimeType


///@param {Struct} json
function CLIParam(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {?String}
  fullName = Struct.contains(json, "fullName") 
    ? Assert.isType(json.fullName, String) 
    : null

  ///@type {?String}
  description = Struct.contains(json, "description") 
    ? Assert.isType(json.description, String) 
    : null

  ///@type {Array<CLIParamArg>}
  args = Core.isType(Struct.get(json, "args"), GMArray)
    ? GMArray.toArray(json.args, Struct, function(arg) {
      return new CLIParamArg(arg)
    })
    : new Array(Struct)

  ///@type {Callable}
  handler = Assert.isType(method(this, json.handler), Callable)
}


///@param {Struct} json
function CLIParamArg(json) constructor {
  
  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {String}
  type = Assert.isType(json.type, String)

  ///@type {?String}
  description = Struct.contains(json, "description") 
    ? Assert.isType(json.description, String) 
    : null
}


///@param {Struct} json
function CLIParamParser(json) constructor {

  ///@type {Array<CLIParam>}
  cliParams = Assert.isType(json.cliParams, Array)

  ///@private
  ///@type {Queue<String>} params
  ///@throws {Exception}
  dispatchParam = function(params) {
    Logger.debug("CLIParamParser", $"DispatchParam, total: {params.size()}")
    if (params.size() == 0) {
      return
    }
  
    var param = params.pop()
    var cliParam = this.cliParams.find(function(cliParam, index, param) {
      return param == cliParam.name || param == cliParam.fullName
    }, param)
  
    if (!Core.isType(cliParam, CLIParam)) {
      Logger.warn("CLIParamParser", $"Cannot parse parameter '{param}'")
      this.dispatchParam(params)
      return
    }
  
    if (cliParam.args.size() > params.size()) {
      throw new Exception($"param '{cliParam.name}' require '{cliParam.args.size()}' options while '{params.size()} were provided'")
    }
  
    var args = new Array()
    IntStream.forEach(0, cliParam.args.size(), function(num, idx, acc) {
      acc.args.add(acc.params.pop())
    }, { args: args, params: params })
  
    cliParam.handler(args)
  
    this.dispatchParam(params)
  }

  ///@return {CLIParamParser}
  parse = function() {
    var count = parameter_count()
    var params = new Queue(any)
    Logger.debug("CLIParamParser", $"Parameters count: {count}")
    for (var index = 1; index < count; index++) {
      var param = parameter_string(index)
      if (!String.isEmpty(param)) {
        params.push(param)
        Logger.debug("CLIParamParser", $"{index} Adding param: '{param}'")
      }
    }
    Logger.debug("CLIParamParser", $"Parameters parsed: {params.size()}")

    this.dispatchParam(params)
    return this
  }
}

global.__SceneContext = {
  intent: null,
  getIntent: function() {
    return this.intent
  },
  setIntent: function(intent) {
    this.intent = intent
    return this
  },
  open: function(name, intent = null) {
    var scene = Assert.isType(asset_get_index(name), GMScene)
    this.setIntent(intent)
    room_goto(scene)
    return this
  }
}
#macro SceneContext global.__SceneContext