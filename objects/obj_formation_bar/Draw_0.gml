/*var tist;tist=true;
if (tist=true){
    if (nobar=true) then draw_set_alpha(0.5);
    draw_set_color(c_purple);draw_set_alpha(1);
    if (instance_exists(col_parent)) and (!instance_exists(col_target)){draw_line_width(mouse_x,mouse_y,col_parent.x,col_parent.y,2);}
    if (instance_exists(col_target)){draw_line_width(mouse_x,mouse_y,col_target.x,col_target.y,5);}
}*/ draw_set_alpha(1);

if (dragging == false) {
    draw_sprite_ext(spr_formation_bars, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
}
if (dragging == true) {
    draw_sprite_ext(spr_formation_bars, image_index, x, y + 1000, image_xscale, image_yscale, 0, c_white, 1);
}

draw_set_alpha(1);
draw_set_color(0);
draw_set_font(fnt_40k_14b);
draw_set_halign(fa_center);

var max_hi, actual_hi;
max_hi = height - 4;
actual_hi = 0;

actual_hi = string_width(string_hash_to_newline(unit_type)) * text_xscale;
if (actual_hi > max_hi) {
    repeat (10) {
        actual_hi = string_width(string_hash_to_newline(unit_type)) * text_xscale;
        if (actual_hi > max_hi) {
            text_xscale -= 0.05;
        }
    }
}

if (dragging == false) {
    draw_text_transformed(x + 28, y + (height / 2), string_hash_to_newline(string(unit_type)), text_xscale, text_xscale, 270);
}
if (dragging == true) {
    draw_text_transformed(x + 28, y + (height / 2) + 1000, string_hash_to_newline(string(unit_type)), text_xscale, text_xscale, 270);
}

/* */
/*  */
