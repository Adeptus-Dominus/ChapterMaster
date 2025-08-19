draw_self();

draw_set_color(CM_GREEN_COLOR);
draw_set_font(fnt_info);
draw_set_halign(fa_center);
draw_set_alpha(1);
draw_set_color(0);
draw_text(x,y,string_hash_to_newline(string(boarders-boarders_dead)));
draw_text(x-1,y-1,string_hash_to_newline(string(boarders-boarders_dead)));
draw_text(x+1,y+1,string_hash_to_newline(string(boarders-boarders_dead)));
draw_text(x+1,y,string_hash_to_newline(string(boarders-boarders_dead)));
draw_set_color(c_white);
draw_text(x,y,string_hash_to_newline(string(boarders-boarders_dead)));



