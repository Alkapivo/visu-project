///@description Based on shader created by Peace 2024-07-24
///             https://www.shadertoy.com/view/MclyWl

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec3 iResolution;
uniform float iTime;
uniform float iFactor;

float hash11(float p) {
  p = fract(p * 0.1031);
  p *= p + 33.33;
  return abs(0.5 - fract(p * p * 2.0)) * 2.0;
}

float noise11(float p) {
	float i = floor(p);
	float f = fract(p);
  f *= f * (3.0 - 2.0 * f);
	return mix(hash11(i), hash11(i + 1.0), f);
}

float hash12(vec2 p) {
	vec3 p3 = fract(p.xyx * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	float res = mix(
	mix(hash12(i), hash12(i + vec2(1, 0)), f.x),
	mix(hash12(i + vec2(0, 1)), hash12(i + vec2(1)), f.x), f.y);
	return res;	
}

float fbm(vec2 p, int octaves) {
	float s = 0.0;
  float m = 0.0;
  float a = 1.0;
	for (int i = 0; i < octaves; i++) {
		s += a * noise(p);
		m += a;
		a *= 0.5;
		p *= mat2(1.6, 1.2, -1.2, 1.6); 
	}

	return s / m;
}

float lightning(vec2 uv, float i) {
  // Expanding / Warping
  float n = fract(noise11(i * 3.0) * 3.0) * 2.0 - 1.0;
  float bend = n * 0.15;
  bend *= smoothstep(1.0, -0.5, abs(0.5 - gl_FragCoord.x / iResolution.x) * 1.6);
  uv.y += (2.0 - uv.x * uv.x) * bend;
  uv.x -= iTime * 0.2;
  
  float d = fbm(uv * vec2(2, 1.4) - vec2(0, i), 6);
  d = (d * (2.0 + iFactor) - ((2.0 + iFactor) / 2.0)) * 0.45;

  return abs(uv.y - d);
}

vec3 lightnings(vec2 uv) {
  float t2 = iTime * 0.08;
  float d1 = lightning(uv, 21.17 + t2);
  float d2 = lightning(uv, 63.41 + t2);
  float d3 = lightning(uv, 77.69 + t2);
  float d4 = lightning(uv, 21.99 + t2);
  float d = 0.007 / sqrt(d1 * d2 * d3 * d4);
  float dd = max(0.0, 1.0 - sqrt(d1 + d2 * d3 + d3 + d4 * d1) * 0.5);
  float md = 1.0 - dd;
  vec3 col = vec3(0.31, 0.5, 0.89) * sqrt(d);
  col = col * 0.7 + 0.7 * vec3(4.0 * md * md + 3.5 * md, 0.3, 0.6) * md * d;
  col = mix(col, col * col, min(1.0, dd * dd * dd * dd));
  col = (col - 0.5) * 0.6 + 0.3;
  
  return col;
}

void main() {
  vec2 uv = (vTexcoord * 2.0 - iResolution.xy) / iResolution.y;
  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec4 pixel = mix(vec4(lightnings(uv), 1), textureColor, 0.17);

  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 1.3)
  );
}
