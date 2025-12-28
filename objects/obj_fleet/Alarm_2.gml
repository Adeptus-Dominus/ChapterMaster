capital_max = capital;
frigate_max = frigate;
escort_max = escort;

var _enemy_ship;
var _enemy_ship_x_coord = 1200;
var _enemy_ship_y_coord = 0;

sort_ships_into_columns(self);

player_fleet_ship_spawner();

if (enemy == eFACTION.Imperium) {
    // This is an orderly Imperium formation

    if (en_num[4] > 0) {
        _enemy_ship_y_coord = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
        _enemy_ship_y_coord += en_height[4] / 2;
        repeat (en_num[4]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
            _enemy_ship_y_coord += en_height[4];
            _enemy_ship.class = en_column[4];
        }
        _enemy_ship_x_coord += en_width[4];
    }
    if (en_num[3] > 0) {
        _enemy_ship_y_coord = (room_height / 2) - ((en_height[3] * en_num[3]) / 2);
        _enemy_ship_y_coord += en_height[3] / 2;
        repeat (en_num[3]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
            _enemy_ship_y_coord += en_height[3];
            _enemy_ship.class = en_column[3];
        }
        _enemy_ship_x_coord += en_width[3];
    }
    if (en_num[2] > 0) {
        _enemy_ship_y_coord = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
        _enemy_ship_y_coord += en_height[2] / 2;
        repeat (en_num[2]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
            _enemy_ship_y_coord += en_height[2];
            _enemy_ship.class = en_column[2];
        }
        _enemy_ship_x_coord += en_width[2];
    }
    if (en_num[1] > 0) {
        _enemy_ship_y_coord = 256;
        repeat (en_num[1]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
            _enemy_ship_y_coord += en_height[1];
            _enemy_ship.class = en_column[1];
            _enemy_ship_y_coord += en_height[1];
        }
    }
}

/*
if (en_escort>0){en_column[4]="Aconite";en_num[4]=max(1,floor(en_escort/2));en_size[4]=1;}
if (en_escort>1){en_column[3]="Hellebore";en_num[3]=max(1,floor(en_escort/2));en_size[3]=1;}
if (en_frigate>0){en_column[2]="Shadow Class";en_num[2]=en_frigate;en_size[2]=2;}
if (en_capital>0){en_column[1]="Void Stalker";en_num[1]=en_capital;en_size[1]=3;}
*/

if (enemy == eFACTION.Eldar) {
    // This is an orderly Eldar formation

    if (en_num[4] > 0) {
        _enemy_ship_y_coord = 128;
        repeat (en_num[4]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
            _enemy_ship_y_coord += en_height[4];
            _enemy_ship.class = en_column[4];
        }
    }
    if (en_num[3] > 0) {
        _enemy_ship_y_coord = room_height - 128;
        repeat (en_num[3]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
            _enemy_ship_y_coord -= en_height[3];
            _enemy_ship.class = en_column[3];
        }
    }
    _enemy_ship_x_coord += max(en_width[3], en_width[4]);

    if (en_num[2] > 0) {
        _enemy_ship_y_coord = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
        _enemy_ship_y_coord += en_height[2] / 2;
        repeat (en_num[2]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
            _enemy_ship_y_coord += en_height[2];
            _enemy_ship.class = en_column[2];
        }
        _enemy_ship_x_coord += en_width[2];
    }
    if (en_num[1] > 0) {
        _enemy_ship_y_coord = 256;
        repeat (en_num[1]) {
            _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
            _enemy_ship_y_coord += en_height[1];
            _enemy_ship.class = en_column[1];
            _enemy_ship_y_coord += en_height[1];
        }
    }
}

if ((enemy == eFACTION.Ork) || (enemy == eFACTION.Chaos)) {
    // This spews out random ships without regard for formations

    for (var i = 0; i < 5; i++) {
        if (en_column[i] != "") {
            repeat (en_num[i]) {
                if (en_size[i] > 1) {
                    _enemy_ship = instance_create(random_range(1200, 1400), round(random(860) + 50), obj_en_capital);
                }
                if (en_size[i] == 1) {
                    _enemy_ship = instance_create(random_range(1200, 1400), round(random(860) + 50), obj_en_cruiser);
                }
                _enemy_ship.class = en_column[i];
            }
        }
    }
}

if (enemy == eFACTION.Tau) {
    // This is an orderly Tau formation

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[5] * en_num[5]) / 2);
    _enemy_ship_y_coord += en_height[5] / 2;
    repeat (en_num[5]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[5];
        _enemy_ship.class = "Warden";
    }
    _enemy_ship_x_coord += en_width[5];

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[2] * en_num[2]) / 2) - ((en_height[3] * en_num[3]) / 2);
    _enemy_ship_y_coord += en_height[2] / 2;
    _enemy_ship_y_coord += en_height[3] / 2;
    repeat (en_num[2]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[2];
        _enemy_ship.class = "Emissary";
    }
    repeat (en_num[3]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[3];
        _enemy_ship.class = "Protector";
    }
    _enemy_ship_x_coord += max(en_width[2], en_width[3]);

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
    _enemy_ship_y_coord += en_height[4] / 2;
    repeat (en_num[4]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[4];
        _enemy_ship.class = "Castellan";
    }
    _enemy_ship_x_coord += en_width[4];

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[1] * en_num[1]) / 2);
    _enemy_ship_y_coord += en_height[1] / 2;
    repeat (en_num[1]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
        _enemy_ship_y_coord += en_height[1];
        _enemy_ship.class = "Custodian";
    }
}

if (enemy == eFACTION.Tyranids) {
    // This is an orderly Tyranid formation

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[4] * en_num[4]) / 2);
    _enemy_ship_y_coord += en_height[4] / 2;
    repeat (en_num[4]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[4];
        _enemy_ship.class = "Prowler";
    }
    _enemy_ship_x_coord += en_width[4];

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[3] * en_num[3]) / 2);
    _enemy_ship_y_coord += en_height[3] / 2;
    repeat (en_num[3]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[3];
        _enemy_ship.class = "Razorfiend";
    }
    _enemy_ship_x_coord += en_width[3];

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[2] * en_num[2]) / 2);
    _enemy_ship_y_coord += en_height[2] / 2;
    repeat (en_num[2]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[2];
        _enemy_ship.class = "Stalker";
    }
    _enemy_ship_x_coord += en_width[2];

    _enemy_ship_y_coord = (room_height / 2) - ((en_height[1] * en_num[1]) / 2);
    _enemy_ship_y_coord += en_height[1] / 2;
    repeat (en_num[1]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
        _enemy_ship_y_coord += en_height[1];
        _enemy_ship.class = "Leviathan";
    }
}

/* */
action_set_alarm(2, 3);
