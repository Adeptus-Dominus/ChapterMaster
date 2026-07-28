function scr_count_forces(_unit_location, _target_location, _is_planet, _return_as_array = false) {
    if (!_is_planet) {
        return;
    }

    var _marine_count = 0;
    var _vehicle_count = 0;
    var _max_companies = 11;
    var _safety_limit = 500;

    for (var _company = 0; _company < _max_companies; _company++) {
        var _veh_race = obj_ini.veh_race[_company];
        var _veh_loc = obj_ini.veh_loc[_company];
        var _veh_wid = obj_ini.veh_wid[_company];
        var _veh_len = array_length(_veh_race);

        for (var i = 0; i < _safety_limit; i++) {
            var _unit = fetch_unit([_company, i]);
            var _marine_exists = is_struct(_unit) && _unit.name() != "";
            var _vehicle_exists = i < _veh_len;

            if (!_marine_exists && !_vehicle_exists) {
                break;
            }

            if (_marine_exists && _unit.race() == 1 && _unit.location_string == _unit_location && _unit.planet_location == _target_location) {
                _marine_count++;
            }

            if (_vehicle_exists && _veh_race[i] == 1 && _veh_loc[i] == _unit_location && _veh_wid[i] == _target_location) {
                _vehicle_count++;
            }
        }
    }

    if (_return_as_array) {
        return [
            _marine_count,
            _vehicle_count,
        ];
    } else {
        if (instance_exists(obj_turn_end)) {
            obj_turn_end.info_mahreens = _marine_count;
            obj_turn_end.info_vehicles = _vehicle_count;
        }
    }
}
