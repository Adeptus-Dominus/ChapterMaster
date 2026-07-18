try {
    var equip = false;
    var co;
    var ide;
    tooltip = "";
    tooltip2 = "";
    col_shift = is_string(type);

    if (!col_shift) {
        col_shift = type > 0;
        equip = type > 20;
    }

    if (col_shift) {
        if (!equip) {
            draw_set_font(fnt_40k_30b);
            var _type_key = string(type);
            var _colour_type = struct_exists(type_names, _type_key) ? type_names[$ _type_key] : "";

            picker.title = _colour_type;

            var _action = picker.draw();
            if (_action == "destroy") {
                instance_destroy();
                exit;
            } else {
                var _col = picker.chosen;
                if (start_colour == -1) {
                    if (is_numeric(type) && type >= 1 && type <= 7) {
                        start_colour = variable_instance_get(obj_creation, type_fields[type]);
                    } else if (is_string(type)) {
                        var role_data = obj_creation.complex_livery_data[$ role];
                        if (is_struct(role_data) && struct_exists(role_data, type)) {
                            start_colour = role_data[$ type];
                        }
                    }
                }

                if (is_array(_col)) {
                    if (is_string(type)) {
                        obj_creation.complex_livery_data[$ role][$ type] = _col;
                    }
                } else {
                    if (_col == -1) {
                        _col = start_colour;
                    }

                    if (is_numeric(type) && type >= 1 && type <= 7) {
                        variable_instance_set(obj_creation, type_fields[type], _col);
                    }

                    with (obj_creation) {
                        bulk_selection_buttons_setup();
                    }

                    if (is_string(type)) {
                        obj_creation.complex_livery_data[$ role][$ type] = _col;
                        with (obj_creation) {
                            set_complex_livery_buttons();
                        }
                    }
                }
            }
        }

        if (equip) {
            co = 100;
            ide = type - 100;

            draw_set_font(fnt_40k_30b);

            var _role_name = obj_creation.role[co][ide];
            var _text_selected = obj_creation.text_selected;
            var _sel_key = "unit_name" + string(ide);

            if (_role_name == "" || badname == 1) {
                draw_set_color(c_red);
            }

            var _display_text = string(_role_name);
            if (_text_selected == _sel_key && obj_creation.text_bar <= 30) {
                _display_text += "|";
            }

            draw_text_transformed(444, 550, string_hash_to_newline(_display_text), 0.6, 0.6, 0);

            var _height = string_height_ext(string_hash_to_newline(string(_role_name) + "Q"), -1, 580) * 0.6;
            if (scr_hit(444, 550, 820, 550 + _height)) {
                obj_cursor.image_index = 2;
                tooltip = "Astartes Role Name";
                tooltip2 = $"The name of this Astartes Role.  The plural form will be ''{_role_name}s''.";
                if (mouse_button_clicked()) {
                    obj_creation.text_selected = _sel_key;
                    keyboard_string = _role_name;
                }
            }

            if (_text_selected == _sel_key) {
                obj_creation.role[co][ide] = keyboard_string;
            }

            draw_rectangle(444 - 1, 550 - 1, 822, 550 + _height, 1);
            draw_set_color(CM_GREEN_COLOR);

            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_right);

            var _spacing = 22;
            var x5 = 594;
            var y5 = 597 - _spacing;

            for (var _slot_count = 0; _slot_count <= 4; _slot_count++) {
                y5 += _spacing;

                draw_set_halign(fa_right);
                draw_set_color(CM_GREEN_COLOR);

                var _title = $"{get_slot_name(type - 100, _slot_count)}: ";
                _title = string_hash_to_newline(_title);
                var _title_width = string_width(_title);
                var _title_height = string_height(_title) - 2;

                draw_rectangle(x5, y5, x5 - _title_width, y5 + _title_height, 1);
                draw_text(x5, y5, _title);

                if (scr_hit(x5 - _title_width, y5, x5, y5 + _title_height)) {
                    draw_set_color(c_white);
                    draw_set_alpha(0.2);
                    draw_rectangle(x5, y5, x5 - _title_width, y5 + _title_height, 0);

                    if (mouse_button_clicked()) {
                        var _unit_type = type - 100;
                        var _is_invalid = _unit_type == eROLE.DREADNOUGHT && _slot_count > eEQUIPMENT_SLOT.WEAPON_TWO;

                        if (!_is_invalid) {
                            tab = 1;
                            target_gear = _slot_count;
                            item_name = [];
                            scr_get_item_names(item_name, _unit_type, _slot_count, eENGAGEMENT.RANGED, false, false);
                        }
                    }
                }

                var _array_name = slot_arrays[_slot_count];
                var _slot_array2d = variable_instance_get(obj_creation, _array_name);
                var _equipment_slot = _slot_array2d[co][ide];

                draw_set_alpha(1);
                draw_set_color(CM_GREEN_COLOR);
                draw_set_halign(fa_left);
                draw_text(600, y5, string_hash_to_newline(string(_equipment_slot)));
            }

            var _confirm_gear_button = {
                alpha: 1,
                rects: [],
            };
            _confirm_gear_button.alpha = target_gear > -1 ? 0.5 : 1;
            _confirm_gear_button.rects = draw_unit_buttons([614, 716], "CONFIRM", [1, 1], CM_GREEN_COLOR, undefined, fnt_40k_14b, _confirm_gear_button.alpha);

            if (target_gear == -1 && point_and_click(_confirm_gear_button.rects)) {
                var _role_id = ide;
                for (var i = 0; i < array_length(possible_custom_roles); i++) {
                    var _role_pair = possible_custom_roles[i];
                    if (_role_pair[1] == _role_id) {
                        var c_role = {
                            name: obj_creation.role[100][_role_id],
                            wep1: obj_creation.wep1[100][_role_id],
                            wep2: obj_creation.wep2[100][_role_id],
                            gear: obj_creation.gear[100][_role_id],
                            mobi: obj_creation.mobi[100][_role_id],
                            armour: obj_creation.armour[100][_role_id],
                        };
                        variable_struct_set(obj_creation.custom_roles, _role_pair[0], c_role);
                        break;
                    }
                }

                instance_destroy();
                with (obj_creation) {
                    update_creation_roles_radio(2);
                }
            }

            draw_set_halign(fa_left);
            if (scr_hit(434, 591, 594, 709)) {
                tooltip = "Gear";
                tooltip2 = "The equipment this Astartes Role defaults to.  Note that if defaults are set to expensive items the Astartes may instead be provided with more usual equipment.";
            }
        }
    }

    if (target_gear > -1) {
        draw_set_valign(fa_top);
        tab = 1;
        item_name = [];
        scr_get_item_names(
            item_name,
            type - 100, // eROLE
            target_gear, // slot
            tab, // eEngagement
            false, // no company standard
            false, // don't limit to available items
        );

        draw_set_color(0);
        draw_rectangle(851, 210, 1168, 749, 0);

        draw_set_color(CM_GREEN_COLOR);
        draw_rectangle(844, 200, 1166, 748, 1);
        draw_rectangle(845, 201, 1165, 747, 1);
        draw_rectangle(846, 202, 1164, 746, 1);

        draw_set_font(fnt_40k_30b);
        var slot_name = get_slot_name(type - 100, target_gear);
        draw_text_transformed(862, 215, $"Select {slot_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14b);

        var x3 = 862;
        var y3 = 245;
        var space = 18;

        for (var h = 0; h < array_length(item_name); h++) {
            draw_set_color(CM_GREEN_COLOR);
            var scale = string_width(item_name[h]) >= 140 ? 0.75 : 1;
            draw_text_transformed(x3, y3, item_name[h], scale, 1, 0);
            y3 += space;

            if (scr_hit(x3, y3 - space, x3 + 143, y3 + 17 - space)) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_text_transformed(x3, y3 - space, string_hash_to_newline(item_name[h]), scale, 1, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked()) {
                    var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];
                    switch (target_gear) {
                        case 0:
                            obj_creation.wep1[co][ide] = buh;
                            break;
                        case 1:
                            obj_creation.wep2[co][ide] = buh;
                            break;
                        case 2:
                            obj_creation.armour[co][ide] = buh;
                            break;
                        case 3:
                            obj_creation.gear[co][ide] = buh;
                            break;
                        case 4:
                            obj_creation.mobi[co][ide] = buh;
                            break;
                    }
                }
            }
        }

        if (target_gear == eEQUIPMENT_SLOT.WEAPON_ONE || target_gear == eEQUIPMENT_SLOT.WEAPON_TWO) {
            tab = 2;
            item_name = [];
            scr_get_item_names(
                item_name,
                type - 100, // eROLE
                target_gear, // slot
                tab, // eEngagement
                false, // no company standard
                false, // don't limit to available items
            );

            x3 = 862 + 146;
            y3 = 245;

            for (var h = 0; h < array_length(item_name); h++) {
                draw_set_color(CM_GREEN_COLOR);
                var scale = string_width(item_name[h]) >= 140 ? 0.75 : 1;
                var _button = draw_unit_buttons([x3, y3], item_name[h], [scale, scale], CM_GREEN_COLOR);
                y3 += space;

                if (point_and_click(_button)) {
                    var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];
                    switch (target_gear) {
                        case 0:
                            obj_creation.wep1[co][ide] = buh;
                            break;
                        case 1:
                            obj_creation.wep2[co][ide] = buh;
                            break;
                        case 2:
                            obj_creation.armour[co][ide] = buh;
                            break;
                        case 3:
                            obj_creation.gear[co][ide] = buh;
                            break;
                        case 4:
                            obj_creation.mobi[co][ide] = buh;
                            break;
                    }
                }
            }
            tab = 1;
        }

        if (point_and_click(draw_unit_buttons([980, 716], "CLOSE", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b, 1))) {
            target_gear = -1;
        }
    }

    if ((tooltip != "") && (obj_creation.change_slide <= 0)) {
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_set_color(0);
        draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 0);
        draw_set_color(CM_GREEN_COLOR);
        draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 1);
        draw_set_font(fnt_40k_14b);
        draw_text(mouse_x + 22, mouse_y + 22, string_hash_to_newline(string(tooltip)));
        draw_set_font(fnt_40k_14);
        draw_text_ext(mouse_x + 22, mouse_y + 42, string_hash_to_newline(string(tooltip2)), -1, 500);
    }
} catch (ex) {
    ERROR_HANDLER.handle_exception(ex);
    instance_destroy();
}
