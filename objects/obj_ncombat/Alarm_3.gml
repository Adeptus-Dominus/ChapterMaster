if (defeat_message == 1) {
    exit;
}

if (wall_destroyed == 1) {
    wall_destroyed = 0;
}

if (combat_log.pending_count > 0) {
    alarm[3] = 2;
}

if (instance_exists(obj_pnunit)) {
    var plnear = instance_nearest(room_width, 240, obj_pnunit);
    if (plnear.x < -40) {
        player_forces = 0;
    }
}
if (!instance_exists(obj_pnunit)) {
    player_forces = 0;
}

var _newline = "";
var _newline_color = eMSG_COLOR.DEFAULT;

if ((combat_log.pending_count == 0) && (timer_stage == 2)) {
    _newline_color = eMSG_COLOR.YELLOW;
    if (enemy != eFACTION.ELDAR) {
        combat_emit_enemy_status();
    }
    _newline_color = eMSG_COLOR.YELLOW;
    if (enemy == eFACTION.ELDAR) {
        for (var jims = 1; jims <= 20; jims++) {
            if ((dead_jim[jims] != "") && (dead_jims > 0)) {
                combat_log.push(dead_jim[jims], eMSG_COLOR.RED);
                dead_jim[jims] = "";
                dead_jims -= 1;
            }
        }
        if (player_forces > 0) {
            _newline = string(global.chapter_name) + " at " + string(round((player_forces / player_max) * 100)) + "%";
            combat_log.push(_newline, _newline_color);
            four_show = 0;
        }
        var plnear = instance_nearest(room_width, 240, obj_pnunit);
        if (((player_forces <= 0) || (plnear.x < -40)) && (defeat_message == 0)) {
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

if ((combat_log.pending_count == 0) && ((timer_stage == 4) || (timer_stage == 5)) && (four_show == 0)) {
    _newline_color = eMSG_COLOR.YELLOW;
    if (enemy != eFACTION.ELDAR) {
        for (var jims = 1; jims <= 20; jims++) {
            if ((dead_jim[jims] != "") && (dead_jims > 0)) {
                combat_log.push(dead_jim[jims], eMSG_COLOR.RED);
                dead_jim[jims] = "";
                dead_jims -= 1;
            }
        }
        if (player_forces > 0) {
            _newline = string(global.chapter_name) + " at " + string(round((player_forces / player_max) * 100)) + "%";
            combat_log.push(_newline, _newline_color);
            four_show = 1;
        }
        var plnear = instance_nearest(room_width, 240, obj_pnunit);
        if (((player_forces <= 0) || (plnear.x < -40)) && (defeat_message == 0)) {
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
        combat_emit_enemy_status();
    }
    done = 1;
    timer_stage = 5;
    exit;
}
