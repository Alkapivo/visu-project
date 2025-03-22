///@package io.alkapivo.core.service.file

///@param {Struct} json
function File(json) constructor {

  ///@type {String}
  path = Assert.isType(FileUtil.get(json.path), String)

  ///@type {any}
  data = Struct.getDefault(json, "data", null)

  ///@return {String}
  static getPath = function() {
    return this.path
  }

  ///@param {String} path
  ///@return {File}
  static setPath = function(path) {
    this.path = Assert.isType(FileUtil.get(json.path), String)
    return this
  }

  ///@return {any}
  static getData = function() {
    return this.data
  }

  ///@param {any} data
  ///@return {File}
  static setData = function(data) {
    this.data = data
    return this
  }
}


///@enum
function _FileAttribute(): Enum() constructor {
  NONE = fa_none
  READ_ONLY = fa_readonly
  HIDDEN = fa_hidden
  SYSTEM = fa_sysfile
  VOLUME_ID = fa_volumeid
  DIRECTORY = fa_directory
  ARCHIVE = fa_archive
}
global.__FileAttribute = new _FileAttribute()
#macro FileAttribute global.__FileAttribute


///@enum
function _PathType(): Enum() constructor {
  FILE = "file"
  DIRECTORY = "directory"
}
global.__PathType = new _PathType()
#macro PathType global.__PathType


///@todo improve API
///@static
function _FileUtil() constructor {

  ///@param {?String} path
  ///@return {?String}
  static get = function(path) {
    var posixPath = Core.isType(path, String) 
      ? String.replaceAll(String.replaceAll(path, "\\", "/"), "//", "/") 
      : null
    
    var type = FileUtil.getPathType(posixPath)
    switch (type) {
      case PathType.FILE: return posixPath
      case PathType.DIRECTORY: 
        return String.getLastChar(posixPath) != "/" 
          ? $"{posixPath}/" 
          : posixPath
      default: return null
    }
  }

  ///@param {?String} path
  ///@return {?String}
  static getDirectoryFromPath = function(path) {
    var posixPath = FileUtil.get(path)
    if (!Optional.is(FileUtil.getPathType(posixPath))) {
      return null
    } 

    var array = String.split(FileUtil.get(posixPath), "/")
    return array.remove(array.size() - 1).join("/") + "/"
  }

  ///@param {?String} path
  ///@return {?String}
  static getFilenameFromPath = function(path) {
    var posixPath = FileUtil.get(path)
    if (!Optional.is(FileUtil.getPathType(posixPath))) {
      return null
    }   

    var array = String.split(FileUtil.get(posixPath), "/")
    return array.get(array.size() - 1)
  }

  ///@param {?Struct} [config]
  ///@return {?String}
  static getPathToOpenWithDialog = function(config = null) {
    var description = Assert.isType(Struct.getDefault(config, "description", ""), String)
    var extension = Assert.isType(Struct.getDefault(config, "extension", ""), String)
    var filename = Assert.isType(Struct.getDefault(config, "filename", ""), String)
    var path = get_open_filename($"{description}|*.{extension}", filename)
    return FileUtil.get(path)
  }

  ///@param {?Struct} [config]
  ///@return {?String}
  static getPathToSaveWithDialog = function(config = null) {
    var description = Assert.isType(Struct.getDefault(config, "description", ""), String)
    var extension = Assert.isType(Struct.getDefault(config, "extension", ""), String)
    var filename = Assert.isType(Struct.getDefault(config, "filename", ""), String)
    var path = get_save_filename($"{description}|*.{extension}", filename)
    return FileUtil.get(path)
  }

  ///@param {?String} path
  ///@return {?PathType}
  static getPathType = function(path) {
    if (!Core.isType(path, String)) {
      return null
    }

    if (FileUtil.directoryExists(path)) {
      return PathType.DIRECTORY
    }

    return PathType.FILE
  }

  ///@param {?String} path
  ///@return {Boolean}
  static fileExists = function(path) {
    return Core.isType(path, String) && file_exists(path)
  }

  ///@param {?String} path
  ///@return {Boolean}
  static directoryExists = function(path) {
    return Core.isType(path, String) && directory_exists(path)
  }

  ///@param {?String} path
  ///@return {FileUtil}
  static createDirectory = function(path) {
    var posixPath = FileUtil.get(path)
    if (Core.isType(posixPath, String) && !this.directoryExists(posixPath)) {
      Logger.info("FileUtil", $"Create directory '{posixPath }'")
      directory_create(posixPath)
    }
    return this
  }

  ///@param {?String} file - path to file
  ///@param {?String} path - path to new file or target directory
  ///@return {FileUtil}
  static copyFile = function(_file, path) {
    var file = FileUtil.get(_file)
    var type = FileUtil.getPathType(path)
    if (!Optional.is(type)) {
      return this
    }

    var target = FileUtil.get(path)
    switch (type) {
      case PathType.FILE: break
      case PathType.DIRECTORY:
        target = String.getLastChar(target) == "/" ? target : $"{target}/"
        target = $"{target}{FileUtil.getFilenameFromPath(file)}"
        break
      default:
        Logger.error("FileUtil", $"Found unsupported PathType: '{type}'")
        return this
    }

    var rootPath = String.replaceAll(String.replaceAll(working_directory, "\\", "/"), "//", "/") 
    var arePathsEqual = String.contains(String.toLowerCase(file), String.toLowerCase(rootPath))
      ? String.toLowerCase(target) == String.toLowerCase(file)
      : String.toLowerCase(target) == $"{String.toLowerCase(rootPath)}{String.toLowerCase(file)}" 

    if (file == target || arePathsEqual) {
      Logger.info("FileUtil", $"Skip copying, paths are the same: file: '{file}', target: '{target}'")
      return this
    }

    Logger.info("FileUtil", $"Copy file '{file}' to '{target}'")
    file_copy(file, target)
    return this
  }

  ///@param {String} _path
  ///@throws {FileNotFoundException}
  ///@return {File}
  static readFileSync = function(_path) {
    var path = FileUtil.get(_path)
    if (!FileUtil.fileExists(path)) {
      throw new FileNotFoundException(_path)
    }

    var file = file_text_open_read(path)
    if (file == -1) {
      throw new FileNotFoundException(path)
    }

    var data = ""
    while (!file_text_eof(file)) {
      var line = file_text_read_string(file)
      data = data + line + "\n"
      file_text_readln(file)
    }
    file_text_close(file)
    Logger.debug("FileUtil", $"fetch-file-sync successfully: {path}")
    return new File({ path: path, data: data })
  }

  ///@param {File} file
  ///@throws {FileNotFoundException}
  ///@return {FileUtil}
  static writeFileSync = function(file) {
    var path = file.getPath()
    var _file = file_text_open_write(path)
    if (_file == -1) {
      throw new FileNotFoundException(path)
    }

    file_text_write_string(_file, file.getData())
    file_text_close(_file)
    Logger.info("File", $"save-file-sync successfully: {path}")
  }

  ///@param {String} _path
  ///@param {String} [mask]
  ///@param {FileAttribute} [attribute]
  ///@param {Boolean} [appendPath]
  ///@return {Array<String>}
  static listDirectory = function(_path, mask = "*", attribute = FileAttribute.NONE, appendPath = false) {
    var path = FileUtil.get(_path)
    var list = new Array(String)
    if (!FileUtil.directoryExists(path)) {
      return list
    }

    var filename = file_find_first($"{path}{mask}", attribute)
    while (filename != "") {
      list.add(appendPath ? $"{path}{filename}" : filename)
      filename = file_find_next()
    }

    return list
  }
}
global.__FileUtil = new _FileUtil()
#macro FileUtil global.__FileUtil
