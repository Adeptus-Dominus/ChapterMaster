function base_inquis_fleet () {
    owner = eFACTION.Inquisition;
    frigate_number = 1;
    sprite_index = spr_fleet_inquisition;
    image_index = 0;
    warp_able = true;
    var roll = roll_dice(1, 100);
    inquisitor = 0;
    trade_goods = "Inqis";
    if (roll > 60){
        var inquis_choice = choose(2, 3, 4, 5);
        inquisitor = inquis_choice;
    }
}

function inquisition_fleet_inspection_chase() {
    var good = 0, acty = "";
    var reset = !instance_exists(target);
    if (!reset) {
        reset = target.object_index != obj_p_fleet;
    }
    if (reset) { // Reacquire target
        var target_player_fleet = get_largest_player_fleet();
        if (target_player_fleet != "none") {
            if (target_player_fleet.action == "") {
                set_fleet_target(target_player_fleet.x, target_player_fleet.y, target_player_fleet);
            } else {
                set_fleet_target(target_player_fleet.action_x, target_player_fleet.action_y, target_player_fleet);
            }                        
        }
    } else {
        var at_star = instance_nearest(target.x, target.y, obj_star).id;
        var target_at_star = instance_nearest(x, y, obj_star).id;
        if (target.action != "") { at_star = 555; }
    
        if (at_star != target_at_star){
            trade_goods += "!";
            acty = "chase";
            scr_loyalty("Avoiding Inspections", "+");
        }
    
        // if (string_count("!",trade_goods)>=3) then demand stop fleet
    
        
        //Inquisitor is pissed as hell
        if (string_count("!", trade_goods) == 5) {
            obj_controller.alarm[8] = 10;
            instance_destroy();
            exit;
        }
    
    
        if (acty == "chase") {
            instance_activate_object(obj_star);
            var goal_x, goal_y, target_meet = 0;
        
            chase_fleet_target_set();
            target_meet = instance_nearest(action_x, action_y, obj_star);
            if (string_count("!", trade_goods) == 4 && instance_exists(obj_turn_end)) {
        
            // color / type / text /x/y
        
                scr_alert("blank","blank","blank",target_meet.x,target_meet.y);
            
                var massa, iq = 0;
                massa = "Inquisitor ";
                if (inquisitor > 0) {
                    iq = inquisitor
                }
            
                massa += string(obj_controller.inquisitor[iq]);
            
                if (target.action == "") { massa+=$" DEMANDS that you keep your fleet at {target_meet.name} until "; }
                if (target.action != "") { massa+=$" DEMANDS that you station your fleet at {target_meet.name} until "; }
        
                scr_event_log("red", $"{massa} they may inspect it.");
                var gender = obj_controller.inquisitor_gender[iq] == 1 ? "he" : "she";
                if (obj_controller.inquisitor_gender[iq] == 1) { massa+=$"{gender} is able to complete the inspection.  Further avoidance will be met with harsh action."; }

                scr_popup("Fleet Inspection", massa, "inquisition", "");
        
            // scr_poup("
            }
        
            exit;
        }
    }
}
// TODO maybe have the inquisitor or his team as an actual entity that goes around and can die, which gives the player time to fix stuff 
// either kill the inquisitor or he dies in combat

// Sets up an inquisitor ship to do an inspection on the HomeWorld
function new_inquisitor_inspection(){
    var target_system = "none";
    var new_inquis_fleet;
    if (obj_ini.fleet_type == ePlayerBase.home_world) {
        var monestary_system = "none";
        // If player does not own their homeworld than do a fleet inspection instead
        var player_stars = [];
        with(obj_star) {
            if (owner == eFACTION.Player) {
                array_push(player_stars, id);
            }
            if (system_feature_bool(p_feature, P_features.Monastery)) {
                monestary_system = self;
            }
        }
        if (monestary_system != "none"){
            target_system = monestary_system;
        } else if (array_length(player_stars) > 0) {
            target_system = player_stars[0];
        }

        if (target_system != "none") {
            var target_star = target_system;
            var tar;
            var xx = target_star.x;
            var yy = target_star.y;

              //get the second or third closest planet to launch inquisitor from
            var from_star = distance_removed_star(target_star.x, target_star.y);
            new_inquis_fleet = instance_create(from_star.x, from_star.y, obj_en_fleet);


            with (new_inquis_fleet) {
                base_inquis_fleet();
                action_x = xx;
                action_y = yy;
                set_fleet_movement();
            }
            var mess = $"Inquisitor {obj_controller.inquisitor[new_inquis_fleet.inquisitor]}";
            mess += $" wishes to inspect your chapter base at {target_star.name}";
            scr_alert("green", "inspect", mess, target_star.x, target_star.y);
            obj_controller.last_world_inspection = obj_controller.turn;
            // we sent an inspection, we are done
            return;
        }
    }
    // otherwise, do a fleet inspection.

    var target_player_fleet = get_largest_player_fleet();
    if (target_player_fleet != "none") {

        //get the second or third closest planet to launch inquisitor from
        var from_star = distance_removed_star(target_player_fleet.x, target_player_fleet.y);

        new_inquis_fleet = instance_create(from_star.x, from_star.y, obj_en_fleet);
        var obj;
        with (new_inquis_fleet) {
            base_inquis_fleet();
            target = target_player_fleet;
            chase_fleet_target_set();
            obj = instance_nearest(action_x, action_y, obj_star);
            trade_goods += "_fleet";
        }

        var mess = $"Inquisitor {obj_controller.inquisitor[new_inquis_fleet.inquisitor]}";

        mess += $" wishes to inspect your fleet at {obj.name}";
        scr_alert("green", "inspect", mess, obj.x, obj.y);

        obj_controller.last_fleet_inspection = obj_controller.turn;

        instance_activate_object(obj_star);
    }
}

function inquisition_inspection_logic(){
    var inspec_alert_string = "";
    var cur_star=instance_nearest(x,y,obj_star);
    inquisitor = inquisitor < 0 ? 0 : inquisitor;
    var inquis_string = $"Inquisitor {obj_controller.inquisitor[inquisitor]}";
     if (string_count("fleet",trade_goods) == 0) {
            inspec_alert_string = $"{inquis_string} finishes inspection of {cur_star.name}";
            inquisition_inspection_loyalty("inspect_world"); // This updates the loyalties
    } else if (string_count("fleet", trade_goods) > 0){
        inspec_alert_string = $"{inquis_string} finishes inspection of your fleet";
        inquisition_inspection_loyalty("inspect_fleet"); // This updates the loyalties
        target = noone;
    }
    if (inspec_alert_string != ""){
        scr_event_log("", inspec_alert_string, cur_star.name);
        scr_alert("green", "duhuhuhu", inspec_alert_string, x, y);
    }

    // Test-Slave Incubator Crap
    if (obj_controller.und_gene_vaults == 0){
        var hur = inquisitor_approval_gene_banks();
        if (hur > 0) {
            if (hur == 1) {
                obj_controller.disposition[eFACTION.Inquisition] -= max(6, round(obj_controller.disposition[eFACTION.Inquisition] * 0.2));
            } else {
                obj_controller.disposition[eFACTION.Inquisition] -= max(3, round(obj_controller.disposition[eFACTION.Inquisition] * 0.1));
            }

            obj_controller.inqis_flag_gene += 1;
            if (obj_controller.inqis_flag_gene == 1) {
                if (hur == 1) {
                    inquis_string += " has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter has plenty enough Gene-Seed to restore itself to full strength and the Incubators on top of that are excessive.  Both have been reported, and you are ordered to remove the Test-Slave Incubators.  Relations with the Inquisition are also more strained than before.";
                } else {
                    inquis_string += " has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter is already at full strength and the Incubators on top of that are excessive.  The Incubators have been reported, and you are ordered to remove them immediately.  Relations with the Inquisition are also slightly more strained than before.";
                }
            } else if (obj_controller.inqis_flag_gene == 2) {
                if (hur == 1) {
                    inquis_string += " has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Both the stores and incubators have been reported, and you are AGAIN ordered to remove the Test-Slave Incubators.  The Inquisitor says this is your final warning.";
                } else {
                    inquis_string += " has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter is already at full strength and the Incubators are unneeded.  The Incubators have been reported, AGAIN, and you are to remove them.  The Inquisitor says this is your final warning.";
                }
            } else if (obj_controller.inqis_flag_gene == 3) {
                if (obj_controller.faction_status[eFACTION.Inquisition] != "War") { obj_controller.alarm[8] = 1; }
            }
            scr_popup("Inquisition Inspection", inquis_string, "inquisition");
        }
    }
}

function inquisitor_approval_gene_banks() {
    var gene_slave_count = 0;
    var hur = 0;
    for (var e = 0; e < array_length(obj_ini.gene_slaves); e++){
        gene_slave_count += obj_ini.gene_slaves[e].num;
    }

    if (obj_controller.marines <= 200) && (gene_slave_count >= 100 && obj_controller.gene_seed >= 1100) {
        hur = 1;
    } else if (obj_controller.marines <= 500 && obj_controller.marines > 200) && (gene_slave_count >= 75 && obj_controller.gene_seed >= 900) {
        hur = 1;
    } else if (gene_slave_count >= 50) {
        if (obj_controller.marines <= 700 && obj_controller.marines > 500 && obj_controller.gene_seed >= 750) {
            hur = 1;
        } else if (obj_controller.marines > 700 && obj_controller.gene_seed >= 500) {
            hur = 1;
        } else if (obj_controller.marines > 990) {
            hur = 2;
        }
    }

    return hur;
}


function inquisitor_ship_approaches(){
    //TODO figure out the meaning of this line
    if ((string_count("eet", trade_goods) != 0) && (string_count("_her", trade_goods) != 0)) { exit; }
    var approach_system = instance_nearest(action_x, action_y, obj_star);
    var inquis_string;
    var do_alert = false;
    if (string_count("fleet",trade_goods)>0 &&  scr_valid_fleet_target(target)){
        var player_fleet_location = fleets_next_location(target);
        if (player_fleet_location != "none"){
            if (approach_system.name == player_fleet_location.name){
                inquis_string = $"Our navigators report that an inquisitor's ship is currently warping towards our flagship. It is likely that the inquisitor on board (provided he/she makes it) will attempt to perform an inspection of our flagship.";
                do_alert = true;
                if (fleet_has_roles(target, ["Ork Sniper", "Flash Git", "Ranger"])) {
                    inquis_string += $"Currently, there are non-imperial hirelings within the fleet. It would be wise to at least unload them on a planet below, if we wish to remain in good graces with inquisition, and possibly imperium at large.";
                }
            }
        }
    } else if (approach_system.owner  == eFACTION.Player || system_feature_bool(approach_system.p_feature, P_features.Monastery)) {
        do_alert = true;
        if (system_feature_bool(approach_system.p_feature, P_features.Monastery)){
            inquis_string = $"Our astropaths report that an inquisitor's ship is currently warping towards our Fortress Monastery. It is likely that theInquisitor {obj_controller.inquisitor[inquisitor]}  will attempt to perform inspection on our Fortress Monastery.";
        } else {
            inquis_string = $"Our astropaths report that an inquisitor's ship is currently warping towards our systems under chapter control. It is likely that Inquisitor {obj_controller.inquisitor[inquisitor]}  will want to make inspections of any chapter assets and fleets in the system.";
        }
    }
    if (do_alert) {
        approach_system = instance_nearest(action_x, action_y, obj_star).name;
        if (inquisitor==0){
            scr_alert("green", "duhuhuhu", $"Inquisitor Ship approaches {approach_system}.", x, y);
        } else {
            scr_alert("green", "duhuhuhu", $"Inquisitor {obj_controller.inquisitor[inquisitor]} approaches {approach_system}.", x, y);
        }
        scr_popup("Inquisition Inspection", inquis_string, "");
    }
}

function inquisition_inspection_loyalty(inspection_type) {
if (inspection_type="inspect_world") || (inspection_type="inspect_fleet") {
        var diceh, that, wid, hurr;
        diceh = 0; that = 0; wid = 0; hurr = 0;
    
        var sniper, finder, git, demonic;
        sniper=0; finder = 0; git = 0; demonic = 0;
    
    
        if (inspection_type="inspect_world") {

            that = instance_nearest(x, y, obj_star);
            // show_message(that);
            instance_activate_object(obj_en_fleet);
            
            for (var i = 1; i <= that.planets; i++){
                if (that.p_hurssy[i] > 0) { hurr += that.p_hurssy[i]; }
            }
            var unit;
            for (var g = 1; g < array_length(obj_ini.artifact); g++) {
                if (obj_ini.artifact[g] != "" && obj_ini.artifact_loc[g] == that.name) {
                    if (obj_ini.artifact_struct[g].inquisition_disprove() && !obj_controller.und_armouries) {
                        hurr += 8;
                        demonic += 1;
                    }
                }
            }

            for (var ca = 0; ca < 11; ca++) {
                for (var ia = 0; ia < 500; ia++){
                    unit = fetch_unit([ca, ia]);
                    if (obj_ini.loc[ca][ia] == that.name) {
                        if (obj_ini.race[ca][ia] != 1) {
                            switch (unit.role()) {
                            case "Ork Sniper":
                                sniper += 1;
                                break;
                            case "Flash Git":
                                git += 1;
                                break;
                            case "Ranger":
                                finder += 1;
                                break;
                            }
                            hurr += 1;
                        }
                        var artis = unit.equipped_artifacts();
                        for (var art = 0; art < array_length(artis); art++) {
                            var artifact = obj_ini.artifact_struct[artis[art]];
                            if (artifact.inquisition_disprove()) {
                                hurr += 8;
                                demonic += 1;
                            }
                        }
                    }
                }
            }
        }
    
        if (inspection_type == "inspect_fleet") {
            with(obj_en_fleet) {
                if (string_count("Inqis", trade_goods) == 0 || owner != eFACTION.Inquisition) { instance_deactivate_object(id); }
            }
            if (instance_exists(obj_en_fleet) && instance_exists(obj_p_fleet)){
                var player_inspection_fleet = instance_nearest(obj_en_fleet.x, obj_en_fleet.y, obj_p_fleet);
                var player_ships = fleet_full_ship_array(player_inspection_fleet);

                for (var g = 1; g < array_length(obj_ini.artifact); g++) {
                    if (obj_ini.artifact[g] != "") {
                        var _ship_hash = variable_get_hash(obj_ini.artifact_sid[g].ship);
                        var _ships = [capital, frigate, escort];
                        var _ships_count = array_length(_ships);
                        for (var i = 0; i < _ships_count; i++) {
                            if (struct_exists(_ships[i], _ship_hash)) {
                                if (!obj_controller.und_armouries && obj_ini.artifact_struct[g].inquisition_disprove()) {
                                    hurr += 8;
                                    demonic += 1;
                                }
                            }
                        }
                    }
                }
                var unit;
                if (player_inspection_fleet.hurssy > 0) { hurr += player_inspection_fleet.hurssy; }
                var ca, ia;
                for (ca = 0; ca < 11; ca++){
                    for (ia = 0; ia < array_length(obj_ini.role[ca]); ia++) {
                        unit = fetch_unit([ca, ia]);
                        if (unit.name() == "") { continue; }
                        //array_contains(player_ships, unit.ship_location)
                        if (geh = 1) {
                            unit = fetch_unit([ca, ia]);
                            if (unit.name() == "") { continue; }
                            if (obj_ini.race[ca][ia] != 1) {
                                switch (unit.role()) {
                                case "Ork Sniper":
                                    sniper += 1;
                                    break;
                                case "Flash Git":
                                    git += 1;
                                    break;
                                case "Ranger":
                                    finder += 1;
                                    break;
                                }
                                hurr += 1;
                            }
                            var artis = unit.equipped_artifacts();
                            for (var art = 0; art < array_length(artis); art++){
                                var artifact = obj_ini.artifact_struct[artis[art]];
                                if (artifact.inquisition_disprove()) {
                                    hurr += 8;
                                    demonic += 1;
                                }
                            }
                        }
                    }
                }
            }
            instance_activate_object(obj_en_fleet);
        }
    
        if (hurr > 0) {
            var hurrr = floor(random(12))+1;
            if (hurrr <= hurr) {
                obj_controller.alarm[8] = 1;
                if (demonic > 0) { scr_alert("red", "inspect", "Inquisitor discovers Daemonic item(s) in your posession.", 0, 0); }
                if (sniper > 0) { scr_alert("red", "inspect", "Inquisitor discovers Ork Sniper(s) hired by your chapter.", 0, 0); }
                if (git > 0) { scr_alert("red", "inspect", "Inquisitor discovers Flash Git(z) hired by your chapter.", 0, 0); }
                if (finder > 0) { scr_alert("red", "inspect", "Inquisitor discovers Eldar Ranger(s) hired by your chapter.", 0, 0); }
                if (demonic + sniper + git + finder == 0) { scr_alert("red", "inspect", "Inquisitor discovers heretical material in your posession.", 0, 0); }
            }
        }

        var i = 0;
        repeat(22) {
            i += 1; diceh = 0;
        
            if (obj_controller.loyal_num[i] < 1 && obj_controller.loyal_num[i] > 0 && obj_controller.loyal[i] != "Avoiding Inspections") {
                diceh = roll_dice(1, 100, "low");
            
                if (diceh <= (obj_controller.loyal_num[i] * 1000)) {
                    if (obj_controller.loyal[i] == "Heretic Contact") {
                        obj_controller.loyal_num[i] = 80;
                        obj_controller.loyal_time[i] = 9999;
                        scr_alert("red", "inspect", "Inquisitor discovers evidence of Chaos Lord correspondence.", 0, 0);

                        var one = 0;
                        if (one == 0) {
                            if (obj_controller.disposition[eFACTION.Inquisition] >= 80) {
                                obj_controller.disposition[eFACTION.Inquisition] = 30;
                                one = 1;
                            } else if (obj_controller.disposition[eFACTION.Inquisition] < 80) && (obj_controller.disposition[eFACTION.Inquisition] > 10) {
                                obj_controller.disposition[eFACTION.Inquisition] = 5;
                                one = 2;
                            } else if (obj_controller.disposition[eFACTION.Inquisition] <= 10) {
                                obj_controller.disposition[eFACTION.Inquisition] = 0;
                                one = 3;
                            }
                        }
                    
                        if ((obj_controller.loyalty - 80) <= 0 && one < 3) { one = 3; }
                        if (one == 1) {
                            with(obj_controller) { scr_audience(4, "chaos_audience1", 0, "", 0, 0); }
                        } else if (one == 2) {
                            with(obj_controller) { scr_audience(4, "chaos_audience2", 0, "", 0, 0); }
                        } else if (one == 3) {
                            obj_controller.alarm[8] = 1;
                        }
                    }

                    switch (obj_controller.loyal[i]) {
                    case "Heretical Homeworld":
                    case "Undevout":
                        obj_controller.loyal_num[i] = 20;
                        obj_controller.loyal_time[i] = 3;
                        break;
                    case "Mutant Gene-Seed":
                    case "Traitorous Marines":
                        obj_controller.loyal_num[i] = 30;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Non-Codex Arming":
                    case "Non-Codex Size":
                        obj_controller.loyal_num[i] = 12;
                        obj_controller.loyal_time[i] = 3;
                        break;
                    case "Lack Of Apothecary":
                    case "Upset Machine Spirits":
                        obj_controller.loyal_num[i] = 8;
                        obj_controller.loyal_time[i] = 1;
                        break;
                    case "Irreverance for His Servants":
                        obj_controller.loyal_num[i] = 12;
                        obj_controller.loyal_time[i] = 5;
                        break;
                    case "Unvigilant":
                        obj_controller.loyal_num[i] = 12;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Conduct Unbecoming":
                        obj_controller.loyal_num[i] = 8;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Refusing to Crusade":
                        obj_controller.loyal_num[i] = 20;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Eldar Contact":
                    case "Ork Contact":
                    case "Tau Contact":
                        obj_controller.loyal_num[i] = 4;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Xeno Trade":
                    case "Xeno Associate":
                        obj_controller.loyal_num[i] = 20;
                        obj_controller.loyal_time[i] = 9999;
                        break;
                    case "Inquisitor Killer":
                        obj_controller.loyal_num[i] = 100;
                        obj_controller.loyal_time[i] = 9999;
                        break;
//                    case "Avoiding Inspections":
//                        obj_controller.loyal_num[i] = 20;
//                        obj_controller.loyal_time[i] = 120;
//                        break;
//                    case "Lost Standard":
//                        obj_controller.loyal_num[i] = 10;
//                        obj_controller.loyal_time[i] = 9999;
//                        break;
                    }

                    obj_controller.loyalty_hidden -= obj_controller.loyal_num[i];
                }
            }
        }// End repeat
        obj_controller.loyalty = obj_controller.loyalty_hidden;
    }    
}
