function scr_quest(quest_satus, quest_name, quest_fac, quest_end) {
    // quest_satus: 0/1/2/3/4       create/fail/accomplish/clear/check
    // quest_name: quest name
    // quest_fac: faction
    // quest_end: duration before end

    var quick_trade = 0;
    var max_quests = 30;

    if (quest_satus == 0) {
        // Create
        var _first_empty_quest_slot = -1;

        for (var i = 1; i <= max_quests; i++) {
            if (obj_controller.quest[i] == "") {
                _first_empty_quest_slot = i;
                break;
            }
        }

        if (_first_empty_quest_slot != -1) {
            obj_controller.quest[_first_empty_quest_slot] = quest_name;
            obj_controller.quest_faction[_first_empty_quest_slot] = quest_fac;
            obj_controller.quest_end[_first_empty_quest_slot] = obj_controller.turn + quest_end;
        } else {
            LOGGER.error($"Warning: Quest log is full. Could not add: {quest_name}");
        }
    } else if (quest_satus > 0) {
        // 1 = Fail, 2 = Accomplish, 3 = Clear, 4 = Check
        var que = -1;

        for (var i = 1; i <= max_quests; i++) {
            if (obj_controller.quest[i] == quest_name) {
                que = i;
                break;
            }
        }

        if (que != -1 || quest_satus == 4) {
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
                var _art_keys = struct_get_names(obj_ini.artifact_map);
                for (var _i = 0; _i < array_length(_art_keys); _i++) {
                    var arti = obj_ini.artifact_map[$ _art_keys[_i]];
                    if (arti.get_type_name() != "" && arti.has_tag("inq")) {
                        wanted_arti = arti.artifact_id;
                        break;
                    }
                }
                var failed = false;
                if (wanted_arti < 0) {
                    failed = true;
                } else {
                    var arti = fetch_artifact(wanted_arti);
                    if (arti.is_equipped()) {
                        failed = true;
                    }
                }
                if (failed) {
                    scr_popup("Inquisition Artifact", "The Inquisition has asked for the return of the Artifact left in your care.  Despite your Marine's best efforts they were unable to waylay the Inquisition, who are now furious.  They demand the Artifact's immediate return.", "inquisition", "");
                    scr_event_log("red", "Inquisition Mission: The Inquisition Artifact entrusted to your Chapter is not retrievable.");
                    obj_controller.disposition[4] -= 10; // Explicitly use obj_controller scope
                    obj_controller.qsfx = 1;
                } else {
                    var _result_text = "";
                    delete_artifact(wanted_arti);
                    if (obj_controller.demanding == 0) {
                        obj_controller.disposition[4] += 1;
                        obj_controller.inspection_passes++;
                        _result_text = "(Disposition : +1\nInspection Passes : +1(yieldable in diplomacy))";
                    }
                    if (obj_controller.demanding == 1) {
                        obj_controller.disposition[4] += choose(0, 0, 1);
                    }
                    scr_popup("Inquisition Mission Completed", "The Inquisition has asked for the return of the Artifact, and your Chapter was able to hand it over without complications.  The mission has been accomplished." + _result_text, "inquisition", "");
                    scr_event_log("", "Inquisition Mission Completed: The entrusted Artifact has been returned to the Inquisition.");
                }
            }

            if ((quest_name == "fund_elder") && (quest_satus == 2)) {
                if (obj_controller.trading == 0) {
                    quick_trade = 6;
                }
                obj_controller.known[eFACTION.ELDAR] += 1;
                obj_controller.disposition[6] += 10;
            }

            if (quest_satus == 4) {
                return que;
            }

            if (que != -1) {
                obj_controller.quest[que] = "";
                obj_controller.quest_faction[que] = 0;
                obj_controller.quest_end[que] = 0;
            }
        }
    }

    if (quick_trade != 0) {
        var _loc = obj_ini.sector_handler.player_base_location(false);

        if (_loc == noone) {
            LOGGER.error("abort could not find a player location");
            return;
        }

        if (_loc.object_index == obj_p_fleet) {
            if (_loc.action != "") {
                var _fleet = _loc;
                var _loc = fleets_next_location(_loc);
            }
        }

        var _flit = create_enemy_fleet(_loc.x - 20, _loc.y - 20, quick_trade);

        if (quick_trade == 2) {
            _flit.sprite_index = spr_fleet_imperial;
        }
        if (quick_trade == 3) {
            _flit.sprite_index = spr_fleet_mechanicus;
        }
        if (quick_trade == 6) {
            _flit.action_spd = 6400;
            _flit.action_eta = 1;
            _flit.sprite_index = spr_fleet_eldar;
        }
        if (quick_trade == 8) {
            _flit.sprite_index = spr_fleet_tau;
        }

        _flit.image_index = 0;
        _flit.capital_number = 1;
        _flit.trade_goods = "";

        _flit.action_x = _loc.x;
        _flit.action_y = _loc.y;
        _flit.target = instance_nearest(_flit.action_x, _flit.action_y, obj_p_fleet);
        _flit.move();
    }
}
