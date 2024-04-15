//https://www.shadertoy.com/view/ttKGDt
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 iResolution;
uniform float iTime;
uniform float iIterations;
uniform float sizeA;
uniform float sizeB;
uniform vec3 iTint; //vec3(0.02, 0.03, 0.05)

float pi = acos(-1.0);
float pi2 = acos(-1.0)*2.0;

mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(c,s,-s,c);
}


vec2 pmod(vec2 p, float r) {
    float a = atan(p.x, p.y) + pi/r;
    float n = pi2 / r;
    a = floor(a/n)*n;
    return p*rot(-a);
}

float box( vec3 p, vec3 b ) {
    vec3 d = abs(p) - b;
    return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float ifsBox(vec3 p) {
    for (int i=0; i<5; i++) {
        p = abs(p) - 1.0;
        p.xy *= rot(iTime*0.3);
        p.xz *= rot(iTime*0.1);
    }
    p.xz *= rot(iTime);
    return box(p, vec3(0.4,0.8,0.3));
}

float map(vec3 p, vec3 cPos) {
    vec3 p1 = p;
    p1.x = mod(p1.x-5., 10.) - 5.;
    p1.y = mod(p1.y-5., 10.) - 5.;
    p1.z = mod(p1.z, sizeA) - sizeB;
    p1.xy = pmod(p1.xy, 5.0);
    return ifsBox(p1);
}

void main() {
  vec2 p = (v_vTexcoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);

  vec3 cPos = vec3(0.0,0.0, -3.0 * iTime);
  // vec3 cPos = vec3(0.3*sin(iTime*0.8), 0.4*cos(iTime*0.3), -6.0 * iTime);
  vec3 cDir = normalize(vec3(0.0, 0.0, -1.0));
  vec3 cUp  = vec3(sin(iTime), 1.0, 0.0);
  vec3 cSide = cross(cDir, cUp);

  vec3 ray = normalize(cSide * p.x + cUp * p.y + cDir);

  // Phantom Mode https://www.shadertoy.com/view/MtScWW by aiekick
  float acc = 0.0;
  float acc2 = 0.0;
  float t = 0.0;
  for (int i = 0; i < 10; i++) {
    vec3 pos = cPos + ray * t;
    float dist = map(pos, cPos);
    dist = max(abs(dist), 0.01);
    float a = exp(-dist*2.0);
    if (mod(length(pos)+24.0*iTime, 10.0) < 16.0) {
        a *= 5.0;
        acc2 += a;
    }
    acc += a;
    t += dist * iIterations;
  }
  
  vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
  vec3 color = vec3(acc * iTint.r * tex.r, acc * iTint.g * tex.g + acc2 * 0.004, acc * iTint.b + acc2*0.012 * tex.b);
  float alpha = v_vColour.a * abs(((color.r + color.g + color.b) / 3.0) - 1.0);
  gl_FragColor = vec4(color, alpha);
}
