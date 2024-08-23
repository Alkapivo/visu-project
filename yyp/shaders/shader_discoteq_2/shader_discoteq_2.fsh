///@description https://www.shadertoy.com/view/DtXfDr
///@author supah 2023-08-23
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 iResolution;
uniform float iTime;

vec4 Line(vec2 uv, float speed, float height, vec3 col) {
    uv.y += smoothstep(1., 0., abs(uv.x)) * sin(iTime * speed + uv.x * height) * .2;
    return vec4(smoothstep(.06 * smoothstep(.2, .9, abs(uv.x)), 0., abs(uv.y) - .004) * col, 1.0) * smoothstep(1., .3, abs(uv.x));
}

void main() {
    vec2 uv = (v_vTexcoord - .5 * iResolution.xy) / iResolution.y;
    vec4 textureColor = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 pixel = vec4 (0.);
    for (float i = 0.; i <= 5.; i += 1.) {
        float t = i / 5.;
        pixel += Line(uv, 1. + t, 4. + t, vec3(.2 + t * .7, .2 + t * .4, 0.3));
    }
    
    gl_FragColor = vec4(
        pixel.x + textureColor.x, 
        pixel.y + textureColor.y, 
        pixel.z + textureColor.z, 
        textureColor.a * v_vColour.a
    );
}