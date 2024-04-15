///@shader shader_ripple
///@description Fragment shader.
///@uniform {vec2(width, height)} resolution
///@uniform {vec2(x, y)} position
///@uniform {float} amount
///@uniform {float} distortion
///@uniform {float} speed
///@uniform {float} time

	varying vec4 inputColor;
	varying vec2 inputTexture;
	
	uniform vec2 resolution;
	uniform vec2 position;
	uniform float amount;
	uniform float distortion;
	uniform float speed;
	uniform float time;
	

	void main() {
		
		vec2 texture = inputTexture;
		texture.x *= (resolution.x / resolution.y);
		float centerX = (position.x / resolution.x) * (resolution.x / resolution.y);
		float centerY = position.y / resolution.y;
		
		vec2 direction = inputTexture - vec2(0.5, 0.5);
		float dist = distance(texture, vec2(centerX, centerY));
		vec2 offset = direction * (sin(dist * amount - time * speed)) / distortion;
		
		vec4 outputPixel = inputColor * texture2D(gm_BaseTexture, inputTexture + offset);
	
		/// Pass pixel to renderer
		gl_FragColor = outputPixel;
	}
	
