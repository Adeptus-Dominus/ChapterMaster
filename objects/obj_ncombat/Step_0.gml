if (fading_strength > 0) {
    fading_strength -= 0.05;
}

if (wall_destroyed == true) {
    wall_destroyed = false;
}

if (biggest_block_size > 0) {
    battlefield_scale = min(1, 400 / biggest_block_size);
}

if (battle_stage == eBATTLE_STAGE.Creation) {
    ncombat_enemy_stacks_init();

    with (obj_pnunit) {
        scr_player_combat_weapon_stacks();
    }

    with (obj_enunit) {
        enunit_enemy_profiles_init();
        if (column_size > obj_ncombat.biggest_block_size) {
            obj_ncombat.biggest_block_size = column_size;
        }
    }

    with (obj_pnunit) {
        pnunit_battle_effects();
    }

    ncombat_battle_start();

    ncombat_ally_init();

    battle_stage = eBATTLE_STAGE.Main;

    if (obj_ncombat.enemy == 30 || battle_special == "ship_demon") {
        turn_stage = eBATTLE_TURN.PlayerEnd;
    }
}

if (keyboard_check_pressed(vk_enter) && fading_strength == 0) {
    if (turn_stage == eBATTLE_TURN.PlayerStart || turn_stage == eBATTLE_TURN.EnemyStart) {
        turn_count++;
        global_perils -= 1;
        queue_battlelog_message($"Turn {turn_count}", COL_YELLOW);
        resolve_battle_state();
        display_message_queue();
    
        if (turn_stage == eBATTLE_TURN.EnemyStart) {
            if (instance_exists(obj_enunit)) {
                with (obj_enunit) {
                    enunit_enemy_profiles_init();
                }
                move_enemy_blocks();
                with (obj_enunit) {
                    enunit_target_and_shoot();
                }
            }
            display_message_queue();
        }

        if (turn_stage == eBATTLE_TURN.PlayerStart) {
            player_blocks_movement();
            with (obj_pnunit) {
                pnunit_battle_effects();
                scr_player_combat_weapon_stacks();
                pnunit_target_and_shoot();
            }
            with (obj_enunit) {
                enunit_enemy_profiles_init();
            }
            display_message_queue();
        }

        queue_force_health();
        display_message_queue();

        turn_stage = (turn_stage == eBATTLE_TURN.PlayerStart) ? eBATTLE_TURN.PlayerEnd : eBATTLE_TURN.EnemyEnd;
    }

    if (turn_stage == eBATTLE_TURN.EnemyEnd || turn_stage == eBATTLE_TURN.PlayerEnd) {
        if (!battle_ended) {
            with (obj_pnunit) {
                pnunit_is_valid(id);
            }
        
            with (obj_enunit) {
                enunit_is_valid(id)
            }
        }

        if (turn_stage == eBATTLE_TURN.EnemyEnd) {
            turn_stage = eBATTLE_TURN.PlayerStart;
        }

        if (turn_stage == eBATTLE_TURN.PlayerEnd) {
            turn_stage = eBATTLE_TURN.EnemyStart;
        }
    }


    if ((battle_stage == eBATTLE_STAGE.PlayerWinStart) || (battle_stage == eBATTLE_STAGE.EnemyWinStart)) {
        instance_activate_object(obj_pnunit);
        instance_activate_object(obj_enunit);
        battle_stage = eBATTLE_STAGE.PlayerWinEnd;
        var _quad_factor = 10;
        total_battle_exp_gain = _quad_factor * sqr(threat);
        with (obj_enunit) {
            enunit_enemy_profiles_init();
        }
        instance_activate_object(obj_star);
        instance_activate_object(obj_event_log);
        ncombat_battle_end();

        newline = "------------------------------------------------------------------------------";
        scr_newtext();
        newline = "------------------------------------------------------------------------------";
        scr_newtext();
    }

    if (battle_stage == eBATTLE_STAGE.PlayerWinEnd) {
        instance_activate_all();
        instance_activate_object(obj_pnunit);
        instance_activate_object(obj_enunit);
        instance_destroy(obj_popup);
        instance_destroy(obj_star_select);
        with (obj_pnunit) {
            pnunit_dying_process();
        }

        ncombat_special_end();
    }
}

function resolve_battle_state() {
    if (enemy_forces <= 0 || !instance_exists(obj_enunit)) {
        battle_ended = true;
        battle_stage = eBATTLE_STAGE.PlayerWinStart;
        instance_activate_object(obj_pnunit);
        turn_stage = eBATTLE_TURN.EnemyStart;
    } else if (player_forces <= 0 || !instance_exists(obj_pnunit)) {
        show_debug_message($"enemy_forces: {player_forces}");
        show_debug_message($"obj_enunit count: {instance_number(obj_pnunit)}}");
        battle_ended = true;
        battle_stage = eBATTLE_STAGE.EnemyWinStart;
        defeat = 1;
        instance_activate_object(obj_pnunit);
        turn_stage = eBATTLE_TURN.EnemyEnd;
    }
}
