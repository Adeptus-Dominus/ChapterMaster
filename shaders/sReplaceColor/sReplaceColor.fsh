uniform vec3 f_Colour1;
uniform vec3 f_Colour2;
uniform vec3 f_Colour3;
uniform vec3 f_Colour4;
uniform vec3 f_Colour5;
uniform vec3 f_Colour6;
uniform vec3 f_Colour7;

uniform vec3 f_Replace1;
uniform vec3 f_Replace2;
uniform vec3 f_Replace3;
uniform vec3 f_Replace4;
uniform vec3 f_Replace5;
uniform vec3 f_Replace6;
uniform vec3 f_Replace7;

uniform vec3 robes_colour_replace;
uniform vec3 helm_replace;
uniform vec3 helm_second_replace;
uniform vec3 helm_lense_replace;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int u_blend_modes;
uniform sampler2D background_texture;
uniform sampler2D armour_texture;

vec3 light_or_dark(vec3 m_colour, float shade) {
  return vec3((m_colour.r * shade) + 0.01, m_colour.g * shade, m_colour.b * shade);
}

void main() {
    const vec3 robes_colour_base = vec3(201.0 / 255.0, 178.0 / 255.0, 147.0 / 255.0);
    const vec3 robes_highlight = vec3(230.0 / 255.0, 203.0 / 255.0, 168.0 / 255.0);
    const vec3 robes_darkness = vec3(189.0 / 255.0, 167.0 / 255.0, 138.0 / 255.0);
    const vec3 robes_colour_base_2 = vec3(169.0 / 255.0, 150.0 / 255.0, 123.0 / 255.0);
    const vec3 robes_highlight_2 = vec3(186.0 / 255.0, 165.0 / 255.0, 135.0 / 255.0);
    const vec3 robes_darkness_2 = vec3(148.0 / 255.0, 132.0 / 255.0, 108.0 / 255.0);

    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
    if (u_blend_modes == 3 && (col.rgb == f_Colour1.rgb || col.rgb == f_Colour2.rgb)){
        vec4 background = texture2D(background_texture, v_vTexcoord);
        if (background.rgb == helm_replace.rgb || background.rgb == helm_second_replace.rgb || helm_lense_replace.rgb == helm_replace.rgb) {
            col.rgb = background.rgb;
        }
    } else if (col.rgb == f_Colour1.rgb && u_blend_modes != 2 && u_blend_modes != 3) {
        col.rgb = f_Replace1.rgb;
    } else if (col.rgb == f_Replace1.rgb && u_blend_modes == 2) {//draw textured armour
        vec2 i = vec2(5.0 * v_vTexcoord.x, 5.0 * v_vTexcoord.y);
        while (i.x > 1.0){
            i.x -= 1.0;
        }
        while (i.y > 1.0) {
            i.y -= 1.0;
        }
        vec4 armour_texture_col = texture2D(armour_texture, i);
        col.rgb = armour_texture_col.rgb;
    }

    if (col.rgb == f_Colour2.rgb) {
        col.rgb = f_Replace2.rgb;
    } else if (col.rgb == f_Colour3.rgb) {
        col.rgb = f_Replace3.rgb;
    } else if (col.rgb == f_Colour4.rgb) {
        col.rgb = f_Replace4.rgb;
    } else if (col.rgb == f_Colour5.rgb) {
        col.rgb = f_Replace5.rgb;
    } else if (col.rgb == f_Colour6.rgb) {
        col.rgb = f_Replace6.rgb;
    } else if (col.rgb == f_Colour7.rgb) {
        col.rgb = f_Replace7.rgb;
    } else if (col.rgb == robes_colour_base.rgb || col.rgb == robes_colour_base_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace, 1.0).rgb;
    } else if (col.rgb == robes_highlight.rgb || col.rgb == robes_highlight_2.rgb) {
        col.rgb = light_or_dark(robes_colour_replace, 1.25).rgb;
        //col.rgb = mix(robes_highlight.rgb, robes_colour_replace.rgb, 0.25);
    } else if (col.rgb == robes_darkness.rgb || col.rgb == robes_darkness_2.rgb) {
        //col.rgb = vec3(col.r*0.8, col.g*0.8, col.b*0.8).rgb;
        //col.rgb = robes_colour_replace.rgb;
        //col.rgb = mix(robes_darkness.rbg, robes_colour_replace.rgb, 0.25);
        col.rgb = light_or_dark(robes_colour_replace, 0.75).rgb;
    }

    if (u_blend_modes == 1) {
        vec3 robe = light_or_dark(robes_colour_replace, 1.0).rgb;
        vec3 robe_light = light_or_dark(robes_colour_replace, 1.25).rgb;
        vec3 robe_dark = light_or_dark(robes_colour_replace, 0.75).rgb;

        vec4 background_col = texture2D(background_texture, v_vTexcoord);

        if (background_col.rgb == robe.rgb) {
            col.a = 0.0;
        } else if (background_col.rgb == robe_light.rgb) {
            col.a = 0.0;
        } else if (background_col.rgb == robe_dark.rgb) {
            col.a = 0.0;
        } else if ((background_col.rgb != f_Replace1.rgb) && (background_col.rgb != f_Replace2.rgb) && (background_col.rgb != f_Replace3.rgb) && background_col.a > 0.0 ) {
            col.a = 0.0;
        }
    }
    gl_FragColor = v_vColour * col;
}
