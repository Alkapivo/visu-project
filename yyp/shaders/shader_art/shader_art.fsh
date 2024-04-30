/* This animation is the material of my first youtube tutorial about creative 
   coding, which is a video in which I try to introduce programmers to GLSL 
   and to the wonderful world of shaders, while also trying to share my recent 
   passion for this community.
                                       Video URL: https://youtu.be/f4s1h2YETNY
*/

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float iTime;
uniform vec2 iResolution;
uniform float iIterations;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.263, 0.416, 0.557);
  return a + b*cos(6.28318 * (c * t + d));
}


//https://www.shadertoy.com/view/mtyGWy
void main() {
  vec2 uv = (v_vTexcoord * 2.0 - iResolution.xy) / iResolution.y;
  vec2 uv0 = uv;
  vec3 finalColor = vec3(0.0);
  
  // Requires webgl 3.0
  for (float idx = 0.0; idx < iIterations; idx++) {
      uv = fract(uv * 1.5) - 0.5;
      float d = length(uv) * exp(-length(uv0));
      vec3 col = palette(length(uv0) + idx * 0.4 + iTime * 0.4);
      d = sin(d*8. + iTime)/8.;
      d = abs(d);
      d = pow(0.01 / d, 1.2);
      finalColor += col * d;
  }

  // webgl 2.0
  //for (float index = 0.0; index < 100.0; index++) {
  //  if (index >= iIterations) {
  //    break;
  //  }
  //
  //  uv = fract(uv * 1.5) - 0.5;
  //  float d = length(uv) * exp(-length(uv0));
  //  vec3 col = palette(length(uv0) + index * 0.4 + iTime * 0.4);
  //  d = sin(d*8. + iTime)/8.;
  //  d = abs(d);
  //  d = pow(0.01 / d, 1.2);
  //  finalColor += col * d;
  //}

  float alpha = (finalColor.r + finalColor.g + finalColor.b) / 3.0;
  gl_FragColor = vec4(finalColor, min(v_vColour.a, alpha)) * texture2D(gm_BaseTexture, v_vTexcoord);
}
