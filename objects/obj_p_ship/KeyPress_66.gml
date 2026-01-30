// if (obj_fleet.start!=5) then exit;

if ((selected == 1) && (boarders > 0) && (board_cooldown <= 0) && (point_distance(x, y, mouse_x, mouse_y) <= 428)) {
    var tar_final;
    var tar1 = instance_nearest(mouse_x, mouse_y, obj_en_ship);
    var tar2 = instance_nearest(mouse_x, mouse_y, obj_en_capital);

    if ((!instance_exists(obj_en_capital)) && instance_exists(obj_en_ship)) {
        tar_final = instance_nearest(mouse_x, mouse_y, obj_en_ship);
    }
    if (instance_exists(obj_en_capital)) {
        var target_one_distance = point_distance(tar2.x, tar2.y, mouse_x, mouse_y) - 32;
        var target_two_distance = point_distance(tar1.x, tar1.y, mouse_x, mouse_y);

        if (target_one_distance < target_two_distance) {
            tar_final = instance_nearest(mouse_x, mouse_y, obj_en_capital);
        }
        if (target_one_distance >= target_two_distance) {
            tar_final = instance_nearest(mouse_x, mouse_y, obj_en_ship);
        }
    }
    create_boarding_craft(tar_final);
}

// board_co[i]=0;board_id[i]=0;board_location[i]=0; 
