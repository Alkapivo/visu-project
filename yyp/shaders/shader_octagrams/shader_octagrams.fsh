//https://www.shadertoy.com/view/tlVGDt
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float iTime;
uniform float iIterations;
uniform vec2 iResolution;
uniform vec3 iTint; //vec3(0.0, 0.2, 0.2)

float gTime = 0.;
const float REPEAT = 5.0;

mat2 rot(float a) {
	float c = cos(a), s = sin(a);
	return mat2(c,s,-s,c);
}

float sdBox( vec3 p, vec3 b )
{
	vec3 q = abs(p) - b;
	return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float box(vec3 pos, float scale) {
	pos *= scale;
	float base = sdBox(pos, vec3(.4,.4,.1)) /1.5;
	pos.xy *= 5.;
	pos.y -= 3.5;
	pos.xy *= rot(.75);
	float result = -base;
	return result;
}

float box_set(vec3 pos, float iTime) {
	vec3 pos_origin = pos;
	pos = pos_origin;
	pos .y += sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box1 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);
	pos = pos_origin;
	pos .y -=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box2 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);
	pos = pos_origin;
	pos .x +=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box3 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);	
	pos = pos_origin;
	pos .x -=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box4 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);	
	pos = pos_origin;
	pos.xy *=   rot(.8);
	float box5 = box(pos,.5) * 6.;	
	pos = pos_origin;
	float box6 = box(pos,.5) * 6.;	
	float result = max(max(max(max(max(box1,box2),box3),box4),box5),box6);
	return result;
}

float map(vec3 pos, float iTime) {
	vec3 pos_origin = pos;
	float box_set1 = box_set(pos, iTime);

	return box_set1;
}


//https://www.shadertoy.com/view/ttKGDt
void main() {
  vec2 p = (v_vTexcoord.xy * 2. - iResolution.xy) / min(iResolution.x, iResolution.y);
	vec3 ro = vec3(0., -0.2 ,iTime * 4.);
	vec3 ray = normalize(vec3(p, 1.5));
	ray.xy = ray.xy * rot(sin(iTime * .03) * 5.);
	ray.yz = ray.yz * rot(sin(iTime * .05) * .2);
  
	float t = 0.1;
	vec3 col = vec3(0.);
	float ac = 0.0;
	for(int i = 0; i < 16; i++){
		vec3 pos = ro + ray * t;
		pos = mod(pos -  iIterations, iIterations) - (iIterations / 2.);
		//gTime = iTime - i * 0.01;
		
		float d = map(pos, iTime);

		d = max(abs(d), 0.01);
		ac += exp(-d*20.);

		t += d* 0.5;
	}

	col = vec3(ac * 0.33);
	col += vec3(iTint.r, iTint.g * abs(sin(iTime)), iTint.b * sin(iTime));

  gl_FragColor = vec4(
    col.r,
    col.g,
    col.b,
    v_vColour.a * (1.0 - t * (0.02 + 0.02 * abs(sin(iTime))))
   );
  //gl_FragColor = vec4(col, 1.0 - t * 0.03) * texture2D(gm_BaseTexture, v_vTexcoord);
}
