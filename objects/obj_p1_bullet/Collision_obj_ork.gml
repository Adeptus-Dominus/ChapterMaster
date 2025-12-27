if (sprite_index != spr_flame2) {
    var i, a, t, d;
    i = 0;
    a = 0;
    t = 0;
    d = 0;
    repeat (10) {
        i += 1;
        if (projectile_damage[i] > 0) {
            t = 0;
            a = 0;
            repeat (41) {
                a += 1;
                if ((other.enemy[a] == 1) && (t == 0)) {
                    t = a;
                }
            }

            if (t > 0) {
                if (projectile_arp[i] == -1) {
                    d = (projectile_damage[i] * other.enemy_dr[t]) - other.enemy_ac[t] * 6;
                }
                if (projectile_arp[i] == 0) {
                    d = (projectile_damage[i] * other.enemy_dr[t]) - other.enemy_ac[t];
                }
                if (projectile_arp[i] == 1) {
                    d = projectile_damage[i] * other.enemy_dr[t];
                }

                if (d < 0) {
                    d = 0;
                }
                if ((other.enemy_hp[t] > 0) && ((other.enemy_hp[t] - d) < 0)) {
                    other.enemy[t] = -1;
                    other.enemies_alive -= 1;
                }
                other.enemy_hp[t] -= d;

                if (other.enemies_alive == 0) {
                    effect_create_depth(-15000, ef_firework, other.x, other.y, 1, c_green);
                    with (other) {
                        instance_destroy();
                    }
                    instance_destroy();
                }
            }

            if (t == 0) {
                instance_destroy();
                exit;
            }
        }
    }

    instance_destroy();
}

if ((sprite_index == spr_flame2) && (life == 5)) {
    var i, a, t, d;
    i = 0;
    a = 0;
    t = 0;
    d = 0;
    repeat (10) {
        i += 1;
        if (projectile_damage[i] > 0) {
            t = 0;
            a = 0;
            repeat (41) {
                a += 1;
                if ((other.enemy[a] == 1) && (t == 0)) {
                    t = a;
                }
            }
            if (t > 0) {
                if (projectile_arp[i] == -1) {
                    d = (projectile_damage[i] * other.enemy_dr[t]) - other.enemy_ac[t] * 6;
                }
                if (projectile_arp[i] == 0) {
                    d = (projectile_damage[i] * other.enemy_dr[t]) - other.enemy_ac[t];
                }
                if (projectile_arp[i] == 1) {
                    d = projectile_damage[i] * other.enemy_dr[t];
                }

                if (d < 0) {
                    d = 0;
                }
                if ((other.enemy_hp[t] > 0) && ((other.enemy_hp[t] - d) < 0)) {
                    other.enemy[t] = -1;
                    other.enemies_alive -= 1;
                }
                other.enemy_hp[t] -= d;

                if (other.enemies_alive == 0) {
                    effect_create_depth(-15000, ef_firework, other.x, other.y, 1, c_green);
                    with (other) {
                        instance_destroy();
                    }
                }
            }

            if (t == 0) {
                exit;
            }
        }
    }
}
