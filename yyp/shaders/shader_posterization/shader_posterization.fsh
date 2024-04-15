///@shader shadershaderPosterization
///@description Fragment shader.
///@uniform {float} gamma
///@uniform {float} colorNumber

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform float gamma;
	uniform float colorNumber;
	

	void main() {
		
		vec3 pixel = texture2D(gm_BaseTexture, inputTexture).rgb;
		pixel = pow(abs(pixel), vec3(gamma, gamma, gamma));
		pixel = pixel * colorNumber;
		pixel = floor(pixel);
		pixel = pixel / colorNumber;
		pixel = pow(abs(pixel), vec3(1.0 / gamma));
		
		vec4 outputPixel = vec4(pixel, texture2D(gm_BaseTexture, inputTexture).a);
	  outputPixel.a *= inputColor.a;
  
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
