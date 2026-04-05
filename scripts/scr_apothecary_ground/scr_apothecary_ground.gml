#macro PLANET_SLOT_COUNT 5
#macro STAR_INSTANCE_INDEX 5
#macro VEHICLE_MAINTENANCE_SMALL 0.2
#macro VEHICLE_MAINTENANCE_BIG 1
#macro VEHICLE_REPAIR_SMALL 0.2
#macro VEHICLE_REPAIR_BIG 3
#macro VEHICLE_REPAIR_LIMIT 10
#macro UNIT_HEAL_SMALL 1

enum eSYSTEM_LOC {
    ORBIT,
    PLANET1,
    PLANET2,
    PLANET3,
    PLANET4,
}

function calculate_full_chapter_spread() {
    obj_controller.command = 0;
    obj_controller.marines = 0;
    var _mar_loc, is_healer, _is_tech, key_val, veh_location, array_slot, _unit;
    var _tech_spread = {};
    var _apoth_spread = {};
    var _unit_spread = {};
    for (var company = 0; company < 11; company++) {
        var _marine_len = array_length(obj_ini.name[company]);
        var _veh_len = array_length(obj_ini.veh_hp[company]);
        var _company_length = max(_marine_len, _veh_len);

        for (var v = 0; v < _company_length; v++) {
            key_val = "";
            if (v < _marine_len) {
                if (obj_ini.name[company][v] != "") {
                    _unit = fetch_unit([company, v]);
                    _mar_loc = _unit.marine_location();
                    if (_unit.base_group == "astartes") {
                        if (_unit.IsSpecialist()) {
                            obj_controller.command++;
                        } else {
                            obj_controller.marines++;
                        }
                    }
                    tech_points_used += _unit.equipment_maintenance_burden();
                    _is_tech = _unit.IsSpecialist(SPECIALISTS_TECHS);
                    if (_is_tech) {
                        add_forge_points_to_stack(_unit);
                    }
                    is_healer = ((_unit.IsSpecialist(SPECIALISTS_APOTHECARIES, true) && _unit.gear() == "Narthecium") || (_unit.role() == "Sister Hospitaler")) && _unit.hp() >= 10;
                    if (is_healer) {
                        add_apoth_points_to_stack(_unit);
                    }
                    if (_mar_loc[2] != "Warp" && _mar_loc[2] != "Lost") {
                        if (_mar_loc[0] == eLOCATION_TYPES.PLANET) {
                            array_slot = _mar_loc[1];
                        } else if (_mar_loc[0] == eLOCATION_TYPES.SHIP) {
                            array_slot = eSYSTEM_LOC.ORBIT;
                        }
                        key_val = _mar_loc[2];
                    } else if (_mar_loc[0] == eLOCATION_TYPES.SHIP) {
                        if (instance_exists(obj_p_fleet)) {
                            with (obj_p_fleet) {
                                if (array_contains(capital_num, _mar_loc[1]) || array_contains(frigate_num, _mar_loc[1]) || array_contains(escort_num, _mar_loc[1])) {
                                    key_val = $"{id}";
                                    array_slot = eSYSTEM_LOC.ORBIT;
                                    break;
                                }
                            }
                        }
                    }
                    if (key_val != "") {
                        if (!struct_exists(_unit_spread, key_val)) {
                            _unit_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                            _tech_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                            _apoth_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                        }
                        array_push(_unit_spread[$ key_val][array_slot], _unit);
                        if (_is_tech) {
                            array_push(_tech_spread[$ key_val][array_slot], _unit);
                        }
                        if (is_healer) {
                            array_push(_apoth_spread[$ key_val][array_slot], _unit);
                        }
                    }
                }
            }

            key_val = "";
            if (company > 0 && v < _veh_len) {
                if (obj_ini.veh_race[company][v] != 0) {
                    if (obj_ini.veh_lid[company][v] > -1) {
                        veh_location = obj_ini.veh_lid[company][v];
                        var _ship_loc = obj_ini.ship_location[veh_location];
                        if (_ship_loc == "Warp" || _ship_loc == "Lost") {
                            if (instance_exists(obj_p_fleet)) {
                                with (obj_p_fleet) {
                                    if (array_contains(capital_num, veh_location) || array_contains(frigate_num, veh_location) || array_contains(escort_num, veh_location)) {
                                        key_val = string(id);
                                        array_slot = eSYSTEM_LOC.ORBIT;
                                        break;
                                    }
                                }
                            }
                        } else if (obj_ini.ship_location[veh_location] != "") {
                            array_slot = eSYSTEM_LOC.ORBIT;
                            key_val = obj_ini.ship_location[veh_location];
                        }
                    }
                    if (obj_ini.veh_wid[company][v] > 0) {
                        key_val = obj_ini.veh_loc[company][v];
                        if (key_val != "") {
                            array_slot = obj_ini.veh_wid[company][v];
                        }
                    }
                    if (key_val != "") {
                        if (!struct_exists(_unit_spread, key_val)) {
                            _unit_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                            _tech_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                            _apoth_spread[$ key_val] = [
                                [],
                                [],
                                [],
                                [],
                                []
                            ];
                        }
                        array_push(_unit_spread[$ key_val][array_slot], [company, v]);
                    }
                }
            }
        }
    }
    return [_tech_spread, _apoth_spread, _unit_spread];
}

function single_loc_point_data() {
    return {heal_points_use: 0, heal_points: 0, forge_points_use: 0, forge_points: 0};
}

function system_point_data_spawn() {
    var _single_point_pos = single_loc_point_data();
    return [variable_clone(_single_point_pos), variable_clone(_single_point_pos), variable_clone(_single_point_pos), variable_clone(_single_point_pos), variable_clone(_single_point_pos)];
}

/// @mixin
function process_specialist_points() {
    var _spreads = chapter_spread();
    var _tech_spread = _spreads[0];
    var _apoth_spread = _spreads[1];
    var _unit_spread = _spreads[2];

    var _locations = struct_get_names(_unit_spread);
    var _loc_count = array_length(_locations);

    // --- Step 1: Map Stars to Locations ---
    var _gene_seed_empty = obj_controller.gene_seed <= 0 && obj_controller.recruiting > 0;

    with (obj_star) {
        var _in_spread = variable_struct_exists(_unit_spread, name);

        if (!_in_spread) {
            if (_gene_seed_empty && system_feature_bool(self.p_feature, eP_FEATURES.RECRUITING_WORLD)) {
                obj_controller.recruiting = 0;
                scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);
                _gene_seed_empty = false;
            }
            continue;
        }
        array_push(_unit_spread[$ name], self);
    }

    // --- Step 2: Process Locations ---
    for (var i = 0; i < _loc_count; i++) {
        var _cur_loc = _locations[i];
        var _loc_slots = _unit_spread[$ _cur_loc];
        var _star_inst = (array_length(_loc_slots) > STAR_INSTANCE_INDEX) ? _loc_slots[STAR_INSTANCE_INDEX] : pointer_null;

        if (_star_inst != pointer_null) {
            point_breakdown.systems[$ _star_inst.name] = system_point_data_spawn();
        }

        for (var _p = 0; _p < PLANET_SLOT_COUNT; _p++) {
            var _cur_units = _loc_slots[_p];
            var _unit_count = array_length(_cur_units);
            if (_unit_count == 0) {
                continue;
            }

            var _cur_apoths = _apoth_spread[$ _cur_loc][_p];
            var _cur_techs = _tech_spread[$ _cur_loc][_p];

            var _pool = {
                heal: 0,
                forge: 0,
            };

            // Calculate Generation
            for (var a = 0, _al = array_length(_cur_apoths); a < _al; a++) {
                _pool.heal += _cur_apoths[a].apothecary_point_generation(turn_end)[0];
            }
            for (var t = 0, _tl = array_length(_cur_techs); t < _tl; t++) {
                _pool.forge += _cur_techs[t].forge_point_generation(turn_end)[0];
            }

            var _initial_heal = _pool.heal;
            var _initial_forge = _pool.forge;

            // Process Maintenance and Repairs/Heal
            for (var u = 0; u < _unit_count; u++) {
                var _unit = _cur_units[u];
                if (is_array(_unit)) {
                    _process_vehicle_maintenance(_unit, _pool);
                } else if (is_struct(_unit)) {
                    _process_marine_maintenance(_unit, _pool);
                }
            }

            // Record Stats
            var _stats = {
                heal_points: _initial_heal,
                forge_points: _initial_forge,
                heal_points_use: _initial_heal - _pool.heal,
                forge_points_use: _initial_forge - _pool.forge,
            };

            if (_star_inst != pointer_null) {
                point_breakdown.systems[$ _star_inst.name][_p] = _stats;

                // Planet specific logic (Orbit is 0, Planets are 1-4)
                if (turn_end && _p > 0 && array_length(_star_inst.p_feature[_p]) > 0) {
                    var _planet_data = new PlanetData(_p, _star_inst);
                    _planet_data.recover_starship(_cur_techs);
                    _planet_data.planet_training(_pool.heal);
                }
            } else if (_p == 0 && string_pos("ref instance", _cur_loc) > 0) {
                _handle_instance_point_recording(_cur_loc, _stats);
            }
        }
    }

    forge_string += $"Equipment Maintenance : -{tech_points_used}#";

    /// @param {Array} _unit
    /// @param {Struct} _pool
    static _process_vehicle_maintenance = function(_unit, _pool) {
        if (_pool.forge <= 0) {
            return;
        }

        var _co = _unit[0];
        var _idx = _unit[1];
        var _role = obj_ini.veh_role[_co][_idx];

        if (_role == "Land Raider") {
            forge_veh_maintenance.land_raider = (forge_veh_maintenance[$ "land_raider"] ?? 0) + VEHICLE_MAINTENANCE_BIG;
            _pool.forge -= VEHICLE_MAINTENANCE_BIG;
            tech_points_used += VEHICLE_MAINTENANCE_BIG;
        } else if (array_contains(["Rhino", "Predator", "Whirlwind"], _role)) {
            forge_veh_maintenance.small_vehicles = (forge_veh_maintenance[$ "small_vehicles"] ?? 0) + VEHICLE_MAINTENANCE_SMALL;
            _pool.forge -= VEHICLE_MAINTENANCE_SMALL;
            tech_points_used += VEHICLE_MAINTENANCE_SMALL;
        }

        var _repairs_done = 0;
        while (_repairs_done < VEHICLE_REPAIR_LIMIT && obj_ini.veh_hp[_co][_idx] < 100 && _pool.forge >= VEHICLE_REPAIR_SMALL) {
            if (turn_end) {
                obj_ini.veh_hp[_co][_idx]++;
            }

            forge_veh_maintenance.repairs += VEHICLE_REPAIR_SMALL;
            _pool.forge -= VEHICLE_REPAIR_SMALL;
            tech_points_used += VEHICLE_REPAIR_SMALL;
            _repairs_done++;
        }
    };

    /// @param {Struct.TTRPG_stats} _unit
    /// @param {Struct} _pool
    static _process_marine_maintenance = function(_unit, _pool) {
        // Equipment burden is always deducted if possible
        var _burden = _unit.equipment_maintenance_burden();
        _pool.forge -= _burden;
        tech_points_used += _burden;

        if (_unit.hp() >= _unit.max_health()) {
            return;
        }

        if (!_unit.is_dreadnought()) {
            if (_unit.hp() > 0) {
                var _can_heal = _pool.heal >= UNIT_HEAL_SMALL;
                if (turn_end) {
                    _unit.healing(_can_heal);
                }

                if (_can_heal) {
                    _pool.heal -= UNIT_HEAL_SMALL;
                    apothecary_points_used += UNIT_HEAL_SMALL;
                }
            } else if (_unit.bionics < 10) {
                _unit.add_bionics();
            }
        } else if (_pool.heal >= UNIT_HEAL_SMALL && _pool.forge >= VEHICLE_REPAIR_BIG && _unit.hp() > 0) {
            // Dreadnoughts require both specialists
            if (turn_end) {
                _unit.healing(true);
            }

            _pool.heal -= UNIT_HEAL_SMALL;
            _pool.forge -= VEHICLE_REPAIR_BIG;
            apothecary_points_used += UNIT_HEAL_SMALL;
            tech_points_used += VEHICLE_REPAIR_BIG;
        }
    };

    static _handle_instance_point_recording = function(_loc_str, _stats) {
        try {
            var _inst_id = real(string_digits(_loc_str));
            if (instance_exists(_inst_id)) {
                _inst_id.point_breakdown = _stats;
            }
        } catch (_ex) {
            LOGGER.error($"Failed to parse instance ID from location string: {_loc_str} | Error: {_ex.message}");
        }
    };
}
