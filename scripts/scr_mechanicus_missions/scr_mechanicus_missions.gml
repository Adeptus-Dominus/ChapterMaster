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
        var check1=scr_bionics_count("star",string(name),planet,"number");
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
	                if (planet_feature_bool(p_feature[planet],P_features.World_Eaters)==1){
	                    obj_turn_end.battle_special[obj_turn_end.battles]="world_eaters";
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
                    if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random","",0,obj_ini.home_name,2);
                    if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random","",0,obj_ini.ship[0],501);
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
    	}
    }
    var mars_mech_mission = has_problem_planet_and_time(planet,"mech_mars", 0);
    if (mars_mech_mission>-1){
        var techs_taken,com,ide,ship_planet, unit;
        techs_taken=0;com=-1;ide=0;ship_planet="";        	
        for (com =0; com<=10;com++){
            for (ide =0; ide<=array_length(obj_ini.role[com]);ide++){
                unit = fetch_unit([com,ide])
                if (unit.role()=obj_ini.role[100][eROLE.Techmarine]){
                    // Case 1: on planet
                    if (obj_ini.loc[com][ide]=name) and (unit.planet_location=planet){
                        p_player[planet]-=scr_unit_size(obj_ini.armour[com][ide],obj_ini.role[com][ide],true);
                        obj_ini.loc[com][ide]="Mechanicus Vessel";
                        unit.planet_location=0;
                        unit.ship_location=-1;
                        techs_taken+=1;
                    }
                    if (unit.ship_location>-1){
                        ship_planet=obj_ini.ship_location[unit.ship_location];
                        if (ship_planet=name){
                            obj_ini.ship_carrying[unit.ship_location]-=scr_unit_size(obj_ini.armour[com][ide],obj_ini.role[com][ide],true);
                            obj_ini.loc[com][ide]="Mechanicus Vessel";unit.planet_location=0;unit.ship_location=0;
                            techs_taken+=1;
                        }
                    }
                }
            }
        }
        if (techs_taken=0){
            var alert_text="Mechanicus Mission Failed: Journey to Mars Catacombs at "+string(name)+" "+scr_roman(planet)+".";
            scr_alert("red","mission_failed",alert_text,0,0);
            scr_event_log("red",alert_text);
            obj_controller.disposition[3]-=10;
            remove_planet_problem(planet,"mech_mars");
        }
    
    
        else if (techs_taken>0){
            if (techs_taken>=20) then obj_controller.disposition[3]+=max(techs_taken,4);
            var taxt="Mechanicus Ship departs for the Mars catacombs.  Onboard are "+string(techs_taken)+" of your "+string(obj_ini.role[100][16])+"s.";
            scr_alert("","mission",taxt,0,0);
            scr_event_log("green",taxt);
        }
        
        var flit=instance_create(x,y,obj_en_fleet);
        flit.owner = eFACTION.Mechanicus;
        flit.sprite_index=spr_fleet_mechanicus;
        flit.capital_number=1;flit.image_index=0;flit.image_speed=0;
        flit.trade_goods="mars_spelunk1";
        flit.home_x=x;
        flit.home_y=y;
        flit.action_x=x+lengthdir_x(3000,obj_controller.terra_direction);
        flit.action_y=y+lengthdir_y(3000,obj_controller.terra_direction);
        flit.action="move";flit.action_eta=48;                    	
    }
    if (has_problem_planet_and_time(planet,"mech_tomb1", 0)>-1){
        var alert_text="Mechanicus Mission Failed: Necron Tomb Study at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text, name);
        obj_controller.disposition[3]-=15; 
        remove_planet_problem(planet,"mech_tomb1");       	
    }
    if (has_problem_planet_and_time(planet,"mech_raider", 0)>-1){
        var alert_text="Mechanicus Mission Failed: Land Raider testing at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text);
        obj_controller.disposition[3]-=6;
        remove_planet_problem(planet,"mech_raider");      	
    }
    if (has_problem_planet_and_time(planet,"mech_bionics", 0)>-1){
        var alert_text="Mechanicus Mission Failed: bionics testing at "+string(name)+" "+scr_roman(planet)+".";
        scr_alert("red","mission_failed",alert_text,0,0);
        scr_event_log("red",alert_text);
        obj_controller.disposition[3]-=6; 
        remove_planet_problem(planet,"mech_bionics");       	
    }
}


function spawn_mechanicus_mission(){
	log_message("RE: Mechanicus Mission");
	var mechanicus_missions = []
	
	var _forge_stars = scr_get_stars(false, [eFACTION.Mechanicus],["Forge"]);
	
	if(array_length(_forge_stars)){
		array_push(mechanicus_missions, "mech_bionics");
		if (scr_role_count(obj_ini.role[100][16],"") >= 6) {
			array_push(mechanicus_missions, "mech_raider");
		}
	}
	
		
	with(obj_star){
		if(scr_star_has_planet_with_feature(id,P_features.Necron_Tomb)) and (awake_necron_Star(id)!= 0){
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
	if(mission_count == 0){
		log_error("RE: Mechanicus Mission, couldn't pick mission");
		exit;
	}
	
	var chosen_mission = array_random_element(mechanicus_missions);
	
    if (chosen_mission == "mech_bionics" || chosen_mission == "mech_raider" || chosen_mission == "mech_mars"){

		if(array_length(_forge_stars) == 0){
			log_error("RE: Mechanicus Mission, couldn't find a mechanicus forge world");
			exit;
		}

		var star = array_random_element(_forge_stars);

		var mission_data = {
			star : star.id,
			pathway_id : chosen_mission,
		}
		var _name = star.name;
        if (chosen_mission == "mech_raider"){
            var text=$"The Adeptus Mechanicus are trusting you with a special mission.  They wish for you to bring a Land Raider and six {obj_ini.role[100][16]} to a Forge World in {_name} for testing and training, for a duration of 24 months. You have four years to complete this.  Can your chapter handle this mission?";
            scr_popup("Mechanicus Mission",text,"mechanicus",mission_data);
			evented = true;
        }
        else if (chosen_mission == "mech_bionics") {
            var text=$"The Adeptus Mechanicus are trusting you with a special mission.  They desire a squad of Astartes with bionics to stay upon a Forge World in {_name} for testing, for a duration of 24 months.  You have four years to complete this.  Can your chapter handle this mission?";
            scr_popup("Mechanicus Mission",text,"mechanicus",mission_data);
			evented = true;
        }
        else {
            var text=$"The local Adeptus Mechanicus are preparing to embark on a voyage to Mars, to delve into the catacombs in search of lost technology.  Due to your close relations they have made the offer to take some of your {obj_ini.role[100][16]}s with them.  Can your chapter handle this mission?";
            scr_popup("Mechanicus Mission",text,"mechanicus",mission_data);
			evented = true;
        }
        //show_debug_message(mission_data);
    }

    else if (chosen_mission=="mech_tomb") {
		log_message("RE: Necron Tomb Study");
		stars = scr_get_stars();
		var valid_stars = array_filter_ext(stars, 
		function(star,index) {
			if(scr_star_has_planet_with_feature(star,P_features.Necron_Tomb)) and (awake_necron_Star(star)!= 0){
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
		var text=$"Mechanicus Techpriests have established a research site on a Necron Tomb World in the {star.name} system.  They are requesting some of your forces to provide security for the research team until the tests may be completed.  Further information is on a need-to-know basis.  Can your chapter handle this mission?";
            scr_popup("Mechanicus Mission",text,"mechanicus",_mission_data);
			evented = true;
    }	
}

function mechanicus_mission_procedures(){
	if ((option1 == "") && (title == "Mechanicus Mission")) {
		option1 = "Accept";
		option2 = "Refuse";
	}
	var mission = pop_data.pathway_id;
	var _star = pop_data.star
	if ((press == 1) && (option1 != "")) {
		if (mission=="mech_tomb") {
			if (_star != "none") {
				var _planet = false;
				for (var i = 1; i<_star.planets; i++) {
					if (awake_tomb_world(_star.p_feature[i])!=0){
						_planet = i;
						break;
					}
				}
				if (_planet > 0) {
					_planet = new PlanetData(_planet, _star);
					_planet.add_problem("mech_tomb1", 17)
					add_new_problem(_planet, "mech_tomb1", 17);
					var _name = _planet.name();
					text = $"The Adeptus Mechanicus await your forces at {_name}.  They are expecting at least two squads of Astartes and have placed the testing on hold until their arrival.  {global.chapter_name} have 16 months to arrive.";
					scr_event_log("", "Mechanicus Mission Accepted: At least two squads of marines are expected at {_name} within 16 months.", _star.name);
					new_star_event_marker("green");
					title = "Mechanicus Mission Accepted";
					option1 = "";
					option2 = "";
					cooldown = 15;
					exit;

				}
			}
		}

		else if (mission == "mech_bionics" || mission == "mech_raider" || mission == "mech_mars"){
			if (_star != "none") {
				var _forge_planet = scr_get_planet_with_type(_star, "Forge");
				var _planet = new PlanetData(_forge_planet, _star);

				if (_planet.current_owner == 3 && _forge_planet) {
					var _mission_loc = _planet.name();
					if (mission == "mech_raider") {
						_planet.add_problem("mech_raider", 49, {
							completion: 0, 
							required_months :24
						});
						text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting six {obj_ini.role[100][16]}s and a Land Raider.";
						scr_event_log("", $"Mechanicus Mission Accepted: Six of your {obj_ini.role[100][16]}s and a Land Raider are to be stationed at {_mission_loc} for 24 months.", _star.name);
					} else if (mission == "mech_bionics") {
						_planet.add_problem("mech_bionics", 49, {
							completion: 0, 
							required_months :24
						})
						text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting ten Astartes with bionics. (Beneficial traits: Weakness of Flesh )";
						scr_event_log("", $"Mechanicus Mission Accepted: Ten Astartes with bionics are to be stationed at {_mission_loc} for 24 months for testing purposes.", _star.name);
					} else if (mission == "mech_mars") {
						_planet.add_problem("mech_mars", 31 )
						text = $"The Adeptus Mechanicus await your {obj_ini.role[100][16]}s at {_mission_loc}.  They are willing to hold on the voyage for up to 12 months.";
						scr_event_log("", $"Mechanicus Mission Accepted: {obj_ini.role[100][16]}s are expected at {_mission_loc} within 30 months, for the voyage to Mars.", _star.name);
					}
					with (_star) {
						new_star_event_marker("green");
					}
					cooldown = 15;
					title = "Mechanicus Mission Accepted";
					option1 = "";
					option2 = "";
					option3 = "";
					exit;
				}
			}
		}
		// Other missions here
	} else if ((press == 2) && (option2 != "")) {
		obj_controller.cooldown = 10;
		if (number != 0) {
			obj_turn_end.alarm[1] = 4;
		}
		instance_destroy();
	}	
}