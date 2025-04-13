/// @description Insert description here
// You can write your code in this editor
if (instance_exists(obj_ncombat)) then exit;
if (instance_exists(obj_fleet)) then exit;
if (global.load>=0) then exit;
if (obj_controller.invis==true) then exit;

if (obj_controller.menu==0){
	draw_warp_lanes();
}







