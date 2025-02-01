///@description https://www.shadertoy.com/view/MdX3zr
///@author XT95 2013-02-15
// Created by anatole duprat - XT95/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 iResolution;
uniform float iTime;
uniform vec3 iPosition; // vec3(0.0, -2.0, 4.0)
uniform float iIterations; // 64

//Thx to Las^Mercury
float noise(vec3 p) {
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1.0, 57.0, 21.0)) + vec4(0.0, 57.0, 21.0, 78.0);
	vec3 f = cos((p - i) * acos(-1.0)) * (-0.5) + 0.5;
  a = mix(sin(cos(a) * a), sin(cos(1.0 + a) * (1.0 + a)), f.x);
  a.xy = mix(a.xz, a.yw, f.y);
  return mix(a.x, a.y, f.z);
}

float sphere(vec3 p, vec4 spr) {
  return length(spr.xyz - p) - spr.w;
}

float flame(vec3 p) {
	float d = sphere(p * vec3(1.0, 0.5, 1.0), vec4(0.0, -1.0, 0.0, 1.0));
  return d + (noise(p + vec3(0.0, iTime * 2.0, 0.0)) + noise(p * 3.0) * 0.5) * 0.25 * (p.y);
}

float scene(vec3 p) {
  return min(100. - length(p), abs(flame(p)));
}

vec4 raymarch(vec3 org, vec3 dir) {
	float d = 0.0;
  float glow = 0.0; 
  float eps = 0.02;
	vec3  p = org;
	bool glowed = false;
  for (float i = 0.0; i < 64.0; i += 1.0) {
    if (i > iIterations) {
      break;
    }
    
    d = scene(p) + eps;
    p += d * dir;
    if (d > eps) {
      if (flame(p) < 0.0) {
        glowed = true;
      }
        
      if (glowed) {
        glow = i / iIterations;
      } 
    }
  }
  return vec4(p, glow);
}

void main() {
  vec2 v = -1.0 + 2.0 * v_vTexcoord.xy / iResolution.xy;
  v.x *= iResolution.x / iResolution.y;
	
	vec3 org = vec3(-1.0 * iPosition.x, -1.0 * iPosition.y, iPosition.z);
	vec3 dir = normalize(vec3(v.x * 1.6, v.y, -1.5));
	vec4 p = raymarch(org, dir);
	float glow = p.w;
	vec4 col = mix(vec4(1.0, 0.5, 0.1, 1.0), vec4(0.1, 0.5, 1.0, 1.0), p.y * 0.02 + 0.4);
  vec4 pixel = mix(vec4(0.0), col, pow(glow * 2.0, 4.0));
  //vec4 pixel = mix(vec4(1.), mix(vec4(1.,.5,.1,1.),vec4(0.1,.5,1.,1.),p.y*.02+.4), pow(glow*2.,4.));
  vec4 textureColor = texture2D(gm_BaseTexture, v_vTexcoord);
  gl_FragColor = vec4(
    pixel.x + textureColor.x,
    pixel.y + textureColor.y,
    pixel.z + textureColor.z,
    textureColor.a * v_vColour.a
  );
}