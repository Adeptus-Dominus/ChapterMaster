xx = camera_get_view_x(view_camera[0]);
yy = camera_get_view_y(view_camera[0]);
ww = camera_get_view_width(view_camera[0]);
hh = camera_get_view_height(view_camera[0]);

// Sets the bombard target, its forces and draws the ships wich will bombard said target
bomb_window = {
    x1: 0,
    y1: 0,
    w: 480,
    h: 365,
    x2: 0,
    y2: 0,
    x3: 0,
    y3: 0,
};
bomb_window.x1 = xx + (ww / 2) - bomb_window.w / 2;
bomb_window.y1 = yy + (hh / 2) - bomb_window.h / 2;
bomb_window.x2 = bomb_window.x1 + bomb_window.w;
bomb_window.y2 = bomb_window.y1 + bomb_window.h;
bomb_window.x3 = bomb_window.x1 + (bomb_window.w / 2);
bomb_window.y3 = bomb_window.y1 + (bomb_window.h / 2);

// Bombardment window
if ((max_ships > 0) && instance_exists(obj_star_select)) {
    // Draw the background
    draw_set_color(c_white);
    draw_sprite_stretched(spr_data_slate, 1, bomb_window.x1 - 20, bomb_window.y1 - 20, bomb_window.w + 40, bomb_window.h + 46);
    draw_set_color(#34bc75);
    // draw_rectangle(bomb_window.x1+1, bomb_window.y1+1, bomb_window.x2-1, bomb_window.y2-1, 1);
    // draw_rectangle(bomb_window.x1+2, bomb_window.y1+2, bomb_window.x2-2, bomb_window.y2-2, 1);

    // Header
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(bomb_window.x1 + 18, bomb_window.y1 + 30, "Initializing Bombardment...", 0.8, 0.8, 0);

    // Target info
    draw_set_font(fnt_info);
    draw_text_bold(bomb_window.x1 + 20, bomb_window.y1 + 70, $"Target planet: {p_data.name()}");

    var _total_hers = p_data.corruption + p_data.secret_corruption;
    var str = 0;
    var _influ = p_data.population_influences;

    var population_string = $"Population: {p_data.display_population()} people";
    draw_text_bold(bomb_window.x1 + 20, bomb_window.y1 + 90, population_string);

    if (p_target.sprite_index != spr_star_hulk) {
        // TODO a centralised point to be able to fetch display names from factions identifying number
        var t_name = "";
        switch (target) {
            case 2:
                t_name = "Imperial Forces";
                break;
            case 2.5:
                if (p_target.p_owner[obj_controller.selecting_planet] == eFACTION.TAU) {
                    t_name = "Gue'la Forces";
                } else {
                    t_name = "PDF";
                }
                break;
            case 3:
                t_name = "Mechanicus";
                break;
            case 5:
                t_name = "Ecclesiarchy";
                break;
            case 6:
                t_name = "Eldar";
                break;
            case 7:
                t_name = "Orks";
                break;
            case 8:
                t_name = "Tau";
                break;
            case 9:
                t_name = "Tyranids";
                break;
            case 10:
                t_name = "Chaos";
                break;
            case 11:
                t_name = "Traitors";
                break;
            case 13:
                t_name = "Necrons";
                break;
            default:
                t_name = "";
                break;
        }

        var str_string = "";
        // TODO a centralised point to be able to fetch display names from factions identifying number
        // First-draw validation: if the default target has no force, advance to the
        // first faction that does, so the screen never opens on a ghost target the
        // player must cycle past.
        if (target_initialized != 1) {
            target_initialized = 1;
            if (p_data.planet_forces[target] <= 0) {
                for (var _t0 = 2; _t0 < array_length(p_data.planet_forces); _t0++) {
                    if (p_data.planet_forces[_t0] > 0) {
                        target = _t0;
                        break;
                    }
                }
            }
        }
        str = floor(p_data.planet_forces[target]);
        if (target == 2.5) {
            str = determine_pdf_defence(p_data.pdf,, p_data.fortification_level)[0];
        }
        var _s_strings = global.force_strength_descriptions;
        if (str < array_length(_s_strings)) {
            str_string = _s_strings[str];
        }

        var target_string = "Target force:  ";
        draw_text_bold(bomb_window.x1 + 20, bomb_window.y1 + 110, target_string);
        if (point_and_click(draw_unit_buttons([bomb_window.x1 + 12 + string_width(target_string), bomb_window.y1 + 99], string(t_name), [1, 1], #34bc75, fa_center, fnt_info))) {
            var _possible_targets = [];
            for (var i = 2; i < array_length(p_data.planet_forces); i++) {
                if (p_data.planet_forces[i] > 0) {
                    array_push(_possible_targets, i);
                }
            }
            if (p_data.pdf > 0) {
                array_push(_possible_targets, 2.5);
            }
            // Switch target to the next in the array
            if (array_length(_possible_targets) > 0) {
                var _current_index = array_get_index(_possible_targets, target);
                _current_index = _current_index < (array_length(_possible_targets) - 1) ? _current_index + 1 : 0;
                target = _possible_targets[_current_index];
            }
        }
        var strength_string = $"Strength: {str}";
        draw_text_bold(bomb_window.x1 + 20, bomb_window.y1 + 130, strength_string);
    }

    // The select all button
    draw_set_font(fnt_menu);
    var ship_index = 0;
    var sel_all_label = "";
    if (all_sel == 0) {
        sel_all_label = " ";
    } else if (all_sel == 1) {
        sel_all_label = "x";
    }
    var sel_all_button = draw_unit_buttons([bomb_window.x2 - 55, bomb_window.y1 + 150, bomb_window.x2 - 40, bomb_window.y1 + 165], sel_all_label, [1, 1], #34bc75, fa_center, fnt_40k_14b);
    if (point_and_click(sel_all_button)) {
        for (var i = 0; i < array_length(ship); i++) {
            // Limit to the first 5 ships with buttons. Spent ships are skipped so
            // Select All never toggles a ship that has already used its turn.
            if (ship[ship_index] != "" && ship_all[i] == all_sel && !ship_spent[i]) {
                ship_all[i] = !all_sel;
                ships_selected += all_sel ? -1 : 1;
            }
            ship_index++; // Move to the next ship in the array
        }
        all_sel = !all_sel;
    }

    // Total selection number
    draw_set_halign(fa_left);
    draw_set_font(fnt_info);
    var sel = ships_selected;
    var curr_sel_string = $"Current Selection: {sel} ships";
    draw_text_bold(bomb_window.x1 + 20, bomb_window.y2 - 28, curr_sel_string);

    draw_text_bold(bomb_window.x1 + 20, bomb_window.y1 + 160, "Select ships:");

    // Individual ship buttons
    ship_index = 0;
    var buttonSpacingX = 106; // adjust as needed
    var buttonSpacingY = 21; // adjust as needed

    // Iterate over the 6 rows
    for (var row = 0; row < 6; row++) {
        // Iterate over the 4 columns in each row
        for (var col = 0; col < 4; col++) {
            // Find the next non-empty ship
            while (ship_index < array_length(ship) && ship[ship_index] == "") {
                ship_index++;
            }

            // Check if ship_index is still within range
            if (ship_index < array_length(ship) && ship[ship_index] != "") {
                // Upstream fix (b593a7837): pass the full name; string_truncate below
                // handles fitting it, and string_delete threw warnings on short names.
                var ship_name = ship[ship_index];
                // Calculate button position based on row and column
                var buttonX = bomb_window.x1 + 24 + col * buttonSpacingX;
                var buttonY = bomb_window.y1 + 172 + row * buttonSpacingY;

                // Draw the unit buttons and handle selection. A ship that has already
                // spent its support this turn shows locked in red and rejects clicks,
                // matching the attack roster. Bombardment needs a fully fresh ship.
                var _spent = ship_spent[ship_index];
                var _btn_col = _spent ? c_red : (ship_all[ship_index] ? #34bc75 : #bf4040);
                var _btn_alpha = _spent ? 0.5 : (ship_all[ship_index] ? 1 : 0.5);
                var _ship_clicked = point_and_click(draw_unit_buttons([buttonX, buttonY, buttonX + 105, buttonY + 20], string_truncate(ship_name, 200), [1, 1], _btn_col, fa_center, fnt_40k_10, _btn_alpha));
                if (_ship_clicked && !_spent) {
                    ship_all[ship_index] = !ship_all[ship_index];
                    ships_selected += ship_all[ship_index] ? 1 : -1;

                    // Ensure ships_selected does not go negative
                    ships_selected = max(ships_selected, 0);
                }
                ship_index++; // Increment the ship index after each iteration
            }
        }
    }

    // Bombardment effect preview. Estimate what a bombard with the currently selected
    // ships would do to this world and show it at a glance, so a small-population planet
    // is not wiped out to shave a point off an entrenched enemy without the player
    // seeing it coming. Population loss is fixed per world (the kill does not scale with
    // ship count); enemy loss scales with the selected bombard score.
    var _est_bomb = 0;
    for (var i = 0; i < array_length(ship_ide); i++) {
        if (ship_all[i] == 1) {
            var _c = player_ships_class(ship_ide[i]);
            if (_c == "capital") {
                _est_bomb += 3;
            } else if (_c == "frigate") {
                _est_bomb += 1;
            }
        }
    }
    var _est = bombard_effect_estimate(p_data, target, _est_bomb, str);
    var _rows_used = max(1, ceil(array_length(ship_ide) / 4));
    var _est_y = min(bomb_window.y1 + 172 + _rows_used * buttonSpacingY + 16, bomb_window.y2 - 74);
    draw_set_halign(fa_left);
    draw_set_font(fnt_info);
    draw_set_color(#34bc75);
    draw_text_bold(bomb_window.x1 + 20, _est_y, "If bombarded now:");
    draw_set_color(bombard_effect_bracket_color(_est.population));
    draw_text_bold(bomb_window.x1 + 20, _est_y + 18, $"Population loss: {_est.population}");
    draw_set_color(bombard_effect_bracket_color(_est.enemy));
    draw_text_bold(bomb_window.x1 + 20, _est_y + 36, $"Enemy losses: {_est.enemy}");
    draw_set_color(#34bc75);

    // Confirm and Cancel buttons
    var button_alpha = 1;
    if (!ships_selected) {
        button_alpha = 0.4;
    }
    bombard_button = draw_unit_buttons([bomb_window.x2 - 96, bomb_window.y2 - 40], "Confirm", [1, 1], #bf4040, fa_center, fnt_40k_14b, button_alpha);
    if (point_and_click(bombard_button)) {
        if (ships_selected > 0) {
            bomb_score = 0;
            for (var i = 0; i < array_length(ship_ide); i++) {
                if (ship_all[i] == 1) {
                    var _class = player_ships_class(ship_ide[i]);
                    if (_class == "capital") {
                        bomb_score += 3;
                    }
                    if (_class == "frigate") {
                        bomb_score += 1;
                    }
                }
            }
            // Start bombardment here
            p_data.bombard(target, bomb_score, str);
        }
    }
    var cancel_button = draw_unit_buttons([bomb_window.x2 - 166, bomb_window.y2 - 40], "Cancel", [1, 1], #34bc75, fa_center, fnt_40k_14b);
    if (point_and_click(cancel_button)) {
        with (obj_bomb_select) {
            instance_destroy();
        }
        instance_destroy();
    }

    draw_set_valign(fa_top);
}
