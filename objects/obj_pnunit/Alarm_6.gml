/// @description Handles marines dying on battle

// Remove from ships
// Remove from the controller
// Remove from any planetary bodies

for (var i = 0; i < array_length(unit_struct); i++) {
    if ((marine_dead[i] > 0) && (marine_type[i] != "") && (ally[i] == false)) {
        var unit = unit_struct[i];
        if (!is_struct(unit)) {
            continue;
        }
        if (unit.name() == "") {
            continue;
        }
        var man_size = unit.get_unit_size();

        if (unit.planet_location > 0) {
            obj_ncombat.world_size += man_size;
        }
        if (unit.ship_location > -1) {
            obj_ini.ship_carrying[unit.ship_location] -= man_size;
        }
        scr_kill_unit(unit.company, unit.marine_number);
    }
}

for (var i = 0; i < array_length(veh_type); i++) {
    if ((veh_dead[i] > 0) && (veh_type[i] != "") && (veh_ally[i] == false)) {
        var man_size = scr_unit_size("", veh_type[i], true);

        if (obj_ini.veh_wid[veh_co[i]][veh_id[i]] > -1) {
            obj_ncombat.world_size += man_size;
        }
        if (obj_ini.veh_lid[veh_co[i]][veh_id[i]] > -1) {
            obj_ini.ship_carrying[obj_ini.veh_lid[veh_co[i]][veh_id[i]]] -= man_size;
        }

        destroy_vehicle(veh_co[i], veh_id[i]);
    }
    if ((veh_dead[i] == 0) && (veh_type[i] != "") && (veh_ally[i] == false)) {
        obj_ini.veh_hp[veh_co[i]][veh_id[i]] = veh_hp[i] / veh_hp_multiplier[i];
    }
}
