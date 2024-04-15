///@shader shader_magnify
///@uniform {vec2} resolution
///@uniform {vec2} position
///@uniform {float} radius
///@uniform {float} minZoom
///@uniform {float} maxZoom

varying vec4 inputColor;
varying vec2 inputTexture;
	
uniform vec2 resolution;
uniform vec2 position;
uniform float radius;
uniform float minZoom;
uniform float maxZoom;
	

void main() {
	vec2 uv = inputTexture;
	uv.x *= (resolution.x / resolution.y);
	vec2 pos = vec2(position.x * resolution.x, position.y * resolution.y);
	float centre_x = (pos.x / resolution.x) * (resolution.x / resolution.y);
	float centre_y = pos.y / resolution.y;
	float maxX = centre_x + radius;
	float minX = centre_x - radius;
	float maxY = centre_y + radius;
	float minY = centre_y - radius;
	if(uv.x > minX && uv.x < maxX && uv.y > minY && uv.y < maxY) {
	  float relX = uv.x - centre_x;
	  float relY = uv.y - centre_y;
	  float ang = atan(relY, relX);
	  float dist = sqrt(relX * relX + relY * relY);
		if(dist <= radius) {
		  float newRad = dist * ((maxZoom * dist/radius) + minZoom);
		  float newX = centre_x + cos(ang) * newRad;
		  newX *= (resolution.y / resolution.x);
		  float newY = centre_y + sin(ang) * newRad;
		  gl_FragColor = texture2D(gm_BaseTexture, vec2(newX, newY)) * inputColor;
		} else {
		   gl_FragColor = texture2D(gm_BaseTexture, inputTexture) * inputColor;
		}
	} else {
		gl_FragColor = texture2D(gm_BaseTexture, inputTexture) * inputColor;
	}  
}
	
