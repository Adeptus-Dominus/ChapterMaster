try {
    if (hide == true) {
        exit;
    }
    if (instance_exists(obj_controller)) {
        if (obj_controller.zoomed == 1) {
            with (obj_controller) {
                scr_zoom();
            }
        }
    }

    for (var i = 0; i < array_length(options); i++) {
        if (keyboard_check_pressed(ord(string(i + 1))) && (cooldown <= 0)) {
            press = i;
        }
    }

    if ((type != 6) && (master_crafted == 1)) {
        master_crafted = 0;
    }

    //! I don't think this is even used?
    if ((room_get_name(room) == "rm_main_menu") && (title == "Tutorial")) {
        if (press == 1) {
            // 1: yes, 2: no (without disabling)
            obj_main_menu_buttons.fading = 1;
            obj_main_menu_buttons.crap = 3;
            obj_main_menu_buttons.cooldown = 9999;
            instance_destroy();
        }
        if (press == 2) {
            ini_open("saves.ini");
            ini_write_real("Data", "tutorial", 1);
            ini_close();
        }

        if (press >= 1) {
            obj_main_menu_buttons.fading = 1;
            obj_main_menu_buttons.crap = self.press;
            obj_main_menu_buttons.cooldown = 9999;
            instance_destroy();
        }
        exit;
    }

    if (title == "Scheduled Event") {
        if (array_length(options) == 0) {
            add_option(["Yes", "No"]);
            exit;
        }

        if ((press == 0) && (!instance_exists(obj_event))) {
            instance_create(0, 0, obj_event);
            if (obj_controller.fest_planet == 0) {
                obj_controller.fest_attend = scr_event_dudes(1, 0, "", obj_controller.fest_sid);
            }
            if (obj_controller.fest_planet == 1) {
                scr_event_dudes(1, 1, obj_controller.fest_star, obj_controller.fest_wid);
            }
            hide = true;
            cooldown = 6000;
            title = "Scheduled Event:2";
            exit;
        }
        if (press == 1) {
            obj_controller.fest_repeats -= 1;
            if (obj_controller.fest_repeats <= 0) {
                obj_controller.fest_scheduled = 0;

                instance_create(0, 0, obj_event);
                if (obj_controller.fest_planet == 0) {
                    obj_controller.fest_attend = scr_event_dudes(1, 0, "", obj_controller.fest_sid);
                }
                if (obj_controller.fest_planet == 1) {
                    scr_event_dudes(1, 1, obj_controller.fest_star, obj_controller.fest_wid);
                }

                with (obj_event) {
                    var _popup_disp_arti = undefined;
                    if (obj_controller.fest_display > -1) {
                        _popup_disp_arti = fetch_artifact(obj_controller.fest_display);
                    }
                    var ide = 0;
                    repeat (700) {
                        ide += 1;
                        if ((attend_corrupted[ide] == 0) && (attend_id[ide] > 0)) {
                            if (is_struct(_popup_disp_arti) && _popup_disp_arti.has_tag("chaos")) {
                                var _unit = fetch_unit([attend_co[ide], attend_id[ide]]);
                                if (is_struct(_unit)) {
                                    _unit.corruption += choose(1, 2, 3, 4);
                                }
                            }
                            if (is_struct(_popup_disp_arti) && _popup_disp_arti.has_tag("daemonic")) {
                                var _unit = fetch_unit([attend_co[ide], attend_id[ide]]);
                                if (is_struct(_unit)) {
                                    _unit.corruption += choose(6, 7, 8, 9);
                                }
                            }
                            attend_corrupted[ide] = 1;
                        }
                    }
                }
                with (obj_event) {
                    instance_destroy();
                }

                var p1, p2, p3;
                p1 = obj_controller.fest_type;
                p3 = "";
                p2 = obj_controller.fest_planet;

                if (p2 > 0) {
                    p3 = string(obj_controller.fest_star) + " " + scr_roman(obj_controller.fest_wid);
                }
                if (p2 <= 0) {
                    p3 = +" the vessel '" + string(obj_ini.ship[obj_controller.fest_sid]) + "'";
                }

                scr_alert("green", "event", string(p1) + " on " + string(p3) + " ends.", 0, 0);
                scr_event_log("green", string(p1) + " on " + string(p3) + " ends.");
            }
            obj_controller.cooldown = 10;
            if (number != 0 && instance_exists(obj_turn_end)) {
                obj_turn_end.alarm[1] = 4;
            }
            instance_destroy();
        }
    }
    if (title == "Scheduled Event:2") {
        exit;
    } 

    if ((press == 1) && (option2 != "")) {


        if (image == "artifact2") {
            scr_return_ship(obj_ground_mission.loc, obj_ground_mission, obj_ground_mission.num);
            var man_size, ship_id, comp, plan, i;
            i = 0;
            ship_id = 0;
            man_size = 0;
            comp = 0;
            plan = 0;
            ship_id = array_get_index(obj_ini.ship, obj_ground_mission.loc);
            obj_controller.menu = 0;
            obj_controller.managing = 0;
            obj_controller.cooldown = 10;
            with (obj_ground_mission) {
                instance_destroy();
            }
            instance_destroy();
            exit;
        }

        obj_controller.cooldown = 10;

        if (obj_controller.complex_event == false) {
            if (number != 0 && instance_exists(obj_turn_end)) {
                obj_turn_end.alarm[1] = 4;
            }
            instance_destroy();
        }
    }

    if (pathway == "end_splash") {
        if (!array_length(options)) {
            add_option(["Continue"]);
        }
        if (press == 0) {
            popup_default_close();
        }
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    instance_destroy();
}
