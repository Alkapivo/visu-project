///@shader shaderScanlines
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {vec3(r, g, b, a)} color
///@uniform {float} height

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform vec4 color;


	void main() {
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, inputTexture);
		
		float halfY = inputTexture.y * resolution.y * 0.5;
		float delta = floor(halfY) - halfY;
		
		if (delta * delta < 0.1) {
			outputPixel = color;	
		}
    
    outputPixel.a *= inputColor.a;
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
