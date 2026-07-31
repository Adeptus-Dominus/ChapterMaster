// right here check for artifacts to be moved

if (capital_number == 0) {
    exit;
}
var c = 0;
var good = 0;
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
    var _art_keys = struct_get_names(obj_ini.artifact_map);
    for (var _i = 0; _i < array_length(_art_keys); _i++) {
        var arti = obj_ini.artifact_map[$ _art_keys[_i]];
        if (!arti.is_equipped() && array_contains(ships_list, arti.get_ship_id())) {
            arti.set_sid(c);
            arti.set_location_name(obj_ini.ship[c]);
        }
    }
}
