function scr_quest(quest_satus = 0, quest_name, quest_fac, quest_end) {
    // quest_satus: 0/1/2/3/4       create/fail/accomplish/clear/check
    // quest_name: quest name
    // quest_fac: faction
    // quest_end: duration before end

    var quick_trade;
    quick_trade = 0;

    if (quest_satus == 0) {
        // Create
        var first_quest, i;
        first_quest = 0;
        i = 0;

        repeat (30) {
            if (first_quest == 0) {
                i += 1;
                if (obj_controller.quest[i] == "") {
                    first_quest = i;
                }
            }
        }

        obj_controller.quest[i] = quest_name;
        obj_controller.quest_faction[i] = quest_fac;
        obj_controller.quest_end[i] = obj_controller.turn + quest_end;
    } else if (quest_satus > 0) {
        // 1 = Fail, 2 = Accomplish, 3 = Clear
        var que = 0;

        for (var i = 1; i <= 10; i += 1) {
            if (que == 0 && obj_controller.quest[i] == quest_name) {
                que = i;
                break;
            }
        }

        if ((quest_name == "fund_elder") && (quest_satus == 1)) {
            // obj_controller.disposition[6]-=2;// Player going 'maybe' and then waiting out the quest duration
            scr_audience(6, "mission1_failed", -2, "", 0, 0);
            scr_event_log("red", "Eldar Mission Failed: Several years have passed since offering to assist the Eldar with resources.");
        } else if ((quest_name == "artifact_return") && (quest_satus == 1)) {
            // Inq are now pissed
            obj_controller.alarm[8] = 1;
        } else if ((quest_name == "artifact_loan") && (quest_satus == 1)) {
            // Inq want the artifact back
            var wanted_arti = -1;
            for (var i = 0; i < array_length(obj_ini.artifact); i++) {
                if (obj_ini.artifact[i] != "") {
                    if (obj_ini.artifact_struct[i].has_tag("inq")) {
                        wanted_arti = i;
                        break;
                    }
                }
            }
            var failed = false;
            if (wanted_arti < 0) {
                failed = true;
            } else {
                var arti = obj_ini.artifact_struct[wanted_arti];
                if (arti.equipped() && is_array(arti.bearer)) {
                    failed = true;
                }
            }
            if (failed) {
                scr_popup("Inquisition Artifact", "The Inquisition has asked for the return of the Artifact left in your care.  Despite your Marine's best efforts they were unable to waylay the Inquisition, who are now furious.  They demand the Artifact's immediate return.", "inquisition", "");
                scr_event_log("red", "Inquisition Mission: The Inquisition Artifact entrusted to your Chapter is not retrievable.");
                disposition[4] -= 10;
                obj_controller.qsfx = 1;
            } else {
                var _result_text = "";
                delete_artifact(wanted_arti);
                i = wanted_arti;
                if (obj_controller.demanding == 0) {
                    obj_controller.disposition[4] += 1;
                    obj_controller.inspection_passes++;
                    _result_text = "(Disposition : 1\nInspection Passes : +1(yieldable in diplommacy))";
                }
                if (obj_controller.demanding == 1) {
                    obj_controller.disposition[4] += choose(0, 0, 1);
                }
                scr_popup("Inquisition Mission Completed", "The Inquisition has asked for the return of the Artifact, and your Chapter was able to hand it over without complications.  The mission has been accomplished." + _result_text, "inquisition", "");
                scr_event_log("", "Inquisition Mission Completed: The entrusted Artifact has been returned to the Inquisition.");
            }
        }

        if ((quest_name == "fund_elder") && (quest_satus == 2)) {
            if (trading == 0) {
                quick_trade = 6;
            }
            obj_controller.known[eFACTION.Eldar] += 1;
            obj_controller.disposition[6] += 10;
        }

        if (quest_satus == 4) {
            var first_quest, i;
            first_quest = 0;
            i = 0;

            repeat (30) {
                if (first_quest == 0) {
                    i += 1;
                    if (obj_controller.quest[i] == quest_name) {
                        first_quest = i;
                    }
                }
            }

            if (first_quest != 0) {
                return first_quest;
            }
            exit;
        }

        obj_controller.quest[que] = "";
        obj_controller.quest_faction[que] = 0;
        obj_controller.quest_end[que] = 0;
    }

    if (quick_trade != 0) {
        if (obj_ini.fleet_type == ePlayerBase.home_world) {
            with (obj_star) {
                if ((owner == eFACTION.Player) && ((p_owner[1] == 1) || (p_owner[2] == 1))) {
                    instance_create(x, y, obj_temp2);
                }
            }
        }
        if (obj_ini.fleet_type != ePlayerBase.home_world) {
            with (obj_p_fleet) {
                // Get fleet star system
                if ((capital_number > 0) && (action == "")) {
                    instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_temp2);
                }
                if ((frigate_number > 0) && (action == "")) {
                    instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_ground_mission);
                }
            }
        }

        with (obj_star) {
            // Get origin star system for enemy fleet
            if ((owner == quick_trade) && ((p_owner[1] == quick_trade) || (p_owner[2] == quick_trade) || (p_owner[3] == quick_trade) || (p_owner[4] == quick_trade))) {
                instance_create(x, y, obj_temp3);
            }
        }

        var targ, flit, goods, i, chasing;
        goods = "";
        chasing = 0; // Set target
        if (instance_exists(obj_temp2)) {
            targ = instance_nearest(obj_temp2.x, obj_temp2.y, obj_temp3);
        }
        if ((!instance_exists(obj_temp2)) && instance_exists(obj_ground_mission)) {
            targ = instance_nearest(obj_ground_mission.x, obj_ground_mission.y, obj_temp3);
        }

        // If player fleet is flying about then get their target for new target
        if ((!instance_exists(obj_temp2)) && (!instance_exists(obj_ground_mission)) && instance_exists(obj_p_fleet)) {
            chasing = 1;
            with (obj_p_fleet) {
                var pop;
                if ((capital_number > 0) && (action != "")) {
                    pop = instance_create(action_x, action_y, obj_temp2);
                    pop.action_eta = action_eta;
                }
                if ((frigate_number > 0) && (action != "")) {
                    pop = instance_create(action_x, action_y, obj_ground_mission);
                    pop.action_eta = action_eta;
                }
            }
        }
        if (instance_exists(obj_temp2)) {
            targ = instance_nearest(obj_temp2.x, obj_temp2.y, obj_temp3);
        }
        if ((!instance_exists(obj_temp2)) && instance_exists(obj_ground_mission)) {
            targ = instance_nearest(obj_ground_mission.x, obj_ground_mission.y, obj_temp3);
        }

        flit = instance_create(targ.x, targ.y, obj_en_fleet);
        flit.owner = quick_trade;

        if (quick_trade == 2) {
            flit.sprite_index = spr_fleet_imperial;
        }
        if (quick_trade == 3) {
            flit.sprite_index = spr_fleet_mechanicus;
        }
        if (quick_trade == 6) {
            flit.action_spd = 6400;
            flit.action_eta = 1;
            flit.sprite_index = spr_fleet_eldar;
        }
        if (quick_trade == 8) {
            flit.sprite_index = spr_fleet_tau;
        }

        flit.image_index = 0;
        flit.capital_number = 1;
        flit.trade_goods = "";

        if (instance_exists(obj_temp2)) {
            flit.action_x = obj_temp2.x;
            flit.action_y = obj_temp2.y;
            flit.target = instance_nearest(flit.action_x, flit.action_y, obj_p_fleet);
        }
        if ((!instance_exists(obj_temp2)) && instance_exists(obj_ground_mission)) {
            flit.action_x = obj_ground_mission.x;
            flit.action_y = obj_ground_mission.y;
            flit.target = instance_nearest(flit.action_x, flit.action_y, obj_p_fleet);
        }
        with (flit) {
            set_fleet_movement();
        }

        with (obj_temp2) {
            instance_destroy();
        }
        with (obj_temp3) {
            instance_destroy();
        }
        with (obj_ground_mission) {
            instance_destroy();
        }
    }
}
