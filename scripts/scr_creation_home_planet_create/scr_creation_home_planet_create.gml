function player_recruit_planet_selection() {
    add_draw_return_values();
    with (obj_creation) {
        draw_set_color(CM_GREEN_COLOR);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        if ((fleet_type != 1) || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_set_alpha(0.5);
        }
        var _recruit_home = buttons.recruit_home_relationship;

        _recruit_home.x1 = 1265;
        _recruit_home.y1 = 110;
        if (custom == eCHAPTER_TYPE.PREMADE) {
            _recruit_home.allow_changes = false;
        }
        _recruit_home.draw();
        var _recruit_world_type = _recruit_home.current_selection;
        if (_recruit_world_type == 0) {
            recruiting = homeworld;
        }
        var _cur_planet_index2 = scr_planet_image_numbers(recruiting);

        if (custom == eCHAPTER_TYPE.CUSTOM && _recruit_world_type > 0) {
            draw_sprite_stretched(spr_creation_arrow, 0, 1265, 285, 32, 32);
            draw_sprite_stretched(spr_creation_arrow, 1, 1455, 285, 32, 32);
            recruiting = list_traveler(planet_types, recruiting, [1265, 285, 1297, 317], [1455, 285, 1487, 317]);
        }

        scr_image("ui/planet", _cur_planet_index2, 1313, 244, 128, 128);

        draw_text_transformed(1377, 378, recruiting, 0.5, 0.5, 0);

        if (_recruit_world_type < 2) {
            recruiting_name = homeworld_name;
        } else if (_recruit_world_type == 2) {
            if (recruiting_name == homeworld_name) {
                recruiting_name = global.name_generator.GenerateFromSet("star", false);
            }
        }
        //TODO make a centralised logic for player renaming things in the creation screen
        if ((fleet_type == 1 && _recruit_world_type < 2) && (homeworld_name == recruiting_name)) {
            draw_set_color(c_red);
        }
        if ((text_selected != "recruiting_name") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_transformed(1377, 398, recruiting_name, 0.5, 0.5, 0);
        }
        if (custom == eCHAPTER_TYPE.CUSTOM && _recruit_world_type == 2) {
            if ((text_selected == "recruiting_name") && (text_bar > 30)) {
                draw_text_transformed(1377, 398, recruiting_name, 0.5, 0.5, 0);
            }
            if ((text_selected == "recruiting_name") && (text_bar <= 30)) {
                draw_text_transformed(1377, 398, $"{recruiting_name}|", 0.5, 0.5, 0);
            }
            if (scr_text_hit(1377, 398, true, recruiting_name)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked()) {
                    text_selected = "recruiting_name";
                    keyboard_string = recruiting_name;
                }
            }
            if (text_selected == "recruiting_name") {
                recruiting_name = keyboard_string;
            }
            draw_set_alpha(0.75);
            draw_rectangle(1258, 398, 1493, 418, 1);
            draw_set_alpha(1);

            if (_recruit_world_type == 2) {
                var _refresh_rec_name_btn = [
                    1503,
                    398,
                    1523,
                    418,
                ];
                draw_unit_buttons(_refresh_rec_name_btn, "?", [1, 1], CM_GREEN_COLOR, fa_center, fnt_40k_14b);
                if (point_and_click(_refresh_rec_name_btn)) {
                    var _new_rec_name = global.name_generator.GenerateFromSet("star", false);
                    recruiting_name = _new_rec_name;
                }
            }
        }
    }
    pop_draw_return_values();
}

function scr_creation_home_planet_create() {
    add_draw_return_values();
    var fleet_type_text = fleet_type == ePLAYER_BASE.HOME_WORLD ? "Homeworld" : "Flagship";
    draw_text_transformed(644, 218, fleet_type_text, 0.6, 0.6, 0);

    var _cur_planet_index = scr_planet_image_numbers(homeworld);
    if (fleet_type != 1) {
        _cur_planet_index = 16;
    }

    if (fleet_type == ePLAYER_BASE.HOME_WORLD) {
        scr_image("ui/planet", _cur_planet_index, 580, 244, 128, 128);

        draw_text_transformed(644, 378, homeworld, 0.5, 0.5, 0);
        if ((text_selected != "home_name") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_transformed(644, 398, homeworld_name, 0.5, 0.5, 0);
        }

        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if (text_selected == "home_name") {
                draw_text_transformed(644, 398, homeworld_name + (text_bar > 30 ? "" : "|"), 0.5, 0.5, 0);
            }

            if (scr_text_hit(644, 398, true, homeworld_name)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked()) {
                    text_selected = "home_name";
                    keyboard_string = homeworld_name;
                }
            }
            if (text_selected == "home_name") {
                homeworld_name = keyboard_string;
            }
            draw_set_alpha(0.75);
            draw_rectangle(525, 398, 760, 418, 1);
            draw_set_alpha(1);
            var _refresh_hw_name_btn = [
                770,
                398,
                790,
                418,
            ];
            draw_unit_buttons(_refresh_hw_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_hw_name_btn)) {
                var _new_hw_name = global.name_generator.GenerateFromSet("star", false);
                homeworld_name = _new_hw_name;
            }
        }

        if (custom == eCHAPTER_TYPE.CUSTOM) {
            draw_sprite_stretched(spr_creation_arrow, 0, 525, 285, 32, 32);
            draw_sprite_stretched(spr_creation_arrow, 1, 725, 285, 32, 32);
            homeworld = list_traveler(planet_types, homeworld, [525, 285, 557, 317], [725, 285, 757, 317]);
        }
        var _system_complex = buttons.complex_homeworld;
        _system_complex.update();
        _system_complex.draw();
        _system_complex.clicked();
        draw_set_font(fnt_40k_30b);
    }
    if (fleet_type != ePLAYER_BASE.HOME_WORLD) {
        scr_image("ui/planet", _cur_planet_index, 580, 244, 128, 128);

        draw_text_transformed(644, 378, "Battle Barge", 0.5, 0.5, 0);
        if ((text_selected != "flagship_name") || (custom == eCHAPTER_TYPE.PREMADE)) {
            draw_text_transformed(644, 398, flagship_name, 0.5, 0.5, 0);
        }

        //TODO swap out for TextBarArea constructor
        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if ((text_selected == "flagship_name") && (text_bar > 30)) {
                draw_text_transformed(644, 398, flagship_name, 0.5, 0.5, 0);
            }
            if ((text_selected == "flagship_name") && (text_bar <= 30)) {
                draw_text_transformed(644, 398, flagship_name + "|", 0.5, 0.5, 0);
            }
            if (scr_text_hit(644, 398, true, flagship_name)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked()) {
                    text_selected = "flagship_name";
                    keyboard_string = flagship_name;
                }
            }
            if (text_selected == "flagship_name") {
                flagship_name = keyboard_string;
            }
            draw_set_alpha(0.75);
            draw_rectangle(525, 398, 760, 418, 1);
            draw_set_alpha(1);
            var _refresh_fs_name_btn = [
                770,
                398,
                790,
                418,
            ];
            draw_unit_buttons(_refresh_fs_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_fs_name_btn)) {
                var _new_fs_name = global.name_generator.GenerateFromSet("imperial_ship");
                LOGGER.debug($"regen name of flagship_name from {flagship_name} to {_new_fs_name}");
                flagship_name = _new_fs_name;
            }
        }
    }

    if (fleet_type != ePLAYER_BASE.PENITENT) {
        right_data_slate.inside_method = player_recruit_planet_selection;
    } else {
        right_data_slate.inside_method = "";
    }

    right_data_slate.draw(1210, 5, 0.45, 1);

    if (recruiting_exists == 0 && homeworld_exists == 1) {
        scr_image("ui/planet", _cur_planet_index, 913, 244, 128, 128);

        draw_set_alpha(0.5);
        draw_text_transformed(977, 378, homeworld, 0.5, 0.5, 0);
        draw_text_transformed(977, 398, homeworld_name, 0.5, 0.5, 0);
        draw_set_alpha(1);
    }

    if (scr_hit(575, 216, 710, 242)) {
        if (fleet_type != ePLAYER_BASE.HOME_WORLD) {
            tooltip = "Battle Barge";
            tooltip2 = "The name of your Flagship Battle Barge.";
        } else if (fleet_type == ePLAYER_BASE.HOME_WORLD) {
            tooltip = "Homeworld";
            tooltip2 = "The world that your Chapter's Fortress Monastery is located upon.  More civilized worlds are more easily defensible but the citizens may pose a risk or be a nuisance.";
        }
    }
    if (scr_hit(895, 216, 1075, 242)) {
        tooltip = "Recruiting World";
        tooltip2 = "The world that your Chapter selects recruits from.  More harsh worlds provide recruits with more grit and warrior mentality.  If you are a homeworld-based Chapter, you may uncheck 'Recruiting World' to recruit from your homeworld instead.";
    }

    draw_line(445, 455, 1125, 455);
    draw_line(445, 456, 1125, 456);
    draw_line(445, 457, 1125, 457);

    draw_set_halign(fa_left);

    //TODO move to OOP checkboxes
    if (fleet_type == ePLAYER_BASE.HOME_WORLD) {
        if (custom != eCHAPTER_TYPE.CUSTOM) {
            draw_set_alpha(0.5);
        }
        var _homeworld_types = [
            {
                name: "Planetary Governer",
                tooltip: "Planetary Governer",
                tooltip2: "Your Chapter's homeworld is ruled by a single Planetary Governer, who does with the planet mostly as they see fit.  While heavily influenced by your Astartes the planet is sovereign.",
            },
            {
                name: "Passive Supervision",
                tooltip: "Passive Supervision",
                tooltip2: "Instead of a Planetary Governer the planet is broken up into many countries or clans.  The people are less united but happier, and see your illusive Astartes as semi-divine beings.",
            },
            {
                name: "Personal Rule",
                tooltip: "Personal Rule",
                tooltip2: "You personally take the rule of the Planetary Governer, ruling over your homeworld with an iron fist.  Your every word and directive, be they good or bad, are absolute law.",
            },
        ];
        draw_text_transformed(445, 480, "Homeworld Rule", 0.6, 0.6, 0);

        var _coords = [
            445,
            512,
        ];
        for (var i = 0; i < array_length(_homeworld_types); i++) {
            var _home_rule_type = _homeworld_types[i];
            var _draw_x = _coords[0];
            var _draw_y = _coords[1];
            var _cur_select = homeworld_rule == i + 1;
            draw_text_transformed(_draw_x + 40, _draw_y, _home_rule_type.name, 0.5, 0.5, 0);
            draw_sprite(spr_creation_check, _cur_select, _draw_x, _draw_y);
            if (scr_hit(_draw_x, _draw_y, _draw_x + 32, _draw_y + 32)) {
                tooltip = _home_rule_type.tooltip;
                tooltip2 = _home_rule_type.tooltip2;
                if (mouse_button_clicked() && custom == eCHAPTER_TYPE.CUSTOM) {
                    homeworld_rule = i + 1;
                }
            }
            _coords[1] += 45;
        }
    }
    pop_draw_return_values();
}
