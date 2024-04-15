///@package io.alkapivo.core.renderer

#macro GMVertexBuffer "GMVertexBuffer"
#macro GMVertexFormat "GMVertexFormat"

///@interface
function VertexBuffer() constructor {

  ///@type {Array}
  vertices = null

  ///@type {GMVertexBuffer}
  buffer = null

  ///@param {Array} vertices
  ///@return {VertexBuffer}
  static set = function(vertices) {
    this.vertices = vertices
    return this
  }

  ///@return {VertexBuffer}
  static build = function() {
    return this
  }
}


///@param {Number} x
///@param {Number} y
///@param {Number} z
///@param {Number} nx
///@param {Number} ny
///@param {Number} nz
///@param {Number} u
///@param {Number} v
///@param {Color} color
///@param {Number} alpha
function DefaultVertex(_x, _y, _z, _nx, _ny, _nz, _u, _v, _color, _alpha) constructor {
  x = _x
  y = _y
  z = _z
  nx = _nx
  ny = _ny
  nz = _nz
  u = _u
  v = _v
  color = _color
  alpha = _alpha
}


///@param {Array<DefaultVertex>} [_vertices]
function DefaultVertexBuffer(_vertices = new Array(DefaultVertex)): VertexBuffer() constructor {

  ///@type {Array<DefaultVertex>}
  vertices = _vertices

  ///@type {GMVertexBuffer}
  buffer = vertex_create_buffer()

  ///@type {GMVertexFormat}
  vertex_format_begin()
  vertex_format_add_position_3d()
  vertex_format_add_normal()
  vertex_format_add_texcoord()
  vertex_format_add_color()
  format = vertex_format_end()

  ///@override
  ///@return {VertexBuffer}
  static build = function() {
    static appendVertex = function(vertex, index, buffer) {
      vertex_position_3d(buffer, vertex.x, vertex.y, vertex.z)
      vertex_normal(buffer, vertex.nx, vertex.ny, vertex.nz)
      vertex_texcoord(buffer, vertex.u, vertex.v)
      vertex_color(buffer, ColorUtil.toGMColor(vertex.color), vertex.alpha)
    }

    vertex_begin(this.buffer, this.format);
    this.vertices.forEach(appendVertex, this.buffer)
    vertex_end(this.buffer)
    return this
  }
}
