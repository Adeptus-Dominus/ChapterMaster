current_battle += 1;
instance_activate_object(obj_star);
combating = 0;

var _battle_data;
while (current_battle < array_length(battles)) {
    _battle_data = battles[current_battle].prep_battle();
    if (!_battle_data.skip_battle) {
        break;
    }
    current_battle += 1;
}

if (current_battle < array_length(battles)) {
    show = current_battle;
} else {
    obj_controller.x = first_x;
    obj_controller.y = first_y;
    alarm[1] = 1;
}
