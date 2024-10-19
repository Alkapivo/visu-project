///@package io.alkapivo.core.service.ldtk

///@enum
function _LDTKLayerType(): Enum() constructor {
  ENTITY = "Entities"
  TILE = "Tiles"
}
global.__LDTKLayerType = new _LDTKLayerType()
#macro LDTKLayerType global.__LDTKLayerType


///@param {Struct} json
function LDTKWorld(json) constructor {

  ///@type {String}
  name = Assert.isType(json.iid, String)

  ///@type {String}
  version = Assert.isType(json.jsonVersion, String)

  ///@type {Array<LDTKLevel>}
  levels = new Array(LDTKLevel, GMArray.map(json.levels, function(json) {
    return new LDTKLevel(json)
  }))

  ///@type {Map<String, GMTileset>}
  tilesets = new Map(String, GMTileset)
  GMArray.forEach(json.defs.tilesets, function(tileset, index, world) {
    world.tilesets.set($"{tileset.uid}", Assert.isType(asset_get_index(tileset.identifier), GMTileset))
  }, this)

  ///@type {Map<String, Callable>}
  entities = new Map(String, Callable)

  ///@type {Map<String, Callable>}
  ///@throws {AssertException}
  ///@return {LDTKWorld}
  setEntities = function(entities) {
    Assert.isType(entities, Map)
    Assert.isTrue(entities.keyType == String)
    Assert.isTrue(entities.valueType == Callable)
    this.entities = entities
    return this
  }


  ///@param {String} levelName
  ///@param {Number} depth
  ///@param {?LevelState} levelState
  ///@return {Array<String>}
  generate = function(levelName, depth, levelState) {
    var level = Assert.isType(this.levels.find(function(level, index, name) {
      return level.name == name
    }, levelName), LDTKLevel)

    var world = this
    return level.layers.map(function(ldtkLayer, index, acc) {
      switch (ldtkLayer.type) {
        case LDTKLayerType.TILE:
          var layerId = Scene.fetchLayer(ldtkLayer.name, acc.depth - index)
          var tileset = acc.world.tilesets.get(ldtkLayer.tilesetUid)
          var tilemap = layer_tilemap_create(layerId, 0, 0, tileset, ldtkLayer.cellWidth, ldtkLayer.cellHeight)
          ldtkLayer.tiles.forEach(function(tile, index, tilemap) {
            tilemap_set(tilemap, tile[2], tile[0], tile[1])
          }, tilemap)
          break
        case LDTKLayerType.ENTITY:
          var layerId = Scene.fetchLayer(ldtkLayer.name, acc.depth - index)
          ldtkLayer.entities.forEach(function(entity, index, acc) {
            if (entity.type != "entity_npc") {
              return
            }

            var factory = acc.world.entities.get(entity.type)
            if (!Core.isType(Struct.get(acc.levelState, "dynamic"), Struct)) {
              factory(acc.layerId, entity)
            } else {
              var entityData = Struct.get(acc.levelState.dynamic, entity.uid)
              if (Optional.is(entityData)) {
                factory(acc.layerId, entityData)
              }
            }
          }, {
            world: acc.world,
            layerId: layerId,
            levelState: acc.levelState,
          })
          break
        default: throw new Exception($"Not supported LDTKLayerType: {ldtkLayer.type}")
      }

      return ldtkLayer.name
    }, {
      world: world,
      depth: depth,
      levelState: levelState,
    }, String)
  }
}


///@param {Struct} json
function LDTKLevel(json) constructor {

  ///@type {String}
  name = Assert.isType(json.identifier, String)

  ///@type {Number}
  width = Assert.isType(json.pxWid, Number)

  ///@type {Number}
  height = Assert.isType(json.pxHei, Number)

  ///@type {Array<LDTKLayer>}
  layers = new Array(LDTKLayer, GMArray.map(json.layerInstances, function(json) {
    return new LDTKLayer(json)
  }))
}


///@param {Struct} json
function LDTKLayer(json) constructor {

  ///@type {String}
  name = Assert.isType(json.__identifier, String)

  ///@type {LDTKLayerType}
  type = Assert.isEnum(json.__type, LDTKLayerType)

  ///@type {Number}
  gridSize = Assert.isType(json.__gridSize, Number)

  ///@type {Number}
  cellWidth = Assert.isType(json.__cWid, Number)

  ///@type {Number}
  cellHeight = Assert.isType(json.__cHei, Number)

  ///@type {?String}
  tilesetUid = Core.isType(json.__tilesetDefUid, Number)
    ? $"{json.__tilesetDefUid}"
    : null

  ///@type {?Array<GMArray>}
  tiles = null
  if (this.type == LDTKLayerType.TILE) {
    Assert.isType(this.tilesetUid, String)
    this.tiles = new Array(GMArray, GMArray.map(json.gridTiles, function(tile, index, ldtkLayer) {
      // Initializing array is faster than struct
      return [ 
        tile.px[0] div ldtkLayer.gridSize, // x: Number
        tile.px[1] div ldtkLayer.gridSize, // y: Number
        tile.t // tile: Number
      ]
    }, this))
  }

  ///@type {?Array<LDTKEntity>}
  entities = null
  if (this.type == LDTKLayerType.ENTITY) {
    this.entities = new Array(LDTKEntity, GMArray
      .map(json.entityInstances, function(json) {
        return new LDTKEntity(json)
      }))
  }
}


///@param {Struct} json
function LDTKEntity(json) constructor {

  ///@type {String}
  type = Assert.isType(json.__identifier, String)

  ///@type {String}
  uid = Assert.isType(json.iid, String)

  ///@type {Number}
  x = Assert.isType(json.px[0], Number)

  ///@type {Number}
  y = Assert.isType(json.px[1], Number)

  ///@type {Number}
  width = Assert.isType(json.width, Number)

  ///@type {Number}
  height = Assert.isType(json.height, Number)

  ///@type {?Struct}
  data = GMArray.size(json.fieldInstances) > 0 ? {} : null
  if (Optional.is(this.data)) {
    GMArray.forEach(json.fieldInstances, function(json, index, entity) {
      Struct.set(entity.data, json.__identifier, json.__value)
    }, this)
  }
}
