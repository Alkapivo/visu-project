///@package io.alkapivo.core.collection

///@param {TreeNode} node
///@param {Number} index
///@param {Number} depth
function printTreeNode(node, index, depth) {
  Core.print("depth:", depth, "index:", index, "name:", node.name, "value:", Struct.get(node, "value"))
  node.childrens.forEach(printTreeNode, depth + 1)
}


///@param {Struct} config
function TreeNode(config) constructor {

  ///@type {String}
  name = Assert.isType(config.name, String)

  ///@type {?TreeNode}
  parent = Core.isType(Struct.get(config, "parent"), TreeNode) ? config.parent : null

  ///@type {any}
  type = Struct.get(config, "value")

  ///@type {any}
  value = Callable.run(Core.fetchTypeParser(this.type), Struct.get(config, "value"))

  ///@type {Array<TreeNode>}
  childrens = new Array(TreeNode)
  if (Core.isType(Struct.get(config, "childrens"), GMArray)) {
    GMArray.forEach(config.childrens, function(json, name, childrens) {
      var node = new TreeNode(json)
      childrens.add(node)
    }, this.childrens)
  }
}


///@param {Struct} node
function Tree(node) constructor {

  ///@type {TreeNode}
  root = new TreeNode(node)

  ///@return {Tree}
  print = function() {
    Core.print("root", "name:", this.root.name, "value:", Struct.get(this.root, "value"))
    this.root.childrens.forEach(printTreeNode, 1)
    return this
  }
}