///@shader shaderDefault
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {float} ledSize
///@uniform {float} brightness

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform float ledSize;
	uniform float brightness;
	

	vec4 pixelize(vec2 uv, float scale) {
		float dx = 1.0 / scale;
		float dy = 1.0 / scale;
		vec2 coord = vec2(
			dx * ceil(uv.x / dx),
			dy * ceil(uv.y / dy));
		return texture2D(gm_BaseTexture, coord);
	}

	void main() {
		
		vec2 coord = inputTexture * ledSize;
		coord.x *= resolution.x / resolution.y;
		float computedDots = (abs(sin(coord.x * 3.1415)) * 1.2) * (abs(sin(coord.y * 3.1415)) * 1.2);
		
		vec4 outputPixel = pixelize(inputTexture, ledSize) * brightness;
		outputPixel = computedDots < 1.0 ?
			vec4(outputPixel.r * 0.5, outputPixel.g * 0.5, outputPixel.b * 0.5, outputPixel.a * 0.5) :
			outputPixel * computedDots;
		outputPixel.a *=  inputColor.a;
    
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
