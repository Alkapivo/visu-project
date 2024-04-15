///@shader shader_mosaic
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {float} amount

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform float amount;
	

	void main() {
		
		vec2 res = vec2(1.0, resolution.x / resolution.y);
		vec2 size = vec2(res.x / amount, res.y / amount);
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, inputTexture - mod(inputTexture, size));
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
