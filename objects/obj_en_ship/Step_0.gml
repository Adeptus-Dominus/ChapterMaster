var __b__;
__b__ = action_if_variable(owner, 6, 0);
if !__b__
{
image_angle=direction;

if (obj_fleet.start!=5) then exit;

if (class="Daemon") and (image_alpha<1) then image_alpha+=0.006;

var o_dist, dist, ch_rang, ex, spid;spid=0;

if (shields>0) and (shields<maxshields) then shields+=0.02;


// Need to every couple of seconds check this
// with obj_en_ship if not big then disable, check nearest, and activate once more


if (instance_exists(obj_p_ship)) and (!instance_exists(obj_al_ship)) then target=instance_nearest(x,y,obj_p_ship);
if (!instance_exists(obj_p_ship)) and (instance_exists(obj_al_ship)) then target=instance_nearest(x,y,obj_al_ship);
if (instance_exists(obj_p_ship)) and (instance_exists(obj_al_ship)){
    var tp1,tp2;
    tp1=instance_nearest(x,y,obj_p_ship);tp2=instance_nearest(x,y,obj_al_ship);
    if (point_distance(x,y,tp1.x,tp1.y)<=point_distance(x,y,tp2.x,tp2.y)) then target=tp1;
    if (point_distance(x,y,tp1.x,tp1.y)>point_distance(x,y,tp2.x,tp2.y)) then target=tp2;
}
if (!instance_exists(target)) then exit;

if (hp<=0){
    var wh,gud;wh=0;gud=0;
    repeat(5){wh+=1;if (obj_fleet.enemy[wh]=owner) then gud=wh;}
    
    if (size=3) then obj_fleet.en_capital_lost[gud]+=1;
    if (size=2) then obj_fleet.en_frigate_lost[gud]+=1;
    if (size=1) then obj_fleet.en_escort_lost[gud]+=1;
    
    image_alpha=0.5;
    
    
    if (owner != eFACTION.Tyranids){
        // ex=instance_create(x,y,obj_explosion);
        // ex.image_xscale=2;ex.image_yscale=2;ex.image_speed=0.75;
        var husk;husk=instance_create(x,y,obj_en_husk);
        husk.sprite_index=sprite_index;husk.direction=direction;
        husk.image_angle=image_angle;husk.depth=depth;husk.image_speed=0;
        repeat(choose(4,5,6)){
            var explo;explo=instance_create(x,y,obj_explosion);
            explo.image_xscale=0.5;explo.image_yscale=0.5;
            explo.x+=random_range(sprite_width*0.25,sprite_width*-0.25);
            explo.y+=random_range(sprite_width*0.25,sprite_width*-0.25);
        }
    }
    if (owner = eFACTION.Tyranids) then effect_create_above(ef_firework,x,y,1,c_purple);
    instance_destroy();
}

if (hp>0) and (instance_exists(obj_p_ship)){

    if (class="Apocalypse Class Battleship"){o_dist=500;action="attack";spid=20;}
    if (class="Nemesis Class Fleet Carrier"){o_dist=1000;action="attack";spid=20;}
    if (class="Leviathan"){o_dist=160;action="attack";spid=20;}
    if (class="Battle Barge") or (class="Custodian"){o_dist=300;action="attack";spid=20;}
    if (class="Desecrator"){o_dist=300;action="attack";spid=20;}
    if (class="Razorfiend"){o_dist=100;action="attack";spid=25;}
    if (class="Cairn Class") or (class="Reaper Class"){o_dist=199;action="attack";spid=25;if (class="Reaper Class") then spid=30;}
    
    if (class="Dethdeala") or (class="Protector") or (class="Emissary"){o_dist=200;action="attack";spid=20;}
    if (class="Gorbag's Revenge"){o_dist=200;action="attack";spid=20;}
    if (class="Kroolboy") or (class="Slamblasta"){o_dist=200;action="attack";spid=25;}
    if (class="Battlekroozer"){o_dist=200;action="attack";spid=30;}
    if (class="Avenger") or (class="Carnage") or (class="Daemon"){o_dist=200;action="attack";spid=20;}
    
    if (class="Ravager") or (class="Iconoclast") or (class="Castellan") or (class="Warden"){o_dist=300;action="attack";spid=35;}
    if (class="Shroud Class"){o_dist=250;action="attack";spid=35;}
    
    if (class="Stalker") or (class="Sword Class Frigate"){o_dist=100;action="attack";spid=20;}
    if (class="Prowler"){o_dist=100;action="attack";spid=35;}
    if (class="Avenger Class Grand Cruiser"){o_dist=48;action="broadside";spid=20;}
    if (class="Jackal Class"){o_dist=200;action="attack";spid=40;}
    if (class="Dirge Class"){o_dist=200;action="attack";spid=45;}
    
    // if (class!="big") then flank!!!!
    
    
    spid=spid*speed_bonus;
    
    dist=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    
    
    if (target!=0) and (action="attack"){
        direction=turn_towards_point(direction,x,y,target.x,target.y,.1);
    }
    if (target!=0) and (action="broadside") and (dist>o_dist){
        if (y>=target.y) then dist=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y<target.y) then dist=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y>target.y) and (dist>o_dist) then direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2);
        if (y<target.y) and (dist>o_dist) then direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        if (turn_bonus>1){
            if (y<target.y) and (dist>o_dist) then direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        }
    }
    
    
    /*if (target!=0) and (action="broadside") and (o_dist>=dist){
        direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
    }*/
    
    /*if (target!=0) and (action="broadside") and (o_dist>=dist){
        var re_deh;re_deh=relative_direction(direction,target.direction);
        
        // if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        
        var wok;
        wok=0;
        
        if (!instance_exists(target_l)) then wok=2;
        if (!instance_exists(target_r)) then wok=1;
        
        if (instance_exists(target_l)) and (instance_exists(target_r)){
            if (point_distance(x,y,target_l.x,target_l.y))<(point_distance(x,y,target_r.x,target_r.y)) then wok=1;
            else{wok=2;}
            
        }
        
        
        if (wok=1){
            direction=turn_towards_point(direction,x,y,x+lengthdir_x(256,90),y+lengthdir_y(256,90),.2)
        }
        
        if (wok=2){
            direction=turn_towards_point(direction,x,y,x+lengthdir_x(256,270),y+lengthdir_y(256,270),.2)
        }
        
        // direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        
        
        
    }*/
    
    
    if (action="attack"){
        if (dist>o_dist) and (speed<((spid)/10)) then speed+=0.005;
        if (dist<o_dist) and (speed>0) then speed-=0.025;
    }
    if (action="broadside"){
        if (dist>o_dist) and (speed<((spid)/10)) then speed+=0.005;
        if (dist<o_dist) and (speed>0) then speed-=0.025;
    }
    

    if (speed<0) then speed=speed*0.9;

    if (cooldown[1]>0) then cooldown[1]-=1;
    if (cooldown[2]>0) then cooldown[2]-=1;
    if (cooldown[3]>0) then cooldown[3]-=1;
    if (cooldown[4]>0) then cooldown[4]-=1;
    if (cooldown[5]>0) then cooldown[5]-=1;
    if (turret_cool>0) then turret_cool-=1;

    
    
    
    var bull, targe, rdir, dirr, dist, xx, yy, ok;
    targe=0;rdir=0;dirr="";dist=9999;xx=x;yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_p_small)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_p_small);
        if (instance_exists(targe)) then dist=point_distance(x,y,targe.x,targe.y);
        
        if (dist>64) and (dist<300){
            bull=instance_create(x,y,obj_en_round);bull.direction=point_direction(x,y,targe.x,targe.y);
            if (owner = eFACTION.Tyranids) then bull.sprite_index=spr_glob;
            bull.speed=20;bull.dam=3;bull.image_xscale=0.5;bull.image_yscale=0.5;turret_cool=floor(60/turrets);
            if (owner = eFACTION.Necrons){bull.sprite_index=spr_green_las;bull.image_yscale=1;}
            bull.direction+=choose(random(10),1*-(random(10)));
        }
    }
    targe=0;rdir=0;dirr="";dist=9999;
    
    
    xx=lengthdir_x(64,direction+90);
    yy=lengthdir_y(64,direction+90);
    
    var front, right, left, rear;
    front=0;right=0;left=0;rear=0;
    
    targe=instance_nearest(xx,yy,obj_p_ship);
    rdir=point_direction(x,y,target.x,target.y);
    // if (rdir>45) and (rdir<=135) and (targe!=target){target_r=targe;right=1;}
    // if (rdir>225) and (rdir<=315) and (targe!=target) and (targe!=target_r){target_l=targe;left=1;}   
    target_l=instance_nearest(x+lengthdir_x(64,direction+90),y+lengthdir_y(64,direction+90),obj_p_ship);
    target_r=instance_nearest(x+lengthdir_x(64,direction+270),y+lengthdir_y(64,direction+270),obj_p_ship);
     
    if (collision_line(x,y,x+lengthdir_x(2000,direction),y+lengthdir_y(2000,direction),obj_p_ship,0,1)) then front=1;
    
    
    var f, facing, ammo, range, wep, dam, gg;f=0;facing="";ammo=0;range=0;wep="";dam=0;gg=0;
    
    lightning=0;
    
    repeat(weapons){
        gg+=1;
    
        ok=0;f+=1;facing="";ammo=0;range=0;wep="";
    
        //weapon[gg]=0;weapon_ammo[gg]=0;weapon_range[gg]=0;
        
        
        if (cooldown[gg]<=0) and (weapon[gg]!="") and (weapon_ammo[gg]>0) then ok=1;
        if (ok=1){
            facing=weapon_facing[gg];ammo=weapon_ammo[gg];range=weapon_range[gg];}
    
        targe=target;
        if (facing="front") and (front=1) then ok=2;
        if (facing="most") then ok=2;
        
        
        /*
        if (facing="right") then targe=target_r;
        if (facing="left") then targe=target_l;    
        if ((facing="front") or (facing="most")) and (front=1) then ok=2;
        if (facing="right") or (facing="most") and (right=1) then ok=2;
        if (facing="left") or (facing="most") and (left=1) then ok=2;
        */
        if (facing="special") then ok=2;
        if (!instance_exists(targe)) then exit;
        dist=point_distance(x,y,targe.x,targe.y);
    
        if (facing="right") and (point_direction(x,y,target_r.x,target_r.y)<337) and (point_direction(x,y,target_r.x,target_r.y)>203) then ok=2;
        if (facing="left") and (point_direction(x,y,target_r.x,target_r.y)>22) and (point_direction(x,y,target_r.x,target_r.y)<157) then ok=2;
        
        /*var re_deh;re_deh=relative_direction(direction,target.direction);
        if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        */
            
        
        
        if (ok=2) and (dist<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
            if (ammo>0) and (ammo<900) then ammo-=1;
            weapon_ammo[gg]=ammo;cooldown[gg]=weapon_cooldown[gg];wep=weapon[gg];dam=weapon_dam[gg];
            
            // if (f=3) and (ship_id=2) then show_message("ammo: "+string(ammo)+" | range: "+string(range));
            
            if (ammo<0) then ok=0;
            ok=3;
            
            if (string_count("orpedo",wep)=0) and (string_count("Interceptor",wep)=0) and (string_count("ommerz",wep)=0) and (string_count("Claws",wep)=0) and (string_count("endrils",wep)=0) and (ok=3) and (owner != eFACTION.Necrons){
                bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_round);
                bull.speed=20;bull.dam=dam;
                if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
                if (facing!="front"){bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);}
                if (string_count("ova",wep)=1){bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("eavy Gunz",wep)=1){bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Lance",wep)=1){bull.sprite_index=spr_ground_las;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Ion",wep)=1){bull.sprite_index=spr_pulse;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Rail",wep)=1){bull.sprite_index=spr_railgun;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Gravitic",wep)=1){bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("Plasma",wep)=1){bull.sprite_index=spr_ground_plasma;bull.image_xscale=2;bullimage_yscale=2;bull.speed=15;}
                if (string_count("Pyro-Acid",wep)=1){bull.sprite_index=spr_glob;bull.image_xscale=2;bullimage_yscale=2;}
                
                if (string_count("Weapons",wep)=1) and (owner = eFACTION.Eldar){bull.sprite_index=spr_ground_las;bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("Pulse",wep)=1) and (owner = eFACTION.Eldar){bull.sprite_index=spr_pulse;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                
            }
            if (string_count("orpedo",wep)=1) and (ok=3) and (owner != eFACTION.Necrons){
                if (class!="Ravager"){
                    bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_round);
                    bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                }
                bull=instance_create(x,y+lengthdir_y(-10,direction+90),obj_en_round);
                bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                bull=instance_create(x,y+lengthdir_y(10,direction+90),obj_en_round);
                bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                
                if (class!="Ravager"){
                    bull=instance_create(x,y+lengthdir_y(30,direction+90),obj_en_round);
                    bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                }
                
            }
            
            if (wep="Lightning Arc"){lightning=10;
                if (target.shields>0){
                    if (class="Cairn Class") or (class="Reaper Class") then target.shields-=20;
                    else{target.shields-=20;}
                }
                if (target.shields<=0){
                    if (class="Cairn Class") or (class="Reaper Class") then target.hp-=10;
                    else{target.hp-=10;}
                }
            }
            if (wep="Gauss Particle Whip"){whip=15;
                if (target.shields>0) then target.shields-=dam;
                if (target.shields<=0) then target.hp-=dam;
            }
            if (wep="Star Pulse Generator") and (ok=3) and (instance_exists(target)){
                bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_pulse);
                bull.speed=20;
                if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
                if (facing!="front"){bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);}
                bull.target_x=target.x;bull.target_y=target.y;
            }
            
            
            
            if ((string_count("Claws",wep)=1) or (string_count("endrils",wep)=1)) and (ok=3){
                if (target.shields<=0) then target.hp-=weapon_dam[wep];
                if (target.shields>0) then target.shields-=weapon_dam[wep];
            }
            if ((string_count("Interceptor",wep)=1) or (string_count("ommerz",wep)=1) or (string_count("Manta",wep)=1) or (string_count("Glands",wep)=1) or (string_count("Eldar Launch",wep)=1)) and (ok=3){
                bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_in);bull.direction=self.direction;bull.owner=self.owner;
            }
        }
    }
    
    
}


/* */
}
__b__ = action_if_variable(owner, 6, 0);
if __b__
{
image_angle=direction;

if (obj_fleet.start!=5) then exit;

var o_dist, dist, ch_rang, ex, spid;spid=0;

if (shields>0) and (shields<maxshields) then shields+=0.03;


// Need to every couple of seconds check this
// with obj_en_ship if not big then disable, check nearest, and activate once more
if (instance_exists(obj_p_ship)) then target=instance_nearest(x,y,obj_p_ship);

if (hp<=0){
    var wh,gud;wh=0;gud=0;
    repeat(5){wh+=1;if (obj_fleet.enemy[wh]=owner) then gud=wh;}

    if (size=3) then obj_fleet.en_capital_lost[gud]+=1;
    if (size=2) then obj_fleet.en_frigate_lost[gud]+=1;
    if (size=1) then obj_fleet.en_escort_lost[gud]+=1;
    
    image_alpha=0.5;
    
    // ex=instance_create(x,y,obj_explosion);
    // ex.image_xscale=2;ex.image_yscale=2;ex.image_speed=0.75;
    var husk;husk=instance_create(x,y,obj_en_husk);
    husk.sprite_index=sprite_index;husk.direction=direction;
    husk.image_angle=image_angle;husk.depth=depth;husk.image_speed=0;
    repeat(choose(4,5,6)){
        var explo;explo=instance_create(x,y,obj_explosion);
        explo.image_xscale=0.5;explo.image_yscale=0.5;
        explo.x+=random_range(sprite_width*0.25,sprite_width*-0.25);
        explo.y+=random_range(sprite_width*0.25,sprite_width*-0.25);
    }
    
    instance_destroy();
}

if (hp>0) and (instance_exists(obj_p_ship)){
    if (class="Void Stalker"){o_dist=300;action="swoop";spid=60;}
    if (class="Shadow Class"){o_dist=200;action="swoop";spid=80;}
    if (class="Hellebore") or (class="Aconite"){o_dist=200;action="swoop";spid=100;}
    
    dist=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(target.sprite_index),sprite_get_height(sprite_index)));
    
    
    
    
    
    
    
    if (target!=0){
        if (speed<((spid)/10)) then speed+=0.02;
        
        var dist, range;
        if (instance_exists(target)){
            dist=point_distance(x,y,target.x,target.y);
            
            if (action="swoop"){direction=turn_towards_point(direction,x,y,target.x,target.y,5-ship_size);}
            if (dist<=o_dist) and (collision_line(x,y,x+lengthdir_x(o_dist,direction),y+lengthdir_y(o_dist,direction),obj_p_ship,0,1)) then action="attack";
            if (dist<300) and (action="attack") then action="bank";
            if (action="bank") then direction=turn_towards_point(direction,x,y,room_width,room_height/2,5-ship_size);
            if (action="bank") and (dist>700) then action="attack";
        }
    }
    
    
    if (y<-2000) or (y>room_height+2000) or (x<-2000) or (x>room_width+2000) then hp=-50;
    
    
    if (cooldown[1]>0) then cooldown[1]-=1;
    if (cooldown[2]>0) then cooldown[2]-=1;
    if (cooldown[3]>0) then cooldown[3]-=1;
    if (cooldown[4]>0) then cooldown[4]-=1;
    if (cooldown[5]>0) then cooldown[5]-=1;
    if (turret_cool>0) then turret_cool-=1;

    
    var bull, targe, rdir, dirr, dist, xx, yy, ok;
    targe=0;rdir=0;dirr="";dist=9999;xx=x;yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_p_small)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_p_small);
        if (instance_exists(targe)) then dist=point_distance(x,y,targe.x,targe.y);
        
        if (dist>64) and (dist<300){
            bull=instance_create(x,y,obj_en_round);bull.direction=point_direction(x,y,targe.x,targe.y);
            if (owner = eFACTION.Tyranids) then bull.sprite_index=spr_glob;
            if (owner = eFACTION.Tau) or (owner = eFACTION.Eldar) then bull.sprite_index=spr_pulse;
            bull.speed=20;bull.dam=3;bull.image_xscale=0.5;bull.image_yscale=0.5;turret_cool=floor(60/turrets);
            bull.direction+=choose(random(10),1*-(random(10)));
        }
    }
    targe=0;rdir=0;dirr="";dist=9999;
    
    
    xx=lengthdir_x(64,direction+90);
    yy=lengthdir_y(64,direction+90);
    
    var front, right, left, rear;
    front=0;right=0;left=0;rear=0;
    
    targe=instance_nearest(xx,yy,obj_p_ship);
    rdir=point_direction(x,y,target.x,target.y);
    // if (rdir>45) and (rdir<=135) and (targe!=target){target_r=targe;right=1;}
    // if (rdir>225) and (rdir<=315) and (targe!=target) and (targe!=target_r){target_l=targe;left=1;}   
    target_l=instance_nearest(x+lengthdir_x(64,direction+90),y+lengthdir_y(64,direction+90),obj_p_ship);
    target_r=instance_nearest(x+lengthdir_x(64,direction+270),y+lengthdir_y(64,direction+270),obj_p_ship);
     
    if (collision_line(x,y,x+lengthdir_x(2000,direction),y+lengthdir_y(2000,direction),obj_p_ship,0,1)) then front=1;
    
    
    var f, facing, ammo, range, wep, dam, gg;f=0;facing="";ammo=0;range=0;wep="";dam=0;gg=0;
    
    
    repeat(weapons){
        gg+=1;
    
        ok=0;f+=1;facing="";ammo=0;range=0;wep="";
    
        //weapon[gg]=0;weapon_ammo[gg]=0;weapon_range[gg]=0;
        
        
        if (cooldown[gg]<=0) and (weapon[gg]!="") and (weapon_ammo[gg]>0) then ok=1;
        if (ok=1){
            facing=weapon_facing[gg];ammo=weapon_ammo[gg];range=weapon_range[gg];}
    
        targe=target;
        if (facing="front") and (front=1) then ok=2;
        if (facing="most") then ok=2;
        
        
        /*
        if (facing="right") then targe=target_r;
        if (facing="left") then targe=target_l;    
        if ((facing="front") or (facing="most")) and (front=1) then ok=2;
        if (facing="right") or (facing="most") and (right=1) then ok=2;
        if (facing="left") or (facing="most") and (left=1) then ok=2;
        */
        if (facing="special") then ok=2;
        if (!instance_exists(targe)) then exit;
        dist=point_distance(x,y,targe.x,targe.y);
    
        if (facing="right") and (point_direction(x,y,target_r.x,target_r.y)<337) and (point_direction(x,y,target_r.x,target_r.y)>203) then ok=2;
        if (facing="left") and (point_direction(x,y,target_r.x,target_r.y)>22) and (point_direction(x,y,target_r.x,target_r.y)<157) then ok=2;
        
        /*var re_deh;re_deh=relative_direction(direction,target.direction);
        if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        */
            
        
        
        if (ok=2) and (dist<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
            if (ammo>0) and (ammo<900) then ammo-=1;
            weapon_ammo[gg]=ammo;cooldown[gg]=weapon_cooldown[gg];wep=weapon[gg];dam=weapon_dam[gg];
            
            // if (f=3) and (ship_id=2) then show_message("ammo: "+string(ammo)+" | range: "+string(range));
            
            if (ammo<0) then ok=0;
            ok=3;
            
            if (string_count("orpedo",wep)=0) and (string_count("Interceptor",wep)=0) and (string_count("ommerz",wep)=0) and (string_count("Claws",wep)=0) and (string_count("endrils",wep)=0) and (ok=3){
                bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_round);
                bull.speed=20;bull.dam=dam;
                if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
                if (facing!="front"){bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);}
                if (string_count("ova",wep)=1){bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("eavy Gunz",wep)=1){bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Lance",wep)=1){bull.sprite_index=spr_ground_las;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Ion",wep)=1){bull.sprite_index=spr_pulse;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Rail",wep)=1){bull.sprite_index=spr_railgun;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                if (string_count("Gravitic",wep)=1){bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("Plasma",wep)=1){bull.sprite_index=spr_ground_plasma;bull.image_xscale=2;bullimage_yscale=2;bull.speed=15;}
                if (string_count("Pyro-Acid",wep)=1){bull.sprite_index=spr_glob;bull.image_xscale=2;bullimage_yscale=2;}
                
                if (string_count("Weapons",wep)=1) and (owner = eFACTION.Eldar){bull.sprite_index=spr_ground_las;bull.image_xscale=2;bull.image_yscale=2;}
                if (string_count("Pulse",wep)=1) and (owner = eFACTION.Eldar){bull.sprite_index=spr_pulse;bull.image_xscale=1.5;bull.image_yscale=1.5;}
                
            }
            if (string_count("orpedo",wep)=1) and (ok=3){
                if (class!="Ravager"){
                    bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_round);
                    bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                }
                bull=instance_create(x,y+lengthdir_y(-10,direction+90),obj_en_round);
                bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                bull=instance_create(x,y+lengthdir_y(10,direction+90),obj_en_round);
                bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                
                if (class!="Ravager"){
                    bull=instance_create(x,y+lengthdir_y(30,direction+90),obj_en_round);
                    bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                }
                
            }
            if ((string_count("Claws",wep)=1) or (string_count("endrils",wep)=1)) and (ok=3){
                if (target.shields<=0) then target.hp-=weapon_dam[wep];
                if (target.shields>0) then target.shields-=weapon_dam[wep];
            }
            if ((string_count("Interceptor",wep)=1) or (string_count("ommerz",wep)=1) or (string_count("Manta",wep)=1) or (string_count("Glands",wep)=1) or (string_count("Eldar Launch",wep)=1)) and (ok=3){
                bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_in);bull.direction=self.direction;bull.owner=self.owner;
            }
        }
    }
    
    
}


/* */
}
/*  */
