function role_data_set() {
    return {
        role: "",
        wep1: "",
        wep2: "",
        armour: "",
        mobi: "",
        gear: "",
        available_to_player: false,
    };
}

function setup_default_gears() {
    default_role_data = [];
    load_default_gear = function(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear) {
        default_role_data[_role_id] = {
            role: _role_name,
            wep1: _wep1,
            wep2: _wep2,
            armour: _armour,
            mobi: _mobi,
            gear: _gear,
            available_to_player: true,
        };
    };

    load_default_gear(eROLE.CHAPTERMASTER, "Chapter Master", "Power Sword", "Bolter", "Artificer Armour", "", "");
    load_default_gear(eROLE.HONOURGUARD, "Honour Guard", "Power Sword", "Bolter", "Artificer Armour", "", "");
    load_default_gear(eROLE.VETERAN, "Veteran", "Combiflamer", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
    load_default_gear(eROLE.TERMINATOR, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
    load_default_gear(eROLE.CAPTAIN, "Captain", "Power Sword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Iron Halo");
    load_default_gear(eROLE.DREADNOUGHT, "Dreadnought", "Dreadnought Lightning Claw", "Twin Linked Lascannon", "Dreadnought", "", "");
    load_default_gear(eROLE.CHAMPION, "Champion", "Power Sword", STR_ANY_POWER_ARMOUR, STR_ANY_POWER_ARMOUR, "", "Combat Shield");
    load_default_gear(eROLE.TACTICAL, "Tactical", "Bolter", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
    load_default_gear(eROLE.DEVASTATOR, "Devastator", "", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
    load_default_gear(eROLE.ASSAULT, "Assault", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "Jump Pack", "");
    load_default_gear(eROLE.ANCIENT, "Ancient", "Company Standard", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
    load_default_gear(eROLE.SCOUT, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
    load_default_gear(eROLE.CHAPLAIN, "Chaplain", "Crozius Arcanum", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Rosarius");
    load_default_gear(eROLE.APOTHECARY, "Apothecary", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Narthecium");
    load_default_gear(eROLE.TECHMARINE, "Techmarine", "Power Axe", "Bolt Pistol", "Artificer Armour", "Servo-arm", "");
    load_default_gear(eROLE.LIBRARIAN, "Librarian", "Force Staff", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Psychic Hood");
    load_default_gear(eROLE.SERGEANT, "Sergeant", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
    load_default_gear(eROLE.VETERANSERGEANT, "Veteran Sergeant", "Chainsword", "Plasma Pistol", STR_ANY_POWER_ARMOUR, "", "");

    for (var i = 0; i < array_length(default_role_data); i++) {
        if (default_role_data[i] == 0) {
            default_role_data[i] = role_data_set();
        }
    }

    return default_role_data;
}

function update_role_data_wth_defaults() {
    for (var i = 0; i < array_length(player_role_data); i++) {
        var _role_data = player_role_data[i];
        var _default_data = default_role_data[i];
        var _keys = global.role_data_keys;
        for (var k = 0; k < array_length(_keys); k++) {
            var _key = _keys[k];
            var _set_with_default = false;
            if (!struct_exists(_role_data, _key)) {
                _set_with_default = true;
            } else {
                var _val = _role_data[$ _key];
                if (_val == "" || _val == "default") {
                    _set_with_default = true;
                }
            }
            if (_set_with_default == true) {
                _role_data[$ _key] = variable_clone(_default_data[$ _key]);
            }
        }
    }
}

/// @self Asset.GMObject.obj_creation
function role_setup_objects() {
    specialist_distribution_box = new ToggleButton({
        str1: "Equal Specialist Distribution",
        font: fnt_40k_12,
        style: "box",
        x1: 500,
        y1: 250,
        tooltip: {
            text: "Specialist Distribution\nCheck if you wish for your Companies to be uniform and each contain {0}s and {1}s.",
            variables: [localize(player_role_data[eROLE.ASSAULT].role), localize(player_role_data[eROLE.DEVASTATOR].role)],
        },
        active: (squad_distribution == 1 || squad_distribution == 3),
        clicked_check_default: true,
    });
    scout_distribution_box = new ToggleButton({
        str1: "Equal Scout Distribution",
        font: fnt_40k_12,
        style: "box",
        x1: 710,
        y1: 250,
        tooltip: "Scout Distribution\nCheck if you wish for Scouts to be distributed equally across your Battle Companies rather than concentrated in the 10th.",
        active: (squad_distribution == 2 || squad_distribution == 3),
        clicked_check_default: true,
    });

    load_to_ship_radio = new RadioSet([
        {
            str1: "On Planet",
            font: fnt_40k_12,
            style: "box",
            tooltip: "On Planet\nCheck to have your Astartes Start on your home planet.",
        },
        {
            str1: "Load to Ships",
            font: fnt_40k_12,
            style: "box",
            tooltip: "Load to Ships\nCheck to have your Astartes automatically loaded into ships when the game starts.",
        },
        {
            str1: "Load (Sans Escorts)",
            font: fnt_40k_12,
            style: "box",
            tooltip: "Load (Sans Escorts)\nCheck to have your Astartes automatically loaded into ships, except for Escorts, when the game starts.",
        },
    ], "", {
        x1: 445,
        y1: 310,
        x_gap: 20,
        center: true,
        max_width: 400,
    });
    load_to_ship_radio.current_selection = load_to_ships[0];
    distribute_scouts_box = new ToggleButton({
        str1: "Distribute Scouts",
        font: fnt_40k_12,
        style: "box",
        x1: 540,
        y1: 370,
        tooltip: "Distribute Scouts\nCheck to have your Scouts split across ships in the fleet.",
        active: load_to_ships[1],
        clicked_check_default: true,
    });
    distribute_vets_box = new ToggleButton({
        str1: "Distribute Veterans",
        font: fnt_40k_12,
        style: "box",
        x1: 690,
        y1: 370,
        tooltip: "Distribute Veterans\nCheck to have your Veterans split across the fleet.",
        active: load_to_ships[2],
        clicked_check_default: true,
    });
}

/// @self Asset.GMObject.obj_creation
function scr_distribution_and_advisor_setup() {
    specialist_distribution_box.update( 
        {x1: 475,
        y1: 230}
    );
    specialist_distribution_box.draw(squad_distribution == 1 || squad_distribution == 3);
    scout_distribution_box.update({y1:specialist_distribution_box.y1, x1 :specialist_distribution_box.x1 + 210});
    scout_distribution_box.draw(squad_distribution == 2 || squad_distribution == 3);
    squad_distribution = (specialist_distribution_box.active ? 1 : 0) + (scout_distribution_box.active ? 2 : 0);

    load_to_ship_radio.draw();

    load_to_ships[0] = load_to_ship_radio.current_selection;

    if (load_to_ships[0] > 0) {
        distribute_scouts_box.update();
        distribute_scouts_box.draw(load_to_ships[1]);
        load_to_ships[1] = distribute_scouts_box.active;

        distribute_vets_box.update();
        distribute_vets_box.draw(load_to_ships[2]);
        load_to_ships[2] = distribute_vets_box.active;
    }
    draw_set_halign(fa_left);
    if (scr_hit(540, 547, 800, 725)) {
        tooltip = localize("Advisor Names");
        tooltip2 = localize("The names of your main Advisors.  They provide useful information and reports on the divisions of your Chapter.");
    }

    draw_text_transformed(444, 550, string_hash_to_newline(localize("Advisor Names")), 0.6, 0.6, 0);
    draw_set_font(cjk_font(fnt_40k_14b));
    draw_set_halign(fa_right);
    var _apoths_allowed = player_role_data[eROLE.APOTHECARY].available_to_player;
    var _chaps_allowed = player_role_data[eROLE.CHAPLAIN].available_to_player;
    var _libs_allowed = player_role_data[eROLE.LIBRARIAN].available_to_player;
    var _techs_allowed = player_role_data[eROLE.TECHMARINE].available_to_player;

    if (_apoths_allowed) {
        draw_text(594, 575, localize("Chief Apothecary: "));
    }
    if (player_role_data[eROLE.CHAPLAIN].available_to_player) {
        draw_text(594, 597, localize("High Chaplain: "));
    }
    if (player_role_data[eROLE.LIBRARIAN].available_to_player) {
        draw_text(594, 619, localize("Chief Librarian: "));
    }
    if (player_role_data[eROLE.TECHMARINE].available_to_player) {
        draw_text(594, 641, localize("Forge Master: "));
    }
    draw_text(594, 663, localize("Master of Recruits: "));
    draw_text(594, 685, localize("Master of the Fleet: "));
    draw_set_halign(fa_left);

    if (_apoths_allowed) {
        draw_set_color(CM_GREEN_COLOR);
        if (hapothecary == "") {
            draw_set_color(c_red);
        }
        if ((text_selected != "apoth") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_ext(600, 575, string_hash_to_newline(string(hapothecary)), -1, 580);
        }
        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if ((text_selected == "capoth") && (text_bar > 30)) {
                draw_text_ext(600, 575, string_hash_to_newline(string(hapothecary)), -1, 580);
            }
            if ((text_selected == "capoth") && (text_bar <= 30)) {
                draw_text_ext(600, 575, string_hash_to_newline(string(hapothecary) + "|"), -1, 580);
            }
            var str_width, hei;
            str_width = 0;
            hei = string_height_ext(string_hash_to_newline(hapothecary), -2, 580);
            if (scr_hit(600, 575, 785, 575 + hei)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                    text_selected = "capoth";
                    keyboard_string = hapothecary;
                }
            }
            if (text_selected == "capoth") {
                hapothecary = keyboard_string;
            }
            draw_rectangle(600 - 1, 575 - 1, 785, 575 + hei, 1);

            var _refresh_capoth_name_btn = [
                794,
                574,
                794 + 20,
                574 + 20,
            ];
            draw_unit_buttons(_refresh_capoth_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_capoth_name_btn)) {
                var _new_capoth_name = global.name_generator.GenerateFromSet("space_marine");
                LOGGER.debug($"regen name of hapothecary from {hapothecary} to {_new_capoth_name}");
                hapothecary = _new_capoth_name;
            }
        }
    }

    if (_chaps_allowed) {
        draw_set_color(CM_GREEN_COLOR);
        if (hchaplain == "") {
            draw_set_color(c_red);
        }
        if ((text_selected != "chap") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_ext(600, 597, string_hash_to_newline(string(hchaplain)), -1, 580);
        }
        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if ((text_selected == "chap") && (text_bar > 30)) {
                draw_text_ext(600, 597, string_hash_to_newline(string(hchaplain)), -1, 580);
            }
            if ((text_selected == "chap") && (text_bar <= 30)) {
                draw_text_ext(600, 597, string_hash_to_newline(string(hchaplain) + "|"), -1, 580);
            }
            var str_width, hei;
            str_width = 0;
            hei = string_height_ext(string_hash_to_newline(hchaplain), -2, 580);
            if (scr_hit(600, 597, 785, 597 + hei)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                    text_selected = "chap";
                    keyboard_string = hchaplain;
                }
            }
            if (text_selected == "chap") {
                hchaplain = keyboard_string;
            }
            draw_rectangle(600 - 1, 597 - 1, 785, 597 + hei, 1);

            var _refresh_chap_name_btn = [
                794,
                597,
                794 + 20,
                597 + 20,
            ];
            draw_unit_buttons(_refresh_chap_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_chap_name_btn)) {
                var _new_chap_name = global.name_generator.GenerateFromSet("space_marine");
                LOGGER.debug($"regen name of hchaplain from {hchaplain} to {_new_chap_name}");
                hchaplain = _new_chap_name;
            }
        }
    }

    if (_libs_allowed) {
        draw_set_color(CM_GREEN_COLOR);
        if (clibrarian == "") {
            draw_set_color(c_red);
        }
        if ((text_selected != "libra") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_ext(600, 619, string_hash_to_newline(string(clibrarian)), -1, 580);
        }
        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if ((text_selected == "libra") && (text_bar > 30)) {
                draw_text_ext(600, 619, string_hash_to_newline(string(clibrarian)), -1, 580);
            }
            if ((text_selected == "libra") && (text_bar <= 30)) {
                draw_text_ext(600, 619, string_hash_to_newline(string(clibrarian) + "|"), -1, 580);
            }
            var str_width, hei;
            str_width = 0;
            hei = string_height_ext(string_hash_to_newline(clibrarian), -2, 580);
            if (scr_hit(600, 619, 785, 619 + hei)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                    text_selected = "libra";
                    keyboard_string = clibrarian;
                }
            }
            if (text_selected == "libra") {
                clibrarian = keyboard_string;
            }
            draw_rectangle(600 - 1, 619 - 1, 785, 619 + hei, 1);

            var _refresh_libra_name_btn = [
                794,
                619,
                794 + 20,
                619 + 20,
            ];
            draw_unit_buttons(_refresh_libra_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_libra_name_btn)) {
                var _new_libra_name = global.name_generator.GenerateFromSet("space_marine");
                LOGGER.debug($"regen name of clibrarian from {clibrarian} to {_new_libra_name}");
                clibrarian = _new_libra_name;
            }
        }
    }

    if (_techs_allowed) {
        draw_set_color(CM_GREEN_COLOR);
        if (fmaster == "") {
            draw_set_color(c_red);
        }
        if ((text_selected != "forge") || (custom != eCHAPTER_TYPE.CUSTOM)) {
            draw_text_ext(600, 641, string_hash_to_newline(string(fmaster)), -1, 580);
        }
        if (custom == eCHAPTER_TYPE.CUSTOM) {
            if ((text_selected == "forge") && (text_bar > 30)) {
                draw_text_ext(600, 641, string_hash_to_newline(string(fmaster)), -1, 580);
            }
            if ((text_selected == "forge") && (text_bar <= 30)) {
                draw_text_ext(600, 641, string_hash_to_newline(string(fmaster) + "|"), -1, 580);
            }
            var str_width, hei;
            str_width = 0;
            hei = string_height_ext(string_hash_to_newline(fmaster), -2, 580);
            if (scr_hit(600, 641, 785, 641 + hei)) {
                obj_cursor.image_index = 2;
                if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                    text_selected = "forge";
                    keyboard_string = fmaster;
                }
            }
            if (text_selected == "forge") {
                fmaster = keyboard_string;
            }
            draw_rectangle(600 - 1, 641 - 1, 785, 641 + hei, 1);

            var _refresh_forge_name_btn = [
                794,
                641,
                794 + 20,
                641 + 20,
            ];
            draw_unit_buttons(_refresh_forge_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
            if (point_and_click(_refresh_forge_name_btn)) {
                var _new_forge_name = global.name_generator.GenerateFromSet("space_marine");
                LOGGER.debug($"regen name of fmaster from {fmaster} to {_new_forge_name}");
                text_selected = "";
                fmaster = _new_forge_name;
            }
        }
    }

    draw_set_color(CM_GREEN_COLOR);
    if (recruiter == "") {
        draw_set_color(c_red);
    }
    if ((text_selected != "recr") || (custom != eCHAPTER_TYPE.CUSTOM)) {
        draw_text_ext(600, 663, string_hash_to_newline(string(recruiter)), -1, 580);
    }
    if (custom == eCHAPTER_TYPE.CUSTOM) {
        if ((text_selected == "recr") && (text_bar > 30)) {
            draw_text_ext(600, 663, string_hash_to_newline(string(recruiter)), -1, 580);
        }
        if ((text_selected == "recr") && (text_bar <= 30)) {
            draw_text_ext(600, 663, string_hash_to_newline(string(recruiter) + "|"), -1, 580);
        }
        var str_width, hei;
        str_width = 0;
        hei = string_height_ext(string_hash_to_newline(recruiter), -2, 580);
        if (scr_hit(600, 663, 785, 663 + hei)) {
            obj_cursor.image_index = 2;
            if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                text_selected = "recr";
                keyboard_string = recruiter;
            }
        }
        if (text_selected == "recr") {
            recruiter = keyboard_string;
        }
        draw_rectangle(600 - 1, 663 - 1, 785, 663 + hei, 1);

        var _refresh_recr_name_btn = [
            794,
            663,
            794 + 20,
            663 + 20,
        ];
        draw_unit_buttons(_refresh_recr_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
        if (point_and_click(_refresh_recr_name_btn)) {
            var _new_recr_name = global.name_generator.GenerateFromSet("space_marine");
            LOGGER.debug($"regen name of recruiter from {recruiter} to {_new_recr_name}");
            recruiter = _new_recr_name;
        }
    }

    draw_set_color(CM_GREEN_COLOR);
    if (admiral == "") {
        draw_set_color(c_red);
    }
    if ((text_selected != "admi") || (custom != eCHAPTER_TYPE.CUSTOM)) {
        draw_text_ext(600, 685, string_hash_to_newline(string(admiral)), -1, 580);
    }
    if (custom == eCHAPTER_TYPE.CUSTOM) {
        if ((text_selected == "admi") && (text_bar > 30)) {
            draw_text_ext(600, 685, string_hash_to_newline(string(admiral)), -1, 580);
        }
        if ((text_selected == "admi") && (text_bar <= 30)) {
            draw_text_ext(600, 685, string_hash_to_newline(string(admiral) + "|"), -1, 580);
        }
        var str_width, hei;
        str_width = 0;
        hei = string_height_ext(string_hash_to_newline(admiral), -2, 580);
        if (scr_hit(600, 685, 785, 685 + hei)) {
            obj_cursor.image_index = 2;
            if (mouse_button_clicked() && (!instance_exists(obj_creation_popup))) {
                text_selected = "admi";
                keyboard_string = admiral;
            }
        }
        if (text_selected == "admi") {
            admiral = keyboard_string;
        }
        draw_rectangle(600 - 1, 685 - 1, 785, 685 + hei, 1);

        var _refresh_admi_name_btn = [
            794,
            685,
            794 + 20,
            685 + 20,
        ];
        draw_unit_buttons(_refresh_admi_name_btn, "?", [1, 1], CM_GREEN_COLOR,, fnt_40k_14b);
        if (point_and_click(_refresh_admi_name_btn)) {
            var _new_admi_name = global.name_generator.GenerateFromSet("space_marine");
            LOGGER.debug($"regen name of admiral from {admiral} to {_new_admi_name}");
            admiral = _new_admi_name;
        }
    }
}

/// @self Asset.GMObject.obj_creation
function scr_role_setup() {
    add_draw_return_values();

    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);

    roles_radio.current_selection = -1;
    draw_text_color_simple(800, 80, localize("Roles"), CM_GREEN_COLOR);
    if (!instance_exists(obj_creation_popup)) {
        roles_radio.update({y1: 150});
        roles_radio.draw();
        if (roles_radio.changed) {
            instance_destroy(obj_creation_popup);
            var _data = {
                target_role : roles_radio.selection_val("role_id"),
                type : ePOPUP_TYPE.EQUIP
            }
            instance_create_depth(0, 0,-55, obj_creation_popup, _data);
            LOGGER.info($"{obj_creation_popup.target_role}")
        }
    }
    draw_set_color(CM_GREEN_COLOR);
    draw_set_alpha(1);
    draw_set_font(cjk_font(fnt_40k_30b));

    if (custom != eCHAPTER_TYPE.CUSTOM) {
        draw_set_alpha(0.5);
    }

    draw_line(433, 535, 844, 535);
    draw_line(433, 536, 844, 536);
    draw_line(433, 537, 844, 537);

    if (!instance_exists(obj_creation_popup)) {
        scr_distribution_and_advisor_setup();
    }
    pop_draw_return_values();
}
