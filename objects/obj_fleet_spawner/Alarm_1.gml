if ((owner == eFACTION.IMPERIUM) || (owner == eFACTION.ELDAR)) {
    // This is an orderly Imperial ship formation
    var _vertical_offset = 0;
    var _horizontal_offset = 0;
    var _ship = noone;
    var _ship_index = 0;
    if (obj_fleet.enemy_status[number] < 0) {
        _horizontal_offset = 1200;
        _ship_index = 5;
    } else if (obj_fleet.enemy_status[number] > 0) {
        _horizontal_offset = 50;
        _ship_index = 0;
    }

    repeat (4) {
        if (obj_fleet.enemy_status[number] < 0) {
            _ship_index -= 1;
        }
        if (obj_fleet.enemy_status[number] > 0) {
            _ship_index += 1;
        }

        _vertical_offset = y - ((en_height[_ship_index] * en_num[_ship_index]) / 2);
        if (en_num[_ship_index] > 0) {
            _vertical_offset += en_height[_ship_index] / 2;
            repeat (en_num[_ship_index]) {
                if (en_size[_ship_index] < 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
                        _vertical_offset += en_height[_ship_index];
                        _ship.class = en_column[_ship_index];
                        _ship.owner = owner;
                        _ship.size = en_size[_ship_index];
                    }
                    if (obj_fleet.enemy_status[number] > 0) {
                        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_al_cruiser);
                        _vertical_offset += en_height[_ship_index];
                        _ship.class = en_column[_ship_index];
                        _ship.owner = owner;
                        _ship.size = en_size[_ship_index];
                    }
                }
                if (en_size[_ship_index] >= 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_capital);
                        _vertical_offset += en_height[_ship_index];
                        _ship.class = en_column[_ship_index];
                        _ship.owner = owner;
                        _ship.size = en_size[_ship_index];
                    } else if (obj_fleet.enemy_status[number] > 0) {
                        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_al_capital);
                        _vertical_offset += en_height[_ship_index];
                        _ship.class = en_column[_ship_index];
                        _ship.owner = owner;
                        _ship.size = en_size[_ship_index];
                    }
                }
            }
            _horizontal_offset += en_width[_ship_index];
        }
    }
}

if ((owner == eFACTION.ORK) || (owner == eFACTION.CHAOS)) {
    // This is spew out random ships without regard for formations
    var _ship = noone;
    for (var i = 1; i <= 5; i++) {
        if (en_column[i] != "") {
            repeat (en_num[i]) {
                if (en_size[i] > 1) {
                    _ship = instance_create(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_capital);
                }
                if (en_size[i] == 1) {
                    _ship = instance_create(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_cruiser);
                }
                _ship.class = en_column[i];
                _ship.owner = owner;
                _ship.size = en_size[i];
            }
        }
    }
}

if (owner == eFACTION.TAU) {
    // This is an orderly Tau ship formation
    var _horizontal_offset = 1200;
    var _ship = noone;
    var _vertical_offset = y - ((en_height[5] * en_num[5]) / 2) + (en_height[5] / 2);
    repeat (en_num[5]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[5];
        _ship.class = "Warden";
        _ship.owner = owner;
        _ship.size = en_size[5];
    }
    _horizontal_offset += en_width[5];

    _vertical_offset = y - ((en_height[2] * en_num[2]) / 2) - ((en_height[3] * en_num[3]) / 2);
    _vertical_offset += en_height[2] / 2;
    _vertical_offset += en_height[3] / 2;
    repeat (en_num[2]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[2];
        _ship.class = "Emissary";
        _ship.owner = owner;
        _ship.size = en_size[2];
    }
    repeat (en_num[3]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[3];
        _ship.class = "Protector";
        _ship.owner = owner;
        _ship.size = en_size[3];
    }
    _horizontal_offset += max(en_width[2], en_width[3]);

    _vertical_offset = y - ((en_height[4] * en_num[4]) / 2);
    _vertical_offset += en_height[4] / 2;
    repeat (en_num[4]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[4];
        _ship.class = "Castellan";
        _ship.owner = owner;
        _ship.size = en_size[4];
    }
    _horizontal_offset += en_width[4];

    _vertical_offset = y - ((en_height[1] * en_num[1]) / 2);
    _vertical_offset += en_height[1] / 2;
    repeat (en_num[1]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_capital);
        _vertical_offset += en_height[1];
        _ship.class = "Custodian";
        _ship.owner = owner;
        _ship.size = en_size[1];
    }
}

if (owner == eFACTION.TYRANIDS) {
    // This is an orderly Tyranid ship formation
    var _horizontal_offset = 1200;
    var _ship = noone;
    var _vertical_offset = y - ((en_height[4] * en_num[4]) / 2) + (en_height[4] / 2);
    repeat (en_num[4]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[4];
        _ship.class = "Prowler";
        _ship.owner = owner;
        _ship.size = en_size[4];
    }
    _horizontal_offset += en_width[4];

    _vertical_offset = y - ((en_height[3] * en_num[3]) / 2);
    _vertical_offset += en_height[3] / 2;
    repeat (en_num[3]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[3];
        _ship.class = "Razorfiend";
        _ship.owner = owner;
        _ship.size = en_size[3];
    }
    _horizontal_offset += en_width[3];

    _vertical_offset = y - ((en_height[2] * en_num[2]) / 2);
    _vertical_offset += en_height[2] / 2;
    repeat (en_num[2]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[2];
        _ship.class = "Stalker";
        _ship.owner = owner;
        _ship.size = en_size[2];
    }
    _horizontal_offset += en_width[2];

    _vertical_offset = y - ((en_height[1] * en_num[1]) / 2);
    _vertical_offset += en_height[1] / 2;
    repeat (en_num[1]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_capital);
        _vertical_offset += en_height[1];
        _ship.class = "Leviathan";
        _ship.owner = owner;
        _ship.size = en_size[1];
    }
}

if (owner == eFACTION.NECRONS) {
    // This is an orderly Necron ship formation
    var _horizontal_offset = 1200;
    var _ship = noone;
    var _vertical_offset = y - ((en_height[4] * en_num[4]) / 2) + (en_height[4] / 2);
    repeat (en_num[4]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[4];
        _ship.class = "Dirge Class";
        _ship.owner = owner;
        _ship.size = en_size[4];
    }
    _horizontal_offset += en_width[4];

    _vertical_offset = y - ((en_height[3] * en_num[3]) / 2);
    _vertical_offset += en_height[3] / 2;
    repeat (en_num[3]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[3];
        _ship.class = "Jackal Class";
        _ship.owner = owner;
        _ship.size = en_size[3];
    }
    _horizontal_offset += en_width[3];

    _vertical_offset = y - ((en_height[2] * en_num[2]) / 2);
    _vertical_offset += en_height[2] / 2;
    repeat (en_num[2]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_cruiser);
        _vertical_offset += en_height[2];
        _ship.class = "Shroud Class";
        _ship.owner = owner;
        _ship.size = en_size[2];
    }
    _horizontal_offset += en_width[2];

    _vertical_offset = y - ((en_height[1] * en_num[1]) / 2);
    _vertical_offset += en_height[1] / 2;
    repeat (en_num[1]) {
        _ship = instance_create(_horizontal_offset, _vertical_offset, obj_en_capital);
        _vertical_offset += en_height[1];
        _ship.class = "Reaper Class";
        _ship.owner = owner;
        _ship.size = en_size[1];
    }
}
