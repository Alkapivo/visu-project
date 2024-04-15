///@shader shaderScanlines
///@description Vertex shader.

	attribute vec3 in_Position;
	attribute vec4 in_Colour;
	attribute vec2 in_TextureCoord;

	varying vec4 inputColor;
	varying vec2 inputTexture;


	void main() {
	
	    vec4 objectSpacePosition = vec4(
			in_Position.x,
			in_Position.y,
			in_Position.z,
			1.0);
	    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePosition;
    
		/// Pass varying to fragment shader
	    inputColor = in_Colour;
	    inputTexture = in_TextureCoord;
	}
	
