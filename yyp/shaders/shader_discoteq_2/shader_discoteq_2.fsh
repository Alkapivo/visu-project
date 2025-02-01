///@description Based on shader created by supah in 2023-08-23
///             https://www.shadertoy.com/view/DtXfDr

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec2 iResolution;
uniform float iTime;

vec4 Line(vec2 uv, float speed, float height, vec3 col) {
  uv.y += smoothstep(1.0, 0.0, abs(uv.x)) * sin(iTime * speed + uv.x * height) * 0.2;
  return vec4(smoothstep(1.0, 0.3, abs(uv.x)) * smoothstep(
    0.06 * smoothstep(0.2, 0.9, abs(uv.x)), 
    0.0, 
    abs(uv.y) - 0.004) * col, 1.0
  );
}

void main() {
  vec2 uv = (vTexcoord - 0.5 * iResolution.xy) / iResolution.y;
  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec4 pixel = vec4(0.0);
  for (float i = 0.0; i <= 5.0; i += 1.0) {
    float t = i / 5.0;
    pixel += Line(uv, 1.0 + t, 4.0 + t, vec3(0.2 + t * 0.7, 0.2 + t * 0.4, 0.3));
  }
  
  pixel = mix(pixel, textureColor, 0.17);
  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 1.33)
  );
}