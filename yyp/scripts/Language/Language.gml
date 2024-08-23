///@pacakge io.alkapivo.core.util

///@enum
function _LanguageType(): Enum() constructor {
  en_US = "en_US"
  pl_PL = "pl_PL"
}

global.__LanguageType = new _LanguageType()
#macro LanguageType global.__LanguageType


///@param {Struct} json
function LanguagePack(json) constructor {

  ///@type {LanguageType}
  code = Assert.isEnum(json.code, LanguageType)

  ///@private
  ///@type {Map<String, String>}
  labels = new Map(String, String)
  if (Core.isType(Struct.get(json, "labels"), Struct)) {
    Struct.forEach(json.labels, function(value, key, labels) {
      Logger.debug("LanguagePack", $"Load label {key}")
      labels.set(key, value)
    }, this.labels)
  }
}

///@static
function _Language() constructor {

  ///@type {?LanguagePack}
  pack = null

  ///@type {?LanguagePack}
  //?@return {Language}
  apply = function(pack) {
    if (Core.isType(pack, LanguagePack)) {
      this.pack = pack
    } else {
      this.pack = null
    }
    return this
  }

  ///@type {String} key
  ///@type {any} [...params]
  ///@return {String}
  get = function(key/*, ...params */) {
    if (!Core.isType(this.pack, LanguagePack)) {
      return ""
    }

    var label = this.pack.labels.get(key)
    if (!Core.isType(label, String)) {
      return ""
    }

    if (argument_count > 1) {
      for (var index = 1; index < argument_count; index++) {
        label = String.replaceAll(label, "{" + string(index - 1) + "}", argument[index])
      }
    }

    return label
  }

  ///@return {LanguageType}
  getCode = function() {
    if (!Core.isType(this.pack, LanguagePack)) {
      return LanguageType.en_US
    }

    return this.pack.code
  }
}
#macro Language global.__Language
global.__Language = null


///@param {LanguageType} code
function initLanguage(code) {
  Language = new _Language()
  var path = null
  switch (code) {
    case LanguageType.en_US: path = $"{working_directory}language.en_US.json" break
    case LanguageType.pl_PL: path = $"{working_directory}language.pl_PL.json" break
    default: path = $"{working_directory}language.en_US.json" break
  }
  
  var json = FileUtil.readFileSync(FileUtil.get(path)).getData()
  JSON.parserTask(json, {
    callback: function(prototype, json, index, acc) {
      Core.print("json", json)
      Language.apply(new prototype(json)) 
    },
    acc: this,
  }).update()
}