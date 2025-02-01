///@package io.alkapivo.core.task

///@param {Struct} _context
///@param {Struct} [config]
function TaskExecutor(_context, config = {}) constructor {

  ///@type {Struct}
  context = Assert.isType(_context, Struct, "TaskExecutor.context must be type of Struct")

  ///@private
  ///@type {Array<Task>}
  tasks = new Array(Task).enableGC()

  ///@private
  ///@type {Boolean}
  enableLogger = Struct.getIfType(config, "enableLogger", Boolean, false)
  
  ///@private
  ///@type {String}
  loggerPrefix = Struct.getIfType(config, "loggerPrefix", String, "TaskExecutor")

  ///@private
  ///@type {Boolean}
  catchException = Struct.getIfType(config, "catchException", Boolean, false)

  ///@private
  ///@type {?Callable}
  exceptionCallback = Struct.getIfType(config, "exceptionCallback", Callable)

  ///@param {Task} task
  ///@param {Number} index
  ///@param {TaskExecutor} executor
  ///@throws {Exception}
  ///@return {TaskExecutor}
  static execute = function(task, index, executor) {
    static resolveTask = function(task, index, executor) {
      if (task.status == TaskStatus.IDLE) {
        task.status = TaskStatus.RUNNING
        if (Core.isType(task.onStart, Callable)) {
          task.onStart(executor)
        }
      }

      if (task.status == TaskStatus.RUNNING) {
        task.update(executor)
      }

      if (task.status == TaskStatus.FULLFILLED
          || task.status == TaskStatus.REJECTED) {
        executor.tasks.addToGC(index)
        if (Optional.is(task.onFinish)) {
          task.onFinish(executor)
        }        
      }
    }

    if (executor.catchException) {
      try {
        resolveTask(task, index, executor)
      } catch (exception) {
        Logger.error(executor.loggerPrefix, 
          $"TaskExecutor::execute fatal error: {exception.message}")
        Core.printStackTrace()
        
        if (Optional.is(task.promise)) {
          try {
            task.promise.reject(exception.message)
          } catch (ex) {
            Logger.error(executor.loggerPrefix, 
              $"TaskExecutor::execute fatal error while rejecting task promise: {ex.message}")
            Core.printStackTrace()
          }
        }
  
        if (Optional.is(executor.exceptionCallback)) {
          try {
            executor.exceptionCallback(task)
          } catch (ex) {
            Logger.error(executor.loggerPrefix, 
              $"TaskExecutor::execute fatal error while running exceptionCallback: {ex.message}")
            Core.printStackTrace()
          }
        }
      }
    } else {
      resolveTask(task, index, executor)
    } 

    return executor
  }

  ///@param {Task} task
  ///@return {TaskExecutor}
  static add = function(task) {
    this.tasks.add(task)
    return this
  }

  ///@return {TaskExecutor}
  static update = function() {
    this.tasks.forEach(this.execute, this).runGC()
    return this
  }
}