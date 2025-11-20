function point_on_circle(start_x, start_y, radius, angle){
    var _angle_radians = degtorad(angle);
    var _final_x = start_x + lengthdir_x(radius, angle);
    var _final_y = start_y + lengthdir_y(radius, angle);
    return [_final_x, _final_y];
}


function find_ship_combat_target(primary_target_type = obj_en_ship, secondary_target_type = -1){
    if (instance_exists(primary_target_type) && !instance_exists(secondary_target_type)){
        target=instance_nearest(x,y,obj_p_ship);
    }
    if (!instance_exists(primary_target_type) && instance_exists(secondary_target_type)){
        target=instance_nearest(x,y,secondary_target_type);
    }
    if (instance_exists(primary_target_type)) and (instance_exists(secondary_target_type)){
        var _tp1=instance_nearest(x,y,primary_target_type);
        var _tp2=instance_nearest(x,y,secondary_target_type);
        if (point_distance(x,y,_tp1.x,_tp1.y)<=point_distance(x,y,_tp2.x,_tp2.y)){
            target=_tp1;
        }
        if (point_distance(x,y,_tp1.x,_tp1.y)>point_distance(x,y,_tp2.x,_tp2.y)){
            target=_tp2;
        }
    }
}

function combat_acceleration_control(){
    var travel_distance = draw_targets == false ? target_distance : point_distance(x, y, draw_targets[0], draw_targets[1]);
    var _start_slowing = start_slowing_telemetry(travel_distance, speed_down);
    if (_start_slowing){
       // if (object_index==obj_p_ship){
            //show_debug_message("start_Slow");
       // }
        speed-=speed_down;
    } else {
        //if (object_index==obj_p_ship){
            //show_debug_message($"start_speed{speed}");
        //} 
        speed+=speed_up;
        /*if (action=="attack"){
            if (target_distance>closing_distance) and (speed<(max_speed)) then speed+=speed_up;
        } else if (action=="broadside"){
            if (target_distance>closing_distance) and (speed<(max_speed)) then speed+=speed_up;
        } else if (action=="flank"){// flank here
            if (target_distance>closing_distance) and (speed<(max_speed)) then speed+=speed_up;
        }*/
         //if (object_index==obj_p_ship){
         //show_debug_message($"end_speed{speed}, {max_speed}");
        //}
    }   
}
/*function circle_mechanics(end_location){
    var _turn_require = point_direction(x,y,end_location[0],end_location[1]);
    if (_turn_require<180){
        time_to_face = 180/turning_speed;
    } else{
        time_to_face = (_turn_require-180)/turning_speed;
    }

    var x_travel = end_location[0] - x; 
    var y_travel = end_location[1] - y;

    for (var i=0; i<time_to_face();i++){

    }
    
    var _current_circumference = speed * 360/turning_speed;



    degtorad(); 
    time_to_face = turning_speed
    max_speed = 
}*/


function ideal_broadside(){
    if (action=="broadside" && target!=0){
        var _ship_direc = direction;
        var _enemy_points_left = 0;
        var _enemy_points_right = 0;
        var _ship_x = x;
        var _ship_y = y;
        with (obj_en_ship){
            var _rel_direct = point_direction(_ship_x, _ship_y, x, y);
            if (_rel_direct > 270){
                _enemy_points_right += size;
            } else if (_rel_direct < 90) {
                _enemy_points_left += size;
            }
        }
        var _break_direction = (_enemy_points_right > _enemy_points_left) ? 90 : 270;
    
    
        draw_targets = point_on_circle(target.x, target.y, 450 ,_break_direction);
        ship_turn_towards_point(draw_targets[0],draw_targets[1]);
    }

}


function broadside_movement(){
	var _target_direction = target.direction;
    if (target!=0) and (action="broadside") and (target_distance>closing_distance){
        if (y>=target.y){
        	target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        }
        if (y<target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y>target.y) and (target_distance>closing_distance){
        	direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2);
        }
        if (y<target.y) and (target_distance>closing_distance){
        	direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        }
        if (turn_bonus>1){
            if (y<target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        }
    }	
}

function return_longest_range_weapon(weapons, facing = "none"){
    var _weapon = false;
    for (var i=0;i<array_length(weapons);i++){
        if (facing != "none" && weapons[i].facing != facing){
            continue;
        }
        if (_weapon == false){
            _weapon = weapons[i];
        } else {
            if (weapons[i].range > _weapon.range){
                _weapon = weapons[i];
            }
        }
    }
    return _weapon;
}

function flank_direction_move(main_weapon = false){
    var _rel_direction = point_direction(target.x, target.y, x, y) - target.direction;
    if (abs(_rel_direction) < 105){
        if (main_weapon == false){           
            ship_rear_approach(_rel_direction);
        } else {
            if (point_distance(x, y, target.x, target.y) < (main_weapon.range*2) && abs(_rel_direction) <= main_weapon.firing_arc){
                avoid_ship_weapon(main_weapon, rel_direction);
            } else {
                ship_rear_approach(_rel_direction);
            }
        }

    } else {
        defualt_target_movement();
    }
}

function avoid_ship_weapon(weapon, rel_direction){
    if (rel_direction){
        var avoid_angle = target.direction + weapon.firing_arc;
    } else {
        var avoid_angle = target.direction - weapon.firing_arc;
    }
    var _sx = xm + lengthdir_x(weapon.range, avoid_angle);
    var _sy = ym + lengthdir_y(weapon.range, avoid_angle);
    draw_targets = [_sx, _sy];
    ship_turn_towards_point(_sx, _sy);
}

function ship_rear_approach(rel_direction){
    var _attack_angle = target.direction + ((rel_direction > 0) ? 105 : -105);
    if (_attack_angle > 360){
        _attack_angle -= 360;
    } else if (_attack_angle< 0){
        _attack_angle = 360 -_attack_angle;
    }
    var _flank_margin = closing_distance*2
    var _target_lock = [target.x + lengthdir_x(_flank_margin, _attack_angle), target.y + lengthdir_y(_flank_margin, _attack_angle)]
    draw_targets = _target_lock;
    ship_turn_towards_point(_target_lock[0],_target_lock[1]);
    closing_distance = 0;    
}

function get_out_of_weapon_firing_arc(weapon, weapon_owner){
    var _rel_direction = point_direction(weapon_owner.x, weapon_owner.y, x, y) - weapon_owner.direction;
    var _travel_direct = 0;
    if (_rel_direction>0){
        _travel_direct = weapon_owner.direction + weapon.firing_arc + 90;
    } else {
        _travel_direct = weapon_owner.direction - weapon.firing_arc  -  90;
    }
    var _target_lock = [x + lengthdir_x(1000, _travel_direct), y + lengthdir_y(1000, _travel_direct)]
    ship_turn_towards_point(_target_lock[0],_target_lock[1]);
    draw_targets = _target_lock;
}

function flank_behaviour(){
	var _normal_target = false;
    if (target!=0 && action=="flank"){
        var _target_main_weapon = return_longest_range_weapon(target.weapons, "front");
    	if (!under_fire){
            if (!_target_main_weapon){
                flank_direction_move();
            } else {
                var _rel_direction = point_direction(target.x, target.y, x, y) - target.direction;
                if (abs(_rel_direction) <= _target_main_weapon.firing_arc){
                    get_out_of_weapon_firing_arc(_target_main_weapon, target);
                } else {
                    flank_direction_move();
                }
            }
    	} else {

    		_normal_target = true;
	    }
    }
    if (_normal_target ){
        defualt_target_movement();
    }
}

function defualt_target_movement(){
     if (y>=target.y){
        target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    } else if (y<target.y){
        target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    }

    if ((y>target.y && target_distance>closing_distance) ){
        direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
    } else if (y<target.y && target_distance>closing_distance){
        direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
    }   
}

function start_slowing_telemetry(distance_to_target, deceleration){
	var _start_slowing = false;
    if (speed>0){
        var _time_to_stop = (speed/deceleration);
        var _distance_traveled_while_slowing = speed*_time_to_stop+ ((1/2) * deceleration * sqr(_time_to_stop));
        
        if (distance_to_target - _distance_traveled_while_slowing < closing_distance){
            _start_slowing = true;
        }
    }
    return 	_start_slowing;
}


function destroy_ship_and_leave_husk(){
    image_alpha=0.5;
    
    if (ai_type == "player" || owner != eFACTION.Tyranids){
        husk=instance_create(x,y,obj_en_husk);
        husk.sprite_index=sprite_index;
        husk.direction=direction;
        husk.image_angle=image_angle;
        husk.depth=depth;
        husk.image_speed=0;
        for(var i=0; i<choose(4,5,6); i++){
            explo=instance_create(x,y,obj_explosion);
            explo.image_xscale=0.5;
            explo.image_yscale=0.5;
            explo.x+=random_range(sprite_width*0.25,sprite_width*-0.25);
            explo.y+=random_range(sprite_width*0.25,sprite_width*-0.25);
        }
    } else {
        if (owner == eFACTION.Tyranids) then effect_create_above(ef_firework,x,y,1,c_purple);
    }
    instance_destroy(); 
}

/// draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision)
//
//  Draws an arc of an ellipse mimicking draw_arc() from GM5. It also mimics
//  draw_ellipse() from GM6 in that it uses a primitive drawn with limited
//  resolution. The arc is drawn following the perimeter of the ellipse, 
//  counterclockwise, from the starting point to the ending point.
//  The starting point is the intersection of the ellipse with the ray 
//  extending from the center point and passing through the point (x3,y3).
//  The ending point is the intersection of the ellipse with the ray
//  extending from the center through the point (x4,y4).
//
//      x1,y1       1st corner of bounding rectangle, real
//      x2,y2       2nd corner of bounding rectangle, real
//      x3,y3       determines starting point, real
//      x4,y4       determines ending point, real
//      precision   number of segments a full ellipse would be drawn with,
//                  [4..64] divisible by 4, default 24, real (optional)
//
/// GMLscripts.com/license
function draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision=24){
    if (precision == 0) precision = 24;
    var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
    res = 360 / min(max(4,4*(precision div 4)),64);
    xm = (x1+x2)/2;
    ym = (y1+y2)/2;
    xr = abs(x2-x1)/2;
    yr = abs(y2-y1)/2;
    if (xr > 0) r = yr/xr;
    else r = 0;
    a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
    a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
    if (a2<a1) a2 += 360;
    draw_primitive_begin(pr_linestrip);
    sx = xm+lengthdir_x(xr,a1);
    sy = ym+lengthdir_y(yr,a1);
    draw_vertex(sx,sy);
    for (a=res*(a1 div res + 1); a<a2; a+=res) {
        sx = xm+lengthdir_x(xr,a);
        sy = ym+lengthdir_y(yr,a);
        draw_vertex(sx,sy);
    }
    sx = xm+lengthdir_x(xr,a2);
    sy = ym+lengthdir_y(yr,a2);
    draw_vertex(sx,sy);
    draw_primitive_end();
    return 0;
}

function is_targeted(){
	var bullets = array_length(bullets_for);
	under_fire = false;
	for (var i=bullets-1;i>-1;i--){
		var _bullet = bullets_for[i];
		if (!instance_exists(_bullet)){
			array_delete(bullets_for, i, 1);
		} else {
			under_fire = true;
			break;
		}
	}
}

function ship_shoot_weapons(){
    for (var i=0;i<array_length(weapons);i++){
        var _wep = weapons[i];
        _wep.find_target();
        _wep.fire();

    }
}

function fire_ship_weapon(wep_id){
	draw_set_alpha(1);
	draw_set_color(c_red); 
	var wep = weapon[wep_id];
	var facing=weapon_facing[wep_id],ammo=weapon_ammo[wep_id],range=weapon_range[wep_id];
	var dam=weapon_dam[wep_id];

    //weapon[wep_id]=0;weapon_ammo[wep_id]=0;weapon_range[wep_id]=0;
    facing = weapon_facing[wep_id];
    var ok = false;
    if (cooldown[wep_id]<=0 && weapon[wep_id]!="" && weapon_ammo[wep_id]>0) then ok=1;
     if (!ok) {
     	return 0;
     }
     front = true;
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
    target_distance=point_distance(x,y,targe.x,targe.y);

    if (facing="right") and (point_direction(x,y,target_r.x,target_r.y)<337) and (point_direction(x,y,target_r.x,target_r.y)>203) then ok=2;
    if (facing="left") and (point_direction(x,y,target_r.x,target_r.y)>22) and (point_direction(x,y,target_r.x,target_r.y)<157) then ok=2;
    
    /*var re_deh;re_deh=relative_direction(direction,target.direction);
    if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
    */
        
    
    
    if (ok=2) and (target_distance<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
        if (ammo>0) and (ammo<900) then ammo-=1;
        weapon_ammo[wep_id]=ammo;
        cooldown[wep_id]=weapon_cooldown[wep_id];
        wep=weapon[wep_id];
        dam=weapon_dam[wep_id];
        
        create_ship_projectile(wep_id);
    }
}

function ship_combat_cleanup(){
    try {
        var _player_battle_fleet, yeehaw2, tstar;
        _player_battle_fleet=0;yeehaw2=0;tstar=0;
        
        if (player_started=1){
            _player_battle_fleet=pla_fleet;
            yeehaw2=battle_system;
        }
        
        if (player_started=0) and (instance_exists(obj_turn_end)){
            _player_battle_fleet=obj_turn_end.battle[obj_turn_end.current_battle].player_object;
        }
        
        
        if (instance_number(obj_en_ship)>0){
            scr_recent("fleet_defeat",star_name,(capital_lost*6)+(frigate_lost*2)+escort_lost);
        }
        if (instance_number(obj_en_ship)<=0){
            with(obj_p_ship){
                var _ship = fetch_ship(ship_id);
                ship_data.hp = hp;
                ship_data.weapons = weapons;
                if (hp<=0){
                    scr_recent("ship_destroyed",_ship.name,ship_id);
                }
            }
        }
        
        if (instance_exists(_player_battle_fleet)){
            with (_player_battle_fleet){
                scr_ini_ship_cleanup();

                if (player_fleet_ship_count() == 0){
                    instance_destroy();    
                }        
            }
        }
        
        var op,ii,killer,killer_tg;op=0;killer=0;killer_tg=0;ii=-50;
        
        
        if (!player_started && instance_exists(obj_turn_end)){
            with(obj_star){
                if (name!=obj_turn_end.battle_location[obj_turn_end.current_battle]){
                    x-=10000;
                    y-=10000;
                }
            }
        } else {
            with(obj_star){
                if (id!=obj_fleet.battle_system){
                    x-=10000;y-=10000;
                }
            }
        }
        ii=instance_nearest(room_width,room_height,obj_star);
        obj_controller.temp[1070]=ii.id;
        
        with(obj_star){
            if (x<-5000) and (y<-5000){x+=10000;y+=10000;
            }
        }
        
        
        
        
        
        
        
        op=0;var ofleet;ofleet=0;
        for (var op=0;op<array_length(enemy);op++){
            op+=1;
            if (enemy[op]!=0) and (enemy[op]!=4){ofleet=0;
                obj_controller.temp[1071]=enemy[op];
                
                // show_message("Hiding all but the fleet owned by "+string(obj_controller.temp[1071]));
                
                with(obj_en_fleet){
                    if (owner!=obj_controller.temp[1071]) or (orbiting!=obj_controller.temp[1070]){
                        x-=10000;y-=10000;
                    }
                }
                
                ofleet=instance_nearest(room_width/2,room_height/2,obj_en_fleet);
                // show_messsage("Fleet: "+string(ofleet.capital_number)+"/"+string(ofleet.frigate_number)+"/"+string(ofleet.escort_number)+", lost "+string(en_capital_lost[op])+"/"+string(en_frigate_lost[op])+"/"+string(en_escort_lost[op]));
                
                repeat(50){
                    if (!instance_exists(ofleet)){ofleet=instance_nearest(room_width/2,room_height/2,obj_en_fleet);}
                    if (instance_exists(ofleet)){
                        if (ofleet.trade_goods="player_hold") then ofleet.trade_goods="";
                        // show_message("ofleet x:"+string(ofleet.x)+", ofleet y:"+string(ofleet.y)+", ofleet owner: "+string(ofleet.owner)+" wants "+string(enemy[op]));
                        if (ofleet.x>-7000) and (ofleet.y>-7000) and (ofleet.owner=enemy[op]){
                            if (en_capital_lost[op]+en_frigate_lost[op]+en_escort_lost[op]>=ofleet.capital_number+ofleet.frigate_number+ofleet.escort_number){
                                en_capital_lost[op]-=ofleet.capital_number;en_frigate_lost[op]-=ofleet.frigate_number;en_escort_lost[op]-=ofleet.escort_number;
                                // show_message("Fleet baleeted");
                                with(ofleet){instance_destroy();}
                            }
                            if (en_capital_lost[op]+en_frigate_lost[op]+en_escort_lost[op]>0) and (instance_exists(ofleet)){
                                // show_message("Fleet: "+string(ofleet.capital_number)+"/"+string(ofleet.frigate_number)+"/"+string(ofleet.escort_number)+", lost "+string(en_capital_lost[op])+"/"+string(en_frigate_lost[op])+"/"+string(en_escort_lost[op]));
                                if (en_capital_lost[op]>0) and (ofleet.capital_number>0){en_capital_lost[op]-=1;ofleet.capital_number-=1;}
                                if (en_frigate_lost[op]>0) and (ofleet.frigate_number>0){en_frigate_lost[op]-=1;ofleet.frigate_number-=1;}
                                if (en_escort_lost[op]>0) and (ofleet.escort_number>0){en_escort_lost[op]-=1;ofleet.escort_number-=1;}
                                if (ofleet.capital_number+ofleet.frigate_number+ofleet.escort_number<=0) then with(ofleet){instance_destroy();}
                            }
                        }
                    }
                }
                
                with(obj_en_fleet){if (x<-7000) and (y<-7000){x+=10000;y+=10000;}}
                
                // if (instance_exists(ofleet)){show_message("Fleet: "+string(ofleet.capital_number)+"/"+string(ofleet.frigate_number)+"/"+string(ofleet.escort_number));}
                // if (!instance_exists(ofleet)){show_message("FlEET WAS DELETED");}
            }
            
            // show_message("End ship removing");
            
            if (enemy[op]=4) and (enemy_status[op]<0){
                obj_controller.temp[1071]=enemy[op];
                with(obj_en_fleet){if (owner!=obj_controller.temp[1071]) or (orbiting!=obj_controller.temp[1070]){x-=10000;y-=10000;}}
                ofleet=instance_nearest(room_width/2,room_height/2,obj_en_fleet);
                killer=1;
                obj_controller.temp[1071]=enemy[op];
                killer_tg=ofleet.inquisitor;
                with(ofleet){instance_destroy();}
                with(obj_en_fleet){{x+=10000;y+=10000;}}
            }
        }
        
        
        
        
        
        obj_controller.cooldown=20;
        
        if (killer>0){
            scr_loyalty("Inquisitor Killer","+");
            if (obj_controller.loyalty>=85) then obj_controller.last_world_inspection-=44;
            if (obj_controller.loyalty>=70) and (obj_controller.loyalty<85) then obj_controller.last_world_inspection-=32;
            if (obj_controller.loyalty>=50) and (obj_controller.loyalty<70) then obj_controller.last_world_inspection-=20;
            if (obj_controller.loyalty<50) then scr_loyalty("Inquisitor Killer","+");
            
            var msg="",msg2="",i=0;
            if (killer_tg > 0){
                var inquis_name = obj_controller.inquisitor[killer_tg];
                msg+=$"Inquisitor {inquis_name} has been killed!";
                msg2=$"Inquisitor {inquis_name}";
            }
            if (obj_controller.inquisitor_type[killer_tg]=="Ordo Hereticus") then scr_loyalty("Inquisitor Killer","+");
            
            array_delete(obj_controller.inquisitor_gender, killer_tg,1);
            array_delete(obj_controller.inquisitor_type, killer_tg,1);
            array_delete(obj_controller.inquisitor, killer_tg,1);
        
            array_push(obj_controller.inquisitor_gender, choose(0,0,0,1,1,1,1));
            array_push(obj_controller.inquisitor_type, choose("Ordo Malleus","Ordo Xenos","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus"));
            array_push(obj_controller.inquisitor, global.name_generator.generate_imperial_name(obj_controller.inquisitor_gender[i]));
            
            instance_activate_object(obj_turn_end);
            
            if (instance_exists(obj_turn_end)) then scr_alert("red","inqis",string(msg),ii.x+16,ii.y-24);
            if (!instance_exists(obj_turn_end)) and (obj_controller.faction_status[eFACTION.Inquisition]!="War"){
                var pip;pip=instance_create(0,0,obj_popup);
                pip.title="Inquisitor Killed";
                pip.text=msg;
                pip.image="inquisition";
                pip.cooldown=20;
                
                if (obj_controller.known[eFACTION.Inquisition]<3){
                    pip.title="EXCOMMUNICATUS TRAITORUS";
                    pip.text=$"The Inquisition has noticed your uncalled murder of {msg2} and declared your chapter Excommunicatus Traitorus.";
                    obj_controller.alarm[8]=1;
                }
            }
            
            
            // if (obj_controller.known[eFACTION.Inquisition]<3) then with(obj_popup){instance_destroy();}
            
            
            
            // excommunicatus traitorus
        }
        
        instance_activate_all();
        
        if (instance_exists(obj_p_assra)){
            obj_p_assra.alarm[0]=1;
        }
        alarm[4]=2;
        
        
        
    } catch(_exception) {
        handle_exception(_exception);
    }    
}

