
ship_id=0;
master_present=0;
o_dist=0;

selected=0;
sel_x1=0;
sel_y1=0;
sel_x2=0;
sel_y2=0;

// if (x<0) then ship_id=2;

action="";paction="";
action_dis=0;
action_dir=0;
action_fac=0;
direction=0;
target=-50;
if (instance_exists(obj_en_ship)){
    target=instance_nearest(x,y,obj_en_ship);
}

target_l=0;
target_r=0;
target_x=0;
target_y=0;

cooldown = array_create(6, 0);
turret_cool=0;
shield_size=0;

board_capital=false;
board_frigate=false;

name="";
class="";
hp=0;
maxhp=0;
conditions="";
shields=1;
maxshields=1;
armour_front=0;
armour_other=0;
weapons=0;
turrets=0;
fighters=0;
bombers=0;
thunderhawks=0;
boarders=0;
board_cooldown=0;

weapon = array_create(8, "");
weapon_facing=array_create(8, "");
weapon_cooldown=array_create(8, 0);
weapon_hp=array_create(8, 0);
weapon_dam=array_create(8, 0);
weapon_ammo=array_create(8, 0);
weapon_range=array_create(8, 0);
weapon_minrange=array_create(8, 0);

board_co=[];
board_id=[];
board_location=[];
board_raft=[];
//action_set_alarm(1, 0);
