function add_event_to_fleet(event , fleet){
	event.fleet_uid = fleet.uid;
	array_push(fleet.events, event);
}



function FleetEvent(_event_data) constructor{

	self.fleetevent_data = _event_data;
	
	static load_json_data = function(data){	
		 var names = variable_struct_get_names(data);
		 for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]))
        }
	}

	timer = -1;

	state = "increment";

	static turn_sequence = function(){
        if (struct_exists(self , "turn_end")){
        	call_fleet_event_function(turn_end);
        }

        if (struct_exists(self , "timer") && timer > 0){
            timer--;

            if (timer == 0 ){
                if (struct_exists(self,"timer_end")){
                    call_fleet_event_function(timer_end);
                }
                state = "destroy";
            }
        }
	}

	static destroy_sequence = function(){
        if (struct_exists(self , "destroy")){
        	call_fleet_event_function(destroy);
        }		
	}

	static call_fleet_event_function = function(_func_name){
		if (struct_exists(fleet_event_functions,_func_name)){
			fleet_event_functions[$ _func_name]();
		}
	}

	static fleet_event_functions = {
		"deliver_trophy_mission_timed_out" : deliver_trophy_mission_timed_out,
		"deliver_trophy_mission_fleet_destroyed" : deliver_trophy_mission_fleet_destroyed,
		"deliver_trophy_end_turn_check" :deliver_trophy_end_turn_check,
		"mech_fleet_explore_battle_grounds":mech_fleet_explore_battle_grounds
	}


}