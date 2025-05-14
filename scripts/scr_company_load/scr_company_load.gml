function scr_company_load(ship_loc) {
    // load all ships at a particular location.
    with (obj_controller){
    reset_ship_manage_arrays();

    var ships = array_length(obj_ini.ship_data);
    for (var i = 0; i < ships; i++) {
        var _ship = obj_ini.ship_data[selecting_ship];
        if (obj_ini.ship[i] != "" && _ship.location == ship_loc){
            array_push(sh_ide, i);
            array_push(sh_name, obj_ini.ship[i]);
            array_push(sh_class, _ship.class);
            array_push(sh_loc, _ship.location);
            array_push(sh_uid, obj_ini.ship_uid[i]);
            array_push(sh_hp, $"{round(_ship.hp / _ship.max_hp) * 100}% HP")
            array_push(sh_cargo, _ship.carrying);
            array_push(sh_cargo_max, _ship.capacity);
        }
    }

    ship_current = 0;
    ship_max = array_length(sh_ide);
    ship_see = 30;
    }

}
