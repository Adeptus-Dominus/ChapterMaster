/// @param {string} _name
/// @param {Asset.GMObject.obj_star} _system
/// @param {struct} _data
/// @param {Real} _timer
function SystemProblem(_name, _system = noone, _data = {}, _timer = -1) : Problem(_name, _timer, _data) constructor{
system = _system;

//base only assigns members when data.members exists; default it here without clobbering that
if (!variable_struct_exists(self, "members")){
    members = [];
}

zero_timer_checks = true;
per_turn_checks = true;


static __check_delete = function(){
    if (timer == -1 || (delete_mission)){
        var _prob = -1;
        for (var i = 0; i < array_length(system.problems); i++){
            if (system.problems[i] == self){
                _prob = i;
            }
        }
        if (_prob > -1){
            array_delete(system.problems, _prob, 1);
        }
    }   
}

static __handle_triggered_mission_func = function(func){
    if (!is_undefined(func)){
        try {
            func();
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    }
    __check_delete();
}

static basic_turn_end = function(){
    if (system.storm <= 0){
        timer--;
    }
    if ((timer > -1) && per_turn_checks) {
        var _func = find_func("per_turn");
        __handle_triggered_mission_func(_func);
    }
    if ((timer == 0) && zero_timer_checks && !delete_mission) {
        var _func = find_func("resolve");
        __handle_triggered_mission_func(_func);
    }
}


static find_func = function(trigger_string){
    var _func_string = find_func_ref(trigger_string);
    if (struct_exists(self,_func_string)){
        return self[$ _func_string]
    }
    return undefined;
}

static mark = function(colour){
    with (system){
        new_star_event_marker(colour)
    }
}

static __init = function(){
    var _func = find_func("init");
    if (!is_undefined(_func)){
        __handle_triggered_mission_func(_func);
    }  
}

__init();

static __great_crusade_init = function(){
    if (system == noone){
        system = scr_random_find(2, true, "", "");
        if (system == noone) {
            delete_mission = true;
            LOGGER.error("RE: Crusade, couldn't find a star for the crusade");
            exit;
        }
        array_push(system.problems ,self);  
    }
    //TODO decide the target/purpose of the crusade to create more variety and to help with post crusade rewards
    var _nearest_player_fleet = get_nearest_player_fleet(system.x, system.y);
    if (_nearest_player_fleet == noone){
        delete_mission = true;
        exit;
    }
    var _travel_leeway = 10;
    if (_nearest_player_fleet.action == "move") {
        _travel_leeway += _nearest_player_fleet.action_eta;
    }
    timer = get_viable_travel_time(_travel_leeway, _nearest_player_fleet.x, _nearest_player_fleet.y, system.x, system.y, _nearest_player_fleet, false);
    scr_popup("Crusade", $"Fellow Astartes legions are preparing to embark on a Crusade to a nearby sector.  Your forces are expected at {system.name}; {timer} months from now your ships there shall begin their journey.", "crusade", "");
    mark("green")
    scr_event_log("", $"A Crusade is called; our forces are expected at {system.name} in {timer} months.", system.name);
}

static __great_crusade_resolve = function() {
    var _player_fleet = system.get_orbiting_player_fleet();

    if (_player_fleet != noone) {
        _player_fleet.add_problem("great_crusade",infinity, {});

        scr_alert("green", "crusade", "Fleet embarks upon Crusade.", system.x, system.y);
        scr_event_log("", "Fleet embarks upon Crusade.");
    } else {
        // hit loyalty here
        alter_dispositions([[eFACTION.INQUISITION, -10], [eFACTION.IMPERIUM, -5]]);
        var _string = $"No ships designated for Crusade.";
        if (obj_controller.penitent == 1) {
            obj_controller.penitent_current = 0;
            _string += "Your penitence crusade has been lengthened for your failings";
        }

        scr_alert("red", "crusade", _string, system.x, system.y);
        scr_loyalty("Refusing to Crusade", "+");
        scr_event_log("red", "No ships designated for Crusade.");
    }
    delete_mission = true;
}

static __hunt_inquisitor_init = function(){
    LOGGER.info("RE: Inquisitor Hunt");


    if (system == noone) {
        var _stars = scr_get_stars();

        if (array_length(_stars) == 0) {
            delete_mission = true;
            exit;
            LOGGER.error("RE: Inquisitor Hunt,couldn't find a _star");
            exit;
        }

        system = array_random_element(_stars);
        array_push(system.problems, self);
    }

    var _gender = set_gender();
    var _name = global.name_generator.GenerateFromSet($"imperial_{string_gender()}");

    var _eta = scr_mission_eta(system.x, system.y, 1);
    _eta = max(_eta, 8);
    timer = _eta
    var _text = $"The Inquisition is trusting you with a special mission.  A radical inquisitor named {_name} will be visiting the {system.name} system in {_eta} month's time.  They are highly suspect of heresy, and as such, are to be put down.  Can your chapter handle this mission?";
    if (obj_controller.demanding) {
        _text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  A radical inquisitor is enroute to {system.name}, expected within {_eta} months.  They are to be silenced and removed.";
    }

    data.inquisitor_name = _name;
    data.inquisitor_gender = _gender;
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    scr_popup("Inquisition Mission", _text, "inquisition", _pop_data);    
}

static __hunt_inquisitor_accept = function(){

    scr_event_log("", $"Inquisition Mission Accepted: The radical Inquisitor {data.inquisitor_name} enroute to {system.name} must be removed.  Estimated arrival in {timer} months.", system.name);

    var _radical_inquisitor_fleet = create_enemy_fleet(system.x - irandom_range(-400, 400), system.y - irandom_range(-400, 400), eFACTION.INQUISITION);
    with (_radical_inquisitor_fleet) {
        base_inquis_fleet();
    }
    _radical_inquisitor_fleet.action_x = system.x;
    _radical_inquisitor_fleet.action_y = system.y;
    _radical_inquisitor_fleet.move(false, "move", timer, timer);
    data.target_name = system.name;
    _radical_inquisitor_fleet.add_problem("radical_inquisitor", timer, data);

    delete_mission = true;
    reset_popup_options();
    exit;
}

}