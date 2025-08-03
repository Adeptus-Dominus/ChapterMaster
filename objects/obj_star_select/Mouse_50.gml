var __b__;
__b__ = action_if_number(obj_saveload, 0, 0);
if __b__
{
__b__ = action_if_number(obj_drop_select, 0, 0);
if __b__
{
__b__ = action_if_variable(obj_controller.diplomacy, 0, 0);
if __b__
{

draw_set_font(fnt_fancy);
draw_set_halign(fa_center);
draw_set_color(0);

if (obj_controller.menu=60) then exit;

var xx, yy, target_distance, close;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;
target_distance=999;close=false;




if (debug!=0) then exit;

    //TODO centralise this logic
    if (instance_exists(obj_fleet_select)){
         if (obj_fleet_select.currently_entered)  then exit;
    }


// Exit button
if (mouse_x>=xx+274) and (mouse_y>=yy+426) and (mouse_x<xx+337) and (mouse_y<yy+451) and (obj_controller.cooldown<=0){
    if (!loading){
        obj_controller.sel_system_x=0;
        obj_controller.sel_system_y=0;
        obj_controller.popup=0;
        obj_controller.cooldown=8000;
        obj_controller.selecting_planet=0;
        instance_destroy();
    } else {
        sel_plan=0;
        obj_controller.cooldown=8000;
        if (obj_controller.menu=1 && obj_controller.view_squad){
            var company_data = obj_controller.company_data;
            var squad_index = company_data.company_squads[company_data.cur_squad];
            var current_squad=obj_ini.squads[squad_index];
            if (sel_plan>0){
                var planet = sel_plan;
                for (var i=0;i<array_length(target.p_operatives[planet]);i++){
                    operation = target.p_operatives[planet][i];
                    if (operation.type=="squad" && operation.reference == squad_index){
                        array_delete(target.p_operatives[planet], i, 1);
                    }
                } 
            }          
            current_squad.assignment="none";
        }
        instance_destroy();
    }          
}

if (obj_controller.cooldown<=0) and (loading==1){
	
}


attack=0;bombard=0;raid=0;purge=0;

if (player_fleet>0) and (imperial_fleet+mechanicus_fleet+inquisitor_fleet+eldar_fleet+ork_fleet+tau_fleet+heretic_fleet>0) and (obj_controller.cooldown<=0){
    var i,x3,y3;i=0;
    // x3=xx+46;y3=yy+252;
    x3=xx+49;y3=yy+441;
    
    var combating=0;
    
    repeat(7){i+=1;
        if (en_fleet[i]>0) and (mouse_x>=x3-24) and (mouse_y>=y3-24) and (mouse_x<x3+48) and (mouse_y<y3+48) and (obj_controller.cooldown<=0){
            obj_controller.cooldown=8;
            combating=en_fleet[i];
        }
        x3+=64;
    }
    
    if (combating>0){
        setup_fleet_battle(combating, target);

        if (instance_exists(obj_fleet)){
            start_fleet_battle();
        }
    }
}



/* */
}
}
}
/*  */
