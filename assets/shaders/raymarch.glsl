#ifdef GL_ES
precision highp float;
#endif

uniform vec3 iResolution;
uniform float iTime;

#define MAX_STEPS 1000
#define MAX_DIST 100.
#define SURF_DIST .0001

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdRoundBox( vec3 p, vec3 b, float r )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}

float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}

float sdCone( vec3 p, vec2 c )
{
  // c is the sin/cos of the angle
  float q = length(p.xy);
  return dot(c,vec2(q,p.z));
}

float sdRoundCone( vec3 p, float r1, float r2, float h )
{
  vec2 q = vec2( length(p.xz), p.y );

  float b = (r1-r2)/h;
  float a = sqrt(1.0-b*b);
  float k = dot(q,vec2(-b,a));

  if( k < 0.0 ) return length(q) - r1;
  if( k > a*h ) return length(q-vec2(0.0,h)) - r2;

  return dot(q, vec2(a,b) ) - r1;
}

float sdEllipsoid( vec3 p, vec3 r )
{
  float k0 = length(p/r);
  float k1 = length(p/(r*r));
  return k0*(k0-1.0)/k1;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float sdOctahedron( vec3 p, float s)
{
  p = abs(p);
  return (p.x+p.y+p.z-s)*0.57735027;
}

float rounding( in float d, in float h )
{
    return d - h;
}

mat2 rotate(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

float opSmoothUnion( float a, float b, float k ) {
    float h = clamp( 0.5+0.5*(b-a)/k, 0., 1. );
    return mix( b, a, h ) - k*h*(1.0-h);
}

float opSmoothSubtraction( float a, float b, float k ) {
    float h = clamp( 0.5-0.5*(b+a)/k, 0., 1. );
    return mix( b, -a, h ) - k*h*(1.0-h);
}

float opSmoothIntersection( float d1, float d2, float k ) {
  float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
  return mix( d2, d1, h ) + k*h*(1.0-h);
}


float GetDist(vec3 p) {
  float planeDist = p.y +0.1;

	vec4 s = vec4(0, 0.9, 6, 1);
  p -= s.xyz;
  p.xz *= rotate(iTime * 0.123 + 1.34);
  p.xy *= rotate(iTime*0.9861234 * 0.1 + 0.44);
  p += s.xyz;

  float obj1 = sdRoundBox( p - s.xyz + vec3(0.4,-0.3,0.4), vec3(0.2,0.5,0.2) , 0.3);
  float obj2 = sdSphere( p - s.xyz, s.w);
  float obj3 = sdCapsule( p - s.xyz, vec3(.0,-1.0,.0), vec3(.0,1.0,.0), 0.5 );
  // vec3 pp = p;
  // pp.xz *= rotate(3.14);

  // float obj4 = sdRoundCone( pp - s.xyz,  0.4, 0.2, 1. );
  // float obj5 = sdEllipsoid( p - s.xyz,  vec3(0.6,1.0,0.6) );
  float obj6 = sdTorus( p - s.xyz, vec2(1.0,0.3));
  // float obj7 = sdOctahedron( p - s.xyz, 1.0);

  float d = 0.0;
  d = opSmoothSubtraction(obj1, obj3, 0.01);
  // d = opSmoothSubtraction(obj3, d, 0.01);
  // d = min(obj4, d);
  // d = min(d, obj4);
  // d = rounding(d, sin(iTime) * 0.1 - 0.1);
  d = mix(d, obj6, sin(iTime * 0.1) * 0.5 + 0.5);
  d = opSmoothUnion(d, planeDist,0.9);

  return d;
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

float softshadow(vec3 ro, vec3 rd, float mint, float tmax, float w)
{
 	float t = mint;
    float res = 1.0;
    for( int i=0; i<256; i++ )
    {
     	float h = GetDist(ro + t*rd);
        res = min( res, h/(w*t) );
    	t += clamp(h, 0.005, 0.10);
        if( res<-1.0 || t>tmax ) break;
    }
    res = max(res,-1.0); // clamp to [-1,1]

    return 0.25*(1.0+res)*(1.0+res)*(2.0-res); // smoothstep
}

vec3 GetNormal(vec3 p) {
	float d = GetDist(p);
  vec2 e = vec2(.01, 0);

  vec3 n = d - vec3(
      GetDist(p-e.xyy),
      GetDist(p-e.yxy),
      GetDist(p-e.yyx));

  return normalize(n);
}

float GetLight(vec3 p, vec3 lightPos) {
  vec3 l = normalize(lightPos-p);

  vec3 n = GetNormal(p);
  float dif = clamp(dot(n, l), 0., 1.0);

  // float d = RayMarch(p+n*SURF_DIST*2., l);
  // if(d<length(lightPos-p)) dif *= .1;

  float shadow = softshadow( p, l, 0.01, 3.0, .3);
  dif *= shadow;

  return dif;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;

  vec3 col = vec3(0);

  vec3 ro = vec3(0, 1, 0);
  vec3 rd = normalize(vec3(uv.x, uv.y, 1));

  float d = RayMarch(ro, rd);
  float z = 1.0 - (d*0.2 - 0.7);
  z = clamp(z , 0.0, 1.0);
  vec3 p = ro + rd * d;

  vec3 lightPos = vec3(2, 2, 6);
  // lightPos.xz += vec2(sin(iTime), cos(iTime))*2.;

  // float dif = GetLight(p, lightPos)*0.8 * z;
  float dif = (((GetLight(p, lightPos)-0.5)*0.3)+0.5) * z * 2.0;

  col = vec3(dif);
  vec3 tint = normalize(vec3(0.4, 0.7, 1.0));
  col += vec3(0.3, 0.0, 0.0);
  col *= tint * 3.0;
  col -= 0.15;

  fragColor = vec4(col,1.0);
}

void main() {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
