if ((other.class != "Daemon") || (other.image_alpha >= 1)) {
    var arm;
    arm = other.armour_front;

    dam = dam * obj_fleet.global_attack;

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
}

instance_destroy();
