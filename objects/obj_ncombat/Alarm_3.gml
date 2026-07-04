if (defeat_message == 1) {
    exit;
}

if (wall_destroyed == 1) {
    wall_destroyed = 0;
}

var good = 0;
var changed = 0;

repeat (100) {
    if (good == 0) {
        changed = 0;
        i = 0;

        // Scan the whole allocated queue (COMBAT_LOG_CAPACITY + 20 slots, see Create), stopping one
        // short of the top so the message[i + 1] lookahead stays in range. Compacting only the first
        // COMBAT_LOG_CAPACITY slots would strand any tail entries so `messages` never reaches 0.
        repeat (COMBAT_LOG_CAPACITY + 19) {
            i += 1;

            // Collide the messages if needed
            if ((message[i] == "") && (message[i + 1] != "")) {
                message[i] = message[i + 1];
                message_sz[i] = message_sz[i + 1];
                message_priority[i] = message_priority[i + 1];

                message[i + 1] = "";
                message_sz[i + 1] = 0;
                message_priority[i + 1] = 0;
                changed = 1;
            }

            // Messages are shown in the order they happened, so we only compact gaps upward
            // (above) and no longer reorder by size/priority.

            if (changed == 0) {
                good = 1;
            }
        }
    } else {
        break;
    }
}

if (messages > 0) {
    // Show messages in the order they happened (chronological), with no per-turn cap, so the
    // whole exchange is visible right down to the closing "held fire" line.
    var that = 0;

    i = 0;
    // Scan the whole allocated queue so tail entries past COMBAT_LOG_CAPACITY still drain.
    repeat (COMBAT_LOG_CAPACITY + 20) {
        i += 1;
        if (message[i] != "") {
            that = i;
            break;
        }
    }
    if (that != 0) {
        newline = message[that];
        if (message_priority[that] > 0) {
            newline_color = "bright";
        }
        if (string_count("lost", newline) > 0) {
            newline_color = "red";
        }
        if (string_count("^", newline) > 0) {
            newline = string_replace(newline, "^", "");
            newline_color = "white";
        }

        if (message_priority[that] == 134) {
            newline_color = "purple";
        }
        if (message_priority[that] == 135) {
            newline_color = "blue";
        }
        if (message_priority[that] == 137) {
            newline_color = "red";
        }
        if (message_priority[that] == MSG_COLOR_WHITE) {
            newline_color = "white";
        }
        if (message_priority[that] == MSG_COLOR_LIGHTGREEN) {
            newline_color = "lightgreen";
        }

        scr_newtext();
        messages_shown += 1;
        largest += 1;
        message[that] = "";
        message_sz[that] = 0;
        message_priority[that] = 0;
        messages -= 1;
    }

    alarm[3] = 2;
}

if (messages == 0) {
    messages_shown = 999;
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

if (((messages_shown == 999) || (messages == 0)) && (timer_stage == 2)) {
    newline_color = "yellow";
    if (obj_ncombat.enemy != 6) {
        combat_emit_enemy_status();
    }
    newline_color = "yellow";
    if (enemy == eFACTION.ELDAR) {
        for (var jims = 1; jims <= 20; jims++) {
            if ((dead_jim[jims] != "") && (dead_jims > 0)) {
                newline = dead_jim[jims];
                newline_color = "red";
                scr_newtext();
                dead_jim[jims] = "";
                dead_jims -= 1;
            }
        }
        if (player_forces > 0) {
            newline = string(global.chapter_name) + " at " + string(round((player_forces / player_max) * 100)) + "%";
            four_show = 0;
        }
        var plnear = instance_nearest(room_width, 240, obj_pnunit);
        if (((player_forces <= 0) || (plnear.x < -40)) && (defeat_message == 0)) {
            defeat_message = 1;
            newline = string(global.chapter_name) + " Defeated";
            timer_maxspeed = 0;
            timer_speed = 0;
            started = 4;
            defeat = 1;
            instance_activate_object(obj_pnunit);
        }
    }
    messages_shown = 105;
    done = 1;
    scr_newtext();
    timer_stage = 3;
    exit;
}

if (((messages_shown == 999) || (messages == 0)) && ((timer_stage == 4) || (timer_stage == 5)) && (four_show == 0)) {
    newline_color = "yellow";
    if (enemy != eFACTION.ELDAR) {
        for (var jims = 1; jims <= 20; jims++) {
            if ((dead_jim[jims] != "") && (dead_jims > 0)) {
                newline = dead_jim[jims];
                newline_color = "red";
                scr_newtext();
                dead_jim[jims] = "";
                dead_jims -= 1;
            }
        }
        if (player_forces > 0) {
            newline = string(global.chapter_name) + " at " + string(round((player_forces / player_max) * 100)) + "%";
            four_show = 1;
        }
        var plnear = instance_nearest(room_width, 240, obj_pnunit);
        if (((player_forces <= 0) || (plnear.x < -40)) && (defeat_message == 0)) {
            defeat_message = 1;
            newline = string(global.chapter_name) + " Defeated";
            timer_maxspeed = 0;
            timer_speed = 0;
            started = 4;
            defeat = 1;
            instance_activate_object(obj_pnunit);
        }
    }
    newline_color = "yellow";
    if (enemy == eFACTION.ELDAR) {
        if (enemy_forces > 0) {
            newline = "Enemy Forces at " + string(max(1, round((enemy_forces / enemy_max) * 100))) + "%";
        }
        if (((enemy_forces <= 0) || (!instance_exists(obj_enunit))) && (defeat_message == 0)) {
            defeat_message = 1;
            newline = "Enemy Forces Defeated";
            timer_maxspeed = 0;
            timer_speed = 0;
            started = 2;
            instance_activate_object(obj_pnunit);
        }
    }
    messages_shown = 105;
    done = 1;
    scr_newtext();
    timer_stage = 5;
    exit;
}
