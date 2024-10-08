///@package io.alkapivo.core.service.transaction

function TransactionService(config = null) constructor {

  ///@private
  ///@type {Stack<Transaction>}
  applied = new Stack(Transaction)

  ///@private
  ///@type {Stack<Transaction>}
  reverted = new Stack(Transaction) 

  ///@type {Number}
  limit = Core.isType(Struct.get(config, "limit"), Number) 
    ? round(clamp(config.limit, 1, 2000))
    : Core.getProperty("visu.transaction.limit", 100)

  ///@param {?Transaction}
  ///@return {TransactionService}
  add = function(transaction) {
    if (Core.isType(transaction, Transaction)) {
      this.reverted.clear()
      this.applied.push(transaction.apply())
      if (this.applied.size() >= this.limit) {
        Core.print("remove! add")
        this.applied.container.remove(0)
      }
    }

    return this
  }

  ///@return {TransactionService}
  undo = function() {
    var transaction = this.applied.pop()
    if (Core.isType(transaction, Transaction)) {
      this.reverted.push(transaction.rollback())
      if (this.reverted.size() >= this.limit) {
        Core.print("remove! undo")
        this.reverted.container.remove(0)
      }
    }

    return this
  }

  ///@return {TransactionService}
  redo = function() {
    var transaction = this.reverted.pop()
    if (Core.isType(transaction, Transaction)) {
      this.applied.push(transaction.apply())
      if (this.applied.size() >= this.limit) {
        Core.print("remove! redo")
        this.applied.container.remove(0)
      }
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

}