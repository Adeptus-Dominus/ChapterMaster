function scr_draw_management_unit(selected, yy = 0, xx = 0, draw = true, click_lock=false) {
    var assignment = "none";
    var _unit;
    var string_role = "";
    var health_string = "";
    var eventing = false;
    var jailed = false;
    var impossible = !is_struct(display_unit[selected]) && !is_array(display_unit[selected]);
    var is_man = false;
    if (man[selected] == "man" && is_struct(display_unit[selected])) {
        is_man = true;
        _unit = display_unit[selected];
        if (_unit.name() == "" || _unit.base_group == "none") {
            return "continue";
        }
        var _active_tags = array_length(manage_tags);
        if(_active_tags){
            var _valid_tag = false;
            if (!array_length(_unit.manage_tags)){
                _valid_tag = false;
            } else {
                for (var t = 0; t<array_length(_unit.manage_tags);t++){
                    if (array_contains(manage_tags, _unit.manage_tags[t])){
                        _valid_tag = true;
                        break;
                    }
                }
            }
            if (!_valid_tag){
                man_sel[selected] = 0;
                return "continue";
            }
        }
        var unit_specialist = is_specialist(_unit.role());
        var unit_location_string = "";
        if (_unit.in_jail()) {
            jailed = true;
            unit_location_string = "=Penitorium=";
        } else {
            var unit_location = _unit.marine_location();
            string_role = _unit.name_role();
            unit_specialism_option = false;
            //TODO make static to handle
            unit_location_string = string(ma_loc[selected]);
            if (_unit.controllable()){
                if (unit_location[0] == location_types.planet) {
                    unit_location_string = unit_location[2];
                    //get roman numeral for system planet
                    unit_location_string += scr_roman(unit_location[1]);
                } else if (unit_location[0] == location_types.ship) {
                    unit_location_string = obj_ini.ship[unit_location[1]];
                }
            } else {
                unit_location_string = ma_loc[selected];
            }
            assignment = _unit.assignment();
            if (assignment != "none") {
                unit_location_string += $"({assignment})";
            } else if ((fest_planet == 0) && (fest_sid > -1) && (fest_repeats > 0) && (ma_lid[selected] == fest_sid)) {
                unit_location_string = "=Event=";
                eventing = true;
            } else if ((fest_planet == 1) && (fest_wid > 0) && (fest_repeats > 0) && (ma_wid[selected] == fest_wid) && (ma_loc[selected] == fest_star)) {
                unit_location_string = "=Event=";
                eventing = true;
            }
        }
        if (draw) {
            health_string = $"{round((_unit.hp() / _unit.max_health()) * 100)}% HP";

            var exp_string = $"{round(ma_exp[selected])} EXP";

            ma_ar = "";
            ma_we1 = "";
            ma_we2 = "";
            ma_ge = "";
            ma_mb = "";
            ttt = 0;
            ar_ar = 0;
            ar_we1 = 0;
            ar_we2 = 0;
            ar_ge = 0;
            ar_mb = 0;
            //TODO handle recursively

            if (ma_armour[selected] != "") {
                ma_ar = gear_weapon_data("armour", _unit.armour(), "abbreviation");
                ma_ar = is_string(ma_ar) ? ma_ar : "";
            }
            if (ma_gear[selected] != "") {
                ma_ge = gear_weapon_data("gear", _unit.gear(), "abbreviation");
                ma_ge = is_string(ma_ge) ? ma_ge : "";
            }
            if (ma_mobi[selected] != "") {
                ma_mb = gear_weapon_data("mobility", _unit.mobility_item(), "abbreviation");
                ma_mb = is_string(ma_mb) ? ma_mb : "";
            }
            if (ma_wep1[selected] != "") {
                ma_we1 = gear_weapon_data("weapon", _unit.weapon_one(), "abbreviation");
                ma_we1 = is_string(ma_we1) ? ma_we1 : "";
            }
            if (ma_wep2[selected] != "") {
                ma_we2 = gear_weapon_data("weapon", _unit.weapon_two(), "abbreviation");
                ma_we2 = is_string(ma_we1) ? ma_we2 : "";
            }
        }
    } else if (man[selected] == "vehicle" && is_array(display_unit[selected]) && draw) {
        // string_role="v "+string(managing)+"."+string(ide[selected]);
        string_role = string(ma_role[selected]);
        unit_location_string = string(ma_loc[selected]);

        if (ma_wid[selected] != 0) {
            //numeral for vehicle planet
            unit_location_string += scr_roman(ma_wid[selected]);
        } else if (ma_lid[selected] > -1) {
            unit_location_string = obj_ini.ship[ma_lid[selected]];
        }
        health_string = string(round(ma_health[selected])) + "% HP";
        exp_string = "";
        // Need abbreviations here

        ma_ar = "";
        ma_we1 = "";
        ma_we2 = "";
        ma_ge = "";
        ma_mb = "";
        ttt = 0;
        ar_ar = 0;
        ar_we1 = 0;
        ar_we2 = 0;
        ar_ge = 0;
        ar_mb = 0;
        //TODO handle recursively
        if (ma_armour[selected] != "") {
            ma_ar = gear_weapon_data("weapon", ma_armour[selected], "abbreviation");
            ma_ar = is_string(ma_ar) ? ma_ar : "";
        }
        if (ma_gear[selected] != "") {
            ma_ge = gear_weapon_data("armour", ma_gear[selected], "abbreviation");
            ma_ge = is_string(ma_ge) ? ma_ge : "";
        }
        if (ma_mobi[selected] != "") {
            ma_mb = gear_weapon_data("gear", ma_mobi[selected], "abbreviation");
            ma_mb = is_string(ma_mb) ? ma_mb : "";
        }
        if (ma_wep1[selected] != "") {
            ma_we1 = gear_weapon_data("weapon", ma_wep1[selected], "abbreviation");
            ma_we1 = is_string(ma_we1) ? ma_we1 : "";
        }
        if (ma_wep2[selected] != "") {
            ma_we2 = gear_weapon_data("weapon", ma_wep2[selected], "abbreviation");
            ma_we2 = is_string(ma_we1) ? ma_we2 : "";
            // temp5=string(ma_wep1[selected])+", "+string(ma_wep2[selected])+" + "+string(ma_gear[selected]);
        }
    }

    if (draw && !impossible && ma_view[selected]) {
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 0);
        draw_set_color(c_white);
        if (mouse_x >= xx + 25 && mouse_y >= yy + 64 && mouse_x < xx + 974 && mouse_y < yy + 85) {
            draw_set_alpha(0.3);
            draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 0);
        }
        if (man_sel[selected] == 1) {
            draw_set_alpha(0.2);
            draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 0);
        }

        unit_specialism_option = false;
        spec_tip = "";
        draw_set_color(c_gray);
        draw_set_alpha(1);
        draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 1);
        if (man[selected] == "man" && is_struct(display_unit[selected])) {
            if (!unit_specialist) {
                var _unit = display_unit[selected];
                var _role = _unit.role();
                var _experience = _unit.experience;

                var _data, valid = false;
                var _circle_coords = [xx + 321, yy + 77];
                var _circle_radius = 3;
                for (var s = 0; s <= 3; s++) {
                    _data = obj_controller.spec_train_data[s];
                    var valid = stat_valuator(_data.req, _unit);
                    if (valid) {
                        unit_specialism_option = true;
                        var _draw_coords = [_circle_coords[0] + _data.coord_offset[0], _circle_coords[1] + _data.coord_offset[1]];

                        var _draw_coords_mouse = [_draw_coords[0] - _circle_radius, _draw_coords[1] - _circle_radius, _draw_coords[0] + _circle_radius, _draw_coords[1] + _circle_radius];
                        specialistdir = _unit.specialist_tooltips(_data.name, _data.min_exp);

                        if (scr_hit(_draw_coords_mouse)) {
                            draw_set_alpha(0.8);
                            if (scr_click_left()) {
                                switch (_data.name) {
                                    case "Techmarine":
                                        _unit.role_tag[eROLE_TAG.Techmarine] = !_unit.role_tag[eROLE_TAG.Techmarine];
                                        break;
                                    case "Librarian":
                                        _unit.role_tag[eROLE_TAG.Librarian] = !_unit.role_tag[eROLE_TAG.Librarian];
                                        break;
                                    case "Chaplain":
                                        _unit.role_tag[eROLE_TAG.Chaplain] = !_unit.role_tag[eROLE_TAG.Chaplain];
                                        break;
                                    case "Apothecary":
                                        _unit.role_tag[eROLE_TAG.Apothecary] = !_unit.role_tag[eROLE_TAG.Apothecary];
                                        break;
                                }
                            }
                        }

                        draw_circle_colour(_draw_coords[0], _draw_coords[1], _circle_radius, specialistdir.colors[0], specialistdir.colors[1], 0);
                        draw_set_alpha(1.0);
                        array_push(potential_tooltip, [specialistdir.spec_tip, _draw_coords_mouse]);
                    }
                }
            }
        }

        // Squads
        var sqi = "";
        draw_set_color(c_black);
        var squad_colours = [
            #ff0000,    // Red (HSL: 0, 100%, 50%)
            #ff8000,    // Orange (HSL: 30, 100%, 50%)
            #ffff00,    // Yellow (HSL: 60, 100%, 50%)
            #00ff00,    // Green (HSL: 120, 100%, 50%)
            #00ffff,    // Cyan (HSL: 180, 100%, 50%)
            #0080ff,    // Light Blue (HSL: 210, 100%, 50%)
            #0000ff,    // Blue (HSL: 240, 100%, 50%)
            #8000ff,    // Purple (HSL: 270, 100%, 50%)
            #ff00ff,    // Magenta (HSL: 300, 100%, 50%)

            #b20000,    // Red (HSL: 0, 100%, 25%)
            #b26e00,    // Orange (HSL: 30, 100%, 25%)
            #b2b200,    // Yellow (HSL: 60, 100%, 25%)
            #00b200,    // Green (HSL: 120, 100%, 25%)
            #00b2b2,    // Cyan (HSL: 180, 100%, 25%)
            #004db2,    // Light Blue (HSL: 210, 100%, 25%)
            #0000b2,    // Blue (HSL: 240, 100%, 25%)
            #4d00b2,    // Purple (HSL: 270, 100%, 25%)
            #b200b2,    // Magenta (HSL: 300, 100%, 25%)

            #ff4d4d,    // Red (HSL: 0, 50%, 50%)
            #ffb84d,    // Orange (HSL: 30, 50%, 50%)
            #ffff66,    // Yellow (HSL: 60, 50%, 50%)
            #66ff66,    // Green (HSL: 120, 50%, 50%)
            #66ffff,    // Cyan (HSL: 180, 50%, 50%)
            #6680ff,    // Light Blue (HSL: 210, 50%, 50%)
            #6666ff,    // Blue (HSL: 240, 50%, 50%)
            #b366ff,    // Purple (HSL: 270, 50%, 50%)
            #ff66ff,    // Magenta (HSL: 300, 50%, 50%)
        ];
        if (squad[selected] != -1) {
            var _squad_modulo = squad[selected] % array_length(squad_colours);
            draw_set_color(squad_colours[_squad_modulo]);
        }

        if (selected > 0 && selected < array_length(display_unit) - 1 && array_length(squad) - 1 > selected) {
            var _cur_squad = squad[selected];
            var _next_squad = squad[selected + 1];
            var _prev_squad = squad[selected - 1];
            if (_cur_squad == _next_squad) {
                if (squad[selected] != _prev_squad) {
                    sqi = "top";
                } else {
                    sqi = "mid";
                }
            } else if (squad[selected] == _prev_squad) {
                sqi = "bot";
            }
        }
        //TODO handle recursively with an array
        draw_rectangle(xx + 25, yy + 64, xx + 25 + 8, yy + 85, 0);
        draw_set_color(c_gray);

        if (sqi == "") {
            draw_rectangle(xx + 25, yy + 64, xx + 25 + 8, yy + 85, 1);
        } else if (sqi == "mid") {
            draw_line(xx + 25, yy + 64, xx + 25, yy + 85);
        } else if (sqi == "top" || sqi == "bot") {
            draw_line(xx + 25, yy + 64, xx + 25 + 28, yy + 64);
            draw_line(xx + 25, yy + 64, xx + 25, yy + 85);
        }

        draw_line(xx + 25 + 8, yy + 64, xx + 25 + 8, yy + 85);
        // was 885
        // 974

        if ((man[selected] == "man") && (ma_ar == "")) {
            draw_set_alpha(0.5);
        }
        var name_xr = 1;

        for (var k = 0; k < 10; k++) {
            if ((string_width(string_hash_to_newline(string_role)) * name_xr) > 184 - 8) {
                name_xr -= 0.05;
            }
        }

        var hpText = [xx + 240 + 8, yy + 66, string_hash_to_newline(string(health_string))]; // HP
        var xpText = [xx + 330 + 8, yy + 66, exp_string]; // EXP
        var hpColor = c_gray;
        var xpColor = c_gray;
        // Draw EXP value and set up health color
        if (man[selected] == "man") {
            if (ma_promote[selected] >= 10) {
                hpColor = c_red;
                array_push(health_tooltip, ["Critical Health State! Bionic augmentation is required!", [xx + 250, yy + 64, xx + 300, yy + 85]]);
            } else if (ma_promote[selected] > 0 && !unit_specialist && obj_controller.command_set[2] != 0) {
                xpColor = c_yellow;
                array_push(promotion_tooltip, ["Promotion Recommended", [xx + 335, yy + 64, xx + 385, yy + 85]]);
            }
            draw_text_color(xpText[0], xpText[1], xpText[2], xpColor, xpColor, xpColor, xpColor, 1);
        }
        // Draw the health value with the defined colors
        draw_text_color(hpText[0], hpText[1], hpText[2], hpColor, hpColor, hpColor, hpColor, 1);

        // Draw the name
        draw_set_color(c_gray);
        draw_text_transformed(xx + 27 + 8, yy + 66, string_hash_to_newline(string(string_role)), name_xr, 1, 0);
        draw_text_transformed(xx + 27.5 + 8, yy + 66.5, string_hash_to_newline(string(string_role)), name_xr, 1, 0);

        // Draw current location
        if (location_out_of_player_control(unit_location_string) || (unit_location_string == "=Penitorium=") || (assignment != "none")) {
            draw_set_alpha(0.5);
        }
        var truncatedLocation = string_truncate(string(unit_location_string), 130); // Truncate the location string to 100 pixels
        draw_text(xx + 430 + 8, yy + 66, truncatedLocation); // LOC
        draw_set_alpha(1);

        if (ma_loc[selected] == "Mechanicus Vessel") {
            draw_sprite(spr_loc_icon, 2, xx + 427 + 8, yy + 66);
        } else {
            if (man[selected] == "man") {
                c = managing <= 10 ? managing : 0;
                var _unit = display_unit[selected];

                if ((ma_lid[selected] > -1) && (ma_wid[selected] == 0)) {
                    draw_sprite(spr_loc_icon, _unit.is_boarder ? 2 : 1, xx + 427 + 8, yy + 66);
                } else if (ma_wid[selected] > 0) {
                    draw_sprite(spr_loc_icon, 0, xx + 427 + 8, yy + 66);
                }
            } else {
                if ((ma_lid[selected] == -1) && (ma_wid[selected] > 0)) {
                    draw_sprite(spr_loc_icon, 0, xx + 427 + 8, yy + 66);
                }
                if ((ma_lid[selected] > -1) && (ma_wid[selected] == 0)) {
                    draw_sprite(spr_loc_icon, 1, xx + 427 + 8, yy + 66);
                }
            }
        }
        //TODO handle recursively
        if (man[selected] == "man") {
            var xoffset = 0;
            draw_set_color(c_gray);
            if (ar_ar == 1) {
                draw_set_color(c_gray);
            }
            if (ar_ar == 2) {
                draw_set_color(881503);
            }
            draw_text(xx + 573, yy + 66, string_hash_to_newline(string(ma_ar)));

            xoffset += string_width(string_hash_to_newline(ma_ar)) + 15;
            draw_set_color(c_gray);
            if (ar_mb == 1) {
                draw_set_color(c_gray);
            }
            if (ar_mb == 2) {
                draw_set_color(881503);
            }
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_mb)));

            xoffset += string_width(string_hash_to_newline(ma_mb)) + 15;
            draw_set_color(c_gray);
            if (ar_ge == 1) {
                draw_set_color(c_gray);
            }
            if (ar_ge == 2) {
                draw_set_color(881503);
            }
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_ge)));

            xoffset += string_width(string_hash_to_newline(ma_ge)) + 15;
            draw_set_color(c_gray);
            if (ar_we1 == 1) {
                draw_set_color(c_gray);
            }
            if (ar_we1 == 2) {
                draw_set_color(881503);
            }
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_we1)));

            xoffset += string_width(string_hash_to_newline(ma_we1)) + 15;
            draw_set_color(c_gray);
            if (ar_we2 == 1) {
                draw_set_color(c_gray);
            }
            if (ar_we2 == 2) {
                draw_set_color(881503);
            }
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_we2)));
            xoffset += 100;

            if (array_length(_unit.manage_tags)){
                var _tag_button = draw_unit_buttons([xx + 573 + xoffset,yy + 66], "T");
                if (scr_hit(_tag_button)){
                    var _tooltip = "";
                    for (var t=array_length(_unit.manage_tags)-1;t>=0;t--){
                        var _tag = _unit.manage_tags[t];
                        if (!array_contains(obj_controller.management_tags, _tag)){
                            array_delete(_unit.manage_tags, t, 1);
                        } else {
                            _tooltip += $"{_tag}\n"
                        }
                    }
                    _tooltip += "Click to set filter to units tags";
                    tooltip_draw(_tooltip);
                }
                if (point_and_click(_tag_button)){
                    manage_tags = _unit.manage_tags;
                    if (instance_exists(obj_popup) && obj_popup.type  == POPUP_TYPE.ADD_TAGS){
                        obj_popup.tag_selects.set(manage_tags);
                    }
                }
            }
        }
        var cols = [c_gray, c_gray, 881503];
        if (man[selected] != "man") {
            var xoffset = 0;
            //Vehicle Upgrade
            draw_set_color(cols[ar_ge]);
            draw_text(xx + 573, yy + 66, string_hash_to_newline(string(ma_ge)));

            //Vehicle accessory
            xoffset += string_width(string_hash_to_newline(ma_ge)) + 15;
            draw_set_color(cols[ar_mb]);
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_mb)));

            //Vehicle wep 1
            xoffset += string_width(string_hash_to_newline(ma_mb)) + 15;
            draw_set_color(cols[ar_we1]);
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_we1)));

            //Vehicle wep 2
            xoffset += string_width(string_hash_to_newline(ma_we1)) + 15;
            draw_set_color(cols[ar_we2]);
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_we2)));

            //Vehicle wep 3
            xoffset += string_width(string_hash_to_newline(ma_we2)) + 15;
            draw_set_color(cols[ar_ar]);
            draw_text(xx + 573 + xoffset, yy + 66, string_hash_to_newline(string(ma_ar)));
        }
    }
    var no_location = selecting_location == "";
    var wrong_location = false;
    if (!no_location) {
        if (selecting_ship > -1) {
            if (ma_lid[selected] == -1) {
                wrong_location = true;
            } else {
                wrong_location = obj_ini.ship_location[ma_lid[selected]] != selecting_location;
            }
        } else {
            wrong_location = ma_loc[selected] != selecting_location;
        }
    }

    if (is_man && !wrong_location) {
        wrong_location = !_unit.controllable();
    }

    var unclickable = eventing || jailed || wrong_location || impossible || instance_exists(obj_star_select);

    if (!unclickable && !click_lock) {
        var changed = false;

        if (sel_all != "") {
            if (sel_all == "all") {
                changed = true;
            } else if (sel_all == "vehicle" && !is_man) {
                changed = true;
            } else if (sel_all == "man" && is_man) {
                changed = true;
            } else if (sel_all == "Command" && is_man) {
                if (_unit.IsSpecialist(SPECIALISTS_COMMAND)) {
                    changed = true;
                } else if (_unit.squad != "none") {
                    if (obj_ini.squads[_unit.squad].type == "command_squad") {
                        changed = true;
                    }
                }
            } else if (ma_role[selected] == sel_all) {
                changed = true;
            }
        }
        if (filter_mode && changed) {
            ma_view[selected] = !ma_view[selected];
            changed = false;
        } else if (changed) {
            man_sel[selected] = !man_sel[selected];
        }
        if (!ma_view[selected]) {
            changed = false;
            man_sel[selected] = false;
        }

        // individual click
        if (draw && scrollbar_engaged == 0 && ma_view[selected]) {
            if (point_and_click([xx + 25 + 8, yy + 64, xx + 974, yy + 85]) && rectangle_action == -1 /*squad[selected]=squad_sel*/ ) {
                if (double_click < 1) {
                    double_was = selected;
                    double_click = 12;
                } else if (double_was == selected) {
                    double_unit = selected;
                }
                //drag selection action
                drag_square = [mouse_x, mouse_y, mouse_x, mouse_y];
                rectangle_action = !man_sel[selected];
                man_sel[selected] = !man_sel[selected];
                changed = true;
            } else if (rectangle_action != -1) {
                if (rectangle_in_rectangle(xx + 25 + 8, yy + 64, xx + 974, yy + 85, drag_square[0], drag_square[1], mouse_x, mouse_y) > 0 && man_sel[selected] != rectangle_action) {
                    man_sel[selected] = rectangle_action;
                    changed = true;
                }
            }
            if ((squad_sel != -1) && (squad[selected] != 0)) {
                if (squad_sel == squad[selected] && man_sel[selected] != squad_sel_action) {
                    man_sel[selected] = squad_sel_action;
                    changed = true;
                }
            }
        }
        if (changed) {
            if (no_location) {
                selecting_location = ma_loc[selected];
                selecting_ship = ma_lid[selected];
                selecting_planet = ma_wid[selected];
            }
            ma_loc[selected] = selecting_location;
            var unit_man_size = is_man ? _unit.get_unit_size() : scr_unit_size("", ma_role[selected], true);
            if (man_sel[selected]) {
                man_size += unit_man_size;
            } else {
                man_size -= unit_man_size;
            }
        }
        //squad select button
        if (point_and_click([xx + 25, yy + 64, xx + 25 + 8, yy + 85]) && draw) {
            if ((squad_sel == -1) && (squad[selected] != 0)) {
                squad_sel = squad[selected];
                squad_sel_count = 2;
                squad_sel_action = !man_sel[selected];
            }
        }
    }
    if (is_man) {
        force_tool = 0;
        if ((temp[101] == $"{_unit.role()} {_unit.name}") && ((temp[102] != _unit.armour()) || (temp[104] != _unit.gear()) || (temp[106] == _unit.mobility_item()) || (temp[108] != _unit.weapon_one()) || (temp[110] != _unit.weapon_two()) || (temp[114] == "refresh"))) {
            force_tool = 1;
        }

        if (((mouse_x >= xx + 25 && mouse_y >= yy + 64 && mouse_x < xx + 974 && mouse_y < yy + 85) || force_tool == 1) && is_struct(_unit)) {
            unit_focus = _unit; // unit_struct
        }
    }
    if (!ma_view[selected]) {
        return "continue";
    }
}
