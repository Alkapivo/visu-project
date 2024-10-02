///@package io.alkapivo.core.test

#macro BeanTestRunner "TestRunner"
function TestRunner() constructor {

  ///@type {?TestSuite}
  testSuite = null

  ///@type {Queue<TestSuite>}
  testSuites = new Queue(TestSuite)
  
  ///@type {Stack<Struct>}
  exceptions = new Stack(Struct)

  ///@type {Map<String, Callable>}
  restoreHooks = new Map(String, Callable)

  ///@type {Boolean}
  initialized = false

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, { 
    enableLogger: true,
    catchException: false,
  })

  ///@return {TestRunner}
  installHooks = function() {
    this.restoreHooks.set("Logger.error", method(this, Logger.error))
    Logger.info(BeanTestRunner, "install hook 'Logger.error'")
    Logger.error = function(context, message) {
      global.__Log(context, "ERROR ", message)

      var runner = Beans.get(BeanTestRunner)
      if (!Core.isType(runner, TestRunner)) {
        return
      }

      runner.exceptions.push({
        timestamp: string(current_year) + "-"
          + string(string_replace(string_format(current_month, 2, 0), " ", "0")) + "-"
          + string(string_replace(string_format(current_day, 2, 0), " ", "0")) + " "
          + string(string_replace(string_format(current_hour, 2, 0), " ", "0")) + ":"
          + string(string_replace(string_format(current_minute, 2, 0), " ", "0")) + ":"
          + string(string_replace(string_format(current_second, 2, 0), " ", "0")),
        context: context,
        message: message,
      })
    }
    
    return this
  }

  ///@return {TestRunner}
  uninstallHooks = function() {
    Logger.info(BeanTestRunner, "uninstall hook 'Logger.error'")
    var hook = this.restoreHooks.get("Logger.error")
    if (Core.isType(Logger, Struct) && Core.isType(hook, Callable))  {
      Logger.error = method(Logger, hook)
    }

    return this
  }

  ///@param {String} path
  ///@return {TestRunner}
  push = function(path) {
    var context = this
    var json = FileUtil.readFileSync(path).getData()
    var task = JSON.parserTask(json, {
      callback: function(prototype, json, index, acc) {
        var testSuite = new prototype(json)
        acc.testSuites.push(testSuite)
      },
      acc: context,
    }).update()

    return this
  }

  ///@private
  ///@return {TestRunner}
  saveReport = function() {
    var stringBuilder = new StringBuilder()
    this.testSuite.report.forEach(function(entry, index, stringBuilder) {
      var status = entry.result.status == PromiseStatus.FULLFILLED ? "Passed" : "Failed"
      var message = $"{entry.test} ({entry.description}): {status}"
      Logger.info("TestRunner", message)
      stringBuilder.append($"{message}\n")
    }, stringBuilder)

    var date = string(current_year) + "-"
      + string(string_replace(string_format(current_month, 2, 0), " ", "0")) + "-"
      + string(string_replace(string_format(current_day, 2, 0), " ", "0")) + "_"
      + string(string_replace(string_format(current_hour, 2, 0), " ", "0")) + "-"
      + string(string_replace(string_format(current_minute, 2, 0), " ", "0")) + "-"
      + string(string_replace(string_format(current_second, 2, 0), " ", "0"));

    FileUtil.writeFileSync(new File({
      path: FileUtil.get($"{working_directory}{date}_{this.testSuite.name}.txt"),
      data: stringBuilder.get()
    }))

    return this
  }

  ///@private
  ///@return {TestRunner}
  shutdown = function() {
    Logger.info(BeanTestRunner, "Shutdown")
    game_end()
    return this
  }

  ///@return {TestRunner}
  update = function() {
    if (!Optional.is(this.testSuite) 
      && this.testSuites.size() > 0) {
      this.testSuite = this.testSuites.pop()
    }

    if (!Core.isType(this.testSuite, TestSuite)) {
      return this
    }

    try {
      this.executor.update()
      
      this.testSuite.update(this.executor)
      if (!this.testSuite.finished) {
        return this
      }

      this.saveReport().testSuite = null
      if (this.testSuites.size() == 0) {
        this.shutdown()
      }
    } catch (exception) {
      Logger.error(BeanTestRunner, $"Fatal exception: {exception.message}")
      Logger.info(BeanTestRunner, "Attempt to save test results")

      try {
        this.saveReport()
      } catch (ex) {
        Logger.error(BeanTestRunner, $"Unable to save test results: {ex.message}")
      }

      this.shutdown()
    }

    return this
  }
  
  ///@return {TestRunner}
  free = function() {
    this.uninstallHooks()
    return this
  }
}
