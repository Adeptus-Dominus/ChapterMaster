capital_max = capital;
frigate_max = frigate;
escort_max = escort;

var i = 0;
var temp1 = 0;
var x2 = 1200;
var man = 0;
var yy = 0;

sort_ships_into_columns(self);

player_fleet_ship_spawner();

if (enemy == eFACTION.IMPERIUM) {
    // This is an orderly Imperium ship formation
    if (en_num[4] > 0) {
        yy = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
        yy += en_height[4] / 2;
        repeat (en_num[4]) {
            man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
            yy += en_height[4];
            man.class = en_column[4];
        }
        x2 += en_width[4];
    }
    if (en_num[3] > 0) {
        yy = (room_height / 2) - ((en_height[3] * en_num[3]) / 2);
        yy += en_height[3] / 2;
        repeat (en_num[3]) {
            man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
            yy += en_height[3];
            man.class = en_column[3];
        }
        x2 += en_width[3];
    }
    if (en_num[2] > 0) {
        yy = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
        yy += en_height[2] / 2;
        repeat (en_num[2]) {
            man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
            yy += en_height[2];
            man.class = en_column[2];
        }
        x2 += en_width[2];
    }
    if (en_num[1] > 0) {
        yy = 256;
        repeat (en_num[1]) {
            man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
            yy += en_height[1];
            man.class = en_column[1];
            yy += en_height[1];
        }
    }
}

if (enemy == eFACTION.ELDAR) {
    // This is an orderly Eldar ship formation
    if (en_num[4] > 0) {
        yy = 128;
        repeat (en_num[4]) {
            man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
            yy += en_height[4];
            man.class = en_column[4];
        }
    }
    if (en_num[3] > 0) {
        yy = room_height - 128;
        repeat (en_num[3]) {
            man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
            yy -= en_height[3];
            man.class = en_column[3];
        }
    }
    x2 += max(en_width[3], en_width[4]);

    if (en_num[2] > 0) {
        yy = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
        yy += en_height[2] / 2;
        repeat (en_num[2]) {
            man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
            yy += en_height[2];
            man.class = en_column[2];
        }
        x2 += en_width[2];
    }
    if (en_num[1] > 0) {
        yy = 256;
        repeat (en_num[1]) {
            man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
            yy += en_height[1];
            man.class = en_column[1];
            yy += en_height[1];
        }
    }
}

if ((enemy == eFACTION.ORK) || (enemy == eFACTION.CHAOS)) {
    // This is spew out random ships without regard for formations
    for (var i = 1; i <= 5; i++) {
        if (en_column[i] != "") {
            for (s = 0; s < en_num[i]; s += 1) {
                if (en_size[i] > 1) {
                    man = instance_create_depth(random_range(1200, 1400), round(random(860) + 50), obj_en_capital.depth, obj_en_capital);
                }
                if (en_size[i] == 1) {
                    man = instance_create_depth(random_range(1200, 1400), round(random(860) + 50), obj_en_cruiser.depth, obj_en_cruiser);
                }
                man.class = en_column[i];
            }
        }
    }
}

if (enemy == eFACTION.TAU) {
    // This is an orderly Tau ship formation
    yy = (room_height / 2) - ((en_height[5] * en_num[5]) / 2);
    yy += en_height[5] / 2;
    repeat (en_num[5]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[5];
        man.class = "Warden";
    }
    x2 += en_width[5];

    yy = (room_height / 2) - ((en_height[2] * en_num[2]) / 2) - ((en_height[3] * en_num[3]) / 2);
    yy += en_height[2] / 2;
    yy += en_height[3] / 2;
    repeat (en_num[2]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[2];
        man.class = "Emissary";
    }
    repeat (en_num[3]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[3];
        man.class = "Protector";
    }
    x2 += max(en_width[2], en_width[3]);

    yy = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
    yy += en_height[4] / 2;
    repeat (en_num[4]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[4];
        man.class = "Castellan";
    }
    x2 += en_width[4];

    yy = (room_height / 2) - ((en_height[1] * en_num[1]) / 2);
    yy += en_height[1] / 2;
    repeat (en_num[1]) {
        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
        yy += en_height[1];
        man.class = "Custodian";
    }
}

if (enemy == eFACTION.TYRANIDS) {
    // This is an orderly Tyranid ship formation
    yy = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
    yy += en_height[4] / 2;
    repeat (en_num[4]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[4];
        man.class = "Prowler";
    }
    x2 += en_width[4];

    yy = (room_height / 2) - ((en_height[3] * en_num[3]) / 2);
    yy += en_height[3] / 2;
    repeat (en_num[3]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[3];
        man.class = "Razorfiend";
    }
    x2 += en_width[3];

    yy = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
    yy += en_height[2] / 2;
    repeat (en_num[2]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[2];
        man.class = "Stalker";
    }
    x2 += en_width[2];

    yy = (room_height / 2) - ((en_height[1] * en_num[1]) / 2);
    yy += en_height[1] / 2;
    repeat (en_num[1]) {
        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
        yy += en_height[1];
        man.class = "Leviathan";
    }
}

alarm_set(3, 2);
