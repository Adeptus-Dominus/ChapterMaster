ship_id = 0;
owner = 0;

action = "";
direction = 180;
// if (instance_exists(obj_p_ship)){target=instance_nearest(x,y,obj_p_ship);}
target_l = 0;
target_r = 0;
target = 0;
hostile = 1;
lightning = 0;
whip = 0;
bridge = 0;

cooldown = array_create(6, 0);
turret_cool = 0;

name = "";
class = "";
size = 0;
hp = 0;
maxhp = 0;
conditions = "";
shields = 1;
maxshields = 1;
armour_front = 0;
armour_other = 0;
weapons = 0;
turrets = 0;

turn_bonus = 1;
speed_bonus = 1;

var _size = 8;
weapon = array_create(_size, "");
weapon_facing = array_create(_size, "");
weapon_cooldown = array_create(_size, 0);
weapon_hp = array_create(_size, 0);
weapon_dam = array_create(_size, 0);
weapon_ammo = array_create(_size, 999);
weapon_range = array_create(_size, 0);
weapon_minrange = array_create(_size, 0);

action_set_alarm(1, 0);
