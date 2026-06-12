direction = 180;
speed = 2;

depth = 0;

enemies_alive = 20;
enemies_max = 20;

for (var i = 0; i <= 50; i++) {
    enemy[i] = 1;
    if (i > 20) {
        enemy[i] = 0;
    }

    enemy_role[i] = "Slugga Boy";

    enemy_hp[i] = 35;
    enemy_maxhp[i] = 35;
    enemy_ac[i] = 10;
    enemy_dr[i] = 1;
}
