// right here check for artifacts to be moved

if (capital_number == 0) {
    exit;
}
var c = 0, good = 0;
var capital_id;
var capital_list = fleet_full_ship_array(,, true, true);
for (var i = 0; i < array_length(capital_list); i++) {
    // Find the healthiest capital ship
    capital_id = capital_list[i];
    if (obj_ini.ship[capital_id] == "") {
        continue;
    }
    if (obj_ini.ship_hp[capital_id] > good) {
        c = capital_id;
        good = obj_ini.ship_hp[capital_id];
    }
}

if (good > 0) {
    var ships_list = fleet_full_ship_array(, true);
    for (var a = 0; a < array_length(obj_ini.artifact); a++) {
        if (obj_ini.artifact[a] == "") {
            continue;
        }
        if (array_contains(ships_list, obj_ini.artifact_sid[a] - 500)) {
            obj_ini.artifact_sid[a] = c + 500;
            obj_ini.artifact_loc[a] = obj_ini.ship[c];
        }
    }
}
