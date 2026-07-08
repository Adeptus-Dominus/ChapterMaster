// Resets all variables related to ship creation
ship_id = 0;

action = "";
direction = 0;
/// @type {Id.Instance.obj_en_ship}
target = noone;
if (instance_exists(obj_en_ship)) {
    target = instance_nearest(x, y, obj_en_ship);
}

target_l = 0;
target_r = 0;

turn_bonus = 1;
speed_bonus = 1;

cooldown = array_create(6, 0);
turret_cool = 0;
shield_size = 0;

name = "";
class = "";
hp = 0;
maxhp = 0;
conditions = "";
owner = eFACTION.IMPERIUM;
shields = 1;
maxshields = 1;
armour_front = 0;
armour_other = 0;
weapons = 0;
turrets = 0;
fighters = 0;
bombers = 0;
thunderhawks = 0;

capacity = 0;
carrying = 0;
leadership = 0;
ship_size = 0;

weapon = array_create(SHIP_WEAPON_SLOTS, "");
weapon_facing = array_create(SHIP_WEAPON_SLOTS, "");
weapon_cooldown = array_create(SHIP_WEAPON_SLOTS, 0);
weapon_hp = array_create(SHIP_WEAPON_SLOTS, 0);
weapon_dam = array_create(SHIP_WEAPON_SLOTS, 0);
weapon_ammo = array_create(SHIP_WEAPON_SLOTS, 999);
weapon_range = array_create(SHIP_WEAPON_SLOTS, 0);
weapon_minrange = array_create(SHIP_WEAPON_SLOTS, 0);

alarm_set(0, 1);
