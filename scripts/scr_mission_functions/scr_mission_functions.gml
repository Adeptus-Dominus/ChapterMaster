// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function mission_name_key(mission){
	var mission_key = {
		"meeting_trap" : "Chaos Lord Meeting",
		"meeting" : "Chaos Lord Meeting",
		"succession" : "War of succession",
		"spyrer" : "Kill Spyrer for Inquisitor",
		"mech_raider" : "Provide Land Raider to Mechanicus",
		"mech_bionics" : "Provide Bionic Augmented marines to study",
		"mech_mars" : "Send Techmarines to mars",
		"mech_tomb1": "Explore Mechanicus Tomb",
		"fallen" : "Find Chapter Fallen",
		"recon" : "Recon Mission for Inquisitor",
		"cleanse" : "Cleanse Planet for Inquisitor",
		"tyranid_org" : "Capture Tyranid for Inquisitor",
		"recon" : "Recon Mission for Inquisitor",
		"bomb" : "Bombard World for inquisitor",
		"great_crusade": "Answer Crusade Muster Call",
		"harlequins" : "Harlequin presence Report",
		"artifact_loan" : "Safeguard Artifact for the inquisition",
		"fund_elder" : "provide assistance to Eldar",
		"provide_garrison" : "Provision Garrison",
		"hunt_beast" : "Hunt Beasts",
		"protect_raiders" : "Protect From Raiders",
		"join_communion" : "Join Planetary Religious Celebration",
		"join_parade" : "Join Parade on Planet Surface",
		"recover_artifacts" : "Recover Artifacts"
	}
	if (struct_exists(mission_key, mission)){
		return mission_key[$ mission];
	} else{
		return "none"
	}  
}
function scr_new_governor_mission(planet){
	problem = "";
	if p_owner[planet]!=eFACTION.Imperium then exit;
	var planet_type= p_type[planet];
	if (planet_type=="Death"){
		problem = choose("hunt_beast", "provide_garrison");
		accept_time = 6+irandom(30);
	} else if (planet_type == "Hive"){
		problem = choose("Show_of_power", "provide_garrison", "purge_enemies", "raid_black_market");
	} else if (planet_type == "Temperate"){
		problem = choose("provide_garrison", "train_forces", "join_parade");
	}else if (planet_type == "Shrine"){
		problem = choose("provide_garrison", "join_communion");
	}else if (planet_type == "Ice"){
		problem = choose("provide_garrison", "hunt_beast");
	}else if (planet_type == "Lava"){
		problem = choose("provide_garrison", "protect_raiders");
	}else if (planet_type == "Agri"){
		problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
	}else if (planet_type == "Desert"){
		problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
	}else if (planet_type == "Feudal"){
		problem = choose("hunt_beast", "protect_raiders");
	}
	var mission_data = {
		stage : "preliminary",
		applicant : "Governor"
	};
	if (problem != ""){
		if (problem == "provide_garrison"){
			if (system_garrison[planet-1].garrison_force) then exit;
			mission_data.reason = choose("stability", "importance");
		} else if (problem=="purge_enemies"){
			var enemy = 0;
			if (planets>1){
				for (var i=1;i<=planets;i++){
					if(i=planet) then continue;
					if (p_owner[i]==eFACTION.Imperium){
						enemy=i;
						break;
					}
				}
			}
			mission_data.target=enemy;
			if (!enemy) then exit;
		}
		add_new_problem(planet,problem, 20+irandom(20), ,mission_data);
	}
}


function init_garrison_mission(planet, star, mission_slot){
	var problems_data = star.p_problem_other_data[planet]
	var mission_data = problems_data[mission_slot];
	if (mission_data.stage == "preliminary"){
		var numeral_name = planet_numeral_name(planet, star);
		mission_data.stage = "active";
		var garrison_length=(10+irandom(6));
		star.p_timer[planet][mission_slot] = garrison_length;
	    //pop.image="ancient_ruins";
	    var gar_pop=instance_create(0,0,obj_popup);
	    //TODO some new universal methods for popups
	    gar_pop.title=$"Requested Garrison Provided to {numeral_name}";
	    gar_pop.text=$"The govornor of {numeral_name} Thanks you for considering his request for a garrison, you agree that the garrison will remain for at least {garrison_length} months.";
	    //pip.image="event_march"
	    gar_pop.option1="Commence Garrison";
        gar_pop.image="";
        gar_pop.cooldown=8;
        obj_controller.cooldown=8;	    
	    scr_event_log("",$"Garrison commited to {numeral_name} for {garrison_length} months.", target.name);
	}	
}



function init_beast_hunt_mission(planet, star, mission_slot){
	var problems_data = star.p_problem_other_data[planet]
	var mission_data = problems_data[mission_slot];
	if (mission_data.stage == "preliminary"){
		var numeral_name = planet_numeral_name(planet, star);
		mission_data.stage = "active";
		var mission_length=(irandom_range(2,5));
		star.p_timer[planet][mission_slot] = mission_length;
	    //pop.image="ancient_ruins";
	    var gar_pop=instance_create(0,0,obj_popup);
	    //TODO some new universal methods for popups
	    gar_pop.title=$"Marines assigned to hunt beasts around {numeral_name}";
	    gar_pop.text=$"The govornor of {numeral_name} Thanks you for the participation of your elite warriors in your execution of such a menial task.";
	    //pip.image="event_march"
	    gar_pop.option1="Happy Hunting";
        gar_pop.image="";
        gar_pop.cooldown=8;
        obj_controller.cooldown=8;	    
	    scr_event_log("",$"Beast hunters deployed to {numeral_name} for {mission_length} months.", star.name);
	}	
}
//@mixin obj_star
function complete_garrison_mission(targ_planet, problem_index){
	var planet = new PlanetData(targ_planet, self);
    if (problem_has_key_and_value(targ_planet,problem_index,"stage", "active")){
        if (planet.current_owner == eFACTION.Imperium && system_garrison[targ_planet-1].garrison_force){
            var _mission_string = $"The garrison on {planet_numeral_name(targ_planet)} has finished the period of garrison support agreed with the planetary governor.";
            var p_garrison = system_garrison[targ_planet-1];
            var  result = p_garrison.garrison_disposition_change(id, targ_planet);
            if (!p_garrison.garrison_leader){
                p_garrison.find_leader();
            }
            if (result == "none"){
            //TODO make a dedicated plus minus string function if there isn't one already
            } else if (!result){
                var effect = result * irandom_range(1,5);
                dispo[targ_planet] += effect;
                _mission_string += $"A number of diplomatic incidents occured over the period which had considerable negative effects on our disposition with the planetary governor (disposition -{effect})";
            } else {
                var effect = result * irandom_range(1,5);
                dispo[targ_planet] += result * effect;
                _mission_string += $"As a diplomatic mission the duration of the stay was a success with our political position with the planet being enhanced greatly (disposition +{effect})";
            }
            var tester = global.character_tester;
            var widom_test = tester.standard_test(p_garrison.garrison_leader, "wisdom",0, ["siege"]);
            if (widom_test[0]){
                p_fortified[targ_planet]++;
                _mission_string+=$"while stationed {p_garrison.garrison_leader.name_role()} makes several notable observations and is able to instruct the planets defense core leaving the world better defended (fortifications++).";
            }
            //TODO just generall apply this each turn with a garrison to see if a cult is found
            if (planet_feature_bool(p_feature[targ_planet], P_features.Gene_Stealer_Cult)){
                var cult = return_planet_features(planet.features,P_features.Gene_Stealer_Cult)[0];
                if (cult.hiding){
                    widom_test = tester.standard_test(p_garrison.garrison_leader, "wisdom",0, ["tyranids"]);
                    if (widom_test[0]){
                        cult.hiding = false;
                        _mission_string+="Most alarmingly signs of a genestealer cult are noted by the garrison. how far the rot has gone will now need to be investigated and the xenos taint purged.";
                    }
                }
            }
            scr_popup($"Agreed Garrison of {planet_numeral_name(targ_planet)} complete",_mission_string,"","");
        } else {
            dispo[targ_planet] -= 20;
            scr_popup($"Agreed Garrison of {planet_numeral_name(targ_planet)}",$"your agreed garrison of  {planet_numeral_name(targ_planet)} was cut short by your chapter the planetary governor has expressed his displeasure (disposition -20)","","");
        }
        remove_planet_problem(targ_planet, "provide_garrison");
    } else {
        remove_planet_problem(targ_planet, "provide_garrison");
    }	
}

function complete_beast_hunt_mission(targ_planet, problem_index){
    var planet = new PlanetData(targ_planet, self);
    if (problem_has_key_and_value(targ_planet,problem_index,"stage","active")){
        _mission_string = "";
        var man_conditions = {
            "job": "hunt_beast",
            "max" : 3,
        }
        var _hunters = collect_role_group("all",[name,targ_planet,0], false, man_conditions);
        var _success = false;
        var _tester = global.character_tester;
        var _unit_pass;
        var _unit;
        var _unit_report_string = "";
        var _deaths = 0;
        if (!array_length(_hunters)){
        	remove_planet_problem(targ_planet, "hunt_beast");
        	return;
        }
        for (var i=0;i<array_length(_hunters);i++){
        	_unit = _hunters[i];
			_unit_pass = _tester.standard_test(_unit, "weapon_skill",10, "beast");
			if (_unit_pass[0]){
				if (!_success) then _unit_pass=true;
			}
			if (_unit_pass[0]){
				_unit.add_trait("beast_slayer");
				_unit_report_string += $"{_unit.name_role()} Has gained the trait {global.trait_list.beast_slayer.display_name}\n";
			} else {
				var _tough_check = _unit_pass = _tester.standard_test(_unit, "constitution",unit.luck);
				if (!_tough_check[0]){
					if (_tough_check[1]<-10){
						_unit_report_string += $"{_unit.name_role()} Was mauled to death\n";
						scr_kill_unit(_unit.company, unit.marine_number);
						_deaths++;
					} else if (_tough_check[1]>=-10){
						if (irandom(100)<unit.luck){
							unit.add_or_sub_health(-100);
							$"{_unit.name_role()} Was injured (health - 100)\n";
						} else {
							unit.add_or_sub_health(-250);
							$"{_unit.name_role()} Was Badly injured, it is unknown if he will recover (health - 250)\n";
						}
					}
				}
			}
			_unit.job="none"
        }
        if (_success){
        	_mission_string = $"The mission was a success and a great number of beasts rounded up and slain, your marines were able to gain great skills and the prestige of your chapter has increased greatly across the planets populace."
        	if (_deaths){
        		$"Unfortunatly {_deaths} of your marines died."
        	}
        	_mission_string += $"\n{_unit_report_string}";
        } else {

        }
        scr_popup($"Beast Hunt on {planet_numeral_name(i)}",_mission_string,"","");
        remove_planet_problem(targ_planet, "hunt_beast");
    } else {
        remove_planet_problem(targ_planet, "hunt_beast");
    }	
}

//TODO allow most of these functions to be condensed and allow arrays of problems or planets and maybe increase filtering options
//filtering options could be done via universal methods that all the filters to be passed to many other game systems
function has_any_problem_planet(planet, star="none"){
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] != ""){
				return true;
			}
		}
	} else {
		with (star){
			return has_any_problem_planet(planet);
		}
	}
	return false;
}

function planet_problemless(planet, star="none"){
	var has_problem = false;
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] != ""){
				has_problem=true;
				break;
			}
		}
	} else {
		with (star){
			has_problem =  planet_problemless(planet);
		}
	}
	return !has_problem;
}

/*
//may not be needed but will be a loop of planet_problemless
function star_problemless(){

}*/

// returns a bool for if any planet on a given star has the given problem
function has_problem_star(problem, star="none"){
	var has_problem = false;
	if (star=="none"){
		for (var i=1;i<=planets;i++){
			has_problem = has_problem_planet(i, problem);
			if (has_problem){
				has_problem=i;
				break
			}
		}
	} else {
		with (star){
			has_problem = has_problem_star(problem);
		}
	}
	return has_problem;
}


//returns a bool for if a planet has a given problem
function has_problem_planet(planet, problem, star="none"){
	if (star=="none"){
		return array_contains(p_problem[planet], problem);
	} else {
		with (star){
			return has_problem_planet(planet, problem);
		}
	}
}

//returns the array position of a given problem on a given planet if the specfied time is given
function has_problem_planet_and_time(planet, problem, time,star="none"){
	var _had_problem = -1;
	if (star=="none"){
		for (var i = 0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				if (p_timer[planet][i] == time){
					_had_problem=i;
				}
			}
		}
	} else {
		with (star){
			_had_problem=has_problem_planet_and_time(planet, problem, time);
		}
	}
	return _had_problem;	
}

//returns the array position of a given problem on a given planet if the specfied time is above 0
 function has_problem_planet_with_time(planet, problem,star="none"){
	var _had_problem = -1;
	if (star=="none"){
		for (var i = 0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				if (p_timer[planet][i] >0){
					_had_problem=i;
				}
			}
		}
	} else {
		with (star){
			_had_problem=has_problem_planet_with_time(planet, problem)
		}
	}
	return _had_problem;	
}


//returns the array position of a gien problem on a given planet 
function find_problem_planet(planet, problem, star="none"){
	if (star=="none"){
		for (var i = 0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				return i;
			}
		}
	} else {
		with (star){
			return find_problem_planet(planet, problem);
		}
	}
	return -1;
}


///removie all of a given problem from a planet
function remove_planet_problem(planet, problem, star="none"){
	var _had_problem = -1;
	if (star=="none"){
		for (var i = 0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				p_problem[planet][i]="";
				p_timer[planet][i]=-1;
				p_problem_other_data[planet][i]={};
				_had_problem=true;
			}
		}
	} else {
		with (star){
			_had_problem=remove_planet_problem(planet, problem);
		}
	}
	return -1;	
}

//find an open problem slot on a given planet
function open_problem_slot(planet, star="none"){
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == ""){
				return i;
			}
		}
	} else {
		with (star){
			return open_problem_slot(planet)
		}
	}
	return -1;
}

//remove all of a given problem types from a star
function remove_star_problem(problem, star="none"){
	if (star=="none"){
		for (var i=1;i<=planets;i++){
			remove_planet_problem(i, problem);
		}
	} else {
		with (star){
			remove_remove_star_problem(problem);
		}
	}
}


//count donw the p_timer on a given planet
function problem_count_down(planet, count_change=1){
	for (var i=0;i<array_length(p_problem[planet]);i++){
		if (p_problem[planet][i]!=""){
			p_timer[planet][i]-=count_change;
			if (p_timer[planet][i]==-5){
				p_problem[planet][i]="";
				p_timer[planet][i]=-1;
			}
		}
	}
}

//add a new problem
function add_new_problem(planet, problem, timer,star="none", other_data={}){
	var problem_added=false;
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] ==""){
				p_problem[planet][i]= problem;
				p_problem_other_data[planet][i]=other_data;
				p_timer[planet][i] = timer;
				problem_added=i;
				break;
			}
		}
	} else {
		with (star){
			problem_added =  add_new_problem(planet, problem, timer,"none",other_data);
		}
	}
	return 	problem_added;
}

//search problem data for a given and key and iff applicable value on that key
//TODO increase filtering and search options
function problem_has_key_and_value(planet, problem,key,value="",star="none"){
	var has_data=false;
	if (star=="none"){
		var problem_data = p_problem_other_data[planet][problem];
		if (struct_exists(problem_data, key)){
			if (value==""){
				has_data=true
			} else if( problem_data[$ key] == value){
				has_data=true;
			}
		}
	} else {
		with (star){
			has_data = problem_has_key_and_value(planet, problem,key,value);
		}
	}
	return 	has_data;
}


function mission_rewards(){

}