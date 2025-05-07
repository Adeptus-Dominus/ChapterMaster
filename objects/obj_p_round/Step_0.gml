image_angle=direction;

if (x<-1000) or (x>room_width+1000) or (y<-1000) or (y>room_height+1000) then instance_destroy();

var th, thd;
if (dam<=4){
    if (instance_exists(obj_en_in)){
        th=instance_nearest(x,y,obj_en_in);
        thd=point_distance(x,y,th.x,th.y);
        if (thd<6){
            th.hp-=(self.dam-1);
            new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);
            instance_destroy()
        ;}
    }
}

