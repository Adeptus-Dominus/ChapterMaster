current_battle += 1;
instance_activate_object(obj_star);
combating = 0;

// Probably want something right here to organize the battle just in case
// Space battles first
// Ground battles after

if (current_battle < array_length(battles)){
    var _battle_prep_variables = battles[i].prep_battle();
    next_battle_data = _battle_prep_variables;
} else {
    obj_controller.x = first_x;
    obj_controller.y = first_y;
    alarm[1] = 1;
}
