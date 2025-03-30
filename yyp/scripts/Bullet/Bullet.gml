///@package io.alkapivo.visu.service.bullet

#macro TAU 6.28318530

///@param {String}
///@param {Struct} json
function BulletTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Struct}
  sprite = Assert.isType(Struct.get(json, "sprite"), Struct)

  ///@type {?Struct}
  mask = Struct.getIfType(json, "mask", Struct)

  ///@type {Number}
  lifespanMax = Struct.getIfType(json, "lifespanMax", Number, 15.0)

  ///@type {Number}
  damage = Struct.getIfType(json, "damage", Number, 1.0)

  ///@type {Boolean}
  wiggle = Struct.getIfType(json, "wiggle", Boolean, false)

  ///@type {Number}
  wiggleTime = Struct.getIfType(json, "wiggleTime", Number, 0.0)

  ///@type {Boolean}
  wiggleTimeRng = Struct.getIfType(json, "wiggleTimeRng", Boolean, false)

  ///@type {Number}
  wiggleFrequency = Struct.getIfType(json, "wiggleFrequency", Number, FRAME_MS)

  ///@type {Boolean}
  wiggleDirRng = Struct.getIfType(json, "wiggleDirRng", Boolean, false)

  ///@type {Number}
  wiggleAmplitude = Struct.getIfType(json, "wiggleAmplitude", Number, 0.0)

  ///@type {?Struct}
  angleOffset = Struct.getIfType(json, "angleOffset", Struct)

  ///@type {Boolean}
  angleOffsetRng = Struct.getIfType(json, "angleOffsetRng", Boolean, false)

  ///@type {Boolean}
  useAngleOffset = Struct.getIfType(json, "useAngleOffset", Boolean, false)

  ///@type {Boolean}
  changeAngleOffset = Struct.getIfType(json, "changeAngleOffset", Boolean, false)

  ///@type {?Struct}
  speedOffset = Struct.getIfType(json, "speedOffset", Struct)

  ///@type {Boolean}
  useSpeedOffset = Struct.getIfType(json, "useSpeedOffset", Boolean, false)

  ///@type {Boolean}
  changeSpeedOffset = Struct.getIfType(json, "changeSpeedOffset", Boolean, false)

  ///@type {?String}
  onDeath = Struct.getIfType(json, "onDeath", String)

  ///@type {?Number}
  onDeathAmount = Struct.getIfType(json, "onDeathAmount", Number)

  ///@type {?Number}
  onDeathAngle = Struct.getIfType(json, "onDeathAngle", Number)

  ///@type {?Boolean}
  onDeathAngleRng = Struct.getIfType(json, "onDeathAngleRng", Boolean)

  ///@type {?Number}
  onDeathAngleStep = Struct.getIfType(json, "onDeathAngleStep", Number)

  ///@type {?Number}
  onDeathRngStep = Struct.getIfType(json, "onDeathRngStep", Number)

  ///@type {?Number}
  onDeathSpeed = Struct.getIfType(json, "onDeathSpeed", Number)

  ///@type {?Boolean}
  onDeathSpeedMerge = Struct.getIfType(json, "onDeathSpeedMerge", Boolean)

  ///@type {?Number}
  onDeathRngSpeed = Struct.getIfType(json, "onDeathRngSpeed", Number)

  ///@return {Struct}
  serialize = function() {
    return {
      sprite: JSON.clone(this.sprite),
      useSpeedOffset: this.useSpeedOffset,
      changeSpeedOffset: this.changeSpeedOffset,
      useAngleOffset: this.useAngleOffset,
      changeAngleOffset: this.changeAngleOffset,
      damage: this.damage,
      lifespanMax: this.lifespanMax,
      mask: Optional.is(this.mask) ? JSON.clone(this.mask) : null,
      wiggle: this.wiggle,
      wiggleTime: this.wiggleTime,
      wiggleTimeRng: this.wiggleTimeRng,
      wiggleFrequency: this.wiggleFrequency,
      wiggleDirRng: this.wiggleDirRng,
      wiggleAmplitude: this.wiggleAmplitude,
      angleOffset: this.angleOffset,
      angleOffsetRng: this.angleOffsetRng,
      speedOffset: this.speedOffset,
      onDeath: this.onDeath,
      onDeathAmount: this.onDeathAmount,
      onDeathAngle: this.onDeathAngle,
      onDeathAngleRng: this.onDeathAngleRng,
      onDeathAngleStep: this.onDeathAngleStep,
      onDeathRngStep: this.onDeathRngStep,
      onDeathSpeed: this.onDeathSpeed,
      onDeathSpeedMerge: this.onDeathSpeedMerge,
      onDeathRngSpeed: this.onDeathRngSpeed,
    }
  }

  ///@return {Struct}
  serializeSpawn = function(x, y, angle, speed, producer, uid) {
    return {
      sprite: JSON.clone(this.sprite),
      useSpeedOffset: this.useSpeedOffset,
      changeSpeedOffset: this.changeSpeedOffset,
      useAngleOffset: this.useAngleOffset,
      changeAngleOffset: this.changeAngleOffset,
      damage: this.damage,
      lifespanMax: this.lifespanMax,
      mask: Optional.is(this.mask) ? JSON.clone(this.mask) : null,
      wiggle: this.wiggle,
      wiggleTime: this.wiggleTime,
      wiggleTimeRng: this.wiggleTimeRng,
      wiggleFrequency: this.wiggleFrequency,
      wiggleDirRng: this.wiggleDirRng,
      wiggleAmplitude: this.wiggleAmplitude,
      angleOffset: this.angleOffset,
      angleOffsetRng: this.angleOffsetRng,
      speedOffset: this.speedOffset,
      onDeath: this.onDeath,
      onDeathAmount: this.onDeathAmount,
      onDeathAngle: this.onDeathAngle,
      onDeathAngleRng: this.onDeathAngleRng,
      onDeathAngleStep: this.onDeathAngleStep,
      onDeathRngStep: this.onDeathRngStep,
      onDeathSpeed: this.onDeathSpeed,
      onDeathSpeedMerge: this.onDeathSpeedMerge,
      onDeathRngSpeed: this.onDeathRngSpeed,
      x: x,
      y: y,
      angle: angle,
      speed: speed,
      producer: producer,
      uid: uid,
    }
  }
}


///@param {BulletTemplate} template
function Bullet(template): GridItem(template) constructor {

  ///@param {Number}
  startAngle = this.angle

  ///@param {Number}
  startSpeed = this.speed
  
  ///@type {Player|Shroom}
  producer = template.producer
  //Assert.isTrue(this.producer == Player || this.producer == Shroom)

  ///@private
  ///@type {Number}
  lifespanMax = Struct.get(template, "lifespanMax")
  
  ///@type {Number}
  damage = Struct.get(template, "damage")

  ///@type {Boolean}
  wiggle = Struct.get(template, "wiggle")

  ///@type {Number}
  wiggleTime = Struct.get(template, "wiggleTime")

  ///@type {Boolean}
  wiggleTimeRng = Struct.get(template, "wiggleTimeRng")

  ///@type {Number}
  wiggleFrequency = Struct.get(template, "wiggleFrequency")

  ///@type {Boolean}
  wiggleDirRng = Struct.get(template, "wiggleDirRng")

  ///@type {Number}
  wiggleAmplitude = Struct.get(template, "wiggleAmplitude")

  this.wiggleTime = this.wiggleTimeRng ? random(this.wiggleTime) : this.wiggleTime
  this.wiggleFrequency = this.wiggleDirRng ? choose(1, -1) * this.wiggleFrequency : this.wiggleFrequency

  ///@type {?NumberTransformer}
  angleOffset = Optional.is(Struct.get(template, "angleOffset"))
    ? new NumberTransformer({
      value: template.useAngleOffset ? template.angleOffset.value : 0.0,
      target: template.changeAngleOffset ? template.angleOffset.target : (template.useAngleOffset ? template.angleOffset.value : 0.0),
      factor: template.changeAngleOffset ? template.angleOffset.factor : (template.useAngleOffset ? abs(template.angleOffset.value) : 999.9),
      increase: template.changeAngleOffset ? template.angleOffset.increase : 0.0,
    })
    : null

  ///@type {Boolean}
  angleOffsetRng = Struct.get(template, "angleOffsetRng") // false

  ///@param {Number}
  angleOffsetDir = this.angleOffsetRng ? choose(1.0, -1.0) : 1.0

  ///@type {?NumberTransformer}
  speedOffset = Optional.is(Struct.get(template, "speedOffset"))
    ? new NumberTransformer({
      value: template.useSpeedOffset ? template.speedOffset.value : 0.0,
      target: template.changeSpeedOffset ? template.speedOffset.target : (template.useSpeedOffset ? template.speedOffset.value : 0.0),
      factor: template.changeSpeedOffset ? template.speedOffset.factor : (template.useSpeedOffset ? abs(template.speedOffset.value) : 999.9),
      increase: template.changeSpeedOffset ? template.speedOffset.increase : 0.0,
    })
    : null
  
  ///@type {?String}
  onDeath = Struct.get(template, "onDeath")

  ///@type {?Number}
  onDeathAmount = Struct.get(template, "onDeathAmount")

  ///@type {?Number}
  onDeathAngle = Struct.get(template, "onDeathAngle")

  ///@type {?Boolean}
  onDeathAngleRng = Struct.get(template, "onDeathAngleRng")

  ///@type {?Number}
  onDeathAngleStep = Struct.get(template, "onDeathAngleStep")

  ///@type {?Number}
  onDeathRngStep = Struct.get(template, "onDeathRngStep")

  ///@type {?Number}
  onDeathSpeed = Struct.get(template, "onDeathSpeed")

  ///@type {?Boolean}
  onDeathSpeedMerge = Struct.get(template, "onDeathSpeedMerge")

  ///@type {?Number}
  onDeathRngSpeed = Struct.get(template, "onDeathRngSpeed")

  ///@param {VisuController} controller
  ///@return {Bullet}
  static update = function(controller) {
    gml_pragma("forceinline")
    var componentAngle = 0.0
    var componentSpeed = 0.0

    if (this.wiggle) {
      this.wiggleTime += DeltaTime.apply(this.wiggleFrequency * FRAME_MS)
      if (this.wiggleTime > TAU) {
        this.wiggleTime -= TAU
      } else if (this.wiggleTime < 0.0) {
        this.wiggleTime += TAU
      }
      componentAngle += sin(this.wiggleTime) * this.wiggleAmplitude
    }

    if (this.angleOffset != null) {
      componentAngle += this.angleOffsetDir * this.angleOffset.update().value
    }

    this.angle = this.startAngle + componentAngle

    if (this.speedOffset != null) {
      componentSpeed = this.speedOffset.update().value / 1000.0
    }

    this.speed = abs(this.startSpeed + componentSpeed)
    
    this.lifespan += DeltaTime.apply(FRAME_MS)
    if (this.lifespan >= this.lifespanMax
      || Optional.is(this.signals.shroomCollision)
      || Optional.is(this.signals.playerCollision)) {
      this.signal("kill")
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }
    
    return this
  }

  /* 
  ///@param {VisuController} controller
  ///@return {Bullet}
  static update = function(controller) {
    if (Optional.is(this.gameMode)) {
      gameMode.update(this, controller)
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }
    
    return this
  }

  this.gameModes
    .set(GameMode.RACING, BulletRacingGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "racing", {})))
    .set(GameMode.BULLETHELL, BulletBulletHellGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "bulletHell", {})))
    .set(GameMode.PLATFORMER, BulletPlatformerGameMode(Struct
      .getDefault(Struct.get(template, "gameModes"), "platformer", {})))
  */
}