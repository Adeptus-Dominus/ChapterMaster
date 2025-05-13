
unit="";
men=0;
veh=0;
charge=0;
engaged=0;
owner  = eFACTION.Player;
medi=0;
attacked_dudes=0;
dreads=0;
jetpack_destroy=0;
defenses=0;

unit_count=0;
unit_count_old=0;
composition_string="";

column_size = 0;

pos = 880;
draw_size = 0;
x1 = pos;
y1 = 450 - (draw_size / 2);
x2 = pos + 10;
y2 = 450 + (draw_size / 2);

// let="";let=string_delete(obj_ini.psy_powers,2,string_length(obj_ini.psy_powers)-1);let=string_upper(let);
// LET might be different for each marine; need a way of determining this

// show_message(let);
// x determines column; maybe every 10 or so?
// For fortified locations maybe create a wall unit for the player?

unit_struct =[];
marine_type=[];
marine_co=[];
marine_id=[];
marine_hp=[];
marine_ac=[];
marine_exp=[];
marine_wep1=[];
marine_wep2=[];
marine_armour=[];
marine_gear=[];
marine_mobi=[];
marine_powers=[];
marine_dead=[];
marine_attack=[];
marine_ranged=[];
marine_defense=[];
marine_casting=[];
marine_casting_cooldown=[];
marine_local=[];
ally=[];

//* Psychic power buffs
// this would be set to the turns remaining
// so long as >0 would apply an effect
marine_mshield=[];
marine_quick=[];
marine_might=[];
marine_fiery=[];
marine_fshield=[];
marine_iron=[];
marine_dome=[];
marine_spatial=[];
marine_dementia=[];

var _vehicles_size = 1500;
veh_co = array_create(_vehicles_size, 0);
veh_id = array_create(_vehicles_size, 0);
veh_type = array_create(_vehicles_size, "");
veh_hp = array_create(_vehicles_size, 0);
veh_ac = array_create(_vehicles_size, 0);
veh_wep1 = array_create(_vehicles_size, "");
veh_wep2 = array_create(_vehicles_size, "");
veh_wep3 = array_create(_vehicles_size, "");
veh_upgrade = array_create(_vehicles_size, "");
veh_acc = array_create(_vehicles_size, "");
veh_dead = array_create(_vehicles_size, 0);
veh_local = array_create(_vehicles_size, 0);
veh_ally = array_create(_vehicles_size, false);

weapon_stacks_normal = {};
weapon_stacks_vehicle = {};
weapon_stacks_unique = {};

var _dudes_size = 72;
dudes = array_create(_dudes_size, "");
dudes_num = array_create(_dudes_size, 0);
dudes_vehicle = array_create(_dudes_size, 0);


// These arrays are the losses on any one frame.
// Let them resize as required.
// Hardcoded lengths lead to bounds issues when hardcoded values disagree.
lost_units = {};

hostile_shots=0;
hostile_shooters=0;
hostile_damage=0;
hostile_weapon="";
hostile_unit="";
hostile_type=0;
hostile_splash=0;

is_mouse_over = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fading_strength == 0;
};
