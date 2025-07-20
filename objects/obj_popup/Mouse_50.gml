var __b__;
__b__ = action_if_variable(cooldown, 0, 2);
if !__b__
{
{

if (hide=true) then exit;
if (!instance_exists(obj_controller)) then exit;
if (instance_exists(obj_fleet)) then exit;
if (obj_controller.scrollbar_engaged!=0) then exit;
if (cooldown>0) then exit;

if (battle_special>0){
    alarm[0]=1;
    cooldown=10;exit;
}

if (type=98){
    obj_controller.cooldown=10;
    if (instance_exists(obj_turn_end)){
        obj_turn_end.current_battle+=1;
        obj_turn_end.alarm[0]=1;
    }
    obj_controller.force_scroll=0;
    instance_destroy();exit;
}




if (option1=="") and (type<5){
    obj_controller.cooldown=10;
    if (instance_exists(obj_turn_end)) and (obj_controller.complex_event==false){if (number!=0) then obj_turn_end.alarm[1]=4;}
    instance_destroy();
}

if (type>4) and (type!=9) and (cooldown<=0){
    var xx,yy;xx=__view_get( e__VW.XView, 0 );yy=__view_get( e__VW.YView, 0 );

    if (mouse_x>=xx+1006) and (mouse_y>=yy+499) and (mouse_x<=xx+1116) and (mouse_y<yy+519){
        obj_controller.cooldown=10;
        instance_destroy();
        exit;
    }
}



if (type=5.1) and (cooldown<=0){
    var xx,yy,before,before2;
    xx=__view_get( e__VW.XView, 0 );yy=__view_get( e__VW.YView, 0 );
    before=target_comp;
    before2=target_role;

    if (mouse_y>=yy+210) and (mouse_y<yy+230){
        if (mouse_x>=xx+1468) and (mouse_x<=xx+1515){target_comp=0;cooldown=8000;}
    }
    if (mouse_y>=yy+230) and (mouse_y<yy+250){
        if (mouse_x>=xx+1030) and (mouse_x<=xx+1120){target_comp=1;cooldown=8000;}
        if (mouse_x>=xx+1140) and (mouse_x<=xx+1230){target_comp=2;cooldown=8000;}
        if (mouse_x>=xx+1250) and (mouse_x<=xx+1340){target_comp=3;cooldown=8000;}
        if (mouse_x>=xx+1360) and (mouse_x<=xx+1450){target_comp=4;cooldown=8000;}
        if (mouse_x>=xx+1470) and (mouse_x<=xx+1560){target_comp=5;cooldown=8000;}
    }
    if (mouse_y>=yy+250) and (mouse_y<yy+270){
        if (mouse_x>=xx+1030) and (mouse_x<=xx+1120){target_comp=6;cooldown=8000;}
        if (mouse_x>=xx+1140) and (mouse_x<=xx+1230){target_comp=7;cooldown=8000;}
        if (mouse_x>=xx+1250) and (mouse_x<=xx+1340){target_comp=8;cooldown=8000;}
        if (mouse_x>=xx+1360) and (mouse_x<=xx+1450){target_comp=9;cooldown=8000;}
        if (mouse_x>=xx+1470) and (mouse_x<=xx+1560){target_comp=10;cooldown=8000;}
    }
}

if (type=5) and (cooldown<=0){
    var xx,yy,before,before2;
    xx=__view_get( e__VW.XView, 0 );yy=__view_get( e__VW.YView, 0 );
    before=target_comp;
    before2=target_role;

    if (unit_role!=obj_ini.role[100,17]) or (obj_controller.command_set[1]!=0){
        if (mouse_y>=yy+210) and (mouse_y<yy+230){
            if (mouse_x>=xx+1468) and (mouse_x<=xx+1515) and (min_exp>=0){
                target_comp=0;
                get_unit_promotion_options();
                cooldown=8000;
            }
        }
    }
}

/* */

var xx,yy,change_tab;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );
change_tab=0;

/* */

var xx,yy,change_tab,do_not_change;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );
change_tab=0;
do_not_change=false;

if (type=6) and (cooldown<=0){// Actually changing equipment right here
    if (target_comp=1) or (target_comp=2){
        if (mouse_y>=yy+318) and (mouse_y<yy+330) and (mouse_x>=xx+1190) and (mouse_x<xx+1216) and (tab!=1){
            change_tab=1;
            tab=1;
            obj_controller.last_weapons_tab=1;
            cooldown=8000;
        }
        if (mouse_y>=yy+318) and (mouse_y<yy+330) and (mouse_x>=xx+1263) and (mouse_x<xx+1289) and (tab!=2){change_tab=1;tab=2;obj_controller.last_weapons_tab=2;cooldown=8000;}
        if (mouse_y>=yy+318) and (mouse_y<yy+330) and (mouse_x>=xx+1409) and (mouse_x<xx+1435) and (target_comp<3){
            cooldown=8000;

            master_crafted = !bool(master_crafted);
            obj_controller.popup_master_crafted = master_crafted;
            item_name = [];
            scr_get_item_names(
                item_name,
                vehicle_equipment, // eROLE
                target_comp, // slot
                tab == 1 ? eENGAGEMENT.Ranged : eENGAGEMENT.Melee,
                false, // include company standard
                true, // limit to available equipment
                master_crafted
            );
        }
    }


    if ((mouse_x>=xx+1296) and (mouse_x<xx+1578)) or (change_tab=1){
        var befi;befi=target_comp;

        if (change_tab=0){
            if (mouse_y>=yy+215) and (mouse_y<yy+235){target_comp=1;cooldown=8000;tab=obj_controller.last_weapons_tab;}
            if (mouse_y>=yy+235) and (mouse_y<yy+255){target_comp=2;cooldown=8000;tab=obj_controller.last_weapons_tab;}
            if (mouse_y>=yy+255) and (mouse_y<yy+275){target_comp=3;cooldown=8000;}
            if (mouse_y>=yy+275) and (mouse_y<yy+295){target_comp=4;cooldown=8000;}
            if (mouse_y>=yy+295) and (mouse_y<yy+315){target_comp=5;cooldown=8000;}
        }

        if ((befi != target_comp && vehicle_equipment != -1) || change_tab == 1) {
            item_name = [];
            scr_get_item_names(
                item_name,
                vehicle_equipment, // eROLE
                target_comp, // slot
                tab == 1 ? eENGAGEMENT.Ranged : eENGAGEMENT.Melee,
                false, // include company standard
                true, // limit to available equipment
                master_crafted
            );
        }
    }
}
/* */

if (mouse_x>=xx+1465) and (mouse_y>=yy+499) and (mouse_x<xx+1577) and (mouse_y<yy+520){// Equipment

    if (type=6) and (cooldown<=0) and (n_good1+n_good2+n_good3+n_good4+n_good5=5){
        cooldown=999;
        obj_controller.cooldown=8;

        if (n_wep1=ITEM_NAME_NONE) then n_wep1="";
        if (n_wep2=ITEM_NAME_NONE) then n_wep2="";
        if (n_armour=ITEM_NAME_NONE) then n_armour="";
        if (n_gear=ITEM_NAME_NONE) then n_gear="";
        if (n_mobi=ITEM_NAME_NONE) then n_mobi="";


        for (var i=0;i<array_length(obj_controller.display_unit);i++){

            var endcount=0;

            if (obj_controller.man[i]!="") and (obj_controller.man_sel[i]) and (vehicle_equipment!=-1){
                var check=0,scout_check=0;
                unit = obj_controller.display_unit[i];
                var standard = master_crafted==1?"master_crafted":"any";
                if (is_struct(unit)){
                    unit.update_armour(n_armour, true, true, standard);
                    unit.update_mobility_item(n_mobi, true, true, standard);
                    unit.update_weapon_one(n_wep1, true, true, standard);
                    unit.update_weapon_two(n_wep2, true, true, standard);
                    unit.update_gear(n_gear, true, true, standard);

                    update_man_manage_array(i);
                    continue;
                } else if (is_array(unit)){

                    // NOPE
                        if (check=0) and (n_armour!=obj_controller.ma_armour[i]) and (n_armour!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle wep3
                            if (obj_controller.ma_armour[i]!="") then scr_add_item(obj_controller.ma_armour[i],1);
                            obj_controller.ma_armour[i]="";
                            obj_ini.veh_wep3[unit[0],unit[1]]="";

                            if (n_armour!=ITEM_NAME_NONE) and (n_armour!=""){
                                obj_controller.ma_armour[i]=n_armour;
                                obj_ini.veh_wep3[unit[0],unit[1]]=n_armour;
                                if (n_armour!="") then scr_add_item(n_armour,-1);
                            }
                        }
                        check=0;
                        if (n_wep1=obj_controller.ma_wep1[i]) or (n_wep1="Assortment") then check=1;

                        if (check==0){
                            if (n_wep1!=obj_controller.ma_wep1[i])  and (n_wep1!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ // vehicle wep1
                                if (obj_controller.ma_wep1[i]!="") and (obj_controller.ma_wep1[i]!=n_wep1){
                                    scr_add_item(obj_controller.ma_wep1[i],1);
                                    obj_controller.ma_wep1[i]="";
                                    obj_ini.veh_wep1[unit[0],unit[1]]="";
                                }
                                if (n_wep1!=""){
                                    scr_add_item(n_wep1,-1);
                                    obj_controller.ma_wep1[i]=n_wep1;
                                    obj_ini.veh_wep1[unit[0],unit[1]]=n_wep1;
                                }
                            }
                        }
                        // End swap weapon1

                        check=0;

                        if (n_wep2=obj_controller.ma_wep2[i]) or (n_wep2="Assortment") then check=1;

                        if (check==0) and (n_wep2!=obj_controller.ma_wep2[i]) and (n_wep2!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ // vehicle wep2
                            if (obj_controller.ma_wep2[i]!="") and (obj_controller.ma_wep2[i]!=n_wep2){
                                scr_add_item(obj_controller.ma_wep2[i],1);
                                obj_controller.ma_wep2[i]="";
                                obj_ini.veh_wep2[unit[0],unit[1]]="";
                            }
                            if (n_wep2!=""){
                                scr_add_item(n_wep2,-1);
                                obj_controller.ma_wep2[i]=n_wep2;
                                obj_ini.veh_wep2[unit[0],unit[1]]=n_wep2;
                            }
                        }
                        // End swap weapon2

                        check=0;

                        if (check=0) and (n_gear!=obj_controller.ma_gear[i]) and (n_gear!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle upgrade item
                            if (obj_controller.ma_gear[i]!="") then scr_add_item(obj_controller.ma_gear[i],1);
                            obj_controller.ma_gear[i]="";
                            obj_ini.veh_upgrade[unit[0],unit[1]]="";
                            if (n_gear!=ITEM_NAME_NONE) and (n_gear!=""){
                                obj_controller.ma_gear[i]=n_gear;
                                obj_ini.veh_upgrade[unit[0],unit[1]]=n_gear;
                            }
                            if (n_gear!="") then scr_add_item(n_gear,-1);
                        }
                        // End gear and upgrade

                        check=0;
                        if (check=0) and (n_mobi!=obj_controller.ma_mobi[i]) and (n_mobi!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle accessory item
                            if (obj_controller.ma_mobi[i]!="") then scr_add_item(obj_controller.ma_mobi[i],1);
                            obj_controller.ma_mobi[i]="";
                            obj_ini.veh_acc[unit[0],unit[1]]="";
                            obj_controller.ma_mobi[i]=n_mobi;
                            obj_ini.veh_acc[unit[0],unit[1]]=n_mobi;
                            if (n_mobi!="") then scr_add_item(n_mobi,-1);
                        }
                        // End mobility and accessory

                }

            }// End that [i]

        }// End repeat

        obj_controller.cooldown=10;
        instance_destroy();exit;
    }
}

/* */


// if ((mouse_x>=xx+240) and (mouse_x<=xx+387) and (type!=88)) or (((type=9) or (type=9.1)) and (mouse_x>=xx+240+420) and (mouse_x<xx+387+420)){
if (type=9.1) and (mouse_x>=xx+240+420) and (mouse_x<xx+387+420) and (cooldown<=0){

    if (mouse_y>=yy+325) and (mouse_y<yy+342){
        obj_controller.cooldown=8000;
        instance_destroy();
        exit;
    }

    if (giveto>0) {
            var r1,r2,cn;r2=0;cn=obj_controller;
            r1=floor(random(cn.stc_wargear_un+cn.stc_vehicles_un+cn.stc_ships_un))+1;

            if (r1<cn.stc_wargear_un) and (cn.stc_wargear_un>0) then r2=1;
            if (r1>cn.stc_wargear_un) and (r1<=cn.stc_wargear_un+cn.stc_vehicles_un) and (cn.stc_vehicles_un>0) then r2=2;
            if (r1>cn.stc_wargear_un+cn.stc_vehicles_un) and (r2<=cn.stc_wargear_un+cn.stc_vehicles_un+cn.stc_ships_un) and (cn.stc_ships_un>0) then r2=3;

            if (cn.stc_wargear_un>0) and (cn.stc_vehicles_un+cn.stc_ships_un=0) then r2=1;
            if (cn.stc_vehicles_un>0) and (cn.stc_wargear_un+cn.stc_ships_un=0) then r2=2;
            if (cn.stc_ships_un>0) and (cn.stc_vehicles_un+cn.stc_wargear_un=0) then r2=3;

            cn.stc_un_total-=1;
            if (r2=1) then cn.stc_wargear_un-=1;
            if (r2=2) then cn.stc_vehicles_un-=1;
            if (r2=3) then cn.stc_ships_un-=1;

            // Modify disposition here
            if (giveto = eFACTION.Imperium){
                obj_controller.disposition[giveto]+=3;
            }
            else if (giveto = eFACTION.Mechanicus){
                obj_controller.disposition[giveto]+=choose(5,6,7,8);
            }
            else if (giveto = eFACTION.Inquisition){
                obj_controller.disposition[giveto]+=3;
            }
            else if (giveto = eFACTION.Ecclesiarchy) {
                obj_controller.disposition[giveto]+=3;
                if (scr_has_adv("Reverent Guardians")){
                    obj_controller.disposition[giveto]+=2;
                }
            }
			
            if (giveto=eFACTION.Eldar)
				obj_controller.disposition[giveto] +=2;
            if (giveto=eFACTION.Tau) {
				obj_controller.disposition[giveto]+=15;
			}// 137 ; chance for mechanicus to get very pissed
            // End disposition
            obj_controller.cooldown=7000;
            scr_toggle_diplomacy();
            obj_controller.diplomacy=giveto;
            obj_controller.force_goodbye=-1;
            var the;
			the="";
			if (giveto!=eFACTION.Ork) and (giveto!=eFACTION.Chaos) then the="the ";
			
            scr_event_log("",$"STC Fragment gifted to {the}{obj_controller.faction[giveto]}.");

            with(obj_controller ) {
				scr_dialogue("stc_thanks");
			}
            instance_destroy();
			exit;
    }
}



xx=__view_get( e__VW.XView, 0 )+951;yy=__view_get( e__VW.YView, 0 )+398;
if (mouse_x>=xx+121) and (mouse_y>=yy+393) and (mouse_x<xx+231) and (mouse_y<yy+414){
    if (type=8) and (cooldown<=0){
        obj_controller.cooldown=8000;
        instance_destroy();exit;
    }
}

/* */
}
}
/*  */
