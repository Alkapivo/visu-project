///@shader shader_abberation
///@description Fragment shader.

varying vec4 inputColor;
varying vec2 inputTexture;


void main() {
  
  float abberationDistance = 1.0;//2.0;
  vec4 color1 = texture2D(gm_BaseTexture, inputTexture) / 3.0;
  vec4 color2 = texture2D(gm_BaseTexture, inputTexture + 0.002 * abberationDistance) / 3.0;
  vec4 color3 = texture2D(gm_BaseTexture, inputTexture - 0.002 * abberationDistance) / 3.0;
  
  color1 *= 1.0;//1.7;//1.61;
  color2.g = 0.00;//0.10;//0.58;//0.0;
  color2.b = 0.00;0.11;//0.02;//0.32;//0.12;
  color3.r = 0.00;0.23;//0.55;//0.08;//0.24;
  
  vec4 outputPixel = inputColor * (color1 + color2 + color3);

  /// Pass pixel to renderer
  gl_FragColor = outputPixel;
}
