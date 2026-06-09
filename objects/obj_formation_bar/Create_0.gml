dragging = false;
rel_mousex = 0;
rel_mousey = 0;
old_x = 0;
old_y = 0;

unit_type = "";
unit_id = 0;

size = 0;
col_parent = 0;
col_target = 0;
above_neighbor = 0;
nearest_col = 0;
nobar = false;

height = 0;
width = 0;
text_xscale = 1.25;
image_speed = 0;

tooltip = "";
tooltip2 = "";

bar_hit = function(){
	if (scr_hit_object()){
	    obj_cursor.image_index = 3;
	    draw_set_alpha(1);
	    draw_set_color(c_gray);
	    draw_set_font(fnt_40k_30b);
	    draw_set_halign(fa_center);
	    draw_text_transformed(1398, 213, string(tooltip), 0.75, 0.75, 0);

	    draw_set_halign(fa_left);
	    draw_set_font(fnt_40k_14);
	    draw_text_ext(1227, 565, string(tooltip2), -1, 323);

		draw_set_alpha(1);
		draw_set_color(0);
		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);

	    // draw_sprite(spr_formation_splash,too_img,xx+1271,yy+252);
		// unit_id-1 because reasons, otherwise sprites are wrong
	    scr_image("formation", unit_id-1, 1271, 252, 239, 297);

	    init_drag();
	}
}

init_drag = function(){
	if (mouse_check_button_pressed(mb_left)){
	    if ((obj_cursor.dragging == 0) && (obj_controller.cooldown <= 0)) {
	        obj_cursor.dragging = 1;
	        dragging = true;
	        obj_controller.cooldown = 9999;
	        obj_controller.click = 1;

	        // save crap
	        rel_mousex = x - mouse_consts[0];
	        rel_mousey = y - mouse_consts[1] - 1000;
	        old_x = x;
	        old_y = y;

	        // Establish drop areas
	        /*with(obj_temp8){instance_destroy();}
	        with(obj_formation_bar){
	            if (y<=view_yview[0]+230) then instance_create(x,y,obj_temp8);
	        }*/
	    }
	}
}




drag_logic = function(){
    if (mouse_check_button(mb_left)){
        x = mouse_consts[0] + rel_mousex;
        y = mouse_consts[1] + rel_mousey;
        obj_cursor.image_index = 3;
        col_target = instance_nearest(x, 224, obj_temp8);
        nearest_col = instance_nearest(col_target.x, col_target.y, obj_formation_bar);
        nobar = false;
        if (point_distance(col_target.x, col_target.y, nearest_col.x, nearest_col.y) > 2) {
            nobar = true;
        }
    } else {
        dragging = false;
	    rel_mousex = 0;
	    rel_mousey = 0;
	    old_x = 0;
	    old_y = 0;
	    col_parent = 0;
	    col_target = 0;
	    above_neighbor = 0;
	    nearest_col = 0;
    }
}

mouse_release = function(){
	if (!mouse_check_button_released(mb_left)){
		return;
	}

	var mah_target;
	mah_target = 0;
	/*if (dragging=true) and (nobar=true) then mah_target=col_target;
	if (dragging=true) and (nobar=false) then mah_target=nearest_col;*/

	mah_target = col_target;

	if ((dragging == true) && instance_exists(mah_target)) {
	    if (mah_target.col_parent == col_parent) {
	        obj_controller.click = 1;
	        obj_controller.cooldown = 20;
	        x = old_x;
	        y = old_y;
	        rel_mousex = 0;
	        rel_mousey = 0;
	        old_x = 0;
	        old_y = 0;
	        col_target = 0;
	        nearest_col = 0;
	        nobar = false;
	        obj_cursor.dragging = 0;
	        obj_cursor.image_index = 0;
	        dragging = false;
	        exit;
	    }
	}

	if ((dragging == true) && instance_exists(mah_target)) {
	    if ((x >= mah_target.x - 5) && (x <= mah_target.x + 42) && (mouse_consts[1] >= 222) && (mouse_consts[1] <= 688)) {
	        var himcol, te;
	        himcol = mah_target.col_parent;
	        te = 0;
	        te = 4800 + himcol;
	        nexti = false;

	        if (obj_controller.temp[te] + size <= 10) {
	            obj_controller.temp[4800 + col_parent] -= size;
	            obj_controller.click = 1;
	            obj_controller.cooldown = 20;
	            if (unit_id == 1) {
	                obj_controller.bat_comm_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 2) {
	                obj_controller.bat_hono_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 3) {
	                obj_controller.bat_libr_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 4) {
	                obj_controller.bat_tech_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 5) {
	                obj_controller.bat_term_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 6) {
	                obj_controller.bat_vete_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 7) {
	                obj_controller.bat_tact_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 8) {
	                obj_controller.bat_deva_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 9) {
	                obj_controller.bat_assa_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 10) {
	                obj_controller.bat_scou_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 11) {
	                obj_controller.bat_drea_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 12) {
	                obj_controller.bat_hire_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 13) {
	                obj_controller.bat_rhin_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 14) {
	                obj_controller.bat_pred_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 15) {
	                obj_controller.bat_landraid_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 16) {
	                obj_controller.bat_landspee_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            if (unit_id == 17) {
	                obj_controller.bat_whirl_for[obj_controller.formating] = mah_target.col_parent;
	            }
	            obj_cursor.dragging = 0;
	            obj_cursor.image_index = 0;

	            // show_message("-> slot "+string(mah_target.col_parent)+", now "+string(obj_controller.temp[te]+size)+"/10 full, old slot is "+string(obj_controller.temp[4800+col_parent])+"/10");

	            with (obj_temp8) {
	                instance_destroy();
	            }
	            with (obj_controller) {
	                scr_ui_formation_bars();
	            }
	            exit;
	        }
	        if (obj_controller.temp[te] + size > 10) {
	            dragging = false;
	            x = old_x;
	            y = old_y;
	            obj_controller.cooldown = 20;
	            obj_cursor.dragging = 0;
	            obj_cursor.image_index = 0;
	            if ((global.settings.master_volume > 0) && (global.settings.sfx_volume > 0)) {
	                audio_play_sound(snd_error, -80, false);
	            }
	        }
	    }
	    if (instance_exists(mah_target)) {
	        if ((x < mah_target.x - 5) || (x > mah_target.x + 42) || ( 222) || (mouse_consts[1] >  688)) {
	            dragging = false;
	            x = old_x;
	            y = old_y;
	            obj_controller.cooldown = 20;
	            obj_cursor.dragging = 0;
	            obj_cursor.image_index = 0;
	            if ((global.settings.master_volume > 0) && (global.settings.sfx_volume > 0)) {
	                audio_play_sound(snd_error, -80, false);
	            }
	        }
	    }
	}

	/* */
	/*  */

}

