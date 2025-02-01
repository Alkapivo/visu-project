///@package io.alkapivo.visu.

///@param {GridECS} _system
function MovementSystem(_system) constructor {

  ///@type {GridECS}
  system = Assert.isType(_system, GridECS)

  ///@param {GridEntity} entity
  ///@param {String} key
  ///@param {GridECS} system
  static moveEntity = function(entity, key, system) {
    entity.signals.reset()
    entity.position.x += Math.fetchCircleX(entity.velocity.speed, entity.velocity.angle)
    entity.position.y += Math.fetchCircleY(entity.velocity.speed, entity.velocity.angle)
    var view = system.controller.gridService.view
    if (Math.fetchLength(entity.position.x, entity.position.y, 
      view.x + (view.width / 2.0), view.y + (view.height / 2.0)) 
       > GRID_ITEM_FRUSTUM_RANGE) {

      entity.signal("kill")
      system.entities.gc.push(entity.key)
    }
  }

  ///@return {MovementSystem}
  static update = function() {
    this.system.entities.bullets.forEach(this.moveEntity, this.system)
    this.system.entities.enemies.forEach(this.moveEntity, this.system)
    this.system.entities.players.forEach(this.moveEntity, this.system)
    return this
  }
}

