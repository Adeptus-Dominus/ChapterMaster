//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vMaskCoord;

uniform vec3 replace_colour;
uniform sampler2D armour_texture;

uniform int blend;
uniform vec3 blend_colour;


vec3 light_or_dark(vec3 m_colour, float shade) {
    return vec3((clamp(m_colour.r * shade,0.01,0.99)) , (m_colour.g * shade), m_colour.b * shade);
}

void main() {
    const float _60COL = 60.0 / 255.0;
    // Attempt to workaround Intel sampling bug
    const float _127_25COL = 127.25 / 255.0;
    const float _128COL = 128.0 / 255.0;
    const float _128_75COL = 128.75 / 255.0;
    //
    const float _160COL = 160.0 / 255.0;
    const float _215COL = 215.0 / 255.0;

    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);

    if (col.rgba == vec4(0.0, 0.0, 0.0, 0.0)) {
        discard;
    }

    // Intel
    if (col.r >= _127_25COL && col.r <= _128_75COL) {
        col.r = _128COL;
    }
    if (col.g >= _127_25COL && col.g <= _128_75COL) {
        col.g = _128COL;
    }
    if (col.b >= _127_25COL && col.b <= _128_75COL) {
        col.b = _128COL;
    }
    if (col.a >= _127_25COL && col.a <= _128_75COL) {
        col.a = _128COL;
    }
    //

    if (col.rgb != replace_colour.rgb) {
        col.a = 0.0;
    } else {
        vec4 col_orig = col;
        col = texture2D(armour_texture, v_vMaskCoord);
        if (col.a != 0.0) {
            if (blend == 1) {
                col.rgb = col.rgb * blend_colour.rgb;
            }

            if (col_orig.a == _128COL) {
                col.rgb = light_or_dark(col.rgb, 1.2);
                col.a = 1.0;
            } else if (col_orig.a == _60COL) {
                col.rgb = light_or_dark(col.rgb, 1.4);
                col.a = 1.0;
            } else if (col_orig.a == _215COL) {
                col.rgb = light_or_dark(col.rgb, 0.6);
                col.a = 1.0;
            } else if (col_orig.a == _160COL) {
                col.rgb = light_or_dark(col.rgb, 0.8);
                col.a = 1.0;
            }
        } else {
            col = texture2D(gm_BaseTexture, v_vTexcoord);
        }
    }

    gl_FragColor = v_vColour * col;
    //gl_FragColor = v_vColour * (background_col*texture2D(gm_BaseTexture, v_vTexcoord));
}
