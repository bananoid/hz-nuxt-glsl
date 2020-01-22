#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 iResolution;
uniform float iTime;

#define MAX_STEPS 20
#define MAX_DIST 20.
#define SURF_DIST .001

float GetDist(vec3 p) {
  float t = iTime * 0.1;
  float sY = cos(t * 2.) * 0.1 + 0.5 + .9;
  float sX = sin(t * 2.) * 0.1;
  float sZ = sin(t * 1.) * 1.;
	vec4 s1 = vec4(sX, sY, 7.0 + sZ , 1.2);
	vec4 s2 = vec4(sX, sY, 7.0-0.5 + sZ, 0.8);

  float sphereDist1 =  length(p-s1.xyz)-s1.w + sin(t*10. + p.y * 4.0)*.1;
  float sphereDist2 =  length(p-s2.xyz)-s2.w + sin(t*20. + p.y * 20.0)*.03;
  float planeDist = p.y;

  // float d = min(sphereDist, planeDist);
  float d = max(-sphereDist2, sphereDist1);
  return d + sin(t*10.1234 + p.z * 4.3)*.1 * sin(t*10.36 + p.y * 4.3)*2.3;
}

float RayMarch(vec3 ro, vec3 rd) {
	float dO=0.;

    for(int i=0; i<MAX_STEPS; i++) {
    	vec3 p = ro + rd*dO;
        float dS = GetDist(p);
        dO += dS;
        if(dO>MAX_DIST || dS<SURF_DIST) break;
    }

    return dO;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;

    vec3 col = vec3(0.0);

    vec3 ro = vec3(0, 1, 0);
    vec3 rd = normalize(vec3(uv.x, uv.y, 1));

    float d = RayMarch(ro, rd);
    d = d/6. - 0.5;
    col = vec3(0.0,1.0-d,1.0-d);

    fragColor = vec4(col,1.0);
}

void main() {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
