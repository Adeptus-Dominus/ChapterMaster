uniform vec3 left_leg_lower;
uniform vec3 left_leg_upper;
uniform vec3 left_leg_knee;
uniform vec3 right_leg_lower;
uniform vec3 right_leg_upper;
uniform vec3 right_leg_knee;
uniform vec3 metallic_trim;
uniform vec3 right_trim;
uniform vec3 left_trim;
uniform vec3 left_chest;
uniform vec3 main_colour;
uniform vec3 right_chest;
uniform vec3 left_thorax;
uniform vec3 right_thorax;
uniform vec3 left_pauldron;
uniform vec3 right_pauldron;
uniform vec3 left_head;
uniform vec3 right_head;
uniform vec3 left_muzzle;
uniform vec3 right_muzzle;
uniform vec3 left_arm;
uniform vec3 right_arm;
uniform vec3 left_hand;
uniform vec3 right_hand;
uniform vec3 eye_lense;
uniform vec3 right_backpack;
uniform vec3 left_backpack;
uniform vec3 company_marks;
uniform vec3 robes_colour_replace;
uniform vec3 weapon_primary;
uniform vec3 weapon_secondary;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;


vec3 light_or_dark(vec3 m_colour, float shade) {
    return vec3((clamp(m_colour.r * shade,0.001,0.999)) , (m_colour.g * shade), m_colour.b * shade);
}

void main() {
    const float _20COL = 20.0 / 255.0;
    const float _24COL = 24.0 / 255.0;
    const float _46COL = 46.0 / 255.0;
    const float _60COL = 60.0 / 255.0;
    const float _64COL = 64.0 / 255.0;
    const float _84COL = 84.0 / 255.0;
    const float _104COL = 104.0 / 255.0;
    const float _112COL = 112.0 / 255.0;
    // Attempt to workaround Intel sampling bug
    const float _127_25COL = 127.25 / 255.0;
    const float _128COL = 128.0 / 255.0;
    const float _128_75COL = 128.75 / 255.0;
    //
    const float _130COL = 130.0 / 255.0;
    const float _135COL = 135.0 / 255.0;
    const float _138COL = 138.0 / 255.0;
    const float _140COL = 140.0 / 255.0;
    const float _147COL = 147.0 / 255.0;
    const float _151COL = 151.0 / 255.0;
    const float _160COL = 160.0 / 255.0;
    const float _165COL = 165.0 / 255.0;
    const float _168COL = 168.0 / 255.0;
    const float _169COL = 169.0 / 255.0;
    const float _170COL = 170.0 / 255.0;
    const float _181COL = 181.0 / 255.0;
    const float _188COL = 188.0 / 255.0;
    const float _194COL = 194.0 / 255.0;
    const float _214COL = 214.0 / 255.0;
    const float _215COL = 215.0 / 255.0;
    const float _218COL = 218.0 / 255.0;
    const float _230COL = 230.0 / 255.0;

    vec4 col_orig = texture2D(gm_BaseTexture, v_vTexcoord);
    if (col_orig.rgba == vec4(0.0, 0.0, 0.0, 0.0)) {
        discard;
    }

    // Intel
    if (col_orig.r >= _127_25COL && col_orig.r <= _128_75COL) {
        col_orig.r = _128COL;
    }
    if (col_orig.g >= _127_25COL && col_orig.g <= _128_75COL) {
        col_orig.g = _128COL;
    }
    if (col_orig.b >= _127_25COL && col_orig.b <= _128_75COL) {
        col_orig.b = _128COL;
    }
    if (col_orig.a >= _127_25COL && col_orig.a <= _128_75COL) {
        col_orig.a = _128COL;
    }
    //
    vec4 col = col_orig;


    if (col.rgb == vec3(0.0, 0.0, _128COL).rgb) {
        col.rgb = left_head.rgb;
    } else if (col.rgb == vec3(_181COL, 0.0, 1.0).rgb) {
        col.rgb = right_backpack.rgb;
    } else if (col.rgb == vec3(_104COL, 0.0, _168COL).rgb) {
        col.rgb = left_backpack.rgb;
    } else if (col.rgb == vec3(0.0, 0.0, 1.0).rgb){
        col.rgb = right_head.rgb;
    } else if (col.rgb == vec3(_128COL, _64COL, 1.0).rgb) {
        col.rgb = left_muzzle.rgb;
    } else if (col.rgb == vec3(_64COL, _128COL, 1.0).rgb) {
        col.rgb = right_muzzle.rgb;
    } else if (col.rgb == vec3(0.0, 1.0, 0.0).rgb) {
        col.rgb = eye_lense.rgb;
    } else if (col.rgb == vec3(1.0, _20COL, _147COL).rgb) {
        col.rgb = right_chest.rgb;
    } else if (col.rgb == vec3(_128COL, 0.0, _128COL).rgb) {
        col.rgb = left_chest.rgb;
    } else if (col.rgb == vec3(0.0, _128COL, _128COL).rgb) {
        col.rgb = right_trim.rgb;
    } else if (col.rgb == vec3(1.0, _128COL, 0.0).rgb) {
        col.rgb = left_trim.rgb;
    } else if (col.rgb == vec3(_135COL, _130COL, _188COL).rgb) {
        col.rgb = metallic_trim.rgb;
    } else if (col.rgb == vec3(1.0, 1.0, 1.0).rgb) {
        col.rgb = right_pauldron.rgb;
    } else if (col.rgb == vec3(1.0, 1.0, 0.0).rgb) {
        col.rgb = left_pauldron.rgb;
    } else if (col.rgb == vec3(0.0, _128COL, 0.0).rgb) {
        col.rgb = right_leg_upper.rgb;
    } else if (col.rgb == vec3(1.0, _112COL, _170COL).rgb) {
        col.rgb = left_leg_upper.rgb;
    } else if (col.rgb == vec3(1.0, 0.0, 0.0).rgb) {
        col.rgb = left_leg_knee.rgb;
    } else if (col.rgb == vec3(_128COL, 0.0, 0.0).rgb) {
        col.rgb = left_leg_lower.rgb;
    } else if (col.rgb == vec3(_214COL, _194COL, 1.0).rgb) {
        col.rgb = right_leg_knee.rgb;
    } else if (col.rgb == vec3(_165COL, _84COL, _24COL).rgb) {
        col.rgb = right_leg_lower.rgb;
    } else if (col.rgb == vec3(_138COL, _218COL, _140COL).rgb) {
        col.rgb = right_arm.rgb;
    } else if (col.rgb == vec3(_46COL, _169COL, _151COL).rgb) {
        col.rgb = right_hand.rgb;
    } else if (col.rgb == vec3(1.0, _230COL, _140COL).rgb) {
        col.rgb = left_arm.rgb;
    } else if (col.rgb == vec3(1.0, _160COL, _112COL).rgb) {
        col.rgb = left_hand.rgb;
    } else if (col.rgb == vec3(_128COL, _128COL, 0.0)) {
        col.rgb = company_marks.rgb;
    } else if (col.rgb == vec3(0.0, 1.0, 1.0)) {
        col.rgb = weapon_primary.rgb;
    } else if (col.rgb == vec3(1.0, 0.0, 1.0)) {
        col.rgb = weapon_secondary.rgb;
    }

    if (col_orig.rgb != col.rgb) {
        if (col_orig.a == _128COL){
            col.rgb = light_or_dark(col.rgb, 1.2);
            col.a = 1.0;
        } else if (col_orig.a == _60COL) {
            col.rgb = light_or_dark(col.rgb, 1.4);
            col.a = 1.0;
        } else if (col_orig.a == _215COL) {
            col.rgb = light_or_dark(col.rgb,0.6);
            col.a = 1.0;
        } else if (col_orig.a == _160COL) {
            col.rgb = light_or_dark(col.rgb, 0.8);
            col.a = 1.0;
        }
    }

    const vec3 robes_colour_base = vec3(201.0 / 255.0, 178.0 / 255.0, 147.0 / 255.0);
    const vec3 robes_highlight = vec3(230.0 / 255.0, 203.0 / 255.0, 168.0 / 255.0);
    const vec3 robes_darkness = vec3(189.0 / 255.0, 167.0 / 255.0, 138.0 / 255.0);
    const vec3 robes_colour_base_2 = vec3(169.0 / 255.0, 150.0 / 255.0, 123.0 / 255.0);
    const vec3 robes_highlight_2 = vec3(186.0 / 255.0, 165.0 / 255.0, 135.0 / 255.0);
    const vec3 robes_darkness_2 = vec3(148.0 / 255.0, 132.0 / 255.0, 108.0 / 255.0);
    if (col.rgb == robes_colour_base.rgb || col.rgb == robes_colour_base_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace , 1.0).rgb;
    } else if (col.rgb == robes_highlight.rgb || col.rgb == robes_highlight_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace , 1.25).rgb;
    //col.rgb = mix(robes_highlight.rgb, robes_colour_replace.rgb, 0.25);
    } else if (col.rgb == robes_darkness.rgb || col.rgb == robes_darkness_2.rgb) {
    //col.rgb = vec3(col.r*0.8, col.g*0.8, col.b*0.8).rgb;
    //col.rgb = robes_colour_replace.rgb;
    //col.rgb = mix(robes_darkness.rbg, robes_colour_replace.rgb, 0.25);
        col.rgb = light_or_dark(robes_colour_replace , 0.75).rgb;
    }

    gl_FragColor = v_vColour * col;
}
