///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
function VEStatusBar(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

    ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "status-bar",
        nodes: {
          ws: {
            name: "status-bar.ws",
            x: function() { return this.context.nodes.stateLabel.left() 
              - this.width() },
            y: function() { return 0 },
            margin: { left: 4 },
            width: function() { return 58 },
          },
          topLine: {
            name: "status-bar.topLine",
            x: function() { return 0 },
            y: function() { return 0 },
            width: function() { return this.context.width() },
            height: function() { return 1 },
          },
          stateLabel: {
            name: "status-bar.stateLabel",
            x: function() { return this.context.nodes.stateValue.left() 
              - this.width() },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          stateValue: {
            name: "status-bar.stateValue",
            x: function() { return this.context.nodes.videoLabel.left() 
              - this.width() },
            y: function() { return 0 },
            margin: { left: 4 },
            width: function() { return 52 },
          },
          videoLabel: {
            name: "status-bar.videoLabel",
            x: function() { return this.context.nodes.videoValue.left() 
              - this.width() },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          videoValue: {
            name: "status-bar.videoValue",
            x: function() { return this.context.x() + this.context.width()
              - this.width() },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 64 },
          },
        }
      },
      parent
    )
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  __factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "status-bar",
        nodes: {
          fpsLabel: {
            name: "status-bar.fpsLabel",
            x: function() { return this.context.x() + this.margin.left },
            y: function() { return 0 },
            width: function() { return 32 },
          },
          fpsValue: {
            name: "status-bar.fpsValue",
            x: function() { return this.context.nodes.fpsLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 24 },
          },
          timestampLabel: {
            name: "status-bar.timestampLabel",
            x: function() { return this.context.nodes.fpsValue.right() + this.margin.left },
            y: function() { return 0 },
            width: function() { return 34 },
          },
          timestampValue: {
            name: "status-bar.timestampValue",
            x: function() { return this.context.nodes.timestampLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 48 },
          },
          durationLabel: {
            name: "status-bar.durationLabel",
            x: function() { return this.context.nodes.timestampValue.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 52 },
          },
          durationValue: {
            name: "status-bar.durationValue",
            x: function() { return this.context.nodes.durationLabel.right()
              + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 48 },
          },
          bpmLabel: {
            name: "status-bar.bpmLabel",
            x: function() { return this.context.nodes.durationValue.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 30 },
          },
          bpmValue: {
            name: "status-bar.bpmValue",
            x: function() { return this.context.nodes.bpmLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 32 },
          },
          bpmCountLabel: {
            name: "status-bar.bpmCountLabel",
            margin: { left: 4 },
            x: function() { return this.context.nodes.bpmValue.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 44 },
          },
          bpmCountValue: {
            name: "status-bar.bpmCountValue",
            x: function() { return this.context.nodes.bpmCountLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 32 },
          },
          bpmSubLabel: {
            name: "status-bar.bpmSubLabel",
            margin: { left: 4 },
            x: function() { return this.context.nodes.bpmCountValue.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 30 },
          },
          bpmSubValue: {
            name: "status-bar.bpmSubValue",
            x: function() { return this.context.nodes.bpmSubLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 32 },
          },
          gameModeLabel: {
            name: "status-bar.gameModeLabel",
            x: function() { return this.context.nodes.bpmSubValue.right()
              + this.margin.left },
            y: function() { return 0 },
            width: function() { return 46 },
          },
          gameModeValue: {
            name: "status-bar.gameModeValue",
            x: function() { return this.context.nodes.gameModeLabel.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 74 },
          },
          autosaveLabel: {
            name: "status-bar.autosaveLabel",
            x: function() { return this.context.nodes.gameModeValue.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 6 },
            width: function() { return 64 },
          },
          autosaveCheckbox: {
            name: "status-bar.autosaveLabel",
            x: function() { return this.context.nodes.autosaveLabel.right() + this.margin.left },
            y: function() { return 0 },
            width: function() { return 24 },
          },
          updateLabel: {
            name: "status-bar.updateLabel",
            x: function() { return this.context.nodes.autosaveCheckbox.right() + this.margin.left },
            y: function() { return 0 },
            margin: { left: 6 },
            width: function() { return 48 },
          },
          updateCheckbox: {
            name: "status-bar.updateLabel",
            x: function() { return this.context.nodes.updateLabel.right() + this.margin.left },
            y: function() { return 0 },
            width: function() { return 24 },
          },
          ws: {
            name: "status-bar.ws",
            x: function() { return this.context.nodes.stateLabel.left() 
              - this.width() },
            y: function() { return 0 },
            margin: { left: 4 },
            width: function() { return 58 },
          },
          stateLabel: {
            name: "status-bar.stateLabel",
            x: function() { return this.context.nodes.stateValue.left() 
              - this.width() },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          stateValue: {
            name: "status-bar.stateValue",
            x: function() { return this.context.nodes.videoLabel.left() 
              - this.width() },
            y: function() { return 0 },
            margin: { left: 4 },
            width: function() { return 52 },
          },
          videoLabel: {
            name: "status-bar.videoLabel",
            x: function() { return this.context.nodes.videoValue.left() 
              - this.width() },
            y: function() { return 0 },
            width: function() { return 48 },
          },
          videoValue: {
            name: "status-bar.videoValue",
            x: function() { return this.context.x() + this.context.width()
              - this.width() },
            y: function() { return 0 },
            margin: { left: 2 },
            width: function() { return 64 },
          }
        }
      }, 
      parent
    )
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Map<String, UI>}
  factoryContainers = function(parent) {
    static factoryLabel = function(json) {
      var struct = {
        type: UIText,
        layout: json.layout,
        text: json.text,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      }

      if (Struct.contains(json, "onMouseReleasedLeft")) {
        Struct.set(struct, "onMouseReleasedLeft", json.onMouseReleasedLeft)
      }

      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("ve-status-bar").label,
        false
      )
    }

    static factoryValue = function(json) {
      var struct = {
        type: UIText,
        layout: json.layout,
        text: "VALUE",
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        updateCustom: json.updateCustom,
      }

      if (Struct.contains(json, "onMouseReleasedLeft")) {
        Struct.set(struct, "onMouseReleasedLeft", json.onMouseReleasedLeft)
      }

      if (Struct.contains(json, "backgroundColor")) {
        Struct.set(struct, "backgroundColor", json.backgroundColor)
      }
      
      if (Struct.contains(json, "align")) {
        Struct.set(struct, "align", json.align)
      }

      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("ve-status-bar").value,
        false
      )
    }

    static factoryBPMField = function(json) {
      var struct = {
        type: UITextField,
        layout: json.layout,
        text: 60,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        config: {
          key: "bpm",
        },
        store: {
          key: "bpm",
          callback: function(value, data) { 
            var item = data.store.get("bpm")
            if (item == null) {
              return 
            }

            var bpm = item.get()
            if (!Core.isType(bpm, Number)) {
              return 
            }
            data.textField.setText(string(bpm))
          },
          set: function(value) {
            var item = this.get()
            if (item == null) {
              return 
            }

            var parsedValue = NumberUtil.parse(value, null)
            if (parsedValue == null) {
              return
            }
            item.set(parsedValue)

            Struct.set(Beans.get(BeanVisuController).track, "bpm", parsedValue)
          },
        },
      }

      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("text-field"),
        false
      )
    }

    static factoryCountField = function(json) {
      var struct = {
        type: UITextField,
        layout: json.layout,
        text: 0,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        config: { key: "bpm-count" },
        store: {
          key: "bpm-count",
          callback: function(value, data) { 
            var item = data.store.get("bpm-count")
            if (item == null) {
              return 
            }

            var bpmCount = item.get()
            if (!Core.isType(bpmCount, Number)) {
              return 
            }
            data.textField.setText(string(bpmCount))
          },
          set: function(value) {
            var item = this.get()
            if (item == null) {
              return 
            }

            var parsedValue = NumberUtil.parse(value, null)
            if (parsedValue == null) {
              return
            }
            item.set(parsedValue)

            Struct.set(Beans.get(BeanVisuController).track, "bpmCount", parsedValue)
          },
        },
      }

      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("text-field"),
        false
      )
    }

    static factorySubField = function(json) {
      var struct = {
        type: UITextField,
        layout: json.layout,
        text: 0,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        config: { key: "bpm-sub" },
        store: {
          key: "bpm-sub",
          callback: function(value, data) { 
            var item = data.store.get("bpm-sub")
            if (item == null) {
              return 
            }

            var bpmSub = item.get()
            if (!Core.isType(bpmSub, Number)) {
              return 
            }
            data.textField.setText(string(bpmSub))
          },
          set: function(value) {
            var item = this.get()
            if (item == null) {
              return 
            }

            var parsedValue = NumberUtil.parse(value, null)
            if (parsedValue == null) {
              return
            }
            item.set(parsedValue)

            Struct.set(Beans.get(BeanVisuController).track, "bpmSub", parsedValue)
          },
        },
      }

      return Struct.appendRecursiveUnique(
        struct,
        VEStyles.get("text-field"),
        false
      )
    }

    static factoryCheckbox = function(json) {
      var struct = {
        type: UICheckbox,
        value: Struct.get(json, "value") == true,
        layout: json.layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
      }

      if (Struct.contains(json, "callback")) {
        Struct.set(struct, "callback", json.callback)
      }

      return Struct.appendRecursiveUnique(
        struct,
        {
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
        },
        false
      )
    }

    var controller = this
    var layout = this.factoryLayout(parent)
    var autosaveEnabled = Beans.get(BeanVisuEditorController).autosave.value
    var updateServices = Beans.get(BeanVisuEditorController).updateServices
    return new Map(String, UI, {
      "ve-status-bar": new UI({
        name: "ve-status-bar",
        state: new Map(String, any, {
          "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          "components": new Array(Struct, [
            {
              name: "ve-status-bar_fps-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 36 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "FPS" },
              },
            },
            {
              name: "ve-status-bar_fps-value",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 24 },
                  margin: { left: 2, right: 2 },
                },
                label: {
                  text: string(GAME_FPS),
                  updateCustom: (Core.getProperty("visu.editor.status-bar.render-average-fps", true)
                    ? function() { this.label.text = string(fps) }
                    : function() { this.label.text = string(clamp(ceil(fps_real + 1), 0, 60)) }),
                },
              },
            },
            {
              name: "ve-status-bar_fps-value-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_time-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 42 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "Time" },
              },
            },
            {
              name: "ve-status-bar_time-value",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 42 },
                  margin: { left: 2, right: 2 },
                },
                label: {
                  text: "N/A",
                  updateCustom: function() {
                    try {
                      var trackService = Beans.get(BeanVisuController).trackService
                      this.label.text = trackService.isTrackLoaded()
                        ? String.formatTimestamp(trackService.time)
                        : "N/A"
                    } catch (exception) {
                      this.label.text = "N/A"
                    }
                  },
                },
              },
            },
            {
              name: "ve-status-bar_time-value-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_duration-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 64 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "Duration" },
              },
            },
            {
              name: "ve-status-bar_duration-value",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 42 },
                  margin: { left: 2, right: 2 },
                },
                label: {
                  text: "N/A",
                  updateCustom: function() {
                    try {
                      var trackService = Beans.get(BeanVisuController).trackService
                      this.label.text = trackService.isTrackLoaded()
                        ? String.formatTimestamp(trackService.duration)
                        : "N/A"
                    } catch (exception) {
                      this.label.text = "N/A"
                    }
                  },
                },
              },
            },
            {
              name: "ve-status-bar_duration-value-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_bpm-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 38 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "BPM" },
              },
            },
            {
              name: "ve-status-bar_bpm-field",
              template: VEComponents.get("text-field-simple"),
              layout: VELayouts.get("text-field-simple"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 36 },
                  //height: function() { return 24 },
                  margin: { left: 2, right: 2, top: 2, bottom: 2 },
                },
                field: {
                  GMTF_DECIMAL: 0,
                  store: {
                    key: "bpm",
                    callback: function(value, data) { 
                      var item = data.store.get("bpm")
                      if (item == null) {
                        return 
                      }
          
                      var bpm = item.get()
                      if (!Core.isType(bpm, Number)) {
                        return 
                      }

                      data.textField.setText(bpm)
                    },
                    set: function(value) {
                      var item = this.get()
                      if (item == null) {
                        return 
                      }
          
                      var parsedValue = NumberUtil.parse(value, null)
                      if (parsedValue == null) {
                        return
                      }

                      item.set(parsedValue)
                      Struct.set(Beans.get(BeanVisuController).track, "bpm", parsedValue)
                    },
                  },
                },
              },
            },
            {
              name: "ve-status-bar_bpm-field-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_bpm-count-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 48 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "Meter" },
              },
            },
            {
              name: "ve-status-bar_bpm-count-field",
              template: VEComponents.get("text-field-simple"),
              layout: VELayouts.get("text-field-simple"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 36 },
                  //height: function() { return 24 },
                  margin: { left: 2, right: 2, top: 2, bottom: 2},
                },
                field: {
                  text: "10",
                  config: { key: "bpm-count" },
                  store: {
                    key: "bpm-count",
                    callback: function(value, data) { 
                      var item = data.store.get("bpm-count")
                      if (item == null) {
                        return 
                      }
          
                      var bpm = item.get()
                      if (!Core.isType(bpm, Number)) {
                        return 
                      }
                      data.textField.setText(string(bpm))
                    },
                    set: function(value) {
                      var item = this.get()
                      if (item == null) {
                        return 
                      }
          
                      var parsedValue = NumberUtil.parse(value, null)
                      if (parsedValue == null) {
                        return
                      }
                      item.set(parsedValue)
          
                      Struct.set(Beans.get(BeanVisuController).track, "bpmCount", parsedValue)
                    },
                  },
                  margin: { left: 2, right: 2 },
                },
              },
            },
            {
              name: "ve-status-bar_bpm-count-field-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_bpm-sub-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 36 },
                  margin: { left: 2, right: 2 },
                },
                label: { text: "Sub" },
              },
            },
            {
              name: "ve-status-bar_bpm-sub-field",
              template: VEComponents.get("text-field-simple"),
              layout: VELayouts.get("text-field-simple"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 36 },
                  //height: function() { return 24 },
                  margin: { left: 2, right: 2, top: 2, bottom: 2 },
                },
                field: {
                  text: "10",
                  config: { key: "bpmSub" },
                  store: {
                    key: "bpm-sub",
                    callback: function(value, data) { 
                      var item = data.store.get("bpm-sub")
                      if (item == null) {
                        return 
                      }
          
                      var bpm = item.get()
                      if (!Core.isType(bpm, Number)) {
                        return 
                      }
                      data.textField.setText(string(bpm))
                    },
                    set: function(value) {
                      var item = this.get()
                      if (item == null) {
                        return 
                      }
          
                      var parsedValue = NumberUtil.parse(value, null)
                      if (parsedValue == null) {
                        return
                      }
                      item.set(parsedValue)
          
                      Struct.set(Beans.get(BeanVisuController).track, "bpmSub", parsedValue)
                    },
                  },
                  margin: { left: 2, right: 2 },
                },
              },
            },
            {
              name: "ve-status-bar_bpm-sub-field-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_autosave-checkbox",
              template: VEComponents.get("checkbox"),
              layout: VELayouts.get("checkbox"),
              config: { 
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 28 },
                },
                checkbox: {
                  spriteOn: { name: "visu_texture_checkbox_on" },
                  spriteOff: { name: "visu_texture_checkbox_off" },
                  value: autosaveEnabled,
                  callback: function() {
                    var editor = Beans.get(BeanVisuEditorController)
                    editor.autosave.value = this.value
                    Visu.settings.setValue("visu.editor.autosave", this.value).save()
                    if (!editor.autosave.value) {
                      editor.autosave.timer.time = 0
                    }
                  },
                },
              },
            },
            {
              name: "ve-status-bar_autosave-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 64 },
                  margin: { left: 0, right: 2 },
                },
                label: { text: "Autosave" },
              },
            },
            {
              name: "ve-status-bar_autosave-label-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
            {
              name: "ve-status-bar_update-checkbox",
              template: VEComponents.get("checkbox"),
              layout: VELayouts.get("checkbox"),
              config: { 
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 28 },
                },
                checkbox: {
                  value: updateServices,
                  spriteOn: { name: "visu_texture_checkbox_on" },
                  spriteOff: { name: "visu_texture_checkbox_off" },
                  callback: function() {
                    var editor = Beans.get(BeanVisuEditorController)
                    editor.updateServices = !editor.updateServices
                  },
                },
              },
            },
            {
              name: "ve-status-bar_update-label",
              template: VEComponents.get("label"),
              layout: VELayouts.get("label"),
              config: {
                layout: { 
                  type: UILayoutType.HORIZONTAL,
                  width: function() { return 56 },
                  margin: { left: 0, right: 2 },
                },
                label: { text: "Update" },
              },
            },
            {
              name: "ve-status-bar_update-label-line-w",
              template: VEComponents.get("line-w"),
              layout: VELayouts.get("line-w"),
              config: { layout: { type: UILayoutType.HORIZONTAL } },
            },
          ]),
        }),
        controller: controller,
        layout: layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        items: {
          "text_ve-status-ws": factoryValue({
            layout: layout.nodes.ws,
            updateCustom: function() {
              try {
                var server = Beans.get(BeanVisuController).server
                this.label.text = server.isRunning() ? $"ws: {server.port}" : ""
              } catch (exception) {
                Logger.error("VEStatusBar", exception.message)
                this.label.text = ""
              }
            },
          }),
          "text_ve-status-bar_stateLabel": factoryLabel({
            text: "State",
            layout: layout.nodes.stateLabel,
          }),
          "text_ve-status-bar_stateValue": factoryValue({
            layout: layout.nodes.stateValue,
            updateCustom: function() {
              try {
                this.label.text = String.toUpperCase(Beans
                  .get(BeanVisuController).fsm
                  .getStateName())
              } catch (exception) {
                this.label.text = "N/A"
              }
            },
          }),
          "text_ve-status-bar_videoLabel": factoryLabel({
            text: "Video",
            layout: layout.nodes.videoLabel,
          }),
          "text_ve-status-bar_videoValue": factoryValue({
            layout: layout.nodes.videoValue,
            updateCustom: function() {
              try {
                this.label.text = Beans
                  .get(BeanVisuController).videoService
                  .getVideo()
                  .getStatusName()
              } catch (exception) {
                this.label.text = "N/A"
              }
            },
          }),
          "line_ve-status-bar_topLine": {
            type: UIImage,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            layout: layout.nodes.topLine,
            backgroundColor: VETheme.color.accentShadow,
            backgroundAlpha: 0.85,
          },
        },
        onInit: function() {
          var components = this.state.get("components")
          this.state.set("store", Beans.get(BeanVisuEditorController).store)
          this.addUIComponents(components
            .map(function(component) {
              return new UIComponent(component)
            }),
            new UILayout({
              area: this.area,
              height: function() { return this.area.getHeight() },
            })
          )
        },
      }),
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.containers = this.factoryContainers(event.data.layout)
      containers.forEach(function(container, key, uiService) {
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService)
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function(container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VEBrushToolbar}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VEStatusBar dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}