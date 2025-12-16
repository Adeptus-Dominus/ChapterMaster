// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function MissionHandler(planet, system) : PlanetData(planet, system) constructor{

}


function location_out_of_player_control(unit_loc){
	static _locs = ["Terra", "Mechanicus Vessel", "Lost", "Mars"];
	return (array_contains(_locs,unit_loc ));
}

#macro planet_problem_keys ["meeting_trap","meeting","succession","mech_raider","mech_bionics","mech_mars","mech_tomb1","fallen","great_crusade","harlequins","fund_elder","provide_garrison","hunt_beast","protect_raiders","join_communion","join_parade","recover_artifacts","train_forces","spyrer","inquisitor","recon","cleanse","purge","tyranid_org","artifact_loan","necron","ethereal","demon_world","deliver_trophy"]

function mission_name_key(mission){
	var mission_key = {
		"meeting_trap" : "Chaos Lord Meeting",
		"meeting" : "Chaos Lord Meeting",
		"succession" : "War of succession",
		"mech_raider" : "Provide Land Raider to Mechanicus",
		"mech_bionics" : "Provide Bionic Augmented marines to study",
		"mech_mars" : "Send Techmarines to mars",
		"mech_tomb1": "Explore Mechanicus Tomb",
		"fallen" : "Find Chapter Fallen",
		"great_crusade": "Answer Crusade Muster Call",
		"harlequins" : "Harlequin presence Report",
		"fund_elder" : "provide assistance to Eldar",
		"provide_garrison" : "Provision Garrison",
		"hunt_beast" : "Hunt Beasts",
		"protect_raiders" : "Protect From Raiders",
		"join_communion" : "Join Planetary Religious Celebration",
		"join_parade" : "Join Parade on Planet Surface",
		"recover_artifacts" : "Recover Artifacts",
		"train_forces" : "Train Planet Forces",
		// Inquisition missions
		"spyrer" : "Kill Spyrer for Inquisitor",
		"inquisitor": "Radical Inquisitor Arriving",
		"recon" : "Recon Mission for Inquisitor",
		"cleanse" : "Cleanse Planet for Inquisitor",
		"purge": "Purge Leadership for Inquisitor",
		"tyranid_org" : "Capture Tyranid for Inquisitor",
		// "bomb" : "Bombard World for Inquisitor",
		"artifact_loan" : "Safeguard Artifact for the Inquisition",
		"necron": "Bomb Necron Tomb for Inquisitor",
		"ethereal": "Capture Ethereal for Inquisitor",
		"demon_world": "Clear Demon World for Inquisitor"
		
	}
	if (struct_exists(mission_key, mission)){
		return mission_key[$ mission];
	} else{
		return "none"
	}  
}
function scr_new_governor_mission(planet, problem = ""){

	if p_owner[planet] != eFACTION.Imperium then exit;
	var planet_type= p_type[planet];
	if (problem == ""){
		if (planet_type=="Death"){
			problem = choose("hunt_beast", "provide_garrison");
			accept_time = 6+irandom(30);
		} else if (planet_type == "Hive"){
			problem = choose("show_of_power", "provide_garrison", "purge_enemies", "raid_black_market");
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
	}
	var mission_data = {
		stage : "preliminary",
		applicant : "Governor"
	};
	if (problem != ""){
		if (problem == "provide_garrison"){
			if (system_garrison[planet-1].garrison_force){
				exit;
			}
			mission_data.reason = choose("stability", "importance");
		} else if (problem=="purge_enemies"){
			var enemy = 0;
			if (planets>1){
				for (var i=1;i<=planets;i++){
					if (i=planet) then continue;
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

function init_marine_acting_strange(){
	log_message("RE: Strange Behavior");
    var marine_and_company = scr_random_marine("",0);
	if(marine_and_company == "none")
	{
		log_error("RE: Strange Behavior, couldn't pick a space marine");
		exit;
	}

	var unit = fetch_unit(marine_and_company);
	var role = unit.role();
	var text = unit.name_role();
	var company_text = scr_convert_company_to_string(unit.company);
	if(company_text != ""){
		company_text = $"({company_text})";
		text += company_text;
	}
	text += " is behaving strangely.";
	scr_alert("color","lol",text,0,0);
    scr_event_log("color",text);
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
	    gar_pop.text=$"The governor of {numeral_name} Thanks you for considering his request for a garrison, you agree that the garrison will remain for at least {garrison_length} months.";
	    //pip.image="event_march"
	    gar_pop.add_option("Commence Garrison");
        gar_pop.image="";
        gar_pop.cooldown=8;
        obj_controller.cooldown=8;	    
	    scr_event_log("",$"Garrison committed to {numeral_name} for {garrison_length} months.", star.name );
	}	
}


function role_compare(unit, role){
	return unit.role() == obj_ini.role[100][role];
}

function init_protect_raider_mission(squad){
	var _squad_units = squad.get_squad_structs();
	var _squad_wisdom = stat_average(_squad_units, "wisdom");
	var _squad_dex = stat_average(_squad_units, "dexterity");
	var _tester = global.character_tester;

	var _pdata = new PlanetData(selection_data.planet, selection_data.system);
	var _mod = _squad_wisdom+_squad_dex/20;
	if (scr_has_adv("Ambushers")){
		_mod += 10
	}

	var _leader = fetch_unit(squad.determine_leader());

	var _wis_test =  _tester.standard_test(_leader, "wisdom", _mod, ["ambush"]);

	if (!_wis_test[0]){
		var _mission_data = variable_clone(selection_data);
		if (_wis_test[1] < -25){
			scr_toggle_manage();
			var gar_pop = instance_create(0, 0, obj_popup);			
		    gar_pop.title=$"Strange Disappearance";
		    gar_pop.pdata = _pdata;
		    gar_pop.text=$"Your Marines make planet fall and are directed to report to the governor for the duration of the operation after a period of reconnaissance dig in for their ambush. After a two weeks have passed A message from the governor reaches your astropaths that your marines have not been heard of for some time, The raiders also were not noted to have arrived onor left the planet";
		    //pip.image="event_march"
		    var _dead_marine = array_random_index(_squad_units);
		    for (var i = 0;i<array_length(_dead_marine);i++){
		    	if ( i == _dead_marine){
		    		continue;
		    	}

				var _marine = _dead_marine[i];

				_marine.location_string = "Lost";
				_marine.ship_location = -1;
				_marine.planet_location = 0;
		    }
		    gar_pop.text += $"After eventual investigation it appears the eldar anticipated the would be ambushers and turned the tides. {_squad_units[_dead_marine].name_role()}s body is eventually discovered some way off from the main battle his rent armour and body showing the extent of combat that must have occured";

		    gar_pop.text += "\nThe total loss of a squad in what was meant to be a routine operation is bad for moral and your chapters reputation you must now decide how to proceed";

		    gar_pop.add_option({
		    	str1: "Suppress the Information",
		    	choice_func:protect_raiders_suppress_information
		    });


		    gar_pop.add_option({
		    	str1:"Hold a Memorial",
		    	choice_func:protect_raiders_hold_memorial
		    });			
		} else {
			scr_toggle_manage();
			var gar_pop = instance_create(0, 0, obj_popup);		
		    gar_pop.title=$"Ineffective Ambush";
		    gar_pop.text=$"Your Marines Are ineffective at setting up an ambush the assailants clearly got wind of the operation or the plan was otherwise so ill thought out that by the time your forces arrived there was little that could be done to intercept them";
		    //pip.image="event_march"
		    //var _dead_marine = array_random_index(_squad_units);
		    gar_pop.text += $"";
		    gar_pop.pathway = "protect_raiders_ineffective";
		    gar_pop.pdata = _pdata;
		    _pdata.add_disposition(-10);
		    gar_pop.text += "\nThe governor is unhappy and it has done little to improve your reputation with the planets populace but otherwise very little harm has been done. It is likely the raiders will choose better targets without the possible threat of space marine presence for the foreseeable future\nGovernor Disposition : -10";

		    gar_pop.add_option("continue");		
		}
	} else {

	    instance_create(0,0,obj_ncombat);
	    obj_ncombat.enemy = eFACTION.Eldar;
	    obj_ncombat.battle_object = selection_data.system;
	    obj_ncombat.battle_loc = selection_data.system.name;
	    obj_ncombat.battle_id = selection_data.planet;
	    obj_ncombat.battle_special = "protect_raiders";
	    _roster = new Roster();
	    with (_roster){
	        selected_units=_squad_units;
	        setup_battle_formations();
	        add_to_battle();
	    }
	    exit_adhoc_manage();
	    delete _roster;
	}	
}

function protect_raiders_suppress_information(){
	title = "Captains Disgruntled";
	options1 = "continue";
	pathway = "";
	var _caps = scr_role_count(obj_ini.roles[100][eROLE.Captain]);
	var _worst = -1;
	var _worst_hit  = -1;
	for (var i=0;i<array_length(_caps);i++){
		if (!irandom(2)){
			var _cap = _caps[i];
			var _loyalty_hit = irandom(6);
			if (_loyalty_hit>_worst_hit){
				_worst_hit = _loyalty_hit;
				_worst = i;
			}
		}
	}
	
	if (_worst == -1){
		text = $"You are able to convince your captains of the strategic need to cover up the incidence, various excuses are made and fake logs that cover up the disaster of the mission"
	} else {
		text = $"Not all of your captains are convinced of the need to use deceit and a none have breached the order but it has soured your relations with a few namely {_caps[_worst].name_role()}"
	}	
}

function protect_raiders_hold_memorial(){
		reset_popup_options();
		options1 = "continue";
		_pdata.add_disposition(-30);
		text =  $"You prepare to have a large public memorial for your fallen marines on the planet surface as a show of defiance. The chapter are pleased by such an act and the population of the planet are mesmerized by the spectacle. The governor is furious not only has his incompetence to deal with the planets xenos issue been made public in such a way that the sector commander has now heard about it but he perceives his failures are being paraded in font of him\n nGovernor Disposition : -30";
}

function init_train_forces_mission(planet, star, mission_slot, marine){
	var _pdata = new PlanetData(planet, star);
	var mission_data = _pdata.problems_data[mission_slot];
	if (mission_data.stage == "preliminary"){
		var numeral_name = _pdata.name();
		mission_data.stage = "active";
		var _mission_length=(irandom_range(3,12));
		star.p_timer[planet][mission_slot] = _mission_length;
	    //pop.image="ancient_ruins";
	    var gar_pop=instance_create(0,0,obj_popup);
	    //TODO some new universal methods for popups
	    gar_pop.title=$"Training forces on {numeral_name} begins";
	    gar_pop.text=$"{marine.name_role()} Has taken leave of his current post in order to aid the governor of {numeral_name} and his pdf commanders with training local forces and bolstering defences.";
	    var _is_cap = role_compare(marine, eROLE.Captain);

	    if (_is_cap){
	    	gar_pop.text += "the governor seems to be impressed that such a high ranking officer has been assigned to his request (disp +3)";
	    	_pdata.add_disposition(3);
	    }

	    //pip.image="event_march"
	    gar_pop.add_option($"Good luck {marine.name()}");
        gar_pop.image="";
        gar_pop.cooldown=500;
        obj_controller.cooldown=500;	    
	    scr_event_log("",$"{marine.name_role()} deployed to {numeral_name} for {_mission_length} months.", star.name);
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
            if (planet_feature_bool(p_feature[targ_planet], P_features.GeneStealerCult)){
                var cult = return_planet_features(planet.features,P_features.GeneStealerCult)[0];
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
        	planet.add_disposition(-20);
            scr_popup($"Agreed Garrison of {planet_numeral_name(targ_planet)}",$"your agreed garrison of  {planet_numeral_name(targ_planet)} was cut short by your chapter the planetary governor has expressed his displeasure (disposition -20)","","");
        }
        remove_planet_problem(targ_planet, "provide_garrison");
    } else {
        remove_planet_problem(targ_planet, "provide_garrison");
    }	
}
function complete_train_forces_mission(targ_planet, problem_index){
	var planet = new PlanetData(targ_planet, self);
	 if (problem_has_key_and_value(targ_planet,problem_index,"stage","active")){
	 	var man_conditions = {
            "job": "train_forces",
            "max" : 1,
        }
        var _mission_string = "";
        var _trainer = collect_role_group("all",[name,targ_planet,0], false, man_conditions);
        if (array_length(_trainer)){
        	var _unit_report_string = "";
        	var _tester = global.character_tester;
        	var _wis_test_difficulty = -20;
        	_trainer = _trainer[0];
        	var _tyannic_vet = _trainer.has_trait("tyrannic_vet");
        	if (_tyannic_vet){
        		_wis_test_difficulty += 10;
        		if (planet.has_feature(P_features.GeneStealerCult)){
        			var _cult = planet.get_features(P_features.GeneStealerCult)[0];
        			if (_cult.hiding){
        				planet.delete_feature(P_features.GeneStealerCult);
        				_mission_string += $"Fortune has smiled on this mission, {_trainer.name_role()}'s abilities as a Veteran of dealing with the Tyranids came in handy and in a short period was able to discern the existencee of a cult. He was able to organise those  he considered to be still loyal to rally an extermiation of the cult, reeports suggest he was so successful as to have completely wiped the genestealer presence from the planet";
        			}
        		}
        	}
        	var _siege_master = _trainer.has_trait("siege_master");
        	if (_siege_master){
        		_wis_test_difficulty+=10;
        	}
        	var _brute = _trainer.has_trait("brute");
        	if (_brute){
        		_wis_test_difficulty-=10;
        	}

        	var _leader = _trainer.has_trait("natural_leader");
        	if (_leader){
        		_wis_test_difficulty+=10;
        	}

        	_unit_pass = _tester.standard_test(_trainer, "wisdom",_wis_test_difficulty);
        	if (_unit_pass[0]){
        		var _new_pdf = planet.recruit_pdf((_unit_pass[1]/10));//this will approximate podf improvement for the time being
        		_mission_string += $"Training of the Pdf went well and improved the quality of the pdf as well as providing sizeable big recruitment improvement for the planet {_new_pdf} new pdf were recruited";
        		if (_leader){
        			var _disp_gain = 10;
        			planet.add_disposition(_disp_gain);
        			_mission_string += $"\n{_trainer.name_role()}s reputation a natural and confident leader proved well earned as he also made excellent diplomatic headway with the governor and his generals (disposition +{_disp_gain})"
        		}
        		if (_siege_master){
        			_mission_string += $"{_trainer.name()}s trained eye as a Siege Master also allowed him to make several improvements to the planets fortifications (fortification +1)";
        			planet.alter_fortification(1);
        		} else {
		            if (roll_dice(1, 100) > 75 && _trainer.intelligence > 45){
		                _mission_string += $"{_trainer.name()} has proven themselves a great strategist when it comes to defensive structures beyond previousy known ";
		                var _start_stats = variable_clone(_trainer.get_stat_line());
		                _trainer.add_trait("siege_master");
		                var end_stat = _trainer.get_stat_line();
		                var _stat_diff = compare_stats(end_stat,_start_stats); 
		                _unit_report_string += $"{_trainer.name_role()} Has gained the trait {global.trait_list.siege_master.display_name}, {(print_stat_diffs(_stat_diff))}\n"; 
		                _mission_string += "The new insights have allowed for minor improvements to planetary fortifications (fortification +1)";
		                planet.alter_fortification(1);
		            }
        		}
        	} else {
        		disp_loss = -5;
        		_mission_string += "The orgional training mission was a failiure"
        		if (_brute){
        			_mission_string += "in no short part due to his brutish nature";
        		}
        		_mission_string += ".";

        		_mission_string+= "He failed to work effectively with the existing chain of command";

        		if (_unit_pass[1]<-20){
        			var _hard_loss_traits = ["harshborn", "feral", "zealous_faith", "blood_for_blood", "blunt","brute", "brawler"];
        			var _hard_loss = false;
        			for (var i=0;i<array_length(_hard_loss_traits);i++){
        				if (array_contains(_trainer.traits, _hard_loss_traits[i])){
        					_hard_loss = true;
						}
					}
        			if (_hard_loss){
        				_mission_string += $"His particularly grueling regimes and standards imposed upon the senior officers of the pdf caused friction with physical injury being caused to one officer";
        				disp_loss = - 25;
        				_mission_string += "(disposition -25)";
        			}
        		}
        		planet.add_disposition(disp_loss);
        	}
        	_mission_string += $"\n{_unit_report_string}";
        	scr_popup($"Training Forces on {planet.name()}",_mission_string,"","");
        	remove_planet_problem(targ_planet, "train_forces");
        	_trainer.job = "none";
        }
	 }
}

function init_beast_hunt_mission(planet, star, mission_slot){
	var problems_data = star.p_problem_other_data[planet]
	var mission_data = problems_data[mission_slot];
	if (mission_data.stage == "preliminary"){
		var numeral_name = planet_numeral_name(planet, star);
		mission_data.stage = "active";
		var _mission_length=(irandom_range(2,5));
		star.p_timer[planet][mission_slot] = _mission_length;
	    //pop.image="ancient_ruins";
	    var gar_pop=instance_create(0,0,obj_popup);
	    //TODO some new universal methods for popups
	    gar_pop.title=$"Marines assigned to hunt beasts around {numeral_name}";
	    gar_pop.text=$"The govornor of {numeral_name} Thanks you for the participation of your elite warriors in your execution of such a menial task.";
	    //pip.image="event_march"
	    gar_pop.add_option({
	    	str1: "Happy Hunting"
	    });
        gar_pop.image="";
        gar_pop.cooldown=8;
        obj_controller.cooldown=20;	    
	    scr_event_log("",$"Beast hunters deployed to {numeral_name} for {_mission_length} months.", star.name);
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
        var _successful_hunters = [];
        var _largest_pass= 0;
        for (var i=0;i<array_length(_hunters);i++){
        	_unit = _hunters[i];
			_unit_pass = _tester.standard_test(_unit, "weapon_skill",10, ["beast"]);
			if (_unit_pass[0]){
				_success=true;
				_largest_pass = max(_largest_pass,_unit_pass[1]);
			}
			if (_unit_pass[0]){

				_unit_report_string += _unit.add_trait("beast_slayer",true, true);
				array_push(_successful_hunters, _unit);
			} else {
				var _tough_check = _tester.standard_test(_unit, "constitution",_unit.luck);
				if (!_tough_check[0]){
					if (_tough_check[1]<-10){
						_unit_report_string += $"{_unit.name_role()} Was mauled to death\n";
						scr_kill_unit(_unit.company, _unit.marine_number);
						_deaths++;
					} else if (_tough_check[1]>=-10){
						if (irandom(100)<_unit.luck){
							_unit.add_or_sub_health(-100);
							_unit_report_string += $"{_unit.name_role()} Was injured (health - 100)\n";
						} else {
							_unit.add_or_sub_health(-250);
							_unit_report_string += $"{_unit.name_role()} Was Badly injured, it is unknown if he will recover (health - 250)\n";
						}
					}
				}
			}
			_unit.job="none"
        }

        var _pop_data = "";
        var _navy_fleets = get_imperial_navy_fleets();
        if (array_length(_successful_hunters) && _largest_pass > 20 && array_length(_navy_fleets)){
	        _pop_data = {
	        	trophy_owner : array_random_element(_successful_hunters),
	        	system: self.name,
	        	planet : targ_planet,
	        	target_fleet : array_random_element(_navy_fleets)
	        };

	        var _options = {
	        	choice_func : init_deliver_trophy_mission,
	        	str1 : "Continue",
	        }

	        _pop_data.options = _options;
	    }
        if (_success){
        	_mission_string = $"The mission was a success and a great number of beasts rounded up and slain, your marines were able to gain great skills and the prestige of your chapter has increased greatly across the planets populace."
        	if (_deaths){
        		_mission_string += $"Unfortunatly {_deaths} of your marines died."
        	}
        	_mission_string += $"\n{_unit_report_string}";
        } else {
        	_mission_string = $"The mission was a failiure. The governor is disapointed and the legend of your chapter has undoubtedly been diminished";
        	_mission_string += $"\n{_unit_report_string}";
        }
        scr_popup($"Beast Hunt on {planet_numeral_name(i)}",_mission_string,"",_pop_data);
        remove_planet_problem(targ_planet, "hunt_beast");

    } else {
        remove_planet_problem(targ_planet, "hunt_beast");
    }	
}
function init_deliver_trophy_mission(){
	text = $"After your marines return there is a great feast to honour them. Much fanfare is made of the great trophy {pop_data.trophy_owner.name_role()} bears, a great monstrous head as tall as he is that the governor proclaims must be the largest of it's kind and the momst fearsome beast in the sector.";

	text += $"\n\nAn astropathic message is later recieved from the Commander of an Imperial Navy fleet explaining that his fleet is currrently home to the {irandom_numeral(100)},{irandom_numeral(100)} and {irandom_numeral(100)} {pop_data.system} Regiments and pleads that the trophy be handed over to his fleet in order to boost the moral of the regiments and fleet in general";

	replace_options([
		{
			str1 : "Refuse and place the trophy into the Librarium",
			choice_func : function(){
				scr_add_artifact();
			}

		},
		{
			str1 : "Accept",
			choice_func : accept_deliver_trophy_mission
		}
	]);

}



function accept_deliver_trophy_mission(){
	text = $"You Send a reply to tell the commander you accept and will ensure the trophy is delivered in person by the marine that slew the beast";
	var _targ_fleet = pop_data.target_fleet;

	var _targ_fleet_intercept = fleets_next_location(_targ_fleet);
	if (_targ_fleet.action==""){
		text += $"\n\n the fleet in question is currently active around the  {_targ_fleet_intercept.name} system";
	} else {
		text += $"\n\n the fleet will next be accessible around the  {_targ_fleet_intercept.name} system";
	}

	pop_data.target_fleet = _targ_fleet.uid;

	pop_data.delivering_marine = pop_data.trophy_owner.name_role();
	var _t_owner = pop_data.trophy_owner;
	pop_data.trophy_owner = _t_owner.uid;

	var _fleet_event = new FleetEvent(pop_data);

	_fleet_event.turn_end = "deliver_trophy_end_turn_check";
	_fleet_event.destroy = "deliver_trophy_mission_fleet_destroyed";
	_fleet_event.timer_end = "deliver_trophy_mission_timed_out";

	_fleet_event.timer = 120;

	_targ_fleet.add_event(_fleet_event);

	reset_popup_options();
}


///@mixin FleetEvent
function deliver_trophy_mission_timed_out(){
	scr_popup(
		"Objective Forgotten", 
		$"It has been so long in the life of a mortal that the commanders that once saught your delivery of the trophy from the hunt on {fleetevent_data.system} have now all either died or moved to greener pastures. The trophy will instead remain in the chapters possession",
	);
}

///@mixin FleetEvent
function deliver_trophy_mission_fleet_destroyed(){
	scr_popup(
		"Fleet Destroyed", 
		$"With the Imperial Navy fleet containing the regiments from {fleetevent_data.system} destroyed there is no reason to now deliver the trophy from the hunt to them The trophy will instead remain in the chapters possession",
	);	
}

///@mixin FleetEvent
function deliver_trophy_end_turn_check(){
	show_debug_message($"evetn_Data  = {fleetevent_data}");
	var _navy_fleet = get_fleet_uid(fleet_uid);
	if (!instance_exists(_navy_fleet)){
		deliver_trophy_mission_fleet_destroyed();
		return;
	}

	var _ratio =0;
	with (_navy_fleet){
		_ratio = fleet_remaining_guard_ratio();
	}

	if (_ratio<=0){
		scr_popup(
			"Regiments Destroyed ", 
			$"The guard Regiments from {fleetevent_data.system} serving in the imperial navy fleet have been annihilated wholesale there is no reason to now deliver the trophy from the hunt to them The trophy will instead remain in the chapters possession",
		);	
		return;		
	}

	if (is_orbiting(_navy_fleet)){
		var _nearest_player = instance_at_location(_navy_fleet.x,_navy_fleet.y,obj_p_fleet);
		if (instance_exists(_nearest_player)){
			var _ships = fleet_full_ship_array(_nearest_player);
			var _marine = fetch_unit_uid(fleetevent_data.trophy_owner);
			var _present = _marine.is_at_location("", 0, _ships);
			var _meet_point = _navy_fleet.orbiting;  
			if (_present){
				var _text = "{_marine.role(name)} is able to rendevous with the imperial navy at {_meet_point.name}."
				_text += $" The guard regiments of {fleetevent_data.system} are overjoyed at the delivery of the trophy and find the beast that the head came from adorns many of the regiments banners.";
				_text += $" While The task is for the most part thankless your chapters esteem has risen greatly with the exploits of {_marine.role(name)} spreading far and wide amoung guard regiments.";
				var _roll = roll_dice_chapter(1, 100, "high");
				if (_roll>30 && _roll<70){
					//TODO would be cool to have this changed to be a guard specific piece of equipment
					_text += "In return for your labour and in honour of your chapter the commander of the guard division has a brand new Rhino destined for the army diverted to your chapter";
					scr_add_vehicle("Rhino");
				} else if (_roll>=70 ){
					var _wanted_types = ["Ice","Desert","Agri","Lava","Death"];
					var _star = scr_get_stars(true,[],_wanted_types)[0];
					_text += "During the concourse that follows with the fleet command your marines learn of a old battle ground discovered on {_star.name}.";
					_text += "According too intel it appeared to be an old astartes battle ground from an unknown age, communications have been passed onto the adeptus mechanicus who will no doubt pick the site clean should they reach it befre you do";

					var _planet = scr_get_planet_with_type(_wanted_types);
					var _battle_ground = new NewPlanetFeature(P_features.AstartesBattleGround);

					_battle_ground.player_hidden = false;

					_star.add_feature(_planet,_battle_ground);
				}
				scr_popup(
					"Trophy Delivered ", 
					_text,
				);					
			}
		}
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
	var _problemless = true;
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] != ""){
				_problemless=false;
				break;
			}
		}
	} else {
		with (star){
			_problemless =  planet_problemless(planet);
		}
	}
	return _problemless;
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


function increment_mission_completion(mission_data){
	if (!struct_exists(mission_data, "completion")){
		mission_data.completion = 0;
	}
	mission_data.completion++;
    if (!struct_exists(mission_data, "required_months") || mission_data.required_months <= 0) {
        log_error("Invalid required_months in mission_data");
        return 0;
    }
	return (mission_data.completion/mission_data.required_months) * 100;
}
//search problem data for a given and key and iff applicable value on that key
//TODO increase filtering and search options
function problem_has_key_and_value(planet, problem,key,value="",star="none"){
	var has_data=false;
	if (star=="none"){
		var problem_data = p_problem_other_data[planet][problem];
		if (struct_exists(problem_data, key)){
			if (value==""){
				has_data=true;
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
