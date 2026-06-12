// Handles damage allocation on space combat against ships based on shields and hp
var arm = other.armour_front;

if (arm < dam) {
    dam -= arm;
    if (other.shields > 0) {
        other.shields -= dam / 2;
    } else {
        other.hp -= dam / 2;
    }
}

if (arm > dam) {
    if (other.shields > 0) {
        other.shields -= 0.5;
    }
    if (other.shields <= 0) {
        other.hp -= 0.5;
    }
}

if (sprite_index == spr_torpedo) {
    instance_create_depth(x, y, obj_explosion.depth, obj_explosion);
}

instance_destroy();
