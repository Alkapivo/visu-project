///@shader shaderHue
///@description Fragment shader.

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform float colorShift;
	
	
	const mat3 rgb2yiq = mat3(
		0.299, 0.587, 0.114, 
		0.595716, -0.274453, -0.321263, 
		0.211456, -0.522591, 0.311135
	);
	
	const mat3 yiq2rgb = mat3(
		1.0, 0.9563, 0.6210, 
		1.0, -0.2721, -0.6474, 
		1.0, -1.1070, 1.7046
	);
	
	void main() {
		
		vec4 tColor = texture2D(gm_BaseTexture, inputTexture);
		vec3 yColor = (tColor.rgb * inputColor.rgb) * rgb2yiq;
		
		float originalHue = atan(yColor.b, yColor.g);
		float finalHue = originalHue + colorShift;
		
		float chroma = sqrt(yColor.b * yColor.b + yColor.g * yColor.g);
		vec3 yFinalColor = vec3(yColor.r, chroma * cos(finalHue), chroma * sin(finalHue));
		
	    vec4 outputPixel = vec4(yFinalColor * yiq2rgb, tColor.a * inputColor.a);
		
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
