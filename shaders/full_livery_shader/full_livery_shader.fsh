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

// === SHADOW AUGMENT: new uniforms ===
uniform sampler2D shadow_texture;
uniform int use_shadow;
varying vec2 v_vShadowCoord;

// === Utility: RGB <-> HSV ===
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x*6.0 + vec3(0.0,4.0,2.0),
                              6.0) - 3.0) - 1.0,
                     0.0,
                     1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

// Shortest-path hue interpolation with clamp
float hueMixClamp(float fromHue, float toHue, float t, float maxShift) {
    // Compute shortest path delta
    float delta = mod((toHue - fromHue + 540.0), 360.0) - 180.0;
    
    // Clamp delta to maxShift (in degrees)
    if (delta > maxShift) delta = maxShift;
    if (delta < -maxShift) delta = -maxShift;

    return mod(fromHue + delta * t, 360.0);
}

vec3 light_or_dark(vec3 m_colour, float shade, float maxHueShift) {
    vec3 hsv = rgb2hsv(m_colour);

    float orig_brightness = max(m_colour.r, max(m_colour.g, m_colour.b));
    bool near_black = (orig_brightness < 0.15); // works for 35/255

    if (shade > 1.0) {
        float hue = hsv.x * 360.0;

        if (near_black) {
            // Near-black highlight: push toward green-blue (~180°), clamped
            hue = hueMixClamp(hue, 180.0, shade - 1.0, 180);
            hsv.z = clamp(hsv.z * shade, 0.0, 1.0);
            hsv.y = clamp(hsv.y * (2.0 - shade), 0.0, 1.0);
            hsv.x = hue / 360.0;

        } else {
            // Normal highlight: push toward yellow (60°), clamped
            hue = hueMixClamp(hue, 60.0, shade - 1.0, maxHueShift);
            hsv.z = clamp(hsv.z * shade, 0.0, 1.0);
            hsv.y = clamp(hsv.y * (2.0 - shade), 0.0, 1.0);
            hsv.x = hue / 360.0;
        }

    } else {
        // Shadow: push hue toward blue (240°), clamped
        float hue = hsv.x * 360.0;
        hue = hueMixClamp(hue, 240.0, 1.0 - shade, maxHueShift);
        hsv.x = hue / 360.0;

        hsv.z = clamp(hsv.z * shade, 0.0, 1.0);
        hsv.y = clamp(hsv.y * (1.0 + (1.0 - shade)), 0.0, 1.0);
    }

    vec3 rgb = hsv2rgb(hsv);

    if (!near_black) {
        float maxDelta = 0.05;
        if (m_colour.r < max(m_colour.g, m_colour.b)) rgb.r = min(rgb.r, max(rgb.g, rgb.b) + maxDelta);
        if (m_colour.g < max(m_colour.r, m_colour.b)) rgb.g = min(rgb.g, max(rgb.r, rgb.b) + maxDelta);
        if (m_colour.b < max(m_colour.r, m_colour.g)) rgb.b = min(rgb.b, max(rgb.r, rgb.g) + maxDelta);
    }

    if (near_black && shade > 1.0) {
        float maxRGB = max(rgb.r, max(rgb.g, rgb.b));
        rgb.b = max(rgb.b, maxRGB * 1.1);
    }

    return rgb;
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

    // === Existing replacement logic ===
    if (col.rgb == vec3(0.0, 0.0, _128COL).rgb) { col.rgb = left_head.rgb; }
    else if (col.rgb == vec3(_181COL, 0.0, 1.0).rgb) { col.rgb = right_backpack.rgb; }
    else if (col.rgb == vec3(_104COL, 0.0, _168COL).rgb) { col.rgb = left_backpack.rgb; }
    else if (col.rgb == vec3(0.0, 0.0, 1.0).rgb){ col.rgb = right_head.rgb; }
    else if (col.rgb == vec3(_128COL, _64COL, 1.0).rgb) { col.rgb = left_muzzle.rgb; }
    else if (col.rgb == vec3(_64COL, _128COL, 1.0).rgb) { col.rgb = right_muzzle.rgb; }
    else if (col.rgb == vec3(0.0, 1.0, 0.0).rgb) { col.rgb = eye_lense.rgb; }
    else if (col.rgb == vec3(1.0, _20COL, _147COL).rgb) { col.rgb = right_chest.rgb; }
    else if (col.rgb == vec3(_128COL, 0.0, _128COL).rgb) { col.rgb = left_chest.rgb; }
    else if (col.rgb == vec3(0.0, _128COL, _128COL).rgb) { col.rgb = right_trim.rgb; }
    else if (col.rgb == vec3(1.0, _128COL, 0.0).rgb) { col.rgb = left_trim.rgb; }
    else if (col.rgb == vec3(_135COL, _130COL, _188COL).rgb) { col.rgb = metallic_trim.rgb; }
    else if (col.rgb == vec3(1.0, 1.0, 1.0).rgb) { col.rgb = right_pauldron.rgb; }
    else if (col.rgb == vec3(1.0, 1.0, 0.0).rgb) { col.rgb = left_pauldron.rgb; }
    else if (col.rgb == vec3(0.0, _128COL, 0.0).rgb) { col.rgb = right_leg_upper.rgb; }
    else if (col.rgb == vec3(1.0, _112COL, _170COL).rgb) { col.rgb = left_leg_upper.rgb; }
    else if (col.rgb == vec3(1.0, 0.0, 0.0).rgb) { col.rgb = left_leg_knee.rgb; }
    else if (col.rgb == vec3(_128COL, 0.0, 0.0).rgb) { col.rgb = left_leg_lower.rgb; }
    else if (col.rgb == vec3(_214COL, _194COL, 1.0).rgb) { col.rgb = right_leg_knee.rgb; }
    else if (col.rgb == vec3(_165COL, _84COL, _24COL).rgb) { col.rgb = right_leg_lower.rgb; }
    else if (col.rgb == vec3(_138COL, _218COL, _140COL).rgb) { col.rgb = right_arm.rgb; }
    else if (col.rgb == vec3(_46COL, _169COL, _151COL).rgb) { col.rgb = right_hand.rgb; }
    else if (col.rgb == vec3(1.0, _230COL, _140COL).rgb) { col.rgb = left_arm.rgb; }
    else if (col.rgb == vec3(1.0, _160COL, _112COL).rgb) { col.rgb = left_hand.rgb; }
    else if (col.rgb == vec3(_128COL, _128COL, 0.0)) { col.rgb = company_marks.rgb; }
    else if (col.rgb == vec3(0.0, 1.0, 1.0)) { col.rgb = weapon_primary.rgb; }
    else if (col.rgb == vec3(1.0, 0.0, 1.0)) { col.rgb = weapon_secondary.rgb; }

    if (col_orig.rgb != col.rgb) {
        if (col_orig.a == _128COL){ col.rgb = light_or_dark(col.rgb, 1.2, 85.0); col.a = 1.0; }
        else if (col_orig.a == _60COL) { col.rgb = light_or_dark(col.rgb, 1.4, 85.0); col.a = 1.0; }
        else if (col_orig.a == _215COL) { col.rgb = light_or_dark(col.rgb,0.6, 85.0); col.a = 1.0; }
        else if (col_orig.a == _160COL) { col.rgb = light_or_dark(col.rgb, 0.8, 85.0); col.a = 1.0; }
    }

    const vec3 robes_colour_base = vec3(201.0 / 255.0, 178.0 / 255.0, 147.0 / 255.0);
    const vec3 robes_highlight = vec3(230.0 / 255.0, 203.0 / 255.0, 168.0 / 255.0);
    const vec3 robes_darkness = vec3(189.0 / 255.0, 167.0 / 255.0, 138.0 / 255.0);
    const vec3 robes_colour_base_2 = vec3(169.0 / 255.0, 150.0 / 255.0, 123.0 / 255.0);
    const vec3 robes_highlight_2 = vec3(186.0 / 255.0, 165.0 / 255.0, 135.0 / 255.0);
    const vec3 robes_darkness_2 = vec3(148.0 / 255.0, 132.0 / 255.0, 108.0 / 255.0);
    if (col.rgb == robes_colour_base.rgb || col.rgb == robes_colour_base_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace , 1.0,85.0).rgb;
    } else if (col.rgb == robes_highlight.rgb || col.rgb == robes_highlight_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace , 1.25,85.0).rgb;
    } else if (col.rgb == robes_darkness.rgb || col.rgb == robes_darkness_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace , 0.75,85.0).rgb;
    }

    // === SHADOW AUGMENT: artist-friendly highlight/shadow grading ===
    if (use_shadow == 1) {
        vec4 shadow_col = texture2D(shadow_texture, v_vShadowCoord);
        float intensity = shadow_col.r;

        // Remap: 0 = shadow, 0.5 = neutral, 1 = highlight
        float shadow_factor = 1.0 + (intensity - 0.5);

        col.rgb = light_or_dark(col.rgb, shadow_factor, 85.0);
    }

    gl_FragColor = v_vColour * col;
}
