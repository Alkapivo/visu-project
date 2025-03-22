///@package io.alkapivo.core.task

///@enum
function _TaskExecutorFreeStrategyType(): Enum() constructor {
  NONE = "NONE"
  FULLFILL = "FULLFILL"
  REJECT = "REJECT"
}
global.__TaskExecutorFreeStrategyType = new _TaskExecutorFreeStrategyType()
#macro TaskExecutorFreeStrategyType global.__TaskExecutorFreeStrategyType


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

  ///@private
  ///@type {TaskExecutorFreeStrategyType}
  freeStrategy = Struct.getIfEnum(config, "freeStrategy", TaskExecutorFreeStrategyType, TaskExecutorFreeStrategyType.NONE)

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

  ///@return {TaskExecutor}
  static free = function() {
    static freeFullfill = function(task, iterator, executor) {
      try {
        TaskUtil.fullfill(task, iterator, executor)
        if (Optional.is(task.onFinish)) {
          task.onFinish(executor)
        }
      } catch (exception) {
        Logger.error(executor.loggerPrefix, $"executor.free(freeStrategy=FULLFILL) fatal error: {exception.message}")
        Core.printStackTrace()
      }
    }

    static freeReject = function(task, iterator, executor) {
      try {
        TaskUtil.reject(task, iterator, executor)
        if (Optional.is(task.onFinish)) {
          task.onFinish(executor)
        }
      } catch (exception) {
        Logger.error(executor.loggerPrefix, $"executor.free(freeStrategy=REJECT) fatal error: {exception.message}")
        Core.printStackTrace()
      }
    }

    switch (this.freeStrategy) {
      case TaskExecutorFreeStrategyType.FULLFILL:
        this.tasks.forEach(freeFullfill, this)
        break
      case TaskExecutorFreeStrategyType.REJECT:
        this.tasks.forEach(freeReject, this)
        break
    }

    this.tasks.clear()
    return this
  }
}