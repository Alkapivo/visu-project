///@description https://www.shadertoy.com/view/4tjSDt
///@author Dave_Hoskins 2015-11-12
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 iResolution;
uniform float iTime;
uniform float iIterations; // 10
uniform vec2 iSize; // vec2(1.666, 0.666)
uniform float iFactor; // 2.08
uniform vec3 iSeed; // vec3(0.03, 0.3, 0.0002)

void main() {
  float s = 0.0, v = 0.0;
	vec2 uv = (v_vTexcoord / iResolution.xy) * 2.0 - 1.;
  float time = (iTime - 2.0);
	vec3 col = vec3(0);
  vec3 init = vec3(sin(time * 0.1856) * iSeed.x, .35 - cos(time * 0.3) * iSeed.y, time * iSeed.z);
	for (float r = 0.0; r < 5.0; r += 1.0) {
		vec3 p = init + s * vec3(uv, 0.05);
		p.z = fract(p.z);
    // Thanks to Kali's little chaotic loop...
		for (float i = 0.0; i < 24.0; i += 1.0) {
      if (i > iIterations) {
        break;
      }

      p = abs(p * iFactor) / dot(p, p) -0.9;
    }
		v += pow(dot(p, p), iSize.x) * iSize.y;
		col +=  vec3(v * 0.2+.4, 12.-s*2., .1 + v * 1.) * v * 0.00003;
		s += .025;
	}
	vec4 pixel = vec4(clamp(col, 0.0, 1.0), 1.0);
  vec4 textureColor = texture2D(gm_BaseTexture, v_vTexcoord);
  gl_FragColor = vec4(
    pixel.x + textureColor.x, 
    pixel.y + textureColor.y, 
    pixel.z + textureColor.z, 
    textureColor.a * v_vColour.a
  );
}
