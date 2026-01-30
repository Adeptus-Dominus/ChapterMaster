if ((stage == 1) || (stage == 2)) {
    draw_set_alpha(tim1);
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(fnt_cul_18);

    var hi;
    tx = legal_text;

    hi = string_height_ext(string_hash_to_newline(legal_text), -1, 900);
    draw_text_ext(room_width / 2, (900 - hi) / 2, string_hash_to_newline(legal_text), -1, 900);

    draw_set_alpha(1);
}

draw_set_alpha(1);
if (stage == 3) {
    scr_image("title_splash", 0, 0, 0, room_width, room_height);
    // draw_sprite_stretched(spr_new_mm,0,0,0,room_width,room_height);
}

if (tim3 > 0) {
    draw_set_alpha(tim3 / 60);
    draw_set_color(0);
    draw_rectangle(0, 0, 2000, 2000, 0);
    draw_set_alpha(1);
}

exit;

action_color(51712);
