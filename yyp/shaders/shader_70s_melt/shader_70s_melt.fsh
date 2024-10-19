///@description Based on shader created by tomorrowevening in 2013-08-12
///             https://www.shadertoy.com/view/XsX3zl 

varying vec2 vTexcoord;
varying vec4 vColor;

uniform float iTime;
uniform vec2 iResolution;
uniform float iFactor;

const float RADIANS = 0.017453292519943295;
const float BRIGHTNESS = 0.975;

float cosRange(float degrees, float range, float minimum) {
	return (((1.0 + cos(degrees * RADIANS)) * 0.5) * range) + minimum;
}

void main() {
	vec2 uv = vTexcoord.xy / iResolution.xy;
	vec2 p  = (2.0*vTexcoord.xy-iResolution.xy) / max(iResolution.x,iResolution.y);
	float time = iTime * 1.25;
	float ct = cosRange(time * 5.0, 3.0, 1.1);
	float xBoost = cosRange(time * 0.2, 5.0, 5.0);
	float yBoost = cosRange(time * 0.1, 10.0, 5.0);
	float fScale = cosRange(time * 15.5, 1.25, 0.5);
	for (float i = 1.0; i < 40.0; i += 1.0) {
		vec2 newp = p;
		newp.x += 0.25 / i * sin(i * p.y + time * cos(ct) * 0.5 / 20.0 + 0.005 * i) * fScale + xBoost;		
		newp.y += 0.25 / i * sin(i * p.x + time * ct * 0.3 / 40.0 + 0.03 * (i + 15.0)) * fScale + yBoost;
		p = newp;
	}
	
	vec3 col = vec3(
		0.5 * sin(3.0*p.x) + 0.5,
		0.5 * sin(((iFactor / 100.0) + 3.0) * p.y) + 0.5,
		sin(p.x + p.y)
	);
	col *= BRIGHTNESS;
    
  // Add border
  float vigAmt = 10.0;
  float vignette = (1.0 - vigAmt * (uv.y - .5) * (uv.y - 0.5)) * (1.0 - vigAmt * (uv.x - 0.5) * (uv.x - 0.5));
	float extrusion = (col.x + col.y + col.z) / 4.0;
  extrusion *= 1.5;
  extrusion *= vignette;
  
	gl_FragColor = vec4(col.r, col.g, col.b, min(vColor.a, vColor.a * extrusion));
}
