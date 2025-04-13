//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float highlight;
vec3 light_or_dark(vec3 m_colour, float shade){
    return vec3((m_colour.r * shade) + 0.01, m_colour.g * shade, m_colour.b * shade);
}

void main() {
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
    col.rgb = light_or_dark(col.rgb, highlight);
    gl_FragColor = v_vColour * col;
}
