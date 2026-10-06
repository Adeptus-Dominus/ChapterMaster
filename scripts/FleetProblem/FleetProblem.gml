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
/// @param {Id.Instance.obj_p_fleet} |  {Id.Instance.obj_en_fleet} _fleet
function FleetProblem(_name, _timer = -1, _data = {}, _fleet = noone) : Problem(_name, _timer, _data) constructor{
fleet = _fleet;

static __refresh_data = function(){
    if (!instance_exists(fleet)){
        delete_mission = true;
    }
}

per_turn_checks = true;

static save = function(){
    var _save_copy = variable_clone(self);
    struct_remove(_save_copy, "fleet");
    __save_members(_save_copy)
    return _save_copy;
}

//the owning fleet must re-attach itself after loading (problem.fleet = self)
static load = function(data){
    move_data_to_current_scope(data);
    __load_members();
}

static __check_delete = function(){
    if (timer == -1 || (delete_mission)){
        if (!instance_exists(fleet)){
            exit;
        }
        var _prob = -1;
        for (var i = 0; i < array_length(fleet.problems); i++){
            if (fleet.problems[i] == self){
                _prob = i;
            }
        }
        if (_prob > -1){
            array_delete(fleet.problems, _prob, 1);
        }
    }
}

//runs the entry point with fleet_event_data available for the duration of the call
static __trigger_with_event = function(trigger_string, _event_data = {}){
    var _func = find_func(trigger_string);
    if (is_undefined(_func)){
        exit;
    }
    fleet_event_data = _event_data;
    __handle_triggered_mission_func(_func);
    struct_remove(self, "fleet_event_data");
}

static basic_turn_end = function(){
    timer--;
    if ((timer > -1) && per_turn_checks) {
        var _func = find_func("per_turn");
        __handle_triggered_mission_func(_func);
    }
    __check_delete();
}

/// @param {Id.Instance.obj_star} star
static on_arrival = function(){
    __trigger_with_event("on_arrival");
}

/// @param {Id.Instance.obj_p_fleet} new_fleet
static on_split = function(new_fleet){
    __trigger_with_event("on_split", {new_fleet});
}

static on_waypoint_arrival = function(){
    __trigger_with_event("on_waypoint_arrival");
}

/// @param {Id.Instance.obj_p_fleet} merged_fleet
static on_merge = function(merged_fleet){
    __trigger_with_event("on_merge", {merged_fleet});
}

//call this before the fleet instance is destroyed
static on_destruction = function(){
    __trigger_with_event("on_destruction");
    delete_mission = true;
    __check_delete();
}

static __default_mission_log_entry = function(){
    if (!instance_exists(fleet)){
        return undefined;
    }
    if (stage_id == "preliminary") {
        return undefined;
    }
    var _data = {
        system: fleet_location_description(fleet).loc,
        mission: description(),
        time: timer,
        problem: self,
    };

    _data.click_left = method(_data, function() {
        set_map_pan_to_loc(problem.fleet);
    });

    return _data;
}

static __init = function(){
    if (p_id == ""){
        exit;
    }
    var _func = find_func("init");
    if (!is_undefined(_func)){
        __handle_triggered_mission_func(_func);
    }
}
}

function load_fleet_problems(_problem_constructor, _save_data){
    // Problems, old saves won't have this key
    problems = [];
    if (struct_exists(_save_data, "problems")) {
        for (var i = 0; i < array_length(_save_data.problems); i++) {
            try {
                // empty p_id stops __init from running, load() theadn restores the real p_id and timer
                var _problem = new _problem_constructor("", 0, {}, self);
                _problem.load(_save_data.problems[i]);
                _problem.fleet = self;
                array_push(problems, _problem);
            } catch (e) {
                LOGGER.exception("Fleet problem deserialization failed", e);
            }
        }
    }
}
function add_fleet_problem(_p_id, _timer = -1, _data = {}){
    var _instance = object_index == obj_en_fleet ? AiFleetProblem : PlayerFleetProblem;
    var _problem = new _instance(_p_id, _timer, _data, self);
    if (_problem.delete_mission) return undefined;
    array_push(problems, _problem);
    return _problem;
}


function fleet_problems_to_mission_log(){
    var _temp_log = []
    for (var i = 0; i < array_length(problems); i++) {
        var _mission_data = problems[i].mission_log_entry();
        array_push(_temp_log, _mission_data);
    }

    return _temp_log;
}






