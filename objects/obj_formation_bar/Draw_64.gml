/*var tist;tist=true;
if (tist=true){
    if (nobar=true) then draw_set_alpha(0.5);
    draw_set_color(c_purple);draw_set_alpha(1);
    if (instance_exists(col_parent)) and (!instance_exists(col_target)){draw_line_width(mouse_x,mouse_y,col_parent._x1,col_parent._y1,2);}
    if (instance_exists(col_target)){draw_line_width(mouse_x,mouse_y,col_target._x1,col_target._y1,5);}
}*/ 

add_draw_return_values();

mouse_consts = return_mouse_consts();

draw_set_alpha(1);


var _x1 = x;
var _y1 = y;

if (dragging){
    _y1 += 1000
}

var max_hi = height - 4;
var actual_hi = 0;

actual_hi = string_width(unit_type) * text_xscale;
if (actual_hi > max_hi) {
    repeat (10) {
        actual_hi = string_width(unit_type) * text_xscale;
        if (actual_hi > max_hi) {
            text_xscale -= 0.05;
        }
    }
}

draw_sprite_ext(spr_formation_bars, image_index, _x1, _y1, image_xscale, image_yscale, 0, c_white, 1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed_outline(_x1 + (width / 2), _y1 + (height / 2), string(unit_type), text_xscale, text_xscale, 270, c_black, c_white);

bar_hit();

mouse_release();

if (dragging == true) {
    drag_logic();
}

if (dragging == false) {
    rel_mousex = 0;
    rel_mousey = 0;
    old_x = 0;
    old_y = 0;
    // col_parent deliberately NOT reset here. It is the bar's home bracket, assigned
    // once by init_combat_bars, and mouse_release needs it on drop: both for the
    // same-bracket snap-back check and for decrementing the source bracket's
    // occupancy (temp[4800 + col_parent]). Zeroing it every idle frame (upstream
    // commit 6730ae794) made every drop read and subtract from temp[4800], an
    // uninitialized slot outside the per-bracket 4801-4810 range: a hard crash when
    // that slot holds a string, and silent occupancy-count corruption (source
    // bracket never decremented) when it holds a number. Bug exists verbatim in
    // upstream main.
    col_target = 0;
    above_neighbor = 0;
    nearest_col = 0;
}

pop_draw_return_values();
/* */
/*  */
