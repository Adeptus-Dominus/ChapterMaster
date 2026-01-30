/// @description Insert description here
// You can write your code in this editor
if (instance_exists(obj_ncombat)) {
    exit;
}
if (instance_exists(obj_fleet)) {
    exit;
}
if (global.load >= 0) {
    exit;
}
if (obj_controller.invis == true) {
    exit;
}

if (obj_controller.menu == 0) {
    draw_warp_lanes();
}
