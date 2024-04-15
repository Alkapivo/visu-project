///@package io.alkapivo.core.service.ui

///@param {UI} _container
///@param {?Struct} [config]
function UICollection(_container, config = null) constructor {
  
  ///@param {UI}
  container = Assert.isType(_container, UI)

  ///@param {UILayout}
  layout = Assert.isType(Struct.get(config, "layout"), UILayout)

  ///@param {Collection}
  components = Struct.contains(config, "components")
    ? Assert.isType(config.components, Collection) 
    : new Map(String, Struct)

  ///@param {any} key
  ///@return {?Struct}
  get = Struct.contains(config, "get")
    ? Assert.isType(method(this, config.get), Callable)
    : function(key) {
      return this.components.get(key) 
    }

    ///@return {Number}
  size = Struct.contains(config, "size")
    ? Assert.isType(method(this, config.size), Callable)
    : function() {
      return this.components.size() 
    }

  ///@param {Number} index
  ///@return {any}
  findByIndex = Struct.contains(config, "findByIndex")
    ? Assert.isType(method(this, config.findByIndex), Callable)
    : function(index) {
      static findComponent = function(component, key, index) {
        return component.index == index
      }
      return this.components.find(findComponent, index)
    }

  ///@param {Number} index
  ///@return {any}
  findKeyByIndex = Struct.contains(config, "findKeyByIndex")
    ? Assert.isType(method(this, config.findKeyByIndex), Callable)
    : function(index) {
      static findComponent = function(component, key, index) {
        return component.index == index
      }
      return this.components.findKey(findComponent, index)
    }

  ///@param {any} key
  ///@return {Boolean}
  contains = Struct.contains(config, "contains")
    ? Assert.isType(method(this, config.contains), Callable)
    : function(key) {
      return this.components.contains(key)
    }

  ///@param {Number} index
  ///@return {Boolean}
  containsIndex = Struct.contains(config, "containsIndex")
    ? Assert.isType(method(this, config.containsIndex), Callable)
    : function(index) {
      var size = this.size()
      return size == 0 ? false : (index >= 0 && index < size)
    }

  ///@param {UIComponent} component
  ///@param {?Number} [index]
  ///@return {UICollection}
  add = Struct.contains(config, "add")
    ? Assert.isType(method(this, config.add), Callable)
    : function(component, index = null) {
      static updateIndex = function(component, key, index) {
        if (component.index >= index) {
          component.index = component.index + 1
        }
      }

      static updateItems = function(component) { 
        component.items.forEach(function(item, index, component) {
          Struct.set(item, "component", component)
          if (Optional.is(item.updateArea)) {
            item.updateArea()
          }
        }, component)
      }

      static add = function(item, index, container) {
        container.add(item, item.name)
      }

      if (this.contains(component.name)) {
        Logger.warn("UICollection", $"Cannot add component '{component.name}', because component already exists")
        return this
      }

      var size = this.size()
      var idx = index == null ? size : (this.containsIndex(index) ? index : size)
      var item = {
        index: idx,
        name: component.name,
        items: component.toUIItems(this.layout),
      }
      
      item.items
        .forEach(add, this.container)
      this.components
        .forEach(updateIndex, idx)
        .add(item, item.name)
        .forEach(updateItems)
      return this
    }

  ///@param {Number} index
  ///@return {UICollection}
  remove = Struct.contains(config, "remove")
    ? Assert.isType(method(this, config.remove), Callable)
    : function(index) {
      static update = function(component, key, index) {
        if (component.index > index) {
          component.index = component.index - 1
        }
        component.items.forEach(function(item, index, component) {
          Struct.set(item, "component", component)
        }, component)
      }

      static remove = function(item, index, container) {
        container.remove(item.name)
      }

      var key = this.findKeyByIndex(index)
      if (!Optional.is(key)) {
        return
      }

      var component = this.components.get(key)
      component.items.forEach(remove, this.container)
      this.components
        .forEach(update, index)
        .remove(key)
      return this
    }

  
  ///@param {any} key
  ///@return {UICollection}
  removeKey = Struct.contains(config, "removeKey")
    ? Assert.isType(method(this, config.removeKey), Callable)
    : function(key) {
      var component = this.components.get(key)
      return Optional.is(component) ? this.remove(component.index) : this
    }
}
