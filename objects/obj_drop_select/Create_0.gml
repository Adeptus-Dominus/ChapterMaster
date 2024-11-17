
mouse_left=1;
attack=0;
once_only=0;

raid_tact=1;
raid_vet=1;
raid_assa=1;
raid_deva=1;
raid_scou=1;
raid_term=1;
raid_spec=1;
raid_wounded=obj_controller.select_wounded;
refresh_raid=0;
remove_local=1;

// 

var i;i=-1;formation_current=0;
repeat(100){i+=1;via[i]=0;
    if (i<=50) then force_present[i]=0;
    if (i<=12){formation_possible[i]=0;}
}

r_master=0;
r_honor=0;
r_capts=0;
r_mahreens=0;
r_veterans=0;
r_terminators=0;
r_dreads=0;
r_chaplains=0;
r_champions=0;
r_psykers=0;
r_apothecaries=0;
r_techmarines=0;
// Attack
r_bikes=0;

var __b__;
__b__ = action_if_number(obj_saveload, 0, 0);
if __b__
{

ship_names="";
sh_target=0;
p_target=0;
max_ships=0;
ships_selected=0;

purge=0;
purge_method=0;
purge_score=0;
purge_a=0;
purge_b=0;
purge_c=0;
purge_d=0;
tooltip="";
tooltip2="";
all_sel=0;


var i;i=-1;
repeat(61){
    i+=1;
    ship[i]="";
    ship_size[i]=0;
    ship_all[i]=0;
    ship_use[i]=0;
    ship_max[i]=0;
    ship_ide[i]=0;
}
i=500;
ship[i]="Local";
ship_size[i]=0;
ship_all[i]=0;
ship_use[i]=0;
ship_max[i]=0;
ship_ide[i]=-42;


menu=0;



master=0;
honor=0;
capts=0;
mahreens=0;
veterans=0;
terminators=0;
dreads=0;
chaplains=0;
champions=0;
psykers=0;
apothecaries=0;
techmarines=0;
// Attack
bikes=0;
rhinos=0;
whirls=0;
predators=0;
raiders=0;
speeders=0;

// These should be set to a negative value; that is, effectively, how much when it is selected (i.e. *-1)
l_master=0;
l_honor=0;
l_capts=0;
l_mahreens=0;
l_veterans=0;
l_terminators=0;
l_dreads=0;
l_chaplains=0;
l_champions=0;
l_psykers=0;
l_apothecaries=0;
l_techmarines=0;
l_size=0;
// Attack
l_bikes=0;
l_rhinos=0;
l_whirls=0;
l_predators=0;
l_raiders=0;
l_speeders=0;





attacking=0;
sisters=0;
eldar=0;
ork=0;
tau=0;
traitors=0;
tyranids=0;
csm=0;
necrons=0;
demons=0;


var j;j=-1;
repeat(501){j+=1;
    fighting[0,j]=0;veh_fighting[0,j]=0;
    fighting[1,j]=0;veh_fighting[1,j]=0;
    fighting[2,j]=0;veh_fighting[2,j]=0;
    fighting[3,j]=0;veh_fighting[3,j]=0;
    fighting[4,j]=0;veh_fighting[4,j]=0;
    fighting[5,j]=0;veh_fighting[5,j]=0;
    fighting[6,j]=0;veh_fighting[6,j]=0;
    fighting[7,j]=0;veh_fighting[7,j]=0;
    fighting[8,j]=0;veh_fighting[8,j]=0;
    fighting[9,j]=0;veh_fighting[9,j]=0;
    fighting[10,j]=0;veh_fighting[10,j]=0;
}


alarm[1]=1;

}

set_zoom_to_defualt();
