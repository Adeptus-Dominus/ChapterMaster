if (obj_controller.zoomed == 1) {
    obj_controller.x = self.x;
    obj_controller.y = self.y;
}
obj_controller.popup = 2; // 1: fleet, 2: other fleet, 3: other
selected = 1;
obj_controller.fleet_minimized = 0;

obj_controller.selected = instance_nearest(x, y, obj_en_fleet);

// obj_controller.selected=self;
obj_controller.sel_owner = self.owner;
// show_message(obj_controller.selected);
obj_controller.cooldown = 8;

if (obj_controller.zoomed == 1) {
    obj_controller.zoomed = 0;
    view_set_visible(0, true);
    view_set_visible(1, false);
    obj_cursor.image_xscale = 1;
    obj_cursor.image_yscale = 1;
}

// Pass variables to obj_controller.temp[t]=""; here
// Pass variables to obj_controller.temp[t]=""; here
with (obj_fleet_select) {
    instance_destroy();
}
instance_create_depth(x, y, obj_fleet_select.depth, obj_fleet_select);
obj_fleet_select.owner = self.owner;
