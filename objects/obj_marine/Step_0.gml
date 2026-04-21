if (instance_number(obj_ork) > 30) {
    blind_fire = 1;
} else {
    blind_fire = 0;
}

if (blind_fire == 0) {
    if ((!instance_exists(target)) || (target == 0)) {
        target = 0;
        if (instance_exists(obj_ork)) {
            target = instance_nearest(x, y, obj_ork);
            target_re = 240 + floor(random(30)) + 1;
        }
    }
    var trange;
    trange = 9999;
    if (instance_exists(target)) {
        trange = point_distance(x, y, target.x, target.y);

        target_re -= 1;
        if (target_re == 0) {
            target = instance_nearest(x, y, obj_ork);
            target_re = 240 + floor(random(30)) + 1;
        }

        if (point_distance(x, y, target.x, target.y) > range) {
            if ((action == "") || ((action == "move") && (animation == ""))) {
                action = "move";
                animation = "move";
                ii = choose(1, 2, 3);
            }
        }
        if (point_distance(x, y, target.x, target.y) <= range) {
            if (action == "move") {
                action = "";
                animation = "settle";
                ii = 0;
            }
            if ((action == "") && (animation == "settle") && (ii == 2)) {
                action = "fire";
                animation = "";
                ii = 0;
            }
        }
    }
}

if (blind_fire == 1) {
    // obj_enemy_leftest

    var trange;
    trange = 9999;
    if (instance_exists(obj_enemy_leftest)) {
        trange = point_distance(x, 0, obj_enemy_leftest.x, 0);

        if (point_distance(x, 0, obj_enemy_leftest.x, 0) > range) {
            if ((action == "") || ((action == "move") && (animation == ""))) {
                action = "move";
                animation = "move";
                ii = choose(1, 2, 3);
            }
        }
        if (point_distance(x, 0, obj_enemy_leftest.x, 0) <= range) {
            if (action == "move") {
                action = "";
                animation = "settle";
                ii = 0;
            }
            if ((action == "") && (animation == "settle") && (ii == 2) && collision_line(x, y, x + 1000, y, obj_ork, 0, 1)) {
                action = "fire";
                animation = "";
                ii = 0;
            }
        }
    }
}

if (action == "") {
    speed = 0;
}

if (animation == "settle") {
    ii += 1;
}

if (action == "move") {
    animation = "walk";
    speed = 2;
    ii += 1;
}
if (action == "fire") {
    // Decide which weapon to use

    var i, m;

    i = 0;
    repeat (10) {
        i += 1;
        if (marine_wep1_cooldown[i] > 0) {
            marine_wep1_cooldown[i] -= 1;
        }

        if (marine_wep1_reload[i] > 0) {
            marine_wep1_reload[i] -= 1;

            if (marine_wep1_reload[i] == 1) {
                var relo;
                relo = min(marine_wep1_ammo[i], marine_wep1_clip_size[i]);
                marine_wep1_ammo[i] -= relo;
                marine_wep1_clip[i] += relo;
                marine_wep1_reload[i] = 0;
            }
        }
    }

    i = 0;
    m = 0;
    repeat (20) {
        i += 1;
        m = 0;

        if ((weapon_group[i] != "") && (weapon_range[i] >= trange) && (instance_exists(target) || ((blind_fire == 1) && (weapon_range[i] >= trange)))) {
            var bull;
            bull = 0;

            repeat (10) {
                m += 1;
                if ((marine[marine_wep1_owner[m]] == 1) && (marine_wep1[m] == weapon_group[i]) && (marine_wep1_clip[m] > 0)) {
                    if ((marine_wep1_reload[m] <= 0) && (marine_wep1_cooldown[m] <= 0) && (marine_wep1_range[m] > 50)) {
                        if ((blind_fire == 0) || ((blind_fire == 1) && collision_line(x, y, x + marine_wep1_range[m], y, obj_ork, 0, 1))) {
                            if ((!instance_exists(bull)) || (bull == 0)) {
                                bull = instance_create(x + 23, y - 24, obj_p1_bullet);
                            }
                            bull.image_speed = 0;

                            if (instance_exists(target) || (blind_fire == 1)) {
                                // Appearance
                                bull.projectile_infos += 1;
                                if (marine_wep1[m] == "Bolter") {
                                    bull.sprite_index = spr_bolt;
                                    bull.image_index = 0;
                                    bull.speed = 40;
                                    if (blind_fire == 0) {
                                        bull.direction = point_direction(bull.x, bull.y, target.x, target.y) + floor(random_range(-4, 4)) + 1;
                                    }
                                    if (blind_fire == 1) {
                                        bull.direction = self.direction + floor(random_range(-8, 8)) + 1;
                                    }
                                    bull.projectile_damage[bull.projectile_infos] = 30;
                                    bull.projectile_arp[bull.projectile_infos] = 0;
                                }
                                if (marine_wep1[m] == "Flamer") {
                                    bull.sprite_index = spr_flame2;
                                    bull.image_index = 0;
                                    bull.speed = 0;
                                    bull.image_speed = 1;
                                    if (blind_fire == 0) {
                                        bull.direction = point_direction(bull.x, bull.y, target.x, target.y) + floor(random_range(-4, 4)) + 1;
                                    }
                                    if (blind_fire == 1) {
                                        bull.direction = self.direction + floor(random_range(-8, 8)) + 1;
                                    }
                                    bull.projectile_damage[bull.projectile_infos] = 160;
                                    bull.projectile_arp[bull.projectile_infos] = -1;
                                }
                            }

                            bull.projectile_range[bull.projectile_infos] = 450;
                            if (marine_wep1_clip[m] < 900) {
                                marine_wep1_clip[m] -= 1;
                            }
                            if ((marine_wep1_clip[m] == 0) && (marine_wep1_ammo[m] > 0) && (marine_wep1_reload[m] <= 0)) {
                                marine_wep1_reload[m] = marine_wep1_reload_time[m] + 1;
                            }

                            marine_wep1_cooldown[m] = marine_wep1_firerate[m];
                            firing = 1;
                        }
                    }
                }
            }
        }
    }

    /*
    weapon_group[i]="";
    weapon_num[i]=0;
    weapon_cool[i]=0;
    weapon_range[i]=0;
    
    marine_wep1_ammo[i]=50;
    marine_wep1_clip[i]=10;
    marine_wep1_reload[i]=0;
    marine_wep1_reload_time[i]=60;
    
    
    
    projectile_infos=0;
    projectile_damage[i]=0;
    projectile_arp[i]=0;
    projectile_splash[i]=0;
    projectile_range[i]=0;
    
    */

    speed = 0;

    if ((firing == 1) && (ii <= 3)) {
        animation = "fire";
        ii += 1;
        image_speed = 0;
    }

    if ((firing == 1) && (ii > 3)) {
        firing = 0;
        ii = 0;
        image_speed = 0;
    }
}

/* */
/*  */
