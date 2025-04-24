function scr_company_load(ship_loc) {
    // load all ships at a particular location.
    with (obj_controller) {
    reset_ship_manage_arrays();

    var _ship_UUIDs = struct_get_names(INI_USHIPROOT);
    var _ship_count = array_length(obj_ini.ship);
    for (var i = 0; i < _ship_count; i++) {
        var _ship_struct = fetch_ship(_ship_UUIDs[i]);
        if (_ship_struct.location == ship_loc) {
            array_push(sh_uuid, _ship_UUIDs[i]);
            array_push(sh_name, _ship_struct.name);
            array_push(sh_class, _ship_struct.class);
            array_push(sh_loc, _ship_struct.location);
            array_push(sh_hp, $"{round(_ship_struct.health.hp / _ship_struct.health.maxhp) * 100}% HP")
            array_push(sh_cargo, _ship_struct.cargo.carrying);
            array_push(sh_cargo_max, _ship_struct.cargo.capacity);
        }
    }

    ship_current = 0;
    ship_max = array_length(sh_uuid);
    ship_see = 30;
    }
}
