function scr_kill_ship(UUID) {
    try {
        with(obj_ini) {
            var _ship_struct = struct_get(USHIPROOT, UUID);
            var _units_on_ship = _ship_struct.cargo.marine_list;
            for (var i = 0; i < array_length(_units_on_ship); i++) {
                var _unit = fetch_unit(_units_on_ship[i]);
                if (!(irandom(_unit.luck) - 3)) {
                    scr_kill_unit(_units_on_ship[i]);
                    array_remove(_units_on_ship, i, 1);
                    i--;
                }
            }
            for (var co = 0; co <= companies; co++) {
                for (var i = 0; i < array_length(veh_role[co]); i++){
                    if (veh_lid[co][i] == UUID) {
                        reset_vehicle_variable_arrays(co, i);
                    }
                }
            }
            var _ship_loc = _ship_struct.location
            var in_warp = _ship_struct.location == "Warp";
            var _available_ships = [];
            var _ship_fleet = find_ships_fleet(UUID);
            if (!in_warp) {
                var _nearest_star = star_by_name(_ship_loc);
            }

            if (_ship_fleet != "none") {
                delete_ship_from_fleet(UUID, _ship_fleet);
                _available_ships = fleet_full_ship_array(_ship_fleet);
            }

            for (var i = 0; i < array_length(_available_ships); i++){
                var _cur_ship = USHIPROOT[$ _available_ships[i]];
                var _max_space = _cur_ship.cargo.capacity;
                for (var f = 0; f < array_length(_units_on_ship); f++) {
                    if (_cur_ship.cargo.carrying < _max_space) {
                        var _index = _units_on_ship[f];
                        var _unit = fetch_unit(_index);
                        if (_unit.get_unit_size() + _cur_ship.cargo.carrying <= _max_space) {
                            _unit.load_marine(_cur_ship);
                            array_delete(_units_on_ship, _index, 1);
                            f--;
                        }
                    } else {
                        break;
                    }
                }
            }
            scr_uuid_delete_ship(UUID);

            if (!in_warp && _nearest_star != "none") {
                for (var i = 0; i < array_length(_units_on_ship); i++) {
                    var _unit = fetch_unit(_units_on_ship[i]);
                    if (irandom(100) > 100 - _unit.luck) {
                        _unit.unload(irandom_range(1, _nearest_star.planets), _nearest_star);
                    }
                }
            }

            for (var i = 0; i < array_length(_units_on_ship); i++){
                scr_kill_unit(_units_on_ship[i]);
            }
        }
    } catch(_exception) {
        handle_exception(_exception);
    }
}

function scr_ini_ship_cleanup() {
    // If the ship is dead then make it fucking dead man
    with(obj_ini) {
        var _ship_UUIDs = struct_get_names(USHIPROOT);
        var _ship_count = array_length(_ship_UUIDs);
        if (_ship_count) {
            for (var i = 0; i < _ship_count; i++) {
                if (UUID_ship[$ _ship_UUIDs[i]].health.hp <= 0) {
                    scr_kill_ship(_ship_UUIDs[i]);
                }
            }
        }
        sort_all_companies();
    }
}
