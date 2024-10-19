///@package io.alkapivo.visu.service.bullet

///@param {String}
///@param {Struct} json
function BulletTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Struct}
  sprite = Assert.isType(Struct.get(json, "sprite"), Struct)

  ///@type {?Struct}
  mask = Struct.getIfType(json, "mask", Struct)

  ///@type {?Number}
  damage = Struct.getIfType(json, "damage", Number)

  ///@type {?Number}
  lifespawnMax = Struct.getIfType(json, "lifespawnMax", Number)

  ///@type {?String}
  bulletTemplateOnDeath = Struct.getIfType(json, "bulletTemplateOnDeath", String)

  ///@private
  ///@type {?Number}
  bulletAmountOnDeath = Struct.getIfType(json, "bulletAmountOnDeath", Number)

  ///@private
  ///@type {?Number}
  bulletSpawnAngleOnDeath = Struct.getIfType(json, "bulletSpawnAngleOnDeath", Number)

  ///@private
  ///@type {?Number}
  bulletAngleStepOnDeath = Struct.getIfType(json, "bulletAngleStepOnDeath", Number)

  ///@type {?Struct}
  speedTransformer = Struct.getIfType(json, "speedTransformer", Struct)

  ///@type {?Struct}
  speedWiggleValue = Struct.getIfType(json, "speedWiggleValue", Struct)

  ///@type {?Struct}
  speedWiggleInterval = Struct.getIfType(json, "speedWiggleInterval", Struct)

  ///@type {?Struct}
  angleTransformer = Struct.getIfType(json, "angleTransformer", Struct)

  ///@type {?Struct}
  angleWiggleValue = Struct.getIfType(json, "angleWiggleValue", Struct)

  ///@type {?Struct}
  angleWiggleInterval = Struct.getIfType(json, "angleWiggleInterval", Struct)

  ///@private
  ///@type {?Boolean}
  randomDirection = Core.isType(Struct.get(json, "randomDirection"), Boolean)
    ? json.randomDirection
    : null

  ///@return {Struct}
  serialize = function() {
    var json = {
      sprite: this.sprite,
    }

    if (Optional.is(this.mask)) {
      Struct.set(json, "mask", this.mask)
    }

    if (Optional.is(this.damage)) {
      Struct.set(json, "damage", this.damage)
    }

    if (Optional.is(this.lifespawnMax)) {
      Struct.set(json, "lifespawnMax", this.lifespawnMax)
    }

    if (Optional.is(this.bulletTemplateOnDeath)) {
      Struct.set(json, "bulletTemplateOnDeath", this.bulletTemplateOnDeath)
    }

    if (Optional.is(this.bulletAmountOnDeath)) {
      Struct.set(json, "bulletAmountOnDeath", this.bulletAmountOnDeath)
    }

    if (Optional.is(this.bulletSpawnAngleOnDeath)) {
      Struct.set(json, "bulletSpawnAngleOnDeath", this.bulletSpawnAngleOnDeath)
    }

    if (Optional.is(this.bulletAngleStepOnDeath)) {
      Struct.set(json, "bulletAngleStepOnDeath", this.bulletAngleStepOnDeath)
    }

    if (Optional.is(this.speedTransformer)) {
      Struct.set(json, "speedTransformer", this.speedTransformer)
    }

    if (Optional.is(this.speedWiggleValue) && Optional.is(this.speedWiggleInterval)) {
      Struct.set(json, "speedWiggleValue", this.speedWiggleValue)
      Struct.set(json, "speedWiggleInterval", this.speedWiggleInterval)
    }

    if (Optional.is(this.angleTransformer)) {
      Struct.set(json, "angleTransformer", this.angleTransformer)
    }

    if (Optional.is(this.angleWiggleValue) && Optional.is(this.angleWiggleInterval)) {
      Struct.set(json, "angleWiggleValue", this.angleWiggleValue)
      Struct.set(json, "angleWiggleInterval", this.angleWiggleInterval)
    }

    if (Optional.is(this.randomDirection)) {
      Struct.set(json, "randomDirection", this.randomDirection)
    }

    return JSON.clone(json)
  }
}


///@param {BulletTemplate} template
function Bullet(template): GridItem(template) constructor {

  ///@type {Player|Shroom}
  producer = template.producer
  Assert.isTrue(this.producer == Player || this.producer == Shroom)

  ///@type {Number}
  damage = Core.isType(Struct.get(template, "damage"), Number) 
    ? template.damage 
    : 1

  ///@private
  ///@type {?NumberTransformer}
  speedTransformer = new NumberTransformer(Struct
    .getIfType(template, "speedTransformer", Struct, { 
      target: this.speed * 1000.0, 
      factor: this.speed * 1000.0,
    }))

  ///@private
  ///@type {Boolean}
  isSpeedTransformerSet = false

  ///@private
  ///@type {Number}
  speedWiggle = new Timer(pi * 2.0, { loop: Infinity })

  ///@private
  ///@type {?NumberTransformer}
  speedWiggleValue = Core.isType(Struct.get(template, "speedWiggleValue"), Struct)
    ? new NumberTransformer(template.speedWiggleValue)
    : null

  ///@private
  ///@type {NumberTransformer}
  speedWiggleInterval = Core.isType(Struct.get(template, "speedWiggleInterval"), Struct)
    ? new NumberTransformer(template.speedWiggleInterval)
    : null


  ///@private  
  ///@type {NumberTransformer}
  angleTransformer = new NumberTransformer(Struct
    .getIfType(template, "angleTransformer", Struct))

  ///@private
  ///@type {Boolean}
  isAngleTransformerSet = false

  ///@private
  ///@type {Number}
  angleWiggle = new Timer(pi * 2.0, { loop: Infinity })

  ///@private
  ///@type {NumberTransformer}
  angleWiggleValue = Core.isType(Struct.get(template, "angleWiggleValue"), Struct)
    ? new NumberTransformer(template.angleWiggleValue)
    : null

  ///@private
  ///@type {NumberTransformer}
  angleWiggleInterval = Core.isType(Struct.get(template, "angleWiggleInterval"), Struct)
    ? new NumberTransformer(template.angleWiggleInterval)
    : null

  ///@private
  ///@type {Boolean}
  randomDirection = Core.isType(Struct.get(template, "randomDirection"), Boolean)
    ? template.randomDirection
    : false

  ///@private
  ///@type {Number}
  lifespawnMax = Core.isType(Struct.get(template, "lifespawnMax"), Number)
    ? template.lifespawnMax
    : 30.0

  ///@private
  ///@type {?String}
  bulletTemplateOnDeath = Core.isType(Struct.get(template, "bulletTemplateOnDeath"), String)
    ? template.bulletTemplateOnDeath
    : null

  ///@private
  ///@type {Number}
  bulletAmountOnDeath = Core.isType(Struct.get(template, "bulletAmountOnDeath"), Number)
    ? template.bulletAmountOnDeath
    : 1.0

  ///@private
  ///@type {Number}
  bulletSpawnAngleOnDeath = Core.isType(Struct.get(template, "bulletSpawnAngleOnDeath"), Number)
    ? template.bulletSpawnAngleOnDeath
    : 0.0
  
  ///@private
  ///@type {Number}
  bulletAngleStepOnDeath = Core.isType(Struct.get(template, "bulletAngleStepOnDeath"), Number)
    ? template.bulletAngleStepOnDeath
    : 0.0

  ///@param {VisuController} controller
  ///@return {Bullet}
  static update = function(controller) {
    if (!this.isSpeedTransformerSet) {
      this.speedTransformer.value = this.speed * 1000.0
      this.speedTransformer.startValue = this.speedTransformer.value
      this.isSpeedTransformerSet = true
    }

    if (this.speedWiggleValue != null && this.speedWiggleInterval != null) {
      this.speed = (this.speedTransformer.update().value + abs(((cos(this.speedWiggle
        .setAmount(this.speedWiggleInterval.update().value).update().time) - 1.0) / 2.0) 
        * this.speedWiggleValue.update().value)) / 1000.0
    } else {
      this.speed = this.speedTransformer.update().value / 1000.0
    }

    if (!this.isAngleTransformerSet) {
      this.angleTransformer.target = this.angleTransformer.target * (this.randomDirection ? choose(1, -1) : 1)
      this.angleTransformer.startValue = Math.normalizeAngle(this.angle)
      this.isAngleTransformerSet = true
    }

    if (this.angleWiggleValue != null && this.angleWiggleInterval != null) {
      this.angle = this.angleTransformer.startValue 
        + this.angleTransformer.update().value + (sin(this.angleWiggle
        .setAmount(this.angleWiggleInterval.update().value).update().time)
        * this.angleWiggleValue.update().value)
    } else {
      this.angle = this.angleTransformer.startValue + this.angleTransformer.update().value
    }
    
    this.lifespawn += DeltaTime.apply(FRAME_MS)
    if (this.lifespawn >= this.lifespawnMax
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
