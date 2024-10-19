///@package io.alkapivo.core.service.transaction

///@type {Number}
#macro TRANSACTION_SERVICE_DEFAULT_LIMIT 100

///@type {Number}
#macro TRANSACTION_SERVICE_MAX_LIMIT 2000


///@param {?Struct} [config]
function TransactionService(config = null) constructor {

  ///@private
  ///@type {Stack<Transaction>}
  applied = new Stack(Transaction)

  ///@private
  ///@type {Stack<Transaction>}
  reverted = new Stack(Transaction)

  ///@type {Number}
  limit = toInt(clamp(Struct.getIfType(config, "limit", Number, 
    TRANSACTION_SERVICE_DEFAULT_LIMIT), 1, TRANSACTION_SERVICE_MAX_LIMIT))

  ///@param {?Transaction}
  ///@return {TransactionService}
  add = function(transaction) {
    if (Core.isType(transaction, Transaction)) {
      this.reverted.clear()
      this.applied.push(transaction.apply())
    }

    return this
  }

  ///@return {TransactionService}
  undo = function() {
    var transaction = this.applied.pop()
    if (Core.isType(transaction, Transaction)) {
      this.reverted.push(transaction.rollback())
    }

    return this
  }

  ///@return {TransactionService}
  redo = function() {
    var transaction = this.reverted.pop()
    if (Core.isType(transaction, Transaction)) {
      this.applied.push(transaction.apply())
    }
    
    return this
  }

  ///@return {TransactionService}
  clear = function() {
    this.applied.clear()
    this.reverted.clear()
    return this
  }

  ///@return {?Transaction}
  peekApplied = function() {
    return this.applied.peek()
  }

  ///@return {?Transaction}
  peekReverted = function() {
    return this.reverted.peek()
  }

  ///@return {TransactionService}
  update = function() {
    if (this.applied.size() >= this.limit) {
      this.applied.container.remove(0)
    }

    if (this.reverted.size() >= this.limit) {
      this.reverted.container.remove(0)
    }

    return this
  }
}