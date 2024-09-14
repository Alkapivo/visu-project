//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float iTime;
uniform float iIterations;
uniform vec2 iResolution;

void main() {
  gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
}
