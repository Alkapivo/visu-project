attribute vec3 in_Position; // (x,y,z)
attribute vec4 in_Colour; // (r,g,b,a)
attribute vec2 in_TextureCoord; // (u,v)

varying vec2 vTexcoord;
varying vec4 vColor;

void main() {
  vec4 position = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
  gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * position;
  vTexcoord = in_TextureCoord;
  vColor = in_Colour;
}
