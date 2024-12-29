// // Global singletons
// global.NameGenerator = new NameGenerator();
show_debug_message("Creating obj_ini");

// // normal stuff
use_custom_icon=0;
icon=0;icon_name="";

specials=0;firsts=0;seconds=0;thirds=0;fourths=0;fifths=0;
sixths=0;sevenths=0;eighths=0;ninths=0;tenths=0;commands=0;

heh1=0;heh2=0;

strin="";
strin2="";
tolerant=0;
companies=10;
progenitor=ePROGENITOR.NONE;
aspirant_trial = 0;

load_to_ships=[2,0,0];
if (instance_exists(obj_creation)){load_to_ships=obj_creation.load_to_ships;}

penitent=0;
penitent_max=0;
penitent_current=0;
penitent_end=0;
man_size=0;

// Equipment- maybe the bikes should go here or something?          yes they should
i=-1;
repeat(200){i+=1;
    equipment[i]="";
    equipment_type[i]="";
    equipment_number[i]=0;
    equipment_condition[i]=100;
    equipment_quality[i]=[];
    artifact[i]="";
    artifact_equipped[i]=false;
    artifact_tags[i]=[];
    artifact_identified[i]=0;
    artifact_condition[i]=100;
    artifact_quality[i]="artifact";
    artifact_loc[i]="";
    artifact_sid[i]=0;// Over 500 : ship
    // Weapon           Unidentified
    artifact_struct[i] =  new ArtifactStruct(i);    
}

var i=-1;
init_player_fleet_arrays();
ship_id = [];

var v;
var company=-1;
repeat(11){
    company+=1;v=-1;// show_message("v company: "+string(company));
    repeat(205){v+=1;// show_message(string(company)+"."+string(v));
        veh_race[company,v]=0;
        veh_loc[company,v]="";
        veh_name[company,v]="";
        veh_role[company,v]="";
        veh_wep1[company,v]="";
        veh_wep2[company,v]="";
        veh_wep3[company,v]="";
        veh_upgrade[company,v]="";
        veh_acc[company,v]="";
        veh_hp[company,v]=100;
        veh_chaos[company,v]=0;
        veh_pilots[company,v]=0;
        veh_lid[company,v]=-1;
        veh_wid[company,v]=2;
        veh_uid[company,v]=0;
    }
}

/*if (obj_creation.fleet_type=3){
    obj_controller.penitent=1;
    obj_controller.penitent_max=(obj_creation.maximum_size*1000)+300;
    if (obj_creation.chapter_name="Lamenters") then obj_controller.penitent_max=100300;
    obj_controller.penitent_current=300;
}*/

check_number=0;
year_fraction=0;
year=0;
millenium=0;
company_spawn_buffs = [];
role_spawn_buffs ={};
previous_forge_masters = [];
recruit_trial = 0;
recruiting_type="Death";

gene_slaves = [];
/* if (global.load=0){
    if (obj_creation.custom>0) then scr_initialize_custom();
    if (obj_creation.custom=0) then scr_initialize_standard();
}*/

if (instance_exists(obj_creation)) then custom=obj_creation.custom;

if (global.load=0) then scr_initialize_custom();




// 135;
// with(obj_creation){instance_destroy();}

/* */
/*  */
