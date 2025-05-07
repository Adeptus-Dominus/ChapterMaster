
if (other.class!="Daemon") or (other.image_alpha>=1){

    var arm;
    arm=other.armour_front;
    
    dam=dam*obj_fleet.global_attack;
    
    if (arm<dam){
        dam-=arm;
        if (other.shields>0) then other.shields-=dam;
        if (other.shields<=0) then other.hp-=dam;
    }
    
    if (arm>dam) and (other.shields>0) then other.shields-=1;
    if (arm>dam) and (other.shields<=0) then other.hp-=1;
    
    new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);

}

instance_destroy();

