/// @description Selects a weighted-random target slot from a battle block.
/// @param {Id.Instance.obj_enunit} battle_block The enemy column instance
/// @param {String} target_type "veh", "men", or "medi"
/// @returns {Real|Undefined} The target slot index, or undefined if no valid target found
function scr_target(battle_block, target_type) {
    var _total = 0;

    for (var f = 0; f <= 30; f++) {
        if (battle_block.dudes[f] == "") {
            continue;
        }

        if (target_type == "veh" && battle_block.dudes_vehicle[f] != 1) {
            continue;
        }

        if (target_type == "men" && battle_block.dudes_vehicle[f] != 0) {
            continue;
        }

        _total += battle_block.dudes_num[f];
    }

    if (_total <= 0) {
        return undefined;
    }

    var _roll = floor(random(_total)) + 1;
    var _cumulative = 0;
    for (var f = 0; f <= 30; f++) {
        if (battle_block.dudes[f] == "") {
            continue;
        }

        if (target_type == "veh" && battle_block.dudes_vehicle[f] != 1) {
            continue;
        }

        if (target_type == "men" && battle_block.dudes_vehicle[f] != 0) {
            continue;
        }

        _cumulative += battle_block.dudes_num[f];
        if (_roll <= _cumulative) {
            return f;
        }
    }

    return undefined;
}
