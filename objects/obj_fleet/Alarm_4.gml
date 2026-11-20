with (obj_p_ship) {
    instance_destroy();
}
with (obj_p_th) {
    instance_destroy();
}
with (obj_en_ship) {
    instance_destroy();
}
with (obj_en_in) {
    instance_destroy();
}
with (obj_al_ship) {
    instance_destroy();
}
with (obj_al_in) {
    instance_destroy();
}
with (obj_fleet_controller) {
    instance_destroy();
}
with (obj_p_round) {
    instance_destroy();
}
with (obj_en_round) {
    instance_destroy();
}
with (obj_al_round) {
    instance_destroy();
}
with (obj_p_assra) {
    instance_destroy();
}
with (obj_en_husk) {
    instance_destroy();
}

instance_activate_all();
recalculate_fleet_presence();
obj_controller.combat = 0;
instance_activate_object(obj_turn_end);

if (player_started == 0) {
    with (obj_turn_end) {
        current_battle += 1;
        alarm[0] = 1;
    }
}
if (player_started == 1) {
    var taxt = string(global.chapter_name) + " engage and destroy a";
    if ((engaged_faction == 2) || (engaged_faction == 4) || (engaged_faction == 5) || (engaged_faction == 6)) {
        taxt += "n";
    }
    taxt += " " + string(obj_controller.faction[engaged_faction]);
    taxt += " fleet at " + string(ene_fleet.name) + ".";
    scr_event_log("", taxt);

    if (instance_exists(obj_star_select)) {
        with (obj_star_select) {
            alarm[1] = 1;
            player_fleet = 0;
        }
    }
    if (instance_exists(pla_fleet)) {
        pla_fleet.acted = 2;
        if (capital + frigate + escort == 0) {
            with (pla_fleet) {
                instance_destroy();
            }
        }
    }
    if ((engaged_faction != eFACTION.INQUISITION) && (obj_controller.faction_status[engaged_faction] != "War")) {
        scr_audience(engaged_faction, "declare_war", obj_controller.disposition[engaged_faction] - 20, "War", 3, 2);
    }
}

if (view_x + view_y > 0) {
    obj_controller.x = view_x;
    obj_controller.y = view_y;
}

with (obj_controller) {
    instance_activate_all();
}
instance_destroy();
