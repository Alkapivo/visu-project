///@package io.alkapivo.core.util.Settings

///@enum
function _SettingTypes(): Enum() constructor {
  BOOLEAN = "BOOLEAN"
  NUMBER = "NUMBER"
  STRING = "STRING"
  STRUCT = "STRUCT"
}
global.__SettingTypes = new _SettingTypes()
#macro SettingTypes global.__SettingTypes


///@param {Struct} json
function SettingEntry(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {SettingTypes}
  type = Assert.isEnum(json.type, SettingTypes)

  ///@param {any} value
  ///@throws {AssertException}
  ///@return {any}
  validate = function(value) {
    switch (this.type) {
      case SettingTypes.BOOLEAN: return Assert.isType(value, Boolean)
      case SettingTypes.NUMBER: return Assert.isType(value, Number)
      case SettingTypes.STRING: return Assert.isType(value, String)
      case SettingTypes.STRUCT: return Assert.isType(value, Struct)
      default: throw new AssertException($"SettinghType '{this.type}'")
    }
    return this.value
  }

  ///@type {any}
  defaultValue = this.validate(json.defaultValue)

  ///@type {any}
  value = null
  try {
    value = Optional.is(Struct.get(json, "value")) ? this.validate(Struct.get(json, "value")) : this.defaultValue
  } catch (exception) {
    Logger.error("SettingEntry", $"Unable to set value for SettingEntry '{this.name}'. {exception.message}")
    value = this.defaultValue
  }

  ///@param {any} value
  ///@throws {AssertException}
  ///@return {SettingEntry}  
  set = function(value) {
    this.value = this.validate(value)
    return this
  }

  ///@return {any}
  get = function() {
    return this.value
  }

  ///@return {Struct}
  serialize = function() {
    return {
      name: this.name,
      type: this.type,
      defaultValue: this.defaultValue,
      value: this.get(),
    }
  }
}


function Settings(_path) constructor {

  ///@type {Map<String, SettingEntry>}
  container = new Map(String, SettingEntry)

  ///@type {String}
  path = Assert.isType(_path, String)

  ///@param {String} name
  ///@return {any}
  get = function(name) {
    return container.get(name)
  }

  ///@param {String} name
  ///@param {any} [defaultValue]
  ///@return {any}
  getValue = function(name, defaultValue = null) {
    var settingEntry = container.get(name)
    return Core.isType(settingEntry, SettingEntry)
      ? settingEntry.get()
      : defaultValue
  }

  ///@param {SettingEntry} settingEntry
  ///@return {Settings}
  set = function(settingEntry) {
    this.container.set(settingEntry.name, settingEntry)
    return this
  }

  ///@param {String} name
  ///@param {any} value
  ///@return {Settings}
  setValue = function(name, value) {
    var settingEntry = this.container.get(name)
    if (Core.isType(settingEntry, SettingEntry)) {
      settingEntry.set(value)
    }
    return this
  }

  ///@param {String} name
  remove = function(name) {
    this.container.remove(name)
    return this
  }

  ///@return {Settings}
  load = function() {
    if (!FileUtil.fileExists(this.path)) {
      Logger.info("Settings", $"Settings file does not exists. Creating default at '{this.path}'")
      this.save()
    }

    try {
      var file = FileUtil.readFileSync(this.path)
      var data = JSON.parse(file.getData()).data
      GMArray.forEach(data, function(entry, index, settings) {
        Logger.info("Settings", $"Load SettingEntry '{entry.name}'")
        settings.set(new SettingEntry(entry))
      }, this)
    } catch (exception) {
      Logger.error("Settings", $"Corrupted settings '{path}'. {exception.message}")
    }
    
    return this
  }

  ///@return {Settings}
  save = function() {
    var json = {
      "version":"1",
      "model":"Collection<io.alkapivo.core.util.SettingEntry>",
      "data": this.container.toArray(function(settingsEntry) {
        return settingsEntry.serialize()
      }, null, Struct).getContainer()
    }
    
    FileUtil.writeFileSync(new File({ path: this.path, data: JSON.stringify(json, { pretty: true }) }))
    return this
  }
}