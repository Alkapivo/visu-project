attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 textureCoord;
varying vec4 blendColor;

void main() {
  vec4 position = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
  gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * position;
  
  blendColor = in_Colour;
  textureCoord = in_TextureCoord;
}