

action="";
    direction=0;


    cooldown1=0;
    cooldown2=0;
    cooldown3=0;
    cooldown4=0;
    cooldown5=0;


    name=obj_ini.ship[ship_id];
    class=obj_ini.ship_class[ship_id];
    hp=obj_ini.ship_hp[ship_id]*1;
    maxhp=obj_ini.ship_hp[ship_id]*1;
    conditions=obj_ini.ship_conditions[ship_id];
    shields=obj_ini.ship_shields[ship_id]*100;
    maxshields=shields;
    armour_front=obj_ini.ship_front_armour[ship_id];
    armour_other=obj_ini.ship_other_armour[ship_id];
    weapons=obj_ini.ship_weapons[ship_id];
    turrets=0;
    ship_colour=obj_controller.body_colour_replace;
    weapon = obj_ini.ship_wep[ship_id]
    
    weapon_facing[1]="";
    weapon_cooldown[1]=0;
    weapon_hp[1]=hp/4;
    weapon_dam[1]=0;
    weapon_ammo[1]=999;
    weapon_range[1]=0;
    weapon_minrange[1]=0;
    weapon_facing[2]="";
    weapon_cooldown[2]=0;
    weapon_hp[2]=hp/4;
    weapon_dam[2]=0;
    weapon_ammo[2]=999;
    weapon_range[2]=0;
    weapon_minrange[2]=0;

    weapon_facing[3]="";
    weapon_cooldown[3]=0;
    weapon_hp[3]=hp/4;
    weapon_dam[3]=0;
    weapon_ammo[3]=999;
    weapon_range[3]=0;
    weapon_minrange[3]=0;

    weapon_facing[4]="";
    weapon_cooldown[4]=0;
    weapon_hp[4]=hp/4;
    weapon_dam[4]=0;
    weapon_ammo[4]=999;
    weapon_range[4]=0;
    weapon_minrange[4]=0;

    weapon_facing[5]="";
    weapon_cooldown[5]=0;
    weapon_hp[5]=hp/4;
    weapon_dam[5]=0;
    weapon_ammo[5]=999;
    weapon_range[5]=0;
    weapon_minrange[5]=0;





    if (class="Battle Barge"){
        turrets=3;
        weapons=5;
        shield_size=3;
        sprite_index=spr_ship_bb;
        weapon_facing[1]="left";
        weapon_dam[1]=15;
        weapon_range[1]=450;
        weapon_cooldown[1]=30;
        weapon_facing[2]="right";
        weapon_dam[2]=15;
        weapon_range[2]=450;
        weapon_cooldown[2]=30;
        weapon_facing[3]="special";
        weapon_cooldown[3]=90;
        weapon_ammo[3]=3;
        weapon_range[3]=9999;
        weapon_facing[4]="front";
        weapon_dam[4]=12;
        weapon_range[4]=1000;
        weapon_cooldown[4]=120;// volley several
        weapon_facing[5]="most";
        weapon_dam[5]=16;
        weapon_range[5]=300;
        weapon_cooldown[5]=30;
    }

    if (class="Slaughtersong"){turrets=3;
        weapons=5;shield_size=3;sprite_index=spr_ship_song;
        weapon_facing[1]="most";
        weapon_dam[1]=16;
        weapon_range[1]=550;
        weapon_cooldown[1]=26;
        weapon_facing[2]="most";
        weapon_dam[2]=16;
        weapon_range[2]=550;
        weapon_cooldown[2]=26;
        weapon_facing[3]="most";
        weapon_dam[3]=16;
        weapon_range[3]=550;
        weapon_cooldown[3]=26;
        weapon_facing[4]="front";
        weapon_dam[4]=32;
        weapon_range[4]=1000;
        weapon_cooldown[4]=90;
    }


if (class="Gloriana"){
    turrets=3;
    weapons=5;
    shield_size=3;
    sprite_index=spr_ship_song;
    weapon_facing[1]="most";
    weapon_dam[1]=16;
    weapon_range[1]=550;
    weapon_cooldown[1]=26;
    weapon_facing[2]="most";
    weapon_dam[2]=16;
    weapon_range[2]=550;
    weapon_cooldown[2]=26;
    weapon_facing[3]="most";
    weapon_dam[3]=16;
    weapon_range[3]=550;
    weapon_cooldown[3]=26;
    weapon_facing[4]="front";
    weapon_dam[4]=32;
    weapon_range[4]=1000;
    weapon_cooldown[4]=90;
}
    if (class="Strike Cruiser"){turrets=1;
        weapons=4;
        shield_size=1;
        sprite_index=spr_ship_stri;
        weapon_facing[1]="left";
        weapon_dam[1]=8;
        weapon_range[1]=300;
        weapon_cooldown[1]=30;
        weapon_facing[2]="right";
        weapon_dam[2]=8;
        weapon_range[2]=300;
        weapon_cooldown[2]=30;
        weapon_facing[3]="special";
        weapon_cooldown[3]=90;
        weapon_ammo[3]=3;
        weapon_range[3]=9999;
        weapon_facing[4]="most";
        weapon_dam[4]=12;
        weapon_range[4]=300;
        weapon_cooldown[4]=30;
    }

    if (class="Hunter"){turrets=1;
        weapons=2;shield_size=1;sprite_index=spr_ship_hunt;
        weapon_facing[1]="front";
        weapon_dam[1]=8;
        weapon_range[1]=450;
        weapon_cooldown[1]=60;
        weapon_facing[2]="most";
        weapon_dam[2]=8;
        weapon_range[2]=300;
        weapon_cooldown[2]=60;
    }

    if (class="Gladius"){turrets=1;
        weapons=2;shield_size=1;sprite_index=spr_ship_glad;
        weapon_facing[1]="most";
        weapon_dam[1]=8;
        weapon_range[1]=300;
        weapon_cooldown[1]=30;
    }


    // STC Bonuses
    if (obj_controller.stc_bonus[5]=5){armour_front=round(armour_front*1.1);armour_other=round(armour_other*1.1);}
    if (obj_controller.stc_bonus[6]=2){armour_front=round(armour_front*1.1);armour_other=round(armour_other*1.1);}


    var i=0, unit, b=0;

    for (var co=0;co<=obj_ini.companies;co++){
        for (i=0;i<array_length(obj_ini.name[co]);i++){
            if (obj_ini.name[co][i]=="") then continue;
            unit=fetch_unit([co,i]);
            if (unit.ship_location==ship_id){
                if (unit.is_boarder && unit.hp()>(unit.max_health()/10)){
                    array_push(board_co, co);
                    array_push(board_id, i);
                    array_push(board_location, 0);
                    array_push(board_raft, 0);
                    boarders+=1;
                }
                // Loc 0: on origin ship
                // Loc 1: in transit
                // Loc >1: (instance_id), on enemy vessel 
                if (co==0 && master_present==0 && i<100){
                    if (unit.role()==obj_ini.role[100][eROLE.ChapterMaster] && unit.ship_location==ship_id){
                        master_present=1;
                        obj_fleet.control=1;
                    }            
                }            
            }
        }
    }

    if (boarders>0){
        if (obj_controller.command_set[25]=1) then board_capital=true;
        if (obj_controller.command_set[26]=1) then board_frigate=true;
    }

    if (hp<=0){
        x=-1000;
        y=room_height/2;
        if (ship_id=0) then instance_destroy();
    }