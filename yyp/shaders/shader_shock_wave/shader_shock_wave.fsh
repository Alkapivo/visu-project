///@shader shaderDefault
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {vec2(x, y)} position
///@uniform {float} amplitude
///@uniform {float} refraction
///@uniform {float} width
///@uniform {float} time

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform vec2 position;
	uniform float amplitude;
	uniform float refraction;
	uniform float width;
	uniform float time;
	

	void main() {
		
		vec2 texture = inputTexture;
		texture.x *= resolution.x / resolution.y;
		vec2 newTexture = inputTexture;
		vec2 pos = vec2(position.x * resolution.x, position.y * resolution.y);
		float centerX = (pos.x / resolution.x) * (resolution.x / resolution.y);
		float centerY = pos.y / resolution.y;
		float dist = distance(texture, vec2(centerX, centerY));
		
		if ((dist <= time + width) && 
			(dist >= time - width)) {
			
			float difference = dist - time;
			float differencePower = 1.0 - pow(abs(difference * amplitude), refraction);
			float differenceTime = difference * differencePower;
			vec2 differenceTexture = normalize(texture - position);
			newTexture = texture + (differenceTexture * differenceTime);
			newTexture.x *= resolution.y / resolution.x;
		}
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, newTexture);
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
