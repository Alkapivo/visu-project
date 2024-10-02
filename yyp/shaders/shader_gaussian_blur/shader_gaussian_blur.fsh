///@shader shaderGaussianBlur
///@description Fragment shader.
///@uniform {vec3(width, height, radius)} size

varying vec2 inputTexture;
varying vec4 inputColor;

uniform vec3 size; 

const int QUALITY = 8;
const int DIRECTIONS = 16;
const float TWO_PI = 6.28318530718;


void main() {

  vec2 radius = (size.z / size.xy);
  vec4 outputPixel = texture2D(gm_BaseTexture, inputTexture);
  for(float d = 0.0; d < TWO_PI; d += (TWO_PI / float(DIRECTIONS))) {
    for(float i = (1.0 / float(QUALITY)); i <= 1.0; i += (1.0 / float(QUALITY))) {
      outputPixel += texture2D(gm_BaseTexture, inputTexture + vec2(cos(d), sin(d)) * radius * i);
    }
  }
  outputPixel /= float(QUALITY) * float(DIRECTIONS) + 1.0;

  /// Pass pixel to renderer
  gl_FragColor = inputColor * outputPixel;
}

