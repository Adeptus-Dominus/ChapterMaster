
/// @mixin obj_ncombat
function necron_tomb_raid_post_battle_sequence(){
	if (!string_count("wake",battle_special)){
		if (defeat=1) {
		    obj_controller.combat=0;
		    obj_controller.cooldown=10;
		    obj_turn_end.alarm[1]=4;
		}

		else if (defeat=0){
		    battle_data.mission_stage+=1;
		    obj_controller.combat=0;
		    var pip=instance_create(0,0,obj_popup);
		    pip.pop_data = battle_data;

		    with (pip){
		    	necron_tomb_mission_start();
		    	necron_tomb_mission_sequence();
		    	number = pop_data.number;
		    }
		}
	} else {
        var pip=instance_create(0,0,obj_popup);
        with(pip){
            title="Necron Tomb Awakens";
            image="necron_army";
            if (obj_ncombat.defeat==0){
            	text="Your marines make a tactical retreat back to the surface, hounded by Necrons all the way.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
            } else {
            	text="Your marines are killed down to the last man.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
            }
        }
        
        instance_activate_object(obj_star);
        var _star_obj = star_by_name(battle_loc);
        if (star_by_name(_star_obj) != "none"){
	        with(_star_obj){
	            var planet = obj_ncombat.battle_id;
	            if (remove_planet_problem(planet,"necron")){
	                p_necrons[planet]=4;
	            }
	            if (awake_tomb_world(p_feature[planet])==0){
	            	awaken_tomb_world(p_feature[planet]);
	            }
	        }        	
        }

        pip.pop_data = battle_data;

        alter_disposition(eFACTION.Inquisition, -5);
        obj_controller.combat=0;

        with (pip){
        	number = pop_data.number;
        }
	}
}

/// @mixin obj_ncombat
function protect_raiders_battle_aftermath(){
     instance_activate_object(obj_star);
    // show_message(obj_turn_end.current_battle);
    // show_message(obj_turn_end.battle_world[obj_turn_end.current_battle]);
    // title / text / image / speshul
    var cur_star = battle_object;
    var planet = battle_id;
    var _planet = new PlanetData(planet,cur_star);
    var _planet_string = _planet.name();
    _planet.remove_problem("protect_raiders");
    if (!defeat){
            
        _planet.add_disposition(15);
        var _special_reward = 0;
        var tixt=$"The Raiding forces on {_planet_string} have been removed.  The citizens and craftsman may sleep more soundly. (planet disp +15)"
    
        scr_popup("Planet Protected",tixt,"protect_raiders","");
        scr_event_log("",$"Governor Request completed: Raiding forces on {_planet_string} have been eliminated.", cur_star.name);               
    } else {
        _planet.add_disposition(-15);
        var tixt=$"The Raiding forces on {_planet_string} dispatched with your forces and will continue with their bloody practices.  The citizens remain unsafe and the governor is unimpressed. (planet disp -15)";
        scr_popup("Planet Protected",tixt,"protect_raiders","");
    
        scr_event_log("",$"Governor Request failed: Raiding forces on {_planet_string} continue to harrass population.", cur_star.name);
    } 
    instance_deactivate_object(obj_star);  
}


/// @mixin obj_ncombat
function hunt_fallen_battle_aftermath(){
	if (!defeat){
	    var fallen=0;
	    with (obj_turn_end){
	        remove_planet_problem(battle_world[current_battle], "fallen", battle_object[current_battle])
	        var tixt="The Fallen on "+ battle_object[current_battle].name;
	        tixt+=scr_roman(battle_world[current_battle]);
	        scr_event_log("",$"Mission Succesful: {tixt} have been captured or purged.");
	        tixt+=$" have been captured or purged.  They shall be brought to the Chapter {obj_ini.role[100][14]}s posthaste, in order to account for their sins.  ";
	        var _tex_options = [
	            "Suffering is the beginning to penance.",
	            "Their screams shall be the harbringer of their contrition.",
	            "The shame they inflicted upon us shall be written in their flesh."
	        ]
	        tixt += _tex_options[choose(0,0,1,2)];
	        scr_popup("Hunt the Fallen Completed",tixt,"fallen","");        
	    }
	}
}



function spacce_hulk_explore_battle_aftermath(){
	if (defeat=0 hulk_treasure>0){
	    var shi=0,loc="";

	    var shiyp=instance_nearest(battle_object.x,battle_object.y,obj_p_fleet);
	    if (shiyp.x == battle_object.x && shiyp.y ==battle_object.y){
	        shi = fleet_full_ship_array(shiyp)[0];
	        loc = obj_ini.ship[shi];
	    }
	    
	    if (hulk_treasure=1){// Requisition
	        var _reqi=irandom_range(30,60)*10;
	        obj_controller.requisition+=_reqi;
	        
	        var pop=instance_create(0,0,obj_popup);
	        pop.image="space_hulk_done";
	        pop.title="Space Hulk: Resources";
	        pop.text=$"Your battle brothers have located several luxury goods and coginators within the Space Hulk.  They are salvaged and returned to the ship, granting {_reqi} Requisition.";
	    }else if (hulk_treasure=2){// Artifact
	        //TODO this will eeroniously put artifacts in the wrong place but will resolve crashes
	        var last_artifact = scr_add_artifact("random","random",4,loc,shi+500);
	        var i=0;

	        var pop=instance_create(0,0,obj_popup);
	        pop.image="space_hulk_done";
	        pop.title="Space Hulk: Artifact";
	        pop.text=$"An Artifact has been retrieved from the Space Hulk and stowed upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
	        scr_event_log("","Artifact recovered from the Space Hulk.");
	    }else if (hulk_treasure=3){// STC
	        scr_add_stc_fragment();// STC here
	        var pop;pop=instance_create(0,0,obj_popup);
	        pop.image="space_hulk_done";
	        pop.title="Space Hulk: STC Fragment";
	        pop.text="An STC Fragment has been retrieved from the Space Hulk and safely stowed away.  It is ready to be decrypted or gifted at your convenience.";
	        scr_event_log("","STC Fragment recovered from the Space Hulk.");
	    }else if (hulk_treasure=4){// Termie Armour
	        var termi=choose(2,2,2,3);
	        scr_add_item("Terminator Armour",termi);
	        var pop;pop=instance_create(0,0,obj_popup);
	        pop.image="space_hulk_done";
	        pop.title="Space Hulk: Terminator Armour";
	        pop.text="The fallen heretics wore several suits of Terminator Armour- a handful of them were found to be cleansible and worthy of use.  "+string(termi)+" Terminator Armour has been added to the Armamentarium.";
	    }
	}
}