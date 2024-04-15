///@shader shaderDefault
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution

	varying vec4 inputColor;
	varying vec2 inputTexture;
	

	void main() {
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, inputTexture);
		
		outputPixel.rgb = 1.0 - outputPixel.rgb;
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
