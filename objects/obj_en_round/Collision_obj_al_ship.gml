


var arm;
arm=other.armour_front;

if (arm<dam){
    dam-=arm;
    if (other.shields>0) then other.shields-=dam/2;
    if (other.shields<=0) then other.hp-=dam/2;
}

if (arm>dam) and (other.shields>0) then other.shields-=0.5;
if (arm>dam) and (other.shields<=0) then other.hp-=0.5;

new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);

instance_destroy();

