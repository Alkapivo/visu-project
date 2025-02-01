///@description https://www.shadertoy.com/view/lffyWf
///@author Peace 2024-07-22
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 iResolution;
uniform float iTime;

// uv https://www.shadertoy.com/view/M3cSDS
vec2 CenterUV(vec2 v_vTexcoord) {
  return (2.0 * v_vTexcoord - iResolution.xy) / min(iResolution.x, iResolution.y);
}

// https://www.shadertoy.com/view/4fXyzr
float CrateGrid(vec2 uv, float cellSize) {
  vec2 line = vec2(0.005) * uv.y;
  uv = abs(mod(uv - 0.5 * cellSize, cellSize) - 0.5 * cellSize);
  vec2 gridUV = 1.0 - pow(uv, vec2(0.4));
  gridUV += 1.0 - (smoothstep(line - 0.01, line + 0.01, uv));
  return gridUV.x * gridUV.y;
}

vec3 calculateXYZ(vec2 uv) {
  float z = 1.0 / abs(uv.y);
  return vec3(uv.x * z, uv.y, z);
}

vec2 RotateUV(vec2 uv, float angle) {
  return vec2(uv.x * cos(angle) - uv.y * sin(angle), uv.x * sin(angle) + uv.y * cos(angle));
}

void main() {
  vec2 uv = RotateUV(CenterUV(v_vTexcoord), iTime * 0.5);
  vec3 xyz = calculateXYZ(uv);
  vec3 col = 0.5 + 0.5 * cos(iTime + vec3(xyz.x, xyz.y, xyz.x) + vec3(0, 2, 4));
  float grid = CrateGrid(vec2(xyz.x + iTime * 3.0, xyz.z), 0.4) * (1.0 - smoothstep(2.0, 5.0, xyz.z));
  vec3 gridColor = grid * col;
  vec4 textureColor = texture2D(gm_BaseTexture, v_vTexcoord);
  vec4 pixel = vec4(gridColor, 1.0);
  gl_FragColor = vec4(
      pixel.x + textureColor.x, 
      pixel.y + textureColor.y, 
      pixel.z + textureColor.z, 
      textureColor.a * v_vColour.a
  );
}
