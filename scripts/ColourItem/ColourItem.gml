function fetch_marine_components_to_memory() {
    array_foreach(global.modular_drawing_items, function(_element, _index) {
        try {
            if (_element.position != "weapon" && sprite_exists(_element.sprite)) {
                sprite_prefetch(_element.sprite);
                if (struct_exists(_element, "overides")) {
                    var _override_areas = struct_get_names(_element.overides);
                    for (var i = 0; i < array_length(_override_areas); i++) {
                        sprite_prefetch(_element.overides[$ _override_areas[i]]);
                    }
                }
            }
            if (struct_exists(_element, "shadows")) {
                sprite_prefetch(_element.shadows);
            }
        } catch (_exception) {
            // Sprite prefetch failure logged but non-fatal
            show_debug_message($"Sprite prefetch failed for element at index {_index}: {_exception}");
        }
    });
}

function ColourItem(_xx, _yy) constructor {
    fetch_marine_components_to_memory();
    xx = _xx;
    yy = _yy;
    data_slate = new DataSlate();

    static swap_role_set = function(type_start, type_end) {
        var _full_livs = obj_creation.full_liveries;
        var _comp_livs = obj_creation.company_liveries;
        switch (type_start) {
            case 1:
                _full_livs[role_set] = variable_clone(map_colour);
                break;
            case 0:
                _full_livs[0] = variable_clone(map_colour);
                break;
            case 2:
                _comp_livs[role_set] = variable_clone(map_colour);
                break;
        }

        switch (type_end) {
            case 1:
                role_set = obj_creation.roles_radio.selection_val("role_id");
                role_set = role_set == noone ? 0 : role_set;
                map_colour = variable_clone(_full_livs[role_set]);
                break;
            case 0:
                role_set = 0;
                map_colour = variable_clone(_full_livs[0]);
                break;
            case 2:
                role_set = obj_creation.buttons.company_liveries_choice.current_selection;
                if (role_set == -1) {
                    role_set = 1;
                }
                map_colour = variable_clone(_comp_livs[role_set]);
                break;
        }
        shuffle_dummy();
        reset_image();
        colour_pick = false;
    };

    static scr_unit_draw_data = function(default_val = 0) {
        map_colour = {
            is_changed: false,
            block_company_colours: false,
            left_leg_lower: default_val,
            left_leg_upper: default_val,
            left_leg_knee: default_val,
            right_leg_lower: default_val,
            right_leg_upper: default_val,
            right_leg_knee: default_val,
            metallic_trim: default_val,
            right_trim: default_val,
            left_trim: default_val,
            left_chest: default_val,
            right_chest: default_val,
            left_thorax: default_val,
            right_thorax: default_val,
            left_pauldron: default_val,
            left_arm: default_val,
            left_hand: default_val,
            right_pauldron: default_val,
            right_arm: default_val,
            right_hand: default_val,
            left_head: default_val,
            right_head: default_val,
            left_muzzle: default_val,
            right_muzzle: default_val,
            eye_lense: default_val,
            right_backpack: default_val,
            left_backpack: default_val,
            weapon_primary: default_val,
            weapon_secondary: default_val,
            company_marks: default_val,
            company_marks_loc: default_val,
        };
        return map_colour;
    };

    role_set = 0;
    static image_location_maps = {
        left_leg_lower: [
            103,
            165,
            148,
            217,
        ],
        left_leg_upper: [
            83,
            107,
            119,
            134,
        ],
        left_leg_knee: [
            105,
            138,
            126,
            159,
        ],
        right_leg_lower: [
            15,
            165,
            57,
            218,
        ],
        right_leg_upper: [
            43,
            107,
            73,
            139,
        ],
        right_leg_knee: [
            35,
            138,
            58,
            160,
        ],
        metallic_trim: [
            70,
            53,
            100,
            70,
        ],
        right_trim: [
            -100,
            31,
            string_width("R Trim"),
            string_height("R Trim"),
        ],
        left_trim: [
            -150,
            31,
            string_width("L Trim"),
            string_height("L Trim"),
        ],
        left_chest: [
            84,
            72,
            108,
            92,
        ],
        right_chest: [
            50,
            73,
            82,
            103,
        ],
        left_thorax: 0,
        right_thorax: 0,
        weapon_primary: 0,
        weapon_secondary: 0,
        left_pauldron: [
            114,
            31,
            150,
            67,
        ],
        right_pauldron: [
            19,
            31,
            43,
            71,
        ],
        left_head: [
            81,
            15,
            94,
            30,
        ],
        right_head: [
            68,
            15,
            81,
            31,
        ],
        left_muzzle: [
            82,
            32,
            90,
            42,
        ],
        right_muzzle: [
            73,
            32,
            82,
            42,
        ],
        eye_lense: [
            40,
            -20,
            string_width("Lense"),
            string_height("Lense"),
        ],
        left_arm: [
            119,
            67,
            146,
            105,
        ],
        left_hand: [
            128,
            109,
            146,
            123,
        ],
        right_arm: [
            19,
            67,
            34,
            106,
        ],
        right_hand: [
            18,
            109,
            33,
            134,
        ],
        right_backpack: [
            32,
            17,
            60,
            38,
        ],
        left_backpack: [
            97,
            17,
            130,
            38,
        ],
        company_marks: [
            30,
            40,
            string_width("Company Marks"),
            string_height("Company Marks"),
        ],
    };

    static name_maps = {
        left_leg_lower: "Left Leg Lower",
        left_leg_upper: "Left Leg Upper",
        left_leg_knee: "Left Leg Knee",
        right_leg_lower: "Right Leg Lower",
        right_leg_upper: "Right Leg Upper",
        right_leg_knee: "Right Leg Knee",
        metallic_trim: "Metallic Trim",
        right_trim: "Right Trim",
        left_trim: "Left Trim",
        left_chest: "Left Chest",
        right_chest: "Right Chest",
        left_thorax: "Left Thorax",
        right_thorax: "Right Thorax",
        weapon_primary: "Weapon Primary",
        weapon_secondary: "Weapon Secondary",
        left_pauldron: "Left Pauldron",
        right_pauldron: "Right Pauldron",
        left_head: "Left Head",
        right_head: "Right Head",
        left_muzzle: "Left Muzzle",
        right_muzzle: "Right Muzzle",
        eye_lense: "Eye Lense",
        left_arm: "Left Arm",
        left_hand: "Left Hand",
        right_arm: "Right Arm",
        right_hand: "Right Hand",
        right_backpack: "Right Backpack",
        left_backpack: "Left Backpack",
        company_marks: "Company Marks",
    };

    var _radio_opts = [];
    var _names = struct_get_names(name_maps);
    for (var i = 0; i < array_length(_names); i++) {
        array_push(_radio_opts, {str1: name_maps[$ _names[i]], font: fnt_40k_14b, area_id: _names[i]});
    }
    colours_radio = new RadioSet(_radio_opts);

    static lower_left = [
        "left_leg_lower",
        "left_leg_upper",
        "left_leg_knee",
    ];

    static lower_right = [
        "right_leg_lower",
        "right_leg_upper",
        "right_leg_knee",
    ];

    static upper_left = [
        "left_chest",
        "left_arm",
        "left_hand",
        "left_backpack",
    ];

    static chest = [
        "left_chest",
        "right_chest",
    ];

    static upper_right = [
        "right_chest",
        "right_arm",
        "right_hand",
        "right_backpack",
    ];

    static legs = [
        "left_leg_lower",
        "left_leg_upper",
        "left_leg_knee",
        "right_leg_lower",
        "right_leg_upper",
        "right_leg_knee",
    ];

    static head_set = [
        "left_head",
        "right_head",
        "left_muzzle",
        "right_muzzle",
    ];

    static backpack = [
        "right_backpack",
        "left_backpack",
    ];

    static trim_all = [
        "right_trim",
        "left_trim",
        "metallic_trim",
    ];

    static full_body = array_join(lower_left, lower_right, upper_left, chest, upper_right, head_set);

    static set_pattern = function(col, pattern) {
        for (var i = 0; i < array_length(pattern); i++) {
            map_colour[$ pattern[i]] = col;
        }
    };

    static set_default_armour = function(struct_cols, armour_style = 0) {
        map_colour.right_pauldron = struct_cols.right_pauldron;
        map_colour.left_pauldron = struct_cols.left_pauldron;

        map_colour.eye_lense = struct_cols.lens_color;

        map_colour.weapon_primary = struct_cols.weapon_color;
        map_colour.weapon_secondary = struct_cols.weapon_color;
        set_pattern(struct_cols.main_trim, trim_all);
        switch (armour_style) {
            case 0: // Full body
                set_pattern(struct_cols.main_color, full_body);
                break;

            case 1: // Breastplate
                set_pattern(struct_cols.secondary_color, chest);
                set_pattern(struct_cols.main_color, head_set);
                set_pattern(struct_cols.main_color, legs);
                break;

            case 2: // Vertical
                set_pattern(struct_cols.secondary_color, upper_left);
                set_pattern(struct_cols.main_color, lower_right);
                set_pattern(struct_cols.main_color, upper_right);
                set_pattern(struct_cols.secondary_color, lower_left);
                set_pattern(struct_cols.main_color, head_set);
                break;

            case 3: // Quadrant
                set_pattern(struct_cols.secondary_color, upper_left);
                set_pattern(struct_cols.secondary_color, lower_right);
                set_pattern(struct_cols.main_color, upper_right);
                set_pattern(struct_cols.main_color, lower_left);
                set_pattern(struct_cols.main_color, head_set);
                break;
        }
        reset_image();
        return variable_clone(map_colour);
    };

    static set_default_techmarines = function(struct_cols) {
        set_pattern(eCOLORS.RED, full_body);
        map_colour.eye_lense = eCOLORS.GREEN;
        map_colour.right_pauldron = eCOLORS.RED;
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed = true;
        return variable_clone(map_colour);
    };

    static set_default_apothecary = function(struct_cols) {
        set_pattern(eCOLORS.WHITE, full_body);
        map_colour.eye_lense = eCOLORS.RED;
        map_colour.right_pauldron = eCOLORS.WHITE;
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed = true;
        return variable_clone(map_colour);
    };

    static set_default_chaplain = function(struct_cols) {
        set_pattern(eCOLORS.BLACK, full_body);
        map_colour.eye_lense = eCOLORS.RED;
        map_colour.right_pauldron = eCOLORS.BLACK;
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed = true;
        return variable_clone(map_colour);
    };

    static set_default_librarian = function(struct_cols) {
        set_pattern(eCOLORS.DARK_ULTRAMARINE, full_body);
        map_colour.eye_lense = eCOLORS.CYAN;
        map_colour.right_pauldron = eCOLORS.DARK_ULTRAMARINE;
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed = true;
        return variable_clone(map_colour);
    };

    colour_pick = false;
    dummy_marine = undefined;
    dummy_image = undefined;

    static reset_image = function() {
        if (is_struct(dummy_image)) {
            delete dummy_image;
            dummy_image = undefined;
        }
    };

    freeze_armour = false;

    static shuffle_dummy = function() {
        dummy_marine.update();
    };

    hover_pos = false;
    colour_return = false;

    static draw_base = function() {
        data_slate.inside_method = function() {
            if (hover_pos != false) {
                if (colour_return != false) {
                    if (colour_return[0] != hover_pos) {
                        map_colour[$ colour_return[0]] = colour_return[1];
                        colour_return = [
                            hover_pos,
                            map_colour[$ hover_pos],
                        ];
                        map_colour[$ hover_pos] = 0;
                        reset_image();
                    }
                } else {
                    colour_return = [
                        hover_pos,
                        map_colour[$ hover_pos],
                    ];
                    map_colour[$ hover_pos] = 0;
                    reset_image();
                }
            }
            if (is_struct(colour_pick)) {
                var _action = colour_pick.draw();
                if (_action == "destroy") {
                    colour_pick = false;
                } else {
                    var _reset = false;
                    if (!is_array(colour_pick.chosen)) {
                        if (colour_pick.chosen != -1 && colour_pick.chosen != map_colour[$ colour_pick.area]) {
                            _reset = true;
                        }
                    } else {
                        if (!is_array(map_colour[$ colour_pick.area])) {
                            _reset = true;
                        } else if (!array_equals(map_colour[$ colour_pick.area], colour_pick.chosen)) {
                            _reset = true;
                            if (colour_pick.chosen[0] == "icon") {
                                if (is_struct(map_colour[$ colour_pick.area][1])) {
                                    var _comp_icon = map_colour[$ colour_pick.area][1].icon;
                                    if (_comp_icon == colour_pick.chosen[1].icon) {
                                        _reset = false;
                                    }
                                }
                            }
                        }
                    }
                    if (_reset) {
                        map_colour[$ colour_pick.area] = colour_pick.chosen;
                        map_colour.is_changed = true;
                        switch (obj_creation.livery_selection_options.current_selection) {
                            case 0:
                                obj_creation.full_liveries[0] = variable_clone(map_colour);
                                break;
                            case 1:
                                obj_creation.full_liveries[role_set] = variable_clone(map_colour);
                                break;
                            case 2:
                                obj_creation.company_liveries[role_set] = variable_clone(map_colour);
                                break;
                        }
                        delete dummy_image;
                        dummy_image = undefined;
                    }
                }
            }
            image_location_maps.right_trim = move_location_relative(draw_unit_buttons([xx - 90, yy + 31], "R Trim"), -xx, -yy);
            image_location_maps.eye_lense = move_location_relative(draw_unit_buttons([xx - 90, yy + image_location_maps.right_trim[3]], "Lenses"), -xx, -yy);
            image_location_maps.weapon_primary = move_location_relative(draw_unit_buttons([xx - 90, yy + image_location_maps.eye_lense[3]], "Weapon\nPrimary"), -xx, -yy);
            image_location_maps.weapon_secondary = move_location_relative(draw_unit_buttons([xx - 90, yy + image_location_maps.weapon_primary[3]], "Weapon\nSecondary"), -xx, -yy);
            image_location_maps.left_trim = move_location_relative(draw_unit_buttons([xx + 150, yy + 31], "L Trim"), -xx, -yy);
            var freeze_image_shuffle = draw_unit_buttons([xx + 150, yy + image_location_maps.left_trim[3]], "Freeze",, freeze_armour ? c_green : c_red);

            if (point_and_click(freeze_image_shuffle)) {
                freeze_armour = !freeze_armour;
            }
            if (scr_hit(freeze_image_shuffle)) {
                tooltip_draw("Freeze and un-freeze marine armour changes");
            }

            var _shuffle_marine_decorations = draw_unit_buttons([xx + 150, freeze_image_shuffle[3]], "Shuffle",, c_green);

            if (point_and_click(_shuffle_marine_decorations)) {
                freeze_armour = !freeze_armour;
                shuffle_dummy();
                reset_image();
            }
            if (scr_hit(_shuffle_marine_decorations)) {
                tooltip_draw("click to shuffle marine decorations and randomisations");
            }
            image_location_maps.company_marks = move_location_relative(draw_unit_buttons([xx - 30, yy - 40], "Company Marks"), -xx, -yy);

            if (dummy_marine ?? true) {
                dummy_marine = new DummyMarine();
            }
            if (!is_struct(dummy_image)) {
                dummy_image = dummy_marine.draw_unit_image();
            }
            dummy_image.draw(xx, yy - 20);
            hover_pos = false;
            var map_names = struct_get_names(image_location_maps);
            for (var i = 0; i < array_length(map_names); i++) {
                var _body_loc = map_names[i];
                var _body_loc_coords = image_location_maps[$ _body_loc];
                if (!is_array(_body_loc_coords)) {
                    continue;
                }
                var _rel_position = coord_relevative_positions(_body_loc_coords, xx, yy);
                if (scr_hit(_rel_position)) {
                    if (struct_exists(name_maps, _body_loc)) {
                        tooltip_draw(name_maps[$ _body_loc]);
                    } else {
                        tooltip_draw(_body_loc);
                    }
                    hover_pos = _body_loc;
                }
                if (point_and_click(_rel_position)) {
                    new_colour_pick(_body_loc);
                }
            }
            if (colour_return != false) {
                if (hover_pos != colour_return[0]) {
                    map_colour[$ colour_return[0]] = colour_return[1];
                    colour_return = false;
                    reset_image();
                }
            }
        };
        data_slate.draw(0, 5, 0.45, 1);
    };

    static new_colour_pick = function(body_loc, x_pos = 20, y_pos = yy + 350, col_width = 350) {
        colour_pick = new ColourPicker(x_pos, y_pos, col_width);
        colour_pick.area = body_loc;
        colour_pick.title = body_loc;
    };
}
