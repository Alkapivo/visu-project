///@package io.alkapivo.visu

///@todo missing absolute path validation
///@param {Struct} json
function VisuTrack(_path, json) constructor {

  ///@type {String}
  path = Assert.isType(FileUtil.getDirectoryFromPath(_path), String)

  ///@type {Number}
  bpm = Assert.isType(Struct.getDefault(json, "bpm", Beans
    .get(BeanVisuController).editor.store.getValue("bpm")), Number)

  ///@type {Number}
  bpmSub = Assert.isType(Struct.getDefault(json, "bpm-sub", Beans
    .get(BeanVisuController).editor.store.getValue("bpm-sub")), Number)

  ///@type {String}
  sound = Assert.isType(Struct.get(json, "sound"), String)

  ///@type {String}
  track = Assert.isType(Struct.get(json, "track"), String)
  
  ///@type {String}
  bullet = Assert.isType(Struct.get(json, "bullet"), String)
  
  ///@type {String}
  lyrics = Assert.isType(Struct.get(json, "lyrics"), String)
  
  ///@type {String}
  particle = Assert.isType(Struct.get(json, "particle"), String)
  
  ///@type {String}
  shader = Assert.isType(Struct.get(json, "shader"), String)
  
  ///@type {String}
  shroom = Assert.isType(Struct.get(json, "shroom"), String)
  
  ///@type {String}
  texture = Assert.isType(Struct.get(json, "texture"), String)

  ///@type {?String}
  video = Core.isType(Struct.get(json, "video"), String)
    ? json.video
    : null

  ///@type {Array<String>}
  editor = new Array(String, json.editor)

  saveProject = function(manifestPath) {
    var controller = Beans.get(BeanVisuController)
    var fileService = controller.fileService
    var previousPath = this.path
    var path = Assert.isType(FileUtil.getDirectoryFromPath(manifestPath), String)
    var manifest = {
      "model": "io.alkapivo.visu.controller.VisuTrack",
      "version": "1",
      "data": {  
        "bpm": this.bpm,
        "bpm-sub": this.bpmSub,
        "track": this.track,
        "bullet": this.bullet,
        "lyrics": this.lyrics,
        "particle": this.particle,
        "shader": this.shader,
        "shroom": this.shroom,
        "sound": this.sound,
        "texture": this.texture,
        "video": this.video,
        "editor": controller.editor.brushService.templates
          .keys()
          .map(function(filename) {
            return $"brush/{filename}.json"
          })
          .getContainer(),
      }
    }

    FileUtil.createDirectory($"{path}brush")
    FileUtil.createDirectory($"{path}template")
    FileUtil.createDirectory($"{path}texture")

    #region Serialize
    var track = controller.trackService.track.serialize()

    var sound = {
      "model": "Collection<io.alkapivo.core.service.sound.SoundIntent>",
      "version": "1",
      "data": {}
    }
    Beans.get(BeanSoundService).intents
      .forEach(function(intent, name, data) {
        Struct.set(data, name, intent.serialize())
      }, sound.data)

    var bullet = {
      "model": "Collection<io.alkapivo.visu.service.bullet.BulletTemplate>",
      "version": "1",
      "data": {},
    }
    controller.bulletService.templates
      .forEach(function(template, name, data) {
        Struct.set(data, template.name, template.serialize())
      }, bullet.data)

    var lyrics = {
      "model": "Collection<io.alkapivo.visu.service.lyrics.LyricsTemplate>",
      "version": "1",
      "data": {},
    }
    controller.lyricsService.templates
      .forEach(function(template, name, data) {
        Struct.set(data, template.name, template.serialize())
      }, lyrics.data)

    var particle = {
      "model": "Collection<io.alkapivo.core.service.particle.ParticleTemplate>",
      "version": "1",
      "data": {},
    }
    controller.particleService.templates
      .forEach(function(template, name, data) {
        Struct.set(data, template.name, template.serialize())
      }, particle.data)
    
    var shader = {
      "model": "Collection<io.alkapivo.core.service.shader.ShaderTemplate>",
      "version": "1",
      "data": {},
    }
    controller.shaderPipeline.templates
      .forEach(function(template, name, data) {
        Struct.set(data, template.name, template.serialize())
      }, shader.data)

    var shroom = {
      "model": "Collection<io.alkapivo.visu.service.shroom.ShroomTemplate>",
      "version": "1",
      "data": {},
    }
    controller.shroomService.templates
      .forEach(function(template, name, data) {
        Struct.set(data, template.name, template.serialize())
      }, shroom.data)

    var textureAcc = {
      texture: {
        "model": "Collection<io.alkapivo.core.service.texture.TextureIntent>",
        "version": "1",
        "data": {},
      },
      files: new Map(String, Struct),
    }
    Beans.get(BeanTextureService).templates
      .forEach(function(template, name, acc) {
        var path = template.file
        var json = template.serialize()
        json.file = $"texture/{json.file}"
        acc.files.set(path, json)
        Struct.set(acc.texture.data, template.name, json)
      }, textureAcc)

    var editor = {}
    controller.editor.brushService.templates
      .forEach(function(templates, type, editor) {
        Struct.set(editor, type, {
          "model": "Collection<io.alkapivo.visu.editor.api.VEBrushTemplate>",
          "version": "1",
          "data": templates.getContainer(),
        })
      }, editor)

    var video = null
    var sourceVideo = null
    if (Optional.is(this.video)) {
      sourceVideo = Assert.isType(FileUtil.get(Struct.get(controller.videoService.getVideo(), "path")), String)
      video = FileUtil.getFilenameFromPath(sourceVideo)
    } 
    #endregion

    #region Save
    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: manifestPath,
        data: String.replaceAll(JSON.stringify(manifest, { pretty: true }), "\\", ""),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.track}",
        data: track,
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.bullet}",
        data: JSON.stringify(bullet, { pretty: true }),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.lyrics}",
        data: JSON.stringify(lyrics, { pretty: true }),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.particle}",
        data: JSON.stringify(particle, { pretty: true }),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.shader}",
        data: JSON.stringify(shader, { pretty: true }),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.shroom}",
        data: JSON.stringify(shroom, { pretty: true }),
    })))

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.texture}",
        data: String.replaceAll(JSON.stringify(textureAcc.texture, { pretty: true }), "\\", ""),
    })))
    textureAcc.files.forEach(function(template, sourcePath, targetDirectory) {
      FileUtil.copyFile(sourcePath, $"{targetDirectory}{template.file}")
    }, path)

    fileService.send(new Event("save-file-sync")
      .setData(new File({
        path: $"{path}{this.sound}",
        data: JSON.stringify(sound, { pretty: true }),
    })))
    Struct.forEach(sound.data, function(intent, name, acc) {
      FileUtil.copyFile($"{acc.source}{intent.file}", $"{acc.target}{intent.file}")
    }, {
      source: previousPath,
      target: path,
    })

    if (Optional.is(this.video)) {
      FileUtil.copyFile(sourceVideo, $"{path}{video}")
    }

    Struct.forEach(editor, function(data, filename, acc) {
      acc.fileService.send(new Event("save-file-sync")
        .setData(new File({
          path: $"{acc.path}brush/{filename}.json",
          data: JSON.stringify(data, { pretty: true }),
      })))
    }, { path: path, fileService: fileService })
    #endregion
  }
}