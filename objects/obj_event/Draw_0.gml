var xx, yy, ii;
xx = __view_get(e__VW.XView, 0) + 317;
yy = __view_get(e__VW.YView, 0) + 144;
ii = 0;

draw_set_alpha(fade_alpha);

// BG
draw_sprite(spr_popup_event, 0, xx, yy);
draw_sprite(spr_popup_event, 1, xx, yy);

// Draw avatars here
var x5, y5;
x5 = xx + 15 - 120;
y5 = yy + 482;

ii = 0;

draw_set_color(0);
draw_set_font(fnt_40k_30b);
draw_set_halign(fa_center);
// draw_text(view_xview[0]+800,view_yview[0]+165,string(obj_controller.fest_type)+"#"+string(obj_controller.fest_display)+"] "+string(obj_controller.fest_display_tags));
draw_text(__view_get(e__VW.XView, 0) + 800, __view_get(e__VW.YView, 0) + 165, string_hash_to_newline(string(obj_controller.fest_type)));

if (avatars > 0) {
    if (shader_is_compiled(sReplaceColor)) {
        shader_set(sReplaceColor);

        shader_set_uniform_f_array(colour_to_find1, body_colour_find);
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace);
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find);
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace);
        shader_set_uniform_f_array(colour_to_find3, pauldron_colour_find);
        shader_set_uniform_f_array(colour_to_set3, pauldron_colour_replace);
        shader_set_uniform_f_array(colour_to_find4, lens_colour_find);
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace);
        shader_set_uniform_f_array(colour_to_find5, trim_colour_find);
        shader_set_uniform_f_array(colour_to_set5, trim_colour_replace);
        shader_set_uniform_f_array(colour_to_find6, pauldron2_colour_find);
        shader_set_uniform_f_array(colour_to_set6, pauldron2_colour_replace);
        shader_set_uniform_f_array(colour_to_find7, weapon_colour_find);
        shader_set_uniform_f_array(colour_to_set7, weapon_colour_replace);
    }

    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);
    draw_set_color(c_black);

    repeat (8) {
        ii += 1;
        x5 += 120;
        if (avatar_name[ii] != "") {
            // draw_sprite(spr_popup_event_avatar,avatar_image[ii],x5,y5);
            scr_image("event", avatar_image[ii], x5, y5, 97, 95);
            draw_text_transformed(x5 + 47, y5 + 99, string_hash_to_newline(string(avatar_name[ii])), 0.75, 1, 0);
            // draw_text(x5+45,y5+100,string(avatar_name[ii])+"#"+string(avatar_rank[ii]));
        }
    }

    shader_reset();
}

draw_set_color(c_black);
draw_rectangle(xx + 25, yy + 102, xx + 940, yy + 106, 1);
draw_set_color(c_blue);
draw_rectangle(xx + 25, yy + 102, xx + 25 + ((time_at / time_max) * 915), yy + 106, 0);

draw_set_halign(fa_left);
draw_set_font(fnt_40k_14);

if (exit_fade >= 0) {
    var ealpha;
    ealpha = exit_fade / 30;
    draw_set_alpha(min(fade_alpha, ealpha));

    if (exit_fade < 30) {
        draw_sprite(spr_help_exit, 0, __view_get(e__VW.XView, 0) + 1238, __view_get(e__VW.YView, 0) + 200);
    }
    if (exit_fade >= 30) {
        draw_set_alpha(min(fade_alpha, 1));
        if (scr_hit(__view_get(e__VW.XView, 0) + 1238, __view_get(e__VW.YView, 0) + 200, __view_get(e__VW.XView, 0) + 1271, __view_get(e__VW.YView, 0) + 233) == false) {
            draw_sprite(spr_help_exit, 0, __view_get(e__VW.XView, 0) + 1238, __view_get(e__VW.YView, 0) + 200);
        }
        if (scr_hit(__view_get(e__VW.XView, 0) + 1238, __view_get(e__VW.YView, 0) + 200, __view_get(e__VW.XView, 0) + 1271, __view_get(e__VW.YView, 0) + 233) == true) {
            draw_sprite(spr_help_exit, 1, __view_get(e__VW.XView, 0) + 1238, __view_get(e__VW.YView, 0) + 200);
            if (mouse_button_clicked() && (closing == false)) {
                closing = true;
                fading = -1;
            }
        }
    }
    draw_set_alpha(1);
}

draw_set_color(c_gray);
draw_set_alpha(fade_alpha);
ii = 0;
y5 = yy + 120 - 21;
repeat (17) {
    y5 += 21;
    ii += 1;
    draw_text_ext(xx + 25, y5, string_hash_to_newline(string(line[ii])), -1, 916);
}
draw_set_alpha(1);
