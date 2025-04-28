// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro ARR_strength_descriptions ["none", "Minimal", "Sparse", "Moderate", "Numerous", "Very Numerous", "Overwhelming"];

function PlanetData(planet, system) constructor{
//safeguards // TODO LOW DEBUG_LOGGING // Log when tripped somewhere
    //disposition
    if (system.dispo[planet] < -100 && system.dispo[planet] > -1000 && system.p_owner[planet] != eFACTION.Player ) { // Personal Rule code be doing some interesting things
        system.dispo[planet] = -100; // TODO LOW DISPOSITION_REVAMP // Consider revamping the disposition system
    } else if (system.dispo[planet] > 100) {
        system.dispo[planet] = 100;
    }
//
	static large_pop_conversion = 1000000000;

    self.planet = planet;
    self.system = system;
    x = system.x;
    y = system.y;
    player_disposition = system.dispo[planet];
    planet_type = system.p_type[planet];
    operatives = system.p_operatives[planet];
    features = system.p_feature[planet];
    current_owner = system.p_owner[planet];
    origional_owner = system.p_first[planet];
    population = system.p_population[planet];
    max_population = system.p_max_population[planet];
    large_population = system.p_large[planet];
    secondary_population = system.p_pop[planet];
    is_craftworld = system.craftworld;
    is_hulk = system.space_hulk;

    static set_player_disposition = function(new_dispo){
    	player_disposition = new_dispo;
        system.dispo[planet] = player_disposition;
    }

    static set_population = function(new_population){
    	population = new_population;
    	system.p_population[planet] = population;
    }

    static edit_population = function(edit_val){
    	population = population + edit_val >= 0 ? population + edit_val : 0;
    	system.p_population[planet] = population;
    }

    //assumes a large pop figure and changes down if small pop planet
    static population_small_conversion = function(pop_value){
    	if (!large_population){
    		pop_value *= large_pop_conversion;
    	}
    	return pop_value;
    }

    static send_colony_ship = function(target, targ_planet, type){
        new_colony_fleet(system, planet, target, targ_planet, type);
    }

    static return_to_first_owner = function(allow_player = false){
    	if (!allow_player && origional_owner == eFACTION.Player){
    		system.p_owner[planet]= eFACTION.Imperium;
    	} else {
    		system.p_owner[planet] = origional_owner;
    	}
    	current_owner = origional_owner;
    }

    static add_disposition = function(alteration){
    	var _new_dispo = clamp(player_disposition+alteration, 0, 100);
    	player_disposition = _new_dispo;
    	system.dispo[planet] = player_disposition;

    }

    static display_population = function(){
    	if (large_population){
    		return $"{population} B";
    	} else {
    		return $"{scr_display_number(population)}";
    	}
    }

    static owner_status = function(){
    	return obj_controller.faction_status[current_owner];
    }

    static at_war = function(imperium=1, antagonism=0, war=1){
        var _at_war = false
        if (imperium) {
            if (current_owner>5) then _at_war=true;
        }

        if (antagonism) {
            if (owner_status()=="Antagonism") then _at_war=true;
        }

        if (war) {
            if (owner_status()=="War") then _at_war=true;
        }
        return _at_war;
    }

    guardsmen = system.p_guardsmen[planet];
    pdf = system.p_pdf[planet];
    fortification_level  = system.p_fortified[planet];
    static alter_fortification = function(alteration){
    	system.p_fortified[planet] += alteration;
    	fortification_level = system.p_fortified[planet];
    }

    static recruit_pdf = function(percentage_pop){
    	var new_pdf = population * (percentage_pop/100);
    	edit_population(new_pdf*-1);
    	if (large_population){
    		new_pdf *= large_pop_conversion;
    	}
    	pdf += new_pdf;
    	system.p_pdf[planet] = pdf;
    	return new_pdf;
    }
    star_station = system.p_station[planet];
    pdf_loss_reduction = 0;

    // Whether or not player forces are on the planet
    player_forces = system.p_player[planet];
    defence_lasers = system.p_lasers[planet];
    defence_silos = system.p_silo[planet];
    ground_defences = system.p_defenses[planet];
    upgrades = system.p_upgrades[planet];
    // v how much of a problem they are from 1-5
    planet_forces = array_create(14, 0);

    try{
    	planet_forces[1] = player_forces;

	    planet_forces[2] =	guardsmen;

	    planet_forces[5] =	system.p_sisters[planet];
	    planet_forces[6] =	system.p_eldar[planet];
	    planet_forces[7] =	system.p_orks[planet];
	    planet_forces[8] =	system.p_tau[planet];
	    planet_forces[9] =	system.p_tyranids[planet];
		planet_forces[10] =	system.p_traitors[planet];   	
	    planet_forces[11] =	system.p_chaos[planet]+ system.p_demons[planet];

	    planet_forces[13] =	system.p_necrons[planet];
	}catch(_exception){
		handle_exception(_exception);
	}

	static add_forces = function(faction, val){
		planet_forces[faction] = clamp(planet_forces[faction]+val,0,12);
		var _new_val = planet_forces[faction];
		switch (faction){
			case eFACTION.Ork:
				system.p_orks[planet] = _new_val;
				break;
		}
	}

    static grow_ork_forces = function(){
        var contin=0;
        var rando=roll_dice(1,100);// This part handles the spreading
        // if (rando<30){
        var _non_deads = planets_without_type("dead", system);

        var _has_warboss = has_feature(P_features.OrkWarboss);
        var _has_stronghold = has_feature(P_features.OrkStronghold);
        var _build_ships = false;
        if (_has_stronghold){
            var _stronghold = get_features(P_features.OrkStronghold)[0];
        }

        if (_has_warboss){
            var _warboss = get_features(P_features.OrkWarboss)[0];
            _warboss.turns_static++;
        }
        if (array_length(_non_deads)>0 && rando>40){
            var _ork_spread_planet = array_random_element(_non_deads);
            var _orks = planet_forces[eFACTION.Ork]
            var _ork_target = system.p_orks[_ork_spread_planet];
            var _spread_orks = (current_owner==eFACTION.Ork &&  ((pdf + guardsmen + planet_forces[8] + planet_forces[10]+planet_forces[1]) == 0 ));
            if (_spread_orks){
                // determine maximum Ork presence on the source planet
                var _ork_max = planet_forces[eFACTION.Ork];

                if (_ork_max<5 && _ork_target<2) then  system.p_orks[_ork_spread_planet]++;
                if (_orks>4 && _ork_target<3){
                    system.p_orks[_ork_spread_planet]++;
                    if (_ork_target<3){
                        system.p_orks[_ork_spread_planet]++;
                        add_forces(eFACTION.Ork, -1);
                    }
                }

            }
        }
        contin=0;
        rando=roll_dice(1,100);// This part handles the ship building
        if (population>0 && pdf==0 && guardsmen==0 && planet_forces[10]==0) and (planet_forces[eFACTION.Tau]==0){
        	if (!large_population){
				set_population(population*0.97);
			}else {
				edit_population(-0.01);
			}
        	
        };
    
        var enemies_present=false;
        with (system){
	        for (var n=0;n<array_length(_non_deads);n++){
	        	var plan = _non_deads[n];

	            if (planets>=1) and ((p_pdf[plan]>0) or (p_guardsmen[plan]>0) or (p_traitors[plan]>0) or (p_tau[plan]>0)){
	            	enemies_present=true;
	            }
	        }
	    }

        if (_has_warboss && !_has_stronghold){
            rando=roll_dice(1,100, "low");
            if (rando<30){
                add_feature(P_features.OrkStronghold);
            }
        } else {
            if (_has_stronghold){
                growth = 0.01;
                if (_has_warboss){
                    growth *= 2;
                }
                if (_stronghold.tier<planet_forces[eFACTION.Ork]){
                    _stronghold.tier += growth;
                }
            }
        }

        if (!enemies_present){
            rando=roll_dice(1,200, "low");
            if (_has_warboss){
                rando -= 20;
            }
            if (_has_stronghold){
                rando -= _stronghold.tier*5;
            }
            if (obj_controller.known[eFACTION.Ork]>0) then rando-=10;// Empire bonus, was 15 before
        
            // Check for industrial facilities
            var fleet_buildable = ((planet_type!="Dead" && planet_type!="Lava") || _has_warboss || _has_stronghold);
            if (fleet_buildable && planet_forces[eFACTION.Ork]>=4){// Used to not have Ice either

                if (instance_exists(obj_p_fleet)){
                    var ppp=instance_nearest(x,y,obj_p_fleet);
                    if (point_distance(x,y,ppp.x,ppp.y)<50) and (ppp.action=""){
                    	exit;
                    };
                }
                if (planet_type == "Forge"){
                    rando-=80;
                } else if (planet_type == "Hive" || planet_type == "Temperate"){
                	rando-=30;
                }else if (planet_type == "Agri"){
                	rando-=10;
                }
                var _ork_fleet = scr_orbiting_fleet(eFACTION.Ork, system); 
                if (_ork_fleet=="none"){
                	if (rando<=20){
                		new_ork_fleet(x,y);
                	}
                } else {

                	_build_ships = true;

                }              
            } 
        }
        if (_build_ships){
            var _pdata = self;
            with (_ork_fleet){
            // Increase ship number for this object?
                var rando=irandom(101);
                if (obj_controller.known[eFACTION.Ork]>0) then rando-=10;
                var _planet_type = _pdata.planet_type;
                if (_planet_type=="Forge"){
                    rando-=20;
                } else if (_planet_type=="Hive"){
                    rando-=10;
                }else if (_planet_type=="Shrine" || _planet_type=="Temperate"){
                    rando-=5;
                }
                if (rando<=15){// was 25
                    rando=choose(1,1,1,1,1,1,1,2,2,2);
                    var _big_stronghold = false
                    if (_has_stronghold){
                        if (_stronghold.tier>=2){
                            _big_stronghold = true;
                        }
                    }
                    if (_planet_type=="Forge" || _big_stronghold || _has_warboss){
                        if (!irandom(10)){
                            rando = 3;
                        }
                    }else if (_has_stronghold || _planet_type=="Hive"){
                        if (!irandom(30)){
                            rando = 3;
                        }
                    }
                    if (capital_number<=0){
                        rando = 3;
                    }
                    switch(rando){
                        case 3:
                            capital_number+=1;
                            break;
                        case 2:
                            frigate_number+=1;
                            break;
                        case 1:
                            escort_number+=1;
                            break;

                    }
                }
                var ii=0;
                ii+=capital_number;
                ii+=round((frigate_number/2));
                ii+=round((escort_number/4));
                if (ii<=1) then ii=1;
                image_index=ii; 
                //if big enough flee bugger off to new star
                if (image_index>=5){
                    instance_deactivate_object(_pdata.system);
                    with(obj_star){
                        if (is_dead_star()){
                            instance_deactivate_object(id);
                        } else {
                            if (owner == eFACTION.Ork || array_contains(p_owner, eFACTION.Ork)){
                                instance_deactivate_object(id);
                            }                   
                        }
                    }
                    var new_wagh_star = instance_nearest(x,y,obj_star);
                    if (instance_exists(new_wagh_star)){
                        action_x=new_wagh_star.x;
                        action_y=new_wagh_star.y;
                        action = "";
                        set_fleet_movement();
                    }
                
                }
                instance_activate_object(obj_star);
            }
        }
        if (_has_warboss){
            rando=roll_dice(1,100)+10;
            var _ork_fleet = scr_orbiting_fleet(eFACTION.Ork, system);
            if (_ork_fleet!="none" && rando <  _warboss.turns_static){
                _warboss.turns_static = 0;
                _ork_fleet.cargo_data.ork_warboss = _warboss;
                delete_feature(P_features.OrkWarboss);
                if (!_warboss.player_hidden){
                     scr_alert("red","ork",$"{obj_controller.faction_leader[0]} departs {name()} as his waaagh gains momentum",0,0);
                }
            }
        }
    
    }

    deamons = system.p_demons[planet];
    chaos_forces = system.p_chaos[planet];

    requests_help = system.p_halp[planet];

    // current planet heresy
    if (population == 0) {
        system.p_heresy[planet] = 0;
        system.p_heresy_secret[planet] = 0;
        for (var i = 0; i < array_length(system.p_influence[planet]); ++i) {
            system.p_influence[planet][i] = 0;
        }
    }


    corruption = system.p_heresy[planet];

    static alter_corruption = function(value){
    	alter_planet_corruption(value, planet, system);
    	corruption = system.p_heresy[planet];
    }
    
    is_heretic = system.p_hurssy[planet];

    heretic_timer = system.p_hurssy_time[planet];

    secret_corruption = system.p_heresy_secret[planet];

    population_influences = system.p_influence[planet];

    raided_this_turn = system.p_raided[planet];
    // 
    governor = system.p_governor[planet];

    problems = system.p_problem[planet];
    problems_data = system.p_problem_other_data[planet];
    problem_timers = system.p_timer[planet];

    static has_problem = function(problem){
    	has_problem_planet(planet, problem, system);
    }

    static find_problem = function(problem){
    	return find_problem_planet(planet, problem, system);
    }

    static add_problem = function(problem, timer, other_data={}){
    	return add_new_problem(planet, problem, timer,system, other_data);
    }

    static name = function(){
    	var _name="";

    	_name =  planet_numeral_name(planet, system);

    	return _name;
    }

    static xenos_and_heretics = function(){
    	var xh_force = 0;
    	for (var i=5;i<array_length(planet_forces); i++){
    		xh_force += planet_forces[i];
    	} 
    	return xh_force;
    }
    
    static has_feature = function(feature){
    	return planet_feature_bool(features, feature);
    }

    static add_feature = function(feature_type){
    	var new_feature =  new NewPlanetFeature(feature_type);
    	array_push(system.p_feature[planet], new_feature);
    	return new_feature;
    }

    static has_upgrade = function(feature){
    	return planet_feature_bool(upgrades, feature);
    }

    static get_features = function(request_feature){
    	var _array_positions = search_planet_features(features,request_feature);
    	var _select_features = [];
  		for (var i=0;i<array_length(_array_positions);i++){
  			array_push(_select_features, features[_array_positions[i]]);
  		}
  		return _select_features;
    }

    static delete_feature = function(feature){
    	delete_features(system.p_feature[planet], feature);
    }

    static bombard = scr_bomb_world;

    static get_local_apothecary_points = function() {
        var _system_point_use = obj_controller.specialist_point_handler.point_breakdown.systems;
        var _spare_apoth_points = 0;
        if (struct_exists(_system_point_use, system.name)) {
            var _point_data = _system_point_use[$ system.name][planet];
            _spare_apoth_points = _point_data.heal_points - _point_data.heal_points_use;
        }
        return _spare_apoth_points;
    }

    static marine_training = planet_training_sequence;

    static planet_training = function(local_screening_points) {
        var _training_happend = false;
        if (has_feature(P_features.Recruiting_World)) {
            if (obj_controller.gene_seed == 0 && obj_controller.recruiting > 0) {
                obj_controller.recruiting = 0;
                scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);
            } else if (obj_controller.recruiting > 0) {
                if (local_screening_points > 0) {
                    marine_training(local_screening_points);

                    _training_happend = true;
                } else {
                    scr_alert("red", "recruiting", $"Recruitment on {name()} halted due to insufficient apothecary rescources", 0, 0);
                }
            }
        }
        return _training_happend;
    };

    static recover_starship = function(techs){
    	try {
			var engineer_count = array_length(techs);
			if (has_feature(P_features.Starship) && engineer_count>0){
				//TODO allow total tech point usage here
		        var _starship = get_features(P_features.Starship)[0];

		        var _engineer_score_start = _starship.engineer_score;
		    	if (_starship.engineer_score<2000){
		        	for (var v=0;v<engineer_count;v++){
		        		_starship.engineer_score += (techs[v].technology/2);
		        	}
		        	scr_alert("green","owner",$"Ancient ship repairs {min((_starship.engineer_score/2000)*100, 100)}% complete",system.x,system.y);
		    	}

		        var _target_spend=10000;

		        var _maxr=floor(obj_controller.requisition/50);
		        var _requisition_spend=min(_maxr*50,array_length(techs)*50,_target_spend-_starship.funds_spent);
		        obj_controller.requisition-=_requisition_spend;
		        _starship.funds_spent+=_requisition_spend;
		    
		        if (_requisition_spend>0 && _starship.funds_spent<_target_spend){
		            scr_alert("green","owner",$"{_requisition_spend} Requision spent on Ancient Ship repairs in materials and outfitting (outfitting {(_starship.funds_spent/_target_spend)*100}%)",system.x,system.y);
		        }
		        if (_starship.funds_spent>=_target_spend && _starship.engineer_score>=2000){// u2=tar;
		        	//TODO refactor into general new ship logic
		            delete_feature(P_features.Starship);
		        
		            var locy=$"{name()}";
		        
		            var flit=instance_create(system.x,system.y,obj_p_fleet);
		      
		        	var _slaughter = new_player_ship("Gloriana", system.name, "Slaughtersong");
		        	add_ship_to_fleet(_slaughter, flit);
		            flit.oribiting = system.id;
		        
		            scr_popup($"Ancient Ship Restored",$"The ancient ship within the ruins of {locy} has been fully repaired.  It is determined to be a Gloriana Class vessel and is bristling with golden age weaponry and armour.  Your {string(obj_ini.role[100][16])}s are excited; the Slaughtersong is ready for it's maiden voyage, at your command.","","");                
		        }
		    }    	
	    }catch (_exception){
			handle_exception(_exception);
		}
	} 

	static guard_score_calc = function(){
		guard_score = 0;
        if (guardsmen < 500 && guardsmen>0) {
		    guard_score = 0.1;
		} else if (guardsmen >= 100000000) {
		    guard_score = 7;
		} else if (guardsmen >= 50000000) {
		    guard_score = 6;
		} else if (guardsmen >= 15000000) {
		    guard_score = 5;
		} else if (guardsmen >= 6000000) {
		    guard_score = 4;
		} else if (guardsmen >= 1000000) {
		    guard_score = 3;
		} else if (guardsmen >= 100000) {
		    guard_score = 2;
		} else if (guardsmen >= 2000) {
		    guard_score = 1;
		} else {
		    guard_score = 0.5;
		}

		return guard_score;
	}

	static continue_to_planet_battle = function(stop){

	    var _nids_real = planet_forces[eFACTION.Tyranids];
	    var _nids_score = _nids_real < 4 ? 0 : _nids_real;
	    var _nid_diff = _nids_score-_nids_real;

	    if (chaos_forces==6.1) and (_nids_real>0) then tyranids_score=_nids_real;

	    if (current_owner == eFACTION.Tau){
 			stop = (xenos_and_heretics() + _nid_diff + player_forces + planet_forces[eFACTION.Ecclesiarchy]) <= 0;
	    }
	   	
	   	if (stop){
	   		if (planet_forces[eFACTION.Ork]>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) then stop=0;
	   	}

	    var imperium_forces = ((guardsmen>0) or (pdf>0) or (planet_forces[eFACTION.Ecclesiarchy]>0));

	    if (stop){
	    	if (planet_forces[eFACTION.Necrons]>=5 || planet_forces[eFACTION.Tyranids]>=5 && imperium_forces) then stop=0;
	    }


	    //tau fight imperial
	    if (stop){
	    	if (current_owner = eFACTION.Tau){
				if ((guardsmen>0) or (planet_forces[eFACTION.Ecclesiarchy]>0)) and ((pdf>0) or (planet_forces[eFACTION.Tau]>0)) then stop=0;
	    	}
	    	
	    }
    
	    // Attack heretics whenever possible, even player controlled ones
	    if (stop){
	    	if (player_forces+pdf>0) and (guardsmen>0) and (obj_controller.faction_status[2]="War") then stop=0;
	    }
	    if (stop){
	    	if (player_forces+pdf>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) and (obj_controller.faction_status[5]="War") then stop=0;
	    }

	    return stop;
	}

	static pdf_will_support_player = function(){
		if (current_owner== eFACTION.Tau){
			return false;
		}
		if (has_feature(P_features.Gene_Stealer_Cult) && current_owner==eFACTION.Tyranids){
			return false;
		}

		if ((current_owner=1 || obj_controller.faction_status[2]!="War") && pdf){
			return true;
		}
		return false;
	}

	static guard_attack_matrix = function(){
		var guard_attack = "";
	    // if (p_eldar[planet]>0) and (p_owner[planet]!=6) then guard_attack="eldar";
	    //if (planet_forces[eFACTION.Tau] + planet_forces[eFACTION.Ork] + planet_forces[eFACTION.Heretics]+ planet_forces[eFACTION.Chaos])
	    if (planet_forces[eFACTION.Tau]>0) then guard_attack="tau";
	    if (planet_forces[eFACTION.Ork]>0) then guard_attack="ork";
	    if (planet_forces[eFACTION.Heretics]>0){
	    		    // Always goes after traitors first, unless
	    	guard_attack="traitors";
			if (planet_forces[eFACTION.Heretics]<=1 && planet_forces[eFACTION.Tau]>=4) and (current_owner!=8) then guard_attack="tau";	    	
	    }
	    if (planet_forces[eFACTION.Chaos]>0) then guard_attack="csm";
	    if (pdf>0) and (current_owner=eFACTION.Tau) then guard_attack="pdf";

	    if (current_owner = eFACTION.Player){
	    	if (pdf>0 && obj_controller.faction_status[2]=="War") then guard_attack="pdf";
	    }
	    if (planet_forces[eFACTION.Tyranids]<=1) and (planet_forces[eFACTION.Ork]>=4) then guard_attack="ork";
	    // if (p_tyranids[planet]>0) and (guard_attack="") then guard_attack="tyranids";
	    if (planet_forces[eFACTION.Tyranids]>=4){
	    	guard_attack="tyranids";
	    }else if (planet_forces[eFACTION.Tyranids]<4 && planet_forces[eFACTION.Tyranids]>0){
			 if (has_feature(P_features.Gene_Stealer_Cult)){
	 			var _hidden_cult = get_features(P_features.Gene_Stealer_Cult)[0].hiding;
	 			if (!_hidden_cult){
	 				guard_attack="tyranids";
	 			}
	 		}
	    }	

	    return guard_attack;		
	}


	static pdf_attack_matrix = function(){
		var _no_notable_traitors = planet_forces[eFACTION.Heretics]<=1;
		var _pdf_attack = "";
		if (planet_forces[eFACTION.Tyranids]>=4 && !has_feature(P_features.Gene_Stealer_Cult)){
			_pdf_attack = "tyranids";
		}

		if (_no_notable_traitors &&  _pdf_attack=="") {
			if ((planet_forces[eFACTION.Ork]>=4)){
				_pdf_attack="ork";
			} else if (planet_forces[eFACTION.Tau]>=4 && current_owner!=8){
				_pdf_attack="tau";
			}
		} 
		if (guardsmen && _pdf_attack==""){
			if (obj_controller.faction_status[2]=="War"){
				if (pdf_will_support_player()){
					_pdf_attack="guard";
				}
			} else if (current_owner == eFACTION.Tau){
				_pdf_attack="guard";
			}
		}

		if (_pdf_attack==""){
			if (planet_forces[eFACTION.Chaos]>0){
				_pdf_attack="csm";
			} else if (planet_forces[eFACTION.Heretics]>0){
				_pdf_attack="traitors";
			} else if ((planet_forces[eFACTION.Ork]>0)){
				_pdf_attack="ork";
			} else  if (planet_forces[eFACTION.Tau]>0) and (current_owner!=eFACTION.Tau){
				_pdf_attack="tau";
			}
		}
        // Always goes after traitors first, unless
        return _pdf_attack;				
	}

	static pdf_loss_reduction_calc = function(){
		pdf_loss_reduction = fortification_level*0.001;
		if (pdf_will_support_player()){
			pdf_loss_reduction+=garrison.viable_garrison*0.0005;
		}
		return pdf_loss_reduction;
	}

	static pdf_defence_loss_to_orks = function(){
		var active_garrison = pdf_will_support_player() && garrison.viable_garrison>0;
        if (planet_forces[eFACTION.Ork]>=4) and (pdf>=30000){
        	pdf=floor(pdf*(min(0.95, 0.55+pdf_loss_reduction)));
    	}
        else if (planet_forces[eFACTION.Ork]>=4 && pdf<30000 && pdf>=10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]>=3) and (pdf<10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]<3 && pdf>30000){
        	pdf=floor(pdf*(min(0.95, 0.7+pdf_loss_reduction)));
        }
        if (planet_forces[eFACTION.Ork]>=2) and (pdf<2000){ pdf=0;}
        if (planet_forces[eFACTION.Ork]>=1) and (pdf<200){ pdf=0;}

        system.p_pdf[planet] = pdf;
	}


	static planet_info_screen = function(){
		var improve=0
        var xx=15;
        var yy=25;
        var current_planet=obj_controller.selecting_planet;
        var nm=scr_roman(current_planet), temp1=0;
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14);
        
        var _xenos_and_heretics = xenos_and_heretics();
        if (current_owner<=5) and (!_xenos_and_heretics){
            if (planet_forces[eFACTION.Player]>0||system.present_fleet[1]>0){
                if (fortification_level<5) then improve=1;
            }
        }
        
        // Draw disposition here
        var yyy=0;

        var _succession = has_problem("succession");

        if ((player_disposition>=0 && current_owner<=5 && population>0)) and (_succession=0){
            var wack=0;
            draw_set_color(c_blue);
            draw_rectangle(xx+349,yy+175,xx+349+(min(100,player_disposition)*3.68),yy+192,0);
        }
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+175,xx+717,yy+192,1);
        draw_set_color(c_white);


        if (!_succession){
            if (player_disposition>=0) and (origional_owner<=5) and (current_owner<=5) and (population>0) then draw_text(xx+534,yy+176,"Disposition: "+string(min(100,player_disposition))+"/100");
            if (player_disposition>-30) and (player_disposition<0) and (current_owner<=5) and (population>0){
                draw_text(xx+534,yy+176,"Disposition: ???/100");
            }
            if ((player_disposition>=0) and (origional_owner<=5) and (current_owner>5)) or (population<=0){
                draw_text(xx+534,yy+176,"-------------");
            }

            if (player_disposition<=-3000) then draw_text(xx+534,yy+176,"Disposition: N/A");
        } else  if (_succession=1) then draw_text(xx+534,yy+176,"War of _Succession");
        draw_set_color(c_gray);
        // End draw disposition
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+193,xx+717,yy+210,0);
        var bar_width = 717-349;
        var bar_start_point = xx+349;
        var bar_percent_length = (bar_width/100);
        var current_bar_percent = 0;
        var hidden_cult = false;
        if (has_feature(P_features.Gene_Stealer_Cult)){
            hidden_cult = get_features(P_features.Gene_Stealer_Cult)[0].hiding;
        }          
        
        for (var i=1;i<13;i++){
            if (population_influences[i]>0){
                draw_set_color(global.star_name_colors[i]);
                if (hidden_cult){
                    draw_set_color(global.star_name_colors[eFACTION.Imperium]);
                }
                var current_start = bar_start_point+(current_bar_percent*bar_percent_length)
                draw_rectangle(current_start,yy+193,current_start+(bar_percent_length*population_influences[i]),yy+210,0);
                current_bar_percent+=population_influences[i];
            }
            draw_set_color(c_gray);
        }

        draw_set_color(c_white);   
        draw_text(xx+534,yy+194,"Population Influence");
        yy+=20;
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        if (!is_craftworld && !is_hulk) then draw_text(xx+480,yy+196,$"{system.name} {nm}  ({planet_type})");
        if (is_craftworld) then draw_text(xx+480,yy+196,string(system.name)+" (Craftworld)");
        // if (is_craftworld=0) and (is_hulk=0) then draw_text(xx+534,yy+214,string(planet_type)+" World");
        // if (is_craftworld=1) then draw_text(xx+594,yy+214,"Craftworld");
        if (is_hulk) then draw_text(xx+480,yy+196,"Space Hulk");
        
        // draw_sprite(spr_planet_splash,temp1,xx+349,yy+194);
        scr_image("ui/planet",scr_planet_image_numbers(planet_type),xx+349,yy+194,128,128);
        draw_rectangle(xx+349,yy+194,xx+477,yy+322,1);
        draw_set_font(fnt_40k_14);
        
        var pop_string = $"Population: {display_population()}";

        if (instance_exists(obj_star_select)){
            var _button_manager = obj_star_select.button_manager;
            _button_manager.update({
                label:pop_string,
                tooltip : "population data toggle with 'P'",
                keystroke : press_exclusive(ord("P")),
                x1 : xx+480,
                y1 : yy+217,
                w : 200,
                h : 22
            });
            _button_manager.update_loc();
            if (_button_manager.draw()){
                obj_star_select.population = !obj_star_select.population;
                if (obj_star_select.population){
                    obj_star_select.potential_doners = find_population_doners(system.id);
                }
            }
        }
        
        if (is_craftworld=0) and (is_hulk=0){
            var y7=240,temp3=string(scr_display_number(guardsmen));
            if (guardsmen>0){
                draw_text(xx+480,yy+y7,$"Imperial Guard: {temp3}");
                y7+=20;
            }
            var temp4=string(scr_display_number(pdf));
            if (current_owner!=8){
                draw_text(xx+480,yy+y7,$"Defense Force: {temp4}");
            }
            if (current_owner=8){
                draw_text(xx+480,yy+y7,$"Gue'Vesa Force:  {temp4}");
            }
        }
        
        var temp5="";
        
        
        if (!is_hulk){
            if (improve=1){
                draw_set_color(c_green);
                draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                draw_sprite(spr_requisition,0,xx+657,yy+283);
                
                
                var improve_cost=1500,yep=0,o=0;

                if (scr_has_adv("Siege Masters")){
                	improve_cost=1100;
                }
                
                draw_text_glow(xx+671, yy+281,improve_cost,16291875,0);
                
                if (scr_hit(xx+481,yy+282,xx+716,yy+300)){
                    draw_set_color(0);
                    draw_set_alpha(0.2);
                    draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                    if (scr_click_left()) and (obj_controller.requisition>=improve_cost){
                        obj_controller.requisition-=improve_cost;
                        alter_fortification(1);
                        
                        if (player_disposition>0) and (player_disposition<=100){
                        	add_disposition(9-fortification_level);
                        }
                    }
                    
                }
                draw_set_alpha(1);
                draw_set_color(0);
            }
            var forti_string = ["None", "Sparse","Light","Moderate","Heavy","Major","Extreme"];
            var planet_forti = $"Defenses: {forti_string[fortification_level]}";

            draw_text(xx+480,yy+280,planet_forti);
        }
        
        draw_set_color(c_gray);
        
        if (is_hulk=1){
            temp5="Integrity: "+string(floor(fortification_level*20))+"%";
            draw_text(xx+480,yy+280,temp5);
        }
        
        var temp6="???";
        var target_planet_heresy=corruption;

        if (target_planet_heresy < 0) {
            temp6 = "DEBUG: Heresy below 0!"
        } else if (target_planet_heresy <= 10) {
            temp6 = "None";
        } else if (target_planet_heresy <= 30) {
            temp6 = "Little";
        } else if (target_planet_heresy <= 50) {
            temp6 = "Major";
        } else if (target_planet_heresy <= 70) {
            temp6 = "Heavy";
        } else if (target_planet_heresy <= 96) {
            temp6 = "Extreme";
        } else if (target_planet_heresy <= 100) {
            temp6 = "Maximum";
        } else if (target_planet_heresy > 100) {
            temp6 = "DEBUG: Heresy above 100!";
        } else {
            temp6 = "DEBUG: Heresy somehow unknown value!"
        }

        draw_text(xx+480,yy+300,$"Corruption: {temp6}");
        
        
        draw_set_font(fnt_40k_14b);
        draw_text(xx+349,yy+326,"Planetary Presence");
        draw_text(xx+535,yy+326,"Planetary Features");
        draw_set_font(fnt_40k_14);
        
        
        var presence_text = "";
        var faction_names = ["Adeptas", "Orks", "Tau", "Tyranids", "Chaos", "Traitors", "Daemons", "Necrons"];
        var faction_ids = ["p_sisters", "p_orks", "p_tau", "p_tyranids", "p_traitors", "p_chaos", "p_demons", "p_necrons"];
        var blurbs = ["Minima", "Parvus", "Moderatus", "Significus", "Enormicus", "Extremis"];
        
        for (var t = 0; t < array_length(faction_names); t++) {
            var faction = faction_names[t];
            var faction_id = faction_ids[t];
            var level = system[$ faction_id][current_planet];
            var blurb = "";

            // Special condition for "Cultists" -> "Daemons"
            if (faction_id == "p_chaos" && level > 6) {
                faction = "Daemons";
            }

            if (level >= 1 && level <= 6) {
                blurb = blurbs[level - 1];
            } else if (level > 6) {
                blurb = blurbs[5];
            }

            if (faction != "" && level > 0) {
                presence_text += $"{faction}: {blurb} ({level})\n";
            }
        }

        draw_text(xx+349,yy+346,string_hash_to_newline(string(presence_text)));
        
        
        var to_show=0,temp9="";t=-1;

        var fit =  array_create(11, "");
        var planet_displays = [], i;
        var feat_count, _cur_feature;
        var feat_count = array_length(features);
        var upgrade_count = array_length(upgrades);
        var size = ["", "Small", "", "Large"];
        if ( feat_count > 0){
            for (i =0; i <  feat_count ;i++){
                cur_feature= features[i]
                if (cur_feature.planet_display != 0){
                    if (cur_feature.f_type == P_features.Gene_Stealer_Cult){
                        if (!cur_feature.hiding){
                            array_push(planet_displays, [cur_feature.planet_display, cur_feature]);
                        }
                    }else if (cur_feature.player_hidden == 1){
                        array_push(planet_displays, ["????", ""] );
                    }else{
                        array_push(planet_displays, [cur_feature.planet_display, cur_feature]);
                    }
                    if (cur_feature.f_type == P_features.Monastery){
                        if (cur_feature.forge>0){
                            var forge = cur_feature.forge_data;
                            var size_string= $"{size[forge.size]} Chapter Forge"
                            array_push(planet_displays, [size_string, forge]);
                        }
                    }                
                }
            }
        }
        if (upgrade_count>0){
            for (i =0; i <  upgrade_count ;i++){
                var _upgrade = upgrades[i];
                if (_upgrade.f_type == P_features.Secret_Base){
                    if (_upgrade.forge>0){
                        var forge = _upgrade.forge_data;
                        var size_string= $"{size[forge.size]} Chapter Forge"
                        array_push(planet_displays, [size_string, forge]);
                    }
                }
            }
        }

        for (i=0;i<array_length(problems);i++){
            if (problems[i]=="") then continue;
            problem_data = problems_data[i];
            if (struct_exists(problem_data, "stage")){
                if (problem_data.stage == "preliminary"){
                    var mission_string  = $"{problem_data.applicant} Audience";
                    problem_data.f_type = P_features.Mission;
                    problem_data.time = problem_timers[i];
                    problem_data.problem = problems[i];
                    problem_data.array_position = i;
                    array_push(planet_displays, [mission_string, problem_data]);
                }
            }
        }

        t=0;
        var button_size, y_move=0, button_colour;
        for (i=0; i< array_length(planet_displays); i++){
            button_colour = c_green;
            if (planet_displays[i][0] == "????") then button_colour = c_red;
            button_size = draw_unit_buttons([xx+535,yy+346+y_move], planet_displays[i][0],[1,1], button_colour,, fnt_40k_14b, 1);
            y_move += button_size[3]-button_size[1];
            if (point_and_click(button_size)){
                if (planet_displays[i][0] != "????"){
                    obj_star_select.feature = new FeatureSelected(planet_displays[i][1], system, current_planet);
                } else {
                    obj_star_select.feature = "";
                }
            }
        }
        if (obj_controller.selecting_planet>0){
            var current_planet=obj_controller.selecting_planet;
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            
            /*if (obj_controller.recruiting_worlds_bought>0) and (system.p_owner[obj_controller.selecting_planet]<=5) and (obj_controller.faction_status[system.p_owner[obj_controller.selecting_planet]]!="War"){
                if (string_count("Recr",system.p_feature[obj_controller.selecting_planet])=0){
                    button4="+Recruiting";
                }
            }*/
            
            /*if (origional_owner=1){
                if (mouse_x>=xx+363) and (mouse_y>=yy+194) and (mouse_x<xx+502) and (mouse_y<yy+204){
                    if (string_count("Monastery",features)>0){
                        var wid,hei,tex;draw_set_halign(fa_left);
                        tex=string(system.p_lasers[current_planet])+" Defense Laser, "+string(system.p_defenses[current_planet])+" Weapon Emplacements, "+string(system.p_silo[current_planet])+" Missile Silo";
                        hei=string_height_ext(tex,-1,200)+4;wid=string_width_ext(tex,-1,200)+4;
                        draw_set_color(c_black);
                        draw_rectangle(xx+363,yy+210,xx+363+wid,yy+210+hei,0);
                        draw_set_color(38144);
                        draw_rectangle(xx+363,yy+210,xx+363+wid,yy+210+hei,1);
                        draw_text_ext(xx+365,yy+212,tex,-1,200);
                    }
                }
            }*/
        }		
	}

	static suffer_navy_bombard = function(strength){
                
                
    	var kill = 0;
        // Eh heh heh
        if  (planet_forces[eFACTION.Tyranids]>0){
            strength = strength>2 ? 2 : 0;
            system.p_tyranids[planet]-=2;
        }
        else if  (planet_forces[eFACTION.Ork]>0){
            if (strength>2) then strength=2;if (strength<1) then strength=0;
            system.p_orks[planet]-=2;
        }
        else if  (current_owner=eFACTION.Tau) and (planet_forces[eFACTION.Tau]>0){
            strength = strength>2 ? 2 : 0;
            system.p_tau[planet]-=2;
        	
        	kill = large_population ? strength*0.15 : strength*15000000
        }
        else if  (current_owner=8) and (pdf>0){
            wob=strength*(irandom_range(49, 51) * 100000);
            system.p_pdf[planet]-=wob;
            if (pdf<0){
            	system.p_pdf[planet]=0;
            }
        	
        	kill = large_population ? strength*0.15 : strength*15000000
        }
        else if  (current_owner=10){

        	strength = strength>2 ? 2 : 0;
        
            if  (system.p_chaos[planet]>0){
            	system.p_chaos[planet]=max(0,system.p_traitors[planet]-1);
            } else if  (system.p_traitors[planet]>0){
            	system.p_traitors[planet]=max(0,system.p_traitors[planet]-2);
            }
        	kill = strength * population_small_conversion(0.15);
            if (system.p_heresy[planet]>0) then system.p_heresy[planet]=max(0,system.p_heresy[planet]-5);
        }
    	edit_population(kill*-1);
        if (system.p_pdf[planet]<0) then system.p_pdf[planet]=0;
    
        if (population+pdf<=0) and (current_owner=1) and (obj_controller.faction_status[eFACTION.Imperium]="War"){
            if (planet_feature_bool(system.p_feature[planet],P_features.Monastery)==0){
            	current_owner=2;
            	add_disposition(-50);
            }
        }		
	}

}
