if (fading_strength > 0) {
    fading_strength -= 0.05;
}

if (wall_destroyed == true) {
    wall_destroyed = false;
}

if (battle_stage == eBATTLE_STAGE.Creation) {
    if (DEBUG_COMBAT_PERFORMANCE) {
        stopwatch("BATTLE_STAGE.Creation");
    }
    
    ncombat_enemy_stacks_init();

    if (DEBUG_COMBAT_PERFORMANCE) {
        stopwatch("scr_player_combat_weapon_stacks");
    }
    // with (obj_pnunit) {
    //     scr_player_combat_weapon_stacks();
    // }

    if (DEBUG_COMBAT_PERFORMANCE) {
        stopwatch("scr_player_combat_weapon_stacks");
    }

    // with (obj_pnunit) {
    //     pnunit_battle_effects();
    // }

    // ncombat_battle_start();

    // ncombat_ally_init();

    // update_battlefield_scale();

    battle_stage = eBATTLE_STAGE.Main;

    if (obj_ncombat.enemy == 30 || battle_special == "ship_demon") {
        turn_side = eBATTLE_ALLEGIANCE.Enemy;
    }
    
    if (DEBUG_COMBAT_PERFORMANCE) {
        stopwatch("BATTLE_STAGE.Creation");
    }
}

if ((press_exclusive(vk_enter) || hold_exclusive(vk_enter)) && fading_strength == 0) {
    if (turn_phase == eBATTLE_TURN_PHASE.Movement) {
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("BATTLE_TURN.Start");
        }
        
        turn_count++;
        // global_perils -= 1;
        queue_battlelog_message($"Turn {turn_count}", COL_YELLOW);
        // resolve_battle_state();
        display_message_queue();
    
        if (turn_side == eBATTLE_ALLEGIANCE.Enemy) {
            if (DEBUG_COMBAT_PERFORMANCE) {
                stopwatch("move_enemy_forces");
            }

            enemy_force.move_forces();

            if (DEBUG_COMBAT_PERFORMANCE) {
                stopwatch("move_enemy_forces");
            }

            // if (instance_exists(obj_enunit)) {                
            //     if (DEBUG_COMBAT_PERFORMANCE) {
            //         stopwatch("enunit_create_weapon_stacks");
            //     }
            //     with (obj_enunit) {
            //         assign_weapon_stacks();
            //     }
            //     if (DEBUG_COMBAT_PERFORMANCE) {
            //         stopwatch("enunit_create_weapon_stacks");
            //     }
            //     if (DEBUG_COMBAT_PERFORMANCE) {
            //         stopwatch("enunit_target_and_shoot");
            //     }
            //     with (obj_enunit) {
            //         enunit_target_and_shoot();
            //     }
            //     if (DEBUG_COMBAT_PERFORMANCE) {
            //         stopwatch("enunit_target_and_shoot");
            //     }
            // }
            // display_message_queue();
        }

        if (turn_side == eBATTLE_ALLEGIANCE.Player) {
            // player_blocks_movement();
            // if (DEBUG_COMBAT_PERFORMANCE) {
            //     stopwatch("pnunit_stacking_shooting");
            // }
            // with (obj_pnunit) {
            //     pnunit_battle_effects();
            //     scr_player_combat_weapon_stacks();
            //     pnunit_target_and_shoot();
            // }
            // if (DEBUG_COMBAT_PERFORMANCE) {
            //     stopwatch("pnunit_stacking_shooting");
            // }
            // with (obj_enunit) {
            //     enunit_enemy_profiles_init();
            // }
            // display_message_queue();
        }

        // queue_force_health();
        // display_message_queue();

        turn_phase = eBATTLE_TURN_PHASE.Morale;
        
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("BATTLE_TURN.Start");
        }
    }

    if (turn_phase == eBATTLE_TURN_PHASE.Morale) {
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("BATTLE_TURN.End");
        }
        
        // if (!battle_ended) {
        //     with (obj_pnunit) {
        //         pnunit_is_valid(id);
        //     }
        
        //     with (obj_enunit) {
        //         enunit_is_valid(id)
        //     }
        // }

        // update_battlefield_scale();

        if (turn_side == eBATTLE_ALLEGIANCE.Enemy) {
            turn_side = eBATTLE_ALLEGIANCE.Player;
        }

        if (turn_side == eBATTLE_ALLEGIANCE.Player) {
            turn_side = eBATTLE_ALLEGIANCE.Enemy;
        }

        turn_phase = eBATTLE_TURN_PHASE.Movement;
        
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("BATTLE_TURN.End");
        }
    }


    if ((battle_stage == eBATTLE_STAGE.PlayerWinStart) || (battle_stage == eBATTLE_STAGE.EnemyWinStart)) {
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
        instance_destroy(obj_popup);
        instance_destroy(obj_star_select);
        with (obj_pnunit) {
            pnunit_dying_process();
        }

        ncombat_special_end();
    }
}

function resolve_battle_state() {
    if (enemy_forces <= 0) {
        battle_ended = true;
        battle_stage = eBATTLE_STAGE.PlayerWinStart;
    } else if (player_forces <= 0) {
        battle_ended = true;
        battle_stage = eBATTLE_STAGE.EnemyWinStart;
        defeat = 1;
    }
}
