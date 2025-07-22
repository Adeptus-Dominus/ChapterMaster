try {
	//TODO refactor this entire turd of a construct
	if (hide == true) {
		exit;
	}
	if (image == "debug") {
		size = 3;
	}

	var romanNumerals = scr_roman_numerals();
	var xx, yy;
	xx = __view_get(e__VW.XView, 0);
	yy = __view_get(e__VW.YView, 0);

	if (instance_exists(obj_fleet)) {
		exit;
	}

	if (type == POPUP_TYPE.FLEET_MOVE) {
		draw_set_font(fnt_large);
		draw_set_halign(fa_center);
		draw_set_color(38144);

		if (!obj_controller.zoomed) {
			draw_text_transformed(__view_get(e__VW.XView, 0) + 320, __view_get(e__VW.YView, 0) + 60, "SELECT DESTINATION", 0.5, 0.5, 0);
		} else {
			draw_text_transformed(room_width / 2, 60 * 3, "SELECT DESTINATION", 1.5, 1.5, 0);
		}

		draw_set_halign(fa_left);
	} else if (type == 10) {
		target_comp += 1;
		draw_set_color(0);
		draw_set_alpha(target_comp / 60);
		draw_rectangle(0, 0, room_width, room_height, 0);
		draw_set_alpha(1);
		exit;
	}

	var zoom = 0;
	if (instance_exists(obj_controller)) {
		zoom = obj_controller.zoomed;
	}
	if (((zoom == 0) && (type <= 4)) || (type == 98)) {
		var widd, image_bot, y_scale_mod;
		image_bot = 0;
		y_scale_mod = 1;

		if ((size == 0) || (size == 2)) {
			sprite_index = spr_popup_medium;
			image_alpha = 0;
			widd = sprite_width - 50;
			draw_sprite_ext(spr_popup_medium, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height) / 2), 1, y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 100;
				image_hei = 100;
			}
		} else if (size == 1) {
			sprite_index = spr_popup_small;
			image_alpha = 0;
			widd = sprite_width - 10;
			draw_sprite_ext(spr_popup_small, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height) / 2), 1, y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 150;
				image_hei = 150;
			}
		} else if (size == 3) {
			var draw_y_scale = y_scale;
			sprite_index = spr_popup_large;
			image_alpha = 0;
			widd = sprite_width - 50;
			if (image == "debug") {
				y_scale_mod = 1.5;
				draw_y_scale = y_scale * y_scale_mod;
			}
			draw_sprite_ext(spr_popup_large, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height * y_scale_mod) / 2), 1, draw_y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 200;
				image_hei = 200;
			}
		}

		if (image_wid > 0) {
			widd -= image_wid + 10;
		}

		var x1, y1;
		x1 = xx + ((1600 - sprite_width) / 2);
		y1 = yy + ((900 - sprite_height * y_scale_mod) / 2);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(38144);

		if (fancy_title == 1) {
			draw_set_font(fnt_fancy);
			if (type == 1) {
				draw_set_color(255);
			}
		}
		draw_text_transformed(x1 + (sprite_width / 2), y1 + (sprite_height * 0.07), string_hash_to_newline(string(title)), 1.1, 1.1, 0);
		// draw_text(xx+320.5,yy+123.5,string(title));

		draw_set_font(fnt_40k_14);
		draw_set_halign(fa_left);
		draw_set_color(38144);

		if (instance_exists(obj_turn_end)) {
			if (obj_turn_end.popups > 0) {
				draw_text(x1 + 20, y1 + (sprite_height * 0.07), string_hash_to_newline(string(obj_turn_end.current_popup) + "/" + string(obj_turn_end.popups)));
			}
		}
		if (image == "debug") {
			draw_text_ext(x1 + 20, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, sprite_width - 40);
		} else if (image == "") {
			if (size == 1) {
				draw_text_ext(x1 + 5, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			if (size != 1) {
				draw_text_ext(x1 + 25, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			str_h = string_height_ext(string_hash_to_newline(string(text)), -1, widd) + (sprite_height * 0.18);
		} else if (image != "") {
			if (size == 1) {
				draw_text_ext(x1 + 15 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			if (size != 1) {
				draw_text_ext(x1 + 35 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			str_h = string_height_ext(string_hash_to_newline(string(text)), -1, widd) + (sprite_height * 0.18);
		}

		// if (image!="") then draw_text_ext(x1+126+150,y1+152,string(text),-1,384-150);
		// if (text2!="") then draw_text_ext(x1+126,y1+309,string(text2),-1,384);
		// TODO change this into an array in a function (like romanNumerals does in here)
		var img = defualt_popup_image_index();


		if ((img != -1) && (image != "") && (image_wid > 0)) {
			var sh = 999;
			if (size == 1) {
				sh = 24;
				scr_image("popup", img, x1 + 5, y1 + sh + 24, image_wid, image_hei);
			}
			if (size >= 2) {
				sh = 24;
				scr_image("popup", img, x1 + 25, y1 + sh + 24, image_wid, image_hei);
			}

			image_bot = (sprite_height * 0.07) + image_hei + 5;
		}

		if ((option1 != "") && (string_count("Servitors and Skitarii", option1) == 0)) {
			var tox = "1. " + string(option1);
			if (option2 != "") {
				tox += "#2. " + string(option2);
			}
			if (option3 != "") {
				tox += "#3. " + string(option3);
			}

			var top = y1 + 0.5 + (sprite_height * 0.6);
			if (str_h != 0) {
				top = y1 + str_h + 20;
			}
			if (image != "") {
				top = max(top, y1 + image_bot);
			}

			draw_text_ext(x1 + 25.5, top, string_hash_to_newline("  Choices:"), -1, widd);
			draw_text_ext(x1 + 25, top + 0.5, string_hash_to_newline("  Choices:"), -1, widd);

			var sz = 0, sz2 = 0, oy = y1, t8 = 0;
			if (str_h != 0) {
				y1 += str_h + 20;
				y1 -= sprite_height * 0.6;
			}

			y1 = top;

			if (option1 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20, string_hash_to_newline("1. " + string(option1)), -1, widd);
			}

			sz = string_height_ext(string_hash_to_newline("1. " + string(option1)), -1, widd);
			if (option2 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20 + sz, string_hash_to_newline("2. " + string(option2)), -1, widd);
			}

			sz2 = string_height_ext(string_hash_to_newline("1. " + string(option1)), -1, widd);
			sz2 += string_height_ext(string_hash_to_newline("2. " + string(option2)), -1, widd);
			if (option3 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20 + sz2, string_hash_to_newline("3. " + string(option3)), -1, widd);
			}

			if (option1 != "") {
				t8 = (y1 + 20) + 5;
			}
			if (option2 != "") {
				t8 = (y1 + 20 + sz) + 5;
			}
			if (option3 == "") {
				t8 = (y1 + 20 + sz2 + string_height_ext(string_hash_to_newline("3. " + string(option3)), -1, widd)) + 5;
			}

			if ((option1 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("1. " + string(option1)), -1, widd)) && (mouse_y < y1 + 39)) {
				option1enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21);
				if (mouse_check_button(mb_left)) {
					press = 1;
				}
			} else {
				option1enter = false;
			}
			if ((option2 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21 + sz) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("2. " + string(option2)), -1, widd)) && (mouse_y < y1 + 39 + sz)) {
				option2enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21 + sz);
				if (mouse_check_button(mb_left)) {
					press = 2;
				}
			} else {
				option2enter = false;
			}
			if ((option3 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21 + sz2) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("3. " + string(option3)), -1, widd)) && (mouse_y < y1 + 39 + sz2)) {
				option3enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21 + sz2);
				if (mouse_check_button(mb_left)) {
					press = 3;
				}
			} else {
				option3enter = false;
			}
			if (image == "new_forge_master") {
				var new_master_image = false;
				if (pathway == "selection_options") {
					if (option1enter) {
						new_master_image = techs[charisma_pick].draw_unit_image();
						techs[charisma_pick].stat_display();
					} else if (option2enter) {
						new_master_image = techs[talent_pick].draw_unit_image();
						techs[talent_pick].stat_display();
					} else if (option3enter) {
						new_master_image = techs[experience_pick].draw_unit_image();
						techs[experience_pick].stat_display();
					}
					if (is_struct(new_master_image)) {
						new_master_image.draw(xx + 1208, yy + 210, true);
					}
				}
			}
			if (t8 < (oy + sprite_height)) {
				y_scale = t8 / (oy + sprite_height);
			}
			if (t8 > (oy + sprite_height)) {
				y_scale = t8 / (oy + sprite_height);
			}
		}
	}
	var xx, yy;
	xx = __view_get(e__VW.XView, 0);
	yy = __view_get(e__VW.YView, 0);


	if (type == "duel") {}
} catch (_exception) {
	handle_exception(_exception);
    instance_destroy();
}
