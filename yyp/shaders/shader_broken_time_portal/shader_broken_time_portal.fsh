///@description Based on shader created by iekdosha in 2024-05-21
///             https://www.shadertoy.com/view/XXcGWr

// Credit to nimitz (stormoid.com) (twitter: @stormoid)
// For the original shader here: https://www.shadertoy.com/view/ldlXRS
// Lisense has to propagate I think... so:
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

// I am just trying out new things and found this one, I do not understand how the original works so I am making mofications for fun.

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec3 iResolution;
uniform float iTime;
uniform float iTreshold;
uniform float iSize;
uniform vec3 iTint;

mat2 makem2(in float theta) {
  float c = cos(theta);
  float s = sin(theta);
  return mat2(c, -s, s, c);
}

float noise(in vec2 x) {
  return texture2D(gm_BaseTexture, vTexcoord + (x * iTreshold)).x;
}

float fbm(in vec2 p) {
  float z = 2.0;
  float rz = 0.0;
  vec2 bp = p;
  for (float idx = 0.0; idx < 6.0; idx += 1.0) {
    rz += abs((noise(p) - 0.5) * 2.0) / z;
    z = z * 2.0;
    p = p * 2.0;
  }
  return rz;
}

float dualfbm(in vec2 p) {
  vec2 p2 = p * 0.7; // get two rotated fbm calls and displace the domain
  vec2 basis = vec2(fbm(p2 - iTime * 1.6), fbm(p2 + iTime * 1.7));
  basis = (basis - 0.5) * 0.2;
  p += basis;
  
  return fbm(p * makem2(iTime * 0.2)); // coloring
}

float circ(vec2 p)  {
  float r = length(p);
  r = log(sqrt(r));
  return abs(mod(r * 4.0 * iSize, 3.141592 * 2.0) - 3.15) * 3.0 + 0.2;
}

void main() {
  vec2 p = vTexcoord.xy / iResolution.xy - 0.5;
  p.x *= iResolution.x / iResolution.y;
  float len = length(p);
  p *= 4.0;
    
  float rz = dualfbm(p);
  float fade = pow(max(1.0, 6.5 * len), 0.2);
  rz = fade * rz + (1.0 - fade) * dualfbm(p + 5.0 * sin(iTime)); // Add floating things around portal
  float my_time = iTime + 0.08 * rz;
    
  //rings
  p /= exp(mod((my_time + rz), 3.1415)); 
  rz *= pow(abs((0.1 - circ(p))), 0.9);
  
  //final color
  vec3 pixel = clamp(pow(abs(iTint / rz), vec3(0.99)), 0.0, 1.0);
  gl_FragColor = vec4(pixel, max(pixel.r, max(pixel.g, pixel.b)) 
    * texture2D(gm_BaseTexture, vTexcoord).a * vColor.a);
}