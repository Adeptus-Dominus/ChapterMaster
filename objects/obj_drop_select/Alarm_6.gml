
attacking=10;

var add_ground;add_ground=0;        // Local Forces here
var smin,smax,w;w=-1;smin=0;smax=0;

if (add_ground=1){ships_selected+=1;remove_local=-1;
    bikes+=l_bikes;rhinos+=l_rhinos;
    whirls+=l_whirls;predators+=l_predators;
    raiders+=l_raiders;speeders+=l_speeders;
    
    refresh_raid=1;ship_all[500]=1;ship_use[500]=ship_max[500];
}
if (add_ground=-1){ships_selected-=1;remove_local=1;
    bikes-=l_bikes;rhinos-=l_rhinos;
    whirls-=l_whirls;predators-=l_predators;
    raiders-=l_raiders;speeders-=l_speeders;
    
    refresh_raid=1;ship_all[500]=0;ship_use[500]=0;
}add_ground=0;


obj_controller.cooldown=30;combating=1;// Start battle here

instance_deactivate_all(true);
instance_activate_object(obj_controller);
instance_activate_object(obj_ini);
instance_activate_object(obj_drop_select);

instance_create(0,0,obj_ncombat);
obj_ncombat.battle_object=p_target;
obj_ncombat.battle_loc=p_target.name;
obj_ncombat.battle_id=obj_controller.selecting_planet;
obj_ncombat.dropping=0;obj_ncombat.attacking=10;
obj_ncombat.enemy=10;obj_ncombat.formation_set=1;

/*
obj_ncombat.battle_object=p_target;
obj_ncombat.battle_loc=p_target.name;
obj_ncombat.battle_id=obj_controller.selecting_planet;
obj_ncombat.dropping=1-attack;
obj_ncombat.attacking=attack;
obj_ncombat.enemy=attacking;
obj_ncombat.formation_set=formation_possible[formation_current];
*/

if (ship_all[500]=1) then obj_ncombat.local_forces=1;

obj_ncombat.leader=1;obj_ncombat.threat=5;
obj_ncombat.battle_special="WL10_later";

/*
argument0.p_heresy[argument1]+=floor(random_range(20,50));
argument0.p_traitors[argument1]=5;
argument0.p_chaos[argument1]=4;
argument0.p_owner[argument1]=10;
*/

var co, v, stop;
co=0;v=0;stop=0;  
repeat(3600){
    if (co<11){v+=1;
        if (v>300){co+=1;v=1;}
        if (co>10) then stop=1;
        if (stop=0){
            if (fighting[co][v]!=0){obj_ncombat.fighting[co][v]=1;}// show_message(string(co)+":"+string(v)+" is fighting");
            if (attack=1) and (v<=100){
                if (veh_fighting[co][v]!=0) then obj_ncombat.veh_fighting[co][v]=1;
            }
            if (attack=1) and (ship_all[500]=1){
            if (obj_ini.loc[co][v]=p_target.name) and (obj_ini.TTRPG[co][v].planet_location==obj_controller.selecting_planet) and (fighting[co][v]=1) then obj_ncombat.fighting[co][v]=1;
                if (v<=100){if (obj_ini.veh_loc[co][v]=p_target.name) and (obj_ini.veh_wid[co][v]=obj_controller.selecting_planet) then obj_ncombat.veh_fighting[co][v]=1;}
            }
        }
    }
}

// Iterates through all selected "ships" (max 30), including the planet (Local on the drop menu), 
// and fills the battle roster with any marines found.
ships_selected=0;
var ships_len = array_length(ship_all);
for (var i = 0; i < ships_len; i++) {
    if (ship_all[i]!=0) then scr_battle_roster(ship[i],ship_ide[i],false);
}
//ship_all[500] equals "Local" status on the drop menu
if (ship_all[500]=1) and (attack=1) then scr_battle_roster(p_target.name,obj_controller.selecting_planet,true);


instance_destroy();



/* */
/*  */
