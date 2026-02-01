if (owner == eFACTION.ELDAR) {
    sprite_index = spr_darkstar;
}
if (owner == eFACTION.ORK) {
    sprite_index = spr_fighta;
}
if (owner == eFACTION.TAU) {
    sprite_index = spr_manta;
}
if (owner == eFACTION.TYRANIDS) {
    sprite_index = spr_bio_fighter;
}
if (owner == eFACTION.CHAOS) {
    sprite_index = spr_ship_dreadclaw;
}

image_angle = direction;
if (cooldown1 > 0) {
    cooldown1 -= 1;
}

var dist, range;
if (instance_exists(target)) {
    dist = point_distance(x, y, target.x, target.y);
    range = 100 + max(sprite_get_width(target.sprite_index), sprite_get_height(target.sprite_index));

    if (action == "close") {
        speed = 4;
        direction = turn_towards_point(direction, x, y, target.x, target.y, 6);
    }
    if ((dist < range) && (dist > 100) && (action == "close")) {
        action = "shoot";
    }
    if ((action == "shoot") && (dist > range)) {
        action = "close";
    }
    if ((dist < 80) && (action == "shoot")) {
        action = "bank";
    }
    if (action == "bank") {
        direction = turn_towards_point(direction, x, y, room_width, room_height / 2, 3);
    }
    if ((action == "bank") && (dist > 300)) {
        action = "close";
    }

    if ((action == "shoot") && (cooldown1 <= 0)) {
        var bull;
        cooldown1 = 30;
        if (owner == eFACTION.TAU) {
            cooldown1 = 20;
        }
        bull = instance_create(x, y, obj_en_round);
        bull.direction = self.direction;
        if ((owner == eFACTION.TAU) || (owner == eFACTION.ELDAR)) {
            bull.sprite_index = spr_pulse;
        }
        if (owner == eFACTION.TYRANIDS) {
            bull.sprite_index = spr_glob;
        }
        bull.speed = 20;
        bull.image_xscale = 0.5;
        bull.image_yscale = 0.5;
        bull.dam = 3;
        if (owner == eFACTION.ORK) {
            bull.dam = 2;
        }
    }
}

if ((!instance_exists(target)) || (target.x <= -4000)) {
    if (instance_exists(obj_p_small) && (!instance_exists(obj_al_in))) {
        var n, ins;
        n = floor(random(instance_number(obj_p_small))); // get a random whole number based on obj amount
        ins = instance_find(obj_p_small, n); // find that n'th instance of that type
        target = ins;
    }
    if ((!instance_exists(obj_p_small)) && instance_exists(obj_al_in)) {
        var n, ins;
        n = floor(random(instance_number(obj_al_in))); // get a random whole number based on obj amount
        ins = instance_find(obj_al_in, n); // find that n'th instance of that type
        target = ins;
    }
    if (instance_exists(obj_p_small) && instance_exists(obj_al_in)) {
        var wh;
        wh = choose(1, 2);
        if (wh == 1) {
            var n, ins;
            n = floor(random(instance_number(obj_p_small))); // get a random whole number based on obj amount
            ins = instance_find(obj_p_small, n); // find that n'th instance of that type
            target = ins;
        }
        if (wh == 2) {
            var n, ins;
            n = floor(random(instance_number(obj_al_in))); // get a random whole number based on obj amount
            ins = instance_find(obj_al_in, n); // find that n'th instance of that type
            target = ins;
        }
    }
    if ((!instance_exists(obj_p_small)) && (!instance_exists(obj_al_in))) {
        if (instance_exists(obj_p_ship) && instance_exists(obj_al_ship)) {
            var tp1, tp2;
            tp1 = instance_nearest(x, y, obj_p_ship);
            tp2 = instance_nearest(x, y, obj_al_ship);
            if (point_distance(x, y, tp1.x, tp1.y) <= point_distance(x, y, tp2.x, tp2.y)) {
                target = tp1;
            }
            if (point_distance(x, y, tp1.x, tp1.y) > point_distance(x, y, tp2.x, tp2.y)) {
                target = tp2;
            }
        }
        if (instance_exists(obj_p_ship) && (!instance_exists(obj_al_ship))) {
            var n, ins;
            n = floor(random(instance_number(obj_p_ship))); // get a random whole number based on obj amount
            ins = instance_find(obj_p_ship, n); // find that n'th instance of that type
            target = ins;
        }
    }
}

if (hp <= 0) {
    instance_create(x, y, obj_explosion);
    instance_destroy();
}
