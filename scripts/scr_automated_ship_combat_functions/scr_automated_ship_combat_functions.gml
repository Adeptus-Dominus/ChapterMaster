function point_on_circle(start_x, start_y, radius, angle){
    var _angle_radians = degtorad(angle);
    var _final_x = start_x + lengthdir_x(radius, angle);
    var _final_y = start_y + lengthdir_y(radius, angle);
    return [_final_x, _final_y];
}

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
                _enemy_points_left += size;
            } else if (_rel_direct < 90) {
                _enemy_points_right += size;
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
            if (point_distance(x, y, target.x, target.y) > main_weapon.range && abs(_rel_direction) <= main_weapon.firing_arc){
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
    var _sx = xm+lengthdir_x(weapon.range, avoid_angle);
    var _sy = ym+lengthdir_y(weapon.range, avoid_angle);
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
     if (y>=target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    if (y<target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    if (y>target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
    if (y<target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);     
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
    dist=point_distance(x,y,targe.x,targe.y);

    if (facing="right") and (point_direction(x,y,target_r.x,target_r.y)<337) and (point_direction(x,y,target_r.x,target_r.y)>203) then ok=2;
    if (facing="left") and (point_direction(x,y,target_r.x,target_r.y)>22) and (point_direction(x,y,target_r.x,target_r.y)<157) then ok=2;
    
    /*var re_deh;re_deh=relative_direction(direction,target.direction);
    if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
    */
        
    
    
    if (ok=2) and (dist<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
        if (ammo>0) and (ammo<900) then ammo-=1;
        weapon_ammo[wep_id]=ammo;
        cooldown[wep_id]=weapon_cooldown[wep_id];
        wep=weapon[wep_id];
        dam=weapon_dam[wep_id];
        
        create_ship_projectile(wep_id);
    }
}



