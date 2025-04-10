
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

centerline_offset = 0;
pos = 880;
draw_size = 0;
x1 = pos + (centerline_offset * 2);
y1 = 450 - (draw_size / 2);
x2 = pos + (centerline_offset * 2) + 10;
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

var i;i=-1;
repeat(1500){i+=1;
    //
    veh_co[i]=0;
    veh_id[i]=0;
    veh_type[i]="";
    veh_hp[i]=0;
    veh_ac[i]=0;
    veh_wep1[i]="";
    veh_wep2[i]="";
    veh_wep3[i]="";
    veh_upgrade[i]="";
    veh_acc[i]="";
    veh_dead[i]=0;
    veh_hp_multiplier[i]=1;
    veh_local[i]=0;
    veh_ally[i]=false;
}

i=-1;
repeat(71){i+=1;
    wep[i]="";
    wep_num[i]=0;
    wep_rnum[i]=0;
    range[i]=0;
    att[i]=0;
    apa[i]=0;
    ammo[i]=-1;
    splash[i]=0;
    wep_owner[i]="";
    wep_solo[i]=[];
    wep_title[i]="";

    dudes[i]="";
    dudes_num[i]=0;
    dudes_vehicle[i]=0;
}

// These arrays are the losses on any one frame.
// Let them resize as required.
// Hardcoded lengths lead to bounds issues when hardcoded values disagree.
lost = [];
lost_num = [];

hostile_shots=0;
hostile_shooters=0;
hostile_damage=0;
hostile_weapon="";
hostile_unit="";
hostile_type=0;
hostile_splash=0;

alarm[1]=4;

action_set_alarm(1, 3);

hit = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fadein <= 0;
};
