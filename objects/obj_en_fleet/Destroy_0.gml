/*if (owner = eFACTION.Chaos){
    show_message("Trade Goods: "+string(trade_goods)+"#Alarms: "+string(alarm[0])+"|"+string(alarm[1])+"|"+string(alarm[2])+"|"+string(alarm[4]));
}*/

if ((action == "") && (orbiting != 0)) {
    if (orbiting == instance_nearest(x, y, obj_star)) {
        orbiting.present_fleet[owner] -= 1;
    }
    orbiting = 0;
}

if (instance_exists(obj_controller)) {
    if (fleet_has_cargo("warband") && (obj_controller.faction_defeated[10] == 0)) {
        destroy_khorne_fleet();
    }
    if (fleet_has_cargo("ork_warboss") && (obj_controller.faction_defeated[7] <= 0) && (safe == 0)) {
        obj_controller.faction_defeated[7] = 1;
        scr_event_log("", "Enemy Leader Assassinated: Ork Warboss");
        if (instance_exists(obj_turn_end)) {
            scr_alert("", "ass", "Warboss " + string(obj_controller.faction_leader[eFACTION.Ork]) + " has been killed.", 0, 0);
        }
    }
}

/* */
/*  */
