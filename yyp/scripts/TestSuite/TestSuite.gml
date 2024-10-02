///@package io.alkapivo.core.test

///@param {Struct} [json]
function TestSuite(json = {}) constructor {
  
  ///@type {String}
  name = Assert.isType(Struct.getDefault(json, "name", "Undefined test suite"), String)

  ///@type {Boolean}
  finished = false

  ///@type {Array<Test>}
  tests = new Array(Test, GMArray.map(
    (Core.isType(Struct.get(json, "tests"), GMArray) 
      ? json.tests 
      : []),
    function(json) {
      return new Test(json)
    }))

  ///@type {Array<Struct>}
  report = new Array(Struct)

  ///@type {Boolean}
  stopAfterFailure = Struct.getDefault(json, "stopAfterFailure", false)

  ///@private
  ///@type {Number}
  pointer = 0

  ///@param {TaskExecutor}
  ///@return {TestSuite}
  update = function(executor) {
    if (this.finished) {
      return this
    }

    if (this.pointer >= this.tests.size()) {
      this.finished = true
      return this
    }

    if (this.pointer == this.report.size()) {
      var test = this.tests.get(this.pointer)
      var task = Callable.run(test.handler, Struct.get(test, "data"))
      executor.add(task)
      this.report.add({
        test: test.handler,
        description: test.description,
        result: task.promise,
      })
    } else {
      var status = this.report.getLast().result.status
      if (this.stopAfterFailure) {
        switch (status) {
          case PromiseStatus.REJECTED: this.finished = true break
          case PromiseStatus.FULLFILLED: this.pointer++ break
        }
      } else if (status != PromiseStatus.PENDING) {
        this.pointer++
      }
    }

    return this
  }
}
