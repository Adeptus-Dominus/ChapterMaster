combat_log.update_scroll(x, y, 800, 900);

if (fadein > -30) {
    fadein -= 1;
}

if (cd >= 0) {
    cd -= 1;
}

if (click_stall_timer >= 0) {
    click_stall_timer -= 1;
}

if (!instance_exists(obj_enunit)) {
    enemy_forces = 0;
}

if (!instance_exists(obj_pnunit)) {
    player_forces = 0;
}

if (fack == 1) {
    instance_activate_object(obj_pnunit);
}

instance_activate_object(obj_centerline);
instance_activate_object(obj_cursor);

var _newline = "";
var _newline_color = eMSG_COLOR.DEFAULT;

if ((((timer_stage == 2) && (fugg >= 60)) || (((timer_stage == 4) || (timer_stage == 5)) && (fugg2 >= 60) && (four_show == 0))) && (combat_log.pending_count == 0) && (defeat_message == 0)) {
    fugg = 0;
    fugg2 = 0;
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
    if (timer_stage == 2) {
        _newline_color = eMSG_COLOR.YELLOW;
        if (enemy != eFACTION.ELDAR) {
            combat_emit_enemy_status();
        }
        if (enemy == eFACTION.ELDAR) {
            if (((player_forces <= 0) || (!instance_exists(obj_pnunit))) && (defeat_message == 0)) {
                defeat_message = 1;
                _newline = string(global.chapter_name) + " Defeated";
                combat_log.push(_newline, _newline_color);
                timer_maxspeed = 0;
                timer_speed = 0;
                started = 4;
                defeat = 1;
                instance_activate_object(obj_pnunit);
            }
        }
        done = 1;
        timer_stage = 3;
        exit;
    }

    if (((timer_stage == 4) || (timer_stage == 5)) && (four_show == 0)) {
        _newline_color = eMSG_COLOR.YELLOW;
        if (enemy != eFACTION.ELDAR) {
            if (((player_forces <= 0) || (!instance_exists(obj_pnunit))) && (defeat_message == 0)) {
                defeat_message = 1;
                _newline = string(global.chapter_name) + " Defeated";
                combat_log.push(_newline, _newline_color);
                timer_maxspeed = 0;
                timer_speed = 0;
                started = 4;
                defeat = 1;
                instance_activate_object(obj_pnunit);
            }
        }
        if (enemy == eFACTION.ELDAR) {
            if (((enemy_forces <= 0) || (!instance_exists(obj_enunit))) && (defeat_message == 0)) {
                combat_emit_enemy_status();
            }
        }
        done = 1;
        timer_stage = 5;
        exit;
    }
    exit;
}

if (timer_stage == 2) {
    fugg += 1;
    stage_elapsed += 1;
}
// Don't time out of stage 2 until the combat log has finished displaying - otherwise on a long turn
// the stage advances before `messages` drains and the "Enemy Forces at X%" status line is skipped.
// The large hard cap is anti-hang insurance in case the queue ever fails to drain. It uses
// stage_elapsed (not fugg) because the 60-frame status poll above resets fugg every time it fires,
// so fugg can never reach the cap during a stall - stage_elapsed keeps counting regardless.

if ((timer_stage == 2) && (((fugg > 60) && (combat_log.pending_count == 0)) || (stage_elapsed > COMBAT_STAGE_TIMEOUT_FRAMES))) {
    timer_stage = 3;
}

if (timer_stage != 2) {
    fugg = 0;
    stage_elapsed = 0;
}

if (timer_stage == 4) {
    fugg2 += 1;
    stage_elapsed2 += 1;
}

if ((timer_stage == 4) && (((fugg2 > 60) && (combat_log.pending_count == 0)) || (stage_elapsed2 > COMBAT_STAGE_TIMEOUT_FRAMES))) {
    timer_stage = 5;
}

if (timer_stage != 4) {
    fugg2 = 0;
    stage_elapsed2 = 0;
}
