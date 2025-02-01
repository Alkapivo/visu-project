///@description Based on shader created by nayk in 2024-07-22
///             https://www.shadertoy.com/view/lcscDj

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec2 iResolution;
uniform float iTime;
uniform float iIterations; // 20.8
uniform float iSize; // 0.5
uniform float iFactor; // 32.0

float Hash(vec2 p, in float s) {
  vec3 p2 = vec3(p.xy, 27.0 * abs(sin(s)));
  return fract(sin(dot(p2, vec3(27.1, 61.7, 12.4))) * 273758.5453123);
}

float noise(in vec2 p, in float s) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f *= f * (3.0 - 2.0 * f);
  return mix(
    mix(Hash(i + vec2(0.0, 0.0), s), Hash(i + vec2(1.0, 0.0), s), f.x),
    mix(Hash(i + vec2(0.0, 1.0), s), Hash(i + vec2(1.0, 1.0), s), f.x),
    f.y
  ) * s;
}

float fbm(vec2 p) {
  float v = - noise(p * 2.0, 0.35);
  v += noise(p * 01.1, 0.5) - noise(p * 01.1, 0.25);
  v += noise(p * 03.1, 0.25) - noise(p * 03.1, 0.125);
  v += noise(p * 04.1, 0.125) - noise(p * 05.1, 2.3625);
  v += noise(p * 05.1, 0.50625) - noise(p * 16., 6.13125);
  v += noise(p * 26.1, 1.23125);
  return v;
}

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x * 34.0) + 1.0) * x);
}

float snoise(vec2 v) {
  const vec4 C = vec4(
    0.211324865405187, // (3.0-sqrt(3.0))/6.0
    0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
    -0.577350269189626, // -1.0 + 2.0 * C.x
    0.024390243902439 // 1.0 / 41.0
  );
  // First corner
  vec2 i  = floor(v + dot(v, C.yy));
  vec2 x0 = v -   i + dot(i, C.xx);

  // Other corners
  vec2 i1;
  i1.x = step(x0.y, x0.x); // x0.x > x0.y ? 1.0 : 0.0
  i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

  // Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute(permute( i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));

  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;

  // Gradients: 41 points uniformly over a line, mapped onto a diamond.
  // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  // Normalise gradients implicitly by scaling m
  // Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);

  // Compute final noise value at P
  vec3 g;
  g.x  = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float fbm2(in vec2 st) {
  float v = 0.0;
  float a = 0.5;
  vec2 shift = vec2(100.0);
  // Rotate to reduce axial bias
  mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
  for (int i = 0; i < 5; ++i) {
    v += a * snoise(st);
    st = rot * st * 2.0 + shift;
    a *= 0.5;
  }
  return v;
}

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
  float xx = x + sin(t * fx) * sx;
  float yy = y + cos(t * fy) * sy;
  return 1.0 / sqrt(xx * xx + yy * yy);
}

void main() {
  float worktime = (iTime * iSize) + 100000.0;
  vec2 uv = (vTexcoord.xy / iResolution.xy ) * 5.0 - 2.0;
  uv.y *= iResolution.y / iResolution.x;
  vec2 st = (vTexcoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);
  vec3 color = vec3(1.0);
  vec2 st2 = st;
  vec2 p = (vTexcoord.xy / iResolution.x) * 2.0 - vec2(1.0, iResolution.y / iResolution.x);
  p = p*2.0;
  float x = p.x;
  float y = p.y;

  float a = makePoint(x, y, 3.3, 2.9, 0.3, 0.3, iTime);
  a = a + makePoint(x, y, 1.9, 2.0, 0.4, 0.4, iTime);
  a = a + makePoint(x, y, 2.3, 0.1, 0.6, 0.3, iTime);
  a = a + makePoint(x, y, 0.8, 1.7, 0.5, 0.4, iTime);
  a = a + makePoint(x, y, 0.3, 1.0, 0.4, 0.4, iTime);
  a = a + makePoint(x, y, 1.4, 1.7, 0.4, 0.5, iTime);
  a = a + makePoint(x, y, 1.3, 2.1, 0.6, 0.3, iTime);
  a = a + makePoint(x, y, 1.8, 1.7, 0.5, 0.4, iTime);   
   
  float b = makePoint(x, y, 1.2, 1.9, 0.3, 0.3, iTime);
  b = b + makePoint(x, y, 0.7, 2.7, 0.4, 0.4, iTime);
  b = b + makePoint(x, y, 1.4, 0.6, 0.4, 0.5, iTime);
  b = b + makePoint(x, y, 2.6, 0.4, 0.6, 0.3, iTime);
  b = b + makePoint(x, y, 0.7, 1.4, 0.5, 0.4, iTime);
  b = b + makePoint(x, y, 0.7, 1.7, 0.4, 0.4, iTime);
  b = b + makePoint(x, y, 0.8, 0.5, 0.4, 0.5, iTime);
  b = b + makePoint(x, y, 1.4, 0.9, 0.6, 0.3, iTime);
  b = b + makePoint(x, y, 0.7, 1.3, 0.5, 0.4, iTime);

  float c = makePoint(x, y, 3.7, 0.3, 0.3, 0.3, iTime);
  c = c + makePoint(x, y, 1.9, 1.3, 0.4, 0.4, iTime);
  c = c + makePoint(x, y, 0.8, 0.9, 0.4, 0.5, iTime);
  c = c + makePoint(x, y, 1.2, 1.7, 0.6, 0.3, iTime);
  c = c + makePoint(x, y, 0.3, 0.6, 0.5, 0.4, iTime);
  c = c + makePoint(x, y, 0.3, 0.3, 0.4, 0.4, iTime);
  c = c + makePoint(x, y, 1.4, 0.8, 0.4, 0.5, iTime);
  c = c + makePoint(x, y, 0.2, 0.6, 0.6, 0.3, iTime);
  c = c + makePoint(x, y, 1.3, 0.5, 0.5, 0.4, iTime);
   
  vec3 d = vec3(a, b, c) / iFactor;
  float lng = length(st);
  float at = atan(st.y, st.x) + lng * 2.0;
  st = vec2(cos(at) * lng, sin(at) * lng);
  st *= 2.0 + dot(lng, lng);
  st = abs(st / dot(st, st) * 8.0);
  color += fbm(st * 0.5 + iTime);
  color = mix(color, vec3(0.0, 0.2, 0.8), 0.5);
  color.gb += fbm2(st * 30.0);
  color -= length(st2) - 0.2;
  vec3 finalColor = vec3(0.0, 0.0, 0.0);
  for (float i = 1.0; i < 64.0; i++) {
    if (i > iIterations) {
      break;
    }
    
    float t = abs(1.0 / ((uv.y + fbm(uv + worktime / i)) * (i * 100.0)));
    finalColor +=  t * vec3(i * 0.1, 0.9, 1.90);
  }
  
  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec4 pixel = mix(vec4((finalColor * color) * (100.0) + d * 5.0, 1.0), textureColor, 0.24);
  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 5.0)
  );
}