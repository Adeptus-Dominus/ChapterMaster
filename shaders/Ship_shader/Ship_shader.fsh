varying vec2 v_vTexcoord;
uniform vec3 main_colour;
varying vec4 v_vColour;
void main() {
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(1, 1, 1, 1) * texColor;
    if (texColor.b > texColor.g && texColor.b > texColor.r) {
        float ratio = 2.0 * (texColor.b - 0.1);
        gl_FragColor = vec4(1, 1, 1, 1) * vec4(main_colour.r * ratio, main_colour.g * ratio, main_colour.b * ratio, 1);
        //texColor.rgb=main_colour.rgb;
        //texColor.a = 1.0;
    }
}