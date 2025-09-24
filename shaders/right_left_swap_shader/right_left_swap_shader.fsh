//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec3 remapRightToLeft(vec3 col) {
    const float _20COL = 20.0 / 255.0;
    const float _24COL = 24.0 / 255.0;
    const float _46COL = 46.0 / 255.0;
    const float _60COL = 60.0 / 255.0;
    const float _64COL = 64.0 / 255.0;
    const float _84COL = 84.0 / 255.0;
    const float _104COL = 104.0 / 255.0;
    const float _112COL = 112.0 / 255.0;
    const float _127_25COL = 127.25 / 255.0;
    const float _128COL = 128.0 / 255.0;
    const float _128_75COL = 128.75 / 255.0;
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
    // === Right → Left body mapping ===
    if (col == vec3(0.0, 0.0, 1.0)) {            // right_head
        return vec3(0.0, 0.0, _128COL);          // left_head
    }
    else if (col == vec3(_181COL, 0.0, 1.0)) {   // right_backpack
        return vec3(_104COL, 0.0, _168COL);      // left_backpack
    }
    else if (col == vec3(_64COL, _128COL, 1.0)) { // right_muzzle
        return vec3(_128COL, _64COL, 1.0);       // left_muzzle
    }
    else if (col == vec3(1.0, _20COL, _147COL)) { // right_chest
        return vec3(_128COL, 0.0, _128COL);      // left_chest
    }
    else if (col == vec3(0.0, _128COL, _128COL)) { // right_trim
        return vec3(1.0, _128COL, 0.0);          // left_trim
    }
    else if (col == vec3(1.0, 1.0, 1.0)) {       // right_pauldron
        return vec3(1.0, 1.0, 0.0);              // left_pauldron
    }
    else if (col == vec3(0.0, _128COL, 0.0)) {   // right_leg_upper
        return vec3(1.0, _112COL, _170COL);      // left_leg_upper
    }
    else if (col == vec3(_214COL, _194COL, 1.0)) { // right_leg_knee
        return vec3(1.0, 0.0, 0.0);              // left_leg_knee
    }
    else if (col == vec3(_165COL, _84COL, _24COL)) { // right_leg_lower
        return vec3(_128COL, 0.0, 0.0);          // left_leg_lower
    }
    else if (col == vec3(_138COL, _218COL, _140COL)) { // right_arm
        return vec3(1.0, _230COL, _140COL);      // left_arm
    }
    else if (col == vec3(_46COL, _169COL, _151COL)) { // right_hand
        return vec3(1.0, _160COL, _112COL);      // left_hand
    }

    // If not a right-side color, just return original
    return col;
}

void main() {
    vec4 col_orig = texture2D(gm_BaseTexture, v_vTexcoord);

    vec4 col_orig = texture2D(gm_BaseTexture, v_vTexcoord);
    if (col_orig.rgba == vec4(0.0, 0.0, 0.0, 0.0)) {
        discard;
    }

    // Intel fix
    if (col_orig.r >= _127_25COL && col_orig.r <= _128_75COL) { col_orig.r = _128COL; }
    if (col_orig.g >= _127_25COL && col_orig.g <= _128_75COL) { col_orig.g = _128COL; }
    if (col_orig.b >= _127_25COL && col_orig.b <= _128_75COL) { col_orig.b = _128COL; }
    if (col_orig.a >= _127_25COL && col_orig.a <= _128_75COL) { col_orig.a = _128COL; }

    vec4 col = col_orig;
    col.rgb = remapRightToLeft(col.rgb);
    gl_FragColor = v_vColour * col;
}
