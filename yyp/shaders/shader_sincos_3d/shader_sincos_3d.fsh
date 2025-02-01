///@description https://www.shadertoy.com/view/XfXGz4
///@author ChunderFPV 2023-12-17
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform float lineThickness; // 0.1
uniform float pointRadius; // 0.3

#define A(angle) mat2(cos(angle), -sin(angle), sin(angle), cos(angle))  // rotate
#define W(v) length(vec3(p.yz-v(p.x+vec2(0, pi_2)+t), 0))-lt  // wave
#define P(v) length(p-vec3(0, v(t), v(t+pi_2)))-pt  // point

void main() {
    float lt = lineThickness, 
          pt = pointRadius, 
          pi = 3.1416,
          pi2 = pi*2.,
          pi_2 = pi/2.,
          t = iTime*pi,
          s = 1., d = 0., i = d;
    vec2 R = iResolution.xy,
         m = (iMouse.xy-.5*R)/R.y*4.;
    vec3 o = vec3(0, 0, -7), // cam
         u = normalize(vec3((v_vTexcoord-.5*R)/R.y, 1)),
         c = vec3(0), k = c, p;
    if (iMouse.z < 1.) m = -vec2(t/20.-pi_2, 0);
    mat2 v = A(m.y), h = A(m.x); // pitch & yaw
    for (; i++<25.;) // raymarch
    {
        p = o+u*d;
        p.yz *= v;
        p.xz *= h;
        p.x -= 3.;
        if (p.y < -1.5) p.y = 2./p.y;
        k.x = min( max(p.x+lt, W(sin)), P(sin) );
        k.y = min( max(p.x+lt, W(cos)), P(cos) );
        s = min(s, min(k.x, k.y));
        if (s < .001 || d > 100.) break;
        d += s*.5;
    }
    c = max(cos(d*pi2) - s*sqrt(d) - k, 0.);
    c.gb += .1;

    if ((c.r < 0.15) && (c.g < 0.15) && (c.b < 0.15)) {
        discard;
    }

    vec4 tColor = texture2D(gm_BaseTexture, v_vTexcoord);

    //gl_FragColor = vec4(tColor.rgb * c*.4 + c.brg*.6 + c*c, tColor.a * v_vColour.a);
    gl_FragColor = vec4(c, tColor.a * v_vColour.a);
}
