
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


enemy=0;
enemy2=0;



avg_attack=1;
avg_ranged=1;
avg_defense=1;
averages=1;


// x determines column; maybe every 10 or so?

var i;i=0;
i=0;

wep = [];
wep_num = [];
combi = [];
range = [];
att = [];
apa = [];
ammo = [];
splash = [];
wep_owner = [];

dude_co = [];
dude_id = [];

dudes = [];
dudes_special = [];
dudes_num = [];
dudes_onum = [];
dudes_ac = [];
dudes_hp = [];
dudes_dr = [];
dudes_vehicle = [];
dudes_damage = [];
dudes_exp = [];
dudes_powers = [];
faith = [];

dudes_attack = [];
dudes_ranged = [];
dudes_defense = [];

dudes_wep1 = [];
dudes_wep2 = [];
dudes_gear = [];
dudges_mobi = [];


alarm[1]=5;
alarm[5]=6;
if (obj_ncombat.enemy=1) then alarm[6]=10;

// if (obj_ncombat.enemy=1){alarm[1]=8;alarm[5]=10;}


hit = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fadein <= 0;
};
