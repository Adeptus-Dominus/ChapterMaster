var arm = other.armour_front;

if (obj_fleet.global_defense != 1) {
    var t1 = 1 - (obj_fleet.global_defense - 1);
    dam = dam * t1;
}

if (arm < dam) {
    dam -= arm;
    if (other.shields > 0) {
        other.shields -= dam;
    }
    if (other.shields <= 0) {
        other.hp -= dam;
    }
}

if ((arm > dam) && (other.shields > 0)) {
    other.shields -= 1;
}
if ((arm > dam) && (other.shields <= 0)) {
    other.hp -= 1;
}

if (sprite_index == spr_torpedo) {
    instance_create_depth(x, y, obj_explosion.depth, obj_explosion);
}

instance_destroy();
