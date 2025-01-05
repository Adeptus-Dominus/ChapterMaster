try {
	if (instance_number(obj_ncombat) || instance_number(obj_popup)) {
		exit;
	}

	w = 660;
	h = 520;
	// Center of the screen
	//setup
	var _x_center = (display_get_gui_width() / 2) - (w / 2);
	var _y_center = (display_get_gui_height() / 2) - (h / 2);
	//draw main_slate
	if (purge != DropType.PurgeSelect && (local_content_slate.XX <= _x_center - local_content_slate.width)) {
		main_slate.inside_method = drop_select_draw;
		main_slate.draw(_x_center, _y_center, (660 / 860), (520 / 850));
	}

	//left hand slate
	local_content_slate.inside_method = function() {
		var _xx = local_content_slate.XX;
		var _yy = local_content_slate.YY + 40;
		var _width = local_content_slate.width;
		var _heigth = local_content_slate.height;
		if (purge == 0) {
			draw_set_halign(fa_left);
			draw_text_ext(_xx + 15, _yy, roster.roster_local_string, -1, local_content_slate.width - 30);
			draw_text_ext(_xx + 15.1, _yy + 0.1, roster.roster_local_string, -1, local_content_slate.width - 30);
		}
		if (purge != DropType.RaidAttack) {
			if (purge == DropType.PurgeSelect) {
				draw_set_halign(fa_center);
				draw_set_font(fnt_40k_30b);

				draw_set_color(c_gray);
				var _exit = draw_unit_buttons([_xx + (_width / 2) - 40, 559], "Cancel");
				if (point_and_click(_exit)) {
					instance_destroy();
				}
			}
			var _xx = local_content_slate.XX;

			/*if (instance_exists(p_target)) {
                if (p_target.p_type[planet_number] = "Shrine") then nup = true;
            }
            */
			// 89,31
			draw_set_halign(fa_left);
			for (var i = 0; i < array_length(purge_options); i++) {
				var _purge_button = purge_options[i];
				_purge_button.x1 = _xx + 10;
				_purge_button.width = local_content_slate.width - 20;
				_purge_button.draw();
				if (_purge_button.clicked()) {
					purge_score = 0;
					purge = _purge_button.purge_type;
				}
			}
		}
	};

	draw_set_halign(fa_center);
	if (purge == DropType.RaidAttack) {
		local_content_slate.draw(_x_center - local_content_slate.width, _y_center, (300 / 860), (520 / 850));
	} else if (purge == 1) {
		local_content_slate.draw((camera_width / 2) - (local_content_slate.width / 2), _y_center, (300 / 860), (520 / 850));
	} else {
		if (local_content_slate.XX > _x_center - local_content_slate.width) {
			var _draw_x = max(local_content_slate.XX - 15, _x_center - local_content_slate.width);
			local_content_slate.draw(_draw_x, _y_center, (300 / 860), (520 / 850));
		} else {
			local_content_slate.draw(local_content_slate.XX, _y_center, (300 / 860), (520 / 850));
		}
	}
	draw_set_halign(fa_center);
	draw_set_font(fnt_40k_14b);
	roster_slate.inside_method = function() {
		var _xx = roster_slate.XX + (roster_slate.width / 2);
		var _yy = roster_slate.YY + 40;
		if (purge == 0) {
			draw_text_transformed(_xx, _yy, "Battle Roster", 2, 2, 0);
			_yy += 30;
			draw_text_ext(_xx, _yy, roster.roster_string, -1, roster_slate.width - 30);
			draw_text_ext(_xx + 0.1, _yy + 0.1, roster.roster_string, -1, roster_slate.width - 30);
		} else if (purge > DropType.PurgeSelect) {
			draw_text_transformed(_xx, _yy, "Purge Insight", 2, 2, 0);
			_yy += 30;
			var hers, influ, poppy;
			var hers = p_target.p_heresy[planet_number] + p_target.p_heresy_secret[planet_number];
			var influ = p_target.p_influence[planet_number];
			if (p_target.p_large[planet_number] == 1) {
				poppy = string(p_target.p_population[planet_number]) + "B";
			}
			if (p_target.p_large[planet_number] == 0) {
				poppy = string(scr_display_number(p_target.p_population[planet_number]));
			}
			draw_text(_xx + 14, _yy + 10, $"Heresy: {max(hers, influ[eFACTION.Tau])}%");
			draw_text(_xx + 14, _yy + 20, $"Population: {poppy}");
		} else if (purge == DropType.PurgeSelect) {
			draw_text_transformed(_xx, _yy, "Purge", 2, 2, 0);
			_yy += 30;
			for (var i = 0; i < array_length(purge_options); i++) {
				if (purge_options[i].hover()) {
					draw_text_ext(_xx, _yy, purge_options[i].description, -1, roster_slate.width - 30);
				}
			}
		}
	};
	var _draw_x = _x_center + main_slate.width;
	var _draw_y = _y_center;
	if (purge > DropType.PurgeSelect) {
		if (roster_slate.XX < _x_center + 660) {
			var _draw_x = min(roster_slate.XX + 15, _x_center + 660);
		} else {
			_draw_x = roster_slate.XX;
		}
	} else if (purge == DropType.PurgeSelect) {
		_draw_x = local_content_slate.XX + local_content_slate.width;
	}

	roster_slate.draw(_draw_x, _draw_y, (300 / 860), (520 / 850));
} catch (_exception) {
	handle_exception(_exception);
    instance_destroy();
}
