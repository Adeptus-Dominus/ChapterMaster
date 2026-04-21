draw_set_color(0);
draw_set_font(fnt_40k_30b);
draw_set_halign(fa_center);

draw_text(room_width / 2, 5, string_hash_to_newline(string(fps) + "#SM:" + string(instance_number(obj_marine) * 10) + "  Orks:" + string(instance_number(obj_ork) * 20)));
