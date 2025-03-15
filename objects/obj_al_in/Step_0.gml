// Sets up the sprites and beheavior for ship combat
if (owner == 6) then sprite_index = spr_darkstar;
if (owner == 7) then sprite_index = spr_fighta;
if (owner == 8) then sprite_index = spr_manta;
if (owner == 9) then sprite_index = spr_bio_fighter;
if (owner == eFACTION.Chaos) then sprite_index = spr_ship_dreadclaw;

image_angle = direction;
if (cooldown1 > 0) then cooldown1 -= 1;

var dist, range;
if (instance_exists(target)) {

    dist = point_distance(x, y, target.x, target.y);
    range = 100 + max(sprite_get_width(target.sprite_index), sprite_get_height(target.sprite_index));

    if (action == "close") {
        speed = 4;
        direction = turn_towards_point(direction, x, y, target.x, target.y, 6);
    }
    if (dist < range) and(dist > 100) and(action = "close") then action = "shoot";
    if (action == "shoot") and(dist > range) then action = "close";
    if (dist < 80) and(action = "shoot") then action = "bank";
    if (action == "bank") then direction = turn_towards_point(direction, x, y, room_width, room_height / 2, 3);
    if (action == "bank") and(dist > 300) then action = "close";

    if (action == "shoot") and(cooldown1 <= 0) {
        var bull;
        cooldown1 = 30;
        if (owner == 8) then cooldown1 = 20;
        bull = instance_create(x, y, obj_al_round);
        bull.direction = self.direction;
        if (owner == 8) or(owner == 6) then bull.sprite_index = spr_pulse;
        if (owner == 9) then bull.sprite_index = spr_glob;
        bull.speed = 20;
        bull.image_xscale = 0.5;
        bull.image_yscale = 0.5;
        bull.dam = 3;
        if (owner == 7) then bull.dam = 2;
    }
} else if (!instance_exists(target)) or (target.x <= -4000) {
    var object_number = instance_exists(obj_en_in) ? obj_en_in : obj_en_ship;
    var n = floor(random(instance_number(object_number))) // get a random whole number based on obj amount
    var ins = instance_find(object_number, n) // find that n'th instance of that type
    target = ins;
}

if (hp <= 0) {
    instance_create(x, y, obj_explosion);
    instance_destroy();
}