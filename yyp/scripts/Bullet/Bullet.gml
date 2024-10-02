///@package io.alkapivo.visu.service.bullet

///@param {String}
///@param {Struct} json
function BulletTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  ///@type {Struct}
  sprite = Assert.isType(Struct.get(json, "sprite"), Struct)

  ///@type {?Struct}
  mask = Struct.contains(json, "mask")
    ? Assert.isType(json.mask, Struct)
    : null

  ///@type {?Number}
  damage = Core.isType(Struct.get(json, "damage"), Number) 
    ? json.damage 
    : null

  ///@type {?Number}
  lifespawnMax = Core.isType(Struct.get(json, "lifespawnMax"), Number)
    ? json.lifespawnMax
    : null 

  ///@type {?String}
  bulletTemplateOnDeath = Core.isType(Struct.get(json, "bulletTemplateOnDeath"), String)
    ? json.bulletTemplateOnDeath
    : null

  ///@private
  ///@type {?Number}
  bulletAmountOnDeath = Core.isType(Struct.get(json, "bulletAmountOnDeath"), Number)
    ? json.bulletAmountOnDeath
    : null

  ///@private
  ///@type {?Number}
  bulletSpawnAngleOnDeath = Core.isType(Struct.get(json, "bulletSpawnAngleOnDeath"), Number)
    ? json.bulletSpawnAngleOnDeath
    : null

  ///@private
  ///@type {?Number}
  bulletAngleStepOnDeath = Core.isType(Struct.get(json, "bulletAngleStepOnDeath"), Number)
    ? json.bulletAngleStepOnDeath
    : null

  ///@type {?Struct}
  speedTransformer = Core.isType(Struct.get(json, "speedTransformer"), Struct) 
    ? json.speedTransformer
    : null

  ///@type {?Struct}
  angleTransformer = Core.isType(Struct.get(json, "angleTransformer"), Struct)
    ? json.angleTransformer
    : null

  ///@private
  ///@type {?Boolean}
  randomDirection = Core.isType(Struct.get(json, "randomDirection"), Boolean)
    ? json.randomDirection
    : null

  ///@type {?Struct}
  swingAmount = Core.isType(Struct.get(json, "swingAmount"), Struct)
    ? json.swingAmount
    : null

  ///@type {?Struct}
  swingSize = Core.isType(Struct.get(json, "swingSize"), Struct)
    ? json.swingSize
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

    if (Optional.is(this.angleTransformer)) {
      Struct.set(json, "angleTransformer", this.angleTransformer)
    }

    if (Optional.is(this.randomDirection)) {
      Struct.set(json, "randomDirection", this.randomDirection)
    }

    if (Optional.is(this.swingSize)) {
      Struct.set(json, "swingSize", this.swingSize)
    }

    if (Optional.is(this.swingAmount)) {
      Struct.set(json, "swingAmount", this.swingAmount)
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
  ///@type {?Struct}
  speedTransformer = Core.isType(Struct.get(template, "speedTransformer"), Struct) 
    ? new NumberTransformer(template.speedTransformer)
    : null

  ///@private
  ///@type {Boolean}
  isSpeedTransformerSet = false
  
  ///@private  
  ///@type {?NumberTransformer}
  angleTransformer = Core.isType(Struct.get(template, "angleTransformer"), Struct) 
    ? new NumberTransformer(template.angleTransformer)
    : null

  ///@private
  ///@type {Boolean}
  isAngleTransformerSet = false

  ///@private
  ///@type {Number}
  initAngle = this.angle

  ///@private
  ///@type {Boolean}
  randomDirection = Core.isType(Struct.get(template, "randomDirection"), Boolean)
    ? template.randomDirection
    : false

  ///@private    
  ///@type {?NumberTransformer}
  swingAmount = Core.isType(Struct.get(template, "swingAmount"), Struct) 
    ? new NumberTransformer(template.swingAmount)
    : null
  
  ///@private
  ///@type {?NumberTransformer}
  swingSize = Core.isType(Struct.get(template, "swingSize"), Struct) 
    ? new NumberTransformer(template.swingSize)
    : null

  ///@private
  ///@type {Timer}
  swingTimer = new Timer(pi * 2, { loop: Infinity })

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
    if (this.speedTransformer != null) {
      if (!this.isSpeedTransformerSet) {
        this.speedTransformer.value = this.speed * 1000.0
        this.speedTransformer.startValue = this.speedTransformer.value
        this.isSpeedTransformerSet = true
      }
      this.speed = this.speedTransformer.update().value / 1000.0
    }
    
    if (this.angleTransformer != null) {
      if (!this.isAngleTransformerSet) {
        var _sign = this.randomDirection ? choose(1, -1) : 1
        this.angleTransformer.target *= _sign
        this.initAngle = this.angle
        this.isAngleTransformerSet = true
      }
      this.angle = Math.normalizeAngle(this.initAngle 
        + this.angleTransformer.update().value)
    }
    
    if (this.swingAmount != null) {
      this.swingTimer.amount = this.swingAmount.update().value
    }

    if (this.swingSize != null) {
      this.angle = Math.normalizeAngle(this.angle
        + (sin(this.swingTimer.update().time) 
        * this.swingSize.update().value))
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
