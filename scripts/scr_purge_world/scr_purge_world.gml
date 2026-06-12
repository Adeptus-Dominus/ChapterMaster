
function PlayerPurge(action_type, action_score, planet_data){
	pop_before = 0;
	max_kill = 0;
	pop_after = 0;
	overkill = 0;
	self.planet_data = planet_data;
	self.action_type = action_type;
	self.action_score = action_score;
	population_reduction_percentage = 0;

	heres_after = 0;
	heres_before = 0;


	static calculate_max_kills(){
		switch (action_type){
			case eDROP_TYPE.PURGEBOMBARD:
				max_kill = 15000000 * action_score;
				if (pop_before > 0){
					overkill = max(pop_before * 0.1, ((heres_before / 200) * pop_before));
				}
				break;
			case eDROP_TYPE.PURGEFIRE:
				max_kill = 12000 * action_score;
				if (pop_before > 0){
					overkill = max(pop_before * 0.1, ((heres_before / 200) * pop_before));
				}
				break;
			case eDROP_TYPE.PURGESELECTIVE:
				kill=action_score * 30;
				break;
		}	
		kill=min(kill, pop_before);

		if (overkill > 0){
			kill=min(kill, overkill);
		}
	}

	calculate_influence_reduction = function(){
		switch (action_type){
			case eDROP_TYPE.PURGEBOMBARD:
			    if (population_reduction_percentage>0){
			    	influence_reduction=min((population_reduction_percentage*2), action_score*2);// How much hurresy to get rid of
			    }
			    break;
			case eDROP_TYPE.PURGEFIRE:
				influence_reduction = min((population_reduction_percentage * 2), round(action_score / 25));
				break;
			case eDROP_TYPE.PURGESELECTIVE:
				influence_reduction = round(action_score / 50);
				break;			    
		}
		influence_reduction = min(influence_reduction, heres_before);
	}

	static calculate_deaths = function(){


		calculate_max_kills();

		pop_after = (pop_before - kill);
    
	    population_reduction_percentage = (pop_after/pop_before)*100;// Relative % of people murderized


	    calculate_influence_reduction();

	    heres_after = heres_before - influence_reduction;
	}

	static population_death_string = function(){
        var _prev_pop_string = "\n\nThe planet had a population of "
        if (!planet_data.large_population){
        	_prev_pop_string += $"{scr_display_number(floor(pop_before))} and {string(scr_display_number(floor(kill)))}";
        } else {
        	_prev_pop_string+="{pop_before} billion and {scr_display_number(action_score*12000)}";
        }

        var _prev_pop_string += " were purged";
	}
}

function scr_purge_world(action_type, action_score) {

	var _purge = new PlayerPurge(action_type, action_score, self);
	var isquest=0,thequest="",questnum=0,txt1="",txt2="";


	_purge.pop_before = population_as_small();

	_purge.heres_before = max(total_corruption(),population_influences[eFACTION.TAU],population_influences[eFACTION.TYRANIDS]);// Starting heresy

	_purge.calculate_deaths();


	var _heres_target = "corruption";

	if (max(population_influences[eFACTION.TAU],population_influences[eFACTION.TYRANIDS])  > total_corruption()){
		if  (population_influences[eFACTION.TAU] > population_influences[eFACTION.TYRANIDS]){
			_heres_target = "tau";
		} else{
			_heres_target = "genestealers";
		}
		
	}

	purge.heres_target = _heres_target;


	var _no_chaos = (planet_forces[eFACTION.HERETICS] + planet_forces[eFACTION.CHAOS]) == 0;
	if ((action_type==eDROP_TYPE.PURGEFIRE || action_type==eDROP_TYPE.PURGESELECTIVE) && _no_chaos && obj_controller.turn>=obj_controller.chaos_turn){
	    if (has_feature(P_features.WARLORD10) && obj_controller.known[10]=0 && obj_controller.faction_gender[10]=1){
	    	with(obj_drop_select){
		        var pop=instance_create(0,0,obj_popup);
		        pop.image="chaos_symbol";
		        pop.title="Concealed Heresy";
		        pop.text=$"Your astartes set out and begin to cleanse {name()} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";        
		        exit;   
		    }
		}
	    if (has_feature(P_features.WARLORD10) && obj_controller.known[10]>=2 && obj_controller.faction_gender[10]=1){
	    	with(obj_drop_select){

				attacking=10;
				obj_controller.cooldown=30;
				combating=1;// Start battle here

				instance_deactivate_all(true);
				instance_activate_object(obj_controller);
				instance_activate_object(obj_ini);
				instance_activate_object(obj_drop_select);

				instance_create(0,0,obj_ncombat);
				obj_ncombat.battle_object=p_target;
				obj_ncombat.battle_loc=p_target.name;
				obj_ncombat.battle_id=obj_controller.selecting_planet;
				obj_ncombat.dropping=0;
				obj_ncombat.attacking=10;
				obj_ncombat.enemy=10;
				obj_ncombat.formation_set=1;

				obj_ncombat.leader=1;
				obj_ncombat.threat=5;
				obj_ncombat.battle_special="WL10_later";
	            scr_battle_allies();
	            setup_battle_formations();
	            roster.add_to_battle();
        	}
	    }
	}


	// TODO - while I don't expect Surface to Orbit weapons retaliating against player's purge bombardment, it might still be worthwhile to consider possible situations

	if (action_type=eDROP_TYPE.PURGEBOMBARD){// Bombardment
		var _ship = string_plural("ship",ships_selected);
	    txt1=choose($"Your cruiser and larger {_ship}", $"The heavens rumble and thunder as your {_ship}");
	    txt1+=choose(" position themselves over the target in close orbit, and unleash", " unload");
	    var _adjective = choose("tearing ground", "hammering", "battering", "thundering");
		txt1+= $" annihilation upon {name()}. Even from space the explosions can be seen, {_adjective} across the planet's surface.";
	    
		var _displayed_population = display_population();
		var _displayed_killed = large_population ? $"{kill} billion" : scr_display_number(floor(kill));
	    txt1 += $"\n\nThe world had {_displayed_population} Imperium subjects. {_displayed_killed} were purged over the duration of the bombardment.\n\nHeresy has fallen down to {max(0, heres_after)}%.";
    
	    if (pop_after<=0){
	        if (current_owner=2 && obj_controller.faction_status[2]!="War"){
	            if (planet_type="Temperate" || planet_type="Hive" || planet_type="Desert"){
	            	var _disp_hit = -10;
		            if (planet_type="Temperate"){
		            	_disp_hit = -5;
		            }
		            if (planet_type="Desert"){
		            	_disp_hit = -3;
		            }         	

	                scr_audience(eFACTION.IMPERIUM, "bombard_angry", _disp_hit, "", 0, 0);
	            }
	        }
	    }
	    if (current_owner=3 && obj_controller.faction_status[3]!="War"){

	    	if (planet_type="Forge"){
	    		_disp_hit =-15;
	    	}
	        if (planet_type="Ice"){
	        	_disp_hit =-7;
	        }
	    	scr_audience(eFACTION.INQUISITION, "bombard_angry", _disp_hit, "", 0, 0);

	    }

    
	}


	if (action_type=eDROP_TYPE.PURGEFIRE){// Burn baby burn
	    var i=0;
	    if (has_problem("cleanse")){
        	isquest=1;
	        thequest="cleanse";
	        questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="cleanse" && action_score>=20){
	        	remove_planet_problem(planet,thequest,star);
            	
            	alter_disposition(eFACTION.INQUISITION,obj_controller.demanding ? choose(0,0,1) :1);
            
	            txt1="Your marines scour the underhive of {name()}, spraying mutants down with promethium as they go.  It takes several days but a sizeable dent is put in their numbers.";        
	            scr_event_log("","Inquisition Mission Completed: The mutants of {name()} have been cleansed by promethium.");
	            add_disposition(choose(1,2,3));
	        }
	    }else if (isquest=0){ // TODO add more variation, with planets, features, marine equipment perhaps?
	        txt1=choose(
				$"Timing their visits right, Your forces scour {name()} burning down whatever the local heretic communities call their homes. Their screams were quickly extinguished by fire, turning whatever it was before, into ash.",
				$"Your forces scour {name()}, burning homes and towns that reek of heresy. The screams and wails of the damned carry through the air."
			);
     	

	        var nid_influence = population_influences[eFACTION.TYRANIDS];
            if (has_feature( P_features.GENE_STEALER_CULT)) {
                var cult = get_features(P_features.GENE_STEALER_CULT)[0];
                if (cult.hiding) {

                }
            } else {
                if (nid_influence > 25) {
                    txt1 += " Scores of mutant offspring from a genestealer infestation are burnt, while we have damaged their influence over this world, the mutants appear to lack the organisation of a true cult";
                    adjust_influence(eFACTION.TYRANIDS, -10, planet, star);
                } else if (nid_influence > 0) {
                    txt1 += " There are signs of a genestealer infestation but the cultists are too unorganized to do any real damage to their influence on this world";
                }
            }

	        var _prev_pop_string = "\n\nThe planet had a population of "
	        if (!large_population){
	        	_prev_pop_string += $"{scr_display_number(floor(_purge.pop_before))} and {string(scr_display_number(floor(kill)))}";
	        }else {
	        	_prev_pop_string+="{_purge.pop_before} billion and {scr_display_number(action_score*12000)}";
	        }

	        _prev_pop_string += $" were purged over the duration of the cleansing.\n\nHeresy has fallen down to {string(max(0,heres_after))}%.";
	    }
	}


	if (action_type=eDROP_TYPE.PURGESELECTIVE){// Blam!
	    var i=0;
	    if (has_problem_planet(planet, "purge", star)){
        	isquest=1;
        	thequest="purge";
        	questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="purge" && action_score>=10){
	        	remove_planet_problem(planet, "purge", star);
            
	            alter_disposition(eFACTION.INQUISITION,obj_controller.demanding ? choose(0,0,1) :1);
            
	            txt1="Your marines drop fast and hard, blowing through guards and mercenaries with minimal resistance.  Before ten minutes have passed all your targets are executed.";        
	            scr_event_log("","Inquisition Mission Completed: The unruly Nobles of {name()} have been purged.");
	            add_disposition(choose(1,2,3));
	        }
	    }
	    else if (isquest=0){ // TODO add more variation, with planets, features, possibly marine equipment
	        txt1=choose(
				$"Your marines move across {name()}, searching for high profile targets. Once found, they are dragged outside from their lairs. Their execution would soon follow.",
				$"Your marines move across {name()}, rooting out sources of corruption. Heretics are dragged from their lairs and executed in the streets."
			);
	        
	        if (!large_population) {
	          txt1+=$"\n\nThe planet had a population of "+string(scr_display_number(floor(_purge.pop_before)))+" and "+string(scr_display_number(floor(kill)))+" die over the duration of the search.\n\nHeresy has fallen to "+string(max(0,heres_after))+"%.";
	     	}
	        if (large_population) {
	          txt1+=$"\n\nThe planet had a population of {_purge.pop_before} billion and {action_score*30} die over the duration of the search.\n\nHeresy has fallen to "+string(max(0,heres_after))+"%.";
	     	}
	    }
	}



	if (action_type=eDROP_TYPE.PURGEASSASSINATE){
		assasinate_governor_setup();
	}

	if (action_type!=eDROP_TYPE.PURGEASSASSINATE){
	    if (isquest=0){// DO EET
	        txt2=txt1;
	        if (_purge.heres_target == "corruption"){
	        	alter_corruption(-_purge.influence_reduction);
	        }else if (_purge.heres_target == "tau"){
	        	alter_influence(eFACTION.TAU , -_purge.influence_reduction);
	        }else if (_purge.heres_target == "genestealers"){
				alter_influence(eFACTION.TYRANIDS , -_purge.influence_reduction);
	        }

	        if (action_type<eDROP_TYPE.PURGESELECTIVE){
	        	set_population(_purge.pop_after);
	        }
	        if (action_type==eDROP_TYPE.PURGESELECTIVE && !large_population){
	        	set_population(_purge.pop_after);
	        }
        
	        var pip=instance_create(0,0,obj_popup);
	        pip.title="Purge Results";
	        pip.text=txt2;
	    }
	    if (isquest){// DO EET
	        var pip=instance_create(0,0,obj_popup);
	        scr_popup("Inquisition Mission Completed",txt1,"inquisition")
	        // scr_event_log("","Inquisition Mission Completed: The unruly nobles of {name()} have been silenced.");
	    }
	}


	if instance_exists(obj_drop_select){
		if (instance_exists(sh_target)){
			sh_target.acted=5;
		}
		with(obj_drop_select){
			instance_destroy();
		}
		instance_destroy();
	}


}

