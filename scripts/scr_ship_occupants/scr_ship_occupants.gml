function scr_ship_occupants(target_ship_id) {
    var unit_list = [];

    // Crew
    for (var co = 0; co < obj_ini.companies; co++) {
        var _co_length = company_length(co);
        for (var i = 0; i < _co_length; i++) {
            var unit = fetch_unit([co, i]);
            if (!is_struct(unit)) {
                continue;
            }
            if (unit.ship_location != target_ship_id) {
                continue;
            }
            array_push(unit_list, unit);
        }
    }
    var occupant_index = new UnitIndex(unit_list);
    var strings_array = occupant_index.create_plural_strings_array();

    // Vehicles (not compatible with UnitIndex - tally role strings directly)
    var veh_index = {};
    var veh_keys = [];
    for (var co = 0; co < obj_ini.companies; co++) {
        for (var i = 0; i <= 100; i++) {
            if (obj_ini.veh_role[co][i] == "" || obj_ini.veh_lid[co][i] != target_ship_id) {
                continue;
            }
            var veh_role = obj_ini.veh_role[co][i];
            if (!struct_exists(veh_index, veh_role)) {
                veh_index[$ veh_role] = 1;
                array_push(veh_keys, veh_role);
            } else {
                veh_index[$ veh_role] += 1;
            }
        }
    }
    for (var i = 0; i < array_length(veh_keys); i++) {
        var _role = veh_keys[i];
        var _count = veh_index[$ _role];
        if (_count == 1) {
            array_push(strings_array, {str1: _role, bold: true, italic: false});
        } else {
            array_push(strings_array, string_plural_count(_role, _count, false));
        }
    }

    // Build final string
    var blur = "";
    var _total = array_length(strings_array);
    for (var i = 0; i < _total; i++) {
        var entry = strings_array[i];
        blur += is_struct(entry) ? entry.str1 : string(entry);
        blur += (i < _total - 1) ? ", " : ".";
    }

    return blur;
}
