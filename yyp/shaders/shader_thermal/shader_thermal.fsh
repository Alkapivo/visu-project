///@shader shaderThermal
///@description Fragment shader.

	varying vec4 inputColor;
	varying vec2 inputTexture;
	

	void main() {
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, inputTexture);
		
		float luminescence = (outputPixel.r + outputPixel.g + outputPixel.b) / 3.0;
		
		mat3 colors = mat3(
			0.7, 0.2, 0.5,
			0.7, 0.1, 0.3,
			0.7, 0.5, 0.4);
			
		vec3 firstMix = luminescence < 0.5 ? colors[0] : colors[1];
		vec3 secondMix = luminescence < 0.5 ? colors[1] : colors[2];
		
		outputPixel.rgb = mix(firstMix, secondMix, (luminescence - float(firstMix) * 0.5) / 0.5);
		
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
