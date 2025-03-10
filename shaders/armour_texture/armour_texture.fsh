//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 replace_colour;
uniform sampler2D armour_texture;

void main()
{
    vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 background_col = texture2D(armour_texture, v_vTexcoord);
    if (background_col.rgb == replace_colour.rgb){
       vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
    }
    gl_FragColor = v_vColour * col;
}
