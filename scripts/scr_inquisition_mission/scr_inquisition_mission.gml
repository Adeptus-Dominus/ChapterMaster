/*
    Mission flow: 
    scr_random_event -> rolls rng for inquis mission
    scr_inquisition_mission -> rolls rng and tests suitable planets for which mission
    mission_inquisition_<mission_name> -> logic and mechanics for spawning the mission and triggering the popup
    scr_popup -> displays the panel with mission details and Accept/Refuse buttons
    obj_popup.Step0 -> find `mission_is_go` section and add necessary event logic for when the player accepts
    scr_mission_functions > mission_name_key -> need to update this so that missions display in the mission log


    Helpers: 
    scr_mission_eta -> given the xy of a _star where the mission is, calculate how long you should have to complete the mission
            Todo? maybe add a disposition influence here so that angy inquisitor gives you less spare time and vice versa
    scr_star_has_planet_with_feature -> given the id of a _star and a `P_features` enum value, check if any planet on that _star has the desired  feature
    star_has_planet_with_forces -> given the id of a _star, and a faction, returns whether or not there are forces present there and in sufficient number
*/


/// @param {Enum.EVENT} event 
/// @param {Enum.INQUISITION_MISSION} forced_mission optional
function scr_inquisition_mission(event, forced_mission = -1){
    
    log_message($"RE: Inquisition Mission, event {event}, forced_mission {forced_mission}");
	if ((obj_controller.known[eFACTION.Inquisition] == 0 || obj_controller.faction_status[eFACTION.Inquisition] == "War") && !global.cheat_debug){
        log_message("Player is either hasn't met or is at war with Inquisition, not proceeding with inquisition mission");
        return;
    }
    if (global.cheat_debug){
        show_debug_message("find mission");
    }
    if (event == EVENT.inquisition_planet){
        mission_investigate_planet();
    } else if (event == EVENT.inquisition_mission){
    
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
            var _star = all_stars[s];

            if (scr_star_has_planet_with_feature(_star, P_features.Necron_Tomb) && !awake_necron_star(_star.id)){
                array_push(necron_tomb_worlds, _star);
                found_sleeping_necrons = true;
            }

            if (star_has_planet_with_forces(_star, "Demons", 1)){
                // array_push(demon_worlds, _star); // turning this off til i have a way to finish the mission
                found_demon_world = true;
            }

            if (star_has_planet_with_forces(_star, eFACTION.Tyranids, 4)){
                array_push(tyranid_org_worlds, _star)
                found_tyranid_org = true;
            }
        }

        if (found_sleeping_necrons){
            array_push(inquisition_missions, INQUISITION_MISSION.tomb_world);
            log_message($"Was able to find a _star with dormant necron tomb for inquisition mission");
        } else {
            log_message($"Couldn't find any planets with a dormant necron tomb for inquisition mission")
        }
        if (found_tyranid_org){
            log_message($"Was able to find a _star with lvl 4 tyranids for inquisition mission");
            array_push(inquisition_missions, INQUISITION_MISSION.tyranid_organism);
        } else {
            log_message($"Couldn't find any planets with lvl 4 tyranids for inquisition mission")
        }
        if (found_demon_world){
            array_push(inquisition_missions, INQUISITION_MISSION.demon_world);
            log_message($"Was able to find a _star with demons on it for inquisition mission");
        } else {
            log_message($"Couldn't find any planets with demons for inquisition mission")
        }
		
		//if (string_count("Tau",obj_controller.useful_info)=0){
		//	var found_tau = false;
		//	with(obj_star){
		//		if (found_tau){
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
        if (forced_mission != -1){
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
    var _star = choose_array(demon_worlds);
    var planet = -1;
    for(var i = 1; i <= _star.planets; i++){
        if (_star.p_demons[i] > 1){
            planet = i;
            break;
        }
    }
    var eta = scr_mission_eta(_star.x, _star.y, 25);
    var text=$"The Inquisitor is trusting you with a special mission.  The planet {string(_star.name)} {scr_roman(planet)}";
    text+=$" has been uncovered as a Demon World. The taint of chaos must be eradicated from this system.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"demon_world|{string(_star.name)}|{string(planet)}|{string(eta+1)}|");
}

function mission_inquisition_ethereal(){
    log_message("RE: Ethereal Capture");
    var stars = scr_get_stars();
    var _valid_stars = array_filter_ext(stars, function(_star, index) {
        for(var i = 1; i <= _star.planets; i++){
            if (_star.p_owner[i]==eFACTION.Tau && _star.p_tau[i] >= 4) {
                return true;
            }
        }
        return false;
    });
    if (array_length(_valid_stars) == 0){
        exit;
    }
    var _star = array_random_element(_valid_stars);
    
    var planet = -1;
    for(var i = 1; i <= _star.planets; i++){
        if (_star.p_owner[i]==eFACTION.Tau && _star.p_tau[i] >= 4){
            planet = i;
            break;
        }
    }
    var eta = scr_mission_eta(_star.x,_star.y,1);
    eta = min(max(eta,12),50);
    var text = $"An Inquisitor is trusting you with a special mission.";
    text +=$"They require that you capture a Tau Ethereal from the planet {string(_star.name)} {scr_roman(planet)} for research purposes. You have {string(eta)} months to locate and capture one. Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"ethereal|{string(_star.name)}|{string(planet)}|{string(eta+1)}|");

}

function mission_inquisition_tyranid_organism(worlds){
    log_message("RE: Gaunt Capture");
    var _star = choose_array(worlds);
    var planet = -1;
    for(var i = 1; i <= _star.planets; i++){
        if (_star.p_tyranids[i] > 4){
            planet = i;
            break;
        }
    }

    var eta = scr_mission_eta(_star.x, _star.y, 1);
    var eta = min(max(eta,6),50);

    var text=$"An Inquisitor is trusting you with a special mission.  The planet {string(_star.name)} {scr_roman(planet)}";
    text+=" is ripe with Tyranid organisms.  They require that you capture one of the Gaunt species for research purposes.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"tyranid_org|{string(_star.name)}|{string(planet)}|{string(eta+1)}|");

}\

function mission_inquisition_tomb_world(tomb_worlds){
    log_message("RE: Necron Tomb Bombing");
    if (is_array(tomb_worlds)){
        var _star = array_random_element(tomb_worlds);
    } else {
        _star = tomb_worlds;
    }

    var planet = scr_get_planet_with_feature(_star);

    if (planet == -1){
        planet = irandom_range(1,_star.planets);
        array_push(_star.p_feature[planet],new NewPlanetFeature(P_features.Necron_Tomb));
    }
    
    var eta = scr_mission_eta(_star.x, _star.y,1)
    if (global.cheat_debug){
        show_debug_message("mission popup");
    }
    var _options = [
        {
            str1 :"Accept",
            method: init_mission_inquisition_tomb_world,
        },
        {
            str1 :"Refuse",
            method: popup_defualt_close,
        }
    ]
    var _pop_data = {
        system : _star.name,
        planet : planet,
        estimate : eta,
        mission : "necron",
        options : _options,
    }

    var text=$"The Inquisition is trusting you with a special mission.  They have reason to suspect the Necron Tomb on planet {string(_star.name)} {scr_roman(planet)}";

    text+=$" may become active.  You are to send a small group of marines to plant a bomb deep inside, within {string(eta)} months.  Can your chapter handle this mission?";

    scr_popup("Inquisition Mission",text,"inquisition",_pop_data);
}

function init_mission_inquisition_tomb_world(){

    mission_star = star_by_name(pop_data.system);
    if (mission_star == "none"){
        popup_defualt_close();
        exit;
    }
    scr_event_log("", $"Inquisition Mission Accepted: {global.chapter_name} have been given a Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(pop_data.planet)}.", mission_star.name);

    image = "necron_cave";
    title = "New Equipment";
    fancy_title = 0;
    text_center = 0;
    text = $"{global.chapter_name} have been provided with 1x Plasma Bomb in order to complete the mission.";

    if (demand) {
        text = $"The Inquisition demands that your Chapter demonstrate its loyalty.  {global.chapter_name} have been given a Plasma Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(pop_data.planet)}.  It is expected to be completed within {estimate} months.";
    }
    reset_popup_options();
    scr_add_item("Plasma Bomb", 1);
    obj_controller.cooldown = 10;
    if (demand) {
        demand = 0;
    }
    add_new_inquis_mission();
    exit;    
}

function mission_inquisition_artifact(){
    var text;
    log_message("RE: Artifact Hold");
    text="The Inquisition is trusting you with a special mission.  A local Inquisitor has a powerful artifact.  You are to keep it safe, and NOT use it, until the artifact may be safely retrieved.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission",text,"inquisition",$"artifact|bop|0|{string(irandom_range(6,26))}|");
}

function mission_inquistion_hunt_inquisitor(star_id = -1){
    log_message("RE: Inquisitor Hunt");

    var stars = scr_get_stars();
    /*var _valid_stars = array_filter_ext(stars,
    function(_star,index){
        var _p_fleet = instance_nearest(_star.x,_star.y,obj_p_fleet);
        if (instance_exists(_p_fleet)){
            var _distance = point_distance(_star.x,_star.y,_p_fleet.x,_p_fleet.y);
            if (100 <= _distance & _distance <= 300){
                return true;
            }
        }
        return false;
    });*/


    if (star_id == -1){
        var _valid_stars = stars;
        
        if (array_length(_valid_stars) == 0) {
            log_error("RE: Inquisitor Hunt,couldn't find a _star");
            exit;
        }
            
        var _star = array_random_element(_valid_stars);
    } else {
        _star = star_id;
    }
    
    var _gender = set_gender();
    var _name = global.name_generator.generate_imperial_name(_gender);
    var planet = irandom_range(1, _star.planets);
    
    var eta = scr_mission_eta(_star.x,_star.y,1);
    eta=max(eta, 8);
    var text=$"The Inquisition is trusting you with a special mission.  A radical inquisitor named {_name} will be visiting the {string(_star.name)} system in {string(eta)} month's time.  They are highly suspect of heresy, and as such, are to be put down.  Can your chapter handle this mission?";
    if (obj_controller.demanding) {
        text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  A radical inquisitor is enroute to {_star.name}, expected within {estimate} months.  They are to be silenced and removed.";
    }
    var _options = [
        {
            str1 :"Accept",
            method: init_mission_hunt_inquisitor,
        },
        {
            str1 :"Refuse",
            method: popup_defualt_close,
        }
    ];

    var _mission_data = {
        inquisitor_name : _name,
        inquisitor_gender : _gender,
    };
    var _pop_data = {
        system : _star.name,
        planet : planet,
        estimate : eta,
        mission : "inquisitor",
        options : _options,
        mission_data : _mission_data,
    };

    scr_popup("Inquisition Mission",text,"inquisition",_pop_data);
}

/// @mixin obj_popup
function add_new_inquis_mission(){

    if (add_new_problem(pop_data.planet, pop_data.mission, pop_data.estimate, mission_star)) {
        new_star_event_marker("green");
        mission_is_go = true;
    } 
}

function init_mission_hunt_inquisitor(){
    mission_star = star_by_name(pop_data.system);
    if (mission_star == "none"){
        popup_defualt_close();
        exit;
    }
    scr_event_log("", $"Inquisition Mission Accepted: The radical Inquisitor {pop_data.mission_data.inquisitor_name} enroute to {mission_star.name} must be removed.  Estimated arrival in {pop_data.estimate} months.", mission_star.name);
    var _mission_data = pop_data.mission_data,

    var _radical_inquisitor_fleet = instance_create(mission_star.x-irandom_range(-400,400),mission_star.y-irandom_range(-400,400),obj_en_fleet);
    with (_radical_inquisitor_fleet){
        base_inquis_fleet();
    }

    fleet_add_cargo("radical_inquisitor", pop_data.mission_data, true, _radical_inquisitor_fleet);

    _radical_inquisitor_fleet.action_x=mission_star.x;
    _radical_inquisitor_fleet.action_y=mission_star.y;

    var _est = pop_data.estimate;
    with (_radical_inquisitor_fleet){
        set_fleet_movement(false,"move",_est,_est);
    }

    if (add_new_problem(pop_data.planet, pop_data.mission, pop_data.estimate, mission_star,pop_data.mission_data)) {
        new_star_event_marker("green");
        mission_is_go = true;
    }
}

function mission_hunt_inquisitor_hear_out_radical_inquisitor(){

    var _offer = choose(1, 1, 2, 2, 3);

    var _gender = pop_data.inquisitor_gender
    var _gender_third = string_gender_third_person(_gender);
    var gender_pronoun = string_gender_pronouns(_gender);

    if (_offer == 1) {
        replace_options(
            [ 
                {
                    str1 : "Destroy their vessel",
                    method : mission_hunt_inquisitor_destroy_inquisitor_ship,

                },
                {
                    str1 : "Take the artifact and then destroy them",
                    method : instance_destroy,
                },
                {
                    str1 : "Take the artifact and spare them",
                    method : mission_hunt_inquisitor_take_artifact_bribe,
                }
            ]
        );
        title = "Artifact Offered";
        text = $"The Inquisitor claims that this is a massive misunderstanding, and {_gender_third} wishes to prove {gender_pronoun} innocence.  If {global.chapter_name} allow their ship to leave {_gender_third} will give {global.chapter_name} an artifact.";
        exit;
    }

    else if (_offer == 2) {
        replace_options(
            [ 
                {
                    str1 : "Destroy their vessel",
                    method : mission_hunt_inquisitor_destroy_inquisitor_ship,

                },
                {
                    str1 : "Search their ship",
                    //method : instance_destroy,
                },
                {
                    str1 : "Spare them",
                    method : mission_hunt_inquisitor_show_mercy,
                }
            ]
        )
        title = "Mercy Plea";
        text = $"The Inquisitor claims that {_gender_third} has key knowledge that would grant the Imperium vital power over the forces of Chaos.  If {global.chapter_name} allow {gender_pronoun} ship to leave the forces of Chaos within this sector will be weakened.";
        exit;
    }

    else if (_offer == 3) {
        with (obj_en_fleet) {
            if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
                with (obj_p_fleet) {
                    if (action != "") {
                        instance_deactivate_object(id);
                    }
                }
                with (instance_nearest(x, y, obj_p_fleet)) {
                    scr_add_corruption(true, "1d3");
                }
                instance_activate_object(obj_p_fleet);
                instance_destroy();
            }
        }
        title = "Inquisition Mission Completed";
        image = "exploding_ship";
        text = $"{global.chapter_name} allow communications.  As soon as the vox turns on {global.chapter_name} hear a sickly, hateful voice.  They begin to speak of the inevitable death of your marines, the fall of all that is and ever shall be, and " + string(gender_pronoun) + " Lord of Decay.  Their ship is fired upon and destroyed without hesitation.";
        reset_popup_options();
        scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
        exit;
    }
    exit;   
}

function mission_hunt_inquisitor_take_artifact_bribe(){
    with (pop_data.inquisitor_ship) {
        action_x = choose(room_width * -1, room_width * 2);
        action_y = choose(room_height * -1, room_height * 2);
        trade_goods = "|DELETE|";
        action_spd = 256;
        set_fleet_movement(false);
    }
    var last_artifact = scr_add_artifact("random", "", 4);
    
    reset_popup_options();

    title = "Inquisition Mission Completed";
    text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
    text += $" some form of {obj_ini.artifact[last_artifact]}.  As promised {global.chapter_name} allow the Inquisitor to leave, hoping for the best.  What's the worst that could happen?";
    image = "artifact_recovered";
    scr_event_log("", "Artifact Recovered from radical Inquisitor.");
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");

    add_event({
        e_id : "inquisitor_spared",
        duration : irandom_range(6, 18) + 1,
        variation : 1,
    });
 
}

function mission_hunt_inquisitor_show_mercy(){

    with (pop_data.inquisitor_ship) {
        action_x = choose(room_width * -1, room_width * 2);
        action_y = choose(room_height * -1, room_height * 2);
        trade_goods = "|DELETE|";
        alarm[4] = 1;
        action_spd = 256;
        action = "";
    };

    title = "Inquisition Mission Completed";
    text = $"{global.chapter_name} allow the Inquisitor to leave, trusting in their words.  If they truly do have key information it is a risk {global.chapter_name} are willing to take.  What's the worst that could happen?";
    image = "artifact_recovered";
    reset_popup_options();

    scr_event_log("", "Inquisition Mission Completed?: The radical Inquisitor has been allowed to flee in order to weaken the forces of Chaos, as they promised.");

    add_event({
        e_id : "inquisitor_spared",
        duration : irandom_range(6, 18) + 1,
        variation : 2,
    })

}

function mission_hunt_inquisitor_destroy_inquisitor_ship(){

    show_debug_message("mission_hunt_inquisitor_destroy_inquisitor_ship");
    var _final_disp_mod = 0;

    if (obj_controller.demanding == 0) {
        _final_disp_mod += 1;
    }
    else if (obj_controller.demanding == 1) {
        _final_disp_mod += choose(0, 0, 1);
    }

    if ((title == "Artifact Offered") || (title == "Mercy Plea")) {
        _final_disp_mod -= choose(0, 1);
    }

    alter_disposition(eFACTION.Inquisition, _final_disp_mod);

    title = "Inquisition Mission Completed";
    image = "exploding_ship";
    text = "The Inquisitor's ship begans to bank and turn, to flee, but is immediately fired upon by your fleet.  The ship explodes, taking the Inquisitor with it.  The mission has been accomplished.";
    reset_popup_options();

    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    with (pop_data.inquisitor_ship) {
        instance_destroy();
    }
    exit;  
}

function hunt_inquisition_spared_inquisitor_consequence(event){
    var _diceh=roll_dice_chapter(1, 100, "high");

    if (_diceh<=25){
        alarm[8]=1;
        scr_loyalty("Crossing the Inquisition","+");
        scr_popup("Inquisition Crossed","","","");
    }
    if (_diceh>25) and (_diceh<=50){
        scr_loyalty("Crossing the Inquisition","+");
        scr_popup("Inquisition Crossed","","","");
    }
    if (_diceh>50) and (_diceh<=85){
        //nothing happens for the minute
    }
    if (_diceh>85) and (event.variation==2){
        scr_popup("Anonymous Message","You recieve an anonymous letter of thanks.  It mentions that motions are underway to destroy any local forces of Chaos.","","");
        with(obj_star){
            for(var o=1; o<=planets; o++){
                p_heresy[o]=max(0,p_heresy[o]-10);
            }
        }
    }
}


function mission_inquistion_spyrer(){
    log_message("RE: Spyrer");
    var stars = scr_get_stars();
    var _valid_stars = array_filter_ext(stars, 
        function(_star,index){
            return scr_star_has_planet_with_type(_star,"Hive");
    });
    
    if (array_length(_valid_stars) == 0){
        log_error("RE: Spyrer, couldn't find _star");
        exit;
    }
    var _star = array_random_element(_valid_stars);
    var planet = scr_get_planet_with_type(_star,"Hive");
    var eta = scr_mission_eta(_star.x,_star.y,1);
    eta = min(max(eta, 6), 50);
    
    
    var text=$"The Inquisition is trusting you with a special mission.  An experienced Spyrer on hive world {string(_star.name)} {scr_roman(planet)}";
    text += $" has began to hunt indiscriminately, and proven impossible to take down by conventional means.  If they are not put down within {string(eta)} month's time panic is likely.  Can your chapter handle this mission?";
    var mission_params = $"spyrer|{string(_star.name)}|{string(planet)}|{string(eta+1)}|";
    log_message($"Starting spyrer mission with params {mission_params}")
    scr_popup("Inquisition Mission",text,"inquisition",mission_params);
}

function mission_inquistion_purge(){
    log_message("RE: Purge");
    var mission_flavour = choose(1,1,1,2,2,3);
    
    var stars = scr_get_stars();
    var _valid_stars = 0;
    
    if (mission_flavour == 3) {
        _valid_stars = array_filter_ext(stars, function(_star,index){
            var hive_idx = scr_get_planet_with_type(_star,"Hive")
            return scr_is_planet_owned_by_allies(_star, hive_idx);
        });
    } else {
        _valid_stars = array_filter_ext(stars,
            function(_star,index){
                var hive_idx = scr_get_planet_with_type(_star,"Hive")
                var desert_idx =  scr_get_planet_with_type(_star,"Desert")
                var temperate_idx = scr_get_planet_with_type(_star,"Temperate")
                var allied_hive = scr_is_planet_owned_by_allies(_star, hive_idx)
                var allied_desert = scr_is_planet_owned_by_allies(_star, desert_idx)
                var allied_temperate =scr_is_planet_owned_by_allies(_star, temperate_idx)

                return allied_hive || allied_desert || allied_temperate;
        });
    }

    if (array_length(_valid_stars) == 0){
        log_error("RE: Purge, couldn't find _star");
        exit;
    }
    
    var _star = stars[irandom(_valid_stars - 1)];
    
    var planet = -1;
    if (mission_flavour == 3) {
        planet = scr_get_planet_with_type(_star, "Hive");
    } else {
        var hive_planet = scr_get_planet_with_type(_star,"Hive");
        var desert_planet = scr_get_planet_with_type(_star,"Desert");
        var temperate_planet = scr_get_planet_with_type(_star,"Temperate");
        if (scr_is_planet_owned_by_allies(_star, hive_planet)) {
            planet = hive_planet;
        } else if (scr_is_planet_owned_by_allies(_star, temperate_planet)) {
            planet = temperate_planet;
        } else if (scr_is_planet_owned_by_allies(_star, desert_planet)) {
            planet = desert_planet;
        }
    }
    
    if (planet == -1){
        log_error("RE: Purge, couldn't find planet");
        exit;
    }
    
    
    var eta = infinity
    with(obj_p_fleet){
        if (capital_number+frigate_number==0) {
            eta = min(scr_mission_eta(_star.x,_star.y,1),eta); // this is wrong
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
        scr_popup("Inquisition Mission",text,"inquisition",$"purge|{string(_star.name)}|{string(planet)}|{string(real(eta+1))}|");
    }
    else {	
        scr_popup("Inquisition Mission",text,"inquisition",$"cleanse|{string(_star.name)}|{string(planet)}|{string(real(eta+1))}|");
    }

}

function mission_investigate_planet(){
		var stars = scr_get_stars();
		var _valid_stars = array_filter_ext(stars,
		function(_star,index){			
			if (scr_star_has_planet_with_feature(_star, "????")){
				var fleet = instance_nearest(_star.x,_star.y,obj_p_fleet);
				if (fleet == undefined || point_distance(_star.x,_star.y,fleet.x,fleet.y)>=160){
					return true;
				}
				return false;
			}
			return false;
		});
		
		if (array_length(_valid_stars) == 0){
			log_error("RE: Investigate Planet, couldn't find a _star");
			exit;
		}
	    	
		var _star = array_random_element(_valid_stars);
		var planet = scr_get_planet_with_feature(_star, P_features.Ancient_Ruins);
		if (planet == -1){
			log_error("RE: Investigate Planet, couldn't pick a planet");
			exit;
		}

		
		var eta = infinity;
	    with(obj_p_fleet){
			if (action!=""){
				continue;
			}
			eta = min(eta, scr_mission_eta(_star.x,_star.y,1));
		}
		eta = min(max(3,eta),100); 
		
		var text=$"The Inquisition wishes for you to investigate {string(_star.name)} {scr_roman(planet)}";
		text+=$"  Boots are expected to be planted on its surface over the course of your investigation.";
	    text += $" You have {string(eta)} months to complete this task.";
	    scr_popup("Inquisition Recon",text,"inquisition",$"recon|{string(_star.name)}|{string(planet)}|{string(eta)}|");

}


function setup_necron_tomb_raid(planet){
    log_message($"player on planet with necron mission {name} planet: {planet}")
    var have_bomb;
    have_bomb = scr_check_equip("Plasma Bomb", name, planet, 0);
    log_message($"have bomb? {have_bomb} ")
    if (have_bomb > 0) {
        var tixt;
        tixt = "Your marines on " + planet_numeral_name(planet);
        tixt += " are prepared and ready to enter the Necron Tombs.  A Plasma Bomb is in tow.";
        var _number = instance_exists(obj_turn_end) ? obj_turn_end.current_popup : 0;
        var _pop_data = {
            mission : "necron_tomb_excursion",
            loc : name,
            planet : planet, 
            estimate : 999,
            number : _number,
            mission_stage :1,
            options : [
                {
                    str1 : "Begin the Mission",
                    method : necron_tomb_mission_start,
                },
                {
                    str1 : "Not Yet",
                    method : instance_destroy,
                }
            ]
        }
        scr_popup("Necron Tomb Excursion", tixt, $"necron_cave",_pop_data);
    }   
}

function necron_tomb_mission_start(){
    instance_activate_all();
    var player_forces, penalty, roll;
    mission_star = star_by_name(pop_data.loc);
    planet = pop_data.planet;
    player_forces = 0;
    penalty = 0;
    roll =  roll_dice_chapter(1, 100, "low");

    player_forces = mission_star.p_player[planet];
    cooldown = 30;


    title = $"Necron Tunnels : {pop_data.mission_stage}";
    replace_options(
        [ 
            {
                str1 : "Continue",
                method : necron_tomb_mission_sequence,

            },
            {
                str1 : "Return to the surface",
                method : instance_destroy,
            }
        ]
    )
    image = "necron_tunnels_1";
    text = "Your marines enter the massive tunnel complex, following the energy readings.  At first the walls are cramped and tiny, closing about them, but the tunnels widen at a rapid pace.";
}

function necron_tomb_mission_sequence(){
    var penalty, roll, battle;
    penalty = 0;
    roll = floor(random(100)) + 1;
    battle = 0;
    instance_activate_all();

    // SMALL TEAM OF MARINES
    if (player_forces > 6) {
        penalty = 10;
    }
    if (player_forces > 10) {
        penalty = 20;
    }
    if (player_forces >= 20) {
        penalty = 30;
    }
    if (player_forces >= 40) {
        penalty = 50;
    }
    if (player_forces >= 60) {
        penalty = 100;
    }
    roll += penalty;

    // roll=30;if (string_count("3",title)>0) then roll=70;

    // Result
    if (roll <= 60) {
        pop_data.mission_stage += 1;
        title = $"Necron Tunnels : {pop_data.mission_stage}";

        if (pop_data.mission_stage == 2) {
            image = "necron_tunnels_2";
            text = "The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
        } else if (pop_data.mission_stage == 3) {
            image = "necron_tunnels_3";
            text = "After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
        } else if (pop_data.mission_stage >= 4) {
            image = "";
            title = "Inquisition Mission Completed";
            text = "Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
            reset_popup_options();

            add_disposition(eFACTION.Inquisition, obj_controller.demanding ? choose(0, 0, 1) : 1);

            mission_star = star_by_name(pop_data.loc);
            remove_planet_problem(planet, "necron", mission_star);
            seal_tomb_world(mission_star.p_feature[planet]);
            // mission_star.p_feature[planet][search_planet_features(mission_star.p_feature[planet], P_features.Necron_Tomb)[0]].sealed = 1;

            scr_event_log("", $"Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on {mission_star.name} {scr_roman(planet)}.", mission_star.name);
            scr_gov_disp(mission_star.name, planet, irandom_range(3, 7));
            var have_bomb = scr_check_equip("Plasma Bomb", pop_data.loc, pop_data.planet, 1);
            exit;
        }
    }
    if ((roll > 60) && (roll <= 82)) {
        // Necron Wraith attack
        battle = 1;
    }
    if ((roll > 82) && (roll <= 92)) {
        // Tomb Spyder attack
        battle = 2;
    }
    if ((roll > 92) && (roll <= 97)) {
        // Tomb Stalker
        battle = 3;
    }
    if (roll > 97) {
        // Tomb World wakes up
        if (player_forces <= 30) {
            battle = 4;
        }
        if (player_forces > 30) {
            battle = 5;
        }
        if (player_forces > 100) {
            battle = 6;
        }
    }

    if (battle > 0) {
        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_temp8);

        instance_create(0, 0, obj_ncombat);
        _roster = new Roster();
        with (_roster){
            roster_location = obj_temp8.loc;
            roster_planet = obj_temp8.wid;
            determine_full_roster();
            only_locals();
            update_roster();
            if (array_length(selected_units)){  
                setup_battle_formations();
                add_to_battle();
            }               
        }
        delete _roster;         


        mission_star = star_by_name(pop_data.loc);

        obj_ncombat.battle_object = mission_star;
        instance_deactivate_object(obj_star);
        obj_ncombat.battle_loc = pop_data.loc;
        obj_ncombat.battle_id = pop_data.planet;
        obj_ncombat.dropping = 0;
        obj_ncombat.attacking = 0;
        obj_ncombat.enemy = 13;
        obj_ncombat.threat = 1;
        obj_ncombat.formation_set = 1;
        obj_ncombat.battle_mission = "necron_tomb_excursion";
        obj_ncombat.battle_data = pop_data;
        if (battle == 1) {
            obj_ncombat.battle_special = "wraith_attack";
        } else if (battle == 2) {
            obj_ncombat.battle_special = "spyder_attack";
        } else if (battle == 3) {
            obj_ncombat.battle_special = "stalker_attack";
        } else if (battle == 4) {
            obj_ncombat.battle_special = "wake1_attack";
        } else if (battle == 5) {
            obj_ncombat.battle_special = "wake2_attack";
        } else if (battle == 6) {
            obj_ncombat.battle_special = "wake2_attack";
        }

        instance_destroy();
    }

    exit;   
}