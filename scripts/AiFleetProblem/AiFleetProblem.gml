//All missions that run on a fleet need their own FleetProblem instance
//missions for the most part can only run from predefined points in the code
// to run from each of these points each mission must have a registered function these functions are then called implicitly
//each function follows the format  `__<p_id>_<entry_flag>`
/* the current entry points for the code are
    "per_turn" - runs every end turn to check for certain conditions often contains reactions to actions player has done last turn
        - runs via basic_turn_end

    "init" - runs immediately after problem is created often used to populate initial popup or stack popup for turn end

    "on_arrival" - runs when the fleet arrives at a star, fleet_event_data holds {star}
    "on_load" - runs when units are loaded onto the fleet, fleet_event_data holds {units}
    "on_unload" - runs when units are unloaded from the fleet, fleet_event_data holds {units}
    "on_split" - runs on the original fleet when it splits, fleet_event_data holds {new_fleet}
    "on_merge" - runs on the receiving fleet when another fleet merges into it, fleet_event_data holds {merged_fleet}
    "on_destruction" - runs when the fleet is destroyed, the mission is deleted after this function has run
        - must be triggered BEFORE the fleet instance is destroyed

    "mission_log_entry" - runs to provide a data row for the mission log

- other than these entry points and any other later defined positions mission specific code should not run outside of the FleetProblem container

- to set an entry point up simply register the function as a static e.g
    if i create static __example_per_turn once an "example" problem is registered on a fleet the per turn check will run
    no other code is required

other info
    - the owning fleet must have a `problems = []` array in its create event
    - entry points that receive extra information read it from fleet_event_data, which only exists for the duration of the call
    - set a mission for deletion by setting delete_mission = true; this will delete the mission after the current function
    has finished executing
    - functions prefixed with `__` are only accessible from within the FleetProblem's internal scope
*/

//ANYTIME an exception is caught on a entry point for a mission the mission is prematurely deleted this ensures the player is not unfairly penalised for errors

/// @param {string} _name
/// @param {Real} _timer
/// @param {struct} _data
/// @param {Id.Instance.obj_en_fleet} _fleet
function AiFleetProblem(_name, _timer = -1, _data ={}, _fleet = noone) : FleetProblem(_name, _timer, _data, _fleet) constructor{
fleet = _fleet;

per_turn_checks = true;

/// @param {array} units
static on_load = function(units){
    __trigger_with_event("on_load", {units});
}

/// @param {array} units
static on_unload = function(units){
    __trigger_with_event("on_unload", {units});
}

static __set_members_job_to_mission = function(){
    for (var i = 0; i < array_length(members); i++){
        var _unit = members[i];
        _unit.job = {
            type: p_id,
            location: $"{global.faction_names[fleet.owner]} Fleet",
            fleet : fleet.uid,
        };
        _unit.ship_location = -1;
        _unit.planet_location = 0;
        _unit.location_string = $"{global.faction_names[fleet.owner]} Fleet";
    }    
};


__init();


//unfinished will be completed in adjacent pr
static __deliver_hunt_trophy_mission_log_entry = function(){
    var _mission = localize("Deliver Trophy Guard");
    var _sys = fleets_next_location(fleet);
    var _mission_data = {
        system: _sys.name,
        system_id: _sys.id,
        target: self,
        important_person: data.trophy_owner,
        person_name: data.delivering_marine,
        planet: 0,
        start_system: data.system,
        time: timer,
    };
    _mission_data.mission = self;

    _mission_data.click_left = method(_mission_data, function() {
        set_map_pan_to_loc(system_id);
    });

    _mission_data.hover = method(_mission_data, function() {
        tooltip_draw(localize("You are to have {0} deliver trophy hunted on {1} to the {1} regiments\n\nLeft click to see target fleet intercept system right click to view the trophy bearing marine {0}", [person_name, start_system]));
    });

    _mission_data.click_right = method(_mission_data, function() {
        var _unit = fetch_unit_uid(important_person);
        if (is_struct(_unit)) {
            var _unit_l = [_unit];
            group_selection(_unit_l);
        }
    });
    return _mission_data;   
}

static __radical_inquisitor_init = function(){
    if (!instance_exists(obj_popup)){
        scr_popup("","","","");
    }
    obj_popup.title = "Inquisition Mission Accepted";
    obj_popup.text = $"{global.chapter_name} will intercept the radical Inquisitor {data.inquisitor_name} at {data.target_name}, expected within {timer} months.";
}

static __radical_inquisitor_mission_log_entry = function(){
    var _mission = "Intercept Radical Inquisitor";
    var _sys = fleets_next_location(fleet);
    var _mission_data = {
        system: data.target_name,
        system_id: find_star_by_name(data.target_name),
        time: timer,
    };
    _mission_data.mission = self;

    _mission_data.click_left = method(_mission_data, function() {
        set_map_pan_to_loc(mission.fleet);
    });

    _mission_data.hover = method(_mission_data, function() {
        tooltip_draw($"intercept the radical Inquisitor {mission.data.inquisitor_name} at {mission.data.target_name}, expected within {mission.timer} months.");
    });
    return _mission_data;
}

static __radical_inquisitor_on_arrival = function(){
    if (fleet.orbiting == noone){
        LOGGER.error("radical_inquisitor mission inquisitor fleet did not arrive at system");
        delete_mission = true;
        exit;
    }
    if (!fleet.orbiting.has_orbiting_player_fleet()) {
        with (fleet){
            random_sector_exit_point();
            action_spd = 256;
            action = "";
            set_fleet_movement();
            instance_destroy();
        }
        alter_disposition(eFACTION.INQUISITION, -15);
        scr_popup("Inquisitor Mission Failed", "The radical Inquisitor has departed from the planned intercept coordinates.  They will now be nearly impossible to track- the mission is a failure.", "inquisition", "");
        scr_event_log("red", "Inquisition Mission Failed: The radical Inquisitor has departed from the planned intercept coordinates.");
        delete_mission = true;
        exit;
    }
    var _gender = string_gender_third_person(data.inquisitor_gender);

    var __tixt = $"You have located the radical Inquisitor.  As you prepare to destroy their ship, and complete the mission, you recieve a hail- it appears as though {_gender} wishes to speak.";
    var _options = [
        __create_popup_option("Destroy their vessel", "destroy_inquisitor_ship"),
        __create_popup_option("Hear them out", "hear_them_out"),
    ];
    scr_popup("Inquisitor Located", __tixt, "inquisition", {mission: self, options : _options});
    exit;   
}

/// @self Asset.GMObject.obj_popup
static __radical_inquisitor_destroy_inquisitor_ship = function() {
    LOGGER.debug("mission_hunt_inquisitor_destroy_inquisitor_ship");
    var _final_disp_mod = 0;

    if (obj_controller.demanding == 0) {
        _final_disp_mod += 1;
    } else if (obj_controller.demanding == 1) {
        _final_disp_mod += choose(0, 0, 1);
    }

    if ((obj_popup.title == "Artifact Offered") || (obj_popup.title == "Mercy Plea")) {
        _final_disp_mod -= choose(0, 1);
    }

    alter_disposition(eFACTION.INQUISITION, _final_disp_mod);

    obj_popup.title = "Inquisition Mission Completed";
    obj_popup.image = "exploding_ship";
    obj_popup.text = "The Inquisitor's ship begans to bank and turn, to flee, but is immediately fired upon by your fleet.  The ship explodes, taking the Inquisitor with it.  The mission has been accomplished.";
    reset_popup_options();
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    delete_mission = true;
    __check_delete();
    exit;
}


/// @self Asset.GMObject.obj_popup
static __radical_inquisitor_hear_them_out = function() {
    var _offer = choose(1, 1, 2, 2, 3);

    var _gender = data.inquisitor_gender;
    var _gender_third = string_gender_third_person(_gender);
    var gender_pronoun = string_gender_pronouns(_gender);

    if (_offer == 1) {
        obj_popup.replace_options([
            __create_popup_option("Destroy their vessel", "destroy_inquisitor_ship"),
            __create_popup_option("Take the artifact and then destroy them", "artifact_double_cross"),
            __create_popup_option("Take the artifact and spare them", "take_artifact_bribe"),
        ]);
        obj_popup.title = "Artifact Offered";
        obj_popup.text = $"The Inquisitor claims that this is a massive misunderstanding, and {_gender_third} wishes to prove {gender_pronoun} innocence.  If {global.chapter_name} allow their ship to leave {_gender_third} will give {global.chapter_name} an artifact.";
        exit;
    } else if (_offer == 2) {
        obj_popup.replace_options(
            [
                __create_popup_option("Destroy their vessel", "destroy_inquisitor_ship"),
                //__create_popup_option("Search their ship"), // TODO: Implement proper ship search logic
                __create_popup_option("Spare them", "show_mercy"),
            ],
        );
        obj_popup.title = "Mercy Plea";
        obj_popup.text = $"The Inquisitor claims that {_gender_third} has key knowledge that would grant the Imperium vital power over the forces of Chaos.  If {global.chapter_name} allow {gender_pronoun} ship to leave the forces of Chaos within this sector will be weakened.";
        exit;
    } else if (_offer == 3) {
        with (fleet) {
            with (instance_nearest(fleet.x, fleet.y, obj_p_fleet)) {
                scr_add_corruption(true, "1d3");
            }
            instance_destroy();
        }
        obj_popup.title = "Inquisition Mission Completed";
        obj_popup.image = "exploding_ship";
        obj_popup.text = $"{global.chapter_name} allow communications.  As soon as the vox turns on {global.chapter_name} hear a sickly, hateful voice.  They begin to speak of the inevitable death of your marines, the fall of all that is and ever shall be, and " + string(gender_pronoun) + " Lord of Decay.  Their ship is fired upon and destroyed without hesitation.";
        reset_popup_options();
        scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    }
    delete_mission = true;
    __check_delete();
}

static __radical_inquisitor_show_mercy = function() {
    with (fleet) {
        random_sector_exit_point();
        trade_goods = "|DELETE|";
        action_spd = 256;
        set_fleet_movement(false, 8);
    }

    obj_popup.title = "Inquisition Mission Completed";
    obj_popup.text = $"{global.chapter_name} allow the Inquisitor to leave, trusting in their words.  If they truly do have key information it is a risk {global.chapter_name} are willing to take.  What's the worst that could happen?";
    obj_popup.image = "artifact_recovered";
    reset_popup_options();
    scr_event_log("", "Inquisition Mission Completed?: The radical Inquisitor has been allowed to flee in order to weaken the forces of Chaos, as they promised.");
    add_event({e_id: "inquisitor_spared", duration: irandom_range(6, 18) + 1, variation: 2});
    delete_mission = true;
    __check_delete();
}

static __radical_inquisitor_artifact_double_cross = function() {
    with (fleet) {
        instance_destroy();
    }
    var last_artifact = scr_add_artifact("random", "", 4);

    reset_popup_options();

    obj_popup.title = "Inquisition Mission Completed";
    obj_popup.text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
    obj_popup.text += $" some form of {fetch_artifact(last_artifact).get_type_name()}.  Once it is safely stowed away your ship is then ordered to fire.  The Inquisitor's own seems to hesitate an instant before banking away, but is quickly destroyed.";
    obj_popup.image = "exploding_ship";
    scr_event_log("", "Artifact recovered from radical Inquisitor.");
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    delete_mission = true;
    __check_delete();
}

/// @self Asset.GMObject.obj_popup
static __radical_inquisitor_take_artifact_bribe = function() {
    with (fleet) {
        random_sector_exit_point();
        trade_goods = "|DELETE|";
        action_spd = 256;
        move(false);
    }
    var last_artifact = scr_add_artifact("random", "", 4);

    reset_popup_options();

    obj_popup.title = "Inquisition Mission Completed";
    obj_popup.text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
    obj_popup.text += $" some form of {fetch_artifact(last_artifact).get_type_name()}.  As promised {global.chapter_name} allow the Inquisitor to leave, hoping for the best.  What's the worst that could happen?";
    obj_popup.image = "artifact_recovered";
    scr_event_log("", "Artifact Recovered from radical Inquisitor.");
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    add_event({e_id: "inquisitor_spared", duration: irandom_range(6, 18) + 1, variation: 1});
}

static __mech_mars_init = function(){
    if (array_length(members) == 0){
        delete_mission = true;
        exit;
    }
    __set_members_job_to_mission();
    fleet.home_x = fleet.x;
    fleet.home_y = fleet.y;
    fleet.action_x = fleet.x + lengthdir_x(3000, obj_controller.terra_direction);
    fleet.action_y = fleet.y + lengthdir_y(3000, obj_controller.terra_direction);
    fleet.move(false, "move", 48, 48);
    timer = 96; 
    stage_id = "to_mars";  
}

static __mech_mars_on_arrival = function(){
    if (stage_id == "to_mars"){
        fleet.action_x = fleet.home_x;
        fleet.action_y = fleet.home_y;
        fleet.move(false, "move", 48, 48);
        stage_id = "returning_home";
        exit;   
    }

    var _cleanup = array_create(11, 0);

    var _roll1 = roll_dice_chapter(1, 100, "high"); // For the first STC
    var _found_stc = 0, _found_artifact = 0, _found_requisition = 0;
    var _techs_lost = 0;

    var _orbiting = fleet.orbiting;
    var _techs = clean_unit_array(members);

    var _tech_point_gain = 0;

    var _planet = irandom_range(1, _orbiting.planets);
    for (var i = array_length(_techs) - 1; i >= 0; i--) {
        var _std_tester = global.character_tester.standard_test;
        var _tech = _techs[i];
        var _tech_roll = _std_tester(_tech, "technology", -10)[1];
        var _wep_test = _std_tester(_tech, "weapon_skill", 10);
        if (!_wep_test[0]) {
            _tech.kill(true, false);
            _techs_lost++;
            _cleanup[_tech.company] = true;
            array_delete(_techs , i , 1);
        } else {
            _tech.unload(_planet, fleet.orbiting);
            _tech.job = "none";
            _tech.add_experience(irandom_range(3, 18));
            var gain = irandom(2);

            _tech.technology += gain;
            _tech_point_gain += gain;
            if (_tech_roll < 10 && _tech_roll > 0) {
                _found_requisition += irandom_range(5, 40);
            }
        }
        if ((_tech_roll >= 10) && (_tech_roll < 15)) {
            _found_requisition += 100;
        }
        if ((_tech_roll >= 15) && (_tech_roll < 25)) {
            var last_artifact = scr_add_artifact("random", "", 4);
            _found_artifact += 1;
        }
        if (_tech_roll >= 25) {
            scr_add_stc_fragment(); // STC here
            _found_stc += 1;
        }
    }
    var _techs_alive = array_length(_techs);

    obj_controller.requisition += _found_requisition;
    if ((_techs_alive + _techs_lost >= 2) && (_techs_alive > 0)) {
        if (_roll1 >= (40 + (_techs_alive + _techs_lost) * 5)) {
            scr_add_stc_fragment(); // STC here
            _found_stc += 1;
        }
    }

    var _tixt = $"The journey into the Mars Catacombs was a success.  Your {_techs_alive} remaining {obj_ini.player_role_data[eROLE.TECHMARINE].role}s were useful to the Mechanicus force and return with a bounty.  They await retrieval at {_orbiting.name()}.\n";
    _tixt += $"\n{_found_requisition} Requisition from salvage";
    if (_found_artifact > 0) {
        _tixt += $"\n{string_plural("Unidentified Artifacts", _found_artifact)}  recovered";
    }
    if (_found_stc > 0) {
        _tixt += $"\n{string_plural("STC Fragment", _found_stc)}  recovered";
    }

    if (_tech_point_gain) {
        _tixt += $"\n{string_plural("Tech Point", _tech_point_gain)}  recovered";
    }

    scr_popup("Mechanicus Mission Completed", _tixt, "mechanicus", "");
    _tixt = $"Mechanicus Mission Completed: {_techs_alive}/{_techs_alive+_techs_lost} of your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s return with ";
    _tixt += string(_found_requisition) + " Requisition, ";
    if (_found_artifact > 0) {
        _tixt += $"\n{_found_artifact} : {string_plural("Unidentified Artifacts", _found_artifact)}  recovered";
    }
    if (_found_stc > 0) {
        _tixt += $"\n{_found_stc} : {string_plural("STC Fragment", _found_stc)}  recovered";
    }
    if (_tech_point_gain) {
        _tixt += $"\n{_tech_point_gain} {string_plural("Tech Point", _tech_point_gain)}  gained";
    }
    scr_event_log("green", _tixt);

    sort_all_companies_to_map(_cleanup);

    delete_mission = true;
}

}







