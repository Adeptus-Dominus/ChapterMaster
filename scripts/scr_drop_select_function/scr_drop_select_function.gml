enum DropType {
    RaidAttack=0,
    PurgeSelect,
    PurgeBombard,
    PurgeFire,
    PurgeSelective,
    PurgeAssassinate
}

function drop_select_draw(){
	with (obj_drop_select){
	if (purge != DropType.PurgeSelect) {
        w = 660;
        h = 520;
        // Center of the screen
        var _x_center = main_slate.XX;
        var _y_center = main_slate.YY;
        var x1 = _x_center
        var y1 = _y_center;
        var x2 = x1 + w;
        var y2 = y1 + h;
        var x3 = (x1 + x2) / 2;
        var y3 = (y1 + y2) / 2;

        if (purge ==DropType.RaidAttack){
            draw_set_font(fnt_40k_30b);
    
            // var xx,yy;
            // xx=view_xview[0]+545;yy=view_yview[0]+212;
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            var attack_type = attack ? "Attacking" : "Raiding"
            draw_text_transformed(x1 + 40, y1 + 38, $"{attack_type} ({planet_numeral_name(planet_number, p_target)} )", 0.6, 0.6, 0);
            var _offset = x1 + 40;
            draw_set_font(fnt_40k_14);
            for (var i=0;i<array_length(roster.company_buttons);i++){
                var _button = roster.company_buttons[i];
                _button.x1 = _offset
                _button.y1 = y1 + 60;
                _button.update();
                _button.draw();
                if (_button.company_present) {
                    if (_button.clicked()) {               
                        roster.update_roster();
                    }
                }
                _offset+=_button.width;
            }
    
            // Planet icon here
            // draw_rectangle(xx+1084,yy+215,xx+1142,yy+273,0);
    
            // Formation
            formation.x1 = x1 + 420;
            formation.y1 = y1 + 80;
            formation.str1 = $"Formation: {obj_controller.bat_formation[formation_possible[formation_current]]}";
            formation.update();
            formation.draw();
            if (formation.clicked()) {
                formation_current++;
                if (formation_current>=array_length(formation_possible)){
                    formation_current = 0;
                }
            }
    
            // Ships Are Up, Fuck Me
            draw_set_color(c_gray);
            draw_text(x1 + 40, 273, "Available Forces:");
        }
        var e = 0;
        var sigh = 0;
        var sip = 1;
        var column = 1;
        var row = 1;
        var x8 = 552;
        var y8 = 299;

        var add_ground = 0;

        // Local force button;

        // Ship buttons;
        if (purge != DropType.PurgeBombard){
            var _local_button = roster.local_button;
            _local_button.x1 = x8
            _local_button.y1 = y8
            _local_button.update();
            _local_button.draw();
            if (_local_button.clicked()) {
                roster.update_roster();
            }     
        }   
        y8 += 21;

        var _all_active = true;

        for (var e=0;e<array_length(roster.ships);e++) {
            var _ship_button = roster.ships[e];
            _ship_button.x1 = x8
            _ship_button.y1 = y8
            _ship_button.update();
            _ship_button.draw();           
            if (_ship_button.clicked()) {
                roster.update_roster();
            }
            if (_ship_button.hover()){
                roster.update_local_string(_ship_button.ship_id);
            }
            if (!_ship_button.active){
                _all_active=false;
            }
            y8 += 21;
            if (e%9 == 0 && e!=0){
                y8 = 320;
                x8 = 700;
            }
        }

        var _select_all_button = roster.select_all_ships;

        if (_select_all_button.draw()){
            for (var e=0;e<array_length(roster.ships);e++) {
                var _ship_button = roster.ships[e];
                _ship_button.active = !_ship_button.active;
            }        
            roster.update_roster();
        } 
        draw_set_font(fnt_40k_14);
        draw_set_color(c_gray);
        draw_set_alpha(1);

        // Unit types buttons;
        var _squads_box = {
            header: "Selected Squads:",
            x1: x1 + 40,
            y1: y2 - 180
        };
        draw_text(_squads_box.x1, _squads_box.y1, _squads_box.header);
        var _x_offset = 0;
        var _row = 0;
        var loop_cycle = array_length(roster.squad_buttons);
        loop_cycle = array_length(roster.vehicle_buttons) ? loop_cycle+array_length(roster.vehicle_buttons)-1 : loop_cycle
        var _squad_length = array_length(roster.squad_buttons);
        var _button;
        for (var i = 0; i < loop_cycle; i++){

            if (i<_squad_length){
                _button = roster.squad_buttons[i];
            } else {
                _button = roster.vehicle_buttons[i-_squad_length];
            }

            if (_x_offset + _button.width > 590){
                _row++;
                _x_offset = 0;
            }
            _button.x1 = (_squads_box.x1) + _x_offset;
            _button.y1 = (_squads_box.y1 + string_height(_squads_box.header) + 10) + _row * 28;
            _button.update();
            _button.draw();

            if (_button.clicked()) {               
                roster.update_roster();
            }

            _x_offset += _button.width +10;
        }

        // draw_text(x2 + 14, y2 + 352, string_hash_to_newline("Selection: " + string(smin) + "/" + string(smax)));

        // Target
        if (purge == DropType.RaidAttack){
            var target_race = "",
                target_threat = "",
                race_quantity = 0;
            var races = ["", "Ecclesiarchy", "Eldar", "Orks", "Tau", "Tyranids", "Heretics", "CSMs", "Daemons", "Necrons"];
            var threat_levels = ["", "Negligible", "Minor", "Moderate", "High", "Very High", "Overwhelming"];
            var race_quantities = [0, sisters, eldar, ork, tau, tyranids, traitors, csm, demons, necrons];

            if (attacking >= 5 && attacking <= 13) {
                race_quantity = race_quantities[attacking - 4];
                target_race = races[attacking - 4];
            }

            if (race_quantity >= 1 && race_quantity <= 6) {
                target_threat = threat_levels[race_quantity];
            } else if (race_quantity >= 6) {
                target_threat = threat_levels[6];
            }
            target.x1 = formation.x1;
            target.y1 = formation.y2 + 10;
            target.str1 = "Target: ";
            if (race_quantity != 0) {
                target.str1 += $"{target_race} ({target_threat} Threat)";
            } else {
                target.str1 += "None";
            }
            target.update();
            target.draw();
            draw_sprite(spr_faction_icons, attacking, x2 - 100, y1 + 40);
            var q = 0;
            repeat(20) {
                q += 1;
                if (target.clicked() && force_present[q] != 0) {
                    if (attacking != force_present[q] && force_present[q] > 0) {
                        attacking = force_present[q];
                    }
                }
            }
            target.locked = (force_present[q] == 0);
        }

        // Back / Purge buttons
        btn_back.x1 = x3 - 100;
        btn_back.y1 = y2 - 60;
        btn_back.update();
        btn_back.draw();
        if (btn_back.clicked()) {
            menu = 0;
            purge = 0;
            instance_destroy();
        }

        // Attack / Raid buttons
        btn_attack.x1 = btn_back.x1 + btn_attack.width + 10;
        btn_attack.y1 = btn_back.y1;
        if (purge == DropType.RaidAttack){
            if (attack = 0) then btn_attack.str1 = "RAID!";
            if (attack = 1) then btn_attack.str1 = "ATTACK!";
            btn_attack.active = (array_length(roster.selected_units) > 0 && race_quantity > 0);
        }
        else if (purge>1){
            btn_attack.str1 = "PURGE"
            btn_attack.active = (array_length(roster.selected_units) > 0)
        }        
        btn_attack.update();
        btn_attack.draw();
        if (btn_attack.clicked()) {
            if (purge == 0){
                combating = 1; // Start battle here

                if (attack = 1) then obj_controller.last_attack_form = formation_possible[formation_current];
                if (attack = 0) then obj_controller.last_raid_form = formation_possible[formation_current];

                instance_deactivate_all(true);
                instance_activate_object(obj_controller);
                instance_activate_object(obj_ini);
                instance_activate_object(obj_drop_select);

                // 135 ; temporary balancing
                if (sh_target != -50) {
                    sh_target.acted += 1;
                }

                if (attacking == 10) or (attacking == 11) {
                    remove_planet_problem(planet_number, "meeting", p_target);
                    remove_planet_problem(planet_number, "meeting_trap", p_target);
                }

                instance_create(0, 0, obj_ncombat);
                obj_ncombat.battle_object = p_target;
                obj_ncombat.battle_loc = p_target.name;
                obj_ncombat.battle_id = planet_number;
                obj_ncombat.dropping = 1 - attack;
                obj_ncombat.attacking = attack;
                obj_ncombat.enemy = attacking;
                obj_ncombat.formation_set = formation_possible[formation_current];
                obj_ncombat.defending = false;
                obj_ncombat.local_forces = roster.local_button.active

                var _planet = obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id]
                if (obj_ncombat.battle_object.space_hulk = 1) then obj_ncombat.battle_special = "space_hulk";
                if (planet_feature_bool(_planet, P_features.Warlord6) == 1) and(obj_ncombat.enemy = 6) and(obj_controller.faction_defeated[6] = 0) then obj_ncombat.leader = 1;
                if (obj_ncombat.enemy = 7) and(obj_controller.faction_defeated[7] <= 0) {
                    if (planet_feature_bool(_planet, P_features.OrkWarboss)) {
                        obj_ncombat.leader = 1;
                        obj_ncombat.Warlord = _planet[search_planet_features(_planet, P_features.OrkWarboss)[0]];
                    }
                }

                if (obj_ncombat.enemy = 9) and(obj_ncombat.battle_object.space_hulk = 0) {
                    if (has_problem_planet(planet_number, "tyranid_org", p_target)) then obj_ncombat.battle_special = "tyranid_org";
                }

                if (obj_ncombat.enemy = 11) {
                    if (planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id], P_features.World_Eaters) == 1) {
                        obj_ncombat.battle_special = "world_eaters";
                        obj_ncombat.leader = 1;
                    }
                }

                var _threats = [0,0,0,0,0,sisters,eldar,ork,tau, tyranids, traitors,csm, demons, necrons];
                if (obj_ncombat.enemy >=5 && obj_ncombat.enemy<=13){
                    obj_ncombat.threat = _threats[obj_ncombat.enemy];
                }

                if (obj_ncombat.enemy = 8) {
                    var eth;
                    eth = 0;
                    eth = scr_quest(4, "ethereal_capture", 8, 0);
                    if (eth > 0) and(obj_ncombat.battle_object.p_owner[obj_ncombat.battle_id] = 8) {
                        var rolli;
                        rolli = irandom_range(1, 100)
                        if (obj_ncombat.threat = 6) and(rolli <= 80) then obj_ncombat.ethereal = 1;
                        if (obj_ncombat.threat = 5) and(rolli <= 65) then obj_ncombat.ethereal = 1;
                        if (obj_ncombat.threat = 4) and(rolli <= 50) then obj_ncombat.ethereal = 1;
                        if (obj_ncombat.threat = 3) and(rolli <= 35) then obj_ncombat.ethereal = 1;
                    }
                    // show_message("Ethereal Quest?: "+string(eth)+"#Ethereal?: "+string(obj_ncombat.ethereal));
                }

                // if (obj_ncombat.threat>1) and (obj_ncombat.enemy!=13) then obj_ncombat.threat-=1;
                if (obj_ncombat.threat > 1) and(obj_ncombat.battle_special != "world_eaters") and(attack = 0) then obj_ncombat.threat -= 1;
                if (obj_ncombat.threat < 1) then obj_ncombat.threat = 1;
                if (obj_ncombat.enemy = 10) and(obj_ncombat.battle_object.p_type[obj_ncombat.battle_id] = "Daemon") then obj_ncombat.threat = 7;

                var _battle_place = obj_ncombat.battle_object;
                var _battle_sub_loc = obj_ncombat.battle_id;
                var _chaos_lord_jump_possible = (attacking = 0|| attacking = 10|| attacking = 11);
                var _no_know_chaos = (_battle_place.p_traitors[_battle_sub_loc] == 0 && _battle_place.p_chaos[_battle_sub_loc] == 0);

                var _chaos_warlord_present = planet_feature_bool(_battle_place.p_feature[obj_ncombat.battle_id], P_features.Warlord10);

                var _chaos_popup_turn_reached = obj_controller.turn >= obj_controller.chaos_turn;

                var _chaos_unknown = (obj_controller.known[eFACTION.Chaos] == 0) and (obj_controller.faction_gender[10] = 1);

                if (_chaos_lord_jump_possible && _no_know_chaos) {
                    if (_chaos_popup_turn_reached && _chaos_warlord_present){
                        if (_chaos_unknown) {
                            var pop;
                            pop = instance_create(0, 0, obj_popup);
                            pop.image = "chaos_symbol";
                            pop.title = "Concealed Heresy";
                            pop.text = $"Your astartes set out and begin to cleanse {planet_numeral_name(_battle_sub_loc,_battle_place)} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";
                            cancel_combat();
                            combating = 0;
                            instance_activate_all();
                            exit;
                        }
                        if (obj_controller.known[eFACTION.Chaos] >= 2 && obj_controller.faction_gender[10] = 1){
                            with(obj_drop_select) {
                                obj_ncombat.enemy = 11;
                                obj_ncombat.threat = 0;
                                cancel_combat();
                                combating = 0;
                                instance_destroy();
                                instance_activate_all();
                                exit;
                            }
                        }
                    }
                }

                scr_battle_allies();
                setup_battle_formations();
                roster.add_to_battle();
            } else if (purge >1){
                draw_set_alpha(0.2);
                draw_rectangle(954, 556, 1043, 579, 0);
                draw_set_alpha(1);
                var _purge_score=0;
                if (purge == 2) {
                    _purge_score = roster.purge_bombard_score();
                }                  

                if (purge >= 3) {
                    _purge_score = array_length(roster.selected_units);
                }

                scr_purge_world(p_target, planet_number, purge , _purge_score);              
            }
        }
    }


    // Purge shit happens bellow;
    // God, save us;
    if (menu == 0) {
        if (purge == 1) {
            
            
        } else if (purge >= 2) {
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_30b);

            // 2 is bombardment

            var x2 = 535;
            var y2 = 200;

            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            var _purge_strings = ["Bombard Purging {0}", "Fire Cleansing {0}","Selective Purging {0}", "Assassinate Governor ({0})"];
            var _planet_string = planet_numeral_name(planet_number, p_target);
            draw_text_transformed(x2 + 14, y2 + 12, string(_purge_strings[purge-2],_planet_string), 0.6, 0.6, 0);

            // Disposition here
            var succession = 0,
            pp = planet_number

            var succession = has_problem_planet(pp, "succession", p_target);

            if ((p_target.dispo[pp] >= 0) and(p_target.p_owner[pp] <= 5) and(p_target.p_population[pp] > 0)) and (!succession) {
                var wack = 0;
                draw_set_color(c_blue);
                draw_rectangle(x2 + 12, y2 + 53, x2 + 12 + max(0, (min(100, p_target.dispo[pp]) * 4.37)), y2 + 71, 0);
            }
            draw_set_color(c_gray);
            draw_rectangle(x2 + 12, y2 + 53, x2 + 449, y2 + 71, 1);
            draw_set_color(c_white);

            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_center);
            if (!succession) {
                if (p_target.dispo[pp] >= 0) and(p_target.p_first[pp] <= 5) and(p_target.p_owner[pp] <= 5) and(p_target.p_population[pp] > 0) then draw_text(x2 + 231, y2 + 54, string_hash_to_newline("Disposition: " + string(min(100, p_target.dispo[pp])) + "/100"));
                if (p_target.dispo[pp] > -30) and(p_target.dispo[pp] < 0) and(p_target.p_owner[pp] <= 5) and(p_target.p_population[pp] > 0) then draw_text(x2 + 231, y2 + 54, string_hash_to_newline("Disposition: ???/100"));
                if ((p_target.dispo[pp] >= 0) and(p_target.p_first[pp] <= 5) and(p_target.p_owner[pp] > 5)) or(p_target.p_population[pp] <= 0) then draw_text(x2 + 231, y2 + 54, string_hash_to_newline("-------------"));
                if (p_target.dispo[pp] <= -3000) then draw_text(x2 + 231, y2 + 54, "Chapter Rule");
            }
            if (succession = 1) then draw_text(x2 + 231, y2 + 54, "War of Succession");

            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);

            // Planet icon here
            draw_rectangle(x2 + 459, y2 + 14, x2 + 516, y2 + 71, 0);

            draw_set_font(fnt_40k_14);
            draw_set_color(c_gray);
            draw_set_alpha(1);


            var smin, smax;
            var w;
            w = -1;
            smin = 0;
            smax = 0;


            //draw_text(x2 + 14, y2 + 352, string_hash_to_newline("Selection: " + string(smin) + "/" + string(smax)));
        }
    }
}
}

function collect_local_units(){
		//
	// I think this script is used to count local forces. l_ meaning local.
	//
	ship_use[500]=0;
	ship_max[500]=l_size;
	purge_d=ship_max[500];

	if (purge==1)
	{




	if (sh_target!=-50){
	    
	    max_ships=sh_target.capital_number+sh_target.frigate_number+sh_target.escort_number;
	    
	    
	    if (sh_target.acted>=1) then instance_destroy();
	    
	    var tump;tump=0;
	    
	    var i, q, b;i=-1;q=-1;b=-1;
	    repeat(sh_target.capital_number){
	        b+=1;
	        if (sh_target.capital[b]!=""){
	            i+=1;
	            ship[i]=sh_target.capital[i];
	            
	            ship_use[i]=0;
	            tump=sh_target.capital_num[i];
	            ship_max[i]=obj_ini.ship_carrying[tump];
	            ship_ide[i]=tump;
	            
	            ship_size[i]=3;
	            
	            purge_a+=3;
	            purge_b+=ship_max[i];purge_c+=ship_max[i];purge_d+=ship_max[i];
	        }
	    }
	    q=-1;
	    repeat(sh_target.frigate_number){
	        q+=1;
	        if (sh_target.frigate[q]!=""){
	            i+=1;
	            ship[i]=sh_target.frigate[q];
	            
	            ship_use[i]=0;
	            tump=sh_target.frigate_num[q];
	            ship_max[i]=obj_ini.ship_carrying[tump];
	            ship_ide[i]=tump;
	            
	            ship_size[i]=2;
	            
	            purge_a+=1;
	            purge_b+=ship_max[i];
                purge_c+=ship_max[i];
                purge_d+=ship_max[i];
	        }
	    }
	    q=-1;
	    repeat(sh_target.escort_number){
	        q+=1;
	        if (sh_target.escort[q]!="") and (obj_ini.ship_carrying[sh_target.escort_num[q]]>0){
	            i+=1;
	            ship[i]=sh_target.escort[q];
	            
	            ship_use[i]=0;
	            tump=sh_target.escort_num[q];
	            ship_max[i]=obj_ini.ship_carrying[tump];
	            ship_ide[i]=tump;
	            
	            ship_size[i]=1;
	            
	            purge_b+=ship_max[i];
                purge_c+=ship_max[i];
                purge_d+=ship_max[i];
	        }
	    }

	}

	if (p_target.p_player[planet_number]>0) then max_ships+=1;
	var pp=planet_number;
	purge_d = p_target.p_type[pp]!="Dead";

	if (has_problem_planet(pp,"succession",p_target)) then purge_d=0

	if (p_target.dispo[pp]<-2000) then purge_d=0;

	if (planet_feature_bool(p_target.p_feature[pp],P_features.Monastery)==1) and (obj_controller.homeworld_rule!=1) then purge_d=0;

	if (p_target.p_type[pp]="Dead") then purge_d=0;


	}
}


