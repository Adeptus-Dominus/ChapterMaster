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

    if ((image == "fuklaw") && (save > 0)) {
        if (press == 0) {
            var del = obj_saveload.save[save];
            var _save_file = string(PATH_save_files, del);
            if (file_exists(_save_file)) {
                file_delete(_save_file);
                if (file_exists($"save{del}log.ini")) {
                    file_delete($"save{del}log.ini");
                }
                with (obj_saveload) {
                    instance_destroy();
                }
                var news = instance_create(0, 0, obj_saveload);
                news.menu = woopwoopwoop;
                news.top = owner;
                news.alarm[4] = 1;

                instance_destroy();
            }
        }
        if (press == 1) {
            instance_destroy();
        }
        exit;
    }

    if ((room_get_name(room) == "Main_Menu") && (title == "Tutorial")) {
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
    if (((title == "Inquisition Mission") || (title == "Inquisition Recon")) && (title != "Artifact Located") && (obj_controller.demanding == 1)) {
        demand = 1;
    }

    if ((image == "chaos_messenger") && (title == "Chaos Meeting")) {
        if ((mission == "meeting_1") || (mission == "meeting_1t")) {
            if (array_length(options) == 0) {
                add_option(["Die, heretic!", "Very well.  Lead the way.", "I must take care of an urgent matter first.  (Exit)"]);
                exit;
            }
            if (array_length(options)) {
                if (press == 0) {
                    with (obj_star) {
                        var i = 0;
                        repeat (planets) {
                            remove_planet_problem(i, "meeting");
                            remove_planet_problem(i, "meeting_trap");
                        }
                    }
                    obj_controller.disposition[10] -= 10;
                    text = "The heretic is killed in a most violent fashion.  With a lack of go-between the meeting cannot proceed.";
                    reset_popup_options();
                    mission = ""; // image="";
                    if (obj_controller.blood_debt == 1) {
                        obj_controller.penitent_current += 1;
                        obj_controller.penitent_turn = 0;
                        obj_controller.penitent_turnly = 0;
                    }
                    with (obj_temp_meeting) {
                        instance_destroy();
                    }
                    cooldown = 20;
                    exit;
                } else if ((press == 1) && (mission == "meeting_1")) {
                    obj_controller.complex_event = true;
                    obj_controller.current_eventing = "chaos_meeting_1";
                    text = $"{global.chapter_name} signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before {global.chapter_name} all enter an ordinary-looking structure.  Down, within the basement, {global.chapter_name} then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until {global.chapter_name} find yourself within a hall.  Within this hall, waiting for {global.chapter_name}, are several dozen Chaos Terminators, a Greater Daemon of Tzeentch and Slaanesh, and Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + ".";
                    reset_popup_options();
                    mission = "cslord1";
                    image = "";
                    img = 0;
                    image_wid = 0;
                    size = 3;
                    cooldown = 20;
                    exit;
                } else if ((press == 1) && (mission == "meeting_1t")) {
                    with (obj_star) {
                        remove_star_problem("meeting");
                        remove_star_problem("meeting_trap");
                    }
                    obj_controller.complex_event = true;
                    obj_controller.current_eventing = "chaos_trap";
                    text = $"{global.chapter_name} signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before {global.chapter_name} all enter an ordinary-looking structure.  Down, within the basement, {global.chapter_name} then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until {global.chapter_name} find yourself within a hall.  Within this hall, waiting for {global.chapter_name}, are several dozen Chaos Terminators, a handful of Helbrute, and many more Chaos Space Marines.  The Chaos Lord is nowhere to be seen.  It is a trap.";
                    reset_popup_options();
                    mission = "cslord1t";
                    image = "";
                    img = 0;
                    image_wid = 0;
                    size = 3;
                    cooldown = 20;
                    exit;
                }
                if ((press == 2) && instance_exists(obj_turn_end)) {
                    if (number != 0) {
                        obj_turn_end.alarm[1] = 4;
                    }
                    with (obj_temp_meeting) {
                        instance_destroy();
                    }
                    instance_destroy();
                }
            }
        }
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
                    var ide = 0;
                    repeat (700) {
                        ide += 1;
                        if ((attend_corrupted[ide] == 0) && (attend_id[ide] > 0)) {
                            if (string_count("chaos", obj_ini.artifact_tags[obj_controller.fest_display]) > 0) {
                                obj_ini.TTRPG[attend_co[ide]][attend_id[ide]].corruption += choose(1, 2, 3, 4);
                            }
                            if (string_count("daemonic", obj_ini.artifact_tags[obj_controller.fest_display]) > 0) {
                                obj_ini.TTRPG[attend_co[ide]][attend_id[ide]].corruption += choose(6, 7, 8, 9);
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
    } else if (((title == "Inquisition Mission") || (title == "Inquisition Recon")) && (array_length(options) == 0)) {
        add_option(["Accept", "Refuse"], true);
    }

    if ((press == 0) && array_length(options) || ((demand == 1) && (mission != "") && (string_count("Inquisition", title) > 0)) || ((demand == 1) && (title == "Inquisition Recon"))) {
        if (title == "Inquisition Recon") {
            var mission_star, onceh;
            onceh = 0;
            obj_controller.temp[200] = string(loc);
            var mission_star = star_by_name(obj_controller.temp[200]);
            if (add_new_problem(planet, "recon", estimate, mission_star)) {
                title = "Inquisition Mission Demand";
                text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to land Astartes on {mission_star.name} {scr_roman(planet)} to investigate the planet within {estimate} months.";
                with (mission_star) {
                    new_star_event_marker("green");
                }
                scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wish for Astartes to land on and investigate {mission_star.name} {scr_roman(planet)} within {estimate} months.", mission_star.name);
            }
        }

        if ((mission != "") && (title == "Inquisition Mission")) {
            obj_controller.temp[200] = string(loc);
            var mission_star, onceh;
            mission_star = 0;
            onceh = 0;
            var mission_star = star_by_name(obj_controller.temp[200]);
            var mission_is_go = false;
            if (mission_star != "none" && planet > 0) {
                var _estimate = estimate;
                var _planet = planet;
                var _mission = mission;
                with (mission_star) {
                    if (add_new_problem(_planet, _mission, _estimate)) {
                        new_star_event_marker("green");
                        mission_is_go = true;
                    }
                }

                if (mission_is_go) {
                    if (demand) {
                        title = "Inquisition Mission Demand";
                    }

                    if (mission == "purge") {
                        scr_event_log("", $"Inquisition Mission Accepted: The nobles of {mission_star.name} {scr_roman(planet)} must be selectively purged within {estimate} months.", mission_star.name);
                        if (demand) {
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to selectively purge the Nobles on {mission_star.name} {scr_roman(onceh)} within {estimate} months.";
                        }
                    } else if (mission == "cleanse") {
                        scr_event_log("", $"Inquisition Mission Accepted: The mutants beneath {planet_numeral_name(planet, mission_star)} must be cleansed by fire within {estimate} months.", mission_star.name);
                        if (demand) {
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to cleanse by fire the mutants in Hive {planet_numeral_name(planet, mission_star)} within {estimate} months.";
                        }
                    }
                    if (mission == "spyrer") {
                        scr_event_log("", $"Inquisition Mission Accepted: The Spyrer on {mission_star.name} {scr_roman(planet)} must be killed within {estimate} months.", mission_star.name);
                        if (demand) {
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Spyrer on Hive {mission_star.name} {scr_roman(onceh)} must be removed within {estimate} months.";
                        }
                    } else if (mission == "tyranid_org") {
                        image = "webber";
                        title = "New Equipment";
                        fancy_title = 0;
                        text_center = 0;
                        text = $"{global.chapter_name} have been provided with 4x Astartes Webbers in order to complete the mission.";

                        if (demand) {
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture a Gaunt organism and return it, unharmed- 4x Webbers have been provided for this purpose.";
                        }

                        reset_popup_options();
                        scr_add_item("Webber", 4);
                        obj_controller.cooldown = 10;
                        scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wishes for the capture of a particular strain Gaunt noticed on {mission_star.name} {scr_roman(planet)} is advisable.", mission_star.name);
                        obj_controller.useful_info += "Tyr|";
                        if (demand) {
                            demand = 0;
                        }
                        exit;
                    } else if (mission == "ethereal") {
                        with (obj_star) {
                            if ((p_tau[1] >= 4) || (p_tau[2] >= 4) || (p_tau[3] >= 4) || (p_tau[4] >= 4)) {
                                new_star_event_marker("green");
                            }
                        }
                        scr_quest(0, "ethereal_capture", 4, estimate);
                        obj_controller.useful_info += "Tau|";

                        if (demand) {
                            title = "Inquisition Mission Demand";
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture the Tau Ethereal somewhere within the {mission_star.name} system.";
                        }
                        if (has_problem_star("recon", mission_star)) {
                            scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wish for {global.chapter_name} to capture the Tau Ethereal somewhere within {mission_star.name}.", mission_star.name);
                        }
                    } else if (mission == "demon_world") {
                        scr_event_log("", $"Inquisition Mission Accepted: The demon world of {mission_star.name} {scr_roman(planet)} will be purged by your hand.", mission_star.name);
                        if (demand) {
                            text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Demon World {mission_star.name} {scr_roman(onceh)} must be cleansed within {estimate} months.";
                        }
                    }
                }
            }
            if (!mission_is_go) {
                if (mission == "artifact") {
                    var last_artifact;
                    scr_quest(0, "artifact_loan", 4, estimate);
                    if (obj_ini.fleet_type == ePlayerBase.home_world) {
                        image = "fortress";
                        if (obj_ini.home_type == "Hive") {
                            image = "fortress_hive";
                        }
                        if (obj_ini.home_type == "Death") {
                            image = "fortress_death";
                        }
                        if (obj_ini.home_type == "Ice") {
                            image = "fortress_ice";
                        }
                        if (obj_ini.home_type == "Lava") {
                            image = "fortress_lava";
                        }
                        last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.home_name, 2);
                    } else if (obj_ini.fleet_type != ePlayerBase.home_world) {
                        image = "artifact_given";
                        last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.ship[0], 501);
                    }

                    title = "New Artifact";
                    fancy_title = 0;
                    text_center = 0;
                    text = "The Inquisition has left an Artifact in your care, until it may be retrieved.  It has been stored ";
                    if (obj_ini.fleet_type == ePlayerBase.home_world) {
                        text += "within your Fortress Monastery.";
                    }
                    if (obj_ini.fleet_type != ePlayerBase.home_world) {
                        text += $"upon your ship '{obj_ini.ship[0]}'.";
                    }
                    scr_event_log("", "Inquisition Mission Accepted: The Inquisition has left an Artifact in your care.");

                    text += $"  It is some form of {obj_ini.artifact[last_artifact]}.";
                    reset_popup_options();
                    obj_controller.cooldown = 10;
                    exit;
                }
            }

            if (demand) {
                demand = 0;
                reset_popup_options();
                exit;
            } // Remove multi-choices
        }

        if ((image == "inquisition") && (title == "Investigation Completed")) {
            obj_temp7.alarm[1] = 1;
            instance_destroy();
        }

        if (image == "artifact2") {
            ground_forces_collect_artifact();
            obj_controller.cooldown = 10;
            instance_destroy();
        }

        obj_controller.cooldown = 10;
        if (obj_controller.complex_event == false) {
            if (number != 0 && instance_exists(obj_turn_end)) {
                obj_turn_end.alarm[1] = 4;
            }
            instance_destroy();
        }
    }

    if ((press == 1) && (option2 != "")) {
        if (mission == "spyrer") {
            obj_controller.disposition[4] -= 2;
        }
        if (title == "Inquisition Recon") {
            obj_controller.disposition[4] -= 2;
        }
        if ((image == "inquisition") && (title == "Investigation Completed")) {
            with (obj_temp7) {
                instance_destroy();
            }
            instance_destroy();
        }

        if (title == "Mercy Plea") {
            // If have any marines within the fleet on the ships

            var able, i;
            able = 0;
            i = 0;

            // Several things can happen when the ship is searched;
            // Full of demons, maybe remove a marine, fired upon and explodes

            exit;
        }

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
    handle_exception(_exception);
    instance_destroy();
}
