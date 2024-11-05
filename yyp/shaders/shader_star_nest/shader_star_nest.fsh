///@description Based on shader "Star Nest" created by Kali in 2013-06-17
///             https://www.shadertoy.com/view/XlfGRj

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec3 iResolution;
uniform float iTime;
uniform float iAngle;

#define iterations 17
#define formuparam 0.53
#define volsteps 20
#define stepsize 0.1
#define zoom   0.800
#define tile   0.850
#define speed  0.010 
#define brightness 0.0015
#define darkmatter 0.300
#define distfading 0.730
#define saturation 0.850
#define tau 6.283185

void main() {
	//get coords and direction
	vec2 uv=vTexcoord.xy/iResolution.xy-.5;
	uv.y*=iResolution.y/iResolution.x;
	vec3 dir=vec3(uv*zoom,1.);
	float time=iTime;

	float a1 = 0.5 / iResolution.x;
	float a2 = 0.5 / iResolution.y;
	mat2 rot1 = mat2(cos(a1), sin(a1), -sin(a1), cos(a1));
	mat2 rot2 = mat2(cos(a2), sin(a2), -sin(a2), cos(a2));
	dir.xz *= rot1;
	dir.xy *= rot2;

	float angle = (iAngle / 360.0) * tau;
	vec3 from = vec3(cos(angle) * (iTime / 60.0), sin(angle) * (iTime / 60.0), -2.0);
	from.xz *= rot1;
	from.xy *= rot2;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust

  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec3 pixel = mix(v * 0.01, vec3(textureColor.r, textureColor.g, textureColor.b), 0.17);
  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 1.33)
  );	
}

