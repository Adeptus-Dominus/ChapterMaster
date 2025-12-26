image_angle=direction;

if (obj_fleet.start!=5) then exit;
if (board_cooldown>=0) then board_cooldown-=1;

// Need to every couple of seconds check this
// with obj_en_ship if not big then disable, check nearest, and activate once more
draw_targets = false;
if (instance_exists(target)){
    if ((target.x<3) and (target.y<3)) or (target.hp<0){
        target=-50;
    }
}
if (!instance_exists(target)) or (target=-50){
    with(obj_en_ship){
        if ((x<3) and (y<3)) or (hp<=0) then instance_deactivate_object(id);
    }
    target=instance_nearest(x,y,obj_en_ship);
    instance_activate_object(obj_en_ship);
}
//if (!instance_exists(target)) then exit;

if (instance_exists(obj_en_ship)){
    if (!instance_exists(target) and (instance_nearest(x,y,obj_en_ship).x>500)){
        target=instance_nearest(x,y,obj_en_ship);

    }

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
    x=-7000;
    y=room_height/2;
}
if (hp>0) and (instance_exists(target)){
    is_targeted();

    if (class="Apocalypse Class Battleship") or (class="Gloriana"){
        closing_distance=500;
        action="attack";
    }
    else if (class="Nemesis Class Fleet Carrier"){
        closing_distance=1000;
        action="attack";
    }
    else if (class="Avenger Class Grand Cruiser"){
        closing_distance=64;
        action="broadside";
    }
   else  if (class="Battle Barge"){
        closing_distance=300;
        action="broadside";
    } else if (class == "Strike Cruiser"){
        action="broadside";
        closing_distance=300;
    }
    else if (class="Hunter") or (class="Gladius"){
        closing_distance=64;
        action="flank";
    }

    if (action = "flank" && target.action == "flank"){
        action = "attack";
    }

    if (action == "broadside"){
        var _near_enemy = instance_nearest(x,y,obj_en_ship);
        if (_near_enemy.size >= size){
            target = _near_enemy;
        }
    }

    show_debug_message($"closing:{closing_distance}");

    // if (class!="big") then flank!!!!
    
    
    target_distance=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    target_distance = target_distance;
    
    // STC Bonuses

    turning_speed = ship_data.calc_turn_speed();
    speed_up = ship_data.final_acceleration();
    show_debug_message($"accel:{speed_up}");

    speed_down = ship_data.deceleration();

    var _player_action = (paction=="move" || paction=="attack_move" || paction=="turn" || paction=="attack_turn");
    
    if (!_player_action){
        if (target!=0) and (action=="attack"){
            ship_turn_towards_point(target.x,target.y);
        }
        ideal_broadside();
        //broadside_movement();
        flank_behaviour();
    }

    if (draw_targets != false){
        target_distance=point_distance(x,y,draw_targets[0], draw_targets[1]);
    }
    
    if (!_player_action){
        show_debug_message($"accelcalcs");
        combat_acceleration_control();
    }
    if (_player_action){
        if (paction="turn") or (paction="attack_turn"){
            direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed/2);
            target_distance=point_distance(x,y,target_x,target_y);
            if (y>target_y || y<target_y) {
                ship_turn_towards_point(target_x,target_y);
            }
            if (speed>0) then speed-=speed_down;
            
            if (direction-point_direction(x,y,target_x,target_y)<=2) and (direction-point_direction(x,y,target_x,target_y)>=-2){
                if (paction="turn") then paction="move";
                if (paction="attack_turn") then paction="attack_move";
            }
        }
        

        if (paction="move") or (paction="attack_move"){
            direction=turn_towards_point(direction,x,y,target_x,target_y,turning_speed/2);
            target_distance=point_distance(x,y,target_x,target_y);

            if(y>target_y || y<target_y) {
                ship_turn_towards_point(target_x,target_y);
            }
            
            if (paction="attack_move") and (instance_exists(obj_en_ship)){
                if (!instance_exists(target)){
                    target=instance_nearest(x,y,obj_en_ship);
                }
                target_distance=point_distance(x,y,target.x,target.y);
                if (target_distance<=closing_distance){
                    paction="";
                    action="attack";
                }
            }
            
            if (target_distance>20) and (speed<(max_speed)) then speed+=speed_up;
            if (target_distance<=20) and (speed>0){
                paction="";
                action="attack";
            }
        }
    }
    
    
    if (speed<0) then speed=speed*0.9;
    if (turret_cool>0){
        turret_cool-=1;
    }
    
    
    var bull, targe, rdir, dirr, target_distance, xx, yy, ok;
    targe=0;rdir=0;dirr="";target_distance=9999;xx=x;yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_en_in)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_en_in);
        if (instance_exists(targe)) then target_distance=point_distance(x,y,targe.x,targe.y);
        
        if (target_distance>64) and (target_distance<300){
            bull=instance_create(x,y,obj_p_round);
            bull.direction=point_direction(x,y,targe.x,targe.y);
            bull.speed=20;
            bull.dam=3;
            bull.image_xscale=0.25;
            bull.image_yscale=0.25;
            turret_cool=floor(60/turrets);
            bull.direction+=choose(random(3),1*-(random(3)));
            bull.explosion_sprite = spr_explosion;   
        }
    }
    ship_shoot_weapons();

        
}

shields.step();



/* */

//Deploy boarding craft logic
if (instance_exists(obj_en_ship)) and (boarders>0) and (board_cooldown<=0) and ((board_capital=true) or (board_frigate=true)){
    var eh=0,te=0;
    repeat(2){
        eh+=1;te=0;
        if (eh=1) and (board_capital=true){
            if (instance_exists(obj_en_capital)){
                te=instance_nearest(x,y,obj_en_capital);
            }
        }
        if (eh=2) and (board_frigate=true){
            if (instance_exists(obj_en_cruiser)) then te=instance_nearest(x,y,obj_en_cruiser);}
        if (te!=0) and (instance_exists(te)){
            if (point_distance(x,y,te.x,te.y)<=428){
                create_boarding_craft(te);
            }
        }
        
    }
    
}


/* */
/*  */
