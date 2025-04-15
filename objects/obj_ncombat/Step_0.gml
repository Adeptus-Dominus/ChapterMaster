enum eBATTLE_TURN {
    Creation,
    Start,
    PlayerStart,
    PlayerEnd,
    EnemyStart,
    EnemyEnd,
}

enum eBATTLE_STAGE {
    Creation,
    Start,
    PlayerWinStart,
    PlayerWinEnd,
    EnemyWinStart,
    EnemyWinEnd
}

if (fading_strength > 0) {
    fading_strength -= 0.05;
}

if (!battle_ended) {
    with (obj_pnunit) {
        target_block_is_valid(id, obj_pnunit);
    }

    with (obj_enunit) {
        if (x < 0) {
            instance_destroy();
        } else {
            var nearest = instance_nearest(x, y, obj_pnunit);
            if (instance_exists(nearest)) {
                if (point_distance(x, y, nearest.x, nearest.y) > 100) {
                    instance_destroy();
                }
            }
        }
    }
}

if (wall_destroyed == 1) {
    wall_destroyed = 0;
}

if (keyboard_check_pressed(vk_enter) && fading_strength == 0) {
    if (started == eBATTLE_STAGE.Creation) {
        started = eBATTLE_STAGE.Start;
        battle_stage = eBATTLE_TURN.Start;

        if (enemy == 30) {
            battle_stage = eBATTLE_TURN.PlayerEnd;
        }
        if (battle_special == "ship_demon") {
            battle_stage = eBATTLE_TURN.PlayerEnd;
        }
    }

    if (started > eBATTLE_STAGE.Creation) {
        // This might be causing problems?
        if (instance_exists(obj_pnunit)) {
            obj_pnunit.alarm[8] = 8;
        }
        if (instance_exists(obj_enunit)) {
            obj_enunit.alarm[8] = 8;
        }
    }

    if (battle_stage == eBATTLE_TURN.PlayerStart) {
        if (global_perils > 0) {
            global_perils -= 1;
        }

        queue_battlelog_message($"Turn {turn_count}", 999, "yellow");
        resolve_battle_state();
        display_message_queue();
        battle_stage = eBATTLE_TURN.PlayerEnd;
    }

    if (battle_stage == eBATTLE_TURN.EnemyStart) {
        queue_battlelog_message($"Turn {turn_count}", 999, "yellow");
        resolve_battle_state();
        display_message_queue();
        battle_stage = eBATTLE_TURN.EnemyEnd;
    }

    if ((battle_stage == eBATTLE_TURN.Start) || (battle_stage == eBATTLE_TURN.EnemyEnd)) {
        turn_count += 1;

        if (enemy != 6) {
            if (instance_exists(obj_enunit)) {
                obj_enunit.alarm[1] = 1;
            }
            set_up_player_blocks_turn();
        } else if (enemy == 6) {
            if (instance_exists(obj_enunit)) {
                obj_enunit.alarm[1] = 2;
                move_enemy_blocks();
                obj_enunit.alarm[0] = 3;
            }
            if (instance_exists(obj_pnunit)) {
                wait_and_execute(1, scr_player_combat_weapon_stacks);
                turn_count++;
            }
        }

        queue_enemy_force_health();
        display_message_queue();
        messages_shown = 0;
        battle_stage = eBATTLE_TURN.PlayerStart;
    } else if (battle_stage == eBATTLE_TURN.PlayerEnd) {
        if (enemy != 6) {
            if (instance_exists(obj_pnunit)) {
                with (obj_pnunit) {
                    wait_and_execute(1, scr_player_combat_weapon_stacks);
                }
                turn_count++;
            }
            if (instance_exists(obj_enunit)) {
                obj_enunit.alarm[1] = 2;
                move_enemy_blocks();
                obj_enunit.alarm[0] = 3;
                obj_enunit.alarm[8] = 4;
                turn_count += 1;
            }
        }
        if (enemy == 6) {
            set_up_player_blocks_turn();
            turn_count += 1;
            if (instance_exists(obj_enunit)) {
                obj_enunit.alarm[1] = 1;
            }
            // alarm[9]=5;
        }

        queue_player_force_health();
        display_message_queue();
        messages_shown = 0;
        battle_stage = eBATTLE_TURN.EnemyStart;
    }

    if (started >= eBATTLE_STAGE.PlayerWinStart) {
        instance_activate_object(obj_pnunit);
    }

    if (started == eBATTLE_STAGE.PlayerWinEnd) {
        instance_activate_all();
        instance_activate_object(obj_pnunit);
        instance_activate_object(obj_enunit);
        instance_destroy(obj_popup);
        instance_destroy(obj_star_select);
        if (instance_exists(obj_pnunit)) {
            obj_pnunit.alarm[6] = 1;
        }

        alarm[7] = 2;
    }

    if ((started == eBATTLE_STAGE.PlayerWinStart) || (started == eBATTLE_STAGE.EnemyWinStart)) {
        instance_activate_object(obj_pnunit);
        instance_activate_object(obj_enunit);
        started = eBATTLE_STAGE.PlayerWinEnd;
        var _quad_factor = 10;
        total_battle_exp_gain = _quad_factor * sqr(threat);
        if (instance_exists(obj_enunit)) {
            obj_enunit.alarm[1] = 1;
        }
        instance_activate_object(obj_star);
        instance_activate_object(obj_event_log);
        alarm[5] = 6;

        newline = "------------------------------------------------------------------------------";
        scr_newtext();
        newline = "------------------------------------------------------------------------------";
        scr_newtext();
    }
}

function resolve_battle_state() {
    if (enemy_forces <= 0 || !instance_exists(obj_enunit)) {
        battle_ended = true;
        started = eBATTLE_STAGE.PlayerWinStart;
        instance_activate_object(obj_pnunit);
        battle_stage = eBATTLE_TURN.EnemyStart;
    } else if (player_forces <= 0 || !instance_exists(obj_pnunit)) {
        battle_ended = true;
        started = eBATTLE_STAGE.EnemyWinStart;
        defeat = 1;
        instance_activate_object(obj_pnunit);
        battle_stage = eBATTLE_TURN.EnemyEnd;
    }
}
