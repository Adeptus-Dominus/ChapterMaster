/*
    Mission flow: 
    scr_random_event -> rolls rng for inquis mission
    scr_inquisition_mission -> rolls rng and tests suitable planets for which mission
    mission_inquisition_<mission_name> -> logic and mechanics for spawning the mission and triggering the popup
    scr_popup -> displays the panel with mission details and Accept/Refuse buttons
    obj_popup.Step0 -> find `mission_is_go` section and add necessary event logic for when the player accepts
    scr_mission_functions > mission_name_key -> need to update this so that missions display in the mission log


    Helpers: 
    scr_mission_eta -> given the xy of a star where the mission is, calculate how long you should have to complete the mission
            Todo? maybe add a disposition influence here so that angy inquisitor gives you less spare time and vice versa
    scr_star_has_planet_with_feature -> given the id of a star and a `P_features` enum value, check if any planet on that star has the desired  feature
    star_has_planet_with_forces -> given the id of a star, and a faction, returns whether or not there are forces present there and in sufficient number
*/


/// @param {Enum.EVENT} event 
/// @param {Enum.INQUISITION_MISSION} forced_mission optional
function scr_inquisition_mission(event, forced_mission = -1){
    
    log_message($"RE: Inquisition Mission, event {event}, forced_mission {forced_mission}");
	if(obj_controller.known[eFACTION.Inquisition] == 0 || obj_controller.faction_status[eFACTION.Inquisition] == "War"){
        log_message("Player is either hasn't met or is at war with Inquisition, not proceeding with inquisition mission");
        return;
    }
    if(event == EVENT.inquisition_planet){
        mission_investigate_planet();
    } else if(event == EVENT.inquisition_mission){
    
		var inquisition_missions =
		[
		INQUISITION_MISSION.purge,
		INQUISITION_MISSION.inquisitor,
		INQUISITION_MISSION.spyrer,
		INQUISITION_MISSION.artifact
		];
		
		var found_sleeping_necrons = false;
        var found_tyranid_org = false;
        var found_demon_world = false;
        
        var necron_tomb_worlds = [];
        var tyranid_org_worlds = [];
        var demon_worlds = [];

        var all_stars = scr_get_stars();
        for(var s = 0, _len =  array_length(all_stars); s <_len; s++){
            var star = all_stars[s];

            if(scr_star_has_planet_with_feature(star, P_features.Necron_Tomb) && !awake_necron_Star(star.id)){
                array_push(necron_tomb_worlds, star);
                found_sleeping_necrons = true;
            }

            if(star_has_planet_with_forces(star, "Demons", 1)){
                // array_push(demon_worlds, star); // turning this off til i have a way to finish the mission
                found_demon_world = true;
            }

            if(star_has_planet_with_forces(star, eFACTION.Tyranids, 4)){
                array_push(tyranid_org_worlds, star)
                found_tyranid_org = true;
            }
        }

        if(found_sleeping_necrons){
            array_push(inquisition_missions, INQUISITION_MISSION.tomb_world);
            log_message($"Was able to find a star with dormant necron tomb for inquisition mission");
        } else {
            log_message($"Couldn't find any planets with a dormant necron tomb for inquisition mission")
        }
        if(found_tyranid_org){
            log_message($"Was able to find a star with lvl 4 tyranids for inquisition mission");
            array_push(inquisition_missions, INQUISITION_MISSION.tyranid_organism);
        } else {
            log_message($"Couldn't find any planets with lvl 4 tyranids for inquisition mission")
        }
        if(found_demon_world){
            array_push(inquisition_missions, INQUISITION_MISSION.demon_world);
            log_message($"Was able to find a star with demons on it for inquisition mission");
        } else {
            log_message($"Couldn't find any planets with demons for inquisition mission")
        }
		
		//if (string_count("Tau",obj_controller.useful_info)=0){
		//	var found_tau = false;
		//	with(obj_star){
		//		if(found_tau){
		//			break;
		//		}
		//		for(var i = 1; i <= planets; i++)
		//		{
		//			if (p_tau[i]>4) {
		//				array_push(inquisition_missions, INQUISITION_MISSION.ethereal);
		//				found_tau = true
		//				break;
		//			}
		//		}
		//	}
		//}
		
		var chosen_mission = choose_array(inquisition_missions);
        if(forced_mission != -1){
            chosen_mission = forced_mission;
        }
        switch (chosen_mission){
            case INQUISITION_MISSION.purge: mission_inquistion_purge(); break;
            case INQUISITION_MISSION.inquisitor: mission_inquistion_hunt_inquisitor(); break;
            case INQUISITION_MISSION.spyrer: mission_inquistion_spyrer(); break;
            case INQUISITION_MISSION.artifact: mission_inquisition_artifact(); break;
            case INQUISITION_MISSION.tomb_world: mission_inquisition_tomb_world(necron_tomb_worlds); break;
            case INQUISITION_MISSION.tyranid_organism: mission_inquisition_tyranid_organism(tyranid_org_worlds); break;
            case INQUISITION_MISSION.ethereal: mission_inquisition_ethereal(); break;
            case INQUISITION_MISSION.demon_world: mission_inquisition_demon_world(demon_worlds); break;
        }
    
   
    
    }
}

function mission_inquisition_demon_world(demon_worlds){
    var star = choose_array(demon_worlds);
    var planet = -1;
    for(var i = 1; i <= star.planets; i++){
        if(star.p_demons[i] > 1){
            planet = i;
            break;
        }
    }
    var eta = scr_mission_eta(star.x, star.y, 25);
    var text=$"The Inquisitor is trusting you with a special mission.  The planet {string(star.name)} {scr_roman(planet)}";
    text+=$" has been uncovered as a Demon World. The taint of chaos must be eradicated from this system.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"demon_world|{string(star.name)}|{string(planet)}|{string(eta+1)}|");
}

function mission_inquisition_ethereal(){
    log_message("RE: Ethereal Capture");
    var stars = scr_get_stars();
    var valid_stars = array_filter_ext(stars, function(star, index) {
        for(var i = 1; i <= star.planets; i++){
            if(star.p_owner[i]==eFACTION.Tau && star.p_tau[i] >= 4) {
                return true;
            }
        }
        return false;
    });
    if(valid_stars == 0){
        exit;
    }
    var star = stars[irandom(valid_stars-1)];
    
    var planet = -1;
    for(var i = 1; i <= star.planets; i++){
        if(star.p_owner[i]==eFACTION.Tau && star.p_tau[i] >= 4){
            planet = i;
            break;
        }
    }
    var eta = scr_mission_eta(star.x,star.y,1);
    eta = min(max(eta,12),50);
    var text = $"An Inquisitor is trusting you with a special mission.";
    text +=$"They require that you capture a Tau Ethereal from the planet {string(star.name)} {scr_roman(planet)} for research purposes. You have {string(eta)} months to locate and capture one. Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"ethereal|{string(star.name)}|{string(planet)}|{string(eta+1)}|");

}

function mission_inquisition_tyranid_organism(worlds){
    log_message("RE: Gaunt Capture");
    var star = choose_array(worlds);
    var planet = -1;
    for(var i = 1; i <= star.planets; i++){
        if(star.p_tyranids[i] > 4){
            planet = i;
            break;
        }
    }

    var eta = scr_mission_eta(star.x, star.y, 1);
    var eta = min(max(eta,6),50);

    var text=$"An Inquisitor is trusting you with a special mission.  The planet {string(star.name)} {scr_roman(planet)}";
    text+=" is ripe with Tyranid organisms.  They require that you capture one of the Gaunt species for research purposes.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"tyranid_org|{string(star.name)}|{string(planet)}|{string(eta+1)}|");

}

function mission_inquisition_tomb_world(tomb_worlds){
    log_message("RE: Necron Tomb Bombing");
    var star = choose_array(tomb_worlds)
    var planet = scr_get_planet_with_feature(star, P_features.Necron_Tomb);
    var eta = scr_mission_eta(star.x, star.y,1)
    
    var text=$"The Inquisition is trusting you with a special mission.  They have reason to suspect the Necron Tomb on planet {string(star.name)} {scr_roman(planet)}";
    text+=$" may become active.  You are to send a small group of marines to plant a bomb deep inside, within {string(eta)} months.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"necron|{string(star.name)}|{string(planet)}|{string((eta+1))}|");

}

function mission_inquisition_artifact(){
    var text;
    log_message("RE: Artifact Hold");
    text="The Inquisition is trusting you with a special mission.  A local Inquisitor has a powerful artifact.  You are to keep it safe, and NOT use it, until the artifact may be safely retrieved.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"artifact|bop|0|{string(irandom_range(6,26))}|");
}

function mission_inquistion_hunt_inquisitor(){
    log_message("RE: Inquisitor Hunt");

    var stars = scr_get_stars();
    var valid_stars = array_filter_ext(stars,
    function(star,index){
        var p_fleet = instance_nearest(star.x,star.y,obj_p_fleet);
        if(instance_exists(p_fleet)){
            var distance = point_distance(star.x,star.y,p_fleet.x,p_fleet.y);
            if(100 <= distance & distance <= 300){
                return true;
            }
        }
    return false;
    });
    
    
    if(valid_stars == 0) {
        log_error("RE: Inquisitor Hunt,couldn't find a star");
        exit;
    }
        
    var star = stars[irandom(valid_stars-1)];
    
    var gender = choose(0,1);
    var name=global.name_generator.generate_imperial_name(gender);
    var planet = irandom_range(1, star.planets);
    
    var eta = scr_mission_eta(star.x,star.y,1);
    eta=max(eta, 8);
    var text=$"The Inquisition is trusting you with a special mission.  A radical inquisitor named {string(name)} will be visiting the {string(star.name)} system in {string(eta)} month's time.  They are highly suspect of heresy, and as such, are to be put down.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"inquisitor|{string(star.name)}|{string(planet)}|{string(real(eta))}|");
}

function mission_inquistion_spyrer(){
    log_message("RE: Spyrer");
    var stars = scr_get_stars();
    var valid_stars = array_filter_ext(stars, 
        function(star,index){
            return scr_star_has_planet_with_type(star,"Hive");
    });
    
    if(valid_stars == 0){
        log_error("RE: Spyrer, couldn't find star");
        exit;
    }
    var star = stars[irandom(valid_stars-1)];
    var planet = scr_get_planet_with_type(star,"Hive");
    var eta = scr_mission_eta(star.x,star.y,1);
    eta = min(max(eta, 6), 50);
    
    
    var text=$"The Inquisition is trusting you with a special mission.  An experienced Spyrer on hive world {string(star.name)} {scr_roman(planet)}";
    text += $" has began to hunt indiscriminately, and proven impossible to take down by conventional means.  If they are not put down within {string(eta)} month's time panic is likely.  Can your chapter handle this mission?";
    var mission_params = $"spyrer|{string(star.name)}|{string(planet)}|{string(eta+1)}|";
    log_message($"Starting spyrer mission with params {mission_params}")
    scr_popup("Inquisition Mission",text,"inquisition",mission_params);
}

function mission_inquistion_purge(){
    log_message("RE: Purge");
    var mission_flavour = choose(1,1,1,2,2,3);
    
    var stars = scr_get_stars();
    var valid_stars = 0;
    
    if(mission_flavour == 3) {
        valid_stars = array_filter_ext(stars, function(star,index){
            var hive_idx = scr_get_planet_with_type(star,"Hive")
            return scr_is_planet_owned_by_allies(star, hive_idx);
        });
    } else {
        valid_stars = array_filter_ext(stars,
            function(star,index){
                var hive_idx = scr_get_planet_with_type(star,"Hive")
                var desert_idx =  scr_get_planet_with_type(star,"Desert")
                var temperate_idx = scr_get_planet_with_type(star,"Temperate")
                var allied_hive = scr_is_planet_owned_by_allies(star, hive_idx)
                var allied_desert = scr_is_planet_owned_by_allies(star, desert_idx)
                var allied_temperate =scr_is_planet_owned_by_allies(star, temperate_idx)

                return allied_hive || allied_desert || allied_temperate;
        });
    }

    if(valid_stars == 0){
        log_error("RE: Purge, couldn't find star");
        exit;
    }
    
    var star = stars[irandom(valid_stars - 1)];
    
    var planet = -1;
    if(mission_flavour == 3) {
        planet = scr_get_planet_with_type(star, "Hive");
    } else {
        var hive_planet = scr_get_planet_with_type(star,"Hive");
        var desert_planet = scr_get_planet_with_type(star,"Desert");
        var temperate_planet = scr_get_planet_with_type(star,"Temperate");
        if(scr_is_planet_owned_by_allies(star, hive_planet)) {
            planet = hive_planet;
        } else if(scr_is_planet_owned_by_allies(star, temperate_planet)) {
            planet = temperate_planet;
        } else if(scr_is_planet_owned_by_allies(star, desert_planet)) {
            planet = desert_planet;
        }
    }
    
    if(planet == -1){
        log_error("RE: Purge, couldn't find planet");
        exit;
    }
    
    
    var eta = infinity
    with(obj_p_fleet){
        if (capital_number+frigate_number==0) {
            eta = min(scr_mission_eta(star.x,star.y,1),eta); // this is wrong
        }
    }
    eta = min(max(eta,12),100);
    
                var text="The Inquisition is trusting you with a special mission.";

    
    
    if (mission_flavour==1) {
        text +=$"  A number of high-ranking nobility on the planet {scr_roman(planet)} are being difficult and harboring heretical thoughts.  They are to be selectively purged within {string(eta)} months.  Can your chapter handle this mission?";
    }
    else if (mission_flavour==2) {
        text+=$"  A powerful crimelord on the planet {scr_roman(planet)} is gaining an unacceptable amount of power and disrupting daily operations.  They are to be selectively purged within {string(eta)} months.  Can your chapter handle this mission?";
    }
    else if (mission_flavour==3) {
        text+=$"  The mutants of hive world {scr_roman(planet)} are growing in numbers and ferocity, rising sporadically from the underhive.  They are to be cleansed by promethium within {string(eta)} months.  Can your chapter handle this mission?";
    }
    
    if (mission_flavour!=3) {
        scr_popup("Inquisition Mission",text,"inquisition",$"purge|{string(star.name)}|{string(planet)}|{string(real(eta+1))}|");
    }
    else {	
        scr_popup("Inquisition Mission",text,"inquisition",$"cleanse|{string(star.name)}|{string(planet)}|{string(real(eta+1))}|");
    }

}

function mission_investigate_planet(){
		var stars = scr_get_stars();
		var valid_stars = array_filter_ext(stars,
		function(star,index){			
			if(scr_star_has_planet_with_feature(star, "????")){
				var fleet = instance_nearest(star.x,star.y,obj_p_fleet);
				if(fleet == undefined || point_distance(star.x,star.y,fleet.x,fleet.y)>=160){
					return true;
				}
				return false;
			}
			return false;
		});
		
		if (valid_stars == 0){
			log_error("RE: Investigate Planet, couldn't find a star");
			exit;
		}
	    	
		var star = stars[irandom(valid_stars-1)];
		var planet = scr_get_planet_with_feature(star, P_features.Ancient_Ruins);
		if (planet == -1){
			log_error("RE: Investigate Planet, couldn't pick a planet");
			exit;
		}

		
		var eta = infinity;
	    with(obj_p_fleet){
			if (action!=""){
				continue;
			}
			eta = min(eta, scr_mission_eta(star.x,star.y,1));
		}
		eta = min(max(3,eta),100); 
		
		var text=$"The Inquisition wishes for you to investigate {string(star.name)} {scr_roman(planet)}";
		text+=$"  Boots are expected to be planted on its surface over the course of your investigation.";
	    text += $" You have {string(eta)} months to complete this task.";
	    scr_popup("Inquisition Recon",text,"inquisition",$"recon|{string(star.name)}|{string(planet)}|{string(eta)}|");

}