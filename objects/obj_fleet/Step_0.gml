// if (woohoo<60) then woohoo+=1;

if (beg != 0) /* and (instance_exists(obj_fleet_controller))*/ {
    if ((combat_end > -1) && (instance_number(obj_en_ship) == 0)) {
        combat_end -= 1;
        victory = true;
    }
    if ((combat_end > -1) && ((capital + frigate + escort) <= 0)) {
        combat_end -= 1;
    }
    if (combat_end > -1) {
        if (instance_exists(obj_p_ship)) {
            var wooo = instance_nearest(room_width / 2, room_height / 2, obj_p_ship);
            if (point_distance(wooo.x, wooo.y, room_width / 2, room_height / 2) > 4000) {
                //^have this be the same as roomSettings Height and Width or fleets will auto end!

                combat_end -= 1;
                global.logger.info("Fleet Combat Ended- Loss - Enemy:" + string(enemy[1]));
            }
        }
    }

    if ((combat_end <= -1) && (start == 5) && instance_exists(obj_p_ship)) {
        start = 6;
        obj_p_ship.alarm[3] = 1;
        alarm[0] = 10;
        global.logger.info("Fleet Combat Ended- Victory - Enemy:" + string(enemy[1]));
    }

    if ((combat_end > -1) && (instance_number(obj_en_ship) == 0)) {
        combat_end -= 1;
    }
    if ((combat_end > -1) && (instance_number(obj_p_ship) == 0)) {
        combat_end -= 1;
    }
}

if (start == 5) {
    if ((player_lasers > 0) && instance_exists(obj_en_ship)) {
        if ((player_lasers_target == 0) || (!instance_exists(player_lasers_target))) {
            player_lasers_target = instance_nearest(-50, room_height / 2, obj_en_ship);
        }

        player_lasers_cd = max(player_lasers_cd - 1, 0);
        if (player_lasers_cd <= 0) {
            player_lasers_cd = round(360 / player_lasers);
            repeat (min(2, player_lasers)) {
                var las;
                las = instance_create(x - 150, random(room_height / 2) + (room_height / 4), obj_p_round);
                las.direction = point_direction(las.x, las.y, player_lasers_target.x, player_lasers_target.y) + round(random_range(-4, 4));
                las.image_xscale = 1.5;
                las.image_yscale = 1.5;
                las.speed = 30;
                las.dam = 30;
                las.sprite_index = spr_ground_las;
                las.image_index = 0;
                las.image_speed = 0;
            }
        }
    }
}

/* */
/*  */
