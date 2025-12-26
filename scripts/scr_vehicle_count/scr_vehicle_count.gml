// Counts the number of total vehicles for the player
// TODO this should be function defined in Chapter struct, or something similar
function scr_vehicle_count(role, location="") {

    var _vehicle_count = 0;
    var _fetch = fetch_deep_array;

    for (var j = 0; j <=obj_ini.companies; j++) {
        for (var i = 0; i < array_length(obj_ini.veh_role[j]); i++) {
            var _array_key = [j, i];

             if (_fetch(obj_ini.veh_role, _array_key) != role){
                continue
             }

             if (location==""){
                _add=true;
            } else if (!is_array(location)){
                _add = _fetch(obj_ini.veh_loc, _array_key) == location;
            } else {
                var _planet = location[1];
                var _ship = location[2]
                var _location = location[0];
                var is_at_loc = false;
                var _loc = _fetch(obj_ini.veh_loc, _array_key);
                var _v_planet = _fetch(obj_ini.veh_wid, _array_key);
                var _v_ship = _fetch(obj_ini.veh_lid, _array_key);
                if (_planet > 0) {
                    if (_loc == _location && _v_planet == _planet) {
                        is_at_loc = true;
                    }
                } else if (_ship > -1) {
                    if (_v_ship == _ship) {
                        is_at_loc = true;
                    }
                } else if (_ship == -1 && _planet == 0) {
                    if (_v_ship > -1) {
                        var _shipstruct = obj_ini.ship_data[selecting_ship];
                        if (_shipstruct.location  == _location) {
                            is_at_loc = true;
                        }
                    } else if (_loc == _location) {
                        is_at_loc = true;
                    }
                }
                _add = is_at_loc;
            }   
            if (!_add){
                continue;
            }              

            _vehicle_count++;
        }
    }
    return _vehicle_count;
}
