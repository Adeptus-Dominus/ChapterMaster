//TODO make enum to store menu area codes
function scr_menu_clear_up(specific_area_function) {
    var spec_func = specific_area_function;
    with (obj_controller) {
        var menu_action_allowed = !instance_exists(obj_saveload) && !instance_exists(obj_drop_select) && !instance_exists(obj_popup_dialogue) && !instance_exists(obj_ncombat);

        if (menu_action_allowed) {
            if (combat != 0 || instance_exists(obj_bomb_select) || scrollbar_engaged != 0 || instance_exists(obj_ingame_menu)) {
                exit;
            }

            if (instance_exists(obj_turn_end) && !obj_controller.complex_event && (!instance_exists(obj_temp_meeting)) && array_length(obj_turn_end.audience_stack) == 0) {
                if ((obj_turn_end.popups_end == 1) && (audience == 0) && (cooldown <= 0)) {
                    with (obj_turn_end) {
                        instance_destroy();
                    }
                }
            }
            if ((zoomed == 0) && (cooldown <= 0) && (menu >= eMENU.WELCOME_SCREEN1) && (menu <= eMENU.WELCOME_SCREEN4)) {
                if (mouse_y >= camera_get_view_y(view_camera[0]) + 27) {
                    cooldown = 8000;
                    if ((menu >= eMENU.WELCOME_SCREEN1) && (temp[65 + (menu - 2)] == "")) {
                        menu = eMENU.DEFAULT;
                        exit;
                    }
                    if ((menu < eMENU.WELCOME_SCREEN4) && (menu != eMENU.DEFAULT)) {
                        menu += 1;
                    }
                }
            }

            if (menu == eMENU.DEFAULT) {
                hide_banner = 0;
            }

            if (instance_exists(obj_temp_build)) {
                if (obj_temp_build.isnew) {
                    exit;
                }
            }
            return spec_func();
        }
    }
}

function scr_change_menu(wanted_menu, specific_area_function = undefined) {
    var continue_sequence = false;
    if (obj_controller.menu_lock) {
        return false;
    }
    if (wanted_menu == obj_controller.menu) {
        main_map_defaults();
        return true;
    }
    with (obj_controller) {
        main_map_defaults();
        continue_sequence = scr_menu_clear_up(function() {
            return true;
        });
        if (continue_sequence) {
            with (obj_fleet_select) {
                instance_destroy();
            }
            if (close_popups) {
                with (obj_popup) {
                    instance_destroy();
                }
            }
            close_popups = true;
            if (is_callable(specific_area_function)) {
                specific_area_function();
            }
        }
    }
}

function main_map_defaults() {
    with (obj_controller) {
        menu = eMENU.DEFAULT;
        menu_lock = false;
        hide_banner = 0;
        location_viewer.update_garrison_log();
        managing = 0;
        managing = 0;
        menu_adept = 0;
        view_squad = false;
        unit_profile = false;
        force_goodbye = 0;
        hide_banner = 0;
        diplomacy = 0;
        audience = 0;
        zoomed = 0;
    }
}

function scr_in_game_help() {
    scr_change_menu(eMENU.GAME_HELP, function() {
        with (obj_controller) {
            if ((zoomed == 0) && (!instance_exists(obj_ingame_menu)) && (!instance_exists(obj_popup))) {
                set_zoom_to_default();
                if (menu != eMENU.GAME_HELP) {
                    menu = eMENU.GAME_HELP;
                    cooldown = 8000;
                    click = 1;
                    hide_banner = 0;
                    instance_activate_object(obj_event_log);
                    obj_event_log.top = 1;
                    obj_event_log.help = 1;
                }
            }
        }
    });
}

function scr_in_game_menu() {
    scr_change_menu(-1, function() {
        if ((!instance_exists(obj_ingame_menu)) && (!instance_exists(obj_popup)) && (!obj_controller.zoomed)) {
            // Main MENU
            set_zoom_to_default();
            instance_create(0, 0, obj_ingame_menu);
        }
    });
}

function basic_manage_settings() {
    with (obj_controller) {
        menu = eMENU.MANAGE;
        popup = 0;
        selected = 0;
        diplomacy = 0;
        allow_shortcuts = true;

        init_manage_buttons();
    }
}

function init_manage_buttons() {
    management_buttons = {
        squad_toggle: new UnitButtonObject({
            style: "pixel",
            label: "Squad View",
            tooltip: "Click here or press S to toggle Squad View.",
        }),
        profile_toggle: new UnitButtonObject({
            style: "pixel",
            label: "Show Profile",
            tooltip: "Click here or press P to show unit profile.",
        }),
        bio_toggle: new UnitButtonObject({
            style: "pixel",
            label: "Show Bio",
            tooltip: "Click here or press B to Toggle Unit Biography.",
        }),
        capture_image: new UnitButtonObject({
            style: "pixel",
            label: "Capture Image",
            tooltip: "Click to create a local png of the given marine in the game folder.",
        }),
        company_namer: new TextBarArea(800, 98, 600, false),
    };
}

function scr_toggle_manage() {
    scr_change_menu(eMENU.MANAGE, function() {
        with (obj_controller) {
            if (menu != eMENU.MANAGE) {
                set_zoom_to_default();
                hide_banner = 1;
                basic_manage_settings();
                scr_management(1);
            }
        }
    });
}

function scr_toggle_setting() {
    scr_change_menu(eMENU.SETTINGS, function() {
        with (obj_controller) {
            if (menu != eMENU.SETTINGS) {
                set_zoom_to_default();
                menu = eMENU.SETTINGS;
                popup = 0;
                selected = 0;
                hide_banner = 1;
                try {
                    setup_ui_chapter_settings();
                } catch (_exception) {
                    ERROR_HANDLER.handle_exception(_exception);
                    scr_toggle_setting();
                }
            } else if (settings) {
                menu = eMENU.SETTINGS;
                setup_ui_chapter_settings();
                cooldown = 8000;
                click = 1;
                settings = 0;
            }
        }
    });
}

function scr_toggle_apothecarion() {
    scr_change_menu(eMENU.APOTHECARION, function() {
        with (obj_controller) {
            set_zoom_to_default();
            menu_adept = 0;
            hide_banner = 1;
            if (scr_role_count("Master of the Apothecarion", "0") == 0) {
                menu_adept = 1;
            }
            if (menu != eMENU.APOTHECARION) {
                menu = eMENU.APOTHECARION;

                temp[36] = scr_role_count(obj_ini.role[100][15], "");
            }
        }
    });
}

function scr_toggle_reclu() {
    scr_change_menu(eMENU.RECLUSIAM, function() {
        with (obj_controller) {
            set_zoom_to_default();
            menu_adept = 0;
            hide_banner = 1;
            if (scr_role_count("Master of Sanctity", "0") == 0) {
                menu_adept = 1;
            }
            if (menu != eMENU.RECLUSIAM) {
                menu = eMENU.RECLUSIAM;

                temp[36] = string(scr_role_count(obj_ini.role[100][14], "field"));
                temp[37] = string(scr_role_count(obj_ini.role[100][14], "home"));
                penitorium = 0;

                // Get list of jailed marines
                var p = 0;
                for (var c = 0; c < 11; c++) {
                    for (var e = 0; e < array_length(obj_ini.god[c]); e++) {
                        if (obj_ini.god[c][e] == 10) {
                            p += 1;
                            penit_co[p] = c;
                            penit_id[p] = e;
                            penitorium += 1;
                        }
                    }
                }
            }
        }
    });
}

function scr_toggle_lib() {
    scr_change_menu(eMENU.LIBRARIUM, function() {
        with (obj_controller) {
            set_zoom_to_default();
            var xx = camera_get_view_x(view_camera[0]);
            var yy = camera_get_view_y(view_camera[0]);
            menu_adept = 0;
            hide_banner = 1;
            if (scr_role_count("Chief " + string(obj_ini.role[100][17]), "0") == 0) {
                menu_adept = 1;
            }
            if (menu != eMENU.LIBRARIUM) {
                menu = eMENU.LIBRARIUM;

                if ((artifacts > 0) && (menu_artifact == 0)) {
                    menu_artifact = 1;
                }
                temp[36] = scr_role_count(obj_ini.role[100][17], "");
                temp[37] = scr_role_count("Codiciery", "");
                temp[38] = scr_role_count("Lexicanum", "");
                artifact_equip = new ShutterButton();
                artifact_gift = new ShutterButton();
                artifact_destroy = new ShutterButton();
                artifact_namer = new TextBarArea(xx + 622, yy + 460, 350);
                set_chapter_arti_data();
                artifact_slate = new DataSlate({
                    set_width: true,
                    XX: 392,
                    YY: 500,
                    width: 460,
                    height: 240,
                });
            }
        }
    });
}

function scr_toggle_armamentarium() {
    scr_change_menu(eMENU.ARMAMENTARIUM, function() {
        with (obj_controller) {
            if (menu != eMENU.ARMAMENTARIUM) {
                set_zoom_to_default();
                if (scr_role_count("Forge Master", "0") == 0) {
                    menu_adept = 1;
                }
                menu = eMENU.ARMAMENTARIUM;
                hide_banner = 1;
                armamentarium.refresh_catalog();
            }
        }
    });
}

function scr_toggle_recruiting() {
    scr_change_menu(eMENU.RECRUITING, function() {
        with (obj_controller) {
            if (menu != eMENU.RECRUITING) {
                set_zoom_to_default();
                set_up_recruitment_view();
                hide_banner = 1;
            }
        }
    });
}

function scr_toggle_fleet_area() {
    scr_change_menu(eMENU.FLEET, function() {
        with (obj_controller) {
            set_zoom_to_default();
            menu_adept = 0;
            if (menu != eMENU.FLEET) {
                hide_banner = 1;
                //TODO rewrite all this shit when fleets finally become OOP
                menu = eMENU.FLEET;

                cooldown = 8000;
                click = 1;
                for (var i = 37; i <= 41; i++) {
                    temp[i] = "";
                }

                for (var i = 101; i < 120; i++) {
                    temp[i] = "";
                }

                var _ship_index = 0;
                var _hp_percent = 0;
                var _total_ships = 0;
                var _crippled_ships = 0;
                temp[37] = 0;
                temp[38] = 0;
                temp[39] = 0;
                for (var i = 0; i < array_length(obj_ini.ship); i++) {
                    if (obj_ini.ship[i] != "") {
                        if (obj_ini.ship_size[i] == 3) {
                            temp[37]++;
                        }
                        if (obj_ini.ship_size[i] == 2) {
                            temp[38]++;
                        }
                        if (obj_ini.ship_size[i] == 1) {
                            temp[39]++;
                        }
                    }
                }

                temp[41] = "1";
                for (var i = 0; i < array_length(obj_ini.ship); i++) {
                    if ((_ship_index != 0) && (obj_ini.ship[i] != "")) {
                        if ((obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i]) < _hp_percent) {
                            _ship_index = i;
                            _hp_percent = obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i];
                        }
                    }
                    if ((_ship_index == 0) && (obj_ini.ship[i] != "")) {
                        _ship_index = i;
                        _hp_percent = obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i];
                    }
                    if (obj_ini.ship[i] != "") {
                        _total_ships = i;
                    }
                    if ((obj_ini.ship[i] != "") && ((obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i]) < 0.25)) {
                        _crippled_ships += 1;
                    }
                }
                if (_ship_index != 0) {
                    temp[40] = string(obj_ini.ship_class[_ship_index]) + " '" + string(obj_ini.ship[_ship_index]) + "'";
                    temp[41] = string(_hp_percent);
                    temp[42] = string(_crippled_ships);
                }
                man_max = _total_ships;
                man_current = 0;
            }
        }
    });
}

function scr_toggle_diplomacy() {
    scr_change_menu(eMENU.DIPLOMACY, function() {
        with (obj_controller) {
            if (menu != eMENU.DIPLOMACY) {
                set_zoom_to_default();
                set_up_diplomacy_buttons();
                menu = eMENU.DIPLOMACY;
                audience = 0;
                diplomacy = 0;
                hide_banner = 1;
                character_diplomacy = false;
                LOGGER.debug("set_diplo");
            }
        }
    });
}

function scr_toggle_event_log() {
    scr_change_menu(eMENU.EVENT_LOG, function() {
        with (obj_controller) {
            if (menu != eMENU.EVENT_LOG) {
                set_zoom_to_default();
                menu = eMENU.EVENT_LOG;

                hide_banner = 1;
                instance_activate_object(obj_event_log);
                obj_event_log.top = 1;
            }
        }
    });
}

function scr_end_turn() {
    if (instance_exists(obj_turn_end)) {
        return false;
    }
    scr_change_menu(-1, function() {
        with (obj_controller) {
            if ((menu == eMENU.DEFAULT) && (cooldown <= 0)) {
                if (location_viewer.hide_sequence == 0) {
                    location_viewer.hide_sequence++;
                }
                cooldown = 8;
                menu = eMENU.DEFAULT;

                if (!instance_exists(obj_turn_end)) {
                    obj_controller.menu = eMENU.DEFAULT;
                    obj_controller.zui = 0;
                    obj_controller.invis = false;

                    // Autosave every 10 turns
                    if (global.settings.autosave && obj_controller.turn % 10 == 0) {
                        scr_autosave();
                    }
                    obj_controller.end_turn_insights = {};
                    with (obj_turn_end) {
                        instance_destroy();
                    }
                    with (obj_star_event) {
                        instance_destroy();
                    }
                    audio_play_sound(snd_end_turn, -50, false);

                    turn += 1;
                    with (obj_star) {
                        present_fleet[20] = 0;
                    }
                    with (obj_p_fleet) {
                        if ((action == "move") && (obj_controller.faction_status[eFACTION.IMPERIUM] == "War")) {
                            var him = instance_nearest(action_x, action_y, obj_star);
                            if (point_distance(action_x, action_y, him.x, him.y) < 10) {
                                him.present_fleet[20] = 1;
                            }
                        }
                    }
                    with (obj_en_fleet) {
                        if ((action == "move") && (owner > 5)) {
                            var him = instance_nearest(action_x, action_y, obj_star);
                            if (point_distance(action_x, action_y, him.x, him.y) < 10) {
                                him.present_fleet[20] = 1;
                            }
                        }
                    }

                    if (instance_exists(obj_p_fleet)) {
                        obj_p_fleet.alarm[1] = 1;
                    }
                    if (instance_exists(obj_en_fleet)) {
                        obj_en_fleet.alarm[1] = 1;
                    }
                    if (instance_exists(obj_crusade)) {
                        obj_crusade.alarm[0] = 2;
                    }

                    player_forge_data.player_forges = 0;
                    player_forge_data.vehicle_hanger = [];
                    requisition += income;
                    scr_income();
                    gene_tithe -= 1;

                    // Do that after the combats and all of that crap
                    with (obj_star) {
                        ai_a = 2;
                        ai_b = 3;
                        ai_c = 4;
                        ai_d = 5;
                        ai_e = 5;
                        if (p_type[1] == "Craftworld") {
                            instance_deactivate_object(id);
                        }
                    }
                    alarm[5] = 6;
                    instance_create(0, 0, obj_turn_end);
                    scr_turn_first();
                }
            }
        }
    });
}
