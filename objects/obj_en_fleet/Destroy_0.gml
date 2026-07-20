fleet_unregister_from_star(id);

if (instance_exists(obj_controller)) {
    if (fleet_has_cargo("warband") && (obj_controller.faction_defeated[10] == 0)) {
        destroy_khorne_fleet();
    }

    if (fleet_has_cargo("ork_warboss") && (safe == 0)) {
        var _warboss_alive = false;
        with (obj_star) {
            for (var i = 1; i <= planets; i++) {
                if (planet_feature_bool(p_feature[i], eP_FEATURES.ORKWARBOSS)) {
                    _warboss_alive = true;
                    break;
                }
            }
            if (_warboss_alive) {
                break;
            }
        }

        if (_warboss_alive) {
            struct_remove(cargo_data, "ork_warboss");
        } else {
            obj_controller.faction_defeated[7] = 1;
            scr_event_log("", "Enemy Leader Assassinated: Ork Warboss");
            if (instance_exists(obj_turn_end)) {
                scr_alert("", "ass", $"Warboss {obj_controller.faction_leader[eFACTION.ORK]} has been killed.", 0, 0);
            }
        }
    }
}
