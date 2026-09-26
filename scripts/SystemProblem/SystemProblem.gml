/// @param {sring} name
/// @param {struct} data
function SystemProblem(name, data = {}, system){
timer = -1;
f_type = eP_FEATURES.MISSION;
p_id = name;
data = data;
stage_id = "";
self.system = system;
zero_timer_checks = true;
delete_mission = false;
members = [];
if (struct_exists(data, "stage")){
    stage_id = data.stage;
}
if (struct_exists(data, "members")){
    members = data.members;
}

static handle_triggered_mission_func = function(func){
    if (!is_undefined(func)){
        try {
            func();
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    }
    if (timer == -1 || (delete_mission)){
        var _prob = -1;
        for (var i = 0; i < array_length(system.system_problems); i++){
            if (system.system_problems[i] == self){
                _prob = i;
            }
        }
        if (_prob > -1){
            array_delete(system.system_problems, _prob,1);
        }
    }
}

static basic_turn_end = function(){
    if (system.storm - 1 > 0){
        timer--;
    }
    if ((timer > -1) && per_turn_checks) {
        var _func = undefined;
        /*switch(p_id){
        }*/
        handle_triggered_mission_func(_func)
    }
    if ((timer == 0) && zero_timer_checks && !delete_mission) {
        var _func = undefined;
        switch(p_id){
            case "great_crusade":
                _func = resolve_great_crusade;
                break;
        }
        handle_triggered_mission_func(_func)
    }
}

static mark = function(colour){
    with (system){
        new_star_event_marker(colour)
    }
}

static init = function(){
    switch(p_id){
        case "great_crusade":
        init_great_crusade();
        break;
    }   
}

static init_great_crusade = function(){
    //TODO decide the target/purpose of the crusade to create more variety and to help with post crusade rewards
    var _nearest_player_fleet = data.nearest_player_fleet;
    var _travel_leeway = 10;
    if (_nearest_player_fleet.action == "move") {
        _travel_leeway += _nearest_player_fleet.action_eta;
    }
    timer = get_viable_travel_time(_travel_leeway, _nearest_player_fleet.x, _nearest_player_fleet.y, system.x, system.y, _nearest_player_fleet, false);
    scr_popup("Crusade", $"Fellow Astartes legions are preparing to embark on a Crusade to a nearby sector.  Your forces are expected at {system.name}; {timer} months from now your ships there shall begin their journey.", "crusade", "");
    mark("green")
    scr_event_log("", $"A Crusade is called; our forces are expected at {system.name} in {timer} months.", star_id.name);
}

static resolve_great_crusade = function() {
    var _player_fleet = scr_orbiting_player_fleet(system);

    if (_player_fleet != -1) {
        var _crusade_direction = point_direction(room_width / 2, room_height / 2, system.x, system.y);
        with (_player_fleet) {
            action_x = x + lengthdir_x(1200, _crusade_direction);
            action_y = y + lengthdir_y(1200, _crusade_direction);
            set_fleet_movement(false, "crusade1");
        }

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
}

}