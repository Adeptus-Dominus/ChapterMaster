// Checks if player selects a system/star and then assigns the matching values to obj_controller
if (obj_controller.zoomed == 1) {
    obj_controller.x = x;
    obj_controller.y = y;
}
obj_controller.popup = 3; // 3: star system
obj_controller.sel_system_x = x;
obj_controller.sel_system_y = y;

obj_controller.selected = id;
obj_controller.sel_owner = owner;
obj_controller.cooldown = 8;
obj_controller.selecting_planet = 0;

if (obj_controller.zoomed == 1) {
    obj_controller.zoomed = 0;
    view_set_visible(0, true);
    view_set_visible(1, false);
    obj_cursor.image_xscale = 1;
    obj_cursor.image_yscale = 1;
}

// Pass variables to obj_controller.temp[t]=""; here
with (obj_star_select) {
    instance_destroy();
}
instance_create(x, y, obj_star_select);
obj_star_select.owner = owner;
obj_star_select.target = id;

try {
    if (obj_controller.selection_data != false) {
        var _data = obj_controller.selection_data;
        if (!struct_exists(_data, "system")) {
            _data.system = id;
        }
        if (_data.system != noone) {
            if (struct_exists(_data, "feature")) {
                if (_data.feature != "none") {
                    if (is_struct(_data.feature)) {
                        if (struct_exists(_data.feature, "f_type")) {
                            if (_data.feature.f_type != "none") {
                                obj_star_select.feature = new FeatureSelected(_data.feature, _data.system, _data.planet);
                            }
                        }
                    }
                }
            }
            if (struct_exists(_data, "planet")) {
                obj_controller.selecting_planet = _data.planet;
                if (obj_controller.selecting_planet > 0 && obj_controller.selecting_planet < 5) {
                    var _pdata = get_planet_data(obj_controller.selecting_planet);
                    _pdata.set_star_select_planet();
                }
            }
            obj_controller.selection_data = false;
        }
    }
    obj_controller.selection_data = false;
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    obj_controller.selection_data = false;
}
