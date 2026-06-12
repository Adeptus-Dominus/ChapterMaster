if ((owner == eFACTION.IMPERIUM) || (owner == eFACTION.ELDAR)) {
    // This is an orderly Imperial ship formation
    var xx, yy, i, temp1, x2, man;
    xx = 0;
    yy = 0;
    i = 0;
    temp1 = 0;
    x2 = 0;
    man = 0;
    var fuck = 0;
    if (obj_fleet.enemy_status[number] < 0) {
        x2 = 1200;
        fuck = 5;
    } else if (obj_fleet.enemy_status[number] > 0) {
        x2 = 50;
        fuck = 0;
    }

    repeat (4) {
        if (obj_fleet.enemy_status[number] < 0) {
            fuck -= 1;
        }
        if (obj_fleet.enemy_status[number] > 0) {
            fuck += 1;
        }

        yy = y - ((en_height[fuck] * en_num[fuck]) / 2);
        if (en_num[fuck] > 0) {
            yy += en_height[fuck] / 2;
            repeat (en_num[fuck]) {
                if (en_size[fuck] < 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
                        yy += en_height[fuck];
                        man.class = en_column[fuck];
                        man.owner = owner;
                        man.size = en_size[fuck];
                    }
                    if (obj_fleet.enemy_status[number] > 0) {
                        man = instance_create_depth(x2, yy, obj_al_cruiser.depth, obj_al_cruiser);
                        yy += en_height[fuck];
                        man.class = en_column[fuck];
                        man.owner = owner;
                        man.size = en_size[fuck];
                    }
                }
                if (en_size[fuck] >= 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
                        yy += en_height[fuck];
                        man.class = en_column[fuck];
                        man.owner = owner;
                        man.size = en_size[fuck];
                    } else if (obj_fleet.enemy_status[number] > 0) {
                        man = instance_create_depth(x2, yy, obj_al_capital.depth, obj_al_capital);
                        yy += en_height[fuck];
                        man.class = en_column[fuck];
                        man.owner = owner;
                        man.size = en_size[fuck];
                    }
                }
            }
            x2 += en_width[fuck];
        }
    }
}

if ((owner == eFACTION.ORK) || (owner == eFACTION.CHAOS)) {
    // This is spew out random ships without regard for formations
    var xx = 0;
    var yy = 0;
    var dist = 0;
    var targ = 0;
    var numb = 0;
    var man = 0;

    for (var i = 1; i <= 5; i++) {
        if (en_column[i] != "") {
            for (s = 0; s < en_num[i]; s += 1) {
                if (en_size[i] > 1) {
                    man = instance_create_depth(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_capital.depth, obj_en_capital);
                }
                if (en_size[i] == 1) {
                    man = instance_create_depth(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_cruiser.depth, obj_en_cruiser);
                }
                man.class = en_column[i];
                man.owner = owner;
                man.size = en_size[i];
            }
        }
    }
}

if (owner == eFACTION.TAU) {
    // This is an orderly Tau ship formation
    var xx = 0;
    var yy = 0;
    var i = 0;
    var temp1 = 0;
    var x2 = 1200;
    var man = 0;

    yy = y - ((en_height[5] * en_num[5]) / 2);
    yy += en_height[5] / 2;
    repeat (en_num[5]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[5];
        man.class = "Warden";
        man.owner = owner;
        man.size = en_size[5];
    }
    x2 += en_width[5];

    yy = y - ((en_height[2] * en_num[2]) / 2) - ((en_height[3] * en_num[3]) / 2);
    yy += en_height[2] / 2;
    yy += en_height[3] / 2;
    repeat (en_num[2]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[2];
        man.class = "Emissary";
        man.owner = owner;
        man.size = en_size[2];
    }
    repeat (en_num[3]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[3];
        man.class = "Protector";
        man.owner = owner;
        man.size = en_size[3];
    }
    x2 += max(en_width[2], en_width[3]);

    yy = y - ((en_height[4] * en_num[4]) / 2);
    yy += en_height[4] / 2;
    repeat (en_num[4]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[4];
        man.class = "Castellan";
        man.owner = owner;
        man.size = en_size[4];
    }
    x2 += en_width[4];

    yy = y - ((en_height[1] * en_num[1]) / 2);
    yy += en_height[1] / 2;
    repeat (en_num[1]) {
        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
        yy += en_height[1];
        man.class = "Custodian";
        man.owner = owner;
        man.size = en_size[1];
    }
}

if (owner == eFACTION.TYRANIDS) {
    // This is an orderly Tyranid ship formation
    var xx, yy, i, temp1, x2, man;
    xx = 0;
    yy = 0;
    i = 0;
    temp1 = 0;
    x2 = 1200;
    man = 0;

    yy = y - ((en_height[4] * en_num[4]) / 2);
    yy += en_height[4] / 2;
    repeat (en_num[4]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[4];
        man.class = "Prowler";
        man.owner = owner;
        man.size = en_size[4];
    }
    x2 += en_width[4];

    yy = y - ((en_height[3] * en_num[3]) / 2);
    yy += en_height[3] / 2;
    repeat (en_num[3]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[3];
        man.class = "Razorfiend";
        man.owner = owner;
        man.size = en_size[3];
    }
    x2 += en_width[3];

    yy = y - ((en_height[2] * en_num[2]) / 2);
    yy += en_height[2] / 2;
    repeat (en_num[2]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[2];
        man.class = "Stalker";
        man.owner = owner;
        man.size = en_size[2];
    }
    x2 += en_width[2];

    yy = y - ((en_height[1] * en_num[1]) / 2);
    yy += en_height[1] / 2;
    repeat (en_num[1]) {
        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
        yy += en_height[1];
        man.class = "Leviathan";
        man.owner = owner;
        man.size = en_size[1];
    }
}

if (owner == eFACTION.NECRONS) {
    // This is an orderly Necron ship formation
    var xx, yy, i, temp1, x2, man;
    xx = 0;
    yy = 0;
    i = 0;
    temp1 = 0;
    x2 = 1200;
    man = 0;

    yy = y - ((en_height[4] * en_num[4]) / 2);
    yy += en_height[4] / 2;
    repeat (en_num[4]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[4];
        man.class = "Dirge Class";
        man.owner = owner;
        man.size = en_size[4];
    }
    x2 += en_width[4];

    yy = y - ((en_height[3] * en_num[3]) / 2);
    yy += en_height[3] / 2;
    repeat (en_num[3]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[3];
        man.class = "Jackal Class";
        man.owner = owner;
        man.size = en_size[3];
    }
    x2 += en_width[3];

    yy = y - ((en_height[2] * en_num[2]) / 2);
    yy += en_height[2] / 2;
    repeat (en_num[2]) {
        man = instance_create_depth(x2, yy, obj_en_cruiser.depth, obj_en_cruiser);
        yy += en_height[2];
        man.class = "Shroud Class";
        man.owner = owner;
        man.size = en_size[2];
    }
    x2 += en_width[2];

    yy = y - ((en_height[1] * en_num[1]) / 2);
    yy += en_height[1] / 2;
    repeat (en_num[1]) {
        man = instance_create_depth(x2, yy, obj_en_capital.depth, obj_en_capital);
        yy += en_height[1];
        man.class = "Reaper Class";
        man.owner = owner;
        man.size = en_size[1];
    }
}

/* */
/*  */
