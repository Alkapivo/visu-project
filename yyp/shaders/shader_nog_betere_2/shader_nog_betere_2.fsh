///@description https://www.shadertoy.com/view/NtlSzX
///@author svtetering 2021-07-13

varying vec2 textureCoord;
varying vec4 blendColor;

uniform float iTime;
uniform vec2 iResolution;
uniform vec3 iColor;
uniform float iMix;


///@param {vec2} uv
///@return {vec3}
vec3 color(in vec2 uv) {
  float c = (1.2 + sin(iTime * 0.1) * 0.2) - log(0.7 + distance(
    uv, vec2(sin(iTime * 0.1), 
    0.5 + cos(iTime * 0.25) * 0.2))
  );
  
  vec3 col = vec3(
    c * iColor.r,
    c * iColor.g + cos(iTime * 0.2) * 0.1,
    c * iColor.b + cos(iTime * 0.5) * 0.1
  );

  for (float i = 0.0; i < 10.0; i++) {
    if (uv.y > (sin(iTime * 0.4) + sin(uv.x + iTime + (i / 6.0) + log(iTime) / log(3.0) 
      * 3.0 + (iTime + sin(iTime * 0.3)) * 0.5)) * 0.1) {
      
      col *= 0.92;
    }
  }

  return col;
}


void main() {
  vec2 uv = (textureCoord - 0.5 * iResolution.xy) / iResolution.y;
  vec4 pixel = texture2D(gm_BaseTexture, textureCoord);
  gl_FragColor = vec4(mix(pixel.rgb, color(uv), iMix), blendColor.a * pixel.a);
}