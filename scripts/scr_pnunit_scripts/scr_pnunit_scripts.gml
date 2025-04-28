#macro DEBUG_COLUMN_PRIORITY_PLAYER true

// alarm_0
/// @mixin
function pnunit_target_and_shoot() {
    // Useful functions:
    // target_unit_stack
    // get_rightmost
    // move_unit_block
    // gear_weapon_data
    // scr_shoot

    try {
        if (!instance_exists(obj_enunit)) {
            exit;
        }

        target_block = instance_nearest(0, y, obj_enunit);

        engaged = collision_point(x - 10, y, obj_enunit, 0, 1) || collision_point(x + 10, y, obj_enunit, 0, 1);

        if (!engaged) {
            for (var i = 0; i < array_length(unit_struct); i++) {
                if (marine_dead[i] == 0 && marine_casting[i] == true) {
                    var caster_id = i;
                    scr_powers(caster_id);
                }
            }

            // Shooting
            var _ranged_weapons = get_valid_weapon_stacks(weapon_stacks_normal, 2, 999);
            for (var i = 0, _ranged_len = array_length(_ranged_weapons); i < _ranged_len; i++) {
                if (!enunit_is_valid(target_block)) {
                    target_block = instance_nearest(0, y, obj_enunit);
                    if (!enunit_is_valid(target_block,)) {
                        exit;
                    }
                }

                var _weapon_stack = _ranged_weapons[i];
                var dist = get_block_distance(target_block);

                if (_weapon_stack.range >= dist) {
                    var _target_priority_queue = ds_priority_create();

                    // Scan potential targets
                    var _check_targets = [];
                    with (obj_enunit) {
                        if (!enunit_is_valid(self)) {
                            continue;
                        }
                        array_push(_check_targets, self.id);
                    }

                    // if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    //     show_debug_message($"{wep[i]} IS HERE!");
                    // }

                    for (var t = 0; t < array_length(_check_targets); t++) {
                        var enemy_block = _check_targets[t];

                        var _distance = get_block_distance(enemy_block);
                        if (_distance <= _weapon_stack.range) {
                            var _priority = get_target_priority(_weapon_stack, enemy_block);
                            ds_priority_add(_target_priority_queue, enemy_block, _priority);
                        }
                    }

                    // Shoot highest-priority target
                    if (!ds_priority_empty(_target_priority_queue)) {
                        var best_target = ds_priority_delete_max(_target_priority_queue);
                        var unit_index = 0;

                        scr_shoot(_weapon_stack, best_target, unit_index);
                    } else {
                        log_error($"{_weapon_stack.weapon_name} didn't find a valid target! This shouldn't happen!");
                        // if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                        //     show_debug_message($"We didn't find a valid target! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                        // }
                    }

                    ds_priority_destroy(_target_priority_queue);
                } else {
                    // if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    //     show_debug_message($"I can't shoot, my range is too small! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}");
                    // }
                    // continue;
                }
            }
        } else {
            // Melee
            var _melee_weapons = get_valid_weapon_stacks(weapon_stacks_normal, 1, 2);
            for (var i = 0, _wep_len = array_length(_melee_weapons); i < _wep_len; i++) {
                if (!enunit_is_valid(target_block)) {
                    exit;
                }

                var _weapon_stack = _melee_weapons[i];
                scr_shoot(_weapon_stack, target_block, 0);
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}

// alarm_3
/// @mixin
function pnunit_battle_effects() {
    try {
        if (obj_ncombat.battle_stage == eBATTLE_STAGE.Creation) {
            if (men + dreads + veh <= 0) {
                //show_debug_message($"column destroyed {x}")
                instance_destroy();
            }
            // if (veh+dreads>0) then instance_destroy();
            obj_ncombat.player_forces += self.men + self.veh + self.dreads;
            obj_ncombat.player_max += self.men + self.veh + self.dreads;

            //TODO centralise a method for moving units between columns
            /*if (men<=4) and (veh=0) and (dreads=0){// Squish leftt
                var leftt=instance_nearest(x-12,y,obj_pnunit);
                
            
            }*/
        }

        if (scr_has_disadv("Black Rage")) && (obj_ncombat.battle_over == 0) {
            if (men > 0) {
                var raar = 0, miss = "", r_lost = 0;

                for (var raar; raar < (men + dreads); raar++) {
                    var r_roll = floor(random(1000)) + 1;
                    if (obj_ncombat.player_forces < (obj_ncombat.player_max * 0.75)) {
                        r_roll -= 8;
                    }
                    if (obj_ncombat.player_forces < (obj_ncombat.player_max / 2)) {
                        r_roll -= 10;
                    }
                    if (obj_ncombat.player_forces < (obj_ncombat.player_max / 4)) {
                        r_roll -= 24;
                    }
                    if (obj_ncombat.player_forces < (obj_ncombat.player_max / 7)) {
                        r_roll -= 104;
                    }
                    if (obj_ncombat.player_forces < (obj_ncombat.player_max / 10)) {
                        r_roll -= 350;
                    }

                    if ((marine_dead[raar] == 0) && (marine_type[raar] != "Death Company") && (marine_type[raar] != "Chapter Master") && (r_roll <= 4)) {
                        r_lost += 1;
                        marine_type[raar] = "Death Company";
                        //marine_attack[raar]+=1;
                        marine_defense[raar] = 0.75;
                        //marine_ranged[raar]=0.75;
                        obj_ncombat.lost_to_black_rage++;
                        if (r_lost == 1) {
                            miss += "Battle Brother " + string(obj_ini.name[marine_co[raar], marine_id[raar]]) + ", ";
                        }
                        if (r_lost > 1) {
                            miss += string(obj_ini.name[marine_co[raar], marine_id[raar]]) + ", ";
                        }
                    }
                }
                if (r_lost > 1) {
                    string_replace(miss, "Battle Brother", "Battle Brothers");
                }

                var woo = string_length(miss);
                miss = string_delete(miss, woo - 1, 2); // remove last

                if (string_count(", ", miss) == 1) {
                    /*var woo;woo=string_rpos(", ",miss);
                    miss=string_insert(" and",miss,woo+1);*/

                    miss = string_replace(miss, ", ", " and ");
                }
                if (string_count(", ", miss) > 1) {
                    var woo = string_rpos(", ", miss);

                    miss = string_delete(miss, woo - 1, 3);
                    if (r_lost >= 3) {
                        miss = string_insert(", and ", miss, woo - 1);
                    }
                    if (r_lost == 2) {
                        miss = string_insert(" and ", miss, woo - 1);
                    }
                }

                if (r_lost == 1) {
                    miss += " has been lost to the Red Thirst!";
                }
                if (r_lost > 1) {
                    miss += " have been lost to the Red Thirst!";
                }

                if (r_lost > 0) {
                    obj_ncombat.queue_battlelog_message(miss, COL_RED);
                }
            }
        }

        if (obj_ncombat.battle_stage >= eBATTLE_STAGE.Main) {
            // Should probably have the option under deployment to say 'Should Assault Marines enter the fray with vehicles?'   [ ]
        }

        // Right here execute some sort of check- if left is open, and engaged, and target_block is only vehicles, and no weapons to hurt them...

        //! This doesn't work very well, so I'll comment it out for now, as I don't want to bother fixing it atm
        // if (instance_exists(obj_enunit)){
        //     if (collision_point(x+10,y,obj_enunit,0,1)) and (!collision_point(x-10,y,obj_pnunit,0,1)){
        //         var neares=instance_nearest(x+10,y,obj_enunit);

        //         if (neares.men=0) and (neares.veh>0){
        //             var norun;
        //             norun=0;

        //             var i;i=0;
        //             repeat(20){i+=1;
        //                 if (apa[i]>=30) then norun=1;
        //             }

        //             if (norun=0){
        //                 x-=10;
        //                 engaged=0;
        //             }

        //         }
        //     }
        // }

        /* */
        /*  */
    } catch (_exception) {
        handle_exception(_exception);
    }
}

// alarm_6
/// @mixin
function pnunit_dying_process() {
    //
    // Handles marines dying on battle
    //

    // Remove from ships
    // Remove from the controller
    // Remove from any planetary bodies

    // show_message("pnunit alarm 6");

    var i = -1, unit;
    for (var i = 0; i < array_length(unit_struct); i++) {
        if ((marine_dead[i] > 0) && (marine_type[i] != "") && (ally[i] == false)) {
            unit = unit_struct[i];
            if (!is_struct(unit)) {
                continue;
            }
            if (unit.name() == "") {
                continue;
            }
            man_size = unit.get_unit_size();

            if (unit.planet_location > 0) {
                obj_ncombat.world_size += man_size;
            }
            if (unit.ship_location > -1) {
                obj_ini.ship_carrying[unit.ship_location] -= man_size;
            }
            //
            scr_kill_unit(unit.company, unit.marine_number);
        }
    }

    for (var i = 0; i < array_length(veh_type); i++) {
        // if (veh_type[i]="Predator") or (veh_type[i]="Land Raider") then show_message(string(veh_type[i])+" ("+string(veh_co[i])+"."+string(veh_id[i])+")#HP: "+string(veh_hp[i])+"#Dead: "+string(veh_dead[i])+"");

        if ((veh_dead[i] > 0) && (veh_type[i] != "") && (veh_ally[i] == false)) {
            var man_size = scr_unit_size("", veh_type[i], true);

            /*
            if (veh_type[i]="Rhino") then man_size+=10;
            if (veh_type[i]="Predator") then man_size+=10;
            if (veh_type[i]="Land Raider") then man_size+=20;
            if (veh_type[i]="Bike") then man_size+=2;
            if (veh_type[i]="Land Speeder") then man_size+=6;
            if (veh_type[i]="Whirlwind") then man_size+=10;*/

            if (obj_ini.veh_wid[veh_co[i], veh_id[i]] > -1) {
                obj_ncombat.world_size += man_size;
            }
            if (obj_ini.veh_lid[veh_co[i], veh_id[i]] > -1) {
                obj_ini.ship_carrying[obj_ini.veh_lid[veh_co[i], veh_id[i]]] -= man_size;
            }

            // show_message(string(veh_type[i])+" ("+string(veh_co[i])+"."+string(veh_id[i])+") dead");

            //
            destroy_vehicle(veh_co[i], veh_id[i]);
        }

        if ((veh_dead[i] == 0) && (veh_type[i] != "") && (veh_ally[i] == false)) {
            obj_ini.veh_hp[veh_co[i]][veh_id[i]] = veh_hp[i];
        }
    }

    /* */
    /*  */
}

function target_enemy_squad(_battle_block, _target_type = -1) {
	var _biggest_target = noone;
	var _priority_queue = ds_priority_create();
	var _unit_squads = _battle_block.unit_squads;

    for (var i = 0, l = array_length(_unit_squads); i < l; i++){
        var _unit_squad = _unit_squads[i];

        var _unit_stack_count = _unit_squad.member_count;
		var _unit_stack_type = _unit_squad.squad_type;

		if (_target_type == -1 || _unit_stack_type == _target_type) {
			ds_priority_add(_priority_queue, _unit_squad, _unit_stack_count);
		}
	}

	if (!ds_priority_empty(_priority_queue)) {
		_biggest_target = ds_priority_delete_max(_priority_queue);
	}

	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}

function target_enemy_stack(_squad) {
	var _biggest_target = noone;
	var _priority_queue = ds_priority_create();
	var _unit_stacks = _squad.member_stacks;

    for (var i = 0, l = array_length(_unit_stacks); i < l; i++){
        var _unit_stack = _unit_stacks[i];
        var _unit_count = _unit_stack.unit_count;
        ds_priority_add(_priority_queue, _unit_stack, _unit_count);
	}

	if (!ds_priority_empty(_priority_queue)) {
		_biggest_target = ds_priority_delete_max(_priority_queue);
	}

	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}
