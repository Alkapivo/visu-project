///@shader shaderSketch
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {float} intensity

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform float intensity;
	
	const vec3 W = vec3(0.1125, 0.3154, 0.0721);
	

	void main() {
		
		vec3 textureColor = texture2D(gm_BaseTexture, inputTexture).rgb;

		vec2 stp0 = vec2(1.0 / resolution.x, 0.0);
		vec2 st0p = vec2(0.0, 1.0 / resolution.y);
		vec2 stpp = vec2(1.0 / resolution.x, 1.0 / resolution.y);
		vec2 stpm = vec2(1.0 / resolution.x, -1.0 / resolution.y);

		float i00   = dot(textureColor, W);
		float im1m1 = dot(texture2D(gm_BaseTexture, inputTexture - stpp).rgb, W);
		float ip1p1 = dot(texture2D(gm_BaseTexture, inputTexture + stpp).rgb, W);
		float im1p1 = dot(texture2D(gm_BaseTexture, inputTexture - stpm).rgb, W);
		float ip1m1 = dot(texture2D(gm_BaseTexture, inputTexture + stpm).rgb, W);
		float im10  = dot(texture2D(gm_BaseTexture, inputTexture - stp0).rgb, W);
		float ip10  = dot(texture2D(gm_BaseTexture, inputTexture + stp0).rgb, W);
		float i0m1  = dot(texture2D(gm_BaseTexture, inputTexture - st0p).rgb, W);
		float i0p1  = dot(texture2D(gm_BaseTexture, inputTexture + st0p).rgb, W);
		
		float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
		float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
		float mag = 1.0 - length(vec2(h, v));
		vec3 target = vec3(mag);
		
		vec4 outputPixel = inputColor * vec4(mix(textureColor, target, intensity), texture2D(gm_BaseTexture, inputTexture).a);
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
