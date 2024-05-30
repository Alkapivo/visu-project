///@package io.alkapivo.core.service.file

///@param {Struct} _controller
///@param {Struct} [config]
function FileService(_controller, config = {}): Service() constructor {

  ///@type {Controller}
  controller = Assert.isType(_controller, Struct)

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "fetch-file": function(event) {
      var task = new Task("fetch-file-buffer")
        .setPromise(event.promise) // pass promise to TaskExecutor
        .setState(new Map(String, any, { 
          path: Assert.isType(event.data.path, String)
        }))
        .whenUpdate(function(executor) {
          var path = this.state.get("path")
          var buffer = BufferUtil.loadAsTextBuffer(path)
          var data = buffer.get()
          buffer.free()
          Logger.info("FileService", $"FetchFileBuffer successfully: {path}")
          this.fullfill(new File({ path: path, data: data }))
        })
      
      this.executor.add(task)
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "fetch-file-dialog": function(event) {
      this.send(new Event("fetch-file")
        .setPromise(event.promise)
        .setData({ path: FileUtil.getPathToOpenWithDialog(event.data) }))
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "fetch-file-sync": function(event) {
      return FileUtil.readFileSync(event.data.path)
    },
    "fetch-file-sync-dialog": function(event) {
      this.send(new Event("fetch-file-sync")
        .setPromise(event.promise)
        .setData({ path: FileUtil.getPathToOpenWithDialog(event.data) }))
      event.setPromise() // disable promise in EventPump, the promise will be resolved within TaskExecutor
    },
    "save-file-sync": function(event) {
      FileUtil.writeFileSync(Assert.isType(event.data, File))
    },
  }))

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this)

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    Struct.set(event.data, "fileService", this)
    return this.dispatcher.send(event)
  }

  ///@return {FileService}
  update = function() {
    this.dispatcher.update()
    this.executor.update()
    return this
  }
}
