try {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SYSTEM, $"Player block {obj_ncombat.combat_debugger.resolve_label(id)} at x={x} is picking a target");

    if (!instance_exists(obj_enunit)) {
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"no enemy exists, exiting");
        enemy = noone;
        engaged = false;
        push_held_fire();
        exit;
    }

    if (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) {
        move_unit_block("east");
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"moved east");
    }

    enemy = instance_nearest(0, y, obj_enunit);
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"initial target {obj_ncombat.combat_debugger.resolve_label(enemy)} at x={enemy.x}");

    if (instance_number(obj_enunit) != 1) {
        obj_ncombat.flank_x = self.x;
        with (obj_enunit) {
            if (x < (obj_ncombat.flank_x - 20)) {
                instance_deactivate_object(id);
            }
        }
    }

    engaged = collision_point(x - 10, y, obj_enunit, 0, 1) != noone || collision_point(x + 10, y, obj_enunit, 0, 1) != noone;
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"engaged = {engaged}");

    //* Psychic power buffs
    tick_psychic_buffs();

    obj_ncombat.ctally_target = undefined;
    obj_ncombat.ctally_bounce = [];
    obj_ncombat.ctally_injure = [];

    for (var i = 0; i < array_length(wep); i++) {
        if (!instance_exists(obj_enunit)) {
            push_held_fire(i);
            break;
        }

        if (wep[i] == "" || ammo[i] == 0 || att[i] <= 0) {
            continue;
        }

        enemy = instance_nearest(0, y, obj_enunit);

        if (enemy.men + enemy.veh + enemy.medi <= 0) {
            with (enemy) {
                instance_destroy();
            }

            enemy = instance_nearest(0, y, obj_enunit);
            if (!instance_exists(enemy)) {
                engaged = false;
                break;
            }
        }

        var _is_ap = apa[i] > 2;
        var _dist = point_distance(x, y, enemy.x, enemy.y) / 10;
        var _mode = engaged ? "melee" : "ranged";

        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon slot [{i}] is attacking ({wep_num[i]}x{wep[i]} ATTK:{att[i]} AP:{apa[i]}, RNG:{range[i]}, AMM:{ammo[i]})");
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"distance to the enemy at x={enemy.x} is {_dist}");

        if (_mode == "ranged") {
            if (range[i] < _dist) {
                continue;
            }

            // Solo vehicle columns are always valid AP targets
            if (instance_number(obj_enunit) == 1 && enemy.men == 0 && enemy.medi == 0 && enemy.veh > 0) {
                _is_ap = true;
            }

            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"shooting");
        } else {
            var _can_melee = (range[i] <= 2) || (floor(range[i]) != range[i]);
            if (!_can_melee) {
                continue;
            }

            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"attacking in melee");
        }

        var _priorities = [
            {
                guard: _is_ap && enemy.veh > 0,
                type: "veh",
                damage: "arp",
                label: "vehicles",
            },
            {
                guard: enemy.medi > 0,
                type: "medi",
                damage: "medi",
                label: "monsters",
            },
            {
                guard: enemy.men > 0,
                type: "men",
                damage: "att",
                label: "infantry",
            },
        ];

        for (var p = 0; p < array_length(_priorities); p++) {
            var _priority_data = _priorities[p];
            if (!_priority_data.guard) {
                continue;
            }

            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"targeting {_priority_data.label}");

            var _column = pick_target_column(_priority_data.type, _mode);
            if (_column == undefined) {
                continue;
            }

            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"column {obj_ncombat.combat_debugger.resolve_label(_column)}");

            var _unit_i = scr_target(_column, _priority_data.type);
            if (_unit_i == undefined) {
                continue;
            }

            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"unit {_column.dudes[_unit_i]}");

            scr_shoot(i, _column, _unit_i, _priority_data.damage, _mode);
            break;
        }
    }

    combat_tally_flush();

    instance_activate_object(obj_enunit);

    // Safety net: drop empty/zombie formations the firing loop never reached
    with (obj_enunit) {
        var _alive = 0;
        for (var _rr = 1; _rr < array_length(dudes_num); _rr++) {
            if (dudes_num[_rr] > 0 && dudes_hp[_rr] > 0) {
                _alive += dudes_num[_rr];
            }
        }

        if (_alive == 0 && owner != 1) {
            instance_destroy();
        }
    }

    if (instance_exists(obj_enunit)) {
        var _psy_log = {};
        for (var i = 0; i < array_length(unit_struct); i++) {
            if (marine_dead[i] == 0 && marine_casting[i] == true) {
                scr_powers(i, _psy_log);
            }
        }

        flush_psychic_summary(_psy_log);
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
