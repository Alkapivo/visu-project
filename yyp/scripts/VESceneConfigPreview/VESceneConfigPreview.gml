///@package io.alkapivo.visu.editor.ui.controller

///@param {?Struct} [_config]
function VESceneConfigPreview(_config = null) constructor {

  ///@type {?Struct}
  config = Optional.is(_config) ? Assert.isType(_config, Struct) : null

  ///@type {Store}
  store = new Store({ })

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "ve-scene-config-preview",
        margin: { left: 56, right: 56, top: 56, bottom: 112 },
      },
      parent
    )
  }

  ///@type {Struct}
  factorySceneConfig = {
    
    ///@return {String}
    effect: function() {
      static factoryParticleEmitters = function(particleService) {
        var stringBuilder = new StringBuilder()
        particleService.systems.get("main").executor.tasks.forEach(function(task, iteator, stringBuilder) {
          if (task.name != "emmit-particle") {
            return
          }

          var particle = task.state.get("particle")
          var amount = task.state.get("amount")
          var duration = Core.isType(task.timeout, Timer) ? task.timeout.time : "N/A"
          var interval = Core.isType(task.tick, Timer) ? task.tick.time : "N/A"
          var vec = task.state.get("coords")
          stringBuilder.append($"      - ParticleTemplate: {particle.name}\n"
            + $"        Amount: {amount}\n"
            + $"        Duration: {duration}\n"
            + $"        Interval: {interval}\n"
            + $"        Area:\n"
            + $"          X: {vec.x}\n"
            + $"          Y: {vec.y}\n"
            + $"          W: {vec.z}\n"
            + $"          H: {vec.a}\n")
        }, stringBuilder)

        return stringBuilder.get()
      }

      static factoryShaderTemplates = function(shaderPipeline) {
        var stringBuilder = new StringBuilder()
        shaderPipeline.executor.tasks.forEach(function(task, iterator, stringBuilder) {
          var name = task.state.get("name")
          var alpha = task.state.get("alpha")
          var fadeIn = task.state.get("fadeIn")
          var fadeOut = task.state.get("fadeOut")
          var time = Optional.is(task.timeout) ? string(task.timeout.time) : "N/A"
          var duration = Optional.is(task.timeout) ? string(task.timeout.duration) : "N/A"
          stringBuilder.append($"        - Name: {name}\n"
            + $"          Time: {time} \n"
            + $"          Duration: {duration} \n"
            + $"          Alpha: {alpha}\n"
            + $"          FadeIn: {fadeIn}\n"
            + $"          FadeOut: {fadeOut}\n")

          var properties = task.state.get("properties")
          if (properties.size() == 0) {
            return
          }

          stringBuilder.append("          Uniforms:\n")
          properties.forEach(function(property, name, stringBuilder) {
            stringBuilder.append($"            - {name}: {property.toString()}\n")
          }, stringBuilder)
        }, stringBuilder)

        return stringBuilder.get()
      }

      var controller = Beans.get(BeanVisuController)
      var properties = controller.gridService.properties
      var bktGlitchService = controller.visuRenderer.gridRenderer.glitchService
      var effect = $"Effect:\n"
        + $"  Shader:\n"
        + $"    ClearFrame: \n"
        + $"      Enabled: {properties.shaderClearFrame}\n"
        + $"      Color: {properties.shaderClearColor.toHex(false)}\n"
        + $"    Background:\n"
        + $"      Enabled: {properties.renderBackgroundShaders}\n"
        + $"      ShaderTemplates: \n"
        + factoryShaderTemplates(controller.shaderBackgroundPipeline)
        + $"    Grid:\n"
        + $"      Enabled: {properties.renderGridShaders}\n"
        + $"      ShaderTemplates: \n"
        + factoryShaderTemplates(controller.shaderPipeline)
        + $"    Combined:\n"
        + $"      Enabled: {properties.renderCombinedShaders}\n"
        + $"      ShaderTemplates: \n"
        + factoryShaderTemplates(controller.shaderCombinedPipeline)
        + $"  Glitch: \n"
        + $"    Enabled: TODO\n"
        + $"    Factor: {bktGlitchService.factor}\n"
        + $"    Config: \n"
        + $"      Line:\n"
        + $"        Speed: {global.bktGlitchUniform[bktGlitch.lineSpeed]}\n"
        + $"        Shift: {global.bktGlitchUniform[bktGlitch.lineShift]}\n"
        + $"        Resolution: {global.bktGlitchUniform[bktGlitch.lineResolution]}\n"
        + $"        V: shift {global.bktGlitchUniform[bktGlitch.lineVertShift]}\n"
        + $"        Drift: {global.bktGlitchUniform[bktGlitch.lineDrift]}\n"
        + $"      Jumble:\n"
        + $"        Speed: {global.bktGlitchUniform[bktGlitch.jumbleSpeed]}\n"
        + $"        Shift: {global.bktGlitchUniform[bktGlitch.jumbleShift]}\n"
        + $"        Resolution: {global.bktGlitchUniform[bktGlitch.jumbleResolution]}\n"
        + $"        Chaos: {global.bktGlitchUniform[bktGlitch.jumbleness]}\n"
        + $"      Shader:\n"
        + $"        Dispersion: {global.bktGlitchUniform[bktGlitch.dispersion]}\n"
        + $"        Channel shift: {global.bktGlitchUniform[bktGlitch.channelShift]}\n"
        + $"        Noise level: {global.bktGlitchUniform[bktGlitch.noiseLevel]}\n"
        + $"        Shakiness: {global.bktGlitchUniform[bktGlitch.shakiness]}\n"
        + $"        Rng seed: {global.bktGlitchUniform[bktGlitch.rngSeed]}\n"
        + $"        Intensity: {global.bktGlitchUniform[bktGlitch.intensity]}\n"
        + $"  Particle:\n"
        + $"    Enabled: TODO\n"
        + $"    ParticleEmitters:\n"
        + factoryParticleEmitters(controller.particleService)


      return effect
    },

    ///@return {String}
    entity: function() {
      var controller = Beans.get(BeanVisuController)
      var properties = controller.gridService.properties
      var entity = $"Entity:\n"
        + $"  Shroom:\n"
        + $"    Enabled: {properties.renderShrooms}\n"
        + $"    Amount: {controller.shroomService.shrooms.size()}\n"
        + $"    Z: {properties.depths.shroomZ}\n"
        + $"  Coin:\n"
        + $"    Enabled: {properties.renderCoins}\n"
        + $"    Amount: {controller.coinService.coins.size()}\n"
        + $"    Z: {properties.depths.coinZ}\n"
        + $"  Player:\n"
        + $"    Enabled: {properties.renderPlayer}\n"
        + $"    Amount: {controller.playerService.player != null ? 1 : 0}\n"
        + $"    Z: {properties.depths.playerZ}\n"
        + $"  Bullet:\n"
        + $"    Enabled: {properties.renderBullets}\n"
        + $"    Amount: {controller.bulletService.bullets.size()}\n"
        + $"    Z: {properties.depths.bulletZ}\n"

      return entity
    },

    ///@return {String}
    grid: function() {
      var controller = Beans.get(BeanVisuController)
      var properties = controller.gridService.properties
      var grid = $"Grid:\n"
        + $"  Enabled: {properties.renderGrid}\n"
        + $"  BlendMode:\n"
        + $"    Source: {BlendModeExt.getKey(properties.gridBlendConfig.source)}\n"
        + $"    Target: {BlendModeExt.getKey(properties.gridBlendConfig.target)}\n"
        + $"    Equation: {BlendEquation.getKey(properties.gridBlendConfig.equation)}\n"
      if (Optional.is(properties.gridBlendConfig.equationAlpha)) {
        grid = $"{grid}    EquationAlpha: {BlendEquation.getKey(properties.gridBlendConfig.equationAlpha)}\n"
      }

      grid = $"{grid}  Z: {properties.depths.gridZ}\n"
        + $"  ClearFrame: \n"
        + $"    Enabled: {properties.gridClearFrame}\n"
        + $"    Color: {properties.gridClearColor.toHex(false)}\n"
        + $"    Alpha: {properties.gridClearFrameAlpha}\n"
        + $"  Area:\n"
        + $"    HorizontalBorder:\n"
        + $"      Length: {properties.borderHorizontalLength}\n"
        + $"      Thickness: {properties.borderVerticalThickness}\n"
        + $"      Alpha: {properties.borderVerticalAlpha}\n"
        + $"      Color: {properties.borderVerticalColor.toHex(false)}\n"
        + $"    VerticalBorder:\n"
        + $"      Length: {properties.borderVerticalLength}\n"
        + $"      Thickness: {properties.borderHorizontalThickness}\n"
        + $"      Alpha: {properties.borderHorizontalAlpha}\n"
        + $"      Color: {properties.borderHorizontalColor.toHex(false)}\n"
        + $"  Column:\n"
        + $"    RenderMode: {properties.channelsMode}\n"
        + $"    Amount: {properties.channels}\n"
        + $"    Main:\n"
        + $"      Thickness: {properties.channelsPrimaryThickness}\n"
        + $"      Alpha: {properties.channelsPrimaryAlpha}\n"
        + $"      Color: {properties.channelsPrimaryColor.toHex(false)}\n"
        + $"    Side:\n"
        + $"      Thickness: {properties.channelsSecondaryThickness}\n"
        + $"      Alpha: {properties.channelsSecondaryAlpha}\n"
        + $"      Color: {properties.channelsSecondaryColor.toHex()}\n"
        + $"  Row:\n"
        + $"    RenderMode: {properties.separatorsMode}\n"
        + $"    Amount: {properties.separators}\n"
        + $"    Main:\n"
        + $"      Thickness: {properties.separatorsPrimaryThickness}\n"
        + $"      Alpha: {properties.separatorsPrimaryAlpha}\n"
        + $"      Color: {properties.separatorsPrimaryColor.toHex()}\n"
        + $"    Side:\n"
        + $"      Thickness: {properties.separatorsSecondaryThickness}\n"
        + $"      Alpha: {properties.separatorsSecondaryAlpha}\n"
        + $"      Color: {properties.separatorsSecondaryColor.toHex()}\n"
        + $"  Focus:\n"
        + $"    Enabled: {properties.renderSupportGrid}\n"
        + $"    BlendMode:\n"
        + $"      Source: {BlendModeExt.getKey(properties.supportGridBlendConfig.source)}\n"
        + $"      Target: {BlendModeExt.getKey(properties.supportGridBlendConfig.target)}\n"
        + $"      Equation: {BlendEquation.getKey(properties.supportGridBlendConfig.equation)}\n"
      if (Optional.is(properties.supportGridBlendConfig.equationAlpha)) {
        grid = $"{grid}      EquationAlpha: {BlendEquation.getKey(properties.supportGridBlendConfig.equationAlpha)}\n"
      }
  
      grid = $"{grid}    BlendColor: {properties.supportGridBlendColor.toHex(false)}\n"
        + $"    Treshold: {properties.supportGridTreshold}\n"
        + $"    Alpha: {properties.supportGridAlpha}\n"

      return grid
    },

    ///@return {String}
    view: function() {
      static factoryColorLayers = function(layers) {
        var stringBuilder = new StringBuilder()
        layers.forEach(function(task, iterator, stringBuilder) {
          if (task.name != "fade-color") {
            return
          }

          var color = task.state.get("color")
          var alpha = color.alpha
          var fadeInSpeed = task.state.get("fadeInSpeed")
          var fadeOutSpeed = task.state.get("fadeOutSpeed")
          var source = BlendModeExt.getKey(task.state.get("blendModeSource"))
          var target = BlendModeExt.getKey(task.state.get("blendModeTarget"))
          var equation = BlendEquation.getKey(task.state.get("blendEquation"))
          var equationAlpha = task.state.get("blendEquationAlpha")
          stringBuilder.append($"        - Color: {color.toHex(false)}\n"
            + $"            Alpha: {alpha}\n"
            + $"          Layer: \n"
            + $"            FadeInSpeed: {fadeInSpeed}\n"
            + $"            FadeOutSpeed: {fadeOutSpeed}\n"
            + $"            BlendMode:\n"
            + $"              Source: {source}\n"
            + $"              Target: {target}\n"
            + $"              Equation: {equation}\n")
          if (Optional.is(equationAlpha)) {
            stringBuilder.append($"              EquationAlpha: {BlendEquation.getKey(equationAlpha)}\n")
          }
        }, stringBuilder)

        return stringBuilder.get()
      }

      static factoryTextureLayers = function(layers) {
        var stringBuilder = new StringBuilder()
        layers.forEach(function(task, iterator, stringBuilder) {
          if (task.name != "fade-sprite") {
            return
          }
          
          var sprite = task.state.get("sprite")
          var tiled = task.state.get("tiled")
          var _speed = task.state.get("speed")
          var speedTransformer = task.state.get("speedTransformer")
          if (Optional.is(speedTransformer)) {
            _speed = speedTransformer.value
          }

          var angle = task.state.get("angle")
          var angleTransformer = task.state.get("angleTransformer")
          if (Optional.is(angleTransformer)) {
            angle = angle + angleTransformer.value
          }
          
          var xScale = task.state.get("xScale")
          var yScale = task.state.get("yScale")

          var lifespawn = Optional.is(task.state.get("lifespawn"))
            ? task.state.get("lifespawn").time
            : "N/A"

          var fadeInSpeed = task.state.get("fadeInSpeed")
          var fadeOutSpeed = task.state.get("fadeOutSpeed")
          var source = BlendModeExt.getKey(task.state.get("blendModeSource"))
          var target = BlendModeExt.getKey(task.state.get("blendModeTarget"))
          var equation = BlendEquation.getKey(task.state.get("blendEquation"))
          var equationAlpha = task.state.get("blendEquationAlpha")
          stringBuilder.append($"        - Texture:\n"
            + $"            Name: {sprite.getName()}\n"
            + $"            Speed: {sprite.getSpeed()}\n"
            + $"            Frame: {sprite.getFrame()}\n"
            + $"            Alpha: {sprite.getAlpha()}\n"
            + $"            BlendColor: {ColorUtil.fromGMColor(sprite.getBlend()).toHex()}\n"
            + $"            Tiled: {tiled}\n"
            + $"          Movement:\n"
            + $"            Speed: {_speed}\n"
            + $"            Angle: {angle}\n"
            + $"            Scale:\n"
            + $"              X: {xScale}\n"
            + $"              Y: {yScale}\n"
            + $"          Layer:\n"
            + $"            Lifespawn: {lifespawn}\n"
            + $"            FadeInSpeed: {fadeInSpeed}\n"
            + $"            FadeOutSpeed: {fadeOutSpeed}\n"
            + $"            BlendMode:\n"
            + $"              Source: {source}\n"
            + $"              Target: {target}\n"
            + $"              Equation: {equation}\n")
          if (Optional.is(equationAlpha)) {
            stringBuilder.append($"              EquationAlpha: {BlendEquation.getKey(equationAlpha)}\n")
          }
        }, stringBuilder)

        return stringBuilder.get()
      }

      static factorySubtitleTemplates = function(subtitleService) {
        var stringBuilder = new StringBuilder()
        subtitleService.executor.tasks.forEach(function(task, iterator, stringBuilder) {
          if (task.name != "subtitle-task") {
            return
          }

          var subtitle = task.state.subtitle
          var lineDelay = Core.isType(subtitle.lineDelay, Timer) ? subtitle.lineDelay.duration : "N/A"
          var finishDelay = Core.isType(subtitle.finishDelay, Timer) ? subtitle.finishDelay.duration : "N/A"
          var outline = Core.isType(subtitle.outline, GMColor) ? ColorUtil.fromGMColor(subtitle.outline).toHex(false) : "N/A"
          var angle = Core.isType(subtitle.angleTransformer, NumberTransformer) ? subtitle.angleTransformer.value : "N/A"
          var _speed = Core.isType(subtitle.speedTransformer, NumberTransformer) ? subtitle.speedTransformer.value : "N/A"
          stringBuilder.append($"      - SubtitleTemplate: {subtitle.template}\n"
            + $"        Lifespawn: {task.state.time}\n"
            + $"        Char speed: {subtitle.charSpeed}\n"
            + $"        Fade in: {subtitle.fadeIn}\n"
            + $"        Fade out: {subtitle.fadeOut}\n"
            + $"        Wait after:\n"
            + $"          New line: {lineDelay}\n"
            + $"          Last line: {finishDelay}\n"
            + $"        Font:\n"
            + $"          Face: {subtitle.font.name}\n"
            + $"          Spacing: {subtitle.fontHeight}\n"
            + $"          Align:\n"
            + $"            X: {HAlign.getKey(subtitle.align.h)}\n"
            + $"            Y: {VAlign.getKey(subtitle.align.v)}\n"
            + $"          Color: {ColorUtil.fromGMColor(subtitle.color).toHex(false)}\n"
            + $"          Outline: {outline}\n"
            + $"        SubtitleMovement:\n"
            + $"          Speed: {_speed}\n"
            + $"          Angle: {angle}\n")
        }, stringBuilder)

        return stringBuilder.get()
      }

      var controller = Beans.get(BeanVisuController)
      var gridService = controller.gridService
      var properties = controller.gridService.properties
      var camera = controller.visuRenderer.gridRenderer.camera
      var lock = gridService.targetLocked
      var follow = gridService.view.follow
      var overlayRenderer = controller.visuRenderer.gridRenderer.overlayRenderer
      var view = $"View:\n"
        + $"  HUD: {controller.visuRenderer.hudRenderer.enabled}\n"
        + $"  Camera:\n"
        + $"    Lock: \n"
        + $"      X: {lock.isLockedX}\n"
        + $"      Y: {lock.isLockedY}\n"
        + $"    FollowPlayer:\n"
        + $"      X: {follow.xMargin}\n"
        + $"      Y: {follow.yMargin}\n"
        + $"      Smooth: {follow.smooth}\n"
        + $"    CameraPosition:\n"
        + $"      X: {camera.x}\n"
        + $"      Y: {camera.y}\n"
        + $"      Z: {camera.z}\n"
        + $"      Angle: {camera.angle}\n"
        + $"      Pitch: {camera.pitch}\n"
        + $"  Layer:\n"
        + $"    Background:\n"
        + $"      Colors:\n"
        + factoryColorLayers(overlayRenderer.backgroundColors)
        + $"      Textures:\n"
        + factoryTextureLayers(overlayRenderer.backgrounds)
        + $"    Foreground:\n"
        + $"      Colors:\n"
        + factoryColorLayers(overlayRenderer.foregroundColors)
        + $"      Textures:\n"
        + factoryTextureLayers(overlayRenderer.foregrounds)
        + $"  Subtitle:\n"
        + $"    Enabled: {properties.renderSubtitles}\n"
        + $"    Subtitles:\n"
        + factorySubtitleTemplates(controller.subtitleService)
        + $"  Video:\n"
        + $"    Enabled: {properties.renderVideo}\n"
        + $"    AfterBackground: {properties.renderVideoAfter}\n"
        + $"    BlendMode:\n"
        + $"      Source: {BlendModeExt.getKey(properties.videoBlendConfig.source)}\n"
        + $"      Target: {BlendModeExt.getKey(properties.videoBlendConfig.target)}\n"
        + $"      Equation: {BlendEquation.getKey(properties.videoBlendConfig.equation)}\n"
      if (Optional.is(properties.videoBlendConfig.equationAlpha)) {
        view = + $"{view}      EquationAlpha: {BlendEquation.getKey(properties.videoBlendConfig.equationAlpha)}\n"
      }

      view = $"{view}    BlendColor: {properties.videoBlendColor.toHex(false)}\n"
        + $"    Alpha: {properties.videoAlpha}\n"
      return view
    },

    ///@return {String}
    generateText: function() {
      var editor = Beans.get(BeanVisuEditorController)
      if (!Optional.is(editor)) {
        return ""
      }
      
      var category = editor.brushToolbar.store.getValue("category")
      var callback = Struct.getIfType(this, category, Callable)
      return Optional.is(callback) ? callback() : ""
    },
  }

  ///@private
  ///@param {?UIlayout} [parent]
  ///@return {Map<String, UI>}
  factoryContainers = function(parent = null) {
    var sceneConfigPreview = this
    var layout = this.factoryLayout(parent)
    return new Map(String, UI, {
      "_1_ve-scene-config-preview": new UI({
        name: "_1_ve-scene-config-preview",
        state: new Map(String, any, {
          "surface-alpha": 0.5,
          "background-alpha": 0.0,
          "text": "",
          components: new Array(Struct, [
            {
              name: "_1_text-scene-config-preview",
              template: VEComponents.get("text"),
              layout: VELayouts.get("text"),
              config: { 
                layout: { 
                  type: UILayoutType.VERTICAL,
                  margin: { left: 10 },
                },
                label: {
                  text: "",
                  useScale: false,
                  enableColorWrite: false,
                  shader: null,
                  updateCustom: function() {
                    if (this.shader == null) {
                      this.shader = ShaderUtil.fetch("shader_color_passthrough")
                      if (!Core.isType(this.shader, Shader)) {
                        this.shader = -1
                      }
                    }
                  },
                  render: function() {
                    this.renderBackgroundColor()

                    if (Core.isType(this.enable, Struct)) {
                      this.label.alpha = (Struct.get(this.enable, "value") == false ? 0.5 : 1.0)
                        * Struct.inject(this.enable, "alpha", this.label.alpha)
                    }

                    if (!Core.isType(this.shader, Shader)) {
                      return
                    }

                    GPU.set.shader(this.shader)

                    var color = this.label.color
                    var outline = this.label.outline
                    var outlineColor = this.label.outlineColor
                    var alpha = this.label.alpha
                    this.label.outline = false
                    this.label.color = ColorUtil.parse(VETheme.color.accentDark).toGMColor()
                    this.label.alpha = 1.0

                    var offsetX = 0
                    if (this.label.align.h == HAlign.CENTER) {
                      offsetX = this.area.getWidth() / 2
                    }
                    if (this.label.align.h == HAlign.RIGHT) {
                      offsetX = this.area.getWidth()
                    }

                    var offsetY = 0
                    if (this.label.align.v == VAlign.CENTER) {
                      offsetY = this.area.getHeight() / 2
                    }
                    if (this.label.align.v == VAlign.BOTTOM) {
                      offsetY = this.area.getHeight()
                    }

                    var _x = this.context.area.getX() + this.area.getX() + offsetX
                    var _y = this.context.area.getY() + this.area.getY() + offsetY
                    var width = this.area.getWidth()
                    var height = this.area.getHeight()
                    this.label.render(_x - 2, _y - 2, width, height)
                    this.label.render(_x + 2, _y - 2, width, height)
                    this.label.render(_x, _y, width, height)
                    this.label.render(_x - 2, _y + 2, width, height)
                    this.label.render(_x + 2, _y + 2, width, height)
                    
                    this.label.outline = outline
                    this.label.color = color
                    this.label.alpha = alpha
                    GPU.reset.shader()

                    var text = this.context.state.get("text")
                    if (this.label.text == text) {
                      return
                    }
                      
                    this.label.text = text
                    var height = string_height(text)
                    var store = Struct.get(Struct.get(Struct.get(this, "layout"), "context"), "store")
                    if (height == Struct.get(store, "height")) {
                      return
                    }

                    Struct.set(store, "height", height)
                    this.context.areaWatchdog.signal()
                  },
                },
              },
            },
          ])
        }),
        sceneConfigPreview: sceneConfigPreview,
        layout: layout,
        propagate: true,
        scrollbarY: {
          align: HAlign.LEFT,
          alpha: 0.0,
        },
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.sceneConfigPreview.updateTimer", 4.0), { loop: Infinity, shuffle: true }),
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        updateCustom: function() {
          var container = this.sceneConfigPreview.containers.get("_2_ve-scene-config-preview")
          if (!Optional.is(container)) {
            return
          }

          this.offset.x = container.offset.x
          this.offset.y = container.offset.y
          this.offsetMax.x = container.offsetMax.x
          this.offsetMax.y = container.offsetMax.y
          this.state.set("text", container.state.get("text"))
        },
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableAlpha")),
        onInit: function() {
          var container = this
          this.collection = new UICollection(this, { layout: container.layout })
          this.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
          this.collection.components.clear() ///@todo replace with remove lambda
          this.updateArea()
          this.addUIComponents(state.get("components")
            .map(function(component) {
              return new UIComponent(component)
            }),
            new UILayout({
              area: container.area,
              width: function() { return this.area.getWidth() },
            })
          )
        },
      }),
      "_2_ve-scene-config-preview": new UI({
        name: "_2_ve-scene-config-preview",
        state: new Map(String, any, {
          "surface-alpha": 0.999,
          "background-alpha": 0.0,
          "text": "",
          components: new Array(Struct, [
            {
              name: "_2_text-scene-config-preview",
              template: VEComponents.get("text"),
              layout: VELayouts.get("text"),
              config: { 
                layout: { 
                  type: UILayoutType.VERTICAL,
                  margin: { left: 10 },
                },
                label: { 
                  text: "",
                  useScale: false,
                  enableColorWrite: false,
                  shader: null,
                  updateCustom: function() {
                    this.context.state.set("text", this.context.sceneConfigPreview.factorySceneConfig.generateText())
                  },
                  postRender: function() {
                    var text = this.context.state.get("text")
                    if (this.label.text == text) {
                      return
                    }
                      
                    this.label.text = text
                    var height = string_height(this.label.text)
                    var store = Struct.get(Struct.get(Struct.get(this, "layout"), "context"), "store")
                    if (height == Struct.get(store, "height")) {
                      return
                    }

                    Struct.set(store, "height", height)
                    this.context.areaWatchdog.signal()
                  },
                },
              },
            },
          ])
        }),
        sceneConfigPreview: sceneConfigPreview,
        layout: layout,
        propagate: true,
        scrollbarY: { align: HAlign.LEFT },
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.sceneConfigPreview.updateTimer", 4.0), { loop: Infinity, shuffle: true }),
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableAlpha")),
        onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
        onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          var container = this
          this.collection = new UICollection(this, { layout: container.layout })
          this.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
          this.collection.components.clear() ///@todo replace with remove lambda
          this.updateArea()
          this.addUIComponents(state.get("components")
            .map(function(component) {
              return new UIComponent(component)
            }),
            new UILayout({
              area: container.area,
              width: function() { return this.area.getWidth() },
            })
          )
        },
      }),
    })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.dispatcher.execute(new Event("close"))

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
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETrackControl}
  update = function() { 
    this.dispatcher.update()
    return this
  }
}