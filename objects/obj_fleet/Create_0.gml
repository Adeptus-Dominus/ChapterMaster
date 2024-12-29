

instance_activate_object(obj_controller);
debugl("Fleet Combat Started");

beg=0;fallen=0;fallen_command=0;
obj_controller.cooldown=20;
sel_x1=0;sel_y1=0;control=0;
ships_selected=0;
battle_special="";
csm_exp=0;star_name="";

// woohoo=0;
left_down=0;

view_x=obj_controller.x;
view_y=obj_controller.y;
obj_controller.x=0;
obj_controller.y=240;
obj_controller.combat=1;
is_zoomed=obj_controller.zoomed;
start=0;combat_end=170;

if (obj_controller.zoomed=0) then with(obj_controller){scr_zoom();}

enemy=0;
enemy_status="attacking";

tempor1=0;
tempor2=0;

player_started=0;
player_lasers=0;
player_lasers_cd=70;
player_lasers_target=0;
pla_fleet=0;
ene_fleet=0;
victory=false;

instance_deactivate_all(true);
instance_activate_object(obj_controller);
instance_activate_object(obj_ini);
instance_activate_object(obj_cursor);
instance_activate_object(obj_img);

column[0]="";
column_width[0]=0;// This is determined at the pre-battle screen
column[1]="";
column_width[1]=0;
column[2]="";
column_width[2]=0;
column[3]="";
column_width[3]=0;
column[4]="";
column_width[4]=0;
column[5]="";
column_width[5]=0;// Furthest right


threat=4;
var k,j;
k=-1;
j=-1;


repeat(6){k+=1;j=-1;
    repeat(11){j+=1;
        enemy[j]=0;
        enemy_status[j]=0;
        
        /*en_column[j,k]="";
        en_width[j,k]=0;en_height[j,k]=0;
        en_num[j,k]=0;en_size[j,k]=0;*/
        
        en_capital[j]=0;
        en_capital_max[j]=0;
        en_capital_lost[j]=0;
        en_frigate[j]=0;
        en_frigate_max[j]=0;
        en_frigate_lost[j]=0;
        en_escort[j]=0;
        en_escort_max[j]=0;
        en_escort_lost[j]=0;
        en_ships_max[j]=0;
    }
}
// Should be 0-5 for each of the factions





capital=0;capital_max=0;capital_lost=0;
frigate=0;frigate_max=0;frigate_lost=0;
escort=0;escort_max=0;escort_lost=0;
thunderhawk=0;thunderhawk_list=0;
ships_max=0;
ships_damaged=0;

marines_lost=0;

en_mutation=[];
en_mutation[0]="";
en_mutation[1]="";
en_mutation[2]="";

// 
ambushers=0;if (string_count("Ambushers",obj_ini.strin)>0) then ambushers=1;
bolter_drilling=0;if (string_count("Bolter",obj_ini.strin)>0) then bolter_drilling=1;
enemy_eldar=0;if (string_count("Enemy: Eldar",obj_ini.strin)>0) then enemy_eldar=1;
enemy_fallen=0;if (string_count("Enemy: Fallen",obj_ini.strin)>0) then enemy_fallen=1;
enemy_orks=0;if (string_count("Enemy: Orks",obj_ini.strin)>0) then enemy_orks=1;
enemy_tau=0;if (string_count("Enemy: Tau",obj_ini.strin)>0) then enemy_tau=1;
enemy_tyranids=0;if (string_count("Enemy: Tyraninids",obj_ini.strin)>0) then enemy_tyranids=1;
siege=0;if (string_count("Siege",obj_ini.strin)>0) then siege=1;
slow=0;if (string_count("Purposeful",obj_ini.strin)>0) then slow=1;
melee=0;if (string_count("Melee Enthus",obj_ini.strin)>0) then melee=1;
// 
black_rage=0;if (string_count("Black Rage",obj_ini.strin2)>0) then black_rage=1;
shitty_luck=0;if (string_count("Shitty",obj_ini.strin2)>0) then shitty_luck=1;
warp_touched=0;if (string_count("Warp Touched",obj_ini.strin2)>0) then warp_touched=1;
lyman=obj_ini.lyman;// drop pod penalties
omophagea=obj_ini.omophagea;// feast
ossmodula=obj_ini.ossmodula;// small penalty to all
membrane=obj_ini.membrane;// less chance of survival for wounded
betchers=obj_ini.betchers;// slight melee penalty
catalepsean=obj_ini.catalepsean;// minor global attack decrease
occulobe=obj_ini.occulobe;// penalty if morning and susceptible to flash grenades
mucranoid=obj_ini.mucranoid;// chance to short-circuit
// 
global_melee=1;
global_bolter=1;
global_attack=1;
global_defense=1;

// STC Bonuses
if (obj_controller.stc_bonus[5]=1) then global_defense+=0.1;
if (obj_controller.stc_bonus[5]=2) then global_attack=1.05;
if (obj_controller.stc_bonus[6]=1) then global_defense+=0.1;

// Kings of Space Bonus
if (string_count("Kings of Space",obj_ini.strin)>0){control=1;global_defense+=0.1;global_attack+=0.1;}



// 
master=0;
time=0;


init_player_fleet_arrays();
ship_id = [];


// screwing around below here
alarm[6]=2;
// 
// waiting at this point- show loading screen
// in this time the obj_controller passes over which units will be fighting, similar to the below code

column[0]="";
column_width[0]=0;
column_num[0]=0;// This is determined at the pre-battle screen
column[1]="";
column_width[1]=0;
column_num[1]=0;
column[2]="";
column_width[2]=0;
column_num[3]=0;
column[3]="capital";
column_width[3]=270;
column_num[3]=0;
column[4]="frigate";
column_width[4]=140;
column_num[4]=0;
column[5]="escort";
column_width[5]=76;
column_num[5]=0;// Furthest right


color_index=0;

/* */
/*  */
