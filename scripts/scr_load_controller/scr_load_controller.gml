function default_bat_formation() {
    if (bat_formation[1] == "" && obj_controller.bat_formation_type[1] == 0) {
        obj_controller.bat_formation[1] = "Attack";
        obj_controller.bat_formation_type[1] = 1;

        obj_controller.bat_formation[2] = "Defend";
        obj_controller.bat_formation_type[2] = 1;

        obj_controller.bat_formation[3] = "Raid";
        obj_controller.bat_formation_type[3] = 2;
    }
    sanitize_stored_formation_ids();
}

/// @desc Validates stored formation ids, resetting stale ones to defaults.
/// @returns {undefined}
function sanitize_stored_formation_ids() {
    var _attack_id = obj_controller.last_attack_form;
    var _attack_valid = ((_attack_id >= 0) && (_attack_id < array_length(obj_controller.bat_formation)) && (obj_controller.bat_formation[_attack_id] != "") && (obj_controller.bat_formation_type[_attack_id] == 1));
    if (!_attack_valid) {
        obj_controller.last_attack_form = 1;
    }
    var _raid_id = obj_controller.last_raid_form;
    var _raid_valid = ((_raid_id >= 0) && (_raid_id < array_length(obj_controller.bat_formation)) && (obj_controller.bat_formation[_raid_id] != "") && (obj_controller.bat_formation_type[_raid_id] == 2));
    if (!_raid_valid) {
        obj_controller.last_raid_form = 3;
    }
}
