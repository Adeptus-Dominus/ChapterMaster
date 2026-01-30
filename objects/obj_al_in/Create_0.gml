image_xscale = 0.5;
image_yscale = 0.5;
speed = 6;

target = 0;
shields = 0;
owner = 0;
hostile = 0;

var object_number = instance_exists(obj_en_in) ? obj_en_in : obj_en_ship;
var n = floor(random(instance_number(object_number))); // get a random whole number based on obj amount
var ins = instance_find(object_number, n); // find that n'th instance of that type
target = ins;

hp = 15;

cooldown1 = 0;
action = "close";

alarm[0] = 1;
