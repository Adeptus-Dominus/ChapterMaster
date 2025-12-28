// Sets the target based on the mouse click, sets the bombardment score for when the player bombards the target
var __b__;
__b__ = action_if_number(obj_saveload, 0, 0);
if (__b__) {
    var xx, yy;
    xx = camera_get_view_x(view_camera[0]);
    yy = camera_get_view_y(view_camera[0]);

    with (obj_star_select) {
        instance_deactivate_object(id);
    }

    var why = 0, onceh = 0, ship = 0;

    bomb_score = 0;
    for (var i = 0; i < array_length(ship_ide); i++) {
        if (ship_all[i] == 1) {
            if (obj_ini.ship_class[ship_ide[i]] == "Battle Barge") {
                bomb_score += 3;
            }
            if (obj_ini.ship_class[ship_ide[i]] == "Strike Cruiser") {
                bomb_score += 1;
            }
        }
    }

    // TODO Need to change max_ships to something more meaningful to make sure that SOMETHING is dropping
    instance_activate_object(obj_star_select);
}
