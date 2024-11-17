function scr_battle_roster(required_location, _target_location, _is_planet) {

    // Determines who all will be present for the battle

    // argument 0 : planet or ship name
    // argument 1 : world number (wid)
    // argument 2 : is it a planet?  boolean

    //--------------------------------------------------------------------------------------------------------------------
    // Global objects used.
    //--------------------------------------------------------------------------------------------------------------------
    var func = function(required_location, _target_location, _is_planet){
        new_combat = obj_ncombat;
        //???=obj_drop_select;
        //???=obj_controller
        //--------------------------------------------------------------------------------------------------------------------

        // show_message("Container:"+string(_battle_loci)+", number:"+string(_loci_specific)+", planet?:"+string(_is_planet));

        var stop, okay, sofar, man_limit_reached, man_size_count, unit, unit_location, _u_role,column_decided,squad;
        stop = 0;
        okay = 0;
        sofar = 0;
        man_limit_reached = false;
        man_size_count = 0;


        // Formation here
        obj_controller.bat_devastator_column = obj_controller.bat_deva_for[new_combat.formation_set];
        obj_controller.bat_assault_column = obj_controller.bat_assa_for[new_combat.formation_set];
        obj_controller.bat_tactical_column = obj_controller.bat_tact_for[new_combat.formation_set];
        obj_controller.bat_veteran_column = obj_controller.bat_vete_for[new_combat.formation_set];
        obj_controller.bat_hire_column = obj_controller.bat_hire_for[new_combat.formation_set];
        obj_controller.bat_librarian_column = obj_controller.bat_libr_for[new_combat.formation_set];
        obj_controller.bat_command_column = obj_controller.bat_comm_for[new_combat.formation_set];
        obj_controller.bat_techmarine_column = obj_controller.bat_tech_for[new_combat.formation_set];
        obj_controller.bat_terminator_column = obj_controller.bat_term_for[new_combat.formation_set];
        obj_controller.bat_honor_column = obj_controller.bat_hono_for[new_combat.formation_set];
        obj_controller.bat_dreadnought_column = obj_controller.bat_drea_for[new_combat.formation_set];
        obj_controller.bat_rhino_column = obj_controller.bat_rhin_for[new_combat.formation_set];
        obj_controller.bat_predator_column = obj_controller.bat_pred_for[new_combat.formation_set];
        obj_controller.bat_landraider_column = obj_controller.bat_land_for[new_combat.formation_set];
        obj_controller.bat_scout_column = obj_controller.bat_scou_for[new_combat.formation_set];

        var v = 0;
        var meeting = false;

        instance_activate_object(obj_pnunit);

        //For each company and the HQ
        for (var company=0;company<=10;company++){
            if (man_limit_reached) {
                break;
            }
    		for (v=0;v<array_length(obj_ini.TTRPG[company]);v++){
                column_decided=false;
                okay = 0;
    			unit = obj_ini.TTRPG[company][v];
    			if (unit.name() == ""){continue}
                if (man_limit_reached) {
                    break;
                }
                if (unit.hp()<=0 || unit.in_jail()) then continue;
                unit_location =  unit.marine_location();
                //array[0] set to 0, so the proper array starts at array[1], for some reason

                if (stop == 0) {
                    //Special (okay -1) battle cases go here
                    if (string_count("spyrer", new_combat.battle_special) > 0) or(new_combat.battle_special == "space_hulk") or(string_count("chaos_meeting", new_combat.battle_special) > 0) {
                        if (string_count("Dread", obj_ini.armour[company][v]) > 0) then okay = -1;
                    }
                    if (string_count("spyrer", new_combat.battle_special) > 0) {
                        if (okay == 1) and(sofar > 2) then okay = -1;
                    }
                    if (okay <= -1) then new_combat.fighting[company][v] = 0;

                    //Normal and other battle cases checks go here
                    else if (okay >= 0) {
                        if (instance_exists(obj_ground_mission)) { //Exploring ruins ambush case
                            if (obj_ini.loc[company][v] == required_location) and(unit.planet_location == _target_location) {
                                okay = 1;
                            } else {
                                continue;
                            }
                        } else if (!instance_exists(obj_drop_select)) { // Only when attacked, normal battle
                            if (_is_planet) and(obj_ini.loc[company][v] == required_location) and(unit.planet_location == _target_location)  then okay = 1;
                            else if (!_is_planet) and(unit.ship_location == _target_location) then okay = 1;

                            if (instance_exists(obj_temp_meeting)) {
                                meeting = true;
                                if (company == 0) and(v <= obj_temp_meeting.dudes) and(obj_temp_meeting.present[v] == 1) then okay = 1;
                                else if (company > 0) or(v > obj_temp_meeting.dudes) then okay = 0;
                            }
                        } else if (instance_exists(obj_drop_select)) { // When attacking, normal battle
                            //If not fighting (obj_drop_select pre-check), we skip the unit
                            if (obj_drop_select.fighting[company][v] == 0) then okay = 0;

                            else if (obj_drop_select.attack == 1) {
                                if (_is_planet) and(obj_ini.loc[company][v] == required_location) and(unit.planet_location == _target_location)   then okay = 1;
                                else if (!_is_planet) and(unit.ship_location == _target_location) then okay = 1;
                            } else if (obj_drop_select.attack != 1) {
                                //Related to defensive battles (¿?). Without the above check, it duplicates marines on offensive ones.
                                if (obj_drop_select.fighting[company][v] == 1) and(unit.ship_location == _target_location) then okay = 1;
                            }
                        }
                    }

                    // Start adding unit to battle
                    if (okay >= 1) {
                        var man_size = 1;

                        //Same as co/company and v, but with extra comprovations in case of a meeting (meeting?) 
                        var cooh, va;
                        cooh = 0;
                        va = 0;

                        if (!meeting) {
                            cooh = company;
                            va = v;
                        }else {
                            if (v <= obj_temp_meeting.dudes) {
                                cooh = obj_temp_meeting.company[v];
                                va = obj_temp_meeting.ide[v];
                            }
                        }

                        var col = 0,targ = 0,moov = 0;
                        _u_role = unit.role();

                        if (new_combat.battle_special == "space_hulk") then new_combat.player_starting_dudes++;
                        if (unit.role() = obj_ini.role[100][18]) {
                        	col = obj_controller.bat_tactical_column;				    //sergeants
                            new_combat.sgts++;
                        }else if (unit.role() = obj_ini.role[100, 19]){
                            col = obj_controller.bat_veteran_column;
                            new_combat.vet_sgts++;                        
                        }
                        if (unit.role() = obj_ini.role[100, 12]) {				//scouts
                            col = obj_controller.bat_scout_column;
                            new_combat.scouts++;

                        }else if (array_contains( [obj_ini.role[100][8], $"{obj_ini.role[100, 15]} Aspirant", $"{obj_ini.role[100, 14]} Aspirant"] , unit.role())) {
                            col = obj_controller.bat_tactical_column;				    //tactical_marines
                            new_combat.tacticals++;
                        }else if (unit.role() = obj_ini.role[100, 3]){			//veterans and veteran sergeants
                            col = obj_controller.bat_veteran_column;
                            new_combat.veterans++;
                        }else if (unit.role() = obj_ini.role[100, 9]) {			//devastators
                            col = obj_controller.bat_devastator_column;
                            new_combat.devastators++;
                        }else if(unit.role() = obj_ini.role[100, 10]){			//assualt marines
                            col = obj_controller.bat_assault_column;
                            new_combat.assaults++;

                            //librarium roles

                        }else if (unit.IsSpecialist("libs",true)){
                            col = obj_controller.bat_librarian_column;					//librarium
                            new_combat.librarians++;
                            moov = 1;
                        }else if (unit.role() = obj_ini.role[100, 16]) {			//techmarines
                            col = obj_controller.bat_techmarine_column;
                            new_combat.techmarines++;
                            moov = 2;
                        } else if (unit.role() = obj_ini.role[100, 2]) {			//honour guard
                            col = obj_controller.bat_honor_column;
                            new_combat.honors++;

                        } else if (unit.IsSpecialist("dreadnoughts")){
                            col = obj_controller.bat_dreadnought_column;				//dreadnoughts
                            new_combat.dreadnoughts++;
                        }else if (unit.role() = obj_ini.role[100][4]) {			//terminators
                            col = obj_controller.bat_terminator_column;
                            new_combat.terminators++;
                        }

                        if (moov > 0) {
                            if ((moov = 1) and(obj_controller.command_set[8] = 1)) or((moov = 2) and(obj_controller.command_set[9] = 1)) {
                                if (company >= 2) then col = obj_controller.bat_tactical_column;
                                if (company = 10) then col = obj_controller.bat_scout_column;
                                if (obj_ini.mobi[cooh][va] = "Jump Pack") {
                                    col = obj_controller.bat_assault_column;
                                }
                            }
                        }

                        if (unit.role() = obj_ini.role[100, 15]) or(unit.role() = obj_ini.role[100, 14]) or(string_count("Aspirant", unit.role()) > 0) {
                            if (unit.role() = string(obj_ini.role[100, 14]) + " Aspirant") {
                                col = obj_controller.bat_tactical_column;
                                new_combat.tacticals++;
                            }

                            if (unit.role() = obj_ini.role[100, 15]) then new_combat.apothecaries++;
                            if (unit.role() = obj_ini.role[100, 14]) {
                                new_combat.chaplains++;
                                if (new_combat.big_mofo > 5) then new_combat.big_mofo = 5;
                            }

                            col = obj_controller.bat_tactical_column;
                            if (obj_ini.armour[cooh][va] = "Terminator Armour") or(obj_ini.armour[cooh][va] = "Tartaros Armour") {
                                col = obj_controller.bat_terminator_column;
                            }
                            if (company = 10) then col = obj_controller.bat_scout_column;
                        }

                        if (unit.role() = obj_ini.role[100, 5]) or(unit.role() = obj_ini.role[100][11]) or(unit.role() = obj_ini.role[100, 7]) {
                            if (unit.role() = obj_ini.role[100, 5]) {
                                new_combat.captains++;
                                if (new_combat.big_mofo > 5) then new_combat.big_mofo = 5;
                            }
                            if (unit.role() = obj_ini.role[100][11]) then new_combat.standard_bearers++;
                            if (unit.role() = obj_ini.role[100, 7]) then new_combat.champions++;

                            //if (company = 1) {
                            //    col = obj_controller.bat_veteran_column;
                            //    if (obj_ini.armour[cooh][va] = "Terminator Armour") then col = obj_controller.bat_terminator_column;
                            //    if (obj_ini.armour[cooh][va] = "Tartaros Armour") then col = obj_controller.bat_terminator_column;
                            //}
                            if (company >= 2) then col = obj_controller.bat_tactical_column;
                            if (company = 10) then col = obj_controller.bat_scout_column;
                            if (obj_ini.mobi[cooh][va] = "Jump Pack") then col = obj_controller.bat_assault_column;
                        }

                        if (unit.role() = "Chapter Master") {
                            col = obj_controller.bat_command_column;
                            new_combat.important_dudes++;
                            new_combat.big_mofo = 1;
                            if (string_count("0", obj_ini.spe[cooh][va]) > 0) then new_combat.chapter_master_psyker = 1;
                            else {
                                new_combat.chapter_master_psyker = 0;
                            }
                        }
                        if (unit.IsSpecialist("heads")){
                            col = obj_controller.bat_command_column;
                            new_combat.important_dudes++;                       
                        };
                        if (new_combat.big_mofo > 2) then new_combat.big_mofo = 2;
                        if (new_combat.big_mofo > 3) then new_combat.big_mofo = 3;
                        if (unit.squad!="none"){
                            squad = obj_ini.squads[unit.squad];
                            switch(squad.formation_place){
                                case "assault":
                                    col = obj_controller.bat_assault_column;
                                    column_decided=true;
                                    break;
                                case "veteran":
                                    col = obj_controller.bat_veteran_column;
                                    column_decided=true;
                                    break;
                                 case "tactical":
                                    col = obj_controller.bat_tactical_column;
                                    column_decided=true; 
                                    break;
                                 case "devastator":
                                    col = obj_controller.bat_devastator_column;
                                    column_decided=true; 
                                    break;
                                 case "terminator":
                                    col = obj_controller.bat_terminator_column;
                                    column_decided=true; 
                                    break;
                                case "command":
                                    col = obj_controller.bat_command_column;
                                    column_decided=true; 
                                    break;                                                                                                                      
                            }
                        }
                        if (col = 0) then col = obj_controller.bat_hire_column;

                        targ = instance_nearest(col * 10, 240, obj_pnunit);
                        with (targ){
                            scr_add_unit_to_roster(unit);
                        }

                        if (unit.role() = "Death Company") { // Ahahahahah
                            var really;
                            really = false;
                            if (string_count("Dreadnought", targ.marine_armour[targ.men]) > 0) then really = true;
                            if (really = false) then new_combat.thirsty++;
                            if (really = true) then new_combat.really_thirsty++;
                            col = max(obj_controller.bat_assault_column, obj_controller.bat_command_column, obj_controller.bat_honor_column, obj_controller.bat_dreadnought_column, obj_controller.bat_veteran_column);
                        }
                        // info for ai targetting armour and what they think is best. TODO find out what marine_ranged and attack does

                        // marine_attack[i]=1;
                        // marine_ranged[i]=1;
                        // marine_defense[i]=1;

                        if (obj_ini.mobi[cooh][va] = "Bike") {
                            man_Size = 3;
                        }
                        if (obj_ini.mobi[cooh][va] = "Jump Pack") {
                            man_Size = 2;
                        }

                        //evaluates if there is a limit on the size of men that can be in a battle and only adds the allowable number to roster
                        if (new_combat.man_size_limit == 0) {
                            new_combat.fighting[cooh][va] = 1;
                            sofar++;
                        } else {
                            if (man_size_count + man_size <= new_combat.man_size_limit) {
                                new_combat.fighting[cooh][va] = 1;
                                sofar++;
                                man_size_count += man_size;
                                if (man_size_count == new_combat.man_size_limit) {
                                    man_limit_reached = true;
                                }
                            }
                        }
                    }

                    // Vehicle checks
                    if (v <= 100) and(string_count("spyrer", new_combat.battle_special) = 0) and(company <= 10) and(meeting = false) {
                        var vokay;
                        vokay = 0;

                        if (obj_ini.veh_race[company][v] != 0) and(obj_ini.veh_loc[company][v] = required_location) and(obj_ini.veh_wid[company][v] = _target_location) then vokay = 1;

                        if (_is_planet) and(new_combat.local_forces = 1) {
                            var world_name, p_num;
                            world_name = "";
                            p_num = obj_controller.selecting_planet;
                            if (instance_exists(obj_drop_select)) {
                                world_name = obj_drop_select.p_target.name;
                            }
                            if (obj_ini.veh_race[company][v] != 0) and(obj_ini.veh_loc[company][v] = world_name) and(obj_ini.veh_wid[company][v] = p_num) then vokay = 2;
                        }
                        if (!_is_planet) and(obj_ini.veh_lid[company][v] = _target_location) and(obj_ini.veh_hp[company][v] > 0) then vokay = 1;

                        if (instance_exists(obj_drop_select)) {
                            if (obj_drop_select.attack = 0) then vokay = 0;
                        }


                        // if (obj_ncombat.veh_fighting[company,v]=1) then vokay=2;// Fuck on me, AI

                        if (vokay >= 1) and(new_combat.dropping = 0) {
                            new_combat.veh_fighting[company][v] = 1;

                            var col = 1, targ = 0;

                            switch (obj_ini.veh_role[company][v]){
                                case "Rhino":
                                    col = obj_controller.bat_rhino_column;
                                    new_combat.rhinos++;
                                    break;
                                case "Predator":
                                    col = obj_controller.bat_predator_column;
                                    new_combat.predators++;
                                    break;
                                 case "Land Raider":
                                    col = obj_controller.bat_landraider_column;
                                    new_combat.land_raiders++;
                                    break;
                                 case "Whirlwind":
                                    col = 1;
                                    new_combat.whirlwinds++;
                                    break;                                    
                            }

                            targ = instance_nearest(col * 10, 240 / 2, obj_pnunit);
                            targ.veh++;
                            targ.veh_co[targ.veh] = company;
                            targ.veh_id[targ.veh] = v;
                            targ.veh_type[targ.veh] = obj_ini.veh_role[company][v];
                            targ.veh_wep1[targ.veh] = obj_ini.veh_wep1[company][v];
                            targ.veh_wep2[targ.veh] = obj_ini.veh_wep2[company][v];
                            targ.veh_wep3[targ.veh] = obj_ini.veh_wep3[company][v];
                            targ.veh_upgrade[targ.veh] = obj_ini.veh_upgrade[company][v];
                            targ.veh_acc[targ.veh] = obj_ini.veh_acc[company][v];
                            if (vokay = 2) then targ.veh_local[targ.veh] = 1;


    						if (obj_ini.veh_role[company][v] = "Land Speeder") {
    						targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 3;
                                targ.veh_hp_multiplier[targ.veh] = 3;
                                targ.veh_ac[targ.veh] = 30;
                            }
                            if (obj_ini.veh_role[company][v] = "Rhino") or(obj_ini.veh_role[company][v] = "Whirlwind") {
                                targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 5;
                                targ.veh_hp_multiplier[targ.veh] = 5;
                                targ.veh_ac[targ.veh] = 40;
                            }
                            if (obj_ini.veh_role[company][v] = "Predator") {
                                targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 6;
                                targ.veh_hp_multiplier[targ.veh] = 6;
                                targ.veh_ac[targ.veh] = 45;
                            }
                            if (obj_ini.veh_role[company][v] = "Land Raider") {
                                targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 8;
                                targ.veh_hp_multiplier[targ.veh] = 8;
                                targ.veh_ac[targ.veh] = 50;
                            }

                            // STC Bonuses
                            if (targ.veh_type[targ.veh] != "") {
                                if (obj_controller.stc_bonus[3] = 1) {
                                    targ.veh_hp[targ.veh] = round(targ.veh_hp[targ.veh] * 1.1);
                                    targ.veh_hp_multiplier[targ.veh] = targ.veh_hp_multiplier[targ.veh] * 1.1;
                                }
                                if (obj_controller.stc_bonus[3] = 2) {
                                    //TODO reimplement STC bonus for ranged vehicle weapons
                                    //veh ranged isn't a thing sooooo.... oh well
                                    //targ.veh_ranged[targ.veh] = targ.veh_ranged[targ.veh] * 1.05;
                                }
                                if (obj_controller.stc_bonus[3] = 5) {
                                    targ.veh_ac[targ.veh] = round(targ.veh_ac[targ.veh] * 1.1);
                                }
                                if (obj_controller.stc_bonus[4] = 1) {
                                    targ.veh_hp[targ.veh] = round(targ.veh_hp[targ.veh] * 1.1);
                                    targ.veh_hp_multiplier[targ.veh] = targ.veh_hp_multiplier[targ.veh] * 1.1;
                                }
                                if (obj_controller.stc_bonus[4] = 2) {
                                    targ.veh_ac[targ.veh] = round(targ.veh_ac[targ.veh] * 1.1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    try_and_report_loop("battle roster collection",func, false,[required_location, _target_location, _is_planet]);
}