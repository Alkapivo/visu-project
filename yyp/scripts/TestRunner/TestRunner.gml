///@package io.alkapivo.test.core.TestRunner

function Test() constructor {
  name = ""
  cases = new Array()
}

function TestRunner() constructor {

  ///@param {Test} testSuite
  ///@param {Logger} [_logger]
  run = function(testSuite, _logger = Logger) {
    var acc = {
      passed: new Array(),
      failed: new Array(),
      logger: _logger,
    }
    testSuite.cases.forEach(function(item, index, acc) {
      try {
        var response = item.test(item.config)
        acc.logger.info("TestRunner", String.template(
          "Passed { \"name\": \"{0}\", \"message\": \"{1}\" }", 
          item.name, response.message))
        acc.passed.add(item.name)
      } catch (exception) {
        acc.logger.error("TestRunner", String.template(
          "Failed: { \"name\": \"{0}\", \"message\": \"{1}\" }", 
          item.name, exception.message))
        acc.failed.add(item.name)
      }
    }, acc)

    acc.logger.info("TestRunner", String.template(
			"Test suite ended: { \"name\": \"{0}\", \"passed\": {1}, \"failed\": {2} }", 
      testSuite.name, acc.passed.size(), acc.failed.size())
		)
		
    if (acc.failed.size() > 0) {
      acc.logger.info("TestRunner", String.template(
        "Failed tests: {0}", acc.failed.join(", ")))
    }

    return {
      name: testSuite.name,
      passed: acc.passed,
      failed: acc.failed
    }
  }
}