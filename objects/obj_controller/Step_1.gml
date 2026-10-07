/// @description Insert description here
// You can write your code in this editor
//global.default_view_width = display_get_width();
//global.default_view_height = display_get_height();
camera_moved_this_turn = false;
map_scale = scr_map_scale();
star_scale = min(camera_get_view_width(view_camera[0]) / global.default_view_width, 2.4);
scale_mod = 1 / map_scale;
obj_cursor.image_xscale = 1;
obj_cursor.image_yscale = 1;

main_map_move_keys();
