precision mediump float;

uniform vec3 u_Color;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);

    vec4 color = vec4(u_Color / 255.0, 1.0);

    gl_FragColor = texColor * color;
}
