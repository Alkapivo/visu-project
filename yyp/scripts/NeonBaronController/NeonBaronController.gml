///@package io.alkapivo.neon-baron

#macro BeanNeonBaronController "NeonBaronController"
function NeonBaronController() constructor {

  ///@type {DisplayService}
  displayService = new DisplayService(this, { minWidth: 800, minHeight: 480 })

  ///@type {DialogueRenderer}
  dialogueRenderer = new DialogueRenderer()
  
  ///@type {?GMCamera}
  camera = null

  baron = {
    x: 800,
    y: 600,
    speed: 3,
    zoom: 1,
    sprite: SpriteUtil.parse({ name: "texture_baron_cursor" }),
    update: function() {
      var dx = 0
      var dy = 0
      if (keyboard_check(vk_left)) {
        dx -= this.speed
      }

      if (keyboard_check(vk_right)) {
        dx += this.speed
      }

      if (keyboard_check(vk_up)) {
        dy -= this.speed
      }

      if (keyboard_check(vk_down)) {
        dy += this.speed
      }

      var tilemap = layer_tilemap_get_id(layer_get_id("tileset_collision"))
      var _x = tilemap_get_cell_x_at_pixel(tilemap, this.x + dx, this.y + dy)
      var _y = tilemap_get_cell_y_at_pixel(tilemap, this.x + dx, this.y + dy)
      var tile = tilemap_get(tilemap, _x, _y);
      if (tile == 0) {
        this.x += dx
        this.y += dy
      }
      
      var _hor = keyboard_check(vk_right) - keyboard_check(vk_left)
      var _ver = keyboard_check(vk_down) - keyboard_check(vk_up)
      var _viewX = camera_get_view_x(view_camera[0])
      var _viewY = camera_get_view_y(view_camera[0])
      var _viewW = camera_get_view_width(view_camera[0])
      var _viewH = camera_get_view_height(view_camera[0])
      var _gotoX = x + (_hor * 200) - (_viewW * 0.5)
      var _gotoY = y + (_ver * 150) - (_viewH * 0.5)
      var _newX = lerp(_viewX, _gotoX, 0.03)
      var _newY = lerp(_viewY, _gotoY, 0.03)
      //camera_set_view_pos(view_camera[0], _newX, _newY)

      var _factor = 0.05
      var _mouseW = mouse_wheel_down() - mouse_wheel_up()
      this.zoom = clamp(this.zoom + (_mouseW * _factor), _factor, 2)
      var _lerpH = lerp(_viewH, this.zoom * GuiHeight(), _factor)
      var _newH = clamp(_lerpH, 0, room_height)
      var _newW = _newH * (GuiWidth() / GuiHeight())
      camera_set_view_size(view_camera[0], _newW, _newH)

      var _offsetX = _newX - (_newW - _viewW) * 0.2
      var _offsetY = _newY - (_newH - _viewH) * 0.2
      _newX = clamp(_offsetX, 0, room_width - _newW)
      _newY = clamp(_offsetY, 0, room_height - _newH)
      camera_set_view_pos(view_camera[0], _newX, _newY)
    },
    render: function() {
      this.sprite.render(this.x - (this.sprite.getWidth() / 2.0), this.y - (this.sprite.getHeight() / 2.0))
    }
  }

  baron = new TDMC({
    x: 300,
    y: 300,
    maxSpeed: 3
  })
  gmTdmcCollider = null


  isLDTKLoaded = false
  ldtkWorld = null
  isVisuMode = false

  entities = new Map(String, Callable, {
    ///@param {GMLayer} layerId
    ///@param {LDTKEntity} entity
    "entity_npc": function(layerId, entity) {
      Beans.get(BeanTopDownController).npcService.set(
        entity.uid, {
          x: entity.x,
          y: entity.y,
          sprite: SpriteUtil.parse({ name: "texture_bazyl_cursor" }),
        })
    },
  })

  npcs = new Map(String, Struct)

  initView = function(width, height) {
    Core.print("initView")
    view_enabled = true
    view_visible[0] = true
    view_xport[0] = 0;
    view_yport[0] = 0;
    view_wport[0] = width
    view_hport[0] = height
    view_camera[0] = camera_create_view(
      0, 0, 
      view_wport[0], view_hport[0], 
      0, 
      noone, 
      -1, 
      -1, 
      0, 
      0
    );

    return this
  }

  zoom = 1

  update = function() {
    if (!isLDTKLoaded) {
      this.isLDTKLoaded = true
      this.ldtkWorld = new LDTKWorld(JSON.parse(FileUtil.readFileSync($"{working_directory}_test-world.ldtk").getData())).setEntities(this.entities)
      this.ldtkWorld.generate("level_0", -1000)
      var level = this.ldtkWorld.levels.find(function(level, index, name) {
        return level.name == name
      }, "level_0")
      room_width = level.width
      room_height = level.height

      this.gmTdmcCollider = GMObjectUtil.factoryGMObject(TDMCCollider, layer_get_id("instance_main"), 0, 0)
      Struct.set(this.baron, "gmObject", this.gmTdmcCollider)
      GMObjectUtil.set(this.gmTdmcCollider, "baron", this.baron)
      GMObjectUtil.set(this.gmTdmcCollider, "move", null)
      with (this.gmTdmcCollider) {
        move = use_tdmc()
      }
      
    }    

    if (this.displayService.update().state = "resized") {
      this.initView(GuiWidth(), GuiHeight())
    }
    
    var visuController = Beans.get(BeanVisuController)
    if (Core.isType(visuController, VisuController)) {
      var stateName = visuController.fsm.getStateName()
      this.isVisuMode = stateName == "load" || stateName == "play" || stateName == "resume" || stateName == "rewind"
    }

    if (!this.isVisuMode) {
      this.baron.update()

      var _hor = keyboard_check(vk_right) - keyboard_check(vk_left)
      var _ver = keyboard_check(vk_down) - keyboard_check(vk_up)
      var _viewX = camera_get_view_x(view_camera[0])
      var _viewY = camera_get_view_y(view_camera[0])
      var _viewW = camera_get_view_width(view_camera[0])
      var _viewH = camera_get_view_height(view_camera[0])
      var _gotoX = this.baron.x + (_hor * 0) - (_viewW * 0.5)
      var _gotoY = this.baron.y + (_ver * 0) - (_viewH * 0.5)
      var _newX = lerp(_viewX, _gotoX, 0.03)
      var _newY = lerp(_viewY, _gotoY, 0.03)
      //camera_set_view_pos(view_camera[0], _newX, _newY)

      var _factor = 0.05
      var _mouseW = mouse_wheel_down() - mouse_wheel_up()
      this.zoom = clamp(this.zoom + (_mouseW * _factor), _factor, 2)
      var _lerpH = lerp(_viewH, this.zoom * GuiHeight(), _factor)
      var _newH = clamp(_lerpH, 0, room_height)
      var _newW = _newH * (GuiWidth() / GuiHeight())
      camera_set_view_size(view_camera[0], _newW, _newH)

      var _offsetX = _newX - (_newW - _viewW) * 0.2
      var _offsetY = _newY - (_newH - _viewH) * 0.2
      _newX = clamp(_offsetX, 0, room_width - _newW)
      _newY = clamp(_offsetY, 0, room_height - _newH)
      camera_set_view_pos(view_camera[0], _newX, _newY)
    }

    if (keyboard_check_pressed(vk_f10)) {
      Beans.get(BeanDialogueService).open("dd_test")
    }
    
    return this
  }

  render = function() {
    this.baron.render()

    this.npcs.forEach(function(npc) {
      npc.render()
    })
    return this
  }

  renderGUI = function() {
    if (this.isVisuMode) {
      return this
    }

    
    draw_surface(application_surface, 0, 0)
    surface_set_target(application_surface)
    draw_clear(c_black)
    surface_reset_target()
    this.dialogueRenderer.update().render()
    return this
  }

  free = function() {
    return this
  }

  this.initView(1280, 720)
}