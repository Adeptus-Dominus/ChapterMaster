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
