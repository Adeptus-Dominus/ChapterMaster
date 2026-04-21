var arm;
arm = other.armour_front;

var t1;
t1 = 0;
if (obj_fleet.global_defense != 1) {
    t1 = 1 - (obj_fleet.global_defense - 1);
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
    instance_create(x, y, obj_explosion);
}

instance_destroy();
