mouse_left = 0;
var __b__;
__b__ = action_if_variable(purge, 0, 0);
if __b__
{

exit;

var xx, yy;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );



var i;i=-1;ships_selected=0;
repeat(31){
    i+=1;
    if (ship_all[i]!=0) and (ship[i]!=""){
        ships_selected+=1;
    }
}
if (ship_all[500]!=0) then ships_selected+=1;




var i, fy, why, onceh, loca, add_ground;i=0;why=0;onceh=0;loca=0;add_ground=0;

if (l_size>0) then loca=1;

if (obj_controller.cooldown<=0){fy=1;
    if (fy=1) and (scr_hit(xx+47,yy+107+why,xx+161,yy+122+why)=true){// Leftest
        if (loca=1) and (l_size>0){onceh=0;// Case 1: it is first slot, local
            if (onceh=0) and (ship_all[500]=0){onceh=1;obj_controller.cooldown=8000;ship_all[500]=1;add_ground=1;}
            if (onceh=0) and (ship_all[500]=1){onceh=1;obj_controller.cooldown=8000;ship_all[500]=0;add_ground=-1;}
        }
    }
}

if (loca=1){fy+=1;if (fy=5) then fy=1;}i=0;

if (obj_controller.cooldown<=0){
    repeat(24-loca){i+=1;
        if (fy=1) and (scr_hit(xx+47,yy+107+why,xx+161,yy+122+why)=true){// Leftest
            if (ship[i]!=""){// Case 3: it is a later slot, ship
                if (onceh=0) and (ship_all[i]=0){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],true,i,attack);}
                if (onceh=0) and (ship_all[i]=1){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],false,i,attack);}
            }
        }
        if (fy=2) and (scr_hit(xx+164,yy+107+why,xx+278,yy+122+why)=true){// 2nd
            if (ship[i]!=""){
                if (onceh=0) and (ship_all[i]=0){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],true,i,attack);}
                if (onceh=0) and (ship_all[i]=1){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],false,i,attack);}
            }
        }
        if (fy=3) and (scr_hit(xx+281,yy+107+why,xx+395,yy+122+why)=true){// 3rd
            if (ship[i]!=""){
                if (onceh=0) and (ship_all[i]=0){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],true,i,attack);}
                if (onceh=0) and (ship_all[i]=1){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],false,i,attack);}
            }
        }
        if (fy=4) and (scr_hit(xx+398,yy+107+why,xx+512,yy+122+why)=true){// 4th
            if (ship[i]!=""){
                if (onceh=0) and (ship_all[i]=0){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],true,i,attack);}
                if (onceh=0) and (ship_all[i]=1){onceh=1;obj_controller.cooldown=8000;scr_drop_fiddle(ship_ide[i],false,i,attack);}
            }
        }
        fy+=1;if (fy=5){fy=1;why+=18;}
    }
}




if (obj_controller.cooldown <= 0) {
    if (mouse_x >= xx + 456) && (mouse_y >= yy + 378) && (mouse_x < xx + 519) && (mouse_y < yy + 403) {
        instance_destroy();
        obj_controller.cooldown = 8000;
    }

    if (mouse_x >= xx + 76) && (mouse_y >= yy + 82) && (mouse_x < xx + 102) && (mouse_y < yy + 95) {
        var onceh;
        once = 0;
        i = 0;
        if (all_sel = 0) && (onceh = 0) {
            var ships_len = array_length(ship);
            for (var i = 0; i < ships_len; i++) {
                if (ship[i] != "") && (ship_all[i] = 0) {
                    ship_all[i] = 1;
                    scr_drop_fiddle(ship_ide[i], true, i, attack);
                }
            }
            if (ship_all[500] = 0) && (l_size > 0) {
                ship_all[500] = 1;
                add_ground = 1;
            }
            onceh = 1;
            all_sel = 1;
        }
        if (all_sel = 1) && (onceh = 0) {
            var ships_len = array_length(ship);
            for (var i = 0; i < ships_len; i++) {
                if (ship[i] != "") && (ship_all[i] = 1) {
                    ship_all[i] = 0;
                    scr_drop_fiddle(ship_ide[i], false, i, attack);
                }
            }
            if (ship_all[500] = 1) && (l_size > 0) {
                ship_all[500] = 0;
                add_ground = -1;
            }
            onceh = 1;
            all_sel = 0;
        }
    }
}

if (add_ground = 1) {
    ships_selected += 1;
    master += local_forces.master;
    honor += local_forces.honor;
    capts += local_forces.captains;
    mahreens += l_mahreens;
    veterans += l_veterans;
    terminators += l_terminators;
    dreads += l_dreads;
    chaplains += l_chaplains;
    psykers += l_psykers;
    apothecaries += l_apothecaries;
    techmarines += l_techmarines;
    champions += l_champions;

    bikes += l_bikes;
    rhinos += l_rhinos;
    whirls += l_whirls;
    predators += l_predators;
    raiders += l_raiders;
    speeders += l_speeders;
}
if (add_ground = -1) {
    ships_selected -= 1;
    master -= local_forces.master;
    honor -= local_forces.honor;
    capts -= local_forces.captains;
    mahreens -= l_mahreens;
    veterans -= l_veterans;
    terminators -= l_terminators;
    dreads -= l_dreads;
    chaplains -= l_chaplains;
    psykers -= l_psykers;
    apothecaries -= l_apothecaries;
    techmarines -= l_techmarines;
    champions -= l_champions;

    bikes -= l_bikes;
    rhinos -= l_rhinos;
    whirls -= l_whirls;
    predators -= l_predators;
    raiders -= l_raiders;
    speeders -= l_speeders;
}


}
