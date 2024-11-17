
if (obj_main_menu.stage>2){
    var _build_date_line = $"Build: {global.build_date}";
    var _version_line = $"Version: {global.game_version}";
        
    draw_set_alpha(0.6);
    draw_set_font(fnt_cul_14);
    draw_set_color(c_gray);
    draw_set_halign(fa_right);
    draw_text(1598, 858, _version_line);
    draw_text(1598, 878, _build_date_line);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}



