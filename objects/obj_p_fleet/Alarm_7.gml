


// right here check for artifacts to be moved

if (capital_number == 0) { exit; }
var c = "", good = 0;
var _capital;
var capital_list = fleet_full_ship_array(, , true, true);
for (var i = 0; i < array_length(capital_list); i++) { // Find the healthiest capital ship
    var _capital_struct = fetch_ship(capital_list[i]);
    if (capital.health.hp > good) {
        _capital = _capital_struct.UUID;
        good = capital.health.hp;
    }
}

if (good > 0) {
    var ships_list = fleet_full_ship_array(, true);
    for (var a = 0; a < array_length(obj_ini.artifact); a++) {
        if (obj_ini.artifact[a] == "") { continue; }
        if (array_contains(ships_list, obj_ini.artifact_sid[a].ship)) {
            var _arti_struct = obj_ini.artifact_struct[a];
            _arti_struct.set_ship_id(_capital);
        }
    }
}
