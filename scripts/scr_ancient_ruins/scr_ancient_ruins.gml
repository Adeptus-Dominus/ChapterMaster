// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ancient_ruins_setup(){
	var ruin_data = choose(["tiny", 5], ["small", 15], ["medium", 55], ["large",110], ["sprawling", 0]);
	ruins_size =  ruin_data[0];
	man_size_limit = ruin_data[1];
	recoverable_gene_seed = 0;
	recoverables=[];
	failed_exploration = 0;
	unrecovered_items = false;
	f_type =  P_features.Ancient_Ruins;
	exploration_complete= false;
	planet_display = $"{ruins_size} Unexplored Ancient Ruins";
	completion_level = 0;
	player_hidden = 1;
}

function scr_ruins_suprise_attack_player(){
	try {
		instance_deactivate_all(true);
		instance_activate_object(obj_controller);
		instance_activate_object(obj_ini);
		instance_activate_object(obj_star_select);
		instance_activate_object(obj_star);
		instance_activate_object(obj_ground_mission);
		var _star = star_by_name(obj_ground_mission.loc);
		var _planet = obj_ground_mission.num;
		var _units = obj_ground_mission.display_unit;
		
		instance_create(0,0,obj_ncombat);
		
		obj_ncombat.man_size_limit = man_size_limit;
		
		//that_one=instance_nearest(0,0,obj_star);
	// instance_activate_object(obj_star);
		_roster = new Roster();
		with (_roster){
			roster_location = obj_ground_mission.loc;
			roster_planet = _planet;
	        selected_units = _units;
			if (array_length(selected_units)){	
	            setup_battle_formations();
	            add_to_battle();
	        } else {
	        	instance_destroy(obj_ncombat);
	        	instance_destroy(obj_pnunit);
	        	instance_destroy(obj_enunit);
	        	instance_activate_all();
	        	scr_ruins_reward(_star,_planet,self);
	        }				
		}


		obj_ncombat.battle_object=_star;
		obj_ncombat.battle_loc=_star.name;
		instance_deactivate_object(obj_star);    
		obj_ncombat.battle_id =_planet;
		obj_ncombat.battle_special="ruins";
		if (obj_ground_mission.ruins_race=6) then obj_ncombat.battle_special="ruins_eldar";
		obj_ncombat.dropping=0;
		obj_ncombat.attacking=0;
		obj_ncombat.enemy=obj_ground_mission.ruins_battle;
		obj_ncombat.threat=obj_ground_mission.battle_threat;
		obj_ncombat.formation_set=1;
		instance_destroy(obj_popup);
		instance_destroy(obj_star_select);	
	} catch (_exception) {
		handle_exception(_exception);
		instance_activate_all();
		instance_destroy(obj_popup);
		instance_destroy(obj_star_select);
		instance_destroy(obj_ground_mission);	
		instance_destroy(obj_ncombat);		
	}
}
//spawn point for starship
function scr_ruins_find_starship (){
	f_type = P_features.Starship;
	planet_display = "Ancient Starship";
	funds_spent = 0;
	player_hidden = 0;
	engineer_score = 0;
}

//allows ruins to be entered to retrive fallen marine gear
function scr_ruins_player_forces_defeated(){
	planet_display = "Failed Ruins Expidition"
	completion_level = 1;
	failed_exploration = 1;
	player_hidden = 0;
	exploration_complete= false;
	failiure_turn = obj_controller.turn;
}

//revcover equipment of fallen marines from ruins
function scr_ruins_recover_from_dead(){
	var pop=instance_create(0,0,obj_popup);var route = random(5);
	pop.image="ancient_ruins";
	pop.title="Ancient Ruins: Recovery";
	if (route < 4){
		var weapon_text = ""
	
		//calculate equipment degredation
		var equipment_deg = floor((obj_controller.turn - failiure_turn)/7)
		var some_recoverable = false;
		if (array_length(recoverables)>0){
				for (var item =0;item<array_length(recoverables);item++){
					var i_set = recoverables[item]
					i_set[1] -= equipment_deg;
					if (i_set[1]> 0){
						some_recoverable = true;
						scr_add_item(i_set[0],i_set[1])
						weapon_text += $", {i_set[0]} x {i_set[1]}"
					}
				}
			if (some_recoverable == true){
				pop.text=$"Your strike team locates the site where the previous expedition made their last stand. They airlift whatever equipment and vehicles remain, disposing of anything beyond saving;.{ weapon_text}is repaired and restored to the armamentarium";
			}else{
				pop.text=$"our strike team locates the site where the previous expedition made their last stand. They cannot find any intact equipment, and are forced to burn the derelicts to prevent capture; no equipment is added to the armamentarium"
			}
		}
	
		//calculate geneseed degredation
		if (obj_controller.turn - failiure_turn > 2){
			recoverable_gene_seed -= obj_controller.turn - failiure_turn
		}
		if (recoverable_gene_seed>0){
			pop.text += $" The strike team returns with remains, apothecaries report the gene-seed was able to be saved;{recoverable_gene_seed} gene-seed is harvested from the chapter’s fallen. At least their genetic legacy will continue, we will recover from this."
			obj_controller.gene_seed+=recoverable_gene_seed;
		} else{
			pop.text += $"The strike team returns with remains, but apothecaries report the gene-seed is too contaminated to use; no gene-seed is harvested from the chapter’s fallen. Their legacy lives on through their armaments, we will hold onto their memory."
		}
	}else{
		pop.text = "Your strike team locates the site where the previous expedition made their last stand. They find nothing. Your equipment is gone and bodies nowhere to be found, the entire expedition appears to have vanished without a trace; they return empty handed. Something insidious happened. You must find whoever defiled your brothers, and eliminate them, forever.”"
	}
	unrecovered_items=false;
	recoverable_gene_seed = 0;
	var _recoverables =[];
	recoverables =_recoverables
	planet_display = "Unexplored Ancient Ruins";	
}

//mark ruins as fully explored
function scr_ruins_explored(){
	planet_display = "Ancient Ruins";
	exploration_complete = true;
}

//determine what race the ruins once belonged to effect enemies that can be found
function scr_ruins_determine_race(){
    var dice=floor(random(100))+1;
    if (dice<=9) then ruins_race=1;
    if (dice>9) and (dice<=74) then ruins_race=2;
    if (dice>74) and (dice<=83) then ruins_race=5;
    if (dice>83) and (dice<=91) then ruins_race=6;
    if (dice>91) then ruins_race=10;
};


function scr_explore_ruins() {
	try {
		obj_controller.current_planet_feature = self;
		obj_controller.menu = 0;

		var pip = instance_create(0, 0, obj_popup);
		pip.title = "Ancient Ruins";

		var nu = planet_numeral_name(planet, star);

		var arti = instance_create(star.x, star.y, obj_ground_mission);
		arti.explore_feature = self;
		arti.num = planet;
		arti.loc = star.name;
		arti.battle_loc = star.name;
		arti.manag = obj_controller.managing;
		arti.obj = star;
		with (arti) {
			setup_planet_mission_group();
		}

		arti.ship_id = obj_controller.ma_lid[1];
		obj_controller.current_planet_feature.battle = arti;

		if (failed_exploration) {
			pip.text = $"The accursed ruins on {nu} where your brothers fell still holds many secrets including the remains of your brothers honour demands you avenge them.";
		} else {
			pip.text = $"Located upon {nu} is a {ruins_size} expanse of ancient ruins, dating back to times long since forgotten.  Locals are superstitious about the place- as a result the ruins are hardly explored.  What they might contain, and any potential threats, are unknown.";
			switch (ruins_size) {
				case "tiny":
					pip.text += "It's tiny nature means no more than five marines can operate in cohesion without being seperated";
					break;
				case "small":
					pip.text += "As a result of it's narrow corridors and tight spaces a squad of any more than 15 would struggle to operate effectivly";
					break;
				case "medium":
					pip.text += "Half a standard company (55) could easily operate effectivly in the many wide spaces and caverns";
					break;
				case "large":
					pip.text += "A whole company (110) would not be confined in the huge spaces that such a ruin contain";
					break;
				case "sprawling":
					pip.text += "The ruins is of an unprecidented size whole legions of old would not feel uncomfortable in such a space";
					break;
			}
			pip.text += ". What is thy will?";
		}

		pip.option1 = "Explore the ruins.";
		pip.option2 = "Do nothing.";
		pip.option3 = "Return your marines to the ship.";
		pip.image = "ancient_ruins";
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function scr_check_for_ruins_exploration(select_planet, star){
	var _planet_features = star.p_feature[select_planet]
	var _ruins_list =  search_planet_features( _planet_features, P_features.Ancient_Ruins)
	var _explore_ruins=0;
    if (array_length(_ruins_list) > 0){
		for (var _ruin = 0; _ruin < array_length(_ruins_list); _ruin++){
			var _specific_ruins = _ruins_list[_ruin];
			var _cur_ruins = _planet_features[_specific_ruins];
			if ( _cur_ruins.exploration_complete == false){
				 _explore_ruins = _planet_features[_specific_ruins];
				break;
			}else{
				_explore_ruins=0;
			}
		}
		if (_explore_ruins!=0){
			_explore_ruins.star = star;
			_explore_ruins.planet = select_planet;									
			_explore_ruins.explore();
		}
    }

}


// show_message("so far so good, defeat:"+string(defeat));

function scr_ruins_combat_end() {
    var _star = 0;
    ruins_battle = choose(6,7,9,10,11,12);

    _star = star_by_name(obj_ground_mission.battle_loc);
    var planet = obj_ground_mission.num;
    var _battle_threat = obj_ground_mission.battle_threat;
    if (obj_ground_mission.defeat == 0){
        var dice=roll_dice_chapter(1, 100, "low");

        if (dice < (_battle_threat*10)){
            if (ruins_race == eFACTION.Ecclesiarchy){
                obj_controller.disposition[5]+=2;

                if (scr_has_adv("Reverent Guardians")) {
                    obj_controller.disposition[5]+=1;
                }

            }



            if (ruins_race < 5) {
                var di = choose(eFACTION.Imperium, eFACTION.Inquisition);
                switch (di) {
                case eFACTION.Imperium:
                    obj_controller.disposition[eFACTION.Imperium]+=2;
                    break;
                case eFACTION.Inquisition:
                    obj_controller.disposition[eFACTION.Inquisition]+=1;
                    break;
                }
            } else if (ruins_race == eFACTION.Eldar) {
                switch (ruins_battle) {
                case 6:
                    obj_controller.disposition[eFACTION.Eldar]-=5;
                    break;
                case 11:
                    obj_controller.disposition[eFACTION.Eldar]+=2;
                    break;
                case 12:
                    obj_controller.disposition[eFACTION.Eldar]+=4;
                    break;
                }
            }
        }

        scr_ruins_reward(_star,planet,self);
    } else if (obj_ground_mission.defeat == 1) {
        var dice=roll_dice_chapter(1, 100, "low");

        if (dice < (_battle_threat*10)){
            if (ruins_race == eFACTION.Ecclesiarchy) {
                obj_controller.disposition[5]-=2;
            } else if (ruins_race < 5){
                var di=choose(eFACTION.Imperium, eFACTION.Inquisition);
                switch (di) {
                case eFACTION.Imperium:
                    obj_controller.disposition[eFACTION.Imperium]-=2;
                    break;
                case eFACTION.Inquisition:
                    obj_controller.disposition[eFACTION.Inquisition]-=1;
                    break;
                }
            }
        }
        var pop=instance_create(0,0,obj_popup);
        switch (ruins_battle) {
        case 10:
            _star.p_traitors[planet]=_battle_threat+1;
            _star.p_heresy[planet]+=10;
            break;
        case 11:
            _star.p_traitors[planet]=_battle_threat+1;
            _star.p_heresy[planet]+=25;
            break;
        case 12:
            _star.p_demons[planet]=_battle_threat+1;
            _star.p_heresy[planet]+=40;
            break;
        }

        pop.title="Ancient Ruins";
        pop.text="Your forces within the ancient ruins have been surrounded and destroyed, down to the last man. An immediate expedition must be launched to recover and honour them as well as secure any geneseed or equipment not destroyed";
        switch (ruins_battle) {
        case 10:
            pop.text+="Now that they have been discovered, scans indicate the heretics and mutants are leaving the structures en masse.  ";
            break;
        case 11:
            pop.text+="Now that they have been discovered, scans indicate the chaos space marines are leaving the structures, intent on doing damage.  ";
            break;
        case 12:
            pop.text+="Scans indicate the foul daemons are leaving the structures en masse, intent on doing damage.  ";
            break;
        case 6:
            pop.text+="Now that they have been discovered, the Eldar seem to have vanished without a trace.  Scans reveal nothing.";
        }
        forces_defeated();
        var equip_lost = obj_ground_mission.post_equipment_lost;
        var equip_count_lost = obj_ground_mission.post_equipments_lost;
        if (equip_lost[1]!=""){
            for (var i = 0; i < array_length(equip_lost); i++) { // glorified repeat loop, fix later
                if (equip_lost[i]!="") and (equip_count_lost[i]>0) {
                    var _new_equip = floor(equip_count_lost[i]/2);
                    if (_new_equip == 0) {
                        _new_equip++;
                    }
                    array_push(recoverables, [equip_lost[i],_new_equip])
                }
            }
            recoverable_gene_seed = obj_ground_mission.recoverable_gene_seed;
            if (recoverable_gene_seed > 1) {
                recoverable_gene_seed = floor(recoverable_gene_seed/2);
            }
            if (array_length(recoverables) > 0) {
                unrecovered_items=true;
            }
        }
    }
}
