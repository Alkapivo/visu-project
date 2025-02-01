///@description Based on shader created by haquxx in 2020-01-29
///             https://www.shadertoy.com/view/WldSRn

varying vec2 vTexcoord;
varying vec4 vColor;

uniform vec2 iResolution;
uniform float iTime;
uniform float iIterations;
uniform float iSize;
uniform float iPhase;
uniform float iDistance;
uniform float iTreshold; // 0.0006
uniform vec3 iTint; // vec3(0.0, 0.3, 0.7)

float sdSphere(vec3 pos, float size) {
  return length(pos) - size;
}

float sdBox(vec3 pos, vec3 size) {
  pos = abs(pos) - vec3(size);
  return max(max(pos.x, pos.y), pos.z);
}

float sdOctahedron(vec3 p, float s) {
  p = abs(p);
  float m = p.x + p.y + p.z - s;
  vec3 q;
  if (3.0 * p.x < m) {
    q = p.xyz;
  } else if (3.0 * p.y < m) {
    q = p.yzx;
  } else if (3.0 * p.z < m) {
    q = p.zxy;
  } else {
    return m * 0.57735027;
  }
  
  float k = clamp(0.5*(q.z - q.y + s), 0.0, s); 
  return length(vec3(q.x, q.y - s + k, q.z - k)); 
}

float sdPlane(vec3 pos) {
  return pos.y;
}

mat2 rotate(float a) {
  float s = sin(a);
  float c = cos(a);
  return mat2(c, s, -s, c);
}

vec3 repeat(vec3 pos, vec3 span) {
  return abs(mod(pos, span)) - span * 0.5;
}

float getDistance(vec3 pos, vec2 uv) {
  vec3 originalPos = pos;

  for (int i = 0; i < 3; i++) {
      pos = abs(pos) - iSize;
      pos.xz *= rotate(1.0);
      pos.yz *= rotate(1.0);
  }

  pos = repeat(pos, vec3(iDistance));

  float d0 = abs(originalPos.x) - 0.1;
  float d1 = sdBox(pos, vec3(iPhase));

  pos.xy *= rotate(mix(1.0, 2.0, abs(sin(iTime))));
  float size = mix(1.1, 1.3, (abs(uv.y) * abs(uv.x)));
  float d2 = sdSphere(pos, size);
  float dd2 = sdOctahedron(pos, 1.8);
  float ddd2 = mix(d2, dd2, abs(sin(iTime)));

  return max(max(d1, -ddd2), -d0);
}

void main() {
  vec2 p = (vTexcoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);

  // camera
  vec3 cameraOrigin = vec3(0.0, 0.0, -10.0 + iTime * 4.0);
  vec3 cameraTarget = vec3(cos(iTime) + sin(iTime / 2.0) * 10.0, exp(sin(iTime)) * 2.0, 3.0 + iTime * 4.0);
  vec3 upDirection = vec3(0.0, 1.0, 0.0);
  vec3 cameraDir = normalize(cameraTarget - cameraOrigin);
  vec3 cameraRight = normalize(cross(upDirection, cameraOrigin));
  vec3 cameraUp = cross(cameraDir, cameraRight);
  vec3 rayDirection = normalize(cameraRight * p.x + cameraUp * p.y + cameraDir);
  vec3 rayPos = vec3(0.0);
  float depth = 0.0;
  float ac = 0.0;
  float d = 0.0;

  for (float i = 0.0; i < iIterations; i += 1.0) {
    rayPos = cameraOrigin + rayDirection * depth;
    d = getDistance(rayPos, p);
    if (abs(d) < iTreshold) {
      break;
    }

    ac += exp(-d * mix(5.0, 10.0, abs(sin(iTime))));        
    depth += d;
  }
  
  ac *= 0.168 * (iResolution.x / iResolution.y - abs(p.x));
  vec4 textureColor = texture2D(gm_BaseTexture, vTexcoord);
  vec3 pixel = mix(iTint * ac, vec3(textureColor.r, textureColor.g, textureColor.b), 0.36);

  gl_FragColor = vec4(
    pixel.x, 
    pixel.y, 
    pixel.z, 
    textureColor.a * vColor.a * ((pixel.x + pixel.y + pixel.z) / 1.33)
  );
}