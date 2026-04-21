function scr_count_forces(_unit_location, _target_location, _is_planet, instance = false) {
    if (_is_planet) {
        var info_mahreens = 0;
        var info_vehicles = 0;
        //For each of the companies (HQ + 10)
        for (var company = 0; company < 11; company++) {
            var i = 0;
            var _unit = fetch_unit([company, i]);
            //For each unit in that company, while unit exists
            //Marines and vehicles get checked AT THE SAME TIME
            //This is possible since array for saving vehicles and marines are separated
            while ((_unit.name() != "" || i < array_length(obj_ini.veh_race[company])) && i < 500) {
                if ((_unit.race() == 1) && (_unit.location_string == _unit_location) && (_unit.planet_location == _target_location)) {
                    info_mahreens++;
                }

                if (i < array_length(obj_ini.veh_race[company])) {
                    if ((obj_ini.veh_race[company][i] == 1) && (obj_ini.veh_loc[company][i] == _unit_location) && (obj_ini.veh_wid[company][i] == _target_location)) {
                        info_vehicles++;
                    }
                }

                i++;
            }
        }
        if (instance) {
            return [info_mahreens, info_vehicles];
        } else {
            if (instance_exists(obj_turn_end)) {
                obj_turn_end.info_mahreens = info_mahreens;
                obj_turn_end.info_vehicles = info_vehicles;
            }
        }
    }
}
