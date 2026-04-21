image_xscale = 0.5;
image_yscale = 0.5;
speed = 6;

target = 0;
shields = 0;
owner = 0;
hostile = 0;

hp = 5000;

if (instance_exists(obj_p_small)) {
    var n, ins;
    n = floor(random(instance_number(obj_p_small))); // get a random whole number based on obj amount
    ins = instance_find(obj_p_small, n); // find that n'th instance of that type
    target = ins;
}

if (!instance_exists(obj_p_small)) {
    var n, ins;
    n = floor(random(instance_number(obj_p_ship))); // get a random whole number based on obj amount
    ins = instance_find(obj_p_ship, n); // find that n'th instance of that type
    target = ins;
}

hp = 15;

cooldown1 = 0;
action = "close";

alarm[0] = 1;
