
unit="";
men=0;
veh=0;
dreads=0;
medi=0;
owner = eFACTION.Imperium;
engaged=0;
hostile_splash=0;
flank=0;
flyer=0;// Works same as flank, but does not get denoted as such
neww=0;

column_size=0;

unit_count=0;
unit_count_old=0;
composition_string="";

pos = 880;
centerline_offset = 0;
draw_size = 0;
x1 = pos + (centerline_offset * 2);
y1 = 450 - (draw_size / 2);
x2 = pos + (centerline_offset * 2) + 10;
y2 = 450 + (draw_size / 2);
if (obj_ncombat.enemy < array_length(global.star_name_colors) && obj_ncombat.enemy >= 0) {
    column_draw_colour = global.star_name_colors[obj_ncombat.enemy];
} else {
    column_draw_colour = c_dkgrey;
}


target_block = noone;



avg_attack=1;
avg_ranged=1;
avg_defense=1;
averages=1;


// x determines column; maybe every 10 or so?

weapon_stacks_normal = {};
weapon_stacks_vehicle = {};
weapon_stacks_unique = {};

var _enemy_size = 1002;
dude_co = array_create(_enemy_size, 0);
dude_id = array_create(_enemy_size, 0);

dudes = array_create(_enemy_size, "");
dudes_special = array_create(_enemy_size, "");
dudes_num = array_create(_enemy_size, 0);
dudes_onum = array_create(_enemy_size, -1);
dudes_ac = array_create(_enemy_size, 0);
dudes_hp = array_create(_enemy_size, 0);
dudes_dr = array_create(_enemy_size, 1);
dudes_vehicle = array_create(_enemy_size, 0);
dudes_damage = array_create(_enemy_size, 0);
dudes_exp = array_create(_enemy_size, 0);
dudes_powers = array_create(_enemy_size, "");
faith = array_create(_enemy_size, 0);

dudes_attack = array_create(_enemy_size, 1);
dudes_ranged = array_create(_enemy_size, 1);

dudes_wep1 = array_create(_enemy_size, "");
dudes_wep2 = array_create(_enemy_size, "");
dudes_gear = array_create(_enemy_size, "");
dudges_mobi = array_create(_enemy_size, "");


// if (obj_ncombat.enemy=1){alarm[1]=8;alarm[5]=10;}


hit = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fading_strength == false;
};
