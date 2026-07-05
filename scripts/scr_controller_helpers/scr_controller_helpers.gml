//TODO make enum to store menu area codes
function scr_menu_clear_up(specific_area_function) {
    var spec_func = specific_area_function;
    with (obj_controller) {
        var menu_action_allowed = !instance_exists(obj_saveload) && !instance_exists(obj_drop_select) && !instance_exists(obj_popup_dialogue) && !instance_exists(obj_ncombat);

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
                if (mouse_y >= camera_get_view_y(view_camera[0]) + 27) {
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

            diyst = 999;
            xx = camera_get_view_x(view_camera[0]);
            yy = camera_get_view_y(view_camera[0]);

            if (menu == 0) {
                hide_banner = 0;
            } // 136 ;

            if (instance_exists(obj_temp_build)) {
                if (variable_instance_exists(obj_temp_build, "isnew") && obj_temp_build.isnew) {
                    exit;
                }
            }
            return spec_func();
        }
    }
    return false;
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
                try{
                    setup_ui_chapter_settings();
                } catch (_exception){
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
                LOGGER.debug("set_diplo");
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
                    obj_controller.menu = 0;
                    obj_controller.zui = 0;
                    obj_controller.invis = false;

                    if (global.settings.autosave == true) {
                        // Autosave every 10 turns
                        if (obj_controller.turn % 10 == 0) {
                            scr_autosave();
                        }
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
                    eldar_incursion_tick();
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

/// @desc How many pieces of Eldar intelligence have been collected. Guarded read so
/// old saves and fresh campaigns start at zero without any save-format changes.
function eldar_intel_count() {
    if (!variable_instance_exists(obj_controller, "eldar_intel")) {
        return 0;
    }
    return obj_controller.eldar_intel;
}

/// @desc Grant one piece of Eldar intelligence after a ground victory over a warhost.
/// At ELDAR_INTEL_REQUIRED pieces the craftworld is revealed. Called from the battle
/// aftermath (obj_ncombat\Alarm_5), where most map instances are deactivated, so the
/// reveal only flips obj_controller.known (the craftworld un-hides itself through its
/// own Draw check) and defers the map alert and fleet un-hiding to the next end-turn
/// tick via eldar_reveal_alert_pending.
function eldar_intel_grant() {
    if (obj_controller.known[eFACTION.ELDAR] != 0) {
        return;
    }
    if (!variable_instance_exists(obj_controller, "eldar_intel")) {
        obj_controller.eldar_intel = 0;
    }
    obj_controller.eldar_intel += 1;
    var _n = obj_controller.eldar_intel;
    var _clue_texts = [
        "Among the alien dead your Apothecaries recover spirit stones that pulse in unison, all straining toward some distant point in the void. The Librarium begins triangulating.",
        "A dying Warlock's staff yields a shard of wraithbone etched with webway routes. Cross-referenced with the spirit stones, the search narrows to a handful of sectors.",
        "A captured wayseer's runes, broken under the Librarium's interrogation, complete the pattern. The hidden Craftworld's position is laid bare."
    ];
    var _text = _clue_texts[min(_n, array_length(_clue_texts)) - 1];
    if (_n >= ELDAR_INTEL_REQUIRED) {
        scr_popup("Eldar Intelligence", _text + $"\n\nIntelligence complete ({min(_n, ELDAR_INTEL_REQUIRED)}/{ELDAR_INTEL_REQUIRED}). The Eldar Craftworld has been located.", "");
        obj_controller.known[eFACTION.ELDAR] = 1;
        obj_controller.eldar_reveal_alert_pending = true;
    } else {
        scr_popup("Eldar Intelligence", _text + $"\n\nIntelligence gathered: {_n}/{ELDAR_INTEL_REQUIRED}.", "");
    }
}

/// @desc End-of-turn Eldar processing: fires the deferred craftworld reveal alert,
/// then every ELDAR_INCURSION_INTERVAL turns lands a warhost on a random inhabited
/// imperial world. Warhost strength ramps with collected intelligence
/// (FORCE_BASE + clues, capped at FORCE_MAX), keeping the strongest Eldar for the
/// craftworld itself. The planetary AI never acts on p_eldar (its pdf_attack line is
/// commented out upstream), so a landed warhost persists as a fightable target until
/// the player clears it.
function eldar_incursion_tick() {
    if (variable_instance_exists(obj_controller, "eldar_reveal_alert_pending") && obj_controller.eldar_reveal_alert_pending) {
        obj_controller.eldar_reveal_alert_pending = false;
        with (obj_star) {
            if (p_type[1] == "Craftworld") {
                // Grant fog-of-war vision with the reveal so the craftworld is
                // immediately selectable and targetable (see obj_star Mouse_50).
                vision = 1;
                scr_alert("green", "elfs", "Eldar Craftworld discovered.", x, y);
                scr_event_log("green", "Eldar Craftworld discovered.");
            }
        }
        with (obj_en_fleet) {
            if (owner == eFACTION.ELDAR) {
                image_alpha = 1;
            }
        }
    }
    if (obj_controller.faction_defeated[eFACTION.ELDAR] != 0) {
        return;
    }
    if ((obj_controller.turn < ELDAR_INCURSION_INTERVAL) || ((obj_controller.turn % ELDAR_INCURSION_INTERVAL) != 0)) {
        return;
    }
    var _force = min(ELDAR_INCURSION_FORCE_BASE + eldar_intel_count(), ELDAR_INCURSION_FORCE_MAX);
    var _targets = [];
    with (obj_star) {
        if (craftworld || space_hulk) {
            continue;
        }
        for (var i = 1; i <= planets; i++) {
            if ((p_type[i] != "Dead") && (p_owner[i] >= 1) && (p_owner[i] <= 5) && (p_eldar[i] == 0)) {
                array_push(_targets, [id, i]);
            }
        }
    }
    if (array_length(_targets) == 0) {
        return;
    }
    var _pick = _targets[irandom(array_length(_targets) - 1)];
    var _star = _pick[0];
    var _planet = _pick[1];
    _star.p_eldar[_planet] = _force;
    scr_alert("red", "elfs", $"An Eldar warhost has struck {_star.name} {scr_roman(_planet)}.", _star.x, _star.y);
    scr_event_log("red", $"An Eldar warhost has struck {_star.name} {scr_roman(_planet)}.");
}
