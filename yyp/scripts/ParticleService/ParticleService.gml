///@io.alkapivo.core.service.particle

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


///@param {String} layerName
function ParticleSystem(layerName) constructor {

  ///@type {GMLayer}
  layerRef = layer_get_id(layerName)

  ///@type {GMParticleSystem}
  asset = part_system_create()
  part_system_automatic_draw(this.asset, false)
  part_system_layer(this.asset, this.layerRef)

  ///@type {GMEmitter}
  emitter = part_emitter_create(this.asset)

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  ///@return {ParticleSystem}
  update = method(this, function() {
    if (!part_system_exists(this.asset)) {
      this.asset = part_system_create()
      part_system_automatic_draw(this.asset, false)
      part_system_layer(this.asset, this.layerRef)
    }

    if (!part_emitter_exists(this.asset, this.emitter)) {
      this.emitter = part_emitter_create(this.asset)
    }

    this.executor.update()
    return this
  })

  render = method(this, function() {
    part_system_drawit(this.asset);
  })
    
  free = method(this, function() {
    if (part_system_exists(this.asset)) {
      part_system_destroy(this.asset)
    }
  })
}


///@param {Controller} _controller
///@param {Struct} [config]
function ParticleService(_controller, config = {}): Service() constructor {

  ///@type {Controller}
  controller = Assert.isType(_controller, Struct)

  ///@type {Map<String, ParticleTemplate>}
  templates = new Map(String, ParticleTemplate)

  ///@type {Map<String, ParticleSystem}
  systems = Struct.getDefault(config, "systems", new Map(String, ParticleSystem, {
    main: new ParticleSystem(Struct.get(config, "layerName")),
  }))

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
      this.templates.clear()
    },
  }))

  ///@param {String} name
  ///@return {?Particle}
  factoryParticle = method(this, function(name) {
    var template = this.templates.get(name)
    return template != null ? new Particle(template) : null
  })

  ///@param {Struct} [config]
  ///@return {Event}
  factoryEventSpawnParticleEmitter = function(config = {}) {
    return new Event("spawn-particle-emitter", {
      particle: this.factoryParticle(Struct.getDefault(config, "particleName", "particle_default")),
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
  send = method(this, function(event) {
    return this.dispatcher.send(event)
  })

  ///@override
  ///@return {ParticleService}
  update = method(this, function() {
    this.dispatcher.update()
    this.systems.forEach(function(system) {
      system.update()
    })
    return this
  })
}
