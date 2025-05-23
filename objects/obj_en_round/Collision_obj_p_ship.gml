

var _rel_direction = point_direction(other.x, other.y, x, y);
var arm=other.armour_front;

var t1=0;
if (obj_fleet.global_defense!=1){
    t1=1-(obj_fleet.global_defense-1);
    dam=dam*t1;
}
if (other.shields.active){
    other.shields.shields-=dam;
} else {
    var _arm = 0;
    var _rel_direction = point_direction(other.x, other.y, x, y);
    if (_rel_direction <= 45 || _rel_direction >= 315){
        _arm = other.armour_front;
    } else if (_rel_direction <225 && _rel_direction > 135){
        _arm = other.rear_armour;
    } else {
        _arm = other.side_armour;
    }
    if (_arm<dam){
        other.hp -= (dam - arm);
    } else {
        other.hp -= 1;
    }
}

new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);

instance_destroy();

