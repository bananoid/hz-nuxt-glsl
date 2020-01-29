#ifdef GL_ES
precision highp float;
#endif

uniform vec3 iResolution;
uniform float iTime;
uniform vec2 iMouse;

#define MAX_STEPS 1000
#define MAX_DIST 100.
#define SURF_DIST .001

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

mat2 Rot(float a) {
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

vec4 opSmoothUnionColor( vec4 a, vec4 b, float k ) {
    float h = clamp( 0.5+0.5*(b.w-a.w)/k, 0., 1. );
    return mix( b, a, h ) - k*h*(1.0-h);
}

vec4 objectSDFColor(vec3 p) {
  float planeDist = p.y +0.1;

	vec4 s = vec4(0, 0.9, 0, 1);
  
  // p -= s.xyz;
  // p.xz *= Rot(iTime * 0.123 + 1.34);
  // p.xy *= Rot(iTime*0.9861234 * 0.1 + 0.44);
  // p += s.xyz;

  float obj1 = sdRoundBox( p - s.xyz + vec3(0.4,-0.3,0.4), vec3(0.2,0.5,0.2) , 0.3);
  float obj2 = sdSphere( p - s.xyz, s.w);
  float obj3 = sdCapsule( p - s.xyz, vec3(.0,-1.0,.0), vec3(.0,1.0,.0), 0.5 );
  // vec3 pp = p;
  // pp.xz *= Rot(3.14);

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
  vec4 dC = opSmoothUnionColor(vec4(1.0,0.,0.,d), vec4(0.,0.,1.,planeDist),0.9);
   
  return dC;
}

float objectSDF(vec3 p) {
  return objectSDFColor(p).w; 
}

vec4 RayMarchColor(vec3 ro, vec3 rd) {
	float dO=0.;

  vec3 color = vec3(0.0);

  for(int i=0; i<MAX_STEPS; i++) {
    vec3 p = ro + rd*dO;
    vec4 dSC = objectSDFColor(p);
    float dS = dSC.w;
    color = dSC.rgb;
    dO += dS;
    if(dO>MAX_DIST || dS<SURF_DIST) break;
  }
  color = normalize(color);
  return vec4(color,dO);
}

float RayMarch(vec3 ro, vec3 rd) {
  return RayMarchColor(ro,rd).w;
}

// float softshadow(vec3 ro, vec3 rd, float mint, float tmax, float w)
// {
//  	float t = mint;
//     float res = 1.0;
//     for( int i=0; i<256; i++ )
//     {
//      	float h = objectSDF(ro + t*rd);
//         res = min( res, h/(w*t) );
//     	t += clamp(h, 0.005, 0.10);
//         if( res<-1.0 || t>tmax ) break;
//     }
//     res = max(res,-1.0); // clamp to [-1,1]

//     return 0.25*(1.0+res)*(1.0+res)*(2.0-res); // smoothstep
// }

// float calcSoftshadow( in vec3 ro, in vec3 rd, in float mint, in float tmax)
// {
// 	float res = 1.0;
//   float t = mint;
//   float ph = 1e10; // big, such that y = 0 on the first iteration

//   for( int i=0; i<32; i++ )
//   {
//     float h = objectSDF( ro + rd*t );
//     // use this if you are getting artifact on the first iteration, or unroll the
//     // first iteration out of the loop
//     //float y = (i==0) ? 0.0 : h*h/(2.0*ph);

//     float y = h*h/(2.0*ph);
//     float d = sqrt(h*h-y*y);
//     res = min( res, 10.0*d/max(0.0,t-y) );
//     ph = h;

//     t += h;

//     if( res<0.0001 || t>tmax ) break;

//   }
//   return clamp( res, 0.0, 1.0 );
// }

// vec3 GetNormal(vec3 p) {
// 	float d = objectSDF(p);
//   vec2 e = vec2(.01, 0);

//   vec3 n = d - vec3(
//       objectSDF(p-e.xyy),
//       objectSDF(p-e.yxy),
//       objectSDF(p-e.yyx));

//   return normalize(n);
// }

// float GetLight(vec3 p, vec3 lightPos) {
//   vec3 l = normalize(lightPos-p);

//   vec3 n = GetNormal(p);
//   float dif = clamp(dot(n, l), 0., 1.0);

//   // float d = RayMarch(p+n*SURF_DIST*2., l);
//   // if(d<length(lightPos-p)) dif *= .1;

//   float shadow = calcSoftshadow( p, l, 0.01, 3.0);
//   dif *= shadow;

//   return dif;
// }

// float GetContour(vec3 p, float z){
//   // vec3 n = GetNormal(p);
//   // float dif = dot( camPos, n);
//   // float c = 0.0;
//   // if(dif > 0.5){
//   //   c = 1.0;
//   // }
//   return z;
// }

vec3 R(vec2 uv, vec3 p, vec3 l, float z) {
    vec3 f = normalize(l-p),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f,r),
        c = p+f*z,
        i = c + uv.x*r + uv.y*u,
        d = normalize(i-p);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
	vec2 m = iMouse.xy/iResolution.xy;

  vec3 col = vec3(0);

  vec3 ro = vec3(0, 4, -5);
  ro.yz *= Rot(-m.y*3.14+1.);
  ro.xz *= Rot(-m.x*6.2831);

  vec3 rd = R(uv, ro, vec3(0,1,0), 1.);

  vec4 dC = RayMarchColor(ro, rd);
  float d = dC.w;

  float z = 1.0 - (d*0.2 - 0.7);
  z = clamp(z , 0.0, 1.0);

  vec3 colA = vec3(1.0,0.8,0.8) * 1.5;
  vec3 colB = vec3(1.0,0.3,0.2);

  // col = vec3(z);
  vec3 zC = mix(colB,colA, z);
  
  // col = mix(zC,dC.rgb * z, 0.9 ) ;
  col = z * dC.rgb;

  fragColor = vec4(col,1.0);
}

void main() {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
