///@package io.alkapivo.visu.

  

///@param {GridSystem} _system
function CollisionSystem(_system) constructor {

  ///@type {GridSystem}
  system = Assert.isType(_system, GridSystem)

  ///@param {GridEntity} source
  ///@param {GridEntity} target
  ///@return {Bollean}
  static collide = function(source, target) { 
    var sourceSprite = source.renderSprite.sprite
    var sourceWidth = sourceSprite.getWidth() * sourceSprite.getScaleX()
    var sourceHeight = sourceSprite.getHeight() * sourceSprite.getScaleY()
    var targetSprite = target.renderSprite.sprite
    var targetWidth = targetSprite.getWidth() * targetSprite.getScaleX()
    var targetHeight = targetSprite.getHeight() * targeteSprite.getScaleY()
    var sourceX = source.position.x * GRID_SERVICE_PIXEL_WIDTH
    var sourceY = source.position.y * GRID_SERVICE_PIXEL_HEIGHT
    var targetX = target.position.x * GRID_SERVICE_PIXEL_WIDTH
    var targetY = target.position.y * GRID_SERVICE_PIXEL_HEIGHT
    return Math.rectangleOverlaps(
      sourceX - (sourceWidth / 2.0), sourceY - (sourceHeight / 2.0),
      sourceX + (sourceWidth / 2.0), sourceY + (sourceHeight / 2.0),
      targetX - (targetWidth / 2.0), targetY - (targetHeight / 2.0),
      targetX + (targetWidth / 2.0), targetY + (targetHeight / 2.0)
    )
  }


  ///@return {CollisionSystem}
  static update = function() {
    static dispatchCollision = function(player, key, context) {
      static bulletCollision = function(bullet, key, context) {
        static playerBullet = function(enemy, key, acc) {
          if (acc.collide(enemy, acc.bullet)) {
            enemy.signal("bulletCollision")
            acc.bullet.signal("enemyCollision")
          }
        }
        
        static enemyBullet = function(player, key, acc) {
          if (acc.collide(player, acc.bullet)) {
            player.signal("bulletCollision")
            acc.bullet.signal("playerCollision")
          }
        }

        switch (bullet.shoot.producer) {
          case GridEventType.PLAYER:
            context.system.entities.enemies.forEach(playerBullet, { 
              bullet: bullet, 
              collide: context.collide,
            })
            break
          case GridEventType.ENEMY:
            context.system.entities.players.forEach(enemyBullet, { 
              bullet: bullet, 
              collide: context.collide,
            })
            break
          default:
            Logger.warn("GridService", "Found invalid bullet producer")
            break
        }
      }

      static enemyCollision = function(enemy, index, context) {
        static playerCollision = function(player, key, acc) {
          if (acc.collide(player, acc.enemy)) {
            player.signal("enemyCollision")
            acc.enemy.signal("playerCollision")
          }
        }

        context.system.entities.players.forEach(playerCollision, { 
          enemy: enemy, 
          collide: context.collide,
        })
      }

      context.system.entities.bullets.forEach(bulletCollision, context) 
      context.system.entities.enemies.forEach(enemyCollision, context)
    }

    this.system.entities.players.forEach(dispatchCollision, this)
    return this
  }
}