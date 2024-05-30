///@author iekdosha 2024-05-21
///@description https://www.shadertoy.com/view/XXcGWr
// Credit to nimitz (stormoid.com) (twitter: @stormoid)
// For the original shader here: https://www.shadertoy.com/view/ldlXRS
// Lisense has to propagate I think... so:
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

// I am just trying out new things and found this one, I do not understand how the original works so I am making mofications for fun.

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 iResolution; // viewport resolution (in pixels)
uniform float iTime; // shader playback time (in seconds)
//uniform sampler2D iChannel0..3;          // input channel. XX = 2D/Cube
uniform float iTreshold;
uniform float iSize;
uniform vec3 iTint; //vec3(0.2, 0.1, 0.4)

#define time (iTime)
#define pi 3.1415926535897932384626433832795
#define tau pi * 2.0

mat2 makem2(in float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat2(c,-s,s,c);
}

float noise(in vec2 x) {
    return texture2D(gm_BaseTexture, v_vTexcoord + (x * 0.03)).x; //return texture(iChannel0, x*.01).x;
}

float fbm(in vec2 p) {
    float z=2.;
    float rz = 0.;
    vec2 bp = p;
    for (float i  =1.0; i < 6.0; i++) {
        rz += abs((noise(p) - 0.5) * 2.0) / z;
        z = z * 2.0;
        p = p * 2.0;
    }
    
    return rz;
}

float dualfbm(in vec2 p) {
    //get two rotated fbm calls and displace the domain
    vec2 p2 = p * 0.7;
    vec2 basis = vec2(fbm(p2 - time * 1.6), fbm(p2 + time * 1.7));
    basis = (basis - 0.5) * 0.2;
    p += basis;
    
    //coloring
    return fbm(p * makem2(time * 0.2));
}

float circ(vec2 p) {
    float r = length(p);
    r = log(sqrt(r));
    return abs(mod(r * 4.0, tau) - 3.14) * 3.0 +.2;
}

void main() {
    //setup system
    vec2 p = v_vTexcoord.xy / iResolution.xy - 0.5;
    p.x *= iResolution.x / iResolution.y;
    float len = length(p);
    p*=iSize;
    
    float rz = dualfbm(p);
    float artifacts_radious_fade = pow(max(1.0, 6.5 * len), 0.2);
    rz = artifacts_radious_fade * rz + (1.0 - artifacts_radious_fade) * dualfbm(p + 5.0 * sin(time)); // Add floating things around portal
    float my_time = time + 0.08 * rz;
    
    //rings
    p /= exp(mod((my_time + rz), pi));  
    rz *= pow(abs((0.1 - circ(p))), 0.9);
    
    //final color
    vec3 col = 0.4 * iTint / rz;
    col = pow(abs(col), vec3(0.99));
    gl_FragColor = vec4(col, ((col.r + col.g + col.b + (iTreshold * 3.0)) / 3.0) * v_vColour.a);
}
