if ((action == "") && instance_exists(orbiting)) {
    fleet_unregister_from_star(id);
}

if (instance_exists(obj_controller)) {
    if (fleet_has_cargo("warband") && (obj_controller.faction_defeated[10] == 0)) {
        destroy_khorne_fleet();
    }
    if (fleet_has_cargo("ork_warboss") && (obj_controller.faction_defeated[7] <= 0) && (safe == 0)) {
        obj_controller.faction_defeated[7] = 1;
        scr_event_log("", "Enemy Leader Assassinated: Ork Warboss");
        if (instance_exists(obj_turn_end)) {
            scr_alert("", "ass", "Warboss " + string(obj_controller.faction_leader[eFACTION.ORK]) + " has been killed.", 0, 0);
        }
    }
}
