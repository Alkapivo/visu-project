///@package io.alkapivo.core.service.particle

#macro GMParticleSystem "GMParticleSystem"
#macro GMParticleEmitter "GMParticleEmitter"


///@enum
function _ParticleEmitterShape(): Enum() constructor {
  RECTANGLE = ps_shape_rectangle
  ELLIPSE = ps_shape_ellipse
  DIAMOND = ps_shape_diamond
  LINE = ps_shape_line
}
global.__ParticleEmitterShape = new _ParticleEmitterShape()
#macro ParticleEmitterShape global.__ParticleEmitterShape

///@enum
function _ParticleEmitterDistribution(): Enum() constructor {
  LINEAR = ps_distr_linear
  GAUSSIAN = ps_distr_gaussian
  INVERTEDGAUSSIAN = ps_distr_invgaussian
}
global.__ParticleEmitterDistribution = new _ParticleEmitterDistribution()
#macro ParticleEmitterDistribution global.__ParticleEmitterDistribution


///@param {String} _layerName
function ParticleSystem(_layerName) constructor {

  ///@type {String}
  layerName = Assert.isType(_layerName, String)

  ///@type {GMParticleSystem}
  asset = part_system_create_layer(this.layerName, false)
  part_system_automatic_update(this.asset, false)
  part_system_automatic_draw(this.asset, false)

  ///@type {GMEmitter}
  emitter = part_emitter_create(this.asset)

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  clear = function() {
    this.executor.tasks.forEach(TaskUtil.fullfill).clear()
    if (Core.isType(this.asset, GMParticleSystem)) {
      part_particles_clear(this.asset)
    }
  }
  ///@return {ParticleSystem}
  update = function() {
    if (!Core.isType(this.asset, GMParticleSystem)) {
      this.asset = part_system_create_layer(this.layerName, false)
      this.emitter = part_emitter_create(this.asset)
      part_system_automatic_update(this.asset, false)
      part_system_automatic_draw(this.asset, false)
    }

    if (typeof(this.emitter) != "ref" || !part_emitter_exists(this.asset, this.emitter)) {
      this.emitter = part_emitter_create(this.asset)
    }

    this.executor.update()

    part_system_update(this.asset)
    return this
  }

  render = function() {
    if (!Core.isType(this.asset, GMParticleSystem)) {
      this.asset = part_system_create_layer(this.layerName, false)
      this.emitter = part_emitter_create(this.asset)
      part_system_automatic_update(this.asset, false)
      part_system_automatic_draw(this.asset, false)
    }

    if (typeof(this.emitter) != "ref" || !part_emitter_exists(this.asset, this.emitter)) {
      this.emitter = part_emitter_create(this.asset)
    }
    
    part_system_drawit(this.asset)
  }
    
  free = function() {
    if (Core.isType(this.asset, GMParticleSystem)) {
      if (typeof(this.emitter) == "ref" || part_emitter_exists(this.asset, this.emitter)) {
        part_emitter_destroy(this.asset, this.emitter)
        this.emitter = null
      }

      part_system_destroy(this.asset)
      this.asset = null
    }
  }
}


///@param {?Struct} [config]
function ParticleService(config = null): Service() constructor {

  ///@type {Map<String, ParticleTemplate>}
  templates = new Map(String, ParticleTemplate)

  ///@type {Map<String, ParticleSystem}
  systems = Struct.getDefault(config, "systems", new Map(String, ParticleSystem, {
    main: new ParticleSystem(Struct.get(config, "layerName")),
  }))

  ///@return {Map<String, ParticleTemplate>}
  getStaticTemplates = method(this, Core.isType(Struct.get(config, "getStaticTemplates"), Callable)
    ? config.getStaticTemplates
    : function() {
      return this.templates
    })

  ///@param {String} name
  ///@return {?TextureTemplate}
  getTemplate = function(name) {
    var template = this.templates.get(name)
    return template == null
      ? this.getStaticTemplates().get(name)
      : template
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-particle-emitter": function(event) {
      var task = new Task("emmit-particle")
        .setTimeout(Struct.getDefault(event.data, "duration", FRAME_MS))
        .setTick(Struct.getDefault(event.data, "interval", FRAME_MS))
        .setState(new Map(String, any, {
          particle: event.data.particle,
          system: event.data.system,
          shape: event.data.shape,
          amount: event.data.amount,
          coords: event.data.coords,
          distribution: event.data.distribution,
        }))
        .whenTimeout(function() {
          this.fullfill()
        })
        .whenUpdate(function(executor) {
          var system = this.state.get("system")
          var coords = this.state.get("coords")
          var shape = this.state.get("shape")
          var distribution = this.state.get("distribution")
          part_emitter_region(
            system.asset, system.emitter,
            coords.x, coords.z, coords.y, coords.a,
            shape, distribution
          )

          var particle = this.state.get("particle")
          var amount = this.state.get("amount")
          part_emitter_burst(system.asset, system.emitter, particle.asset, amount)
        })
      event.data.system.executor.add(task)
    },
    "clear-particles": function(event) {
      this.systems.forEach(function(system) {
        system.clear()
      })
    },
    "reset-templates": function(event) {
      this.templates.clear()
      this.dispatcher.container.clear()
    },
  }))

  ///@param {String} name
  ///@return {?Particle}
  factoryParticle = function(name) {
    var template = this.getTemplate(name)
    return template != null ? new Particle(template) : null
  }

  ///@param {Struct} config
  ///@return {Event}
  factoryEventSpawnParticleEmitter = function(config) {
    return new Event("spawn-particle-emitter", {
      particle: this.factoryParticle(Struct.getDefault(config, "particleName", "particle-default")),
      system: this.systems.get(Struct.getDefault(config, "systemName", "main")),
      coords: new Vector4(
        Struct.get(config, "beginX"),
        Struct.get(config, "beginY"),
        Struct.get(config, "endX"),
        Struct.get(config, "endY")
      ),
      shape: Struct.getDefault(config, "shape", ParticleEmitterShape.ELLIPSE),
      duration: Struct.getDefault(config, "duration", 0.0),
      interval: Struct.getDefault(config, "interval", FRAME_MS),
      amount: Struct.getDefault(config, "amount", 100),
      distribution: Struct.getDefault(config, "distribution", ParticleEmitterDistribution.LINEAR),
    })
  }

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {ParticleService}
  update = function() {
    this.dispatcher.update()
    this.systems.forEach(function(system) {
      system.update()
    })
    return this
  }

  free = function() {
    this.systems.forEach(function(system) {
      system.free()
    })
  }

  this.send(new Event("reset-templates"))
}
