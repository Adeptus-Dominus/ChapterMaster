// Assigns the income to the player system based on its neighbours
if (instance_exists(obj_temp1)) {
    var tempy = instance_nearest(x, y, obj_temp1);
    var tempy_d = point_distance(x, y, tempy.x, tempy.y);

    // Nearby star system
    if ((tempy_d > 10) && (tempy_d <= 180)) {
        for (var i = 1; i <= planets; i++) {
            if ((p_type[i] == "Forge") && (p_owner[i] == 3)) {
                obj_controller.income_forge += 6;
            }
            if ((p_type[i] == "Agri") && (p_owner[i] == 2)) {
                obj_controller.income_agri += 3;
            }
        }
    }
    var biggy = instance_nearest(obj_temp1.x, obj_temp1.y, obj_star);
    var connected = determine_warp_join(biggy, id);
    if ((biggy.owner == eFACTION.PLAYER) && (tempy_d > 180) && connected) {
        for (var i = 1; i <= planets; i++) {
            if ((p_type[i] == "Forge") && (p_owner[i] == 3)) {
                obj_controller.income_forge += 6;
            }
            if ((p_type[i] == "Agri") && (p_owner[i] == 2)) {
                obj_controller.income_agri += 3;
            }
        }
    }
}
