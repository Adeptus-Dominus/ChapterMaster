


var arm;
arm=other.armour_front;

var t1;t1=0;
if (obj_fleet.global_defense!=1){
    t1=1-(obj_fleet.global_defense-1);
    dam=dam*t1;
}

if (arm<dam){
    dam-=arm;
    if (other.shields>0) then other.shields-=dam;
    if (other.shields<=0) then other.hp-=dam;
}

if (arm>dam) and (other.shields>0) then other.shields-=1;
if (arm>dam) and (other.shields<=0) then other.hp-=1;

new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);

instance_destroy();

