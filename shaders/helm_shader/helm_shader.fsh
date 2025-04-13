//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 replace_colour;
uniform sampler2D background_texture;

void main()
{
// Remap v_vTexcoord to the UV bounds
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);

    if (col.rgb == vec3(200.0/255.0,0.0,0.0)){
        col.rgb = replace_colour.rgb;        
    }

    gl_FragColor = v_vColour * col;
}
