var total_enemies = 0;
var total_allies = 1;
var spawner = 0;
var t = 0;
var y1 = 0;
var y2 = 0;
var tt = 0;
var fug = 0;

repeat (6) {
    t += 1;
    if (enemy[t] != 0) {
        if (enemy_status[t] < 0) {
            total_enemies += 1;
        }
        if (enemy_status[t] > 0) {
            total_allies += 1;
        }
    }
}

if (total_enemies > 0) {
    t = 1;
    y2 = room_height / total_enemies / 2;
    tt = 0;
    repeat (5) {
        fug += 1;
        if (enemy_status[fug] < 0) {
            tt += 1;
            y1 = t * y2;

            spawner = instance_create_depth(room_width + 200, y1, obj_fleet_spawner.depth, obj_fleet_spawner);
            spawner.owner = enemy[fug];
            spawner.height = y2;
            spawner.number = fug;

            t += 2;
        }
    }
}

if (total_allies > 0) {
    y1 = 0;
    fug = 0;
    t = 1;
    y2 = room_height / total_allies / 2;
    tt = 0;
    repeat (5) {
        fug += 1;
        if (enemy_status[fug] > 0) {
            tt += 1;
            y1 = t * y2;

            spawner = instance_create_depth(200, y1, obj_fleet_spawner.depth, obj_fleet_spawner);

            if (fug == 1) {
                spawner.owner = eFACTION.PLAYER;
            }
            if (fug > 1) {
                spawner.owner = enemy[fug];
            } // Get the ENEMY after the actual enemies

            spawner.height = y2;
            spawner.number = fug;

            t += 2;
        }
    }
}

// Buffs here
attack_mode = "offensive";

if ((ambushers == 1) && (ambushers == 999)) {
    global_attack = global_attack * 1.1;
} // Need to finish this
if (bolter_drilling == 1) {
    global_bolter = global_bolter * 1.1;
}
if ((siege == 1) && (siege == 555)) {
    global_attack = global_attack * 1.2;
} // Need to finish this
if (slow == 1) {
    global_attack = global_attack * 0.9;
    global_defense = global_defense * 1.2;
}
if (melee == 1) {
    global_melee = global_melee * 1.15;
}
if (shitty_luck == 1) {
    global_defense = global_defense * 0.9;
}
// if (lyman=1) and (dropping=1) then ||| handle within each object
if (ossmodula == 1) {
    global_attack = global_attack * 0.95;
    global_defense = global_defense * 0.95;
}
if (betchers == 1) {
    global_melee = global_melee * 0.95;
}
if (catalepsean == 1) {
    global_attack = global_attack * 0.95;
}
// More prep for player

capital_max = capital;
frigate_max = frigate;
escort_max = escort;

obj_fleet_spawner.alarm[0] = 1;
