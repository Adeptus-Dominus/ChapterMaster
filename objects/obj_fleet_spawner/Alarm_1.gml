var _enemy_ship;
var _enemy_ship_x_coord = 0;
var _enemy_ship_y_coord = 0;

if ((owner == eFACTION.Imperium) || (owner == eFACTION.Eldar)) {
    // This is an orderly Imperial ship formation
    var fuck = 0;
    if (obj_fleet.enemy_status[number] < 0) {
        _enemy_ship_x_coord = 1200;
        fuck = 5;
    } else if (obj_fleet.enemy_status[number] > 0) {
        _enemy_ship_x_coord = 50;
        fuck = 0;
    }

    repeat (4) {
        if (obj_fleet.enemy_status[number] < 0) {
            fuck -= 1;
        }
        if (obj_fleet.enemy_status[number] > 0) {
            fuck += 1;
        }

        _enemy_ship_y_coord = y - ((en_height[fuck] * en_num[fuck]) / 2);
        if (en_num[fuck] > 0) {
            _enemy_ship_y_coord += en_height[fuck] / 2;
            repeat (en_num[fuck]) {
                if (en_size[fuck] < 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
                        _enemy_ship_y_coord += en_height[fuck];
                        _enemy_ship.class = en_column[fuck];
                        _enemy_ship.owner = owner;
                        _enemy_ship.size = en_size[fuck];
                    }
                    if (obj_fleet.enemy_status[number] > 0) {
                        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_al_cruiser);
                        _enemy_ship_y_coord += en_height[fuck];
                        _enemy_ship.class = en_column[fuck];
                        _enemy_ship.owner = owner;
                        _enemy_ship.size = en_size[fuck];
                    }
                }
                if (en_size[fuck] >= 3) {
                    if (obj_fleet.enemy_status[number] < 0) {
                        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
                        _enemy_ship_y_coord += en_height[fuck];
                        _enemy_ship.class = en_column[fuck];
                        _enemy_ship.owner = owner;
                        _enemy_ship.size = en_size[fuck];
                    } else if (obj_fleet.enemy_status[number] > 0) {
                        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_al_capital);
                        _enemy_ship_y_coord += en_height[fuck];
                        _enemy_ship.class = en_column[fuck];
                        _enemy_ship.owner = owner;
                        _enemy_ship.size = en_size[fuck];
                    }
                }
            }
            _enemy_ship_x_coord += en_width[fuck];
        }
    }

    /*
    if (en_num[4]>0){
        yy=y-((en_height[4]*en_num[4])/2);
        yy+=(en_height[4]/2);
        repeat(en_num[4]){
            man=instance_create(x2,yy,obj_en_cruiser);
            yy+=en_height[4];
            man.class=en_column[4];
            man.owner=owner;
        }
        x2+=en_width[4];
    }
    if (en_num[3]>0){
        yy=y-((en_height[3]*en_num[3])/2);
        yy+=(en_height[3]/2);
        repeat(en_num[3]){
            man=instance_create(x2,yy,obj_en_cruiser);
            yy+=en_height[3];
            man.class=en_column[3];
            man.owner=owner;
        }
        x2+=en_width[3];
    }
    if (en_num[2]>0){
        yy=y-((en_height[2]*en_num[2])/2);
        yy+=(en_height[2]/2);
        repeat(en_num[2]){
            man=instance_create(x2,yy,obj_en_capital);
            yy+=en_height[2];
            man.class=en_column[2];
            man.owner=owner;
        }
        x2+=en_width[2];
    }
    if (en_num[1]>0){
        yy=256;
        repeat(en_num[1]){
            man=instance_create(x2,yy,obj_en_capital);
            yy+=en_height[1];
            man.class=en_column[1];
            man.owner=owner;
            yy+=(en_height[1]);
        }
    }*/
}

/*
if (en_escort>0){en_column[4]="Aconite";en_num[4]=max(1,floor(en_escort/2));en_size[4]=1;}
if (en_escort>1){en_column[3]="Hellebore";en_num[3]=max(1,floor(en_escort/2));en_size[3]=1;}
if (en_frigate>0){en_column[2]="Shadow Class";en_num[2]=en_frigate;en_size[2]=2;}
if (en_capital>0){en_column[1]="Void Stalker";en_num[1]=en_capital;en_size[1]=3;}
*/

/*
if (owner = eFACTION.Eldar){// This is an orderly Eldar ship formation
    var xx,yy,i, temp1, x2, man;
    xx=0;yy=0;i=0;temp1=0;x2=1200;man=0;
    
    if (en_num[4]>0){
        yy=128;
        repeat(en_num[4]){
            man=instance_create(x2,yy,obj_en_cruiser);
            yy+=en_height[4];
            man.class=en_column[4];
            man.owner=owner;
        }
    }
    if (en_num[3]>0){
        yy=room_height-128;
        repeat(en_num[3]){
            man=instance_create(x2,yy,obj_en_cruiser);
            yy-=en_height[3];
            man.class=en_column[3];
            man.owner=owner;
        }
    }
    x2+=max(en_width[3],en_width[4]);
    
    if (en_num[2]>0){
        yy=y-((en_height[2]*en_num[2])/2);
        yy+=(en_height[2]/2);
        repeat(en_num[2]){
            man=instance_create(x2,yy,obj_en_capital);
            yy+=en_height[2];
            man.class=en_column[2];
            man.owner=owner;
        }
        x2+=en_width[2];
    }
    if (en_num[1]>0){
        yy=256;
        repeat(en_num[1]){
            man=instance_create(x2,yy,obj_en_capital);
            yy+=en_height[1];
            man.class=en_column[1];
            man.owner=owner;
            yy+=(en_height[1]);
        }
    }
}*/

if ((owner == eFACTION.Ork) || (owner == eFACTION.Chaos)) {
    // This is spew out random ships without regard for formations

    for (var i = 0; i < 5; i++) {
        if (en_column[i] != "") {
            repeat (en_num[i]) {
                if (en_size[i] > 1) {
                    _enemy_ship = instance_create(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_capital);
                }
                if (en_size[i] == 1) {
                    _enemy_ship = instance_create(random_range(1200, 1400), round(random_range(y, y + height) + 50), obj_en_cruiser);
                }
                _enemy_ship.class = en_column[i];
                _enemy_ship.owner = owner;
                _enemy_ship.size = en_size[i];
            }
        }
    }
}

if (owner == eFACTION.Tau) {
    // This is an orderly Tau ship formation

    _enemy_ship_y_coord = y - ((en_height[5] * en_num[5]) / 2);
    _enemy_ship_y_coord += en_height[5] / 2;
    repeat (en_num[5]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[5];
        _enemy_ship.class = "Warden";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[5];
    }
    _enemy_ship_x_coord += en_width[5];

    _enemy_ship_y_coord = y - ((en_height[2] * en_num[2]) / 2) - ((en_height[3] * en_num[3]) / 2);
    _enemy_ship_y_coord += en_height[2] / 2;
    _enemy_ship_y_coord += en_height[3] / 2;
    repeat (en_num[2]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[2];
        _enemy_ship.class = "Emissary";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[2];
    }
    repeat (en_num[3]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[3];
        _enemy_ship.class = "Protector";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[3];
    }
    _enemy_ship_x_coord += max(en_width[2], en_width[3]);

    _enemy_ship_y_coord = y - ((en_height[4] * en_num[4]) / 2);
    _enemy_ship_y_coord += en_height[4] / 2;
    repeat (en_num[4]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[4];
        _enemy_ship.class = "Castellan";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[4];
    }
    _enemy_ship_x_coord += en_width[4];

    _enemy_ship_y_coord = y - ((en_height[1] * en_num[1]) / 2);
    _enemy_ship_y_coord += en_height[1] / 2;
    repeat (en_num[1]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
        _enemy_ship_y_coord += en_height[1];
        _enemy_ship.class = "Custodian";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[1];
    }
}

if (owner == eFACTION.Tyranids) {
    // This is an orderly Tyranid ship formation

    _enemy_ship_y_coord = y - ((en_height[4] * en_num[4]) / 2);
    _enemy_ship_y_coord += en_height[4] / 2;
    repeat (en_num[4]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[4];
        _enemy_ship.class = "Prowler";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[4];
    }
    _enemy_ship_x_coord += en_width[4];

    _enemy_ship_y_coord = y - ((en_height[3] * en_num[3]) / 2);
    _enemy_ship_y_coord += en_height[3] / 2;
    repeat (en_num[3]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[3];
        _enemy_ship.class = "Razorfiend";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[3];
    }
    _enemy_ship_x_coord += en_width[3];

    _enemy_ship_y_coord = y - ((en_height[2] * en_num[2]) / 2);
    _enemy_ship_y_coord += en_height[2] / 2;
    repeat (en_num[2]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[2];
        _enemy_ship.class = "Stalker";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[2];
    }
    _enemy_ship_x_coord += en_width[2];

    _enemy_ship_y_coord = y - ((en_height[1] * en_num[1]) / 2);
    _enemy_ship_y_coord += en_height[1] / 2;
    repeat (en_num[1]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
        _enemy_ship_y_coord += en_height[1];
        _enemy_ship.class = "Leviathan";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[1];
    }
}

if (owner == eFACTION.Necrons) {
    // This is an orderly Necron ship formation

    _enemy_ship_y_coord = (y - ((en_height[4] * en_num[4]) / 2)) + (en_height[4] / 2); // Magic number
    repeat (en_num[4]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[4];
        _enemy_ship.class = "Dirge Class";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[4];
    }
    _enemy_ship_x_coord += en_width[4];

    _enemy_ship_y_coord = (y - ((en_height[3] * en_num[3]) / 2)) + (en_height[3] / 2);
    repeat (en_num[3]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[3];
        _enemy_ship.class = "Jackal Class";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[3];
    }
    _enemy_ship_x_coord += en_width[3];

    _enemy_ship_y_coord = (y - ((en_height[2] * en_num[2]) / 2)) + (en_height[2] / 2);
    repeat (en_num[2]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_cruiser);
        _enemy_ship_y_coord += en_height[2];
        _enemy_ship.class = "Shroud Class";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[2];
    }
    _enemy_ship_x_coord += en_width[2];

    _enemy_ship_y_coord = (y - ((en_height[1] * en_num[1]) / 2)) + (en_height[1] / 2);
    repeat (en_num[1]) {
        _enemy_ship = instance_create(_enemy_ship_x_coord, _enemy_ship_y_coord, obj_en_capital);
        _enemy_ship_y_coord += en_height[1];
        _enemy_ship.class = "Reaper Class";
        _enemy_ship.owner = owner;
        _enemy_ship.size = en_size[1];
    }
}

/* */
/*  */
