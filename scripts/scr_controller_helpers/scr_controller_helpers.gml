//TODO make enum to store menu area codes
function scr_menu_clear_up(specific_area_function) {
    var spec_func = specific_area_function;
    with (obj_controller) {
        var menu_action_allowed = action_if_number(obj_saveload, 0, 0) && action_if_number(obj_drop_select, 0, 0) && action_if_number(obj_popup_dialogue, 0, 0) && action_if_number(obj_ncombat, 0, 0);

        if (menu_action_allowed) {
            if (combat != 0) {
                exit;
            }
            if (scrollbar_engaged != 0) {
                exit;
            }
            if (instance_exists(obj_ingame_menu)) {
                exit;
            }

            if (instance_exists(obj_turn_end) && (obj_controller.complex_event != true) && (!instance_exists(obj_temp_meeting)) && array_length(obj_turn_end.audience_stack) == 0) {
                if ((obj_turn_end.popups_end == 1) && (audience == 0) && (cooldown <= 0)) {
                    with (obj_turn_end) {
                        instance_destroy();
                    }
                }
            }
            if (instance_exists(obj_bomb_select)) {
                exit;
            }
            if ((zoomed == 0) && (cooldown <= 0) && (menu >= 500) && (menu <= 510)) {
                if (mouse_y >= __view_get(e__VW.YView, 0) + 27) {
                    cooldown = 8000;
                    if ((menu >= 500) && (temp[menu - 434] == "")) {
                        menu = 0;
                        exit;
                    }
                    if ((menu < 503) && (menu != 0)) {
                        menu += 1;
                    }
                }
            }

            /*if (menu >= 500 && array_length(obj_turn_end.audience_stack) == 0) {
                exit;
            }*/

            diyst = 999;
            xx = __view_get(e__VW.XView, 0);
            yy = __view_get(e__VW.YView, 0);

            if (menu == 0) {
                hide_banner = 0;
            } // 136 ;

            if (instance_exists(obj_temp_build)) {
                if (obj_temp_build.isnew == 1) {
                    exit;
                }
            }
            return spec_func();
        }
    }
    return false;
}

function scr_change_menu(wanted_menu, specific_area_function = false) {
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
        set_zoom_to_default();
        continue_sequence = scr_menu_clear_up(function() {
            //if ((zoomed == 0) && (diplomacy == 0)) {
            return true;
            //}
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
                if (menu != 30) {
                    menu = 30;
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
        squad_toggle: new UnitButtonObject({style: "pixel", label: "Squad View", tooltip: "Click here or press S to toggle Squad View."}),
        profile_toggle: new UnitButtonObject({style: "pixel", label: "Show Profile", tooltip: "Click here or press P to show unit profile."}),
        bio_toggle: new UnitButtonObject({style: "pixel", label: "Show Bio", tooltip: "Click here or press B to Toggle Unit Biography."}),
        capture_image: new UnitButtonObject({style: "pixel", label: "Capture Image", tooltip: "Click to create a local png of the given marine in the game folder."}),
        company_namer: new TextBarArea(800, 98, 600, false),
    };
}

function scr_toggle_manage() {
    scr_change_menu(eMENU.MANAGE, function() {
        with (obj_controller) {
            if (menu != eMENU.MANAGE) {
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
                menu = eMENU.SETTINGS;
                popup = 0;
                selected = 0;
                hide_banner = 1;
            } else if (settings) {
                menu = eMENU.SETTINGS;
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
                artifact_slate = new DataSlate({set_width: true, XX: 392, YY: 500, width: 460, height: 240});
            }
        }
    });
}

function scr_toggle_armamentarium() {
    scr_change_menu(eMENU.ARMAMENTARIUM, function() {
        with (obj_controller) {
            if (menu != eMENU.ARMAMENTARIUM) {
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
            var geh = 0, good = 0;
            for (geh = 1; geh <= 50; geh++) {
                geh += 1;
                if (good == 0) {
                    if ((obj_ini.role[10][geh] == obj_ini.role[100][5]) && (obj_ini.name[10][geh] == obj_ini.recruiter_name)) {
                        good = geh;
                    }
                }
            }

            if (menu != eMENU.RECRUITING) {
                set_up_recruitment_view();
                hide_banner = 1;
            }
        }
    });
}

function scr_toggle_fleet_area() {
    scr_change_menu(eMENU.FLEET, function() {
        with (obj_controller) {
            menu_adept = 0;
            var geh = 0, good = 0;
            for (geh = 1; geh <= 50; geh++) {
                if (good == 0) {
                    if ((obj_ini.role[4][geh] == obj_ini.role[100][5]) && (obj_ini.name[10][geh] == obj_ini.lord_admiral_name)) {
                        good = geh;
                    }
                }
            }
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

                var g = 0, u = 0, m = 0, d = 0;
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

                g = 0;
                temp[41] = "1";
                for (var i = 0; i < array_length(obj_ini.ship); i++) {
                    if ((g != 0) && (obj_ini.ship[i] != "")) {
                        if ((obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i]) < u) {
                            g = i;
                            u = obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i];
                        }
                    }
                    if ((g == 0) && (obj_ini.ship[i] != "")) {
                        g = i;
                        u = obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i];
                    }
                    if (obj_ini.ship[i] != "") {
                        m = i;
                    }
                    if ((obj_ini.ship[i] != "") && ((obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i]) < 0.25)) {
                        d += 1;
                    }
                }
                if (g != 0) {
                    temp[40] = string(obj_ini.ship_class[g]) + " '" + string(obj_ini.ship[g]) + "'";
                    temp[41] = string(u);
                    temp[42] = string(d);
                }
                man_max = m;
                man_current = 0;
            }
        }
    });
}

function scr_toggle_diplomacy() {
    scr_change_menu(eMENU.DIPLOMACY, function() {
        with (obj_controller) {
            if (menu != eMENU.DIPLOMACY) {
                set_up_diplomacy_buttons();
                menu = eMENU.DIPLOMACY;
                audience = 0;
                diplomacy = 0;
                hide_banner = 1;
                character_diplomacy = false;
                global.logger.debug("set_diplo");
            }
        }
    });
}

function scr_toggle_event_log() {
    scr_change_menu(eMENU.EVENT_LOG, function() {
        with (obj_controller) {
            if (menu != eMENU.EVENT_LOG) {
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
                menu = 0;

                if (!instance_exists(obj_turn_end)) {
                    ok = 1;
                }
                /*if (instance_exists(obj_turn_end)) {
                    if (obj_turn_end.popups_end == 1) {
                        ok = 1;
                    }
                }*/

                if (ok == 1) {
                    if (settings_autosave == true) {
                        // Autosave
                        if (obj_controller.turn % 10 == 0) {
                            // save every 10 turns
                            if (!instance_exists(obj_saveload)) {
                                instance_create(0, 0, obj_saveload);
                            }
                            obj_saveload.autosaving = true;
                            scr_save(0, 0, true);
                            obj_controller.menu = 0;
                            obj_controller.zui = 0;
                            obj_controller.invis = false;
                            with (obj_saveload) {
                                instance_destroy();
                            }
                        }
                    }
                    obj_controller.end_turn_insights = {};
                    with (obj_turn_end) {
                        instance_destroy();
                    }
                    with (obj_star_event) {
                        instance_destroy();
                    }
                    audio_play_sound(snd_end_turn, -50, 0);
                    audio_sound_gain(snd_end_turn, master_volume * effect_volume, 0);

                    turn += 1;
                    with (obj_star) {
                        for (var i = 0; i <= 21; i++) {
                            present_fleet[i] = 0;
                        }
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
