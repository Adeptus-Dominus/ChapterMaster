image_xscale = 0.5;
image_yscale = 0.5;
speed = 4;
shields = 0;

target = 0;

if (instance_exists(obj_en_in)) {
    var n, ins;
    n = floor(random(instance_number(obj_en_in))); // get a random whole number based on obj amount
    ins = instance_find(obj_en_in, n); // find that n'th instance of that type
    target = ins;
}

if (!instance_exists(obj_en_in)) {
    var n, ins;
    n = floor(random(instance_number(obj_en_ship))); // get a random whole number based on obj amount
    ins = instance_find(obj_en_ship, n); // find that n'th instance of that type
    target = ins;
}

hp = 20;

cooldown1 = 0;
action = "close";
