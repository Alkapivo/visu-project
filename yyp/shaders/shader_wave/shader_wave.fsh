///@shader shaderWave
///@description Fragment shader.

	varying vec4 inputColor;
	varying vec2 inputTexture;

	uniform float amount;
	uniform float time;
	uniform float speed;
	uniform float distortion;
		

	void main() {
	
		vec2 uv = inputTexture;
		uv.x = uv.x + cos(uv.y * amount + time * speed) / distortion;
		uv.y = uv.y + sin(uv.x * amount + time * speed) / distortion;
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, uv);
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
