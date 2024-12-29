/// @function scr_hit
/// @description Returns true if mouse is hovering on the specified rectangle area.
/// @returns {bool}
function scr_hit(x1=0, y1=0, x2=0, y2=0) {
	var mouse_consts = return_mouse_consts();
	if (is_array(x1)){
		return point_in_rectangle(mouse_consts[0],mouse_consts[1],x1[0],x1[1],x1[2],x1[3]);
	} else {
		return point_in_rectangle(mouse_consts[0],mouse_consts[1],x1, y1, x2, y2);
	}
	return false;

}

/// @function point_and_click
/// @description Returns true if left mouse button was clicked on the desired rectangle area.
/// @param {array} rect x1, y1, x2, y2 array.
/// @returns {bool}
function point_and_click(rect, cooldown = 60) {
	var controller_exist = instance_exists(obj_controller);
	var click_check = false;
	var mouse_consts = return_mouse_consts();
	var mouse_clicked = event_number==ev_gui ? device_mouse_check_button_pressed(0,mb_left) : mouse_check_button_pressed(mb_left);

	if (!mouse_clicked) {
		return false;
	}

	if (controller_exist && obj_controller.cooldown > 0) {
		show_debug_message("point_and_click: ignored click for cooldown, " + string(obj_controller.cooldown) + " steps remaining");
		show_debug_message($"{array_to_string_list(debug_get_callstack())}");
		return false;
	}

	var click_check = point_in_rectangle(mouse_consts[0], mouse_consts[1], rect[0], rect[1],rect[2], rect[3]);
	if (controller_exist && click_check && cooldown > 0) {
		show_debug_message("scr_click_left: clicked and set cooldown!");
		show_debug_message($"{array_to_string_list(debug_get_callstack())}");
		obj_controller.cooldown = cooldown * delta_time/1000000;
	}
	if(is_debug_overlay_open()){
		show_debug_message($"mouse coords x: {mouse_consts[0]} y: {mouse_consts[1]}")
	}
	return click_check;
}

function scr_click_left(cooldown = 60){
	var mouse_clicked = event_number==ev_gui ? device_mouse_check_button_pressed(0,mb_left) : mouse_check_button_pressed(mb_left);

	if (!mouse_clicked) {
		return false;
	}

	var controller_exist = instance_exists(obj_controller);

	if (controller_exist && obj_controller.cooldown > 0) {
		show_debug_message("scr_click_left: ignored click for cooldown, " + string(obj_controller.cooldown) + " steps remaining");
		show_debug_message($"{array_to_string_list(debug_get_callstack())}");
		return false;
	} else if (controller_exist && cooldown > 0) {
		show_debug_message("scr_click_left: clicked and set cooldown!");
		show_debug_message($"{array_to_string_list(debug_get_callstack())}");
		obj_controller.cooldown = cooldown * delta_time/1000000;
	}

	return mouse_clicked;
}

function return_mouse_consts(){
	if (event_number==ev_gui){
		var mouse_const_x = device_mouse_x_to_gui(0);
		var mouse_const_y = device_mouse_y_to_gui(0);
	} else {
		mouse_const_x = mouse_x;
		mouse_const_y = mouse_y;
	}
	return [mouse_const_x,mouse_const_y]
}
function mouse_distance_less(xx, yy, distance){
	var mouse_consts = return_mouse_consts();
	return (point_distance(xx,yy,mouse_consts[0],mouse_consts[1])<=distance)
}
function return_mouse_consts_tooltip(){
	var consts = return_mouse_consts();
	return [consts[0]+20, consts[1]]
}





