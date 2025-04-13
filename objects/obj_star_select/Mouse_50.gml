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

var xx, yy, dist, close;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;
dist=999;close=false;




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
        if (obj_controller.menu=1 && obj_controller.managing>0 && obj_controller.view_squad){
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
            obj_controller.cooldown=8;combating=en_fleet[i];
        }
        x3+=64;
    }
    
    if (combating>0){
        obj_controller.combat=combating;
    
        var  xx=false, yy=false, good=false, e1=false,e2=false,e3=false;


        var enemy_fleet = array_create(20, 0);
        var allied_fleet = array_create(20, 0);
        var ecap = array_create(20, 0);
        var efri = array_create(20, 0);
        var eesc = array_create(20, 0);
        var acap = array_create(20, 0);
        var afri = array_create(20, 0);
        var aesc = array_create(20, 0);
        
        good=1;
        
        var  p_fleet = get_nearest_player_fleet(x,y,true);
        
        obj_controller.temp[1099]=target.name;
        good = (p_fleet!="none" and instance_exists(target));

        if (good=1){// trying to find the star
            instance_activate_object(obj_star);
            obj_controller.x=target.x;
            obj_controller.y=target.y;// show=current_battle;
            
            strin[1]=string(p_fleet.capital_number);
            strin[2]=string(p_fleet.frigate_number);
            strin[3]=string(p_fleet.escort_number);
            // pull health values here
            strin[4]=string(p_fleet.capital_health);
            strin[5]=string(p_fleet.frigate_health);
            strin[6]=string(p_fleet.escort_health);
            
            // pull enemy ships here
            
            var e=1;
            var khorne_count=0;
            var chaos_space_marine_count=0;
            var en_capitals, en_frigates, en_escorts;
            repeat(9){e+=1;
                if (target.present_fleet[e]>0){
                    obj_controller.temp[1070]=target.id;
                    obj_controller.temp[1071]=e;
                    en_capitals=0;
                    en_frigates=0;
                    en_escorts=0;
                    
                    with(obj_en_fleet){
                        if (orbiting=obj_controller.temp[1070]) and (owner=obj_controller.temp[1071]){
                            en_capitals+=capital_number;
                            en_frigates+=frigate_number;
                            en_escorts+=escort_number;
                            if (string_count("BLOOD",trade_goods)>0) then khorne_count++;
                            if (string_lower(trade_goods)="csm") then chaos_space_marine_count++;
                        }
                    }
                    
                    var l1,l2;l1=0;l2=0;
                    if (obj_controller.faction_status[e]!="War") and (e!=combating){
                        repeat(10){
                            l1+=1;
                            if (allied_fleet[l1]=0) and (l2=0) then l2=l1;
                        }
                        allied_fleet[l2]=e;
                        acap[l2]=en_capitals;
                        afri[l2]=en_frigates;
                        aesc[l2]=en_escorts;
                    }else if (obj_controller.faction_status[e]="War") or (e=9) or (e=combating){
                        repeat(10){
                            l1+=1;
                            if (enemy_fleet[l1]=0) and (l2=0) then l2=l1;
                        }
                        enemy_fleet[l2]=e;
                        ecap[l2]=en_capitals;
                        efri[l2]=en_frigates;
                        eesc[l2]=en_escorts;
                    }
                }
            }
        

            obj_controller.cooldown=8000;
            
            // Start battle here
            
            combating=1;
            
            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            // instance_activate_object(battle_object[current_battle]);
            instance_activate_object(p_fleet);
            instance_activate_object(obj_star);
            
            instance_create(0,0,obj_fleet);
            obj_fleet.star_name=target.name;
            // 
            obj_fleet.enemy[1]=enemy_fleet[1];
            obj_fleet.enemy_status[1]=-1;
            
            obj_fleet.en_capital[1]=ecap[1];
            obj_fleet.en_frigate[1]=efri[1];
            obj_fleet.en_escort[1]=eesc[1];
            
            // Plug in all of the enemies first
            // And then plug in the allies after then with their status set to positive
            
            if (chaos_space_marine_count){
                obj_fleet.csm_exp=1;
            }
            if (khorne_count){
                obj_fleet.csm_exp=2;
            }
            
            
            for (var i=0;i<target.planets;i++){
                 if (planet_feature_bool(target.p_feature[i], P_features.Monastery) == 1) then obj_fleet.player_lasers=target.p_lasers[i];
            }
            instance_deactivate_object(obj_star);
            

            add_fleet_ships_to_combat(p_fleet, obj_fleet);

            // instance_deactivate_object(battle_object[current_battle]);
            instance_deactivate_object(p_fleet);
            
            
            
            obj_controller.combat=1;
            obj_fleet.player_started=1;
            obj_fleet.pla_fleet=p_fleet;
            obj_fleet.ene_fleet=target;
            
        
        
        }
    }
}



/* */
}
}
}
/*  */
