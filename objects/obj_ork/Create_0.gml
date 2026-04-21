direction = 180;
speed = 2;

depth = (y * -1) / 2;

enemies_alive = 20;
enemies_max = 20;

var i;
i = -1;
repeat (51) {
    i += 1;
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

/*
while (place_meeting(x,y,other))
{
x += lengthdir_x(1, direction - 180);
y += lengthdir_y(1, direction - 180);
}
*/

/* */
/*  */
