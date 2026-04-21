if (obj_controller.zoomed == 1) {
    obj_controller.x = self.x;
    obj_controller.y = self.y;
}
obj_controller.popup = 1; // 1: fleet, 2: other fleet, 3: other
selected = 1;
obj_controller.fleet_minimized = 0;

var xx = x, yy = y;

obj_controller.selected = id;
if (instance_exists(obj_fleet_select)) {
    if (obj_controller.selected == obj_fleet_select.id) {
        exit;
    }
}
// obj_controller.selected=self;
obj_controller.sel_owner = self.owner;
// show_message(obj_controller.selected);
obj_controller.cooldown = 8;

if (obj_controller.zoomed) {
    scr_zoom();
}

// Pass variables to obj_controller.temp[t]=""; here
with (obj_fleet_select) {
    instance_destroy();
}
instance_create(x, y, obj_fleet_select);
obj_fleet_select.owner = self.owner;
obj_fleet_select.target = self.id;
obj_fleet_select.escort = escort_number;
obj_fleet_select.frigate = frigate_number;
obj_fleet_select.capital = capital_number;

var i = -1;
repeat (91) {
    i += 1;
    if (i <= 20) {
        capital_sel[i] = 1;
    }
    frigate_sel[i] = 1;
    escort_sel[i] = 1;

    if ((obj_controller.fest_scheduled > 0) && (obj_controller.fest_sid > 0)) {
        if (i <= 20) {
            if ((capital_num[i] == obj_controller.fest_sid) && (capital_sel[w] == 1)) {
                capital_sel[w] = 0;
            }
        }
        if ((frigate_num[i] == obj_controller.fest_sid) && (frigate_sel[i] == 1)) {
            frigate_sel[i] = 0;
        }
        if ((escort_num[i] == obj_controller.fest_sid) && (escort_sel[i] == 1)) {
            escort_sel[i] = 0;
        }
    }
}

/*var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
if (ii<=1) then ii=1;image_index=ii;*/

/* */
/*  */
