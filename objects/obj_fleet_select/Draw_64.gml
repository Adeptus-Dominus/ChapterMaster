//TODO centralise draw logi
try {
	if (!obj_controller.zoomed) {
		var zm = 1, tit = "", mnz = 0;

		//if (fleet_minimized=0){
		//    draw_set_color(c_black);
		//    draw_rectangle(__view_get( e__VW.XView, 0 )+44,__view_get( e__VW.YView, 0 )+110,__view_get( e__VW.XView, 0 )+267,__view_get( e__VW.YView, 0 )+110+void_hei,0);
		//    draw_set_color(c_gray);
		//    draw_rectangle(__view_get( e__VW.XView, 0 )+44,__view_get( e__VW.YView, 0 )+110,__view_get( e__VW.XView, 0 )+267,__view_get( e__VW.YView, 0 )+110+void_hei,1);
		//}
		draw_set_color(c_gray);

		fleet_min_button = "-";
		if (fleet_minimized || screen_expansion < 20) {
			fleet_min_button = "+";
			selection_window.draw_cut(60, 110, 0.35, 0.8, screen_expansion * 5);
			if (fleet_minimized && screen_expansion > 1) {
				screen_expansion--;
			} else if (!fleet_minimized && screen_expansion < 20) {
				screen_expansion++;
			}
		} else {
			selection_window.draw(60, 110, 0.35, 0.8);
		}
		var xx = selection_window.XX;
		var yy = selection_window.YY;
		var center_draw = xx + (selection_window.width / 2);
		var width = selection_window.width;
		draw_set_halign(fa_center);
		draw_text(center_draw, yy + 50, string_hash_to_newline(string(global.chapter_name) + " Fleet"));
		draw_set_halign(fa_left);

		draw_set_color(c_gray);
		//draw_rectangle(xx+18+void_wid,yy+116,xx+36+void_wid,yy+134,0);

		draw_set_color(c_red);

		draw_set_color(c_gray);
		draw_line(xx + 10, yy + 75, xx + width - 10, yy + 75);
		if (point_and_click(draw_unit_buttons([xx + 25, yy + 40], fleet_min_button, [1, 1], c_red))) {
			if (fleet_minimized) {
				screen_expansion--;
				fleet_minimized = false;
			} else {
				screen_expansion++;
				fleet_minimized = true;
			}
		}
	}
} catch (_exception) {
	handle_exception(_exception);
	instance_destroy();
}
