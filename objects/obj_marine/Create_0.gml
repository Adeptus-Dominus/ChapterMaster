action = "move";
animation = "";
range = 400;
wounded = 0;

depth = (y * -1) / 2;

ii = 0;
blind_fire = 0;

target = 0;
target_re = 240 + floor(random(30)) + 1;

scr_colors_initialize();

main_color = 8;
secondary_color = 6;
right_pauldron = 6;
lens_color = 7;
main_trim = 15;
left_pauldron = 6;
weapon_color = 6;
col_special = 0;
trim = 1;
firing = 0;

marines_alive = 10;
marines_max = 10;

var i = -1;
repeat (21) {
    i += 1;
    marine[i] = 1;
    if (i > 10) {
        marine[i] = 0;
    }

    marine_co[i] = 2;
    marine_id[i] = 0;
    marine_role[i] = "Tactical";
    marine_name[i] = global.name_generator.generate_space_marine_name();

    marine_hp[i] = 100;
    marine_maxhp[i] = 100;
    marine_ac[i] = 20;
    marine_exp[i] = 50;

    marine_armour[i] = "";
    marine_gear[i] = "";
    marine_mobi[i] = "";

    marine_wep1[i] = "";
    marine_wep1_ammo[i] = 0;
    marine_wep1_reload[i] = 0;
    marine_wep1_reload_time[i] = 60;
    marine_wep1_spec[i] = 0; // For underslung or combi weapons
    marine_wep1_firerate[i] = 30; // If = tough opponents then set to like 10 instead
    marine_wep1_cooldown[i] = 0;
    marine_wep1_owner[i] = i;

    /*marine_wep2[i]="";
    marine_wep2_ammo[i]=0;
    marine_wep2_reload[i]=0;
    marine_wep2_spec[i]=0;*/
    marine_cqc[i] = 0;

    marine_ranged[i] = 1;
    marine_melee[i] = 1;
}

// Bolter Ammo: 50
// Bolter Reload: 10
// once reload = 0 then it sets reload to negative something; each step is +=1, once it gets to -1 then ammo-=10 and reload=10

i = -1;
repeat (41) {
    i += 1;
    weapon_group[i] = "";
    weapon_num[i] = 0;
    weapon_cool[i] = 0;
    weapon_range[i] = 0;
}

i = 0;
repeat (10) {
    i += 1;
    marine_armour[i] = "Power Armour";

    marine_wep1[i] = "Bolter";
    marine_wep1_ammo[i] = 40;
    marine_wep1_clip[i] = 10;
    marine_wep1_clip_size[i] = 10;
    marine_wep1_reload[i] = 0;
    marine_wep1_reload_time[i] = 60;
    marine_wep1_spec[i] = 0;
    marine_wep1_firerate[i] = 30;
    marine_wep1_range[i] = 400;

    if (i >= 8) {
        // if (i>=1){
        marine_wep1[i] = "Flamer";
        marine_wep1_ammo[i] = 0;
        marine_wep1_clip[i] = 6;
        marine_wep1_clip_size[i] = 6;
        marine_wep1_reload[i] = 0;
        marine_wep1_reload_time[i] = 999;
        marine_wep1_spec[i] = 0;
        marine_wep1_firerate[i] = 50;
        marine_wep1_range[i] = 200;
    }

    /*marine_wep2[i]="Chainsword";
    marine_wep2_ammo[i]=0;
    marine_wep2_reload[i]=999;*/
}

var i, n, g;
i = 0;
n = 0;
g = 0;
repeat (10) {
    i += 1;
    n = 0;
    g = 0;
    repeat (10) {
        if (g == 0) {
            n += 1;
            if ((weapon_group[n] == marine_wep1[i]) && (marine_wep1[i] != "") && (weapon_cool[n] == marine_wep1_firerate[i])) {
                g = n;
                weapon_num[n] += 1;
            }
        }
    }
    n = 0;
    repeat (10) {
        if (g == 0) {
            n += 1;
            if (weapon_group[n] == "") {
                g = n;
                weapon_group[n] = marine_wep1[i];
                weapon_cool[n] = marine_wep1_firerate[i];
                weapon_range[n] = marine_wep1_range[i];
                weapon_num[n] = 1;
            }
        }
    }
}

// show_message(string(weapon_num[2])+"x "+string(weapon_group[2])+", range:"+string(weapon_range[2]));

scr_shader_initialize();

/* */
/*  */
