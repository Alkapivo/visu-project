///@shader shaderEmboss
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	

	void main() {
		
		vec2 onePixel = vec2(1.0 / resolution.x, 1.0 / resolution.y);
		vec3 color = vec3(0.5, 0.5, 0.5);
		
		color -= texture2D(gm_BaseTexture, inputTexture - onePixel).rgb;
		color += texture2D(gm_BaseTexture, inputTexture + onePixel).rgb;
		
		vec4 outputPixel = vec4(
			(color.r + color.g + color.b) / 3.0,
			(color.r + color.g + color.b) / 3.0,
			(color.r + color.g + color.b) / 3.0,
			texture2D(gm_BaseTexture, inputTexture).a);
	  outputPixel.a *= inputColor.a;
  
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}

