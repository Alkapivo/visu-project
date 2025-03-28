///@description Based on shader "Star Nest" created by Kali in 2013-06-17
///             https://www.shadertoy.com/view/XlfGRj

#define iterations 16
#define formuparam 0.53
#define volsteps 8
#define stepsize 0.1
#define tau 6.283185

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec2 iResolution;
uniform float iTime;
uniform float iAngle; // 90.0 -> right, 90.0 -> top, 180.0 -> left, 270.0 -> bottom
uniform float iZoom; // 25.0
uniform float iTile; // 8.5
uniform float iSpeed; // 1.0
uniform float iBrightness; // 1.25
uniform float iDarkmatter; // 0.3
uniform float iDistfading; // 0.8
uniform float iSaturation; // 8.5
uniform vec3 iBlend; // vec3(1.0) -> white


void main() {
	vec2 uv = vTexcoord.xy / iResolution.xy;
	uv.y *= iResolution.y / iResolution.x;
	vec3 dir = vec3(uv * (iZoom / 100.0), 1.0);
	float time = iTime * (iSpeed / 100.0);

	float a1 = iResolution.x / 2.0;
	float a2 = iResolution.y / 2.0;
	mat2 rot1 = mat2(cos(a1), sin(a1), -sin(a1), cos(a1));
	mat2 rot2 = mat2(cos(a2), sin(a2), -sin(a2), cos(a2));
	dir.xz *= rot1;
	dir.xy *= rot2;

  float angle = (mod(mod(iAngle, 360.0) + 360.0, 360.0) / 360.0) * tau;
  vec3 from = vec3(0.5, 0.5, 0.5);
	from.x += cos(angle) * time;
  from.y -= sin(angle) * time;
  from.z += 0.0 * time;
	from.xz *= rot1;
	from.xy *= rot2;
	
	//volumetric rendering
	float s = 0.1;
  float fade = 1.0;
	vec3 v = vec3(0.0);
	for (int r = 0; r < volsteps; r++) {
    float pa = 0.0;
    float a = 0.0;
		vec3 p = from + s * dir * 0.5;
		p = abs(vec3(iTile / 10.0) - mod(p, vec3((iTile / 10.0) * 2.0))); // tiling fold
		for (int i = 0; i < iterations; i++) { 
			p = abs(p) / dot(p, p) - formuparam; // the magic formula
			a += abs(length(p) - pa); // absolute sum of average change
			pa = length(p);
		}

		float dm = max(0.0, iDarkmatter - a * a * 0.001); //dark matter
		a *= a * a; // add contrast
		if (r > 6) {
      fade *= 1.0 - dm; // dark matter, don't render near
    }

		//v += vec3(dm, dm * 0.5, 0.0);
		v += fade;
		v += vec3(s, s * s, s * s * s * s) * a * (iBrightness / 1000.0) * fade; // coloring based on distance
		fade *= iDistfading; // distance fading
		s += stepsize;
	}
	v = mix(vec3(length(v)), v, (iSaturation / 10.0))* 0.01 * iBlend; //color adjust

  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec3 pixel = mix(v, vec3(textureColor.r, textureColor.g, textureColor.b), 0.17);
  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 0.36)
  );	
}

