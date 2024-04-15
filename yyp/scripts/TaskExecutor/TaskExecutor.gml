///@package io.alkapivo.core.task

///@param {String} _message
function InvalidTaskStatusException(_message): Exception(_message) constructor { }

///@param {Struct} _context
///@param {Struct} [config]
function TaskExecutor(_context, config = {}) constructor {

  ///@type {Struct}
  context = Assert.isType(_context, Struct)

  ///@private
  ///@type {Array<Task>}
  tasks = new Array(Task)

  ///@private
  ///@type {Stack<Number>}
  gc = new Stack(Number)

  ///@private
  ///@type {Boolean}
  enableLogger = Assert.isType(Struct
    .getDefault(config, "enableLogger", false), Boolean)
  
  ///@private
  ///@type {Boolean}
  catchException = Assert.isType(Struct
    .getDefault(config, "catchException", true), Boolean)

  ///@private
  ///@type {Number}
  timeoutCounter = 0

  ///@private
  ///@param {Task} task
  ///@param {Number} index
  ///@throws {InvalidTaskStatusException}
  updateTask = function(task, index) {
    static resovleTaskStatus = function(context, task, index) {
      if (context.enableLogger
        && Core.isType(task.timeout, Timer)
        && task.timeout.time > context.timeoutCounter) {
        context.timeoutCounter += 1
        Logger.debug("TaskExecutor", $"Timeout 'time': {task.timeout.time}, 'duration': {task.timeout.duration}")
      }
      
      switch (task.status) {
        case TaskStatus.IDLE:
          task.status = TaskStatus.RUNNING
          if (Core.isType(task.onStart, Callable)) {
            task.onStart(this)
          }
          break
        case TaskStatus.RUNNING:
          task.update(this)
          break
        case TaskStatus.FULLFILLED:
        case TaskStatus.REJECTED:
          context.gc.push(index)
          break
        default:
          throw new InvalidTaskStatusException()
          break
      }
    }

    if (this.catchException) {
      try {
        resovleTaskStatus(this, task, index)
      } catch (exception) {
        Logger.error("TaskExecutor", $"'executor-task' fatal error: {exception.message}")
        this.gc.push(index)
        try {
          task.reject(exception.message)
        } catch (ex) {
          Logger.error("TaskExecutor", $"'executor-promise-reject' fatal error: {ex.message}")
        }
      }
    } else {
      resovleTaskStatus(this, task, index)
    } 
  }

  ///@param {Task} task
  ///@return {TaskExecutor}
  add = method(this, function(task) {
    this.tasks.add(task)
    return this
  })

  ///@return {TaskExecutor}
  update = method(this, function() {
    static dispatchTask = function(task, index, executor) {
      executor.updateTask(task, index)  
    }

    static gcTask = function(taskIndex, index, executor) { 
      executor.tasks.remove(taskIndex) 
    }
    
    this.tasks.forEach(dispatchTask, this)
    this.gc.forEach(gcTask, this)
    return this
  })
}