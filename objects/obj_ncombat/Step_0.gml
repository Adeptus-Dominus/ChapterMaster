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
    
    enemy_force.name = "orks_6";
    enemy_force.copy_profile();
    enemy_force.spawn_squads();


    player_force.name = "orks_6";
    player_force.copy_profile();
    player_force.spawn_squads();

    battle_stage = eBATTLE_STAGE.Main;
    
    if (DEBUG_COMBAT_PERFORMANCE) {
        stopwatch("BATTLE_STAGE.Creation");
    }
}

if ((press_exclusive(vk_enter) || hold_exclusive(vk_enter)) && fading_strength == 0) {
    if (turn_phase == eBATTLE_TURN_PHASE.Movement) {
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("Move Phase");
        }
        
        turn_count++;
        // global_perils -= 1;
        queue_battlelog_message($"Turn {turn_count}", COL_YELLOW);
        display_message_queue();

        update_squads_array();

        squads_move();

        turn_phase = eBATTLE_TURN_PHASE.Attack;
        
        if (DEBUG_COMBAT_PERFORMANCE) {
            stopwatch("Move Phase");
        }
    }

    if (turn_phase == eBATTLE_TURN_PHASE.Attack) {
        squads_attack();

        turn_phase = eBATTLE_TURN_PHASE.Morale;
    }

    if (turn_phase == eBATTLE_TURN_PHASE.Morale) {
        turn_phase = eBATTLE_TURN_PHASE.Movement;
    }


    if ((battle_stage == eBATTLE_STAGE.PlayerWinStart) || (battle_stage == eBATTLE_STAGE.EnemyWinStart)) {
        battle_stage = eBATTLE_STAGE.PlayerWinEnd;
        var _quad_factor = 10;
        total_battle_exp_gain = _quad_factor * sqr(threat);

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
