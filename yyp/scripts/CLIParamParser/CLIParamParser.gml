///@package io.alkapivo.core.util

///@param {Struct} json
function CLIParam(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {?String}
  fullName = Struct.contains(json, "fullName") 
    ? Assert.isType(json.fullName, String) 
    : null

  ///@type {?String}
  description = Struct.contains(json, "description") 
    ? Assert.isType(json.description, String) 
    : null

  ///@type {Array<CLIParamArg>}
  args = Core.isType(Struct.get(json, "args"), GMArray)
    ? GMArray.toArray(json.args, Struct, function(arg) {
      return new CLIParamArg(arg)
    })
    : new Array(Struct)

  ///@type {Callable}
  handler = Assert.isType(method(this, json.handler), Callable)
}


///@param {Struct} json
function CLIParamArg(json) constructor {
  
  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {String}
  type = Assert.isType(json.type, String)

  ///@type {?String}
  description = Struct.contains(json, "description") 
    ? Assert.isType(json.description, String) 
    : null
}


///@param {Struct} json
function CLIParamParser(json) constructor {

  ///@type {Boolean}
  parsed = false

  ///@type {Array<CLIParam>}
  cliParams = Assert.isType(json.cliParams, Array)

  ///@private
  ///@type {Queue<String>} params
  ///@throws {Exception}
  dispatchParam = function(params) {
    Logger.debug("CLIParamParser", $"DispatchParam, total: {params.size()}")
    if (params.size() == 0) {
      return
    }
  
    var param = params.pop()
    var cliParam = this.cliParams.find(function(cliParam, index, param) {
      return param == cliParam.name || param == cliParam.fullName
    }, param)
  
    if (!Core.isType(cliParam, CLIParam)) {
      Logger.warn("CLIParamParser", $"Cannot parse parameter '{param}'")
      this.dispatchParam(params)
      return
    }
  
    if (cliParam.args.size() > params.size()) {
      throw new Exception($"param '{cliParam.name}' require '{cliParam.args.size()}' options while '{params.size()} were provided'")
    }
  
    var args = new Array()
    IntStream.forEach(0, cliParam.args.size(), function(num, idx, acc) {
      acc.args.add(acc.params.pop())
    }, { args: args, params: params })
  
    cliParam.handler(args)
  
    this.dispatchParam(params)
  }

  ///@param {Boolean} [ignoreAlreadyParsed]
  ///@return {CLIParamParser}
  parse = function(ignoreAlreadyParsed = false) {
    if (!ignoreAlreadyParsed && this.parsed) {
      Logger.debug("CLIParamParser", "CLIParamParser.parse already parsed")
      return this
    }

    var count = parameter_count()
    var params = new Queue(any)
    Logger.debug("CLIParamParser", $"Parameters count: {count}")
    for (var index = 1; index < count; index++) {
      var param = parameter_string(index)
      if (!String.isEmpty(param)) {
        params.push(param)
        Logger.debug("CLIParamParser", $"{index} Adding param: '{param}'")
      }
    }
    Logger.debug("CLIParamParser", $"Parameters parsed: {params.size()}")

    this.dispatchParam(params)
    this.parsed = true
    return this
  }
}