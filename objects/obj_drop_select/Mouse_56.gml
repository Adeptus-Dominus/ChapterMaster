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
repeat(31){i+=1;if (ship_all[i]!=0) and (ship[i]!="") then ships_selected+=1;
}if (ship_all[500]!=0) then ships_selected+=1;




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
    master += l_master;
    honor += l_honor;
    capts += l_capts;
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
    master -= l_master;
    honor -= l_honor;
    capts -= l_capts;
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







// 
if (obj_controller.cooldown<=0) and (once_only=0){// Need to change max_ships to something more meaningful to make sure that SOMETHING is dropping
    if (ships_selected>0) and (mouse_x>=xx+310) and (mouse_y>=yy+378) and (mouse_x<xx+444) and (mouse_y<yy+403){
        obj_controller.cooldown=30;once_only=1;
        
        // Start battle here
        
        combating=1;
        
        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_drop_select);
        
        // instance_create(0,0,obj_ncombat);
        
        // 135 ; temporary balancing
        if (sh_target!=-50){sh_target.acted+=1;}
        
        instance_create(0,0,obj_ncombat);
        obj_ncombat.battle_object=p_target;
        obj_ncombat.battle_loc=p_target.name;
        obj_ncombat.battle_id=planet_number;
        obj_ncombat.dropping=1-attack;
        obj_ncombat.attacking=attack;
        obj_ncombat.enemy=attacking;
        if (ship_all[500]=1) then obj_ncombat.local_forces=1;
        
        if (obj_ncombat.battle_object.space_hulk=1) then obj_ncombat.battle_special="space_hulk";
        
        if ( planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id],P_features.Warlord6)==1) and (obj_ncombat.enemy=6) and (obj_controller.faction_defeated[6]=0)then obj_ncombat.leader=1;
        
        if (obj_ncombat.enemy=7) and (obj_controller.faction_defeated[7]=0){
            with(obj_temp1){instance_destroy();}
            with(obj_star){
                if (p_owner[1]=7) then instance_create(x,y,obj_temp1);
                if (p_owner[2]=7) then instance_create(x,y,obj_temp1);
                if (p_owner[3]=7) then instance_create(x,y,obj_temp1);
                if (p_owner[4]=7) then instance_create(x,y,obj_temp1);
            }
			var _planet = battle_object.p_feature[obj_ncombat.battle_id]
            if (instance_number(obj_temp1)=1) or ( planet_feature_bool(_planet,P_features.OrkWarboss)==1){
				obj_ncombat.leader=1;
				obj_ncombat.Warlord = _planet[search_planet_features(_planet,P_features.OrkWarboss)[0]]
			}
            with(obj_temp1){instance_destroy();}
        }
        
        if ( planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id],P_features.Warlord10)==1) and (obj_ncombat.enemy=10) and (obj_controller.faction_defeated[10]=0) then obj_ncombat.leader=1;
        
        
        if (obj_ncombat.enemy=9){
            if (has_problem_planet(planet_number, "tyranid_org", p_target)) then obj_ncombat.battle_special="tyranid_org";
        }
        
        if (obj_ncombat.enemy=6) then obj_ncombat.threat=eldar;
        if (obj_ncombat.enemy=7) then obj_ncombat.threat=ork;
        if (obj_ncombat.enemy=8) then obj_ncombat.threat=tau;
        if (obj_ncombat.enemy=9) then obj_ncombat.threat=tyranids;
        if (obj_ncombat.enemy=10) then obj_ncombat.threat=traitors;
        if (obj_ncombat.enemy=13) then obj_ncombat.threat=necrons;
        
        if (obj_ncombat.enemy=8){
            var eth;eth=0;eth=scr_quest(4,"ethereal_capture",8,0);
            if (eth>0) and (obj_ncombat.battle_object.p_owner[obj_ncombat.battle_id]=8){
                var rolli;rolli=floor(random(100))+1;
                if (obj_ncombat.threat=6) and (rolli<=80) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=5) and (rolli<=65) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=4) and (rolli<=50) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=3) and (rolli<=35) then obj_ncombat.ethereal=1;
            }
            // show_message("Ethereal Quest?: "+string(eth)+"#Ethereal?: "+string(obj_ncombat.ethereal));
        }
        
        // if (obj_ncombat.threat>1) and (obj_ncombat.enemy!=13) then obj_ncombat.threat-=1;
        if (obj_ncombat.threat>1) then obj_ncombat.threat-=1;
        if (obj_ncombat.threat<1) then obj_ncombat.threat=1;
        if (obj_ncombat.enemy=10) and (obj_ncombat.battle_object.p_type[obj_ncombat.battle_id]="Daemon") then obj_ncombat.threat=7;
        
        scr_battle_allies();
        
        var co, v, stop;
        co=0;v=0;stop=0;  
        repeat(3600){
            if (co<11){v+=1;
                if (v>300){co+=1;v=1;}
                if (co>10) then stop=1;
                if (stop=0){
                    if (fighting[co][v]!=0) then obj_ncombat.fighting[co][v]=1;
                    if (attack=1) and (v<=100){
                        if (veh_fighting[co][v]!=0) then obj_ncombat.veh_fighting[co][v]=1;
                    }
                    if (attack=1) and (ship_all[500]=1){
                        if (obj_ini.loc[co][v]=p_target.name) and (obj_ini.TTRPG[co][v].planet_location=planet_number) then obj_ncombat.fighting[co][v]=1;
                        if (v<=100){if (obj_ini.veh_loc[co][v]=p_target.name) and (obj_ini.veh_wid[co][v]=planet_number) then obj_ncombat.veh_fighting[co][v]=1;}
                    }
                }
            }
        }
        
        ships_selected=0;
        var ships_len = array_length(ship_all);
        for (var i = 0; i < ships_len; i++) {
            if (ship_all[i]!=0) then scr_battle_roster(ship[i],ship_ide[i],false);
        }
        if (ship_all[500]=1) then scr_battle_roster(p_target.name,planet_number,true);
        
        
    }
}

}
