///@package io.alkapivo.core.lang.Bean

///@param {String} _message
function BeanAlreadyExistsException(_message): Exception(_message) constructor { }


///@param {String} _name
///@param {Prototype} _prototype
///@param {GMObject} _instance
function Bean(_name, _prototype, _instance) constructor {

  ///@type {String}
  name = Assert.isType(_name, String,
    "Bean.name must be of type String")

  ///@type {Prototype}
  prototype = Assert.isType(_prototype, Prototype,
    "Bean.prototype must be of type Prototype")

  ///@type {GMObject}
  instance = Assert.isType(_instance, GMObject)
  Assert.isType(GMObjectUtil.get(this.instance, "__context"), this.prototype,
    "Bean.instance must be of type GMObject")

  ///@return {?Struct}
  get = function() {
    return Core.isType(this.instance, GMObject)
      ? Core.getIfType(GMObjectUtil.get(this.instance, "__context"), this.prototype)
      : null
  }

  ///@return {Bean}
  free = function() {
    GMObjectUtil.free(this.instance)
    this.instance = null
    return this
  }
}


///@static
function _Beans() constructor {

  ///@private
  ///@type {Map<String, Bean>} 
  beans = new Map(String, Bean)

  ///@private
  ///@type {Stack<String>}
  gc = new Stack(String)
  
  ///@private
  ///@type {Timer}
  timer = new Timer(FRAME_MS, { loop: Infinity, callback: this.healthcheck })

  ///@private
  ///@type {Boolean}
  _useHealthcheck = true

  ///@param {String} name
  ///@return {Boolean}
  static exists = function(name) {
    gml_pragma("forceinline")
    if (this.beans.contains(name)) {
      var bean = this.beans.get(name)
      if (!Core.isType(bean, Bean)) {
        Logger.warn("Beans", $"Found non-bean entity: {name}")
        this.remove(name)
        return false
      }

      if (bean.get() == null) {
        Logger.warn("Beans", $"Found corrupted bean: {name}")
        this.kill(name)
        return false
      }

      return true
    }

    return false
  }

  ///@param {String} name
  ///@return {?Struct}
  static get = function(name) {
    gml_pragma("forceinline")
    if (this.exists(name)) {
      return this.beans.get(name).get()
    }
    
    //Logger.debug("Beans", $"Trying to get non-existing bean '{name}'")
    return null
  }

  ///@param {String} name
  ///@return {?Bean}
  static getBean = function(name) {
    gml_pragma("forceinline")
    if (this.exists(name)) {
      return this.beans.get(name)
    }
    
    //Logger.debug("Beans", $"Trying to get non-existing bean '{name}'")
    return null
  }

  ///@param {String} name
  ///@param {GMObjectType} type
  ///@param {LayerID} layerId
  ///@param {Struct} context
  ///@return {Bean}
  static factory = function(name, type, layerId, context) {
    gml_pragma("forceinline")
    return new Bean(name, Core
      .getConstructor(context), GMObjectUtil
      .factoryStructInstance(type, layerId, context))
  }

  ///@param {Bean} bean
  ///@throws {BeanAlreadyExistsException}
  ///@return {Beans}
  static add = function(bean) {
    gml_pragma("forceinline")
    if (this.exists(bean.name)) {
      throw new BeanAlreadyExistsException(
        $"Bean already exists: '{name}'")
    }

    Logger.info("Beans", this.beans.contains(bean.name)
      ? $"Update existing bean: {bean.name}"
      : $"Set new bean: {bean.name}")

    bean.instance.__bean = bean.name
    this.beans.set(bean.name, bean)

    return this
  }

  ///@param {String}
  ///@return {Beans}
  static kill = function(name) {
    gml_pragma("forceinline")
    var bean = this.beans.get(name)
    if (Core.isType(bean, Bean)) {
      Logger.info("Beans", $"Kill bean: {name}\n", bean)
      bean.free()
      this.remove(name)
    }

    return this
  }

  ///@param {String} name
  ///@return {Beans}
  static remove = function(name) {
    gml_pragma("forceinline")
    Logger.info("Beans", $"Remove bean: {name}")
    this.beans.remove(name)
    return this
  }

  ///@private
  ///@return {Beans}
  static healthcheck = function() {
    gml_pragma("forceinline")
    static checkBeanHealth = function(bean, name, gc) {
      if (!Core.isType(bean, Bean) || !Core.isType(bean.asset, bean.prototype)) {
        gc.push(name)
      }
    }

    static gcBean = function(name, index, beans) {
      Logger.info("Beans", $"delete `{name}`")
      beans.remove(name)
    }

    this.beans.forEach(checkBeanHealth, this.gc)
    if (this.gc.size() > 0) {
      Logger.info("Beans", $"Healthcheck detected corrupted beans: {this.gc.size()}")
      this.gc.forEach(gcBean, this.beans)
    }

    return this
  }

  ///@param {Number} interval
  ///@return {Beans}
  static setHealthcheckInterval = function(interval) {
    gml_pragma("forceinline")
    this.timer.changeDuration(interval)
    return this
  }

  ///@param {Boolean} use
  ///@return {Beans}
  static useHealthcheck = function(use) {
    gml_pragma("forceinline")
    this._useHealthcheck = use
    return this
  }

  ///@return {Beans}
  static update = function() {
    gml_pragma("forceinline")
    if (this._useHealthcheck) {
      this.timer.update()
    }

    return this
  }
}
global.__Beans = null
#macro Beans global.__Beans


function initBeans() {
  if (global.__Beans == null) {
    global.__Beans = new _Beans()
  }
}
