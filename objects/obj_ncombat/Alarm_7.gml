try {
    // global.logger.debug("alarm 7 start");
    audio_stop_sound(snd_battle);
    audio_play_sound(snd_royal, 0, true);
    audio_sound_gain(snd_royal, 0, 0);
    var nope = 0;
    if ((obj_controller.master_volume == 0) || (obj_controller.music_volume == 0)) {
        nope = 1;
    }
    if (nope != 1) {
        audio_sound_gain(snd_royal, 0.25 * obj_controller.master_volume * obj_controller.music_volume, 2000);
    }


    // Execute the cleaning scripts
    // Check for any more battles

    obj_controller.cooldown = 10;

    global.logger.info($"Ground Combat - {(defeat ? "Defeat" : "Victory")} - Enemy:{enemy} ({battle_special})");

    // If battling own dudes, then remove the loyalists after the fact

    if (enemy == 1) {
        var j = -1;
        var cleann = array_create(11, false);
        with (obj_enunit) {
            var q = 0;
            repeat (700) {
                q += 1;
                if (dude_id[q] > 0) {
                    var commandy = false;
                    var nco = dude_co[q];
                    var nid = dude_id[q];
                    cleann[nco] = true;

                    // show_message("dude ID:"+string(q)+" ("+string(obj_ini.name[nco,nid])+") is being removed from the array");

                    commandy = is_specialist(obj_ini.role[nco][nid]);
                    if (commandy == true) {
                        obj_controller.command -= 1;
                    }
                    if (commandy == false) {
                        obj_controller.marines -= 1;
                    }

                    obj_ncombat.world_size += scr_unit_size(obj_ini.armour[nco][nid], obj_ini.role[nco][nid], true, obj_ini.mobi[nco][nid]);

                    var recover = !obj_ncombat.defeat;
                    kill_and_recover(nco, nid, recover, recover);
                }
            }
        }

        for (j = 0; j <= 10; j++) {
            if (cleann[j]) {
                with (obj_ini) {
                    scr_company_order(j);
                }
            }
        }
    }
    if (string_count("cs_meeting", battle_special) > 0) {
        with (obj_temp_meeting) {
            instance_destroy();
        }

        with (obj_star) {
            if (name == obj_ncombat.battle_loc) {
                instance_create(x, y, obj_temp_meeting);
                var i = 0, ii = 0, otm, good = 0, master_present = 0;
                var run = 0, s = 0, chaos_meeting = 0;

                var master_index = array_get_index(obj_ini.role[0], obj_ini.role[100][eROLE.CHAPTERMASTER]);
                chaos_meeting = fetch_unit([0, master_index]).planet_location;

                // show_message("meeting planet:"+string(chaos_meeting));
                for (var co = 0; co <= 10; co++) {
                    for (var i = 0; i < array_length(obj_ini.TTRPG[co]); i++) {
                        good = 0;
                        _unit = fetch_unit([co, i]);
                        if (_unit.role() == "" || _unit.location_string != name) {
                            continue;
                        }
                        if (_unit.planet_location == floor(chaos_meeting)) {
                            good += 1;
                        }
                        if ((obj_ini.role[co][i] != obj_ini.role[100][6]) && (obj_ini.role[co][i] != "Venerable " + string(obj_ini.role[100][6]))) {
                            good += 1;
                        }
                        if ((string_count("Dread", obj_ini.armour[co][i]) == 0) || (obj_ini.role[co][i] == obj_ini.role[100][eROLE.CHAPTERMASTER])) {
                            good += 1;
                        }

                        // if (good>=3) then show_message(string(obj_ini.role[co][i])+": "+string(co)+"."+string(i));

                        if (good >= 3) {
                            obj_temp_meeting.dudes += 1;
                            otm = obj_temp_meeting.dudes;
                            obj_temp_meeting.present[otm] = 1;
                            obj_temp_meeting.co[otm] = co;
                            obj_temp_meeting.ide[otm] = i;
                            if (obj_ini.role[co][i] == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                                master_present = 1;
                            }
                        }
                    }
                }
                // show_message("obj_temp_meeting.dudes:"+string(obj_temp_meeting.dudes));
            }
        }
    }

    var _lost_banner = post_equipment_lost.has_item("Company Standard");
    if (_lost_banner != -1) {
        repeat (_lost_banner) {
            scr_loyalty("Lost Standard", "+");
        }
    }

    if (battle_special == "ruins" || battle_special == "ruins_eldar") {
        obj_ground_mission.defeat = defeat;
        obj_ground_mission.explore_feature.ruins_combat_end();
    } else if ((battle_special == "WL10_reveal") || (battle_special == "WL10_later")) {
        var moar, ox, oy;
        with (obj_temp8) {
            instance_destroy();
        }

        if (chaos_angry >= 5) {
            if (string_count("|CPF|", obj_controller.useful_info) == 0) {
                obj_controller.useful_info += "|CPF|";
            }
        }

        if (battle_special == "WL10_reveal") {
            instance_create(battle_object.x, battle_object.y, obj_temp8);
            ox = battle_object.x;
            oy = battle_object.y; // battle_object.owner = eFACTION.CHAOS;
            battle_object.p_traitors[battle_id] = 6;
            battle_object.p_chaos[battle_id] = 4;
            battle_object.p_pdf[battle_id] = 0;
            battle_object.p_owner[battle_id] = 10;

            var corro;
            corro = 0;

            repeat (100) {
                var ii;
                ii = 0;
                if (corro <= 5) {
                    moar = instance_nearest(ox, oy, obj_star);

                    if (moar.owner <= 3) {
                        corro += 1;
                        repeat (4) {
                            ii += 1;
                            if (moar.p_owner[ii] <= 3) {
                                moar.p_heresy[ii] = min(100, moar.p_heresy[ii] + floor(random_range(30, 50)));
                            }
                        }
                    }
                    moar.y -= 20000;
                }
            }
            with (obj_star) {
                if (y < -12000) {
                    y += 20000;
                }
            }

            if (battle_object.present_fleet[2] > 0) {
                with (obj_en_fleet) {
                    if ((navy == 0) && (owner == eFACTION.IMPERIUM) && (point_distance(x, y, obj_temp8.x, obj_temp8.y) < 40)) {
                        owner = eFACTION.CHAOS;
                        sprite_index = spr_fleet_chaos;
                        if (image_index <= 2) {
                            escort_number += 3;
                            frigate_number += 1;
                        }
                        if (capital_number == 0) {
                            capital_number += 1;
                        }
                    }
                }
                battle_object.present_fleet[2] -= 1;
                battle_object.present_fleet[10] += 1;
            }
            with (obj_temp8) {
                instance_destroy();
            }
        }

        if ((defeat == 1) && (battle_special == "WL10_reveal")) {
            obj_controller.audience = 10;
            scr_toggle_diplomacy();
            obj_controller.diplomacy = 10;
            obj_controller.known[eFACTION.CHAOS] = 2;
            with (obj_controller) {
                scr_dialogue("intro2");
            }
        }
        if (defeat == 0) {
            obj_controller.known[eFACTION.CHAOS] = 2;
            obj_controller.faction_defeated[10] = 1;

            if (instance_exists(obj_turn_end)) {
                scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                scr_alert("", "ass", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " has been killed.", 0, 0);
                scr_popup("Chaos Lord Killed", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer as threatened by the forces of Chaos.", "", "");
            }
            if (!instance_exists(obj_turn_end)) {
                scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                var _pop = instance_create(0, 0, obj_popup);
                _pop.image = "";
                _pop.title = "Chaos Lord Killed";
                _pop.text = "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer as threatened by the forces of Chaos.";
            }
        }
    }

    if ((battle_special == "study2a") || (battle_special == "study2b")) {
        if (defeat == 1) {
            var ii = 0, good = 0;

            if (remove_planet_problem(battle_id, "mech_tomb", battle_object)) {
                obj_controller.disposition[3] -= 10;

                if (battle_special == "study2a") {
                    scr_popup("Mechanicus Mission Failed", "All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust, and the Adeptus Mechanicus is furious with your chapter for not providing enough security.  Relations with them are worse than before.", "", "");
                }
                if (battle_special == "study2b") {
                    battle_object.p_necrons[battle_id] = 5;
                    awaken_tomb_world(battle_object.p_feature[battle_id]);
                    alter_dispositions([[eFACTION.MECHANICUS, -15], [eFACTION.INQUISITION, -5]]);
                    scr_popup("Mechanicus Mission Failed", "All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust.  To make matters worse the Necron Tomb has fully awakened- countless numbers of the souless machines are now pouring out of the tomb.  The Adeptus Mechanicus are furious with your chapter.", "necron_army", "");
                    scr_alert("", "inqi", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb", 0, 0);
                    scr_event_log("", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb");
                }

                scr_event_log("", "Mechanicus Mission Failed: Necron Tomb Research Party and present astartes have been killed.");
            }
        }
    }

    if ((enemy == 5) && (obj_controller.faction_status[eFACTION.ECCLESIARCHY] != "War")) {
        obj_controller.loyalty -= 50;
        obj_controller.loyalty_hidden -= 50;
        decare_war_on_imperium_audiences();
    }

    if ((exterminatus > 0) && (dropping != 0) && (string_count("mech", battle_special) == 0)) {
        scr_destroy_planet(1);
    }

    if ((string_count("mech", battle_special) > 0) && (defeat == 0)) {
        with (obj_ground_mission) {
            var comp, plan, i;
            i = 0;
            comp = 0;
            plan = 0;
            plan = instance_nearest(x, y, obj_star);
            scr_return_ship(obj_ground_mission.loc, obj_ground_mission, obj_ground_mission.num);
            with (obj_ground_mission) {
                instance_destroy();
            }
        }
    }

    with (obj_ini) {
        for (var i = 0; i <= 10; i++) {
            scr_company_order(i);
            scr_vehicle_order(i);
        }
    }

    obj_controller.x = view_x;
    obj_controller.y = view_y;
    obj_controller.combat = 0;
    obj_controller.marines -= final_marine_deaths;
    obj_controller.command -= final_command_deaths;

    instance_activate_all();

    if (turn_count < 20) {
        if ((defeat == 0) && (threat >= 4)) {
            scr_recent("battle_victory", $"{battle_loc} {scr_roman(battle_id)}", enemy);
        }

        if ((defeat == 1) && (final_marine_deaths + final_command_deaths >= 10)) {
            scr_recent("battle_defeat", $"{enemy}, {final_marine_deaths + final_command_deaths}");
        }
    } else {
        scr_recent("battle_defeat", $"{enemy}, {final_marine_deaths + final_command_deaths}");
    }

    if (((dropping == 1) || (attacking == 1)) && (string_count("_attack", battle_special) == 0) && (string_count("mech", battle_special) == 0) && (string_count("ruins", battle_special) == 0) && (battle_special != "ship_demon")) {
        obj_controller.combat = 0;
        with (obj_drop_select) {
            instance_destroy();
        }
    }
    if ((dropping + attacking == 0) && (string_count("_attack", battle_special) == 0) && (string_count("mech", battle_special) == 0) && (string_count("ruins", battle_special) == 0) && (battle_special != "ship_demon") && (string_count("cs_meeting", battle_special) == 0)) {
        if (instance_exists(obj_turn_end)) {
            var _battle_index = obj_turn_end.current_battle;
            if (_battle_index < array_length(obj_turn_end.battle_object)) {
                var _battle_object = obj_turn_end.battle_object[_battle_index];

                var _planet = obj_turn_end.battle_world[_battle_index];

                _battle_object.p_player[_planet] -= world_size;

                if (defeat == 1) {
                    _battle_object.p_player[_planet] = 0;
                }
            }
            obj_controller.combat = 0;
            with (obj_turn_end) {
                alarm[4] = 1;
            }
        }
    }
    if ((string_count("ruins", battle_special) > 0) && (defeat == 1)) {
        //TODO this logic is wrong assumes all player units died in ruins
        var _combat_star = star_by_name(obj_ncombat.battle_loc);
        if (_combat_star != "none") {
            _combat_star.p_player[obj_ncombat.battle_id] -= obj_ncombat.world_size;
        }
    }

    if (battle_mission == "necron_tomb_excursion") {
        necron_tomb_raid_post_battle_sequence();
    }

    if ((string_count("spyrer", battle_special) > 0) /* and (string_count("demon",battle_special)>0))*/ && (defeat == 0)) {
        instance_activate_object(obj_star);
        // show_message(obj_turn_end.current_battle);
        // show_message(obj_turn_end.battle_world[obj_turn_end.current_battle]);
        // title / text / image / speshul
        var cur_star = obj_turn_end.battle_object[obj_turn_end.current_battle];
        var planet = obj_turn_end.battle_world[obj_turn_end.current_battle];
        var _planet_string = scr_roman_numerals()[planet - 1];

        remove_planet_problem(planet, "spyrer", cur_star);

        var tixt = $"The Spyrer on {cur_star.name} {_planet_string} has been removed.  The citizens and craftsman may sleep more soundly, the Inquisition likely pleased.";

        scr_popup("Inquisition Mission Completed", tixt, "spyrer", "");

        if (obj_controller.demanding == 0) {
            obj_controller.disposition[4] += 2;
        }
        if (obj_controller.demanding == 1) {
            obj_controller.disposition[4] += choose(0, 0, 1);
        }

        scr_event_log("", "Inquisition Mission Completed: The Spyrer on {cur_star.name} {planet} has been removed.", cur_star.name);
        scr_gov_disp(cur_star.name, planet, choose(1, 2, 3, 4));

        instance_deactivate_object(obj_star);
    } else if (battle_special == "protect_raiders") {
        protect_raiders_battle_aftermath();
    } else if (string_count("fallen", battle_special) > 0) {
        hunt_fallen_battle_aftermath();
    } else if ((defeat == 0) && (enemy == 9) && (battle_special == "tyranid_org")) {
        if (captured_gaunt > 1) {
            _pop = instance_create(0, 0, obj_popup);
            _pop.image = "inquisition";
            _pop.title = "Inquisition Mission Completed";
            _pop.text = "You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.";
        }
        if (captured_gaunt == 1) {
            _pop = instance_create(0, 0, obj_popup);
            _pop.image = "inquisition";
            _pop.title = "Inquisition Mission Completed";
            _pop.text = "You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.";
        }
    } else if ((enemy == 1) && (on_ship == true) && (defeat == 0)) {
        var diceh = roll_dice_chapter(1, 100, "high");

        if (diceh <= 15) {
            var ship, ship_hp, i = -1;
            for (var i = 0; i < array_length(obj_ini.ship); i++) {
                ship[i] = obj_ini.ship[i];
                ship_hp[i] = obj_ini.ship_hp[i];
                if (i == battle_id) {
                    obj_ini.ship_hp[i] = -50;
                    scr_recent("ship_destroyed", obj_ini.ship[i], i);
                }
            }
            var _pop = instance_create(0, 0, obj_popup);
            _pop.image = "";
            _pop.title = "Ship Destroyed";
            _pop.text = $"A handful of loyalist {global.chapter_name} make a fighting retreat to the engine of the vessel, '" + string(obj_ini.ship[battle_id]) + "', and then overload the main reactor.  Your ship explodes in a brilliant cloud of fire.";
            scr_event_log("red", $"A handful of loyalist {global.chapter_name} overload the main reactor of your vessel '" + string(obj_ini.ship[battle_id]) + "'.");
            _pop.mission = "loyalist_destroy_ship";

            scr_ini_ship_cleanup();
        }
    }

    if (enemy == 1) {
        if ((battle_special == "cs_meeting_battle1") || (battle_special == "cs_meeting_battle2")) {
            obj_controller.diplomacy = 10;
            scr_toggle_diplomacy();
            with (obj_controller) {
                scr_dialogue("cs_meeting21");
            }
        }

        // Chapter Master just murdered absolutely everyone
        if ((battle_special == "cs_meeting_battle7") && (defeat == 0)) {
            if (obj_controller.chaos_rating < 1) {
                obj_controller.chaos_rating += 1;
            }
            obj_controller.complex_event = false;
            obj_controller.diplomacy = 0;
            obj_controller.menu = 0;
            obj_controller.force_goodbye = 0;
            obj_controller.cooldown = 20;
            obj_controller.current_eventing = "chaos_meeting_end";
            with (obj_temp_meeting) {
                instance_destroy();
            }
            with (obj_popup) {
                instance_destroy();
            }
            if (instance_exists(obj_turn_end)) {
                obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
            }
            var pip;
            pip = instance_create(0, 0, obj_popup);
            pip.title = "Enemies Vanquished";
            pip.text = "Not only have you killed the Chaos Lord, " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + ", but also all of your battle brothers that questioned your rule.  As you stand, alone, among the broken corpses of your enemies you begin to question what exactly it is that you accomplished.  No matter the results, you feel as though your actions have been noticed.";
        }
    }

    if (enemy == 10) {
        if ((battle_special == "cs_meeting_battle10") && (defeat == 0)) {
            obj_controller.complex_event = false;
            obj_controller.diplomacy = 0;
            obj_controller.menu = 0;
            obj_controller.force_goodbye = 0;
            obj_controller.cooldown = 20;
            obj_controller.current_eventing = "chaos_meeting_end";
            with (obj_temp_meeting) {
                instance_destroy();
            }
            with (obj_popup) {
                instance_destroy();
            }
            if (instance_exists(obj_turn_end)) {
                obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
            }
            var pip = instance_create(0, 0, obj_popup);
            pip.title = "Survived";
            pip.text = "You and the rest of your battle brothers fight your way out of the catacombs, back through the tunnel where you first entered.  By the time you manage it your forces are battered and bloodied and in desperate need of pickup.  The whole meeting was a bust- Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " clearly intended to kill you and simply be done with it.";
        }

        if (((battle_special == "cs_meeting_battle5") || (battle_special == "cs_meeting_battle6")) && (defeat == 0)) {
            var mos = false;

            with (obj_ground_mission) {
                instance_destroy();
            }
            with (obj_pnunit) {
                var j = 0;
                repeat (300) {
                    j += 1;
                    if (marine_type[j] == "Master of Sanctity") {
                        instance_create(0, 0, obj_ground_mission);
                    }
                }
            }
            // Master of Sanctity present, wishes to take in the player
            if (instance_exists(obj_ground_mission) && (string_count("CRMOS|", obj_controller.useful_info) == 0)) {
                scr_toggle_diplomacy();
                with (obj_controller) {
                    scr_dialogue("cs_meeting_m5");
                }
            }

            // Master of Sanctity not present, just get told that you have defeated the Chaos Lord
            if ((!instance_exists(obj_ground_mission)) || (string_count("CRMOS|", obj_controller.useful_info) > 0)) {
                // Some kind of popup based on what you were going after

                obj_controller.complex_event = false;
                obj_controller.diplomacy = 0;
                obj_controller.menu = 0;
                obj_controller.force_goodbye = 0;
                obj_controller.cooldown = 20;
                obj_controller.current_eventing = "chaos_meeting_end";
                with (obj_temp_meeting) {
                    instance_destroy();
                }
                with (obj_popup) {
                    instance_destroy();
                }
                if (instance_exists(obj_turn_end)) {
                    obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
                }
                var pip = instance_create(0, 0, obj_popup);
                pip.title = "Chaos Lord Killed";
                pip.text = "(Not completed yet- variable reward based on what chosen)";
            }
            with (obj_ground_mission) {
                instance_destroy();
            }
        }
    }

    if (battle_special == "ship_demon") {
        if (defeat == 1) {
            var ship, ship_hp, i;
            i = -1;
            repeat (51) {
                i += 1;
                ship[i] = obj_ini.ship[i];
                ship_hp[i] = obj_ini.ship_hp[i];
                if (i == battle_id) {
                    obj_ini.ship_hp[i] = -50;
                    scr_recent("ship_destroyed", obj_ini.ship[i], i);
                }
            }
            var _pop = instance_create(0, 0, obj_popup);
            _pop.image = "";
            _pop.title = "Ship Destroyed";
            _pop.text = "The daemon has slayed all of your marines onboard.  It works its way to the engine of the vessel, '" + string(obj_ini.ship[battle_id]) + "', and then tears into the main reactor.  Your ship explodes in a brilliant cloud of fire.";
            scr_event_log("red", "A daemon unbound from an Artifact wreaks havoc upon and destroys your vessel '" + string(obj_ini.ship[battle_id]) + "'.");

            scr_ini_ship_cleanup();
        }
    }

    if (battle_special == "space_hulk") {
        space_hulk_explore_battle_aftermath();
    }

    if (((leader == 1) || (battle_special == "ChaosWarband")) && (obj_controller.faction_defeated[10] == 0) && (defeat == 0) && (battle_special != "WL10_reveal") && (battle_special != "WL10_later")) {
        if ((battle_special != "WL10_reveal") && (battle_special != "WL10_later")) {
            // prolly schedule a popup congratulating
            obj_controller.faction_defeated[enemy] = 1;
            if (obj_controller.known[enemy] == 0) {
                obj_controller.known[enemy] = 1;
            }

            if (battle_special != "ChaosWarband") {
                with (obj_star) {
                    if (string_count("WL" + string(obj_ncombat.enemy), p_feature[obj_ncombat.battle_id]) > 0) {
                        p_feature[obj_ncombat.battle_id] = string_replace(p_feature[obj_ncombat.battle_id], "WL" + string(obj_ncombat.enemy) + "|", "");
                    }
                }
            }
            if (battle_special == "ChaosWarband") {
                obj_controller.faction_defeated[10] = 1; // show_message("WL10 defeated");
                if (instance_exists(obj_turn_end)) {
                    scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                    scr_alert("", "ass", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " has been killed.", 0, 0);
                    scr_popup("Black Crusade Ended", "The Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer at threat by the forces of Chaos.", "", "");
                }
                if (!instance_exists(obj_turn_end)) {
                    scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                    var _pop = instance_create(0, 0, obj_popup);
                    _pop.image = "";
                    _pop.title = "Black Crusade Ended";
                    _pop.text = $"The Chaos Lord {obj_controller.faction_leader[eFACTION.CHAOS]} has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer at threat by the forces of Chaos.";
                }
            }
        }
    }

    instance_activate_all();
    with (obj_pnunit) {
        instance_destroy();
    }
    with (obj_enunit) {
        instance_destroy();
    }
    with (obj_nfort) {
        instance_destroy();
    }
    with (obj_centerline) {
        instance_destroy();
    }
    obj_controller.new_buttons_hide = 0;

    if (instance_exists(obj_cursor)) {
        obj_cursor.image_index = 0;
    }

    instance_destroy();

    /* */
    /*  */
} catch (_exception) {
    handle_exception(_exception);
}
