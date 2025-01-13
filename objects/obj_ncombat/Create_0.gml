if (instance_number(obj_ncombat)>1) then  instance_destroy();

set_zoom_to_default();
var co,i;co=-1;
repeat(15){co+=1;i=-1;
    repeat(401){i+=1;
        fighting[co][i]=0;
        if (i<=150){veh_fighting[co][i]=0;}
    }
}co=0;i=0;hue=0;

turn_count = 0;
debugl("Ground Combat Started");

audio_stop_sound(snd_royal);
audio_play_sound(snd_battle,0,true);
audio_sound_gain(snd_battle, 0, 0);
var nope=0;if (obj_controller.master_volume=0) or (obj_controller.music_volume=0) then nope=1;
if (nope!=1){audio_sound_gain(snd_battle,0.25*obj_controller.master_volume*obj_controller.music_volume,2000);}


//limit on the size of the players forces allowed
man_size_limit = 0;
man_limit_reached = false;
man_size_count = 0;
fack=0;
cd=0;
owner  = eFACTION.Player;
click_stall_timer=0;
formation_set=0;
big_boom=0;
kamehameha=false;
on_ship=false;
alpha_strike=0;
Warlord = 0;
total_battle_exp_gain=0;
end_alive_units = [];
average_battle_exp_gain=0;
upgraded_librarians=[];

view_x=obj_controller.x;view_y=obj_controller.y;
obj_controller.x=0;obj_controller.y=0;
if (obj_controller.zoomed==1){with(obj_controller){scr_zoom();}}
xxx=200;
instance_activate_object(obj_cursor);
instance_activate_object(obj_ini);
instance_activate_object(obj_img)

var i,u;i=11;
repeat(10){i-=1;// This creates the objects to then be filled in
    u=instance_create(i*10,240,obj_pnunit);
}

instance_create(0,0,obj_centerline);

local_forces=0;
battle_loc="";
battle_climate="";
battle_id=0;
battle_object=0;
battle_special="";
defeat=0;
defeat_message=0;
red_thirst=0;
fugg=0;fugg2=0;
battle_over=0;
done=0;

captured_gaunt=0;
ethereal=0;
hulk_treasure=0;
four_show=0;
chaos_angry=0;

leader=0;
thirsty=0;
really_thirsty=0;
allies=0;
present_inquisitor=0;sorcery_seen=0;
inquisitor_ship=0;
guard_total=0;
guard_effective=0;
player_starting_dudes=0;
chapter_master_psyker=0;
guard_pre_forces=0;
ally=0;
ally_forces=0;
ally_special=0;

global_perils=0;
exterminatus=0;
plasma_bomb=0;

display_p1=0;display_p1n="";
display_p2=0;display_p2n="";


alarm[0]=2;
alarm[1]=3;
obj_pnunit.alarm[3]=1;
alarm[2]=8;


started=0;
charged=0;

fadein=40;
enemy=0;
threat=0;
fortified=0;
enemy_fortified=0;
wall_destroyed=0;
enem="Orks";enem_sing="Ork";
flank_x=0;

player_forces=0;player_max=0;
player_defenses=0;player_silos=0;

enemy_forces=0;enemy_max=0;
hulk_forces=0;

i=-1;messages=0;messages_to_show=4;messages_shown=0;
largest=0;priority=0;random_messages=0;dead_enemies=0;
repeat(70){i+=1;
    lines[i]="";
    lines_color[i]="";
    message[i]="";
    message_sz[i]=0;
    message_priority[i]=0;
    dead_jim[i]="";
    dead_ene[i]="";
    dead_ene_n[i]=0;
    
    post_unit_lost[i]="";
    post_unit_veh[i]=0;
    post_units_lost[i]=0;
    post_geneseed_recovered[i]=0;
    post_equipment_lost[i]="";
    post_equipments_lost[i]=0;
    
    crunch[i]=0;
    
    if (i<=10) then mucra[i]=0;
}
slime=0;
unit_recovery_score=0;
apothecaries_alive=0;
techmarines_alive=0;
vehicle_recovery_score=0;
injured=0;
command_injured=0;
seed_saved=0;
seed_max=0;
units_saved=0;
command_saved=0;
vehicles_saved=0;
final_deaths=0;
final_command_deaths=0;
vehicle_deaths=0;
casualties=0;
command_casualties=0;
dead_jims=0;
newline="";
newline_color="";
liness=0;
world_size=0;
gene_penalty=0;

timer=0;
timer_stage=0;
timer_speed=0;
timer_maxspeed=1;
timer_pause=-1;
turns=1;


// 

scouts=0;
tacticals=0;
veterans=0;
devastators=0;
assaults=0;
librarians=0;
techmarines=0;
honors=0;
dreadnoughts=0;
terminators=0;
captains=0;
standard_bearers=0;
champions=0;
important_dudes=0;
chaplains=0;
apothecaries=0;
sgts=0;
vet_sgts=0;

rhinos=0;
predators=0;
land_raiders=0;
whirlwinds=0;

big_mofo=10;




en_scouts=0;
en_tacticals=0;
en_sgts=0;
en_vet_sgts=0;
en_veterans=0;
en_devastators=0;
en_assaults=0;
en_librarians=0;
en_techmarines=0;
en_honors=0;
en_dreadnoughts=0;
en_terminators=0;
en_captains=0;
en_standard_bearers=0;
en_important_dudes=0;
en_chaplains=0;
en_apothecaries=0;

en_big_mofo=10;
en_important_dudes=0;

// 

defending=true;// 1 is defensive
dropping=0;// 0 is was on ground
attacking=0;// 1 means attacked from space/local
time=floor(random(24))+1;
terrain="";
weather="";

ambushers=0;if (scr_has_adv("Ambushers")) then ambushers=1;
bolter_drilling=0;if (scr_has_adv("Bolter Drilling")) then bolter_drilling=1;
enemy_eldar=0;if (scr_has_adv("Enemy: Eldar")) then enemy_eldar=1;
enemy_fallen=0;if (scr_has_adv("Enemy: Fallen")) then enemy_fallen=1;
enemy_orks=0;if (scr_has_adv("Enemy: Orks")) then enemy_orks=1;
enemy_tau=0;if (scr_has_adv("Enemy: Tau")) then enemy_tau=1;
enemy_tyranids=0;if (scr_has_adv("Enemy: Tyranids")) then enemy_tyranids=1;
enemy_necrons=0;if (scr_has_adv("Enemy: Necrons")) then enemy_necrons=1;
lightning=0;if (scr_has_adv("Lightning Warriors")) then lightning=1;
siege=0;if (scr_has_adv("Siege Masters")) then siege=1;
slow=0;if (scr_has_adv("Devastator Doctrine")) then slow=1;
melee=0;if (scr_has_adv("Assault Doctrine")) then melee=1;
// 
black_rage=0;if (scr_has_disadv("Black Rage")){black_rage=1;red_thirst=1;}
shitty_luck=0;if (scr_has_disadv("Shitty Luck")) then shitty_luck=1;
warp_touched=0;if (scr_has_disadv("Warp Touched")) then warp_touched=1;


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
// 
if (ambushers=1) and (ambushers=999) then global_attack=global_attack*1.1;
if (bolter_drilling=1) then global_bolter=global_bolter*1.1;
if (enemy_eldar=1) and (enemy=6){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (enemy_fallen=1) and (enemy=10){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (enemy_orks=1) and (enemy=7){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (enemy_tau=1) and (enemy=8){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (enemy_tyranids=1) and (enemy=9){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (enemy_necrons=1) and (enemy=13){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}

if (siege=1) and (enemy_fortified>=3) and (defending=false) then global_attack=global_attack*1.2;


if (slow=1){global_attack-=0.1;global_defense+=0.2;}
if (lightning=1){global_attack+=0.2;global_defense-=0.1;}
if (melee=1) then global_melee=global_melee*1.15;
// 
if (shitty_luck=1) then global_defense=global_defense*0.9;
if (lyman=1) and (dropping=1){global_attack=global_attack*0.85;global_defense=global_defense*0.9;}
if (ossmodula=1){global_attack=global_attack*0.95;global_defense=global_defense*0.95;}
if (betchers=1) then global_melee=global_melee*0.95;
if (catalepsean=1){global_attack=global_attack*0.95;}
if (occulobe=1){if (time=5) or (time=6){global_attack=global_attack*0.7;global_defense=global_defense*0.8;}}

enemy_dudes="";
global_defense=2-global_defense;

