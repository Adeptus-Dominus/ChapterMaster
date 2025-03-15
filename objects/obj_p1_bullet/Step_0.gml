
if (life >= 0.75 && life <= 1.25) && (projectile_infos == 0) { instance_destroy(); }

life += global.frame_timings.t1;

if (sprite_index=spr_flame2){
    if (instance_exists(owner)){
        if (owner.x>0) and (owner.x<room_width) and (owner.y>0) and (owner.y<room_height){
            x=owner.x+23;
            y=owner.y-24;
        }
    }
    if (life>8) then instance_destroy();
}

if (life >= 1.75 && life <= 2.25) && (sprite_index != spr_flame2) {
    var miss;miss=floor(random(100))+1;
    
    if (miss<=10){
        var rep;rep=instance_create(x,y,obj_p1_bullet_miss);
        rep.sprite_index=sprite_index;
        rep.image_index=image_index;
        rep.image_speed=image_speed;
        rep.direction=direction;
        rep.speed = speed;
        instance_destroy();
    }
}

image_angle=direction;
image_speed=0;


