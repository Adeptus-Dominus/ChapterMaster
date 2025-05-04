image_angle=direction;

if (obj_fleet.start!=5) then exit;


var dist;

if (shields>0) and (shields<maxshields) then shields+=0.02;
if (board_cooldown>=0) then board_cooldown-=1;

// Need to every couple of seconds check this
// with obj_en_ship if not big then disable, check nearest, and activate once more
draw_targets = false;
if (instance_exists(target)){if ((target.x<3) and (target.y<3)) or (target.hp<0) then target=-50;}
if (!instance_exists(target)) or (target=-50){
    with(obj_en_ship){if ((x<3) and (y<3)) or (hp<=0) then instance_deactivate_object(id);}
    target=instance_nearest(x,y,obj_en_ship);
    instance_activate_object(obj_en_ship);
}
//if (!instance_exists(target)) then exit;

if (instance_exists(obj_en_ship)){
    if (!instance_exists(target) and (instance_nearest(x,y,obj_en_ship).x>500)) then target=instance_nearest(x,y,obj_en_ship);

    if (!instance_exists(target)) then target=instance_nearest(x,y,obj_en_ship);
}

if (hp<=0) and (x>-5000){

    if (class="Battle Barge") or (class="Gloriana"){
        obj_fleet.capital-=1;
        obj_fleet.capital_lost+=1;
    }
    if (class="Strike Cruiser"){
        obj_fleet.frigate-=1;
        obj_fleet.frigate_lost+=1;
    }
    if (class="Hunter"){
        obj_fleet.escort-=1;
        obj_fleet.escort_lost+=1;
    }
    if (class="Gladius"){
        obj_fleet.escort-=1;
        obj_fleet.escort_lost+=1;
    }

    
    obj_fleet.ship_lost[ship_id]=1;// show_message("obj_fleet.ship_lost["+string(ship_id)+"] = 1");
    
    image_alpha=0.5;
    if (obj_fleet.start!=0){
        destroy_ship_and_leave_husk();
    }
    x=-7000;y=room_height/2;
}
if (hp>0) and (instance_exists(target)){
    is_targeted();
    cooldown_ship_weapons();

    if (class="Apocalypse Class Battleship") or (class="Gloriana"){
        o_dist=500;
        action="attack";
    }
    else if (class="Nemesis Class Fleet Carrier"){
        o_dist=1000;
        action="attack";
    }
    else if (class="Avenger Class Grand Cruiser"){
        o_dist=64;
        action="broadside";
    }
   else  if (class="Battle Barge") or (class="Strike Cruiser"){
        o_dist=300;
        action="broadside";
    }
    else if (class="Hunter") or (class="Gladius"){
        o_dist=64;
        action="flank";
    }

    closing_distance = o_dist;

    // if (class!="big") then flank!!!!
    
    
    dist=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    target_distance = dist;
    
    // STC Bonuses
    turning_speed = 0.2;
    if (obj_controller.stc_bonus[5]=3){
        turning_speed+=0.1;
    }
    
    
    if (paction!="move") and (paction!="attack_move") and (paction!="turn") and (paction!="attack_turn"){
        if (target!=0) and (action="attack"){
            direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed/2);
        }
        broadside_movement();
        flank_movement();
    }

    if (draw_targets != false){
        dist=point_distance(x,y,draw_targets[0], draw_targets[1]);
    }
    
    // STC Bonuses
    var speed_up, speed_down;speed_up=0.005;speed_down=0.025;
    if (obj_controller.stc_bonus[6]=3){
        speed_up=0.008;
        speed_down=0.037;
    }
    
    if (paction="turn") or (paction="attack_turn"){
        direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed/2);
        dist=point_distance(x,y,target_x,target_y);
        if (y>target_y) then direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed);
        if (y<target_y) then direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed);
        if (speed>0) then speed-=speed_down;
        
        if (direction-point_direction(x,y,target_x,target_y)<=2) and (direction-point_direction(x,y,target_x,target_y)>=-2){
            if (paction="turn") then paction="move";
            if (paction="attack_turn") then paction="attack_move";
        }
    }
    
    if (paction!="move") and (paction!="turn") and (paction!="attack_move") and (paction!="attack_turn"){

        var _start_slowing = start_slowing_telemetry(dist, speed_down);
        if (_start_slowing){
            speed-=speed_down;
        } else {
            if (action="attack"){
                if (dist>o_dist) and (speed<(max_speed)) then speed+=speed_up;
            } else if (action="broadside"){
                if (dist>o_dist) and (speed<(max_speed)) then speed+=speed_up;
            } else if (action="flank"){// flank here
                if (dist>o_dist) and (speed<(max_speed)) then speed+=speed_up;
            }
        }
    }
    if (paction="move") or (paction="attack_move"){
        direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed/2);
        var dist;dist=point_distance(x,y,target_x,target_y);
        if (y>target_y) then direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed);
        if (y<target_y) then direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed);
        
        if (paction="attack_move") and (instance_exists(obj_en_ship)){
            if (!instance_exists(target)) then target=instance_nearest(x,y,obj_en_ship);
            dist=point_distance(x,y,target.x,target.y);
            if (dist<=o_dist){paction="";
            action="attack";
        }
        }
        
        if (dist>20) and (speed<(max_speed)) then speed+=speed_up;
        if (dist<=20) and (speed>0){
            paction="";
            action="attack";
        }
    }
    
    
    if (speed<0) then speed=speed*0.9;
    if (turret_cool>0) then turret_cool-=1;
    
    
    var bull, targe, rdir, dirr, dist, xx, yy, ok;
    targe=0;rdir=0;dirr="";dist=9999;xx=x;yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_en_in)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_en_in);
        if (instance_exists(targe)) then dist=point_distance(x,y,targe.x,targe.y);
        
        if (dist>64) and (dist<300){
            bull=instance_create(x,y,obj_p_round);
            bull.direction=point_direction(x,y,targe.x,targe.y);
            bull.speed=20;
            bull.dam=3;
            bull.image_xscale=0.5;
            bull.image_yscale=0.5;
            turret_cool=floor(60/turrets);
            bull.direction+=choose(random(3),1*-(random(3)));
        }
    }
    targe=0;rdir=0;dirr="";dist=9999;
    
    
    xx=lengthdir_x(64,direction+90);
    yy=lengthdir_y(64,direction+90);
    
    var front, right, left, rear;
    front=0;right=0;left=0;rear=0;
    
    targe=instance_nearest(xx,yy,obj_en_ship);
    if (instance_exists(targe)){
        rdir=point_direction(x,y,target.x,target.y);
        if (rdir>45) and (rdir<=135) and (targe!=target){
            target_r=targe;right=1;
        }
        if (rdir>225) and (rdir<=315) and (targe!=target) and (targe!=target_r){target_l=targe;left=1;}    
        if (collision_line(x,y,x+lengthdir_x(2000,direction),y+lengthdir_y(2000,direction),obj_en_ship,0,1)) then front=1;
        
        
        var f=0,facing="",ammo=0,range=0,wep="",dam=0;
        
        for (var gg=1;gg<array_length(weapon);gg++){
        
            // if (cooldown[gg]>0) then cooldown[gg]-=1;
        
            ok=0;f+=1;facing="";ammo=0;range=0;wep="";
        
            
            if (cooldown[gg]<=0) and (weapon[gg]!="") and (weapon_ammo[gg]>0) then ok=1;
            if (ok=1){
                facing=weapon_facing[gg];
                ammo=weapon_ammo[gg];
                range=weapon_range[gg];
            }
            
            targe=target;

            if (facing="right") then targe=target_r;
            if (facing="left") then targe=target_l;    
            if ((facing="front") or (facing="most")) and (front=1) then ok=2;
            if (facing="right") or (facing="most") and (right=1) then ok=2;
            if (facing="left") or (facing="most") and (left=1) then ok=2;
            if (facing="special") then ok=2;
            if (instance_exists(targe)){
            
                
                dist=point_distance(x,y,targe.x,targe.y);
                
                
                if (ok=2) and (dist<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
                    //if (ammo>0) and (ammo<500) then ammo-=1;
                    weapon_ammo[gg]=ammo;
                    cooldown[gg]=weapon_cooldown[gg];
                    wep=weapon[gg];
                    dam=weapon_dam[gg];
                    
                    // if (f=3) and (ship_id=2) then show_message("ammo: "+string(ammo)+" | range: "+string(range));
                    
                    if (ammo<0) then ok=0;
                    ok=3;
                    
                    if (string_count("orpedo",wep)=0) and (string_count("hawk",wep)=0) and (ok=3){
                        bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_p_round);
                        bull.speed=20;bull.dam=dam;
                        if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
                        if (facing!="front"){bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);}
                        if (string_count("ova",wep)=1){bull.image_xscale=2;bull.image_yscale=2;}
                        if (wep="Lance Battery"){
                            bull.sprite_index=spr_ground_las;
                            bull.image_xscale=2;
                            bull.image_yscale=2;
                        }
                    }
                    if (string_count("orpedo",wep)=1) and (ok=3){
                        
                        if (sprite_index=spr_ship_bb){
                            bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_p_round);
                            bull.speed=10;bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                        }
                        
                        bull=instance_create(x,y+lengthdir_y(-10,direction+90),obj_p_round);
                        bull.speed=10;
                        bull.direction=direction;bull.sprite_index=spr_torpedo;
                        bull.dam=dam;
                        bull=instance_create(x,y+lengthdir_y(10,direction+90),obj_p_round);
                        bull.speed=10;
                        bull.direction=direction;bull.sprite_index=spr_torpedo;
                        bull.dam=dam;
                        
                        if (sprite_index=spr_ship_bb){
                            bull=instance_create(x,y+lengthdir_y(30,direction+90),obj_p_round);
                            bull.speed=10;
                            bull.direction=direction;bull.sprite_index=spr_torpedo;bull.dam=dam;
                        }
                    }
                    if (string_count("hawk",wep)=1) and (ok=3){
                        bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_p_th);
                        bull.direction=self.direction;
                    }
                }
            }
        }
    }
    

    
}






/* */

//Deploy boarding craft logic
if (instance_exists(obj_en_ship)) and (boarders>0) and (board_cooldown<=0) and ((board_capital=true) or (board_frigate=true)){
    var eh=0,te=0;
    repeat(2){
        eh+=1;te=0;
        if (eh=1) and (board_capital=true){if (instance_exists(obj_en_capital)) then te=instance_nearest(x,y,obj_en_capital);}
        if (eh=2) and (board_frigate=true){if (instance_exists(obj_en_cruiser)) then te=instance_nearest(x,y,obj_en_cruiser);}
        if (te!=0) and (instance_exists(te)){
            if (point_distance(x,y,te.x,te.y)<=428){
                create_boarding_craft(te);
            }
        }
        
    }
    
}


/* */
/*  */
