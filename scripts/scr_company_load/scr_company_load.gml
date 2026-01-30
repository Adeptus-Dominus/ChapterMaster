function scr_company_load(ship_loc) {
    // load all ships at a particular location.
    with (obj_controller) {
        reset_ship_manage_arrays();

        var ships = array_length(obj_ini.ship);
        for (var i = 0; i < ships; i++) {
            if (obj_ini.ship[i] != "" && obj_ini.ship_location[i] == ship_loc) {
                array_push(sh_ide, i);
                array_push(sh_name, obj_ini.ship[i]);
                array_push(sh_class, obj_ini.ship_class[i]);
                array_push(sh_loc, obj_ini.ship_location[i]);
                array_push(sh_uid, obj_ini.ship_uid[i]);
                array_push(sh_hp, $"{round(obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i]) * 100}% HP");
                array_push(sh_cargo, obj_ini.ship_carrying[i]);
                array_push(sh_cargo_max, obj_ini.ship_capacity[i]);
            }
        }

        ship_current = 0;
        ship_max = array_length(sh_ide);
        ship_see = 30;
    }
}
