// if (battle_over=1) then exit;
if (defeat_message == 1) {
    exit;
}

if (wall_destroyed == 1) {
    wall_destroyed = 0;
}

// if (combat_messages_to_show = 24) and (combat_messages_shown=0) then alarm[6]=75;
// if (combat_messages_shown=105) then exit;

/*i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);
i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);
i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);
i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);
i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);
i+=1;if (combat_messages[i]!="") then show_message(combat_messages[i]);*/

var messages_ordered = false;

while (messages_ordered == false) {
    var message_order_changed = false;
    for (var i = 0; i < 55; i++) {
        // Collide the messages if needed
        if ((combat_messages[i] == "") && (combat_messages[i + 1] != "")) {
            combat_messages[i] = combat_messages[i + 1];
            combat_message_sz[i] = combat_message_sz[i + 1];
            combat_message_priority[i] = combat_message_priority[i + 1];

            combat_messages[i + 1] = "";
            combat_message_sz[i + 1] = 0;
            combat_message_priority[i + 1] = 0;
            message_order_changed = true;
        }

        // Move larger messages up
        if ((combat_messages[i] != "") && (combat_messages[i + 1] != "") && (combat_message_sz[i] < combat_message_sz[i + 1]) && ((combat_message_priority[i] < combat_message_priority[i + 1]) || (combat_message_priority[i] == 0))) {
            combat_messages[100] = combat_messages[i];
            combat_message_sz[100] = combat_message_sz[i];
            combat_message_priority[100] = combat_message_priority[i];

            combat_messages[i] = combat_messages[i + 1];
            combat_message_sz[i] = combat_message_sz[i + 1];
            combat_message_priority[i] = combat_message_priority[i + 1];

            combat_messages[i + 1] = combat_messages[100];
            combat_message_sz[i + 1] = combat_message_sz[100];
            combat_message_priority[i + 1] = combat_message_priority[100];
            message_order_changed = true;
        }

        // Move messages with higher priority up
        if ((combat_messages[i] != "") && (combat_messages[i + 1] != "") && (combat_message_priority[i] < combat_message_priority[i + 1])) {
            combat_messages[100] = combat_messages[i];
            combat_message_sz[100] = combat_message_sz[i];
            combat_message_priority[100] = combat_message_priority[i];

            combat_messages[i] = combat_messages[i + 1];
            combat_message_sz[i] = combat_message_sz[i + 1];
            combat_message_priority[i] = combat_message_priority[i + 1];

            combat_messages[i + 1] = combat_messages[100];
            combat_message_sz[i + 1] = combat_message_sz[100];
            combat_message_priority[i + 1] = combat_message_priority[100];
            message_order_changed = true;
        }
    }

    if (message_order_changed == false) {
        messages_ordered = true;
    }
}

if ((array_length(combat_messages > 0) && (combat_messages_shown < 24)) && (combat_messages_shown <= 100)) {
    // If the left side demands that messages_shown is less than 24, then the right side of the messages_shown being less than 100 will always be true. ???
    // show_message("Largest Message");
    var largest_message_sz = 0;
    var largest_message_index = 0;

    for (var i = 0; i < 60; i++) {
        //I don't know why the magic number is 60, but this would be much better as a for loop than a repeat
        if ((combat_messages[i] != "") && (combat_message_sz[i] > largest_message_sz)) {
            largest_message_sz = combat_message_sz[i];
            largest_message_index = i;
        }
    }

    if ((largest_message_index != 0) && (largest_message_sz > 0)) {
        newline = combat_messages[largest_message_index];
        if (combat_message_priority[largest_message_index] > 0) {
            newline_color = "bright";
        }
        if (string_count("lost", newline) > 0) {
            newline_color = "red";
        }
        if (string_count("^", newline) > 0) {
            newline = string_replace(newline, "^", "");
            newline_color = "white";
        }

        if (combat_(message_priority[largest_message_index] == 134)) {
            newline_color = "purple";
        }
        if (combat_message_priority[largest_message_index] == 135) {
            newline_color = "blue";
        }
        if (combat_message_priority[largest_message_index] == 137) {
            newline_color = "red";
        }

        scr_newtext();
        combat_messages_shown += 1;
        largest += 1;
        combat_messages[largest_message_index] = "";
        combat_message_sz[largest_message_index] = 0;
        combat_message_priority[largest_message_index] = 0;
        array_delete(combat_messages, largest_message_index, 1);
    }

    alarm[3] = 2;
}

if ((array_length(combat_messages) == 0) || (combat_messages_shown >= 24)) {
    combat_messages_shown = 999;
}

/*var noloss;noloss=instance_nearest(50,300,obj_pnunit);
if (!instance_exists(noloss)) then player_forces=0;
if (instance_exists(noloss)){if (point_distance(50,300,noloss.x,noloss.y)>500) then player_forces=0;}*/

if (instance_exists(obj_pnunit)) {
    var plnear;
    plnear = instance_nearest(room_width, 240, obj_pnunit);
    if (plnear.x < -40) {
        player_forces = 0;
    }
}
if (!instance_exists(obj_pnunit)) {
    player_forces = 0;
}

if (((combat_messages_shown == 999) || (array_length(combat_messages) == 0)) && (timer_stage == 2)) {
    newline_color = "yellow";
    if (obj_ncombat.enemy != 6) {
        if ((enemy_forces > 0) && (obj_ncombat.enemy != 30)) {
            newline = "Enemy Forces at " + string(max(1, round((enemy_forces / enemy_max) * 100))) + "%";
        }
        if ((obj_ncombat.enemy == 30) && instance_exists(obj_enunit)) {
            newline = "Enemy has ";
            var yoo;
            yoo = instance_nearest(0, 0, obj_enunit);
            newline += string(round(yoo.dudes_hp[1])) + "HP remaining";
        }
        if ((enemy_forces <= 0) || (!instance_exists(obj_enunit)) && (defeat_message == 0)) {
            defeat_message = 1;
            newline = "Enemy Forces Defeated";
            timer_maxspeed = 0;
            timer_speed = 0;
            started = 2;
            instance_activate_object(obj_pnunit);
        }
    }
    newline_color = "yellow";
    if (obj_ncombat.enemy == 6) {
        var jims;
        jims = 0;
        repeat (20) {
            jims += 1;
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
        var plnear;
        plnear = instance_nearest(room_width, 240, obj_pnunit);
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
    combat_messages_shown = 105;
    done = 1;
    scr_newtext();
    timer_stage = 3;
    exit;
}

if (((combat_messages_shown == 999) || (array_length(combat_messages) == 0)) && ((timer_stage == 4) || (timer_stage == 5)) && (four_show == 0)) {
    newline_color = "yellow";
    if (obj_ncombat.enemy != 6) {
        var jims;
        jims = 0;
        repeat (20) {
            jims += 1;
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
        var plnear;
        plnear = instance_nearest(room_width, 240, obj_pnunit);
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
    if (obj_ncombat.enemy == 6) {
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
    combat_messages_shown = 105;
    done = 1;
    scr_newtext();
    timer_stage = 5;
    exit;
}

/* */
/*  */
