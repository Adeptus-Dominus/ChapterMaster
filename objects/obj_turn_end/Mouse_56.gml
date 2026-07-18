//so this only runs if there aren't these types of instances
if (!instance_exists(obj_saveload) && !instance_exists(obj_popup) && !instance_exists(obj_ncombat) && !instance_exists(obj_fleet)) {
    if ((obj_controller.complex_event == true) || instance_exists(obj_temp_meeting)) {
        exit;
    }

    var xxx = 535;
    var yyy = 200;

    if ((cooldown <= 0) && (battle_world[current_battle] == 0) && (combating == 0)) {
        if (scr_hit(xxx + 132, yyy + 354, xxx + 259, yyy + 389, true)) {
            // Run like hell, space
            with (obj_fleet_select) {
                instance_destroy();
            }
            var that = instance_nearest(battle_pobject[current_battle].x, battle_pobject[current_battle].y, obj_p_fleet);
            that.alarm[3] = 1;
            var that2 = instance_create(0, 0, obj_popup);
            that2.type = 99;
            obj_controller.force_scroll = 1;
        }

        if (scr_hit(xxx + 272, yyy + 354, xxx + 399, yyy + 389, true)) {
            // Fight fight fight, space
            var _battle_fleet = battle_pobject[current_battle];
            if (_battle_fleet.capital_number + _battle_fleet.frigate_number + _battle_fleet.escort_number <= 0) {
                alarm[4] = 1;
                exit;
            }

            obj_controller.cooldown = 8000;
            instance_activate_all();

            // Start battle here

            combating = 1;

            var _battle_instance = instance_create(0, 0, obj_fleet);
            _battle_instance.enemy[1] = enemy_fleet[1];
            _battle_instance.enemy_status[1] = -1;

            _battle_instance.en_capital[1] = ecap[1];
            _battle_instance.en_frigate[1] = efri[1];
            _battle_instance.en_escort[1] = eesc[1];

            // Plug in all of the enemies first
            // And then plug in the allies after then with their status set to positive

            var _ship_index = 1;
            for (var g = 2; g <= 6; g++) {
                if (enemy_fleet[g] != 0) {
                    _ship_index += 1;
                    _battle_instance.enemy[_ship_index] = enemy_fleet[g];
                    _battle_instance.enemy_status[_ship_index] = -1;

                    _battle_instance.en_capital[_ship_index] = ecap[g];
                    _battle_instance.en_frigate[_ship_index] = efri[g];
                    _battle_instance.en_escort[_ship_index] = eesc[g];
                }
            }
            for (var g = 1; g <= 6; g++) {
                if (allied_fleet[g] != 0) {
                    _ship_index += 1;
                    _battle_instance.enemy[_ship_index] = allied_fleet[g];
                    _battle_instance.enemy_status[_ship_index] = 1;

                    _battle_instance.en_capital[_ship_index] = acap[g];
                    _battle_instance.en_frigate[_ship_index] = afri[g];
                    _battle_instance.en_escort[_ship_index] = aesc[g];
                }
            }

            if (battle_special[current_battle] == "chaos") {
                _battle_instance.chaos_exp = 1;
            }
            if (battle_special[current_battle] == "BLOOD") {
                _battle_instance.chaos_exp = 2;
            }

            instance_activate_all();
            var stahr = instance_nearest(battle_pobject[current_battle].x, battle_pobject[current_battle].y, obj_star);
            _battle_instance.star_name = stahr.name;

            add_fleet_ships_to_combat(battle_pobject[current_battle], _battle_instance);

            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            instance_activate_object(_battle_instance);
            instance_activate_object(obj_cursor);
        }
    }

    if ((cooldown <= 0) && (battle_world[current_battle] > 0) && (combating == 0)) {
        var tip = "";

        if (scr_hit(xxx + 132, yyy + 354, xxx + 259, yyy + 389, true)) {
            tip = "offensive";
        }

        if (scr_hit(xxx + 272, yyy + 354, xxx + 399, yyy + 389, true)) {
            tip = "defensive";
        }

        if (tip != "") {
            var _loc = battle_location[current_battle];
            var _planet = battle_world[current_battle]; // Fight fight fight, ground
            obj_controller.cooldown = 8;

            // Start battle here

            combating = 1;

            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            instance_activate_object(battle_object[current_battle]);

            var _battle_obj = battle_object[current_battle];

            instance_create(0, 0, obj_ncombat);
            obj_ncombat.enemy = battle_opponent[current_battle];
            obj_ncombat.battle_object = _battle_obj;
            obj_ncombat.battle_loc = _loc;
            obj_ncombat.battle_id = _planet;

            var _enemy = obj_ncombat.enemy;

            var _planet_data = new PlanetData(_planet, _battle_obj);
            if (tip == "offensive") {
                obj_ncombat.formation_set = 1;
            } else if (tip == "defensive") {
                obj_ncombat.formation_set = 2;
            }

            var _allow_fortifications = false;
            var _fort_factions = [
                eFACTION.PLAYER,
                eFACTION.TYRANIDS,
                eFACTION.ORK,
            ];
            _allow_fortifications = array_contains(_fort_factions, _planet_data.current_owner);

            if (!_allow_fortifications) {
                var owner_fac_status;
                _allow_fortifications = _planet_data.owner_status() != "War";
            }

            if (_allow_fortifications) {
                obj_ncombat.fortified = _planet_data.fortification_level;
            }

            if (obj_ncombat.enemy == eFACTION.NECRONS) {
                obj_ncombat.fortified = 0;
            }

            obj_ncombat.battle_special = battle_special[current_battle];
            obj_ncombat.battle_climate = _planet_data.planet_type;

            if (_enemy == eFACTION.IMPERIUM) {
                obj_ncombat.threat = min(1000000, _planet_data.guardsmen);
            } else if (obj_ncombat.enemy <= eFACTION.NECRONS && _enemy >= eFACTION.ELDAR) {
                obj_ncombat.threat = _planet_data.planet_forces[_enemy];
            }

            var _roster = new Roster();
            with (_roster) {
                roster_location = _loc;
                roster_planet = _planet;
                determine_full_roster();
                only_locals();
                update_roster();
                if (array_length(selected_units)) {
                    setup_battle_formations();
                    add_to_battle();
                }
            }
            delete _roster;
            instance_deactivate_object(battle_object[current_battle]);
        }
    }
}
