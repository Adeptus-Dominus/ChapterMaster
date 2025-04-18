//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 skin;
uniform vec3 dark;
uniform vec3 dark2;
uniform vec3 eyes;

vec3 light_or_dark(vec3 m_colour, float shade) {
    return vec3((clamp(m_colour.r * shade,0.001,0.999)) , (m_colour.g * shade), m_colour.b * shade);
}

void main()
{
    vec4 col_orig = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 col = col_orig;
    if (col_orig.rgb== vec3(1.0, 218.0/255.0, 179.0/255.0).rgb){
        col.rgb = skin.rgb;
    }
    else if (col_orig.rgb== vec3(209.0/255.0, 179/255.0, 146.0/255.0).rgb){
        col.rgb = light_or_dark(skin.rgb, 0.8);
    }
    else if (col_orig.rgb== vec3(186.0/255.0, 159.0/255.0, 130.0.0/255.0).rgb){
        col.rgb = light_or_dark(skin.rgb, 0.7);
    }
    gl_FragColor = v_vColour * col;
}
