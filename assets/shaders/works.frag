#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 iResolution;
uniform float iTime;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;

    float dist = distance(uv, vec2(.0,.0)) * 2.0;
    float col = cos(iTime + dist * 10.0 ) * .5 + .5;

    fragColor = vec4(vec3(col),1.0);
}

void main() {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
