function mechanicus_missions_end_turn(planet){	
	var raider_planet_slot = has_problem_planet_with_time(planet,"mech_raider");
    if (raider_planet_slot>-1){
    	var _techs = collect_role_group(SPECIALISTS_TECHS, [name, planet, -1]);
        var _lr_count = scr_vehicle_count("Land Raider",[name, planet, -1]);
        if (array_length(_techs)>=6) and (_lr_count>=1){
            var _prob_data = p_problem_other_data[planet][raider_planet_slot];
            var percent_complete = increment_mission_completion(_prob_data);                
        	scr_alert("",$"mission",$"Mechanicus Mission on {planet_numeral_name(planet)} is {floor(percent_complete)}% complete.",0,0);
        	if (percent_complete>=100){
        		remove_planet_problem(planet,"mech_raider")
        		scr_mission_reward("mech_raider",id,planet);
        	}
        }     	
    }
    var bionics_planet_slot = has_problem_planet_with_time(planet,"mech_bionics");
    if (bionics_planet_slot>-1){
        var check1=scr_bionics_count("star",name,planet,"number");
        if (check1>=10){
            var _prob_data = p_problem_other_data[planet][bionics_planet_slot];
        	var percent_complete = increment_mission_completion(_prob_data);
        	scr_alert("",$"mission",$"Mechanicus Mission on {planet_numeral_name(planet)} is {floor(percent_complete)}% complete.",0,0);
        	if (percent_complete>=100){
        		remove_planet_problem(planet,"mech_bionics");
        		scr_mission_reward("mech_bionics",id,planet);
        	}
        }     	
    }
    var tomb2_planet_slot = has_problem_planet_with_time(planet,"mech_tomb2");
    if (tomb2_planet_slot>-1){
    	var _mission_data = p_problem_other_data[planet][tomb2_planet_slot];
    	_mission_data.turns++;
    	var battli=0;
    	var _roll1 = roll_dice_chapter(1, 100+_mission_data.turns, "low");
    	var completion = _mission_data.completion>0;

    	if (roll1>98){
	        if (roll1>=90) and (roll1<98) then battli=1;// oops
	        if (roll1>=98) then battli=2;// very oops, much necron, wow
	    
	        if (battli>0) and (p_player[planet]>0){// Quene the battle
	            obj_turn_end.battles+=1;
	            obj_turn_end.battle[obj_turn_end.battles]=1;
	            obj_turn_end.battle_world[obj_turn_end.battles]=planet;
	            obj_turn_end.battle_opponent[obj_turn_end.battles]=13;
	            obj_turn_end.battle_location[obj_turn_end.battles]=name;
	            obj_turn_end.battle_object[obj_turn_end.battles]=id;
	            if (battli=1) then obj_turn_end.battle_special[obj_turn_end.battles]="study2a";
	            if (battli=2) then obj_turn_end.battle_special[obj_turn_end.battles]="study2b";
	        
	            if (obj_turn_end.battle_opponent[obj_turn_end.battles]==11){
	                if (planet_feature_bool(p_feature[planet],P_features.ChaosWarband)==1){
	                    obj_turn_end.battle_special[obj_turn_end.battles]="ChaosWarband";
	                }
	            }
	        }
	        if (battli>0) and (p_player[planet]<=0){// XDDDDD
	            scr_popup("Mechanicus Mission Failed","The Mechanicus Research team on planet "+string(name)+" "+scr_roman(planet)+" have been killed by Necrons in the absence of your astartes.  The Mechanicus are absolutely livid, doubly so because of the promised security they did not recieve.","","");
	            obj_controller.turns_ignored[3]+=choose(8,10,12,14,16,18,20,22,24);
	            obj_controller.disposition[3]-=25;
	            remove_planet_problem(planet,"mech_tomb2");
	        }
	    }
        else {// Done        
            if (roll1>20){
				scr_alert("","mission","Adeptus Mechanicus research within the Necron Tomb of "+string(name)+" "+scr_roman(planet)+" continues.",0,0);
            } 
        
            else if (roll1<=20){// Complete
                var text ,reward=choose(1,1,2);
                if (scr_has_adv("Tech-Brothers")) then reward=choose(1,2);
            
                if (reward==1){
                	obj_controller.requisition+=400;
                    text="The Mechanicus Research team on planet "+string(name)+" "+scr_roman(planet)+" have completed their work without any major setbacks.  Pleased with your astartes' work, they have granted you 400 Requisition to be used as you see fit.";
                    scr_event_log("","Mechanicus Mission Completed: The Mechanicus research team on "+string(name)+" "+scr_roman(planet)+" have completed their work.");
                }
                else if (reward==2){
                	
                	var last_artifact = scr_add_artifact("random", "", 0);
                    text="The Mechanicus Research team on planet "+string(name)+" "+scr_roman(planet)+" have completed their work without any major setbacks.  Pleased with your astartes' work, they have granted your Chapter an artifact, to be used as you see fit.";
                    scr_event_log("","Mechanicus Mission Completed: The Mechanicus research team on "+string(name)+" "+scr_roman(planet)+" have completed their work.");
                    scr_event_log("","Artifact gifted from Mechanicus.");
                }
            
                scr_popup("Mechanicus Mission Completed",text,"mechanicus","");
            
                obj_controller.disposition[3]+=1;
                remove_planet_problem(planet,"mech_tomb2");
            }
        }        	
    }
    var tomb1_planet_slot = has_problem_planet_with_time(planet,"mech_tomb1");
    if (tomb1_planet_slot>-1){
    	var _marines  = collect_role_group("all", [name, planet, -1]);
    	if (array_length(_marines)>=20){
    		remove_planet_problem(planet,"mech_tomb1");
    		add_new_problem(planet, "mech_tomb2", 999,star="none", other_data={turns:0})
            scr_popup("Mechanicus Research","The Mechanicus Research team on planet "+string(name)+" "+scr_roman(planet)+" has taken note of your Astartes and are now prepared to begin their research.  Your marines are to stay on the planet until further notice.","necron_cave","");
    	} else {

    	}
    }
    if (has_problem_planet_and_time(planet,"mech_tomb1", 0)>-1){
        var alert_text="Mechanicus Mission Failed: Necron Tomb Study at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text, name);
        alter_disposition(eFACTION.Mechanicus,-15);
        remove_planet_problem(planet,"mech_tomb1");       	
    }

    
    var mars_mech_mission = has_problem_planet_and_time(planet,"mech_mars", 0);
    if (mars_mech_mission>-1){
    	mechanicus_mars_mission_target_time_elapsed(planet);         	
    }

    if (has_problem_planet_and_time(planet,"mech_raider", 0)>-1){
        var alert_text="Mechanicus Mission Failed: Land Raider testing at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text);
        alter_disposition(eFACTION.Mechanicus,-6);
        remove_planet_problem(planet,"mech_raider");      	
    }
    if (has_problem_planet_and_time(planet,"mech_bionics", 0)>-1){
        var alert_text="Mechanicus Mission Failed: bionics testing at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text);
        alter_disposition(eFACTION.Mechanicus,-6);
        remove_planet_problem(planet,"mech_bionics");       	
    }
}


function spawn_mechanicus_mission(chosen_mission = "random"){
	log_message("RE: Mechanicus Mission");
	var mechanicus_missions = []
	var _evented
	
	var _forge_stars = scr_get_stars(false, [eFACTION.Mechanicus],["Forge"]);
	
	if(array_length(_forge_stars)){
		array_push(mechanicus_missions, "mech_bionics");
		if (scr_role_count(obj_ini.role[100][16],"") >= 6) {
			array_push(mechanicus_missions, "mech_raider");
		}
	}
	
		
	with(obj_star){
		if(scr_star_has_planet_with_feature(id,P_features.Necron_Tomb)) and (awake_necron_star(id)!= 0){
			var planet = scr_get_planet_with_feature(id, P_features.Necron_Tomb);
			if(scr_is_planet_owned_by_allies(self, planet)){
				array_push(mechanicus_missions, "mech_tomb");
				break;
			}
		}
	}
	
    if (obj_controller.disposition[eFACTION.Mechanicus]>=70) {
		array_push(mechanicus_missions, "mech_mars");
	}

	var mission_count = array_length(mechanicus_missions);
	if (mission_count == 0 && chosen_mission== "random"){
		log_error("RE: Mechanicus Mission, couldn't pick mission");
		exit;
	}
	
	if (chosen_mission == "random"){
		chosen_mission = array_random_element(mechanicus_missions);
	}
	
    if (chosen_mission == "mech_bionics" || chosen_mission == "mech_raider" || chosen_mission == "mech_mars"){

		if(array_length(_forge_stars) == 0){
			log_error("RE: Mechanicus Mission, couldn't find a mechanicus forge world");
			exit;
		}

		var star = array_random_element(_forge_stars);

		var _mission_data = {
			star : star.id,
		}
		var _name = star.name;
        if (chosen_mission == "mech_raider"){
            var text=$"The Adeptus Mechanicus are trusting you with a special mission.  They wish for you to bring a Land Raider and six {obj_ini.role[100][16]} to a Forge World in {_name} for testing and training, for a duration of 24 months. You have four years to complete this.  Can your chapter handle this mission?";
            _mission_data.options =[
				{
					str1:"Accept",
					choice_func : accept_mechanicus_land_raider_mission,
				},
				{
					str1:"Refuse",
					choice_func : popup_default_close,
				},
			]
			_evented = true;
        }
        else if (chosen_mission == "mech_bionics") {
            var text=$"The Adeptus Mechanicus are trusting you with a special mission.  They desire a squad of Astartes with bionics to stay upon a Forge World in {_name} for testing, for a duration of 24 months.  You have four years to complete this.  Can your chapter handle this mission?";
            _mission_data.options =[
				{
					str1:"Accept",
					choice_func :accept_mechanicus_bionics_mission,
				},
				{
					str1:"Refuse",
					choice_func :popup_default_close
				},
			]
			_evented = true;
        }
        else {
            var text=$"The local Adeptus Mechanicus are preparing to embark on a voyage to Mars, to delve into the catacombs in search of lost technology.  Due to your close relations they have made the offer to take some of your {obj_ini.role[100][16]}s with them for both their unique abilities to function as both scientific helpers and as helpers (high Weapon Skill and Technology is reccomended).  Can your chapter handle this mission?";
            _mission_data.options =[
				{
					str1:"Accept",
					choice_func : accept_mechanicus_mars_mission
				},
				{
					str1:"Refuse",
					choice_func : popup_default_close,
				},
			]
			_evented = true;
        }
        if (_evented){
        	scr_popup("Mechanicus Mission",text,"mechanicus",_mission_data);
        }
        //global.logger.debug(_mission_data);
    }

    else if (chosen_mission=="mech_tomb") {
		log_message("RE: Necron Tomb Study");
		stars = scr_get_stars();
		var valid_stars = array_filter_ext(stars, 
		function(star,index) {
			if(scr_star_has_planet_with_feature(star,P_features.Necron_Tomb)) and (awake_necron_star(star)!= 0){
				var planet = scr_get_planet_with_feature(star, P_features.Necron_Tomb);
				if(scr_is_planet_owned_by_allies(star, planet)) {
					return true;
				}
			}
			return false;
		});
		
		if (array_length(valid_stars) == 0) {
			log_error("RE: Necron Tomb Study, coudln't find a tomb world under imperium control");
			exit;
		}
		var star = array_random_element(valid_stars);
		_mission_data = {
			star : star.id,
			pathway_id : chosen_mission,
		}
        _mission_data.options =[
			{
				str1:"Accept",
				choice_func : accept_mechanicus_tomb_mission,
			},
			{
				str1:"Refuse",
				choice_func : popup_default_close,
			},
		]
		var text=$"Mechanicus Techpriests have established a research site on a Necron Tomb World in the {star.name} system.  They are requesting some of your forces to provide security for the research team until the tests may be completed.  Further information is on a need-to-know basis.  Can your chapter handle this mission?";
            scr_popup("Mechanicus Mission",text,"mechanicus",_mission_data);
			_evented = true;
    }
    return _evented;	
}

/// @mixin obj_popup
function accept_mechanicus_tomb_mission(){

	var _planet = false;
	var _star = pop_data.star;
	for (var i = 1; i<_star.planets; i++) {
		if (awake_tomb_world(_star.p_feature[i])!=0){
			_planet = i;
			break;
		}
	}
	if (_planet > 0) {
		_planet = new PlanetData(_planet, _star);
		_planet.add_problem("mech_tomb1", 17)
		var _name = _planet.name();
		text = $"The Adeptus Mechanicus await your forces at {_name}.  They are expecting at least two squads of Astartes and have placed the testing on hold until their arrival.  {global.chapter_name} have 16 months to arrive.";
		scr_event_log("", "Mechanicus Mission Accepted: At least two squads of marines are expected at {_name} within 16 months.", _star.name);
		with (_star) {
			new_star_event_marker("green");
		}
		title = "Mechanicus Mission Accepted";
		reset_popup_options();
		cooldown = 15;
		exit;

	}

}
/// @mixin obj_popup
function accept_mechanicus_land_raider_mission(){
	var _star = pop_data.star
	var _forge_planet = scr_get_planet_with_type(_star, "Forge");
	if (_forge_planet>0){
		var _planet = new PlanetData(_forge_planet, _star);

		var _mission_loc = _planet.name();
		var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
		var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);

		_planet.add_problem("mech_raider", _mission_time, {
			completion: 0, 
			required_months :24
		});
		text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting six {obj_ini.role[100][16]}s and a Land Raider.";
		scr_event_log("", $"Mechanicus Mission Accepted: Six of your {obj_ini.role[100][16]}s and a Land Raider are to be stationed at {_mission_loc} for {_mission_time} months.", _star.name);
		with (_star) {
			new_star_event_marker("green");
		}
		title = "Mechanicus Mission Accepted";
	} else {
		text = $"Error valid forge planet not found please open a bug report if seen";
	}
	reset_popup_options();
}
/// @mixin obj_popup
function accept_mechanicus_bionics_mission(){
	var _star = pop_data.star
	var _forge_planet = scr_get_planet_with_type(_star, "Forge");
	if (_forge_planet>0){
		var _planet = new PlanetData(_forge_planet, _star);

		var _mission_loc = _planet.name();
		var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
		var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);
		
		_planet.add_problem("mech_bionics", _mission_time, {
			completion: 0, 
			required_months :24
		})
		text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting ten Astartes with bionics. (Beneficial traits: Weakness of Flesh )";
		scr_event_log("", $"Mechanicus Mission Accepted: Ten Astartes with bionics are to be stationed at {_mission_loc} for 24 months for testing purposes.", _star.name);
		with (_star) {
			new_star_event_marker("green");
		}
		title = "Mechanicus Mission Accepted";
	} else {
		text = $"Error valid forge planet not found please open a bug report if seen";
	}
	reset_popup_options();

}

/// @mixin obj_popup
function accept_mechanicus_mars_mission(){
	var _star = pop_data.star
	var _forge_planet = scr_get_planet_with_type(_star, "Forge");
	if (_forge_planet>0){
		var _planet = new PlanetData(_forge_planet, _star);

		var _mission_loc = _planet.name();
		var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
		var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);
		
		_planet.add_problem("mech_bionics", _mission_time, {
			completion: 0, 
			required_months :24
		})
		_planet.add_problem("mech_mars", _mission_time )
		text = $"The Adeptus Mechanicus await your {obj_ini.role[100][16]}s at {_mission_loc}.  They are willing to hold on the voyage for up to {_mission_time} months.";
		scr_event_log("", $"Mechanicus Mission Accepted: {obj_ini.role[100][16]}s are expected at {_mission_loc} within 30 months, for the voyage to Mars.", _star.name);
		with (_star) {
			new_star_event_marker("green");
		}
		title = "Mechanicus Mission Accepted";
		reset_popup_options();
	} else {
		text = $"Error valid forge planet not found please open a bug report if seen";
	}
	reset_popup_options();		
}



/// @mixin obj_star
function mechanicus_mars_mission_target_time_elapsed(planet){
 	var techs_taken,com,ide,ship_planet, _unit;
    techs_taken=0;com=-1;ide=0;ship_planet="";        	
    for (com =0; com<=10;com++){
        for (ide = 0; ide<array_length(obj_ini.TTRPG[com]);ide++){
            _unit = fetch_unit([com,ide]);
            if (_unit.name() == ""){
            	continue;
            }
            if (_unit.role() == obj_ini.role[100][eROLE.Techmarine]){
                // Case 1: on planet
                if (_unit.location_string == name) and (_unit.planet_location == planet){
                    p_player[planet]-=_unit.get_unit_size();
                    _unit.location_string="Mechanicus Vessel";
                    _unit.planet_location=0;
                    _unit.ship_location=-1;
                    _unit.job = {
                    	type : "mechanicus mission",
                    }
                    techs_taken+=1;
                }
                if (_unit.ship_location>-1){
                    ship_planet=obj_ini.ship_location[_unit.ship_location];
                    if (ship_planet=name){
                        obj_ini.ship_carrying[_unit.ship_location]-=_unit.get_unit_size();
                        _unit.location_string="Mechanicus Vessel";
                        _unit.planet_location=0;
                        _unit.ship_location=-1;
                        _unit.job = {
                        	type : "mechanicus mission",
                        }                            
                        techs_taken+=1;
                    }
                }
            }
        }
    }
    if (techs_taken=0){
        var alert_text="Mechanicus Mission Failed: Journey to Mars Catacombs at {planet_numeral_name(planet)}.";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text);
        obj_controller.disposition[3]-=10;
        remove_planet_problem(planet,"mech_mars");
    }


    else if (techs_taken>0){
        if (techs_taken>=5){
        	obj_controller.disposition[3]+=max(techs_taken,4);
        }
        var _text=$"Mechanicus Ship departs for the Mars catacombs.  Onboard are {techs_taken} of your {obj_ini.role[100][16]}s.";
        scr_alert("","mission",_text,0,0);
        scr_event_log("green",_text);
        var flit=instance_create(x,y,obj_en_fleet);

        with  (flit){
	        owner = eFACTION.Mechanicus;
	        sprite_index=spr_fleet_mechanicus;
	        capital_number=1;
	        image_index=0;
	        image_speed=0;
	        trade_goods="mars_spelunk1";
	        home_x=x;
	        home_y=y;
	        action_x=x+lengthdir_x(3000,obj_controller.terra_direction);
	        action_y=y+lengthdir_y(3000,obj_controller.terra_direction);	        	
        	set_fleet_movement(false, "move", 48, 48);   
        }
  
    }	
}

