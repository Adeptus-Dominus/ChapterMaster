if (!instance_exists(obj_saveload) && !instance_exists(obj_drop_select)) {
    if (obj_controller.diplomacy == 0) {
        draw_set_font(fnt_fancy);
        draw_set_halign(fa_center);
        draw_set_color(0);

        if (obj_controller.menu == 60) {
            exit;
        }

        var xx = camera_get_view_x(view_camera[0]);
        var yy = camera_get_view_y(view_camera[0]);
        var dist = 999;
        var close = false;

        if (debug != 0) {
            exit;
        }

        //TODO centralise this logic
        if (instance_exists(obj_fleet_select)) {
            if (obj_fleet_select.currently_entered) {
                exit;
            }
        }

        // Exit button
        if ((mouse_x >= xx + 274) && (mouse_y >= yy + 426) && (mouse_x < xx + 337) && (mouse_y < yy + 451) && (obj_controller.cooldown <= 0)) {
            if (!loading) {
                obj_controller.sel_system_x = 0;
                obj_controller.sel_system_y = 0;
                obj_controller.popup = 0;
                obj_controller.cooldown = 8000;
                obj_controller.selecting_planet = 0;
                instance_destroy();
            } else {
                sel_plan = 0;
                obj_controller.cooldown = 8000;
                if (obj_controller.menu == 1 && obj_controller.view_squad) {
                    var _company_data = obj_controller.company_data;
                    var _current_squad = _company_data.grab_current_squad();
                    if (sel_plan > 0) {
                        var planet = sel_plan;
                        for (var i = 0; i < array_length(target.p_operatives[planet]); i++) {
                            operation = target.p_operatives[planet][i];
                            if (operation.type == "squad" && operation.reference == _current_squad.uid) {
                                target.remove_operative(planet, i);
                                break;
                            }
                        }
                    }
                    _current_squad.assignment = "none";
                }
                instance_destroy();
            }
        }

        if ((obj_controller.cooldown <= 0) && (loading == 1)) {}

        attack = 0;
        bombard = 0;
        raid = 0;
        purge = 0;
    }
}
