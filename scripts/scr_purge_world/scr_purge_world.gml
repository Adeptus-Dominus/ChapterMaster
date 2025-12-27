function scr_purge_world(action_type, action_score) {

	var population_reduction_percentage,influence_reduction, max_kill, heres_before, heres_after, kill;
	var isquest=0,thequest="",questnum=0,pop_after=0,txt1="",txt2="",overkill=0;


	var _pop_before = population;
	var _no_chaos = (planet_forces[eFACTION.Heretics] + planet_forces[eFACTION.Chaos])==0
	if ((action_type==DropType.PurgeFire || action_type==DropType.PurgeSelective) && _no_chaos && obj_controller.turn>=obj_controller.chaos_turn){
	    if (has_feature(P_features.Warlord10) && obj_controller.known[10]=0 && obj_controller.faction_gender[10]=1){
	    	with(obj_drop_select){
		        var pop=instance_create(0,0,obj_popup);
		        pop.image="chaos_symbol";
		        pop.title="Concealed Heresy";
		        pop.text=$"Your astartes set out and begin to cleanse {planet_numeral_name(planet, star)} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";        
		        exit;   
		    }
		}
	    if (has_feature(P_features.Warlord10) && obj_controller.known[10]>=2 && obj_controller.faction_gender[10]=1){
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

	var heres_before = max(total_corruption(),population_influences[eFACTION.Tau],population_influences[eFACTION.Tyranids]);// Starting heresy

	var heres_target = "corruption";

	if (max(population_influences[eFACTION.Tau],population_influences[eFACTION.Tyranids])  > total_corruption()){
		if  (population_influences[eFACTION.Tau]>population_influences[eFACTION.Tyranids]){
			heres_target = "tau";
		} else{
			heres_target = "genestealers";
		}
		
	}


	// TODO - while I don't expect Surface to Orbit weapons retaliating against player's purge bombardment, it might still be worthwhile to consider possible situations

	if (action_type=DropType.PurgeBombard){// Bombardment
		var _ship = string_plural("ship",ships_selected);
	    txt1=choose($"Your cruiser and larger {_ship}", $"The heavens rumble and thunder as your {_ship}");
	    txt1+=choose(" position themselves over the target in close orbit, and unleash", " unload");
	    var _adjective = choose("tearing ground", "hammering", "battering", "thundering");
		txt1+= $" annihilation upon {name()}. Even from space the explosions can be seen, {_adjective} across the planet's surface.";
 	
 		max_kill = population_small_conversion(0.015) * max_kill;
    
	    // Minimum kills
	    overkill=max(_pop_before*0.1,((heres_before/200)*_pop_before));

    
	    kill=min(max_kill,overkill,_pop_before);// How many people ARE going to be killed
    
	    pop_after=max(_pop_before-kill,0);
	    population_reduction_percentage=0;
	    influence_reduction=0;
    
	    population_reduction_percentage=(pop_after/_pop_before)*100;// Relative % of people murderized

	    if (population_reduction_percentage>0){
	    	influence_reduction=min((population_reduction_percentage*2),action_score*2);// How much hurresy to get rid of
	    }
	    heres_after=heres_before-influence_reduction;

    
	    if (!population_large){
	    	pop_after=round(pop_after);   
	    } 
	    
 
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

	                scr_audience(eFACTION.Imperium, "bombard_angry", _disp_hit, "", 0, 0);
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
	    	scr_audience(eFACTION.Inquisition, "bombard_angry", _disp_hit, "", 0, 0);

	    }

    
	}


	if (action_type=DropType.PurgeFire){// Burn baby burn
	    var i=0;
	    if (has_problem("cleanse")){
        	isquest=1;
	        thequest="cleanse";
	        questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="cleanse" && action_score>=20){
	        	remove_planet_problem(planet,thequest,star);
            	
            	alter_disposition(eFACTION.Inquisition,obj_controller.demanding ? choose(0,0,1) :1);
            
	            txt1="Your marines scour the underhive of {name()}, spraying mutants down with promethium as they go.  It takes several days but a sizeable dent is put in their numbers.";        
	            scr_event_log("","Inquisition Mission Completed: The mutants of {name()} have been cleansed by promethium.");
	            add_disposition(choose(1,2,3));
	        }
	    }else if (isquest=0){ // TODO add more variation, with planets, features, marine equipment perhaps?
	        txt1=choose(
				$"Timing their visits right, Your forces scour {name()} burning down whatever the local heretic communities call their homes. Their screams were quickly extinguished by fire, turning whatever it was before, into ash.",
				$"Your forces scour {name()}, burning homes and towns that reek of heresy. The screams and wails of the damned carry through the air."
			);
     	
     		max_kill = population_large_conversion(12000) *action_score;
        
	        // Minimum kills
	         overkill=min(_pop_before*0.01,((heres_before/200)*_pop_before));
        
	        kill=min(max_kill,overkill,_pop_before);// How many people ARE going to be killed
        
	        if (!population_large){
	        	pop_after=max(_pop_before-kill,0);
	        }
	        if (large_population){
	        	pop_after=_pop_before;
	        }
        
	        population_reduction_percentage=0;
	        influence_reduction=0;
	        if (_pop_before>0) {
	         population_reduction_percentage=(pop_after/_pop_before)*100;// Relative % of people murderized
	     	}
	        if (population_reduction_percentage>0){
	        	influence_reduction=min((population_reduction_percentage*2),round(action_score/25));// How much hurresy to get rid of
	        }
	        heres_after=heres_before-influence_reduction;
	        if (_pop_before>0 && pop_after=0) {
	         heres_after=0;
	     	}

	        var nid_influence = population_influences[eFACTION.Tyranids];
            if (has_feature( P_features.Gene_Stealer_Cult)) {
                var cult = get_features(P_features.Gene_Stealer_Cult)[0];
                if (cult.hiding) {

                }
            } else {
                if (nid_influence > 25) {
                    txt1 += " Scores of mutant offspring from a genestealer infestation are burnt, while we have damaged their influence over this world, the mutants appear to lack the organisation of a true cult";
                    adjust_influence(eFACTION.Tyranids, -10, planet, star);
                } else if (nid_influence > 0) {
                    txt1 += " There are signs of a genestealer infestation but the cultists are too unorganized to do any real damage to their influence on this world";
                }
            }
	        if (!population_large){
	        	pop_after=round(pop_after);
	        }
	        
	        if (!population_large){
	        	txt1+="\n\nThe planet had a population of "+string(scr_display_number(floor(_pop_before)))+" and "+string(scr_display_number(floor(kill)))+" were purged over the duration of the cleansing.\n\nHeresy has fallen down to "+string(max(0,heres_after))+"%.";
	        }else {
	        	txt1+="\n\nThe planet had a population of "+string(_pop_before)+" billion and "+string(scr_display_number(action_score*12000))+" were purged over the duration of the cleansing.\n\nHeresy has fallen down to "+string(max(0,heres_after))+"%.";
	        }
	    }
	}


	if (action_type=DropType.PurgeSelective){// Blam!
	    var i=0;
	    if (has_problem_planet(planet, "purge", star)){
        	isquest=1;
        	thequest="purge";
        	questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="purge" && action_score>=10){
	        	remove_planet_problem(planet, "purge", star);
            
	            alter_disposition(eFACTION.Inquisition,obj_controller.demanding ? choose(0,0,1) :1);
            
	            txt1="Your marines drop fast and hard, blowing through guards and mercenaries with minimal resistance.  Before ten minutes have passed all your targets are executed.";        
	            scr_event_log("","Inquisition Mission Completed: The unruly Nobles of {name()} have been purged.");
	            add_disposition(choose(1,2,3));
	        }
	    }
	    else if (isquest=0){ // TODO add more variation, with planets, features, possibly marine equipment
	        txt1=choose(
				$"Your marines move across {star.name} {scr_roman(planet)}, searching for high profile targets. Once found, they are dragged outside from their lairs. Their execution would soon follow.",
				$"Your marines move across {star.name} {scr_roman(planet)}, rooting out sources of corruption. Heretics are dragged from their lairs and executed in the streets."
			);
    
	        if (!population_large) {
	         max_kill=action_score*30;// Population if normal
	     	}
	        if (large_population) {
	         max_kill=0;// Population if large
	     	}
        
	        _pop_before=population;
        
	        // Minimum kills
	        kill=min(action_score*30,_pop_before);// How many people ARE going to be killed
        
	        if (!population_large) {
	         pop_after=max(_pop_before-kill,0);
	     	}
	        influence_reduction=round(action_score/50);
	        heres_after=heres_before-influence_reduction;
	        if (_pop_before>0 && pop_after=0) {
	         heres_after=0;
	     	}
        
	        if (!population_large) {
	         pop_after=round(pop_after);    
	     	}
	        
	        if (!population_large) {
	          txt1+=$"\n\nThe planet had a population of "+string(scr_display_number(floor(_pop_before)))+" and "+string(scr_display_number(floor(kill)))+" die over the duration of the search.\n\nHeresy has fallen to "+string(max(0,heres_after))+"%.";
	     	}
	        if (large_population) {
	          txt1+=$"\n\nThe planet had a population of {_pop_before} billion and {action_score*30} die over the duration of the search.\n\nHeresy has fallen to "+string(max(0,heres_after))+"%.";
	     	}
	    }
	}



	if (action_type=DropType.PurgeAssassinate){
		assasinate_governor_setup();
	}

	if (action_type!=DropType.PurgeAssassinate){
	    if (isquest=0){// DO EET
	        txt2=txt1;
	        if (heres_target == "corruption"){
	        	alter_corruption(-influence_reduction);
	        }else if (heres_target == "tau"){
	        	alter_influence(eFACTION.Tau , -influence_reduction);
	        }else if (heres_target == "genestealers"){
				alter_influence(eFACTION.Tyranids , -influence_reduction);
	        }

	        if (action_type<DropType.PurgeSelective){
	        	set_population(pop_after);
	        }
	        if (action_type==DropType.PurgeSelective && !population_large){
	        	set_population(pop_after);
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
